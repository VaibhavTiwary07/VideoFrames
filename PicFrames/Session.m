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
@synthesize masterAudioPlayer;

+ (UIImage *)iconImageFromSession:(int)sessionId
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

+ (NSDate*)createdDateForSession:(int)sessionId
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

+ (void)deleteSessionImagesFromHddOfId:(int)sessId
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

+ (void)deleteSessionImageFromHdOfId:(int)sessId atIndex:(int)index
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

+ (void)deleteSessionWithId:(int)sessId
{
    [Session deleteSessionImagesFromHddOfId:sessId];
    [SessionDB deleteSessionDimensionsOfId:sessId];
    [SessionDB deleteSessionOfId:sessId];
    
    return;
}

- (eShape)getShapeOfthePhotoInSession:(int)sessionId photonum:(int)index
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
      //  [db release];
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

- (void)updateDbWithShape:(eShape)shape forSession:(int)session andPhoto:(int)photo
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
       // [db release];
        NSLog(@"openDataBase:Could not open db.");
        return;
    }
    
    [db beginTransaction];
    
    [db executeUpdate:@"update shapes set shape = ? where sessionId = ? and photoIndex = ? ",[NSNumber numberWithInt:shape],[NSNumber numberWithInt:session],[NSNumber numberWithInt:photo]];
    
    [db commit];
    [db close];
}

- (Frame*)frame
{
    return _frame;
}

- (void)dealloc
{
    if(nil != _frame)
    {
      //  [_frame release];
        _frame = nil;
    }
    
    [self unregisterForNotifications];
//    [_image release];
//    [playerItems release];
//    [players release];
//    [super dealloc];
}

#pragma mark session dimensions table operations
- (BOOL)deletePhotosAndAdjustors
{
    return [SessionDB deleteSessionDimensionsOfId:iSessionId];
}

- (BOOL)addPhotosAndAdjustorsFromFrame:(Frame*)frm
{
    NSLog(@"addPhotosAndAdjustorsFromFrame 1");
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
      //  [db release];
        NSLog(@"openDataBase:Could not open db.");
        return 0;
    }
#endif
    NSLog(@"begin transaction");
    /* begin transaction */
    [db beginTransaction];
#if DB_TRACE_EXECUTION
    NSLog(@"trace  execution");
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

- (BOOL)updatePhotosAndAdjustorsFromFrame:(Frame*)frm
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
       // [db release];
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

- (UIImage*)getImageAtIndex:(int)index
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
    
    NSLog(@"image path is %@ ",path);
    /* check if the file really exist */
   // NSString *effectPath = [self pathToEffectVideoAtIndex:index];
    NSString *videoPath = [self getVideoUrlForPhotoAtIndex:index].path;
//    if([filemgr fileExistsAtPath:effectPath])
//    {
//        NSLog(@"getImageAtIndex => effect video path ");
//    }
//    else
    if([filemgr fileExistsAtPath:videoPath])
    {
        NSLog(@"getImageAtIndex => video path ");
    }
    if([filemgr fileExistsAtPath:path] && ([filemgr fileExistsAtPath:videoPath] ||  [self getFrameResourceTypeAtIndex:index] == FRAME_RESOURCE_TYPE_PHOTO)) //|| [filemgr fileExistsAtPath:effectPath] 
    {
        img      = [UIImage imageWithContentsOfFile:path];
    }
    
    return img;
}

- (void)saveImage:(UIImage*)img atIndex:(int)index
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
    NSLog(@"saveImage file path %@",path);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    
    if(NO == [filemgr createFileAtPath:path contents:data attributes:attributes])
    {
        NSLog(@"saveImage:Failed to save the file");
    }
    
    return;
}


- (void)saveOriginalImage:(UIImage*)img atIndex:(int)index
{
    if(nil == img)
    {
        NSLog(@"saveOriginalImage:Invalid image------");
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    //NSData *data           = UIImagePNGRepresentation(img);
    NSData *data           = UIImageJPEGRepresentation(img, 1.0);
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *filename     = [NSString stringWithFormat:@"original_%d_%d.png",iSessionId,index];
    NSString *path         = [docDirectory stringByAppendingPathComponent:filename];
    NSLog(@"saveOriginalImage file path %@",path);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    
    if(NO == [filemgr createFileAtPath:path contents:data attributes:attributes])
    {
        NSLog(@"saveImage:Failed to save the file");
    }
    
    return;
}


-(UIImage*)getOriginalImageAtIndex:(int)index
{
    NSArray  *paths        = nil;
    NSString *docDirectory = nil;
    NSString *path         = nil;
    UIImage  *img          = nil;
    NSFileManager *filemgr = nil;
    NSString *filename     = [NSString stringWithFormat:@"original_%d_%d.png",iSessionId,index];
    
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


//- (void)setAdditionalAudioURL:(NSURL *)url {
//    NSLog(@"set additional audio url %@",url);
//    if (url) {
//        // Create master audio player
//        self.masterAudioPlayer = [AVPlayer playerWithURL:url];
//
//        for(int index = 0; index < self.frame.photoCount; index++)
//        {
//            Photo *pht = [self.frame getPhotoAtIndex:index];
//            if(nil != pht)
//            {
//                [pht.view muteAudio:YES];
////              [pht.view.player seekToTime:kCMTimeZero];
////              [pht.view.player play];
//            }
//        }
//        
//        // Play master audio
//        [self.masterAudioPlayer seekToTime:kCMTimeZero];
//        [self.masterAudioPlayer play];
//    } else {
//        // Stop master audio
//        [self.masterAudioPlayer pause];
//        self.masterAudioPlayer = nil;
//        
//        // Unmute all individual video players
//        for(int index = 0; index < self.frame.photoCount; index++)
//        {
//            Photo *pht = [self.frame getPhotoAtIndex:index];
//            if(nil != pht)
//            {
//                [pht.view muteAudio:NO];
////                [pht.view.player seekToTime:kCMTimeZero];
////                [pht.view.player play];
//            }
//        }
//    }
//}

- (void)setAdditionalAudioURL:(NSURL *)url {
    NSLog(@"Setting additional audio URL: %@", url);
    
    if (url) {
        
        // 1. Prepare the audio asset
        AVAsset *audioAsset = [AVAsset assetWithURL:url];
        CMTime audioDuration = audioAsset.duration;
        CMTime targetDuration = CMTimeMakeWithSeconds(30, 1); // 30 seconds
        
        // 2. Create audio composition
        AVMutableComposition *audioComposition = [AVMutableComposition composition];
        AVMutableCompositionTrack *audioTrack = [audioComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        
        // 3. Insert audio segments with looping
        AVAssetTrack *sourceAudioTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        if (sourceAudioTrack) {
            CMTime currentInsertTime = kCMTimeZero;
            CMTime remainingDuration = targetDuration;
            
            while (CMTIME_COMPARE_INLINE(remainingDuration, >, kCMTimeZero)) {
                CMTime segmentDuration = CMTimeMinimum(sourceAudioTrack.timeRange.duration, remainingDuration);
                [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, segmentDuration)
                                  ofTrack:sourceAudioTrack
                                   atTime:currentInsertTime
                                    error:nil];
                
                currentInsertTime = CMTimeAdd(currentInsertTime, segmentDuration);
                remainingDuration = CMTimeSubtract(remainingDuration, segmentDuration);
            }
        }
        
        // 4. Create master audio player with loop observer
        AVPlayerItem *audioPlayerItem = [AVPlayerItem playerItemWithAsset:audioComposition];
        self.masterAudioPlayer = [AVPlayer playerWithPlayerItem:audioPlayerItem];
        
        // Add loop observer
        __weak typeof(self) weakSelf = self;
        self.audioLoopObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                                                  object:audioPlayerItem
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note) {
            // Seek to beginning and play again
            [weakSelf.masterAudioPlayer seekToTime:kCMTimeZero];
            [weakSelf.masterAudioPlayer play];
            
            // Synchronize all videos
            for (int index = 0; index < weakSelf.frame.photoCount; index++) {
                Photo *pht = [weakSelf.frame getPhotoAtIndex:index];
                if (pht) {
//                    [pht.view.player seekToTime:kCMTimeZero];
//                    if (pht.view.player.rate == 0) {
//                        [pht.view.player play];
//                    }
                    
                }
            }
        }];
        
        // 5. Configure all video frames
        for (int index = 0; index < self.frame.photoCount; index++) {
            Photo *pht = [self.frame getPhotoAtIndex:index];
            if (pht) {
                pht.view.isProgrammaticPlaybackChange = YES;
                [pht.view muteAudioPlayer]; // Mute original audio
                [pht.view.player seekToTime:kCMTimeZero];
                [pht.view.player play];
                pht.view.isProgrammaticPlaybackChange = NO;
            }
        }
        
        // 6. Play synchronized audio
        [self.masterAudioPlayer seekToTime:kCMTimeZero];
        [self.masterAudioPlayer play];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"MasterAudioPlayerSet"];
        
    } else {
        // Clean up additional audio
        if (self.audioLoopObserver) {
            [[NSNotificationCenter defaultCenter] removeObserver:self.audioLoopObserver];
            self.audioLoopObserver = nil;
        }
        
        [self.masterAudioPlayer pause];
        self.masterAudioPlayer = nil;
        
        // Restore original audio
        for (int index = 0; index < self.frame.photoCount; index++) {
            Photo *pht = [self.frame getPhotoAtIndex:index];
            if (pht) {
                pht.view.isProgrammaticPlaybackChange = YES;
                [pht.view unmuteAudioPlayer];
                [pht.view.player seekToTime:kCMTimeZero];
                [pht.view.player play];
                pht.view.isProgrammaticPlaybackChange = NO;
            }
        }
    }
}

- (void)removeAudioPlayer {
    NSLog(@"Removing only audio player");
    
    // 1. Pause and clean up master audio player
    if (self.masterAudioPlayer) {
        [self.masterAudioPlayer pause];
        self.masterAudioPlayer = nil;
    }
    
    // 2. Remove audio loop observer if exists
    if (self.audioLoopObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.audioLoopObserver];
        self.audioLoopObserver = nil;
    }
    
    // 3. Unmute all video players' original audio
    for (int index = 0; index < self.frame.photoCount; index++) {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if (pht) {
            [pht.view unmuteAudioPlayer]; // Restore original audio
        }
    }
    
    // 4. Reset mute state
    self.isMasterAudioMuted = NO;
    
    NSLog(@"Audio player removed");
}



// Mutes the master audio while keeping videos playing
- (void)muteMasterAudio {
    if (self.masterAudioPlayer) {
        self.masterAudioPlayer.volume = 0.0f;
        self.isMasterAudioMuted = YES;
        
        // Unmute all video audio tracks
        for (int index = 0; index < self.frame.photoCount; index++) {
            Photo *pht = [self.frame getPhotoAtIndex:index];
            if (pht) {
                if(pht.view.isvideoMute)
                    [pht.view muteAudioPlayer];
                else
                    [pht.view unmuteAudioPlayer];
            }
        }
    }
}

// Unmutes the master audio and mutes video audio tracks
- (void)unmuteMasterAudio {
    if (self.masterAudioPlayer) {
        BOOL enableStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY] boolValue];
        if(enableStatus)
        {
            self.masterAudioPlayer.volume = 1.0f;
            self.isMasterAudioMuted = NO;
            
            // Mute all video audio tracks
            for (int index = 0; index < self.frame.photoCount; index++) {
                Photo *pht = [self.frame getPhotoAtIndex:index];
                if (pht) {
                    [pht.view muteAudioPlayer];
                }
            }
        }
    }
}

- (void)enterNoTouchMode
{
    int index = 0;
    
    for(index = 0; index < self.frame.photoCount; index++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            pht.noTouchMode = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                pht.view.scrollView.userInteractionEnabled = NO;
            });
        }
    }
}

- (void)exitNoTouchMode
{
    int index = 0;
    
    for(index = 0; index < self.frame.photoCount; index++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                pht.view.imageView.image = [self getImageAtIndex:index];
                pht.view.scrollView.userInteractionEnabled = YES;
            });
            pht.noTouchMode = NO;
            
        }
    }
}
- (void)enterTouchModeForSlectingImage:(int)photoIndex
{
    
    for(int index = 0; index < self.frame.photoCount; index++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            pht.view.imageView.image = [self getImageAtIndex:index];
            if (index ==photoIndex) {
                pht.view.scrollView.layer.borderColor = [UIColor redColor].CGColor;
                pht.view.scrollView.layer.borderWidth = 5.0;
            }
            
            pht.effectTouchMode =YES;
            
        }
    }
}
- (void)exitTouchModeForSlectingImage
{
    for( int index = 0; index < self.frame.photoCount; index++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            //pht.view.imageView.image = [self getImageAtIndex:index];
            //pht.view.scrollView.layer.borderWidth = 0.0;
            pht.effectTouchMode = NO;
        }
    }
}

// MARK: - Photo Selection Mode (Green Outline)
- (void)enterPhotoSelectionMode:(int)photoIndex
{
    for(int index = 0; index < self.frame.photoCount; index++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            pht.view.imageView.image = [self getImageAtIndex:index];

            if (index == photoIndex) {
                // GREEN OUTLINE for photo selection
                pht.view.scrollView.layer.borderColor = [UIColor greenColor].CGColor;
                pht.view.scrollView.layer.borderWidth = 5.0;
            } else {
                pht.view.scrollView.layer.borderWidth = 0.0;
            }

            pht.photoSelectionMode = YES;
        }
    }
}

- (void)exitPhotoSelectionMode
{
    for(int index = 0; index < self.frame.photoCount; index++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            pht.view.scrollView.layer.borderWidth = 0.0;
            pht.photoSelectionMode = NO;
        }
    }
}

- (void)restoreFrameImages
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

- (NSString*)pathToIntermediateVideo
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * videoName = [NSString stringWithFormat:@"intercurrent_%d.mp4",iSessionId];
    NSString *videoPath  = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    return videoPath;
}

- (NSString*)pathToCurrentVideo
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * videoName = [NSString stringWithFormat:@"VideoCollage_%d.mov",iSessionId];
    NSString *videoPath  = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    return videoPath;
}


- (NSString*)pathToCurrentAudioMix
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * videoName = [NSString stringWithFormat:@"tempaudio_%d.m4a",iSessionId];
    NSString *videoPath  = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    
    return videoPath;
}
- (NSString *)pathToAudioOfRespectedVideo:(int)videoIndex
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * videoName = [NSString stringWithFormat:@"tempaudio_%d_%d.m4a",iSessionId,videoIndex];
    NSString *videoPath  = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    
    return videoPath;
}
- (NSString*)pathToMusciSelectedFromLibrary
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * audioName = [NSString stringWithFormat:@"libraryaudio_%d.m4a",iSessionId];
    NSString *audioPath  = [documentsDirectory stringByAppendingPathComponent:audioName];
    
    return audioPath;
}

- (void)deleteCurrentAudioMix
{
    NSString *currentMix = [self pathToCurrentAudioMix];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:currentMix])
    {
        
        [[NSFileManager defaultManager]removeItemAtPath:currentMix error:nil];
    }
}

- (void)deleteVideoFramesForPhotoAtIndex:(int)photoIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *docPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"video%d",photoIndex]];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:docPath])
    {
        NSError *error;
        BOOL folderDeleted = [[NSFileManager defaultManager]removeItemAtPath:docPath error:&error];
        NSAssert(YES == folderDeleted, @"delete Video Frames ForPhotoAtIndex: Failed to delete %@, error %@",docPath,error.localizedDescription);
    }
    return;
}

- (void)deleteVideoEffectFramesForPhotoAtIndex:(int)photoIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *docPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"effect_video%d",photoIndex]];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:docPath])
    {
        NSError *error;
        BOOL folderDeleted = [[NSFileManager defaultManager]removeItemAtPath:docPath error:&error];
        NSAssert(YES == folderDeleted, @"delete Video Effect Frames ForPhotoAtIndex: Failed to delete %@, error %@",docPath,error.localizedDescription);
    }
    return;
}


- (void)deleteVideoAtPhototIndex:(int)photoIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString * videoName = [NSString stringWithFormat:@"video_%d_%d.mp4",iSessionId,photoFromFrame.photoNumber];
    //changed recently mp4 to mov
    NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    NSLog(@"Trying to delete video at path :%@", videoPath);
    
    if([[NSFileManager defaultManager]fileExistsAtPath:videoPath])
    {
        NSError *error;
        BOOL folderDeleted = [[NSFileManager defaultManager]removeItemAtPath:videoPath error:&error];
        NSAssert(YES == folderDeleted, @"deleteVideoeffectFramesForPhotoAtIndex: Failed to delete %@, error %@",videoPath,error.localizedDescription);
        NSLog(@" FINISHED");
    }
    return;
}


- (void)deleteImageOfFrame:(int)photoIndex frame:(int)frameIndex
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

- (NSString*)pathForImageAtIndex:(int)index inPhoto:(int)photoIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"video%d",photoIndex]];
    if(NO == [[NSFileManager defaultManager]fileExistsAtPath:folderPath])
    {
        BOOL folderCreated = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO
                attributes:nil error:nil];
        NSLog(@"folder  %@ created %@",folderPath,folderCreated?@"Yes":@"No");
        NSAssert(YES == folderCreated, @"pathForImageAtIndex: Failed To create folder %@",folderPath);
    }
    
    NSString *imgPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.jpg",photoIndex,index]];
    
    return imgPath;
}


- (NSString*)pathForEffectImageAtIndex:(int)index inPhoto:(int)photoIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"effect_video%d",photoIndex]];
    if(NO == [[NSFileManager defaultManager]fileExistsAtPath:folderPath])
    {
        BOOL folderCreated = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO
        attributes:nil error:nil];
        NSLog(@"effect folder  %@ created %@",folderPath,folderCreated?@"Yes":@"No");
        NSAssert(YES == folderCreated, @"pathForImageAtIndex: Failed To create folder %@",folderPath);
    }
    
    NSString *imgPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.jpg",photoIndex,index]];
    
    return imgPath;
}


- (NSString*)pathToEffectVideoAtIndex:(int)photoindex
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * videoName = [NSString stringWithFormat:@"EffectVideo_%d.mov",photoindex];
    NSString *videoPath  = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    return videoPath;
}

- (void)deleteEffectVideoAtPhototIndex:(int)photoIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString * videoName = [NSString stringWithFormat:@"EffectVideo_%d.mov",photoIndex];
    //changed recently mp4 to mov
    NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:videoName];
    
    NSLog(@"Trying to delete video at path :%@", videoPath);
    
    if([[NSFileManager defaultManager]fileExistsAtPath:videoPath])
    {
        NSError *error;
        BOOL folderDeleted = [[NSFileManager defaultManager]removeItemAtPath:videoPath error:&error];
        NSAssert(YES == folderDeleted, @"deleteVideoeffectFramesForPhotoAtIndex: Failed to delete %@, error %@",videoPath,error.localizedDescription);
        NSLog(@" FINISHED");
    }
    return;
}



- (UIImage*)getVideoFrameAtIndex:(int)frameIndex forPhoto:(int)photoIndex
{
    NSString *imgPath = [self pathForImageAtIndex:frameIndex inPhoto:photoIndex];
    if(NO == [[NSFileManager defaultManager]fileExistsAtPath:[self pathForImageAtIndex:frameIndex inPhoto:photoIndex]])
    {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:imgPath];
}

- (UIImage*)getEffectVideoFrameAtIndex:(int)frameIndex forPhoto:(int)photoIndex
{
    NSString *imgPath = [self pathForEffectImageAtIndex:frameIndex inPhoto:photoIndex];
    if(NO == [[NSFileManager defaultManager]fileExistsAtPath:[self pathForImageAtIndex:frameIndex inPhoto:photoIndex]])
    {
        return nil;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];

    if (image) {
        // do nothing
    } else {
        // Get the image from original image
        image = [self getVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
    }
    return image; //[UIImage imageWithContentsOfFile:imgPath];
}


- (void)saveImageAfterApplyingEffect:(UIImage *)image atPhotoIndex:(int)photoIndex atFrameIndex:(int)frameIndex
{
    NSString *imgPath = [self pathForEffectImageAtIndex:frameIndex inPhoto:photoIndex];
    if([[NSFileManager defaultManager]fileExistsAtPath:imgPath])
    {
        NSError *error;
        BOOL folderDeleted = [[NSFileManager defaultManager]removeItemAtPath:imgPath error:&error];
        NSAssert(YES == folderDeleted, @"saveImageAfterApplyingEffect : Failed to delete %@, error %@",imgPath,error.localizedDescription);
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageData writeToFile:imgPath atomically:YES];
    });
}



- (NSString*)getVideoInfoKeyForPhotoAtIndex:(int)index
{
    return [NSString stringWithFormat:@"video%d_%d.png",iSessionId,index];
}

- (int)getFrameCountForPhotoAtIndex:(int)index
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
    //NSLog(@"frames count at index %d is %ld",index,(long)[[videoInfo objectForKey:@"FrameCount"]integerValue]);
    return (int)[[videoInfo objectForKey:@"FrameCount"]integerValue];
}


- (BOOL)getAudioMuteValueForPhotoAtIndex:(int)index
{
    NSString *key     = [self getVideoInfoKeyForPhotoAtIndex:index];
   
    NSData *myData    = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSDictionary *videoInfo = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    if (key == nil)
    {
        return YES;
    }
    if(nil == videoInfo)
    {
        return YES;
    }
    BOOL mute = [[videoInfo objectForKey:@"MuteAudio"]boolValue];
    NSLog(@"video mute value %@ at index %d",mute?@"YES":@"NO",index);
    return mute ;
}




- (int)getFPSForPhotoAtIndex
{
    int maxfps = 0;
    for(int index = 0; index < self.frame.photoCount; index++)
    {
        
        if(FRAME_RESOURCE_TYPE_VIDEO == [self getFrameResourceTypeAtIndex:index])
        {
            NSString *key     = [self getVideoInfoKeyForPhotoAtIndex:index];
          //  NSLog(@"get FPS For Photo At Index key is %@",key);
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
            NSLog(@"fps video info is %@",videoInfo);
            
            float value = [[videoInfo objectForKey:@"Fps"]floatValue];
            int roundedInt = (int)roundf(value);
            
            if(roundedInt > maxfps)
            {
                maxfps = roundedInt;
            }
            NSLog(@" FPS at index %d is %d",index,maxfps);
            
        }
    }
    NSLog(@"max FPS is %d ,maxfps",maxfps);
    return maxfps;
}

- (int)getFrameCountOfFrame:(Frame*)frame
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

- (NSURL*)getVideoUrlForPhotoAtIndex:(int)index
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
    NSLog(@"URL = %@", url);
    NSLog(@"URL class = %@", NSStringFromClass([url class]));
    NSLog(@"getting %@ url as key %@",url.path,key);
    return url;
}

- (double)getMaxVideoDuration:(BOOL)isSequentialPlay
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

- (double)getVideoDurationForPhotoAtIndex:(int)index
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


- (void)saveVideoInfo:(NSMutableDictionary*)videoInfo atIndex:(int)index
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

- (eFrameResourceType)getFrameResourceTypeAtIndex:(int)index
{
    NSString *key     = [NSString stringWithFormat:@"frt%d_%d.png",iSessionId,index];
    
    return (eFrameResourceType)[[[NSUserDefaults standardUserDefaults]objectForKey:key]intValue];
}

- (void)saveFrameResourceType:(eFrameResourceType)eType atIndex:(int)index
{
    NSString *key     = [NSString stringWithFormat:@"frt%d_%d.png",iSessionId,index];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:eType] forKey:key];
}

- (void)swapImageAtIndex:(int)from with:(int)to
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

- (void)updateTheSessionIcon
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

- (void)saveAndSetTheResourceToPhoto:(NSTimer*)tmr
{
    NSLog(@"************************************************************ 1");
    NSURL *pathToVideo = nil;
    eFrameResourceType eType = FRAME_RESOURCE_TYPE_PHOTO;
    
    if(nil != tmr.userInfo)
    {
        
        eType = FRAME_RESOURCE_TYPE_VIDEO;
        pathToVideo = [tmr.userInfo objectForKey:@"videoPath"];
       
       // self.imageFromApp = [tmr.userInfo objectForKey:@"image"];
        NSLog(@"info ---- > img size width %f height %f ",self.imageFromApp.size.width,self.imageFromApp.size.height);
        NSAssert(nil != pathToVideo, @"save And Set The Resource To Photo: Userinfo doesn't contain videopath");
        [self saveVideoInfo:tmr.userInfo atIndex:photoFromFrame.photoNumber];
        NSLog(@"save And SetThe ResourceTo Photo:Saving Video");
    }
    NSLog(@" *********   %d ", eType);
#if IMAGE_SELECTION
    /* First generate the optimized image of the selected image */
    UIImage *optimizedImage = [Utility optimizedImage:self.imageFromApp];
    
    NSLog(@"Optimized image from (%f,%f) to (%f,%f)",self.imageFromApp.size.width,self.imageFromApp.size.height,optimizedImage.size.width,optimizedImage.size.height);
    
    /* Free the selected image image */
   // @autoreleasepool {
    //    [self.imageFromApp release];
   // }

    
    /* Make the optimized image as the selected image */
    self.imageFromApp = optimizedImage;
#endif
    /* save the image to HDD */
    
    [self saveImage:self.imageFromApp atIndex:photoFromFrame.photoNumber];
    [self saveOriginalImage:self.imageFromApp atIndex:photoFromFrame.photoNumber];
    /* save frame type */
    [self saveFrameResourceType:eType atIndex:photoFromFrame.photoNumber];
    
    /*  update the database */
    [SessionDB updateImageSizeInDBWith:self.imageFromApp.size atIndex:photoFromFrame.photoNumber forSession:iSessionId];
    //[SessionDB updateResourceSizeInDBWith:self.imageFromApp.size atIndex:photoFromFrame.photoNumber ofType:eType atPath:pathToVideo forSession:iSessionId];
    
    /* set the image to photo */
//    if(photoFromFrame.image == nil)
//    {
        NSLog(@"Photo setImage is called from here 2");
        photoFromFrame.image = self.imageFromApp;
   // }
    
    /* decrement the retain count */
    //[imageBeingSelected release];
    
    self.imageFromApp = nil;
    
    /* Update the Session Icon */
    [self updateTheSessionIcon];
    
    [LoadingClass removeActivityIndicatorFrom:_frame.superview];
    [self CheckIfAllFramesFilled];
    return;
}
#if 1
- (void)imageSelectedForPhoto:(UIImage*)img
{
    // photoFromFrame.photoNumber = photoNumer;
    [self handleVideoFrameSettingsUpdate];
    
    self.imageFromApp = img;
    NSLog(@"Image selected ***********************************************");
    photoFromFrame.isContentTypeVideo = NO;
    photoFromFrame.muteAudio = YES;
    photoFromFrame.videoURL = nil;
    [self saveVideoInfo:nil atIndex:photoFromFrame.photoNumber];
    NSLog(@"image select for item delete video 1");
    [self deleteVideoFramesForPhotoAtIndex:photoFromFrame.photoNumber];
    [self deleteVideoEffectFramesForPhotoAtIndex:photoFromFrame.photoNumber];
    /* start the activity controller */
//    [LoadingClass addActivityIndicatotTo:_frame.superview withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    /* schedule the timer to start the HDD saving, DB updated and setting to photo */
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(saveAndSetTheResourceToPhoto:) userInfo:nil repeats:NO];
}
#endif
- (void)saveAndSetTheResourceForPhoto:(NSTimer*)timer
{
    Photo *pht = [timer.userInfo objectForKey:@"Photo"];
    UIImage *selectedImage = [timer.userInfo objectForKey:@"selectedImage"];
    NSLog(@"selectedImage size is %@",NSStringFromCGSize(selectedImage.size));
    NSURL *pathToVideo = nil;
    eFrameResourceType eType = FRAME_RESOURCE_TYPE_PHOTO;
    
    if(nil != timer.userInfo)
    {
        
        pathToVideo = [timer.userInfo objectForKey:@"videoPath"];
        if(nil != pathToVideo)
        {
            eType = FRAME_RESOURCE_TYPE_VIDEO;
            [self saveVideoInfo:timer.userInfo atIndex:pht.photoNumber];
            NSLog(@"save And Set The Resource To Photo:Saving Video");
            pht.muteAudio = [self getAudioMuteValueForPhotoAtIndex:pht.photoNumber];
            pht.videoURL =[self getVideoUrlForPhotoAtIndex:pht.photoNumber];
            pht.isContentTypeVideo = YES;
        }
    }
    
#if IMAGE_SELECTION
    /* First generate the optimized image of the selected image */
   // @autoreleasepool {
    UIImage *optimizedImage = [Utility optimizedImage:selectedImage];
    
    NSLog(@"Optimized image from (%f,%f) to (%f,%f)",selectedImage.size.width,selectedImage.size.height,optimizedImage.size.width,optimizedImage.size.height);
    
    /* Free the selected image image */
    
     //   [selectedImage release];
    pht.isContentTypeVideo = NO;
    pht.videoURL = nil;
   
    
    /* Make the optimized image as the selected image */
    selectedImage = optimizedImage;
    
#endif
    /* save the image to HDD */
    [self saveImage:selectedImage atIndex:pht.photoNumber];
    
    [self saveOriginalImage:selectedImage atIndex:pht.photoNumber];
    
    /* save frame type */
    [self saveFrameResourceType:eType atIndex:pht.photoNumber];
    
    /*  update the database */
    [SessionDB updateImageSizeInDBWith:selectedImage.size atIndex:pht.photoNumber forSession:iSessionId];
    //[SessionDB updateResourceSizeInDBWith:self.imageFromApp.size atIndex:photoFromFrame.photoNumber ofType:eType atPath:pathToVideo forSession:iSessionId];
    
    
    
    /* set the image to photo */
//    if(pht.image == nil)
//    {
        NSLog(@"Photo setImage is called from here 1");
    pht.image = selectedImage;
   // }
    
    /* decrement the retain count */
    //[imageBeingSelected release];
    
    selectedImage = nil;
    
    /* Update the Session Icon */
    [self updateTheSessionIcon];
    
    [LoadingClass removeActivityIndicatorFrom:_frame.superview];
    [self CheckIfAllFramesFilled];
    return;
//}        
}

-(void)CheckIfAllFramesFilled
{
    int maximumNumberOfImage = 0;
    int photoIndex = 0;
    for (photoIndex= 0; photoIndex< self.frame.photoCount; photoIndex++)
    {
        Photo *pht = [self.frame getPhotoAtIndex:photoIndex ];
        if (pht.image != nil) {
            maximumNumberOfImage ++;
        }
    }
    NSLog(@"maximum Number Of Image %d photoCount %d",maximumNumberOfImage,self.frame.photoCount);
    if( maximumNumberOfImage > 0)
    {
        if(maximumNumberOfImage == self.frame.photoCount)
        {
           // [self showRateUsPanel];
            [[NSNotificationCenter defaultCenter] postNotificationName:show_RateUsPanel object:nil userInfo:nil];
            NSLog(@"Show rate us panel");
        }
    }
}

- (void)imageSelectedForPhoto:(UIImage*)img indexOfPhoto:(int)photoNumer
{
    Photo *pht = [self.frame getPhotoAtIndex:photoNumer];
    UIImage *selectedImage = nil;
    NSAssert(nil != pht, @"Photo at Index %d is nil",photoNumer);
    
    [self handleVideoFrameSettingsUpdate];
    
    selectedImage = img;// [img retain];
    
    [self saveVideoInfo:nil atIndex:photoNumer];
    NSLog(@"Image select for photo 2 delete video");
    [self deleteVideoFramesForPhotoAtIndex:photoNumer];
    /* start the activity controller */
//    [LoadingClass addActivityIndicatotTo:_frame.superview withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:selectedImage,@"selectedImage",pht,@"Photo", nil];
    /* schedule the timer to start the HDD saving, DB updated and setting to photo */
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(saveAndSetTheResourceForPhoto:) userInfo:input repeats:NO];
}

- (BOOL)anyVideoFrameSelected
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

- (int)totalVideoPhotos
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

- (void)previewVideo
{
    if(NO == [self anyVideoFrameSelected])
    {
        NSLog(@"No Video frames to play");
        return;
    }
    
    readyToPlayPlayerCount = 0;
    
    /* create players based on number of video frames */
    self.playerItems = [[NSMutableArray alloc]initWithCapacity:self.frame.photoCount]; //autorelease];
    self.players     = [[NSMutableArray alloc]initWithCapacity:self.frame.photoCount]; //autorelease];
    
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

- (void)previewAudio
{
    if(NO == [self anyVideoFrameSelected])
    {
        NSLog(@"No Video frames to play");
        return;
    }
    
    readyToPlayPlayerCount = 0;
    
    /* create players based on number of video frames */
    self.playerItems = [[NSMutableArray alloc]initWithCapacity:self.frame.photoCount]; //autorelease];
    self.players     = [[NSMutableArray alloc]initWithCapacity:self.frame.photoCount]; //autorelease];
    
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

- (void)playerFinishedPlaying:(NSNotification*)notification
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
- (void)videoSelectedForCurrentPhotoWithInfo:(NSDictionary*)videoInfo image:(UIImage*)img
{
    NSLog(@"Video selected ***********************************************");
    [self handleVideoFrameSettingsUpdate];
    [self deleteCurrentAudioMix];
    
    /* First set the image */
    self.imageFromApp = img;//[img retain];
    NSLog(@"info ---- > img size width %f height %f ",self.imageFromApp.size.width,self.imageFromApp.size.height);
    //self.imageFromApp = [[videoInfo objectForKey:@"image"]retain];
    self.videoSelected = YES;
    /* start the activity controller */
    //[LoadingClass addActivityIndicatotTo:_frame.superview withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    //NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:path forKey:@"videoPath"];
    photoFromFrame.isContentTypeVideo = YES;
    NSLog(@"video info is %@",videoInfo);
    BOOL muted = [videoInfo[@"MuteAudio"] boolValue];
    photoFromFrame.muteAudio = muted;
    NSLog(@"mute audio %@",muted?@"YES":@"NO");
    photoFromFrame.videoURL = [videoInfo objectForKey:@"videoPath"];
    /* schedule the timer to start the HDD saving, DB updated and setting to photo */
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(saveAndSetTheResourceToPhoto:) userInfo:videoInfo repeats:NO];
}

#pragma mark end saving video frames to HDD
- (int)photoNumberOfCurrentSelectedPhoto
{
    return photoFromFrame.photoNumber;
}

- (void)saveVideoToDocDirectory:(NSURL*)urlforVideo completion:(void (^)(NSString *localVideoPath))complete
{
    NSURL *fileURL = urlforVideo;
    NSString *filePath = [fileURL path];
    NSString *localFilePath = [self getVideofilePath];
    NSString *pathExtension = [filePath pathExtension] ;
    if ([pathExtension length] > 0)
    {
    
    AVAsset *asset = [AVAsset assetWithURL:urlforVideo];
    
    AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    CGAffineTransform transform = videoTrack.preferredTransform;
    CGSize naturalSize = videoTrack.naturalSize;
    CGSize renderSize;

    // Check if it's a rotated portrait video
    if (transform.a == 0 && fabs(transform.b) == 1.0 &&
            fabs(transform.c) == 1.0 && transform.d == 0) {
            renderSize = CGSizeMake(naturalSize.height, naturalSize.width);
        // Composition
            AVMutableComposition *composition = [AVMutableComposition composition];
            AVMutableCompositionTrack *compTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                             preferredTrackID:kCMPersistentTrackID_Invalid];
            [compTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                               ofTrack:videoTrack
                                atTime:kCMTimeZero
                                 error:nil];

            // Add audio if exists
            AVAssetTrack *audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        CMTime maxDurationPerVideo = CMTimeMakeWithSeconds(120, 600);
        CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
            if (audioTrack) {
                AVMutableCompositionTrack *compAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                [compAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
                                        ofTrack:audioTrack
                                         atTime:kCMTimeZero
                                          error:nil];
            }

            // Video composition to fix orientation
            AVMutableVideoComposition *videoComp = [AVMutableVideoComposition videoComposition];
            videoComp.renderSize = renderSize;
            videoComp.frameDuration = CMTimeMake(1, 30);

            AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);

            AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compTrack];
            [layerInstruction setTransform:transform atTime:kCMTimeZero];

            instruction.layerInstructions = @[layerInstruction];
            videoComp.instructions = @[instruction];
            NSURL *outputURL = [NSURL fileURLWithPath:localFilePath];
        NSLog(@"video file location - orientation fix %@",outputURL);
        // Export
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
            exportSession.outputURL = outputURL;
            exportSession.outputFileType = AVFileTypeMPEG4;
            exportSession.shouldOptimizeForNetworkUse = YES;
            exportSession.videoComposition = videoComp;

            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                        NSLog(@"✅ Orientation fixed video saved to: %@", outputURL.path);
                        if (complete) complete(outputURL.path);
                    } else {
                        NSLog(@"❌ Failed to export: %@", exportSession.error.localizedDescription);
                        if (complete) complete(outputURL.path);
                    }
                });
            }];
    } else {
        NSError *error = nil ;
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:localFilePath error:&error];
        if(nil != complete)
        {
            NSLog(@"saved video");
            complete(localFilePath);
        }
        else
        {
            NSLog(@"video failed to save %@",error.localizedDescription);
        }
        }
   }
}

- (void)saveVideoToDocDirectory:(NSURL*)urlforVideo
                     completion:(void (^)(NSString *localVideoPath))complete
                      progress:(void (^)(float progress))progressBlock
{
    NSURL *fileURL = urlforVideo;
    NSString *filePath = [fileURL path];
    NSString *localFilePath = [self getVideofilePath];
    NSString *pathExtension = [filePath pathExtension];
    
    if ([pathExtension length] > 0) {
        AVAsset *asset = [AVAsset assetWithURL:urlforVideo];
        AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        CGAffineTransform transform = videoTrack.preferredTransform;
        CGSize naturalSize = videoTrack.naturalSize;
        CGSize renderSize;
        
        if (transform.a == 0 && fabs(transform.b) == 1.0 && fabs(transform.c) == 1.0 && transform.d == 0) {
            
            renderSize = CGSizeMake(naturalSize.height, naturalSize.width);
        // Composition
            AVMutableComposition *composition = [AVMutableComposition composition];
            AVMutableCompositionTrack *compTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                             preferredTrackID:kCMPersistentTrackID_Invalid];
            [compTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                               ofTrack:videoTrack
                                atTime:kCMTimeZero
                                 error:nil];

            // Add audio if exists
            AVAssetTrack *audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        CMTime maxDurationPerVideo = CMTimeMakeWithSeconds(120, 600);
        CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
            if (audioTrack) {
                AVMutableCompositionTrack *compAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                [compAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
                                        ofTrack:audioTrack
                                         atTime:kCMTimeZero
                                          error:nil];
            }

            // Video composition to fix orientation
            AVMutableVideoComposition *videoComp = [AVMutableVideoComposition videoComposition];
            videoComp.renderSize = renderSize;
            videoComp.frameDuration = CMTimeMake(1, 30);

            AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);

            AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compTrack];
            [layerInstruction setTransform:transform atTime:kCMTimeZero];

            instruction.layerInstructions = @[layerInstruction];
            videoComp.instructions = @[instruction];
            NSURL *outputURL = [NSURL fileURLWithPath:localFilePath];
        NSLog(@"video file location - orientation fix %@",outputURL);
        // Export
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
            exportSession.outputURL = outputURL;
            exportSession.outputFileType = AVFileTypeMPEG4;
            exportSession.shouldOptimizeForNetworkUse = YES;
            exportSession.videoComposition = videoComp;
            
            __block NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if (progressBlock) {
                    progressBlock(exportSession.progress);
                }
            }];
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [progressTimer invalidate];
                    progressTimer = nil;
                    if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                        NSLog(@"✅ Orientation fixed video saved to: %@", outputURL.path);
                        if (complete) complete(outputURL.path);
                    } else {
                        NSLog(@"❌ Failed to export: %@", exportSession.error.localizedDescription);
                        if (complete) complete(outputURL.path);
                    }
                });
            }];
            
        } else {
            // Use our new file copy with progress
            [self copyFileWithEstimatedProgressFromPath:filePath
                                       toPath:localFilePath
                                   completion:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"saved video");
                    if (complete) complete(localFilePath);
                } else {
                    NSLog(@"video failed to save %@", error.localizedDescription);
                    if (complete) complete(nil);
                }
            } progress:^(float progress) {
                // Forward progress updates
                if (progressBlock) {
                    progressBlock(progress);
                }
            }];
        }
    }
}

- (void)copyFileWithEstimatedProgressFromPath:(NSString *)sourcePath
                                     toPath:(NSString *)destinationPath
                                 completion:(void (^)(BOOL success, NSError *error))completion
                                  progress:(void (^)(float progress))progressBlock
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    // Get file size
    NSDictionary *sourceAttributes = [fileManager attributesOfItemAtPath:sourcePath error:&error];
    if (error) {
        completion(NO, error);
        return;
    }
    
    unsigned long long fileSize = [sourceAttributes fileSize];
    __block unsigned long long copiedSize = 0;
    
    // Start a timer to estimate progress
    NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSDictionary *destAttributes = [fileManager attributesOfItemAtPath:destinationPath error:nil];
        if (destAttributes) {
            copiedSize = [destAttributes fileSize];
            float progress = (float)copiedSize / (float)fileSize;
            progressBlock(progress);
        }
    }];
    
    // Perform the copy in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *copyError = nil;
        BOOL success = [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&copyError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressTimer invalidate];
            completion(success, copyError);
        });
    });
}



-(NSString *)getVideofilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * videoName = [NSString stringWithFormat:@"video_%d_%d.mp4",iSessionId,photoFromFrame.photoNumber];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:videoName] ;
    return  localFilePath;
}


-(NSURL*)createVideoCopyFromReferenceUrl:(NSURL*)inputUrlFromVideoPicker{

        NSURL __block *videoURL;
    
//        PHFetchResult *phAssetFetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[inputUrlFromVideoPicker] options:nil];
    PHFetchResult *phAssetFetchResult = [PHAsset fetchAssetsWithOptions:nil];
    
        NSLog(@"1----------");
        PHAsset *phAsset = [phAssetFetchResult firstObject];
        NSLog(@"2----------");
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
    NSLog(@"3----------");

        [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:nil resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
            NSLog(@"4----------");

            if ([asset isKindOfClass:[AVURLAsset class]]) {
                
                NSLog(@"5----------");
                NSURL *url = [(AVURLAsset *)asset URL];
                
                NSLog(@"Final URL %@",url);
                NSData *videoData = [NSData dataWithContentsOfURL:url];

                // optionally, write the video to the temp directory
                NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.mp4",[NSDate timeIntervalSinceReferenceDate]]];

                videoURL = [NSURL fileURLWithPath:videoPath];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL writeResult = [videoData writeToURL:videoURL atomically:true];

                if(writeResult) {
                    NSLog(@"video success");
                }
                else {
                    NSLog(@"video failure");
                }
//                });
                 dispatch_group_leave(group);
                // use URL to get file content
            }
        }];
        dispatch_group_wait(group,  DISPATCH_TIME_FOREVER);
        return videoURL;
    }
//---Requesting Save Video--------//

    

- (void)saveAndSetTheEditedImageToPhoto
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
   // @autoreleasepool {
     //   [self.imageFromApp release];
   // }
   
    
    self.imageFromApp = nil;
    
    /* Now update the session icon */
    [self updateTheSessionIcon];
    
    [LoadingClass removeActivityIndicatorFrom:_frame.superview];
    
    return;
}

- (void)imageEditedForPhoto:(UIImage*)img
{
    [self handleVideoFrameSettingsUpdate];
    
    /* set the image to photo */
    self.imageFromApp = img;
    
    /* start the activity controller */
//    [LoadingClass addActivityIndicatotTo:_frame.superview withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    /* schedule the timer to start the HDD saving, DB updated and setting to photo */
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(saveAndSetTheEditedImageToPhoto) userInfo:nil repeats:NO];
}

#pragma mark helper function to create session entry in DB
- (BOOL)createAndAddSessionToDbWithId:(int)sessionId
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
   // @autoreleasepool {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    
    /* First make sure that database is copied to filesystem */
    [DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open])
    {
      //  [db release];
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
//}
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
        NSLog (@"select Image For PhotoSession Received %@ notification from photo %d",selectImageForPhoto,photoFromFrame.photoNumber);
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
                swapFrom.image = [self getImageAtIndex:(int)swapFrom.view.tag];
            }
            
            return;
        }
        
        [self handleVideoFrameSettingsUpdate];
        
        [self swapImageAtIndex:(int)swapFrom.view.tag with:(int)swapTo.view.tag];
        
        UIImage *img   = [self getImageAtIndex:(int)swapFrom.view.tag];
        if(nil != img)
        {
            swapFrom.image = img;
        }
        else
        {
            [swapFrom setTheImageToBlank];
        }
        
        img = [self getImageAtIndex:(int)swapTo.view.tag];
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
            swapFrom.image = [self getImageAtIndex:(int)swapFrom.view.tag];
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
        
        NSLog(@"received scaleAndOffsetChanged %d of %f, offset %f,%f minimumZoomScale %f",pht.photoNumber,pht.scale,pht.offset.x,pht.offset.y,pht.view.scrollView.minimumZoomScale);
        
        [SessionDB updateImageScaleInDBWith:(float)pht.scale offset:pht.offset atIndex:(int)pht.view.tag forSession:iSessionId];
    }
    else if([[notification name] isEqualToString:photoDimensionsChanged])
    {
        [self handleVideoFrameSettingsUpdate];
        // [_frame setWidth:0];
        [self updatePhotosAndAdjustorsFromFrame:_frame];
        [_frame setWidth:(int)self.frameWidth+DEFAULT_FRAME_WIDTH];
    }
    else if([notification.name isEqualToString:@"AddAdditionalAudioToPlayer"])
    {
        NSURL *audioURL = notification.userInfo[@"audioURL"];
        if (audioURL) {
            NSLog(@"audio url %@",audioURL);
            // Process the audio URL
            self.additionalAudioURL = audioURL;
        }
    }
    else if([notification.name isEqualToString:@"MuteMasterAudioPlayer"])
    {
        [self muteMasterAudio];
    }
    
    return;
}

/*
 handleVideoFrameSettingsUpdate: This function needs to be called everytime frame settings is changed,
 it will delete if any existing videos generated out of the frame.
 */
- (void)handleVideoFrameSettingsUpdate
{
    NSString *currentVideoPath = [self pathToCurrentVideo];
    
    if(YES == [[NSFileManager defaultManager]fileExistsAtPath:currentVideoPath])
    {
        [[NSFileManager defaultManager]removeItemAtPath:currentVideoPath error:nil];
    }
}

- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:nil
                                                  object:nil];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
}

#pragma mark erasing the images from session
- (NSMutableArray*)eraseCurImageAndReturnImageForAnimation
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
    NSLog(@"erase image return for animation delete video 3");
    //delete videos assosiated with the photo
    [self deleteVideoFramesForPhotoAtIndex:photoFromFrame.photoNumber];
    [self deleteVideoEffectFramesForPhotoAtIndex:photoFromFrame.photoNumber];
    [self saveFrameResourceType:FRAME_RESOURCE_TYPE_INVALID atIndex:photoFromFrame.photoNumber];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:photoFromFrame.frame];
    img.image = photoFromFrame.image;
    [photoFromFrame setTheImageToBlank];
    [viewsForAnimation addObject:img];
  //[img release];
    return viewsForAnimation;
}

- (NSMutableArray*)eraseAndReturnImagesForAnimation
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
      //  [img release];
    }
    
    return viewsForAnimation;
}

#pragma mark deallocation methods
- (void)deleteAllSessionResources
{
    
}

#pragma mark session display methods
- (void)showSessionOn:(UIView*)view
{
    if(nil == view)
    {
        NSLog(@"showSessionOn: Invalid input");
        return;
    }
    
    /* First remove if any shadow view is already attached */
    UIImageView *shView = [ view  viewWithTag:TAG_SHADOW_VIEW];
    if(nil != shView)
    {
        [shView removeFromSuperview];
    }
    NSLog(@"show session on ");
    /* First Add the Shadow View */
    UIImageView *v = [[UIImageView alloc]initWithFrame:_frame.frame];
    v.tag     = TAG_SHADOW_VIEW;
    v.backgroundColor = [UIColor whiteColor];
    v.layer.masksToBounds = NO;
    v.layer.shadowRadius = 5.0;
    v.layer.shadowOpacity = 1.0;
    v.layer.shadowColor   = [UIColor blackColor].CGColor;
    v.layer.shadowOffset  = CGSizeMake(2.0, 2.0);
    v.layer.cornerRadius  = fOuterRadius;
    
    [view addSubview:v];
    
  //  [v release];
    
    [view addSubview:_frame];
    [[NSNotificationCenter defaultCenter]postNotificationName:addWaterMark
                                                       object:self
                                                     userInfo:nil];
    
}

- (void)hideSession
{
    /* First remove if any shadow view is already attached */
    UIImageView  *shView = [_frame.superview viewWithTag:TAG_SHADOW_VIEW];
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
- (void)initiClassVariables
{
    photoFromFrame = nil;
    //photoBeingSelected = nil;
    //photoBeingEdited   = nil;
    self.imageFromApp = nil;
    
    /* swaping the images from one photo to another photo */
    swapFrom          = nil;
    swapTo            = nil;
}

- (void)applyScaleAndOffsetForTheFrame
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
//        if(pht.image == nil)
//        {
            NSLog(@"Photo setImage is called from here 3");
            pht.image = [self getImageAtIndex:index];
//        }
        
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

- (id)initWithSessionId:(int)sessionId
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
         //   [db release];
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
                shadowEffectValue=[sessions doubleForColumn:@"shadowValue"];
                
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
        
      //  [self release];
        
        self = nil;
        
    }
    
    return nil;
}

- (int)shapeOfCurrentlySelectedPhoto
{
    if(nil == photoFromFrame)
    {
        return 0;
    }
    
    return photoFromFrame.view.curShape;
}

- (void)shapePreviewSelectedForPhoto:(eShape)shape
{
    if(nil == photoFromFrame)
    {
        return;
    }
    
    //int temp = photoFromFrame.view.curShape;
    
    [photoFromFrame.view setShape:shape];
    
    //photoFromFrame.view.curShape = temp;
}

- (void)shapePreviewCancelled
{
    eShape shape = photoFromFrame.view.curShape;
    
    [photoFromFrame.view setShape:shape];
    
    [self updateDbWithShape:shape forSession:self.sessionId andPhoto:photoFromFrame.photoNumber];
    
    [self updateTheSessionIcon];
}

- (void)shapeSelectedForPhoto:(eShape)shape
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
- (id)initWithFrameNumber:(int)iFrmNumber
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

- (id)initWithFrameNumber:(int)iFrmNumber
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
        self.initialization = YES;
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
- (void)updateSessionInDB
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
      //  [db release];
        NSLog(@"openDataBase:Could not open db.");
        return;
    }
#endif
    
    [db beginTransaction];
    
#if DB_TRACE_EXECUTION
    [db setTraceExecution:YES];
#endif
    
    /* execute the update */
    [db executeUpdate:@"update sessions set iFrameNumber = ?, iPattern = ?, iAspectRatio = ?, fInnerRadius = ?, fOuterRadius = ?,fFrameWidth = ?,bPatternSelected = ?,fRed = ?,fGreen = ?,fBlue = ?,fAlpha = ?,shadowEffectValue = ? where iSessionId = ?",
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
     [NSNumber numberWithFloat:shadowEffectValue];
    
    /* commit the transaction */
    [db commit];
    
    /* close the database */
    [db close];
    
    return;
}

- (void)addPhotosToTheFrame:(Frame*)frm
{
    NSLog(@"************************************************************ 2 add  photto");
    int index = 0;
    
    for(index = 0; index < frm.photoCount; index++)
    {
        Photo *pht = [frm getPhotoAtIndex:index];
        if(nil == pht)
        {
            NSLog(@"addPhotosToTheFrame:Something is seriusly wrong,photo not found");
            continue;
        }
       
        UIImage *img = [self getOriginalImageAtIndex:index]; //[self getImageAtIndex:index];
        if(nil != img)
        {
            if( [self getFrameResourceTypeAtIndex:index] == FRAME_RESOURCE_TYPE_PHOTO)
            {
//                if(pht.image == nil)
//                {
                    pht.muteAudio = YES;
                    pht.videoURL = nil;
                    NSLog(@"Photo setImage is called from here 4");
                    pht.image = img;
                    pht.isContentTypeVideo = NO;
               // }
            }
            else
            {
                NSLog(@"pht = %@, class = %@", pht, NSStringFromClass([pht class]));
                NSURL *videoURL;
                NSString *effectPath = [self pathToEffectVideoAtIndex:index];
                NSString *videoPath = [self getVideoUrlForPhotoAtIndex:index].path;
                if([[NSFileManager defaultManager]fileExistsAtPath:effectPath])
                {
                    NSLog(@"effect video path ");
                    pht.image = img;
                    pht.muteAudio = [self getAudioMuteValueForPhotoAtIndex:index];
                    pht.isContentTypeVideo = YES;
                    videoURL = [NSURL fileURLWithPath:effectPath];
                    pht.videoURL = videoURL;
                }
                else if([[NSFileManager defaultManager]fileExistsAtPath:videoPath])
                {
                    NSLog(@"video path ");
                    pht.muteAudio = [self getAudioMuteValueForPhotoAtIndex:index];
                    videoURL = [self getVideoUrlForPhotoAtIndex:index];
                    NSLog(@"video url is = %@",videoURL);
                    pht.videoURL = videoURL;
                    pht.isContentTypeVideo = YES;
                    pht.image = img;
                }
                
                
                
                
            }
            NSLog(@" it is video == photoFromFrame.is Content TypeVideo %@",pht.isContentTypeVideo?@"YES":@"NO");
            
        }
        else
        {
            //NSLog(@"Image at index %d is nil to add to the photo",index);
        }
    }
    
}



- (int)frameNumber
{
    return iFrameNumber;
}

- (void)setFrameNumber:(int)FrameNumber
{
    NSLog(@"set frame number ");
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
     //   [_frame release];
        _frame = nil;
    }
    
    /* allocate the new frame */
    _frame = [[Frame alloc]initWithFrameNumber:FrameNumber];
    
    
    [self deletePhotosAndAdjustors];
    
    /*initialize the dimension table and shapes table with photos and adjustors */
    [self addPhotosAndAdjustorsFromFrame:_frame];
    
    /* configure the frame */
    [_frame setWidth:DEFAULT_FRAMEWIDTH];
    
//    if(!self.initialization)
//    {
        NSLog(@"Let initialisation be true");
        /* add photos to the frame */
        [self addPhotosToTheFrame:_frame];
  //  }
    
    [self updateSessionInDB];
    
    return;
}

- (int)sessionId
{
    return iSessionId;
}

- (void)setSessionId:(int)sessionId
{
    iSessionId = sessionId;
    
    [self updateSessionInDB];
    
    return;
}

- (BOOL)patternSelected
{
    return bPatternSelected;
}

- (UIColor*)color
{
    UIColor *clr = [UIColor colorWithRed:sColor.fRed green:sColor.fGreen blue:sColor.fBlue alpha:sColor.fAlpha];
    
    return clr;
}

- (void)setColor:(UIColor *)color
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
- (void)setImage:(UIImage *)image
{
    bPatternSelected = NO;
    
    [_frame setImage:image];
}
- (int)pattern
{
    return iPattern;
}

- (void)setPattern:(int)pattern
{
    iPattern = pattern;
    
    [self handleVideoFrameSettingsUpdate];
    
    /* make sure that we set the pattern selected as YES */
    bPatternSelected = YES;
    
    [_frame setPattern:pattern];
    
    [self updateSessionInDB];
    
    return;
}

- (float)getInnerRadius
{
    return fInnerRadius;
}

-(void)setShadowValue:(float)val cornerRad:(int)initialValue

{
    [self handleVideoFrameSettingsUpdate];
    
     shadowEffectValue= val;
    //NSLog(@"setInnerRadius : %f",innerRadius);
    /* Update frame inner radius */
    [_frame setShadowEffect:val cornerRadious:initialValue];
    
    //[self updateSessionInDB];
    
    return;
}

- (void)setInnerRadius:(float)innerRadius
{
    [self handleVideoFrameSettingsUpdate];
    
    fInnerRadius = innerRadius;
    //NSLog(@"setInnerRadius : %f",innerRadius);
    /* Update frame inner radius */
    [_frame setInnerRadius:innerRadius];
    
    [self updateSessionInDB];
    
    return;
}

- (float)getOuterRadius
{
    return fOuterRadius;
}

- (void)setOuterRadius:(float)outerRadius
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


-(float)getShadowValue
{
    return shadowEffectValue;
}

-(float)getFrameWidth
{
    return fFrameWidth;
}

- (void)setPhotoWidth:(float)photoWidth
{
    [self handleVideoFrameSettingsUpdate];
    
    fFrameWidth = photoWidth;
    
    /* Update Frame Width */
    [_frame setPhotoWidth:photoWidth];
    NSLog(@"frame width is %f",photoWidth);
    
    [self updateSessionInDB];
    
    return;
}

- (void)setFrameWidth:(float)frameWidth
{
    [self handleVideoFrameSettingsUpdate];
    
    fFrameWidth = frameWidth;
    
    /* Update Frame Width */
    [_frame setWidth:frameWidth];
    
    [self updateSessionInDB];
    
    return;
}

- (int)aspectRatio
{
    return iAspectRatio;
}

- (void)initAspectRatio:(int)aspectRatio
{
    [self handleVideoFrameSettingsUpdate];
    
    nvm = [Settings Instance];
    
    iAspectRatio = aspectRatio;
    nvm.aspectRatio = aspectRatio;
    
    UIView *sView   = [_frame superview];
    self.innerRadius = fInnerRadius;
    self.outerRadius = fOuterRadius;
    self.frameWidth  = fFrameWidth;
    self.shadowEffectValue=shadowEffectValue;
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
    
    [self updateSessionInDB];
    
    return;
}


- (void)setAspectRatio:(int)aspectRatio
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllVideoPlayer" object:nil userInfo:nil];
    NSLog(@"Removed all preview player");
    [self handleVideoFrameSettingsUpdate];
    
    nvm = [Settings Instance];
    
    iAspectRatio = aspectRatio;
    nvm.aspectRatio = aspectRatio;
    
    UIView *sView   = [_frame superview];
    NSLog(@"set Aspect Ratio frameNumber %d iFrameNumber %d",self.frameNumber,iFrameNumber);
    self.initialization = NO;
    self.frameNumber = iFrameNumber;
    self.innerRadius = fInnerRadius;
    self.outerRadius = fOuterRadius;
    self.frameWidth  = fFrameWidth;
    self.shadowEffectValue=shadowEffectValue;
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
    
    [self updateSessionInDB];
    
    return;
}

@end
