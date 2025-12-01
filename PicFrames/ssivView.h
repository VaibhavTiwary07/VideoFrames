//
//  ssivView.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/25/12.
//
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"
#import "ssivPub.h"
#import "TouchView.h"
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerDemoPlaybackView.h"

@class  AVPlayer;

@interface ssivView : UIImageView

@property(nonatomic,assign)UIScrollView *scrollView;
@property(nonatomic,assign)TouchDetectView  *imageView;
@property(nonatomic,readwrite)eShape curShape;
@property (nonatomic, retain) AVPlayer* player;
@property (nonatomic, strong) NSURL *videoURL;
//@property (nonatomic, assign) NSURL *additionalAudioURL;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) NSArray<AVMutableAudioMixInputParameters *> *audioMixInputParameters;
@property (strong, nonatomic) AVMutableAudioMix *audioMix;
@property (strong, nonatomic) id playerObserver;
@property (nonatomic) BOOL isAudioMuted;
@property (nonatomic) BOOL isProgrammaticPlaybackChange;
@property (nonatomic) BOOL isProgrammaticMuteChange;
@property (nonatomic, assign) BOOL isProgrammaticPause;
@property(nonatomic,readwrite)BOOL isvideoMute;
@property (nonatomic, assign) float playbackSpeed; // Speed for video playback (default 1.0)
@property (nonatomic, assign) double videoTrimStart; // Trim start time in seconds (default 0)
@property (nonatomic, assign) double videoTrimEnd; // Trim end time in seconds (0 = use full video)
@property (nonatomic, strong) CALayer *_overlayBorderLayer; // New property for the actual overlay border
+(UIImage*)imageForShape:(eShape)shp;
-(void)setShape:(eShape)shape;
-(void)previewShape:(eShape)shape;
//- (void)setPlayer:(AVPlayer*)player;
- (void)removePlayer;
-(UIImage*)getCurrentAssignedShapeImage;
- (void)setupVideoPlayer;
//- (void)play;
//- (void)pause;
//- (void)stop;
- (void)stopPlayer;
- (void)playPlayer;
- (void)pausePlayer;
- (void)muteAudio;
-(void)muteAudioPlayer;
-(void)unmuteAudioPlayer;
- (void)updateBorderForCurrentShape;
- (void)setBorderStyle:(UIColor *)color lineWidth:(CGFloat)width dashPattern:(NSArray *)pattern;
- (void)removeBorder;
- (void)setPlayerVolume:(float)volume;
@end
