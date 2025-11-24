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

@interface FrameDB : NSObject
{
    
}

+(int)getThePhotoInfoForFrameNumber:(int)FrameNumber to:(stPhotoInfo**)photoInfo;
+(int)getTheAdjustorInfoForFrameNumber:(int)FrameNumber to:(stAdjustorInfo**)adjustorInfo;
+(int)getPhotoCountForFrameNumber:(int)FrameNumber;

@end
