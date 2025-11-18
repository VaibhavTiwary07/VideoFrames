//
//  FrameDB.h
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "DBUtilities.h"

// ============================================================================
// DEPRECATION NOTICE
// ============================================================================
// This class is DEPRECATED as of Phase 4.
// Use FrameRepository instead (PicFrames/Repositories/FrameRepository.h)
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

NS_DEPRECATED_IOS(2_0, 14_0, "Use FrameRepository instead. See PHASE4_DEPRECATION.md for migration guide.")
@interface FrameDB : NSObject
{

}

// Frame Template Data Access Methods
+(int)getThePhotoInfoForFrameNumber:(int)FrameNumber to:(stPhotoInfo**)photoInfo
    DEPRECATED_MSG_ATTRIBUTE("Use FrameRepository getPhotoInfoForFrame:error: instead");

+(int)getTheAdjustorInfoForFrameNumber:(int)FrameNumber to:(stAdjustorInfo**)adjustorInfo
    DEPRECATED_MSG_ATTRIBUTE("Use FrameRepository getAdjustorInfoForFrame:adjustorInfo:error: instead");

@end
