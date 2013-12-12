//
//  Session.m
//  PicFrame
//
//  Created by Vijaya kumar reddy Doddavala on 2/28/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "Session.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface Session ()
{
    Photo *photoFromFrame;
    //Photo *photoBeingSelected;
    //Photo *photoBeingEdited;
    //UIImage *imageBeingSelected;
    
    /* swaping the images from one photo to another photo */
    Photo *swapFrom;
    Photo *swapTo;
    int readyToPlayPlayerCount;
}

-(void)applyScaleAndOffsetForTheFrame;
-(void)unregisterForNotifications;
-(void)setPhotoWidth:(float)photoWidth;
@end

static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
@implementation Session

@synthesize frame;
//@synthesize imageBeingEdited;
@synthesize imageFromApp;
@synthesize videoSelected;
@synthesize players;
@synthesize playerItems;

+(UIImage *)iconImageFromSession:(int)sessionId
{
    NSArray  *paths        = nil;
    NSString *docDirectory = nil;
    NSString *path         = nil;
    UIImage  *img          = nil;
    NSFileManager *filemgr = nil;
    
    /* Check if the current session is valid or not */
    if(0 == sessionId)
    {
        NSLog(@"iconImageFromSession: current session is NULL");
        return nil;
    }
    
    /* now get the image from the current session */
    paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    docDirectory = [paths objectAtIndex:0];
    filemgr      = [NSFileManager defaultManager];
    NSString *ic = [NSString stringWithFormat:@"%d_icon.png",sessionId];
    path         = [docDirectory stringByAppendingPathComponent:ic];
    
    /* check if the file really exist */
    if([filemgr fileExistsAtPath:path])
    {
        img      = [UIImage imageWithContentsOfFile:path];
    }
    else
    {
        //[sess saveTheIcon];
        //return [self iconImageFromSession:sess];
    }
    
    return img;
}

+(NSDate*)createdDateForSession:(int)sessionId
{
    NSArray  *paths        = nil;
    NSString *docDirectory = nil;
    NSString *path         = nil;
    NSFileManager *filemgr = nil;
    NSDate *creationDate   = nil;
    
    /* Check if the current session is valid or not */
    if(0 == sessionId)
    {
        NSLog(@"iconImageFromSession: current session is NULL");
        return nil;
    }
    
    /* now get the image from the current session */
    paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    docDirectory = [paths objectAtIndex:0];
    filemgr      = [NSFileManager defaultManager];
    NSString *ic = [NSString stringWithFormat:@"%d_icon.png",sessionId];
    path         = [docDirectory stringByAppendingPathComponent:ic];
    
    /* check if the file really exist */
    if(![filemgr fileExistsAtPath:path])
    {
        return nil;
    }
    
    NSDictionary *properties = [filemgr attributesOfItemAtPath:path error:nil];
    if(properties)
    {
        creationDate = [properties objectForKey:NSFileCreationDate];
        NSLog(@"Creation Date %@",[creationDate description]);
    }
    
    return creationDate;
}

+(void)deleteSessionImagesFromHddOfId:(int)sessId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *filename     = nil;
    NSString *path         = nil;
    int       index        = 0;
    
    for(index = 0; index < MAX_PHOTOS_SUPPORTED; index++)
    {
        filename = [NSString stringWithFormat:@"%d_%d.png",sessId,index];
        path     = [docDirectory stringByAppendingPathComponent:filename];
        
        if(YES == [filemgr fileExistsAtPath:path])
        {
            [filemgr removeItemAtPath:path error:nil];
        }
    }
    
    return;
}

+(void)deleteSessionImageFromHdOfId:(int)sessId atIndex:(int)index
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *filename     = nil;
    NSString *path         = nil;
    
    filename = [NSString stringWithFormat:@"%d_%d.png",sessId,index];
    path     = [docDirectory stringByAppendingPathComponent:filename];
    
    if(YES == [filemgr fileExistsAtPath:path])
    {
        [filemgr removeItemAtPath:path error:nil];
    }
}

+(void)deleteSessionWithId:(int)sessId
{
    [Session deleteSessionImagesFromHddOfId:sessId];
    [SessionDB deleteSessionDimensionsOfId:sessId];
    [SessionDB deleteSessionOfId:sessId];
    
    return;
}

-(eShape)getShapeOfthePhotoInSession:(int)sessionId photonum:(int)index
{
    // SELECT name FROM sqlite_master WHERE type='table' AND name='table_name'
    
    /* Open Database */
    NSString *databaseName = PICFARME_DATABASE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    BOOL     bRecordFound = NO;
    eShape   shp = SHAPE_NOSHAPE;
    BOOL     bNewRecordCreated = NO;
    
    /* First make sure that database is copied to filesystem */
    //[DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return SHAPE_NOSHAPE;
    }
    
    FMResultSet *result  = nil;
    
    /* First get the count of photos */
    result = [db executeQuery:@"select shape from shapes where sessionId = ? and photoIndex = ?",[NSNumber numberWithInt:sessionId],[NSNumber numberWithInt:index]];
    if(nil == result)
    {
        NSLog(@"getThePhotoInfoForFrameNumber:Could not get photo count");
        [db close];
        return SHAPE_NOSHAPE;
    }
    
    while([result next])
    {
        bRecordFound = YES;
        shp = [result intForColumn:@"shape"];
    }
    
    if(NO == bRecordFound)
    {
        bNewRecordCreated = YES;
        [db beginTransaction];
        
        [db executeUpdate:@"insert into shapes (sessionId, photoIndex, shape) values (?,?,?)",[NSNumber numberWithInt:sessionId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:SHAPE_NOSHAPE]];
        
        [db commit];
    }
    
    [result close];
    [db close];
    
    //NSLog(@"getShapeOfthePhotoInSession:(session %d photo %d) record(%@) shape(%d) newrecord(%@)",sessionId,index,(bRecordFound == YES)?@"found":@"not found",shp,(bNewRecordCreated == YES)?@"created":@"not created");
    
    return shp;
}

-(void)updateDbWithShape:(eShape)shape forSession:(int)session andPhoto:(int)photo
{
    NSString *databaseName = PICFARME_DATABASE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    
    /* First make sure that database is copied to filesystem */
    //[DBUtilities checkAndCreateDatabase];
    NSLog(@"updateDbWithShape:(%d) session(%d) photo(%d)",shape,session,photo);
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return;
    }
    
    [db beginTransaction];
    
    [db executeUpdate:@"update shapes set shape = ? where sessionId = ? and photoIndex = ? ",[NSNumber numberWithInt:shape],[NSNumber numberWithInt:session],[NSNumber numberWithInt:photo]];
    
    [db commit];
    [db close];
}

-(Frame*)frame
{
    return _frame;
}

-(void)dealloc
{
    if(nil != _frame)
    {
        [_frame release];
        _frame = nil;
    }
    
    [self unregisterForNotifications];
    
    [super dealloc];
}

#pragma mark session dimensions table operations
-(BOOL)deletePhotosAndAdjustors
{
    return [SessionDB deleteSessionDimensionsOfId:iSessionId];
}

-(BOOL)addPhotosAndAdjustorsFromFrame:(Frame*)frm
{
    NSLog(@"addPhotosAndAdjustorsFromFrame");
    int index = 0;
    
#if 0
    /* open the database */
    FMDatabase* db = [DBUtilities openDataBase];
    if (![db open])
    {
        [db release];
        NSLog(@"getThePhotoInfoForFrameNumber:Could not open db.");
        return 0;
    }
#else
    NSString *databaseName = PICFARME_DATABASE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    
    /* First make sure that database is copied to filesystem */
    [DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return 0;
    }
#endif
    
    /* begin transaction */
    [db beginTransaction];
#if DB_TRACE_EXECUTION
    [db setTraceExecution:YES];
#endif
    
    for(index = 0; index < frm.photoCount; index++)
    {
        Photo *pht = [frm getPhotoAtIndex:index];
        if(nil == pht)
        {
            NSLog(@"addPhotosAndAdjustorsFromFrame:Something is seriusly wrong,photo not found");
            continue;
        }
        
        [db executeUpdate:@"insert into sessiondimensions (sessionId, photoIndex, type, photo_x, photo_y, photo_width, photo_height) values (?,?,?,?,?,?,?)",[NSNumber numberWithInt:iSessionId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:0],[NSNumber numberWithFloat:pht.frame.origin.x],[NSNumber numberWithFloat:pht.frame.origin.y],[NSNumber numberWithFloat:pht.frame.size.width],[NSNumber numberWithFloat:pht.frame.size.height]];
        //NSLog(@"Photo (%d): (%f,%f,%f,%f)",index,pht.frame.origin.x,pht.frame.origin.y,pht.frame.size.width,pht.frame.size.height);
        [db executeUpdate:@"insert into shapes (sessionId, photoIndex, shape) values (?,?,?)",[NSNumber numberWithInt:iSessionId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:SHAPE_NOSHAPE]];
    }
    
    for(index = 0; index < frm.adjustorCount; index++)
    {
        Adjustor *adj = [frm getAdjustorAtIndex:index];
        if(nil == adj)
        {
            NSLog(@"addPhotosAndAdjustorsFromFrame:Something is seriusly wrong,adjustor not found");
            continue;
        }
        
        [db executeUpdate:@"insert into sessiondimensions (sessionId, photoIndex, type, photo_x, photo_y, photo_width, photo_height) values (?,?,?,?,?,?,?)",[NSNumber numberWithInt:iSessionId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:1],[NSNumber numberWithFloat:adj.frame.origin.x],[NSNumber numberWithFloat:adj.frame.origin.y],[NSNumber numberWithFloat:adj.frame.size.width],[NSNumber numberWithFloat:adj.frame.size.height]];
    }
    
    /* commit the update */
    [db commit];
    
    /* we are done with delete, so close the databse */
    [db close];
    
    return TRUE;
}

-(BOOL)updatePhotosAndAdjustorsFromFrame:(Frame*)frm
{
    NSLog(@"updatePhotosAndAdjustorsFromFrame");
    int index = 0;
    
#if 0
    /* open the database */
    FMDatabase* db = [DBUtilities openDataBase];
    if (![db open])
    {
        [db release];
        NSLog(@"getThePhotoInfoForFrameNumber:Could not open db.");
        return 0;
    }
#else
    NSString *databaseName = PICFARME_DATABASE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    
    /* First make sure that database is copied to filesystem */
    [DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return 0;
    }
#endif
    
    /* begin transaction */
    [db beginTransaction];
#if DB_TRACE_EXECUTION
    [db setTraceExecution:YES];
#endif
    
    for(index = 0; index < frm.photoCount; index++)
    {
        Photo *pht = [frm getPhotoAtIndex:index];
        if(nil == pht)
        {
            NSLog(@"addPhotosAndAdjustorsFromFrame:Something is seriusly wrong,photo not found");
            continue;
        }
        
        [db executeUpdate:@"update sessiondimensions set photo_x = ?, photo_y = ?, photo_width = ?, photo_height = ? where sessionId = ? and photoIndex = ? and type = ?",[NSNumber numberWithFloat:pht.frame.origin.x],[NSNumber numberWithFloat:pht.frame.origin.y],[NSNumber numberWithFloat:pht.frame.size.width],[NSNumber numberWithFloat:pht.frame.size.height],[NSNumber numberWithInt:iSessionId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:0]];
#if 0
        [db executeUpdate:@"insert into sessiondimensions (sessionId, photoIndex, type, photo_x, photo_y, photo_width, photo_height) values (?,?,?,?,?,?,?)",[NSNumber numberWithInt:iSessionId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:0],[NSNumber numberWithFloat:pht.frame.origin.x],[NSNumber numberWithFloat:pht.frame.origin.y],[NSNumber numberWithFloat:pht.frame.size.width],[NSNumber numberWithFloat:pht.frame.size.height]];
#endif
        //NSLog(@"Pht (%d): (%f,%f,%f,%f)",index,pht.frame.origin.x,pht.frame.origin.y,pht.frame.size.width,pht.frame.size.height);
    }
    
    for(index = 0; index < frm.adjustorCount; index++)
    {
        Adjustor *adj = [frm getAdjustorAtIndex:index];
        if(nil == adj)
        {
            NSLog(@"addPhotosAndAdjustorsFromFrame:Something is seriusly wrong,adjustor not found");
            continue;
        }
        
        [db executeUpdate:@"update sessiondimensions set photo_x = ?, photo_y = ?, photo_width = ?, photo_height = ? where sessionId = ? and photoIndex = ? and type = ?",[NSNumber numberWithFloat:adj.frame.origin.x],[NSNumber numberWithFloat:adj.frame.origin.y],[NSNumber numberWithFloat:adj.frame.size.width],[NSNumber numberWithFloat:adj.frame.size.height],[NSNumber numberWithInt:iSessionId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:1]];
#if 0
        [db executeUpdate:@"insert into sessiondimensions (sessionId, photoIndex, type, photo_x, photo_y, photo_width, photo_height) values (?,?,?,?,?,?,?)",[NSNumber numberWithInt:iSessionId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:1],[NSNumber numberWithFloat:adj.frame.origin.x],[NSNumber numberWithFloat:adj.frame.origin.y],[NSNumber numberWithFloat:adj.frame.size.width],[NSNumber numberWithFloat:adj.frame.size.height]];
#endif
    }
    
    /* commit the update */
    [db commit];
    
    /* we are done with delete, so close the databse */
    [db close];
    
    return TRUE;
}

-(UIImage*)getImageAtIndex:(int)index
{
    NSArray  *paths        = nil;
    NSString *docDirectory = nil;
    NSString *path         = nil;
    UIImage  *img          = nil;
    NSFileManager *filemgr = nil;
    NSString *filename     = [NSString stringWithFormat:@"%d_%d.png",iSessionId,index];
    
    /* now get the image from the current session */
    paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    docDirectory = [paths objectAtIndex:0];
    filemgr      = [NSFileManager defaultManager];
    path         = [docDirectory stringByAppendingPathComponent:filename];
    
    /* check if the file really exist */
    if([filemgr fileExistsAtPath:path])
    {
        img      = [UIImage imageWithContentsOfFile:path];
    }
    
    return img;
}

-(void)saveImage:(UIImage*)img atIndex:(int)index
{
    if(nil == img)
    {
        NSLog(@"saveImage:Invalid image------");
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    //NSData *data           = UIImagePNGRepresentation(img);
    NSData *data           = UIImageJPEGRepresentation(img, 1.0);
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *filename     = [NSString stringWithFormat:@"%d_%d.png",iSessionId,index];
    NSString *path         = [docDirectory stringByAppendingPathComponent:filename];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    
    if(NO == [filemgr createFileAtPath:path contents:data attributes:attributes])
    {
        NSLog(@"saveImage:Failed to save the file");
    }
    
    return;
}

-(void)enterNoTouchMode
{
    int index = 0;
    
    for(index = 0; index < self.frame.photoCount; index++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            pht.noTouchMode = YES;
        }
    }
}

-(void)exitNoTouchMode
{
    int index = 0;
    
    for(index = 0; index < self.frame.photoCount; index++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            pht.view.imageView.image = [self getImageAtIndex:index];
            pht.noTouchMode = NO;
        }
    }
}

-(void)restoreFrameImages
{
    int index = 0;
    
    for(index = 0; index < self.frame.photoCount; index++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            pht.view.imageView.image = [self getImageAtIndex:index];
        }
    }
}

-(NSString*)pathToIntermediateVideo
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * videoName = [NSString stringWithFormat:@"intercurrent_%d.mp4",iSessionId];
    NSString *videoPath  = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    return videoPath;
}

-(NSString*)pathToCurrentVideo
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * videoName = [NSString stringWithFormat:@"current_%d.mp4",iSessionId];
    NSString *videoPath  = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    return videoPath;
}

-(NSString*)pathToCurrentAudioMix
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * videoName = [NSString stringWithFormat:@"tempaudio_%d.m4a",iSessionId];
    NSString *videoPath  = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    
    return videoPath;
}
-(NSString *)pathToAudioOfRespectedVideo:(int)videoIndex
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * videoName = [NSString stringWithFormat:@"tempaudio_%d_%d.m4a",iSessionId,videoIndex];
    NSString *videoPath  = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    
    return videoPath;
}
-(NSString*)pathToMusciSelectedFromLibrary
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * audioName = [NSString stringWithFormat:@"libraryaudio_%d.m4a",iSessionId];
    NSString *audioPath  = [documentsDirectory stringByAppendingPathComponent:audioName];
    
    return audioPath;
}

-(void)deleteCurrentAudioMix
{
    NSString *currentMix = [self pathToCurrentAudioMix];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:currentMix])
    {
        
        [[NSFileManager defaultManager]removeItemAtPath:currentMix error:nil];
    }
}

-(void)deleteVideoFramesForPhotoAtIndex:(int)photoIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *docPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"video%d",photoIndex]];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:docPath])
    {
        NSError *error;
        BOOL folderDeleted = [[NSFileManager defaultManager]removeItemAtPath:docPath error:&error];
        NSAssert(YES == folderDeleted, @"deleteVideoFramesForPhotoAtIndex: Failed to delete %@, error %@",docPath,error.localizedDescription);
    }

    
    return;
}
-(void)deleteVideoAtPhototIndex:(int)photoIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString * videoName = [NSString stringWithFormat:@"student_%d_%d.mp4",iSessionId,photoFromFrame.photoNumber];
    NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    NSLog(@"Trying to delete video at path :%@", videoPath);
    
    if([[NSFileManager defaultManager]fileExistsAtPath:videoPath])
    {
        NSError *error;
        BOOL folderDeleted = [[NSFileManager defaultManager]removeItemAtPath:videoPath error:&error];
        NSAssert(YES == folderDeleted, @"deleteVideoFramesForPhotoAtIndex: Failed to delete %@, error %@",videoPath,error.localizedDescription);
        NSLog(@" FINISHED");
    }
    
    
    return;
}
-(void)deleteImageOfFrame:(int)photoIndex frame:(int)frameIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"video%d",photoIndex]];
     NSString *imgPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.jpg",photoIndex,frameIndex]];
    NSLog(@" frame image path %@", imgPath);
   
    if ([[NSFileManager defaultManager]fileExistsAtPath:imgPath]) {
        
        NSError *error;
        BOOL imageDeleted = [[NSFileManager defaultManager]removeItemAtPath:imgPath error:&error];
        NSLog(@" Image deleted at index %d_%d  successful =  %d",photoIndex,frameIndex,imageDeleted);
        
    }
    
  
}
-(NSString*)pathForImageAtIndex:(int)index inPhoto:(int)photoIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"video%d",photoIndex]];
    if(NO == [[NSFileManager defaultManager]fileExistsAtPath:folderPath])
    {
        BOOL folderCreated = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                                       withIntermediateDirectories:NO
                                                                        attributes:nil
                                                                             error:nil];
        NSAssert(YES == folderCreated, @"pathForImageAtIndex: Failed To create folder %@",folderPath);
    }
   
    NSString *imgPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.jpg",photoIndex,index]];
   
    return imgPath;
}

-(UIImage*)getVideoFrameAtIndex:(int)frameIndex forPhoto:(int)photoIndex
{
    NSString *imgPath = [self pathForImageAtIndex:frameIndex inPhoto:photoIndex];
    if(NO == [[NSFileManager defaultManager]fileExistsAtPath:[self pathForImageAtIndex:frameIndex inPhoto:photoIndex]])
    {
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:imgPath];
}

-(NSString*)getVideoInfoKeyForPhotoAtIndex:(int)index
{
    return [NSString stringWithFormat:@"video%d_%d.png",iSessionId,index];
}

-(int)getFrameCountForPhotoAtIndex:(int)index
{
    NSString *key     = [self getVideoInfoKeyForPhotoAtIndex:index];
    NSData *myData    = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSDictionary *videoInfo = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    if (key == nil)
    {
        return 0;
    }
    if(nil == videoInfo)
    {
        return 0;
    }
    
    return [[videoInfo objectForKey:@"FrameCount"]integerValue];
}

-(int)getFrameCountOfFrame:(Frame*)frame
{
    int photoIndex = 0;
    int maxFrameCount = 0;
    int frameCount = 0;
    
    for(photoIndex = 0; photoIndex < self.frame.photoCount; photoIndex++)
    {
        frameCount = [self getFrameCountForPhotoAtIndex:photoIndex];
        if(frameCount > maxFrameCount)
        {
            maxFrameCount = frameCount;
        }
    }
    
    NSLog(@"getFrameCountOfFrame: %d",maxFrameCount);
    
    return maxFrameCount;
}

-(NSURL*)getVideoUrlForPhotoAtIndex:(int)index
{
    NSString *key     = [self getVideoInfoKeyForPhotoAtIndex:index];
    NSData *myData    = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if(nil == myData)
    {
        NSLog(@"getVideoUrlForPhotoAtIndex: video info for photo %d is nil",index);
        return nil;
    }
    
    NSDictionary *videoInfo = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    //NSLog(@"VideoInfo %@",videoInfo);
    //NSMutableDictionary *videoInfo = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    //NSString *path = [videoInfo objectForKey:@"videoPath"];
    //NSURL *url = [NSURL fileURLWithPath:path];
    NSURL *url = [videoInfo objectForKey:@"videoPath"];
    
    NSLog(@"getting %@ url as key %@",url.path,key);
    return url;
}

-(double)getMaxVideoDuration:(BOOL)isSequentialPlay
{
    double duration = 0.0f;
    
    for(int index = 0; index < self.frame.photoCount; index++)
    {
        double temDuration = [self getVideoDurationForPhotoAtIndex:index];

        if (isSequentialPlay) {
            
        duration = duration+temDuration;
        }else
        {
            if(temDuration > duration)
            {
                duration = temDuration;
            }
        }
    }
    
    return duration;
}

-(double)getVideoDurationForPhotoAtIndex:(int)index
{
    NSString *key     = [self getVideoInfoKeyForPhotoAtIndex:index];
    NSData *myData    = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if(nil == myData)
    {
        NSLog(@"getVideoUrlForPhotoAtIndex: video info for photo %d is nil",index);
        return 0.0;
    }
    
    NSDictionary *videoInfo = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    double duration = [[videoInfo objectForKey:@"Duration"]floatValue];
    
    NSLog(@"Duration for photo %d is %f ",index,duration);
    
    return duration;
}

/*
 -(void)saveVideo:(NSURL*)videopath atIndex:(int)index
 {
 NSString *key     = [NSString stringWithFormat:@"video%d_%d.png",iSessionId,index];
 NSString *path    = videopath.path;
 NSLog(@"Saving %@ url as key %@",videopath,key);
 [[NSUserDefaults standardUserDefaults]setObject:path forKey:key];
 }
 */
-(void)saveVideoInfo:(NSMutableDictionary*)videoInfo atIndex:(int)index
{
    /* generate key for storing video info */
    NSString *key     = [self getVideoInfoKeyForPhotoAtIndex:index];
    NSLog(@"Saving VideoInfo %@",videoInfo);
    if(nil == videoInfo)
    {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:key];
        return;
    }
    
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:videoInfo];
    /* save the videoinfo */
    [[NSUserDefaults standardUserDefaults]setObject:myData forKey:key];
    
    return;
}

-(eFrameResourceType)getFrameResourceTypeAtIndex:(int)index
{
    NSString *key     = [NSString stringWithFormat:@"frt%d_%d.png",iSessionId,index];
    
    return (eFrameResourceType)[[[NSUserDefaults standardUserDefaults]objectForKey:key]intValue];
}

-(void)saveFrameResourceType:(eFrameResourceType)eType atIndex:(int)index
{
    NSString *key     = [NSString stringWithFormat:@"frt%d_%d.png",iSessionId,index];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:eType] forKey:key];
}

-(void)swapImageAtIndex:(int)from with:(int)to
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *srcFileName  = nil;
    NSString *dstFileName  = nil;
    NSString *src          = nil;
    NSString *dst          = nil;
    
    [self handleVideoFrameSettingsUpdate];
    
    /* first move file at from index to temp */
    srcFileName     = [NSString stringWithFormat:@"%d_%d.png",iSessionId,from];
    dstFileName     = [NSString stringWithFormat:@"%d_%d_temp.png",iSessionId,from];
    src             = [docDirectory stringByAppendingPathComponent:srcFileName];
    dst             = [docDirectory stringByAppendingPathComponent:dstFileName];
    if([filemgr fileExistsAtPath:src] == YES)
    {
        NSLog(@"Swap: %@ -> %@",srcFileName,dstFileName);
        [filemgr moveItemAtPath:src toPath:dst error:nil];
    }
    
    /* move item at to index to from */
    srcFileName     = [NSString stringWithFormat:@"%d_%d.png",iSessionId,to];
    dstFileName     = [NSString stringWithFormat:@"%d_%d.png",iSessionId,from];
    src             = [docDirectory stringByAppendingPathComponent:srcFileName];
    dst             = [docDirectory stringByAppendingPathComponent:dstFileName];
    if([filemgr fileExistsAtPath:src] == YES)
    {
        NSLog(@"Swap: %@ -> %@",srcFileName,dstFileName);
        [filemgr moveItemAtPath:src toPath:dst error:nil];
    }
    
    /* move item at temp index to to */
    srcFileName     = [NSString stringWithFormat:@"%d_%d_temp.png",iSessionId,from];
    dstFileName     = [NSString stringWithFormat:@"%d_%d.png",iSessionId,to];
    src             = [docDirectory stringByAppendingPathComponent:srcFileName];
    dst             = [docDirectory stringByAppendingPathComponent:dstFileName];
    if([filemgr fileExistsAtPath:src] == YES)
    {
        NSLog(@"Swap: %@ -> %@",srcFileName,dstFileName);
        [filemgr moveItemAtPath:src toPath:dst error:nil];
    }
}

-(void)updateTheSessionIcon
{
    NSArray  *paths        = nil;
    NSString *docDirectory = nil;
    NSString *path         = nil;
    UIImage  *img          = nil;
    NSFileManager *filemgr = nil;
    
    /* now get the image from the current session */
    paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    docDirectory = [paths objectAtIndex:0];
    filemgr      = [NSFileManager defaultManager];
    NSString *ic = [NSString stringWithFormat:@"%d_icon.png",iSessionId];
    path         = [docDirectory stringByAppendingPathComponent:ic];
    
    /* check if the file really exist */
    if([filemgr fileExistsAtPath:path])
    {
        [filemgr removeItemAtPath:path error:nil];
    }
    
    img = [_frame renderToImageOfScale:1.0];
    NSData *data = UIImagePNGRepresentation(img);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    
    if(NO == [filemgr createFileAtPath:path contents:data attributes:attributes])
    {
        NSLog(@"updateTheSessionIcon:Failed to save the icon");
    }
}

#pragma mark methods for view controller

-(void)saveAndSetTheResourceToPhoto:(NSTimer*)tmr
{
    NSURL *pathToVideo = nil;
    eFrameResourceType eType = FRAME_RESOURCE_TYPE_PHOTO;
    
    if(nil != tmr.userInfo)
    {
        eType = FRAME_RESOURCE_TYPE_VIDEO;
        pathToVideo = [tmr.userInfo objectForKey:@"videoPath"];
        NSAssert(nil != pathToVideo, @"saveAndSetTheResourceToPhoto: Userinfo doesn't contain videopath");
        [self saveVideoInfo:tmr.userInfo atIndex:photoFromFrame.photoNumber];
        NSLog(@"saveAndSetTheResourceToPhoto:Saving Video");
    }
    
#if IMAGE_SELECTION
    /* First generate the optimized image of the selected image */
    UIImage *optimizedImage = [Utility optimizedImage:self.imageFromApp];
    
    NSLog(@"Optimized image from (%f,%f) to (%f,%f)",self.imageFromApp.size.width,self.imageFromApp.size.height,optimizedImage.size.width,optimizedImage.size.height);
    
    /* Free the selected image image */
    [self.imageFromApp release];
    
    /* Make the optimized image as the selected image */
    self.imageFromApp = optimizedImage;
#endif
    /* save the image to HDD */
    [self saveImage:self.imageFromApp atIndex:photoFromFrame.photoNumber];
    
    /* save frame type */
    [self saveFrameResourceType:eType atIndex:photoFromFrame.photoNumber];
    
    /*  update the database */
    [SessionDB updateImageSizeInDBWith:self.imageFromApp.size atIndex:photoFromFrame.photoNumber forSession:iSessionId];
    //[SessionDB updateResourceSizeInDBWith:self.imageFromApp.size atIndex:photoFromFrame.photoNumber ofType:eType atPath:pathToVideo forSession:iSessionId];
    
    /* set the image to photo */
    photoFromFrame.image = self.imageFromApp;
    
    /* decrement the retain count */
    //[imageBeingSelected release];
    
    self.imageFromApp = nil;
    
    /* Update the Session Icon */
    [self updateTheSessionIcon];
    
    [Utility removeActivityIndicatorFrom:_frame.superview];
    
    return;
}
#if 1
-(void)imageSelectedForPhoto:(UIImage*)img
{
    // photoFromFrame.photoNumber = photoNumer;
    [self handleVideoFrameSettingsUpdate];
    
    self.imageFromApp = img;
    
    [self saveVideoInfo:nil atIndex:photoFromFrame.photoNumber];
    
    [self deleteVideoFramesForPhotoAtIndex:photoFromFrame.photoNumber];
    
    /* start the activity controller */
    [Utility addActivityIndicatotTo:_frame.superview withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    /* schedule the timer to start the HDD saving, DB updated and setting to photo */
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(saveAndSetTheResourceToPhoto:) userInfo:nil repeats:NO];
}
#endif
-(void)saveAndSetTheResourceForPhoto:(NSTimer*)timer
{
    Photo *pht = [timer.userInfo objectForKey:@"Photo"];
    UIImage *selectedImage = [timer.userInfo objectForKey:@"selectedImage"];
    
    NSURL *pathToVideo = nil;
    eFrameResourceType eType = FRAME_RESOURCE_TYPE_PHOTO;
    
    if(nil != timer.userInfo)
    {
        eType = FRAME_RESOURCE_TYPE_VIDEO;
        pathToVideo = [timer.userInfo objectForKey:@"videoPath"];
        if(nil != pathToVideo)
        {
            [self saveVideoInfo:timer.userInfo atIndex:pht.photoNumber];
            NSLog(@"saveAndSetTheResourceToPhoto:Saving Video");
        }
    }
    
#if IMAGE_SELECTION
    /* First generate the optimized image of the selected image */
    UIImage *optimizedImage = [Utility optimizedImage:selectedImage];
    
    NSLog(@"Optimized image from (%f,%f) to (%f,%f)",selectedImage.size.width,selectedImage.size.height,optimizedImage.size.width,optimizedImage.size.height);
    
    /* Free the selected image image */
    [selectedImage release];
    
    /* Make the optimized image as the selected image */
    selectedImage = optimizedImage;
#endif
    /* save the image to HDD */
    [self saveImage:selectedImage atIndex:pht.photoNumber];
    
    /* save frame type */
    [self saveFrameResourceType:eType atIndex:pht.photoNumber];
    
    /*  update the database */
    [SessionDB updateImageSizeInDBWith:selectedImage.size atIndex:pht.photoNumber forSession:iSessionId];
    //[SessionDB updateResourceSizeInDBWith:self.imageFromApp.size atIndex:photoFromFrame.photoNumber ofType:eType atPath:pathToVideo forSession:iSessionId];
    
    /* set the image to photo */
    pht.image = selectedImage;
    
    /* decrement the retain count */
    //[imageBeingSelected release];
    
    selectedImage = nil;
    
    /* Update the Session Icon */
    [self updateTheSessionIcon];
    
    [Utility removeActivityIndicatorFrom:_frame.superview];
    
    return;
}

-(void)imageSelectedForPhoto:(UIImage*)img indexOfPhoto:(int)photoNumer
{
    Photo *pht = [self.frame getPhotoAtIndex:photoNumer];
    UIImage *selectedImage = nil;
    NSAssert(nil != pht, @"Photo at Index %d is nil",photoNumer);
    
    [self handleVideoFrameSettingsUpdate];
    
    selectedImage = [img retain];
    
    [self saveVideoInfo:nil atIndex:photoNumer];
    
    [self deleteVideoFramesForPhotoAtIndex:photoNumer];
    
    /* start the activity controller */
    [Utility addActivityIndicatotTo:_frame.superview withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:selectedImage,@"selectedImage",pht,@"Photo", nil];
    /* schedule the timer to start the HDD saving, DB updated and setting to photo */
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(saveAndSetTheResourceForPhoto:) userInfo:input repeats:NO];
}

-(BOOL)anyVideoFrameSelected
{
    BOOL isVideoFrame = NO;
    /* Check if any video is selected */
    for(int index = 0; index < self.frame.photoCount; index++)
    {
        if(FRAME_RESOURCE_TYPE_VIDEO == [self getFrameResourceTypeAtIndex:index])
        {
            isVideoFrame = YES;
            break;
        }
    }
    
    return isVideoFrame;
}

-(int)totalVideoPhotos
{
    int videoFrame = 0;
    /* Check if any video is selected */
    for(int index = 0; index < self.frame.photoCount; index++)
    {
        if(FRAME_RESOURCE_TYPE_VIDEO == [self getFrameResourceTypeAtIndex:index])
        {
            videoFrame++;
        }
    }
    
    return videoFrame;
}

-(void)previewVideo
{
    if(NO == [self anyVideoFrameSelected])
    {
        NSLog(@"No Video frames to play");
        return;
    }
    
    readyToPlayPlayerCount = 0;
    
    /* create players based on number of video frames */
    self.playerItems = [[[NSMutableArray alloc]initWithCapacity:self.frame.photoCount]autorelease];
    self.players     = [[[NSMutableArray alloc]initWithCapacity:self.frame.photoCount]autorelease];
    
    for(int index = 0; index < self.frame.photoCount; index++)
    {
        if([self getFrameResourceTypeAtIndex:index] == FRAME_RESOURCE_TYPE_PHOTO)
        {
            [players insertObject:[NSNull null] atIndex:index];
            [playerItems insertObject:[NSNull null] atIndex:index];
            NSLog(@"Not inserting nil");
            continue;
        }
        
        NSURL *url = [self getVideoUrlForPhotoAtIndex:index];
        if(nil == url)
        {
            NSLog(@"URL is nil");
            continue;
        }
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        if((nil == playerItem)||(nil == player))
        {
            NSLog(@"One of playeritem or player is nil");
            continue;
        }
        [self.playerItems insertObject:playerItem atIndex:index];
        [self.players     insertObject:player atIndex:index];
        
        [player  addObserver:self
                  forKeyPath:@"status"
                     options:0
                     context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerFinishedPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
    }
}

-(void)previewAudio
{
    if(NO == [self anyVideoFrameSelected])
    {
        NSLog(@"No Video frames to play");
        return;
    }
    
    readyToPlayPlayerCount = 0;
    
    /* create players based on number of video frames */
    self.playerItems = [[[NSMutableArray alloc]initWithCapacity:self.frame.photoCount]autorelease];
    self.players     = [[[NSMutableArray alloc]initWithCapacity:self.frame.photoCount]autorelease];
    
    for(int index = 0; index < self.frame.photoCount; index++)
    {
        if([self getFrameResourceTypeAtIndex:index] == FRAME_RESOURCE_TYPE_PHOTO)
        {
            [players insertObject:[NSNull null] atIndex:index];
            [playerItems insertObject:[NSNull null] atIndex:index];
            NSLog(@"Not inserting nil");
            continue;
        }
        
        NSURL *url = [self getVideoUrlForPhotoAtIndex:index];
        if(nil == url)
        {
            NSLog(@"URL is nil");
            continue;
        }
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        if((nil == playerItem)||(nil == player))
        {
            NSLog(@"One of playeritem or player is nil");
            continue;
        }
        [self.playerItems insertObject:playerItem atIndex:index];
        [self.players     insertObject:player atIndex:index];
        
        [player  addObserver:self
                  forKeyPath:@"status"
                     options:0
                     context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerFinishedPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
    }
}

-(void)playerFinishedPlaying:(NSNotification*)notification
{
    NSLog(@"playerFinishedPlaying");
    for(int index = 0;  index < self.frame.photoCount; index++)
    {
        if(notification.object == [self.playerItems objectAtIndex:index])
        {
            Photo *photo = [self.frame getPhotoAtIndex:index];
            [photo.view.imageView removePlayer];
            readyToPlayPlayerCount--;
            NSLog(@"Player at index %d stopped",index);
        }
    }
    
    if(0 == readyToPlayPlayerCount)
    {
        for(int index = 0; index < self.frame.photoCount; index++)
        {
            if([NSNull null] != [self.playerItems objectAtIndex:index])
            {
                [[NSNotificationCenter defaultCenter]removeObserver:self
                                                               name:AVPlayerItemDidPlayToEndTimeNotification
                                                             object:[self.playerItems objectAtIndex:index]];
            }
            
            if([NSNull null] != [self.players objectAtIndex:index])
            {
                AVPlayer *player = [self.players objectAtIndex:index];
                [player removeObserver:self forKeyPath:@"status" context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
            }
        }
        
        [self.playerItems removeAllObjects];
        [self.players removeAllObjects];
        self.players = nil;
        self.playerItems = nil;
        NSLog(@"Freed all playing resources");
    }
}

- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    AVPlayer *player = object;
    
    for(int index = 0;  index < self.frame.photoCount; index++)
    {
        if(object == [self.players objectAtIndex:index])
        {
            if(player.status == AVPlayerStatusReadyToPlay)
            {
                Photo *photo = [self.frame getPhotoAtIndex:index];
                [photo.view.imageView setPlayer:object];
                readyToPlayPlayerCount++;
                NSLog(@"Player at index %d ready to play",index);
                break;
            }
        }
    }
    
    if(readyToPlayPlayerCount == [self totalVideoPhotos])
    {
        for(int index = 0;  index < self.frame.photoCount; index++)
        {
            id obj = [self.players objectAtIndex:index];
            if([NSNull null] != obj)
            {
                player = obj;
                [player play];
                NSLog(@"Player At index %d started playing",index);
            }
        }
    }
}

//-(void)videoSelectedForPhoto:(UIImage *)img atPath:(NSURL*)path
-(void)videoSelectedForCurrentPhotoWithInfo:(NSDictionary*)videoInfo image:(UIImage*)img
{
    [self handleVideoFrameSettingsUpdate];
    [self deleteCurrentAudioMix];
    
    /* First set the image */
    self.imageFromApp = [img retain];
    //self.imageFromApp = [[videoInfo objectForKey:@"image"]retain];
    self.videoSelected = YES;
    /* start the activity controller */
    [Utility addActivityIndicatotTo:_frame.superview withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    //NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:path forKey:@"videoPath"];
    
    /* schedule the timer to start the HDD saving, DB updated and setting to photo */
    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(saveAndSetTheResourceToPhoto:) userInfo:usrInfo repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(saveAndSetTheResourceToPhoto:) userInfo:videoInfo repeats:NO];
}

#pragma mark end saving video frames to HDD
-(int)photoNumberOfCurrentSelectedPhoto
{
    return photoFromFrame.photoNumber;
}

-(void)saveVideoToDocDirectory:(NSURL*)url completion:(void (^)(NSString *localVideoPath))complete
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
        NSData *videoData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        NSString * videoName = [NSString stringWithFormat:@"student_%d_%d.mp4",iSessionId,photoFromFrame.photoNumber];
        NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:videoName];
        
        NSLog(@"video path-%@",videoPath);
        
        [videoData writeToFile:videoPath atomically:YES];
        
        if(nil != complete)
        {
            complete(videoPath);
        }
        
    } failureBlock:^(NSError *error) {
        
        if(nil != complete)
        {
            complete(nil);
        }
    }];
    
    return ;
}

-(void)saveAndSetTheEditedImageToPhoto
{
    
    /* save the image to HDD */
    [self saveImage:self.imageFromApp atIndex:photoFromFrame.photoNumber];
    
    /*  update the database */
    [SessionDB updateImageSizeInDBWith:self.imageFromApp.size atIndex:photoFromFrame.photoNumber forSession:iSessionId];
    //[SessionDB updateResourceSizeInDBWith:self.imageFromApp.size
    //                              atIndex:photoFromFrame.photoNumber ofType:FRAME_RESOURCE_TYPE_PHOTO atPath:nil forSession:iSessionId];
    
    /* set the image to photo */
    [photoFromFrame setEditedImage:self.imageFromApp];
    
    /* decrement the retain count */
    [self.imageFromApp release];
    
    self.imageFromApp = nil;
    
    /* Now update the session icon */
    [self updateTheSessionIcon];
    
    [Utility removeActivityIndicatorFrom:_frame.superview];
    
    return;
}

-(void)imageEditedForPhoto:(UIImage*)img
{
    [self handleVideoFrameSettingsUpdate];
    
    /* set the image to photo */
    self.imageFromApp = img;
    
    /* start the activity controller */
    [Utility addActivityIndicatotTo:_frame.superview withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    /* schedule the timer to start the HDD saving, DB updated and setting to photo */
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(saveAndSetTheEditedImageToPhoto) userInfo:nil repeats:NO];
}

#pragma mark helper function to create session entry in DB
-(BOOL)createAndAddSessionToDbWithId:(int)sessionId
{
    if(nil == nvm)
    {
        nvm = [Settings Instance];
    }
    
    /* First Initialize the session with default values */
    iSessionId = sessionId;
    iFrameNumber = 0;
    iPattern     = 0;
    iAspectRatio = nvm.aspectRatio;
    fInnerRadius = 0.0;
    fOuterRadius = 0.0;
    fFrameWidth  = DEFAULT_FRAMEWIDTH;
    bPatternSelected = NO;
    sColor.fRed = 255.0;
    sColor.fGreen = 255.0;
    sColor.fBlue = 255.0;
    sColor.fAlpha = 255.0;
    
#if 0
    /* open the database */
    FMDatabase* db = [DBUtilities openDataBase];
    if (![db open])
    {
        [db release];
        NSLog(@"getThePhotoInfoForFrameNumber:Could not open db.");
        return 0;
    }
#else
    NSString *databaseName = PICFARME_DATABASE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    
    /* First make sure that database is copied to filesystem */
    [DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return 0;
    }
#endif
    
    [db beginTransaction];
#if DB_TRACE_EXECUTION
    [db setTraceExecution:YES];
#endif
    
    /* Now insert the session into the database */
    [db executeUpdate:@"insert into sessions (iSessionId, iFrameNumber, iPattern, iAspectRatio, fInnerRadius, fOuterRadius,fFrameWidth,bPatternSelected,fRed,fGreen,fBlue,fAlpha) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" ,
     [NSNumber numberWithInt:iSessionId],
     [NSNumber numberWithInt:iFrameNumber],
     [NSNumber numberWithInt:iPattern],
     [NSNumber numberWithInt:iAspectRatio],
     [NSNumber numberWithDouble:fInnerRadius],
     [NSNumber numberWithDouble:fOuterRadius],
     [NSNumber numberWithDouble:fFrameWidth],
     [NSNumber numberWithInt:bPatternSelected],
     [NSNumber numberWithDouble:sColor.fRed],
     [NSNumber numberWithDouble:sColor.fGreen],
     [NSNumber numberWithDouble:sColor.fBlue],
     [NSNumber numberWithDouble:sColor.fAlpha]];
    
    [db commit];
    
    /* close the database */
    [db close];
    
    return YES;
}

#pragma mark notification center methods
- (void) receiveNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:selectImageForPhoto])
    {
        photoFromFrame = notification.object;
        NSLog (@"Session Received %@ notification from photo %d",selectImageForPhoto,photoFromFrame.photoNumber);
        [[NSNotificationCenter defaultCenter]postNotificationName:selectImageForSession
                                                           object:self
                                                         userInfo:notification.userInfo];
    }
    else if([[notification name] isEqualToString:editImageForPhoto])
    {
        photoFromFrame = notification.object;
        
        NSLog (@"Session Received %@ notification from photo %d image %@",editImageForPhoto,photoFromFrame.photoNumber,photoFromFrame);
        [[NSNotificationCenter defaultCenter]postNotificationName:editImageForSession
                                                           object:photoFromFrame.image
                                                         userInfo:notification.userInfo];
    }
    else if([[notification name] isEqualToString:swapFromSelected])
    {
        NSLog(@"Session: SwapFromSelected");
        swapFrom = notification.object;
    }
    else if([[notification name] isEqualToString:swapToSelected])
    {
        NSLog(@"Session: SwapToSelected");
        swapTo   = notification.object;
        if(swapFrom.view.tag == swapTo.view.tag)
        {
            if(nil == swapFrom.image)
            {
                swapFrom.image = [self getImageAtIndex:swapFrom.view.tag];
            }
            
            return;
        }
        
        [self handleVideoFrameSettingsUpdate];
        
        [self swapImageAtIndex:swapFrom.view.tag with:swapTo.view.tag];
        
        UIImage *img   = [self getImageAtIndex:swapFrom.view.tag];
        if(nil != img)
        {
            swapFrom.image = img;
        }
        else
        {
            [swapFrom setTheImageToBlank];
        }
        
        img = [self getImageAtIndex:swapTo.view.tag];
        if(nil != img)
        {
            swapTo.image   = img;
        }
        else
        {
            [swapFrom setTheImageToBlank];
        }
    }
    else if([[notification name] isEqualToString:swapCancelled])
    {
        NSLog(@"Session: SwapCancelled");
        if(nil == swapFrom.image)
        {
            swapFrom.image = [self getImageAtIndex:swapFrom.view.tag];
        }
    }
    else if([[notification name] isEqualToString:scaleAndOffsetChanged])
    {
        Photo *pht = notification.object;
        if(nil == pht)
        {
            return;
        }
        
        [self handleVideoFrameSettingsUpdate];
        
        NSLog(@"received scaleAndOffsetChanged %d of %f, offset %f,%f",pht.photoNumber,pht.scale,pht.offset.x,pht.offset.y);
        
        [SessionDB updateImageScaleInDBWith:pht.scale offset:pht.offset atIndex:pht.view.tag forSession:iSessionId];
    }
    else if([[notification name] isEqualToString:photoDimensionsChanged])
    {
        [self handleVideoFrameSettingsUpdate];
        [_frame setWidth:0];
        [self updatePhotosAndAdjustorsFromFrame:_frame];
        [_frame setWidth:(int)self.frameWidth];
    }
    
    return;
}

/*
 handleVideoFrameSettingsUpdate: This function needs to be called everytime frame settings is changed,
 it will delete if any existing videos generated out of the frame.
 */
-(void)handleVideoFrameSettingsUpdate
{
    NSString *currentVideoPath = [self pathToCurrentVideo];
    
    if(YES == [[NSFileManager defaultManager]fileExistsAtPath:currentVideoPath])
    {
        [[NSFileManager defaultManager]removeItemAtPath:currentVideoPath error:nil];
    }
}

-(void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:nil
                                                  object:nil];
}

-(void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
}

#pragma mark erasing the images from session
-(NSMutableArray*)eraseCurImageAndReturnImageForAnimation
{
    if(nil == photoFromFrame)
    {
        return nil;
    }
    
    if(nil == photoFromFrame.image)
    {
        return nil;
    }
    
    [self handleVideoFrameSettingsUpdate];
    
    NSMutableArray *viewsForAnimation = nil;
    
    /* first delete the photo from HDD */
    [Session deleteSessionImageFromHdOfId:iSessionId atIndex:photoFromFrame.photoNumber];
    
    //delete videos assosiated with the photo
    [self deleteVideoFramesForPhotoAtIndex:photoFromFrame.photoNumber];
    
    [self saveFrameResourceType:FRAME_RESOURCE_TYPE_INVALID atIndex:photoFromFrame.photoNumber];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:photoFromFrame.frame];
    img.image = photoFromFrame.image;
    [photoFromFrame setTheImageToBlank];
    [viewsForAnimation addObject:img];
    [img release];
    
    return viewsForAnimation;
}

-(NSMutableArray*)eraseAndReturnImagesForAnimation
{
    NSMutableArray *viewsForAnimation = nil;
    int             index             = 0;
    
    [self handleVideoFrameSettingsUpdate];
    
    /* First Delete all the images from */
    [Session deleteSessionImagesFromHddOfId:iSessionId];
    
    /* Allocate memory for the array that holds UIImageView objects for animation */
    viewsForAnimation = [[NSMutableArray alloc]initWithCapacity:MAX_PHOTOS_SUPPORTED];
    
    /* Loop through the photos and allocate the UIImageView for each photo with image is set
     For all photos in the frame
     if image is set for the photo
     allocate UIImageView and add it to the array
     set the photo.image to UIImageView
     set photo.imahe = nil
     else
     continue;
     */
    for(index = 0; index < [_frame photoCount]; index++)
    {
        Photo *pht = [_frame getPhotoAtIndex:index];
        if(nil == pht)
        {
            continue;
        }
        
        if(pht.image == nil)
        {
            continue;
        }
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:pht.frame];
        img.image = pht.image;
        [pht setTheImageToBlank];
        [viewsForAnimation addObject:img];
        [img release];
    }
    
    return viewsForAnimation;
}

#pragma mark deallocation methods
-(void)deleteAllSessionResources
{
    
}

#pragma mark session display methods
-(void)showSessionOn:(UIView*)view
{
    if(nil == view)
    {
        NSLog(@"showSessionOn: Invalid input");
        return;
    }
    
    /* First remove if any shadow view is already attached */
    UIView *shView = [view viewWithTag:TAG_SHADOW_VIEW];
    if(nil != shView)
    {
        [shView removeFromSuperview];
    }
    
    /* First Add the Shadow View */
    UIView *v = [[UIView alloc]initWithFrame:_frame.frame];
    v.tag     = TAG_SHADOW_VIEW;
    v.backgroundColor = [UIColor blackColor];
    v.layer.masksToBounds = NO;
    v.layer.shadowRadius = 5.0;
    v.layer.shadowOpacity = 1.0;
    v.layer.shadowColor   = [UIColor blackColor].CGColor;
    v.layer.shadowOffset  = CGSizeMake(2.0, 2.0);
    v.layer.cornerRadius  = fOuterRadius;
    
    [view addSubview:v];
    
    [v release];
    
    [view addSubview:_frame];
    
}

-(void)hideSession
{
    /* First remove if any shadow view is already attached */
    UIView *shView = [_frame.superview viewWithTag:TAG_SHADOW_VIEW];
    if(nil != shView)
    {
        [shView removeFromSuperview];
    }
    
    if(nil != _frame)
    {
        [_frame removeFromSuperview];
    }
}

#pragma mark session initialization methods
-(void)initiClassVariables
{
    photoFromFrame = nil;
    //photoBeingSelected = nil;
    //photoBeingEdited   = nil;
    self.imageFromApp = nil;
    
    /* swaping the images from one photo to another photo */
    swapFrom          = nil;
    swapTo            = nil;
}

-(void)applyScaleAndOffsetForTheFrame
{
    int count = 0;
    int index = 0;
    
    /* configure the images */
    stImageInfo *imgInfo = NULL;
    
    count = [SessionDB getTheImageInfoForSessionId:iSessionId to:&imgInfo];
    for(index = 0; index < [_frame photoCount]; index++)
    {
        Photo *pht = [_frame getPhotoAtIndex:index];
        if(nil == pht)
        {
            continue;
        }
        
        /* set the image */
        pht.image = [self getImageAtIndex:index];
        
        /* set the scale */
        pht.scale = imgInfo[index].scale;
        
        /* set the offset */
        pht.offset = imgInfo[index].offset;
    }
    
    if(NULL != imgInfo)
    {
        free(imgInfo);
        imgInfo = NULL;
    }
    
    return;
}

-(id)initWithSessionId:(int)sessionId
{
    self  = [super init];
    if(nil != self)
    {
        FMResultSet *sessions  = nil;
        
        NSString *databaseName = PICFARME_DATABASE;
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
        
        /* First make sure that database is copied to filesystem */
        [DBUtilities checkAndCreateDatabase];
        
        /* open the database */
        FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
        if (![db open])
        {
            [db release];
            NSLog(@"openDataBase:Could not open db.");
            return 0;
        }
        
        sessions = [db executeQuery:@"select * from sessions where iSessionId = ?",[NSNumber numberWithInt:sessionId]];
        if(nil == sessions)
        {
            NSLog(@"initWithSessionId:Could not get sessions");
            [db close];
            return nil;
        }
        
        if(nil == nvm)
        {
            nvm = [Settings Instance];
        }
        
        /* browse to the row based on index */
        while([sessions next])
        {
            /* check if the session really exist */
            if([sessions intForColumn:@"iSessionId"] == sessionId)
            {
                //NSLog(@"initWithSessionId: Found the session, so loading it now");
                iSessionId   = [sessions intForColumn:@"iSessionId"];
                iFrameNumber = [sessions intForColumn:@"iFrameNumber"];
                iPattern     = [sessions intForColumn:@"iPattern"];
                iAspectRatio = [sessions intForColumn:@"iAspectRatio"];
                nvm.aspectRatio = iAspectRatio;
                
                fInnerRadius = [sessions doubleForColumn:@"fInnerRadius"];
                fOuterRadius = [sessions doubleForColumn:@"fOuterRadius"];
                fFrameWidth  = [sessions doubleForColumn:@"fFrameWidth"];
                
                bPatternSelected = [sessions intForColumn:@"bPatternSelected"];
                sColor.fRed = [sessions doubleForColumn:@"fRed"];
                sColor.fGreen = [sessions doubleForColumn:@"fGreen"];
                sColor.fBlue = [sessions doubleForColumn:@"fBlue"];
                sColor.fAlpha = [sessions doubleForColumn:@"fAlpha"];
                
                [sessions close];
                [db close];
                
                /* Now create the frame and configure it with photos and adjustors */
                Frame *frm = [[Frame alloc]initWithFrameNumber:iFrameNumber];
                if(nil == frm)
                {
                    [sessions close];
                    [db close];
                    NSLog(@"initWithSessionId: Failed to create the frame");
                    return nil;
                }
                
                /* set the frame */
                _frame = frm;
                
                //self.frameWidth  = fFrameWidth;
                
                /* configure the photos one by one */
                stPhotoInfo *phtInfo = NULL;
                int          index   = 0;
                int          count = 0;
                
                /* get the photo info and configure the photos */
                count = [SessionDB getThePhotoInfoForSessionId:sessionId to:&phtInfo];
                for(index = 0; index < [frm photoCount]; index++)
                {
                    Photo *pht = [frm getPhotoAtIndex:index];
                    if(nil == pht)
                    {
                        continue;
                    }
                    
                    pht.frame = phtInfo[index].dimension;
                    pht.actualFrame = phtInfo[index].dimension;
                }
                
                /* Free the Photo information */
                if(NULL != phtInfo)
                {
                    free(phtInfo);
                }
                
                /* configure the adjustors one by one */
                stAdjustorInfo *adjInfo = NULL;
                
                count = [SessionDB getTheAdjustorInfoForSessionId:sessionId to:&adjInfo];
                for(index = 0; index < [frm adjustorCount]; index++)
                {
                    Adjustor *adj = [frm getAdjustorAtIndex:index];
                    if(nil == adj)
                    {
                        continue;
                    }
                    
                    adj.frame = adjInfo[index].dimension;
                    adj.actualFrame = adjInfo[index].dimension;
                }
                
                if(NULL != adjInfo)
                {
                    free(adjInfo);
                }
                
                [self initiClassVariables];
                
                [self registerForNotifications];
                
                /* Now configure the session */
                self.innerRadius = fInnerRadius;
                self.outerRadius = fOuterRadius;
                self.frameWidth  = fFrameWidth;
                //[self setPhotoWidth:fFrameWidth];
                
                [self applyScaleAndOffsetForTheFrame];
                
                [sessions close];
                [db close];
                
                if(bPatternSelected)
                {
                    self.pattern = iPattern;
                }
                else
                {
                    self.color = [UIColor colorWithRed:sColor.fRed green:sColor.fGreen blue:sColor.fBlue alpha:sColor.fAlpha];
                }
                
                /* set the shapes */
                for(index = 0; index < [frm photoCount]; index++)
                {
                    Photo *pht = [frm getPhotoAtIndex:index];
                    if(nil == pht)
                    {
                        continue;
                    }
                    
                    eShape shp = [self getShapeOfthePhotoInSession:sessionId photonum:index];
                    [pht.view setShape:shp];
                }
                
                /* Now update the session icon */
                [self updateTheSessionIcon];
                
                return self;
            }
        }
        
        [sessions close];
        [db close];
#if 0
        NSLog(@"initWithSessionId: sessionId is not found in DB, so creating new session");
        if(NO == [self createAndAddSessionToDbWithId:sessionId])
        {
            return nil;
        }
        
        return self;
#endif
        
        [self release];
        
        self = nil;
        
    }
    
    return nil;
}

-(int)shapeOfCurrentlySelectedPhoto
{
    if(nil == photoFromFrame)
    {
        return 0;
    }
    
    return photoFromFrame.view.curShape;
}

-(void)shapePreviewSelectedForPhoto:(eShape)shape
{
    if(nil == photoFromFrame)
    {
        return;
    }
    
    //int temp = photoFromFrame.view.curShape;
    
    [photoFromFrame.view setShape:shape];
    
    //photoFromFrame.view.curShape = temp;
}

-(void)shapePreviewCancelled
{
    eShape shape = photoFromFrame.view.curShape;
    
    [photoFromFrame.view setShape:shape];
    
    [self updateDbWithShape:shape forSession:self.sessionId andPhoto:photoFromFrame.photoNumber];
    
    [self updateTheSessionIcon];
}

-(void)shapeSelectedForPhoto:(eShape)shape
{
    [self handleVideoFrameSettingsUpdate];
    
    //this piece of code was conflicting with sgwController
#if 0
    /* first update the photo for new shape */
    if(photoFromFrame.view.curShape == shape)
    {
        NSLog(@"shapeSelectedForPhoto: not updating shape is already configured for %d",shape);
        return;
    }
#endif
    [photoFromFrame.view setShape:shape];
    
    [self updateDbWithShape:shape forSession:self.sessionId andPhoto:photoFromFrame.photoNumber];
    
    [self updateTheSessionIcon];
}

#if 0
-(id)initWithFrameNumber:(int)iFrmNumber
{
    self  = [super init];
    if(nil != self)
    {
        /* Create instance for nvm */
        nvm = [Settings Instance];
        
        /* allocate the frame */
        Frame *frm = [[Frame alloc]initWithFrameNumber:iFrmNumber];
        if(nil == frm)
        {
            NSLog(@"initSessionWithFrameNumber:Failed to Allocate the frame");
            return nil;
        }
        
        /* create database entry and init with default values */
        BOOL created = [self createAndAddSessionToDbWithId:nvm.nextSessionIndex];
        if(NO == created)
        {
            NSLog(@"initSessionWithFrameNumber:Failed to create session db entry");
            [frm release];
            return nil;
        }
        
        /* configure the frame */
        [frm setWidth:7];
        
        /* initialize the frame */
        _frame = frm;
        
        iFrameNumber = iFrmNumber;
        
        /* First delete of any photos and adjustors are assosiated with this session */
        [self deletePhotosAndAdjustors];
        
        /*initialize the dimension table with photos and adjustors */
        [self addPhotosAndAdjustorsFromFrame:frm];
        
        [self initiClassVariables];
        
        /* register for notifications */
        [self registerForNotifications];
        
        return self;
    }
    
    return nil;
}

#else

-(id)initWithFrameNumber:(int)iFrmNumber
{
    self  = [super init];
    if(nil != self)
    {
        /* Create instance for nvm */
        nvm = [Settings Instance];
        
        /* create database entry and init with default values */
        BOOL created = [self createAndAddSessionToDbWithId:nvm.nextFreeSessionIndex];
        if(NO == created)
        {
            NSLog(@"initSessionWithFrameNumber:Failed to create session db entry");
            return nil;
        }
        
        /* First delete of any photos and adjustors are assosiated with this session */
        [self deletePhotosAndAdjustors];
        
        self.frameNumber = iFrmNumber;
        
        [self initiClassVariables];
        
        /* register for notifications */
        [self registerForNotifications];
        
        /* Now update the session icon */
        [self updateTheSessionIcon];
        
        return self;
    }
    
    return nil;
}

#endif

#pragma mark other session related functions
-(void)updateSessionInDB
{
#if 0
    /* open the database */
    FMDatabase* db = [DBUtilities openDataBase];
    if (![db open])
    {
        [db release];
        NSLog(@"getThePhotoInfoForFrameNumber:Could not open db.");
        return 0;
    }
#else
    NSString *databaseName = PICFARME_DATABASE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    
    /* First make sure that database is copied to filesystem */
    [DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return;
    }
#endif
    
    [db beginTransaction];
    
#if DB_TRACE_EXECUTION
    [db setTraceExecution:YES];
#endif
    
    /* execute the update */
    [db executeUpdate:@"update sessions set iFrameNumber = ?, iPattern = ?, iAspectRatio = ?, fInnerRadius = ?, fOuterRadius = ?,fFrameWidth = ?,bPatternSelected = ?,fRed = ?,fGreen = ?,fBlue = ?,fAlpha = ? where iSessionId = ?",
     [NSNumber numberWithInt:iFrameNumber],
     [NSNumber numberWithInt:iPattern],
     [NSNumber numberWithInt:iAspectRatio],
     [NSNumber numberWithDouble:fInnerRadius],
     [NSNumber numberWithDouble:fOuterRadius],
     [NSNumber numberWithDouble:fFrameWidth],
     [NSNumber numberWithInt:bPatternSelected],
     [NSNumber numberWithDouble:sColor.fRed],
     [NSNumber numberWithDouble:sColor.fGreen],
     [NSNumber numberWithDouble:sColor.fBlue],
     [NSNumber numberWithDouble:sColor.fAlpha],
     [NSNumber numberWithFloat:iSessionId]];
    
    /* commit the transaction */
    [db commit];
    
    /* close the database */
    [db close];
    
    return;
}

-(void)addPhotosToTheFrame:(Frame*)frm
{
    int index = 0;
    
    for(index = 0; index < frm.photoCount; index++)
    {
        Photo *pht = [frm getPhotoAtIndex:index];
        if(nil == pht)
        {
            NSLog(@"addPhotosToTheFrame:Something is seriusly wrong,photo not found");
            continue;
        }
        
        UIImage *img = [self getImageAtIndex:index];
        if(nil != img)
        {
            pht.image = img;
        }
        else
        {
            //NSLog(@"Image at index %d is nil to add to the photo",index);
        }
    }
}

-(int)frameNumber
{
    return iFrameNumber;
}

-(void)setFrameNumber:(int)FrameNumber
{
    [self handleVideoFrameSettingsUpdate];
    
    iFrameNumber = FrameNumber;
    
    /* first release the frame assosiated with the session */
    if(nil != _frame.superview)
    {
        [_frame removeFromSuperview];
    }
    
    /* release the frame */
    if(nil != _frame)
    {
        [_frame release];
        _frame = nil;
    }
    
    /* allocate the new frame */
    _frame = [[Frame alloc]initWithFrameNumber:FrameNumber];
    
    
    [self deletePhotosAndAdjustors];
    
    /*initialize the dimension table and shapes table with photos and adjustors */
    [self addPhotosAndAdjustorsFromFrame:_frame];
    
    /* configure the frame */
    [_frame setWidth:DEFAULT_FRAMEWIDTH];
    
    /* add photos to the frame */
    [self addPhotosToTheFrame:_frame];
    
    [self updateSessionInDB];
    
    return;
}

-(int)sessionId
{
    return iSessionId;
}

-(void)setSessionId:(int)sessionId
{
    iSessionId = sessionId;
    
    [self updateSessionInDB];
    
    return;
}

-(BOOL)patternSelected
{
    return bPatternSelected;
}

-(UIColor*)color
{
    UIColor *clr = [UIColor colorWithRed:sColor.fRed green:sColor.fGreen blue:sColor.fBlue alpha:sColor.fAlpha];
    
    return clr;
}

-(void)setColor:(UIColor *)color
{
    const float *components = NULL;
    
    [self handleVideoFrameSettingsUpdate];
    
    components = CGColorGetComponents(color.CGColor);
    if(NULL != components)
    {
        /* update the color */
        sColor.fRed = components[0];
        sColor.fGreen = components[1];
        sColor.fBlue = components[2];
        sColor.fAlpha = components[3];
        
        /* make sure that you disabled the pattern */
        bPatternSelected = NO;
        
        /* Update the frame color */
        [_frame setColor:color];
        
        [self updateSessionInDB];
    }
    
    return;
}

-(int)pattern
{
    return iPattern;
}

-(void)setPattern:(int)pattern
{
    iPattern = pattern;
    
    [self handleVideoFrameSettingsUpdate];
    
    /* make sure that we set the pattern selected as YES */
    bPatternSelected = YES;
    
    [_frame setPattern:pattern];
    
    [self updateSessionInDB];
    
    return;
}

-(float)innerRadius
{
    return fInnerRadius;
}

-(void)setInnerRadius:(float)innerRadius
{
    [self handleVideoFrameSettingsUpdate];
    
    fInnerRadius = innerRadius;
    //NSLog(@"setInnerRadius : %f",innerRadius);
    /* Update frame inner radius */
    [_frame setInnerRadius:innerRadius];
    
    [self updateSessionInDB];
    
    return;
}

-(float)outerRadius
{
    return fOuterRadius;
}

-(void)setOuterRadius:(float)outerRadius
{
    [self handleVideoFrameSettingsUpdate];
    
    fOuterRadius = outerRadius;
    
    /* First remove if any shadow view is already attached */
    UIView *shView = [_frame.superview viewWithTag:TAG_SHADOW_VIEW];
    if(nil != shView)
    {
        shView.layer.cornerRadius = outerRadius;
    }
    
    /* Update frame Outer radius */
    [_frame setOuterRadius:outerRadius];
    
    [self updateSessionInDB];
    
    return;
}

-(float)frameWidth
{
    return fFrameWidth;
}

-(void)setPhotoWidth:(float)photoWidth
{
    [self handleVideoFrameSettingsUpdate];
    
    fFrameWidth = photoWidth;
    
    /* Update Frame Width */
    [_frame setPhotoWidth:photoWidth];
    
    [self updateSessionInDB];
    
    return;
}

-(void)setFrameWidth:(float)frameWidth
{
    [self handleVideoFrameSettingsUpdate];
    
    fFrameWidth = frameWidth;
    
    /* Update Frame Width */
    [_frame setWidth:frameWidth];
    
    [self updateSessionInDB];
    
    return;
}

-(int)aspectRatio
{
    return iAspectRatio;
}

-(void)setAspectRatio:(int)aspectRatio
{
    [self handleVideoFrameSettingsUpdate];
    
    nvm = [Settings Instance];
    
    iAspectRatio = aspectRatio;
    nvm.aspectRatio = aspectRatio;
    
    UIView *sView   = [_frame superview];
    
    self.frameNumber = iFrameNumber;
    self.innerRadius = fInnerRadius;
    self.outerRadius = fOuterRadius;
    self.frameWidth  = fFrameWidth;
    if(bPatternSelected)
    {
        self.pattern = iPattern;
    }
    else
    {
        self.color = [UIColor colorWithRed:sColor.fRed green:sColor.fGreen blue:sColor.fBlue alpha:sColor.fAlpha];
    }
    
    /* Now update the session icon */
    [self updateTheSessionIcon];
    
    [self performSelectorOnMainThread:@selector(showSessionOn:) withObject:sView waitUntilDone:YES];
    //[self showSessionOn:sView];
    
    [self updateSessionInDB];
    
    return;
}

@end
