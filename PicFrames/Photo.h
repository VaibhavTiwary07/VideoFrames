//
//  Photo.h
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Settings.h"
//#import "UIImageView+Shapes.h"
#import "ssivView.h"
#import "AVPlayerDemoPlaybackView.h"

@interface Photo : NSObject <UIScrollViewDelegate,touchDetectProtocol>
{
    int iPhotoNumber;
    ssivView *view;
    //AVPlayerDemoPlaybackView *view;
    CGRect _frame;
    UIImage *_image;
    CGRect _actualFrame;
    CGRect _contentFrame;
    float _scale;
    CGPoint _offset;
    float rowCount;
    float colCount;
    float rowIndex;
    float colIndex;
}

//properties
@property(nonatomic,readonly)CGRect contentFrame;
@property(nonatomic,readwrite)CGRect actualFrame;
@property(nonatomic,readwrite)int photoNumber;
@property(nonatomic,readwrite)CGRect frame;
@property(nonatomic,assign) ssivView *view;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,readwrite)float scale;
@property(nonatomic,readwrite)CGPoint offset;
@property(nonatomic,readwrite)float rowCount;
@property(nonatomic,readwrite)float colCount;
@property(nonatomic,readwrite)float rowIndex;
@property(nonatomic,readwrite)float colIndex;
@property(nonatomic,readwrite)BOOL noTouchMode;

//Methods
- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor*)clr;

-(void)setTheImageToBlank;
-(void)notifyAsSwapFrom;
-(void)notifyAsSwapTo;

-(void)releaseAllResources;
-(void)setEditedImage:(UIImage *)image;
@end
