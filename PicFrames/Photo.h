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
    int viewNumber;
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
    NSURL *_videoURL;
}

//properties
@property(nonatomic,readonly)CGRect contentFrame;
@property(nonatomic,readwrite)CGRect actualFrame;
@property(nonatomic,readwrite)int photoNumber;
@property(nonatomic,readwrite)int viewNumber;
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
// REMOVED: effectTouchMode - now managed by MainController.isInEffectMode
// REMOVED: photoSelectionMode - redundant, isSelected is sufficient
@property(nonatomic,readwrite)BOOL isContentTypeVideo;
@property(nonatomic,readwrite)BOOL muteAudio;
@property(nonatomic,readwrite)float videoVolume;
@property(nonatomic,readwrite)float videoSpeed;
@property(nonatomic,readwrite)double videoTrimStart;
@property(nonatomic,readwrite)double videoTrimEnd;
@property(nonatomic,readwrite)BOOL isSelected;
@property(nonatomic,strong)UIImageView *addIconView;
@property (nonatomic, strong, nullable) NSURL *videoURL; // Remove custom getter/setter if possible
@property (nonatomic, strong, nullable) NSURL *additionalAudioURL;
//Methods
- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor*)clr;

-(void)setTheImageToBlank;
-(void)notifyAsSwapFrom;
-(void)notifyAsSwapTo;

-(void)releaseAllResources;
-(void)setEditedImage:(UIImage *)image;
-(void)applyVideoSpeed:(float)speed;
-(void)applyVideoTrimWithStart:(double)startTime end:(double)endTime;

// Production-grade state management methods
-(void)deleteContent;
-(void)replaceWithVideo:(NSURL *)newVideoURL;
-(void)replaceWithImage:(UIImage *)newImage;

// REMOVED: enterPhotoSelectionMode and exitPhotoSelectionMode
// These methods are now in Session.m only (single source of truth)

@end
