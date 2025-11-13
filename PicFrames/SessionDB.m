//
//  SessionDB.m
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 3/9/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "SessionDB.h"

@implementation SessionDB

+(int)printTableForSessionId:(int)sessId
{
    int count = 0;
    int iPhotoCount = 0;
    FMResultSet *photos  = nil;
    
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
    
    photos = [db executeQuery:@"select * from sessiondimensions where sessionId = ?",[NSNumber numberWithInt:sessId]];
    if(nil == photos)
    {
        NSLog(@"getThePhotoInfoForSessionId:Could not get photos from frames table");
        [db close];
        return 0;
    }
    
   // @"insert into sessiondimensions (sessionId, photoIndex, type, photo_x, photo_y, photo_width, photo_height) values (?,?,?,?,?,?,?)"
    /* browse to the row based on index */
    while([photos next])
    {
        /* check if the session really exist */
        if([photos intForColumn:@"sessionId"] == sessId)
        {
            NSLog(@"******Photo %d*******",count+1);
            NSLog(@"session id: %d",[photos intForColumn:@"sessionId"]);
            NSLog(@"photo id: %d",[photos intForColumn:@"photoIndex"]);
            NSLog(@"type: %d",[photos intForColumn:@"type"]);
            NSLog(@"Frame (%f,%f,%f,%f)",[photos doubleForColumn:@"photo_x"],[photos doubleForColumn:@"photo_y"],[photos doubleForColumn:@"photo_width"],[photos doubleForColumn:@"photo_height"]);
            NSLog(@"Image Size (%f,%f)",[photos doubleForColumn:@"img_width"],[photos doubleForColumn:@"img_height"]);
            NSLog(@"Image Scale %f, Offset(%f,%f)",[photos doubleForColumn:@"img_scale"],[photos doubleForColumn:@"img_offset_x"],[photos doubleForColumn:@"img_offset_y"]);
            
            count++;
        }
    }
    
    [photos close];
    [db close];
    
    return iPhotoCount;
}

+(int)getThePhotoInfoForSessionId:(int)sessId to:(stPhotoInfo**)photoInfo
{
    int count = 0;
    int iPhotoCount = 0;
    FMResultSet *photos  = nil;
    FMResultSet *photoCount = nil;
    
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
    
    /* First get the count of photos */
    photoCount = [db executeQuery:@"select COUNT(sessionId) as photocount from sessiondimensions where sessionId = ? and type = ?",[NSNumber numberWithInt:sessId],[NSNumber numberWithInt:0]];
    if(nil == photoCount)
    {
        NSLog(@"getThePhotoInfoForSessionId:Could not get photo count");
        [db close];
        return 0;
    }
    
    while([photoCount next])
    {
        iPhotoCount = [photoCount intForColumn:@"photocount"];
    }
    
    [photoCount close];
    
    photos = [db executeQuery:@"select * from sessiondimensions where sessionId = ? and type = ?",[NSNumber numberWithInt:sessId],[NSNumber numberWithInt:0]];
    if(nil == photos)
    {
        NSLog(@"getThePhotoInfoForSessionId:Could not get photos from frames table");
        [db close];
        return 0;
    }
    
    /* Allocate memory for the photo information */
    stPhotoInfo *PInfo = (stPhotoInfo*)malloc(sizeof(stPhotoInfo) * iPhotoCount);
    if(NULL == PInfo)
    {
        NSLog(@"getThePhotoInfoForSessionId:Failed to allocate memory for photos");
        [db close];
        return 0;
    }
    
    /* browse to the row based on index */
    while([photos next])
    {
        /* check if the session really exist */
        if([photos intForColumn:@"sessionId"] == sessId)
        {
            PInfo[count].dimension.origin.x = [photos intForColumn:@"photo_x"];
            PInfo[count].dimension.origin.y = [photos intForColumn:@"photo_y"];
            PInfo[count].dimension.size.width = [photos intForColumn:@"photo_width"];
            PInfo[count].dimension.size.height = [photos intForColumn:@"photo_height"];
            
            count++;
        }
    }
    
    [photos close];
    [db close];
    
    *photoInfo = PInfo;
    
    return iPhotoCount;
}

+(int)getTheAdjustorInfoForSessionId:(int)sessId to:(stAdjustorInfo**)adjustorInfo
{
    int count = 0;
    int iAdjustorCount = 0;
    FMResultSet *adjustors  = nil;
    FMResultSet *adjustorCount = nil;
    
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
    
    /* First get the count of photos */
    adjustorCount = [db executeQuery:@"select COUNT(sessionId) as photocount from sessiondimensions where sessionId = ? and type = ?",[NSNumber numberWithInt:sessId],[NSNumber numberWithInt:1]];
    if(nil == adjustorCount)
    {
        NSLog(@"getTheAdjustorInfoForSessionId:Could not get adjustor count");
        [db close];
        return 0;
    }
    
    while([adjustorCount next])
    {
        iAdjustorCount = [adjustorCount intForColumn:@"photocount"];
    }
    
    [adjustorCount close];
    
    adjustors = [db executeQuery:@"select * from sessiondimensions where sessionId = ? and type = ?",[NSNumber numberWithInt:sessId],[NSNumber numberWithInt:1]];
    if(nil == adjustors)
    {
        NSLog(@"getTheAdjustorInfoForSessionId:Could not get adjustors from frames table");
        [db close];
        return 0;
    }
    
    /* Allocate memory for the photo information */
    stAdjustorInfo *AInfo = (stAdjustorInfo*)malloc(sizeof(stAdjustorInfo) * iAdjustorCount);
    if(NULL == AInfo)
    {
        NSLog(@"getTheAdjustorInfoForSessionId:Failed to allocate memory for adjustors");
        [db close];
        return 0;
    }
    
    /* browse to the row based on index */
    while([adjustors next])
    {
        /* check if the session really exist */
        if([adjustors intForColumn:@"sessionId"] == sessId)
        {
            AInfo[count].dimension.origin.x    = [adjustors intForColumn:@"photo_x"];
            AInfo[count].dimension.origin.y    = [adjustors intForColumn:@"photo_y"];
            AInfo[count].dimension.size.width  = [adjustors intForColumn:@"photo_width"];
            AInfo[count].dimension.size.height = [adjustors intForColumn:@"photo_height"];
            
            count++;
        }
    }
    
    [adjustors close];
    [db close];
    
    *adjustorInfo = AInfo;
    
    return iAdjustorCount;
}

+(int)getTheImageInfoForSessionId:(int)sessId to:(stImageInfo**)imgInfo
{
    int count = 0;
    int iPhotoCount = 0;
    FMResultSet *photos  = nil;
    FMResultSet *photoCount = nil;
    
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
  
    /* First get the count of photos */
    photoCount = [db executeQuery:@"select COUNT(sessionId) as photocount from sessiondimensions where sessionId = ? and type = ?",[NSNumber numberWithInt:sessId],[NSNumber numberWithInt:0]];
    if(nil == photoCount)
    {
        NSLog(@"getTheImageInfoForSessionId:Could not get photo count");
        [db close];
        return 0;
    }
    
    while([photoCount next])
    {
        iPhotoCount = [photoCount intForColumn:@"photocount"];
    }
    
    [photoCount close];
    
    photos = [db executeQuery:@"select * from sessiondimensions where sessionId = ? and type = ?",[NSNumber numberWithInt:sessId],[NSNumber numberWithInt:0]];
    if(nil == photos)
    {
        NSLog(@"getTheImageInfoForSessionId:Could not get photos from frames table");
        [db close];
        return 0;
    }
    
    /* Allocate memory for the photo information */
    stImageInfo *PInfo = (stImageInfo*)malloc(sizeof(stImageInfo) * iPhotoCount);
    if(NULL == PInfo)
    {
        NSLog(@"getTheImageInfoForSessionId:Failed to allocate memory for photos");
        [db close];
        return 0;
    }
    
    /* browse to the row based on index */
    while([photos next])
    {
        /* check if the session really exist */
        if([photos intForColumn:@"sessionId"] == sessId)
        {
            PInfo[count].imageSize.width = [photos doubleForColumn:@"img_width"];
            PInfo[count].imageSize.height = [photos doubleForColumn:@"img_height"];
            PInfo[count].scale = [photos doubleForColumn:@"img_scale"];
            PInfo[count].rotation = [photos doubleForColumn:@"img_rotation"];
            PInfo[count].offset.x = [photos doubleForColumn:@"img_offset_x"];
            PInfo[count].offset.y = [photos doubleForColumn:@"img_offset_y"];
            
            count++;
            
            //NSLog(@"getTheImageInfoForSessionId: photo %d sess %d scale(%f) offset(%f,%f) sze(%f,%f)",count,sessId,PInfo[count-1].scale,PInfo[count-1].offset.x,PInfo[count-1].offset.y,PInfo[count-1].imageSize.width,PInfo[count-1].imageSize.height);
        }
    }
    
    [photos close];
    [db close];
    
    *imgInfo = PInfo;
    
    return iPhotoCount;
}
/*
+(BOOL)updateResourceSizeInDBWith:(CGSize)size
                          atIndex:(int)index
                           ofType:(int)eType
                           atPath:(NSString*)path
                       forSession:(int)sessId*/
+(BOOL)updateImageSizeInDBWith:(CGSize)size atIndex:(int)index forSession:(int)sessId;
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
    //NSString *videoPath    = path;
    /* First make sure that database is copied to filesystem */
    [DBUtilities checkAndCreateDatabase];
    
    /* open the database */
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) 
    {
     //   [db release];
        NSLog(@"openDataBase:Could not open db.");
        return NO;
    }
#endif
    
    /* Get The path */
    //if(nil == videoPath)
    //{
    //    videoPath = @"NA";
    //}
    
    /* begin transaction */
    [db beginTransaction];
#if DB_TRACE_EXECUTION    
    [db setTraceExecution:YES];
#endif
    [db executeUpdate:@"update sessiondimensions set img_width = ?, img_height = ? where sessionId = ? and photoindex = ? and type = ?",[NSNumber numberWithFloat:size.width],[NSNumber numberWithFloat:size.height],[NSNumber numberWithInt:sessId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:0]];
    
    /* commit the update */
    [db commit];
    
    /* we are done with delete, so close the databse */
    [db close];
    
    return YES;
}

+(BOOL)updateImageScaleInDBWith:(float)scale offset:(CGPoint)offset atIndex:(int)index forSession:(int)sessId
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
       // [db release];
        NSLog(@"openDataBase:Could not open db.");
        return NO;
    }
#endif
    
    /* begin transaction */
    [db beginTransaction];
#if DB_TRACE_EXECUTION    
    [db setTraceExecution:YES];
#endif
    [db executeUpdate:@"update sessiondimensions set img_scale = ?, img_offset_x = ?, img_offset_y = ? where sessionId = ? and photoindex = ? and type = ?",[NSNumber numberWithFloat:scale],[NSNumber numberWithFloat:offset.x],[NSNumber numberWithFloat:offset.y],[NSNumber numberWithInt:sessId],[NSNumber numberWithInt:index],[NSNumber numberWithInt:0]];
    
    /* commit the update */
    [db commit];
    
    /* we are done with delete, so close the databse */
    [db close];
    
    return YES;
}

+(BOOL)deleteSessionDimensionsOfId:(int)sessId
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
        return NO;
    }
#endif
    
    /* begin transaction */
    [db beginTransaction];
#if DB_TRACE_EXECUTION    
    [db setTraceExecution:YES];
#endif
    
    /* delete the rows */
    [db executeUpdate:@"delete from sessiondimensions where sessionId = ?",[NSNumber numberWithInt:sessId]];
    
    /* commit the update */
    [db commit];
    
    /* we are done with delete, so close the databse */
    [db close];
    
    return TRUE;
}

+(BOOL)deleteSessionOfId:(int)sessId
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
        return NO;
    }
#endif
    
    /* begin transaction */
    [db beginTransaction];
#if DB_TRACE_EXECUTION    
    [db setTraceExecution:YES];
#endif
    
    /* delete the rows */
    [db executeUpdate:@"delete from sessions where iSessionId = ?",[NSNumber numberWithInt:sessId]];
    
    /* commit the update */
    [db commit];
    
    /* we are done with delete, so close the databse */
    [db close];
    
    return TRUE;
}

@end
