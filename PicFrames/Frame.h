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
#import "ssivView.h"
#import "ServiceContainer.h"
#import "FrameRepository.h"
//#import "Session.h"

#define MAX_PHOTOS_SUPPORTED 5
#define ENABLE_SWAP_ANIMATION

@interface Frame : UIImageView
{
    NSMutableArray *photos;
    NSMutableArray *adjustors;
      NSMutableArray *uiViews;
    ssivView *ssivView;

}

//Properties
@property(nonatomic,readonly)int photoCount;
@property(nonatomic,readonly)int adjustorCount;
@property(nonatomic,readonly)int viewcount;

// Modern dependency injection - repository for data access
@property (nonatomic, strong) FrameRepository *frameRepository;

//Methods
-(id)initWithFrameNumber:(int)frameNumber;
-(id)initWithFrameNumber:(int)frameNumber withBgColor:(UIColor *)clr;
-(void)setPattern:(int)patternNumber;
-(void)setColor:(UIColor*)color;
//-(void)setImage:(UIImage *)image;
-(void)setWidth:(int)width;
-(void)setOuterRadius:(int)radius;
-(void)setInnerRadius:(int)radius;
-(void)setAspectRatio:(eAspectRatio)ratio;
//-(void)loadPhotosFromSession:(Session*)sess;
-(Photo*)getPhotoAtIndex:(int)index;
//-(UIView *)getViewAtIndex:(int)index;
-(Adjustor*)getAdjustorAtIndex:(int)index;
-(UIImage*)renderToImageOfScale:(float)scale;
-(UIImage*)renderToImageOfSize:(CGSize)sze;
-(void)setPhotoWidth:(int)width;
- (UIImage*)quickRenderToImageOfSize:(CGSize)sze;
-(void)setShadowEffect:(float)opacity cornerRadious:(float)rValue;
-(void)enterSwapMode;
-(void)exitSwapMode;
-(void)hideInfoTextView;

@end
