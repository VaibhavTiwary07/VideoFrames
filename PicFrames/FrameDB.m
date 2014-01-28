//
//  FrameDB.m
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FrameDB.h"

@implementation FrameDB

#if 0
+(int)getThePhotoInfoForFrameNumber:(int)FrameNumber to:(stPhotoInfo**)photoInfo;
{
    int count = 0;
    
#if 1
    stPhotoInfo *PInfo = (stPhotoInfo*)malloc(sizeof(stPhotoInfo)*3);
    if(NULL == PInfo)
    {
        return 0;
    }
    
    PInfo[0].dimension = CGRectMake(10.0, 10.0, 135.0, 165.0);
    PInfo[1].dimension = CGRectMake(155.0, 10.0, 135.0, 165.0);
    PInfo[2].dimension = CGRectMake(10.0, 185.0, 280.0, 165.0);
    
    count = 3;
#else
    stPhotoInfo *PInfo = (stPhotoInfo*)malloc(sizeof(stPhotoInfo)*2);
    if(NULL == PInfo)
    {
        return 0;
    }
    
    PInfo[0].dimension = CGRectMake(10.0, 10.0, 280.0, 165.0);
    //PInfo[1].dimension = CGRectMake(155.0, 10.0, 135.0, 165.0);
    PInfo[1].dimension = CGRectMake(10.0, 185.0, 280.0, 165.0);
    
    count = 2;
#endif
    
    
    *photoInfo = PInfo;
    
    return count;
}

+(int)getTheAdjustorInfoForFrameNumber:(int)FrameNumber to:(stAdjustorInfo**)adjustorInfo
{
    stAdjustorInfo *AInfo = NULL;
#if 0    
    AInfo = (stAdjustorInfo*)malloc(sizeof(stAdjustorInfo));
    if(NULL == AInfo)
    {
        return 0;
    }
    
    AInfo[0].dimension = CGRectMake(10.0, 173.0, 280.0, 14.0);
    
    *adjustorInfo = AInfo;
    
    return 1;
#else
    AInfo = (stAdjustorInfo*)malloc(sizeof(stAdjustorInfo)*2);
    if(NULL == AInfo)
    {
        return 0;
    }
    
    AInfo[0].dimension = CGRectMake(143.0, 10.0, 14.0, 165.0);
    AInfo[1].dimension = CGRectMake(10.0, 173.0, 280.0, 14.0);
    
    *adjustorInfo = AInfo;
    
    return 2;
    
#endif
}
#else
+(int)getThePhotoInfoForFrameNumber:(int)FrameNumber to:(stPhotoInfo**)photoInfo;
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
        [db release];
        NSLog(@"openDataBase:Could not open db.");
        return 0;
    }
#endif
    /* First get the count of photos */
    photoCount = [db executeQuery:@"select COUNT(iFrameNumber) as photocount from frames where iFrameNumber = ? and type = ?",[NSNumber numberWithInt:FrameNumber],[NSNumber numberWithInt:0]];
    if(nil == photoCount)
    {
        NSLog(@"getThePhotoInfoForFrameNumber:Could not get photo count");
        [db close];
        return 0;
    }
    
    while([photoCount next])
    {
        iPhotoCount = [photoCount intForColumn:@"photocount"];
    }
    
    [photoCount close];
    
    photos = [db executeQuery:@"select * from frames where iFrameNumber = ? and type = ?",[NSNumber numberWithInt:FrameNumber],[NSNumber numberWithInt:0]];
    if(nil == photos)
    {
        NSLog(@"getThePhotoInfoForFrameNumber:Could not get photos from frames table");
        [db close];
        return 0;
    }
    
    /* Allocate memory for the photo information */
    stPhotoInfo *PInfo = (stPhotoInfo*)malloc(sizeof(stPhotoInfo) * iPhotoCount);
    if(NULL == PInfo)
    {
        NSLog(@"getThePhotoInfoForFrameNumber:Failed to allocate memory for photos");
        [db close];
        return 0;
    }
    
    /* browse to the row based on index */
    while([photos next])
    {
        /* check if the session really exist */
        if([photos intForColumn:@"iFrameNumber"] == FrameNumber)
        {
            PInfo[count].dimension.origin.x = [photos intForColumn:@"x"];
            PInfo[count].dimension.origin.y = [photos intForColumn:@"y"];
            PInfo[count].dimension.size.width = [photos intForColumn:@"width"];
            PInfo[count].dimension.size.height = [photos intForColumn:@"height"];
            
            if(NO == [photos columnIsNull:@"shape"])
            {
                PInfo[count].eFrameShape = [photos intForColumn:@"shape"];
                //NSLog(@"Shape is not NULL");
            }
            else
            {
                PInfo[count].eFrameShape = SHAPE_NOSHAPE;
            }
            count++;
        }
    }
    
    [photos close];
    //[photos release];
    [db close];
    
    *photoInfo = PInfo;
    
    return iPhotoCount;
}



+(int)getTheAdjustorInfoForFrameNumber:(int)FrameNumber to:(stAdjustorInfo**)adjustorInfo
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
        NSLog(@"getTheAdjustorInfoForFrameNumber:Could not open db.");
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
    /* First get the count of photos */
    adjustorCount = [db executeQuery:@"select COUNT(iFrameNumber) as photocount from frames where iFrameNumber = ? and type = ?",[NSNumber numberWithInt:FrameNumber],[NSNumber numberWithInt:1]];
   
    
    if(nil == adjustorCount)
    {
        NSLog(@"getTheAdjustorInfoForFrameNumber:Could not get adjustor count");
        [db close];
        return 0;
    }
    
    while([adjustorCount next])
    {
        iAdjustorCount = [adjustorCount intForColumn:@"photocount"];
    }
    
    [adjustorCount close];
    
    adjustors = [db executeQuery:@"select * from frames where iFrameNumber = ? and type = ?",[NSNumber numberWithInt:FrameNumber],[NSNumber numberWithInt:1]];
    if(nil == adjustors)
    {
        NSLog(@"getTheAdjustorInfoForFrameNumber:Could not get adjustors from frames table");
        [db close];
        return 0;
    }
    
    /* Allocate memory for the photo information */
    stAdjustorInfo *AInfo = (stAdjustorInfo*)malloc(sizeof(stAdjustorInfo) * iAdjustorCount);
    if(NULL == AInfo)
    {
        NSLog(@"getTheAdjustorInfoForFrameNumber:Failed to allocate memory for adjustors");
        [db close];
        return 0;
    }
    
    /* browse to the row based on index */
    while([adjustors next])
    {
        /* check if the session really exist */
        if([adjustors intForColumn:@"iFrameNumber"] == FrameNumber)
        {
            AInfo[count].dimension.origin.x    = [adjustors intForColumn:@"x"];
            AInfo[count].dimension.origin.y    = [adjustors intForColumn:@"y"];
            AInfo[count].dimension.size.width  = [adjustors intForColumn:@"width"];
            AInfo[count].dimension.size.height = [adjustors intForColumn:@"height"];
            
            count++;
        }
    }
    
    [adjustors close];
    [db close];
    
    *adjustorInfo = AInfo;
    
    return iAdjustorCount;
}
#endif
@end
