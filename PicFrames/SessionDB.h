//
//  SessionDB.h
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 3/9/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "FMDatabase.h"
#import "DBUtilities.h"
#import "Session.h"

@interface SessionDB : NSObject


+(int)getThePhotoInfoForSessionId:(int)sessId to:(stPhotoInfo**)photoInfo;
+(int)getTheAdjustorInfoForSessionId:(int)sessId to:(stAdjustorInfo**)adjustorInfo;
+(int)getTheImageInfoForSessionId:(int)sessId to:(stImageInfo**)imgInfo;
+(BOOL)updateImageSizeInDBWith:(CGSize)size atIndex:(int)index forSession:(int)sessId;
/*+(BOOL)updateResourceSizeInDBWith:(CGSize)size
                          atIndex:(int)index
                           ofType:(int)eType
                           atPath:(NSString*)path
                       forSession:(int)sessId;*/
+(BOOL)updateImageScaleInDBWith:(float)scale offset:(CGPoint)offset atIndex:(int)index forSession:(int)sessId;
+(BOOL)deleteSessionDimensionsOfId:(int)sessId;
+(BOOL)deleteSessionOfId:(int)sessId;
+(int)printTableForSessionId:(int)sessId;
@end
