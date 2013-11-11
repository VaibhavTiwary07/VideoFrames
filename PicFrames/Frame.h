//
//  Frame.h
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Config.h"
#import "Photo.h"
#import "Adjustor.h"
#import "FrameDB.h"
#import "Utility.h"
#import "Settings.h"
//#import "Session.h"

#define MAX_PHOTOS_SUPPORTED 5
#define ENABLE_SWAP_ANIMATION

@interface Frame : UIImageView
{
    NSMutableArray *photos;
    NSMutableArray *adjustors;
}

//Properties
@property(nonatomic,readonly)int photoCount;
@property(nonatomic,readonly)int adjustorCount;

//Methods
-(id)initWithFrameNumber:(int)frameNumber;
-(id)initWithFrameNumber:(int)frameNumber withBgColor:(UIColor *)clr;
-(void)setPattern:(int)patternNumber;
-(void)setColor:(UIColor*)color;
-(void)setWidth:(int)width;
-(void)setOuterRadius:(int)radius;
-(void)setInnerRadius:(int)radius;
-(void)setAspectRatio:(eAspectRatio)ratio;
//-(void)loadPhotosFromSession:(Session*)sess;
-(Photo*)getPhotoAtIndex:(int)index;
-(Adjustor*)getAdjustorAtIndex:(int)index;
-(UIImage*)renderToImageOfScale:(float)scale;
-(UIImage*)renderToImageOfSize:(CGSize)sze;
-(void)setPhotoWidth:(int)width;
- (UIImage*)quickRenderToImageOfSize:(CGSize)sze;

-(void)enterSwapMode;
-(void)exitSwapMode;

@end
