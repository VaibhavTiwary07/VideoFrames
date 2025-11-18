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

// ============================================================================
// DEPRECATION NOTICE
// ============================================================================
// This class is DEPRECATED as of Phase 4.
// Use SessionRepository instead (PicFrames/Repositories/SessionRepository.h)
//
// Reasons for deprecation:
// - No error handling (silent failures)
// - Manual memory management (malloc/free)
// - No type safety (void** pointers)
// - Difficult to test (static methods)
// - SQL mixed with data access logic
//
// Migration Guide: See PHASE4_DEPRECATION.md
// ============================================================================

NS_DEPRECATED_IOS(2_0, 14_0, "Use SessionRepository instead. See PHASE4_DEPRECATION.md for migration guide.")
@interface SessionDB : NSObject


// Photo/Adjustor/Image Info Methods
+(int)getThePhotoInfoForSessionId:(int)sessId to:(stPhotoInfo**)photoInfo
    DEPRECATED_MSG_ATTRIBUTE("Use SessionRepository getPhotoInfoForSession:error: instead");

+(int)getTheAdjustorInfoForSessionId:(int)sessId to:(stAdjustorInfo**)adjustorInfo
    DEPRECATED_MSG_ATTRIBUTE("Use SessionRepository getAdjustorInfoForSession:adjustorInfo:error: instead");

+(int)getTheImageInfoForSessionId:(int)sessId to:(stImageInfo**)imgInfo
    DEPRECATED_MSG_ATTRIBUTE("Use SessionRepository getImageInfoForSession:error: instead");

// Update Methods
+(BOOL)updateImageSizeInDBWith:(CGSize)size atIndex:(int)index forSession:(int)sessId
    DEPRECATED_MSG_ATTRIBUTE("Use SessionRepository updateImageSize:atPhotoIndex:forSession:error: instead");

+(BOOL)updateImageScaleInDBWith:(float)scale offset:(CGPoint)offset atIndex:(int)index forSession:(int)sessId
    DEPRECATED_MSG_ATTRIBUTE("Use SessionRepository updateImageScale:offset:atPhotoIndex:forSession:error: instead");

// Delete Methods
+(BOOL)deleteSessionDimensionsOfId:(int)sessId
    DEPRECATED_MSG_ATTRIBUTE("Use SessionRepository deleteSessionDimensions:error: instead");

+(BOOL)deleteSessionOfId:(int)sessId
    DEPRECATED_MSG_ATTRIBUTE("Use SessionRepository deleteSession:error: instead");

// Debug Methods
+(int)printTableForSessionId:(int)sessId
    DEPRECATED_MSG_ATTRIBUTE("Use SessionRepository for debugging instead");
@end
