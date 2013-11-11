//
//  TouchView.h
//  MirroCamFx
//
//  Created by Vijaya kumar reddy Doddavala on 10/30/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AVPlayerDemoPlaybackView.h"
@protocol touchDetectProtocol <NSObject>
@optional
-(void)touchDetected:(UITouch*)t;
-(void)singleTapDetected:(UITouch*)t;
-(void)doubleTapDetected:(UITouch*)t;
@end

@class AVPlayer;
@interface TouchDetectView : UIImageView

@property(nonatomic,assign)id<touchDetectProtocol> touchdelegate;
@property(nonatomic,assign)UIView *redirectView;
@property (nonatomic, retain) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
-(void)removePlayer;
@end
