//
//  FrameButton.h
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 3/18/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#import "Frame.h"

@protocol FrameButtonDelegate;

@interface FrameButton : UIImageView
{
    __weak id<FrameButtonDelegate>	delegate;
}

@property(nonatomic,weak)id<FrameButtonDelegate>	delegate;

-(id)initWithFrameNumber:(int)frameNumber andFrame:(CGRect)frame;
@end

@protocol FrameButtonDelegate
-(void)frameSelected:(FrameButton*)fb;
@end
