        //
//  ssivView.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/25/12.
//
//

#import "ssivView.h"
#import "AVPlayerDemoPlaybackView.h"
#import "Config.h"

@interface ssivView()
{
    //eShape _curShape;
    //UIColor *bgclr;
    //AVPlayerDemoPlaybackView *playbackView;
   // AVPlayerDemoPlaybackView *playbackView;
    AVPlayerLayer *_playerLayer;
    AVPlayer *_player;
    id _playerObserver;
}

@property(nonatomic,retain)UIColor *bgclr;
@end

@implementation ssivView
@synthesize scrollView;
@synthesize imageView;
@synthesize curShape;

typedef struct
{
    eShape type;
    BOOL  bLocked;
    char imageName[64];
}tShapeMap;

static tShapeMap shape_imagenamemaping[SHAPE_LAST] = {
    {SHAPE_NOSHAPE,NO,"original"},
    {SHAPE_CIRCLE,NO,"circle"},
    {SHAPE_ZIGZAG,NO,"zigzag"},
    {SHAPE_BUTTERFLY,NO,"butterfly"},
    {SHAPE_STAR,NO,"star"},
    {SHAPE_TRIANGLE,NO,"triangle"},
    {SHAPE_FLOWER,NO,"flower"},
    {SHAPE_DIAMONDFLOWER,NO,"diamondflower"},
    {SHAPE_HEART,NO,"heart"},
    {SHAPE_HEXAGON,NO,"hexagon"},
    {SHAPE_CHRISTMASTREE,NO,"christmastree"},
    {SHAPE_CHRISTMASLIGHT,NO,"christmaslight"},
    {SHAPE_LEAF,NO,"leaf"},
    {SHAPE_APPLE,NO,"apple"},
    {SHAPE_MESSAGE,NO,"speach"},
    {SHAPE_CLOUD,NO,"cloud"},
    {SHAPE_BROKENHEART,NO,"brokenheart"},
};

//-(void)removePlayer
//{
//    [playbackView removeFromSuperview];
//}

//- (void)setPlayer:(AVPlayer*)player
//{
//    NSLog(@"Adding playback view");
//	//[(AVPlayerLayer*)[self layer] setPlayer:player];
//    playbackView = [[AVPlayerDemoPlaybackView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    playbackView.tag = 658;
//    [playbackView setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
//    [playbackView setPlayer:player];
//    [self addSubview:playbackView];
//    [playbackView release];
//}



/* Specifies how the video is displayed within a player layer’s bounds.
 (AVLayerVideoGravityResizeAspect is default) */
//- (void)setVideoFillMode:(NSString *)fillMode
//{
//	AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
//	playerLayer.videoGravity = fillMode;
//}

+(UIImage*)imageForShape:(eShape)shp
{
    if(shp >= SHAPE_LAST)
    {
        shp = SHAPE_CIRCLE;
    }
    
    NSString *imgname = [NSString stringWithFormat:@"%s",shape_imagenamemaping[shp].imageName];
    
    NSString *img_Name = [imgname stringByAppendingString:@".png"];
    //NSLog(@"shape img_Name  %@",img_Name);
    
    return [UIImage imageNamed:img_Name]; //[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgname ofType:@"png"]];
}

-(void)setShape:(eShape)shape
{
    if((shape > SHAPE_LAST)||(shape < SHAPE_NOSHAPE))
    {
        NSLog(@"setShape:Invalid Shape");
        return;
    }
    
    UIImage *shapeImage = nil;
    if(shape == SHAPE_NOSHAPE)
    {
        self.curShape = shape;
        self.layer.mask = nil;
        return;
    }
    
    self.curShape = shape;
    
    NSString *imgName = [NSString stringWithFormat:@"%s",shape_imagenamemaping[shape].imageName];
    NSString *img_Name = [imgName stringByAppendingString:@".png"];
    // NSLog(@"shape img_Name  %@",img_Name);
    
    shapeImage = [UIImage imageNamed:img_Name];//imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
    
    CGImageRef imgAlpha = shapeImage.CGImage;
    CALayer *alphaLayer = [CALayer layer];
    CGFloat padding  = 10;
    if(self.frame.size.height >= self.frame.size.width)
    {
        alphaLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    }
    else
    {
        alphaLayer.bounds = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    }
    // alphaLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    NSLog(@"shape name %@ width %f height %f",imgName,self.frame.size.width,self.frame.size.height);
    alphaLayer.position = CGPointMake(self.center.x - self.frame.origin.x,self.center.y-self.frame.origin.y);
    // Quality improvements
    alphaLayer.contentsScale = [UIScreen mainScreen].scale; // Retina support
    alphaLayer.minificationFilter = kCAFilterTrilinear;     // Better downscaling
    alphaLayer.magnificationFilter = kCAFilterTrilinear;   // Better upscaling
    
    alphaLayer.contents = (id)imgAlpha;
    self.layer.mask = alphaLayer;

    // Maintain dark background for empty frames
    self.backgroundColor = [UIColor colorWithRed:0.19 green:0.21 blue:0.25 alpha:1.0];

    // Add shape-specific border after masking
    [self updateBorderForCurrentShape];

    return;
}

-(void)previewShape:(eShape)shape
{
    if((shape > SHAPE_LAST)||(shape < SHAPE_NOSHAPE))
    {
        NSLog(@"setShape:Invalid Shape");
        return;
    }
    
    UIImage *shapeImage = nil;
    if(shape == SHAPE_NOSHAPE)
    {
        //self.curShape = shape;
        self.layer.mask = nil;
        return;
    }
    
    //self.curShape = shape;
    
    NSString *imgName = [NSString stringWithFormat:@"%s",shape_imagenamemaping[shape].imageName];
    NSString *img_Name = [imgName stringByAppendingString:@".png"];
    // NSLog(@"shape img_Name  %@",img_Name);
    
    shapeImage = [UIImage imageNamed:img_Name];
    
    //  shapeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
    
    CGImageRef imgAlpha = shapeImage.CGImage;
    CALayer *alphaLayer = [CALayer layer];
    alphaLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    alphaLayer.position = CGPointMake(self.center.x - self.frame.origin.x,self.center.y-self.frame.origin.y);
    alphaLayer.contents = (id)imgAlpha;
    // Quality improvements
    alphaLayer.contentsScale = [UIScreen mainScreen].scale; // Retina support
    alphaLayer.minificationFilter = kCAFilterTrilinear;     // Better downscaling
    alphaLayer.magnificationFilter = kCAFilterTrilinear;   // Better upscaling
    
    self.layer.mask = alphaLayer;
    
    return;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bgclr = nil;
        self.curShape = SHAPE_NOSHAPE;
        self.userInteractionEnabled = YES;
        CGRect internalFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        // Initialization code
        UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:internalFrame];
        self.scrollView = scrollV;
        
        
        // Allocate image view
        TouchDetectView *imgV = [[TouchDetectView alloc]initWithFrame:internalFrame];
        self.imageView   = imgV;
        
        //        NSLog(@"Touch Detect View x %f y %f ",imgV.center.x,imgV.center.y);
        //        UIImageView *plusButton = [[UIImageView alloc]init];
        //        plusButton.frame = internalFrame; //CGRectMake(0, 0, 30, 30);
        //        plusButton.image= [UIImage systemImageNamed:@"plus"]; //[UIImage imageNamed:@"add_05"];
        //        plusButton.contentMode = UIViewContentModeScaleAspectFit;
        //        plusButton.center = imgV.center;
        
        //self.imageView.contentMode = UIViewContentModeScaleToFill;
        //self.imageView.backgroundColor = clr;
        [self.imageView setUserInteractionEnabled:YES];
        
        // Add imageView inside container
        
        
        [self addSubview:self.scrollView];
        
        [self.scrollView addSubview: self.imageView];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        //        [self.imageView addSubview:plusButton];
        //        plusButton.translatesAutoresizingMaskIntoConstraints = NO;
        //
        //        float buttonSize = 25;
        //        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        //            buttonSize = 35;
        //        else buttonSize = 25;
        //
        //        [NSLayoutConstraint activateConstraints:@[
        //        [plusButton.widthAnchor constraintEqualToConstant:buttonSize], // Set desired width
        //        [plusButton.heightAnchor constraintEqualToConstant:buttonSize],
        //        // Center the image view horizontally
        //        [plusButton.centerXAnchor constraintEqualToAnchor:self.imageView.centerXAnchor],
        //        // Center the image view vertically
        //        [plusButton.centerYAnchor constraintEqualToAnchor:self.imageView.centerYAnchor]
        //        ]];
        
        /* No need to free these */
        [scrollV release];
        [imgV release];
        
        //[self setShape:SHAPE_CIRCLE];
        
        [self registerForNotifications];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setShape:self.curShape];
}

-(void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:nil
                                                  object:nil];
}

-(void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:) name:nil object:nil];
}

-(UIImage*)getImageOfShape:(eShape)shp
{
    NSString *imgName = [NSString stringWithFormat:@"%s",shape_imagenamemaping[shp].imageName];
    NSString *img_Name = [imgName stringByAppendingString:@".png"];
    // NSLog(@"shape img_Name  %@",img_Name);
    
    UIImage * shapeImage = [UIImage imageNamed:img_Name];
    //UIImage *shapeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
    return shapeImage;
}

-(UIImage*)getCurrentAssignedShapeImage
{
    NSLog(@"shape name is %u",self.curShape);
    return [self getImageOfShape:self.curShape];
}

-(void)snapshotWithScale:(float)scale
{
    //commentagain
    //    if((self.curShape == SHAPE_NOSHAPE)||(self.curShape >= SHAPE_LAST))
    //    {
    //        NSLog(@"Returned.......");
    //        return;
    //    }
    //
    //static int count  = 0;
    //count++;
    //NSLog(@"Begin %d (%f,%f) scale %f",count,self.frame.size.width,self.frame.size.height,scale);

    // Ensure all UI operations happen on main thread
    dispatch_block_t renderBlock = ^{
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
        self.bgclr = self.backgroundColor;
        self.backgroundColor = [UIColor clearColor];
        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
        NSString *imgName = [NSString stringWithFormat:@"%s",shape_imagenamemaping[self.curShape].imageName];
        NSString *img_Name = [imgName stringByAppendingString:@".png"];
        //NSLog(@"shape img_Name  %@",img_Name);

        UIImage * shapeImage = [UIImage imageNamed:img_Name];
        // UIImage *shapeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.bounds.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);

        CGContextClipToMask(UIGraphicsGetCurrentContext(),CGRectMake(0, 0, self.frame.size.width, self.frame.size.height),shapeImage.CGImage);

        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.bounds.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);

        [self.layer renderInContext:UIGraphicsGetCurrentContext()];

        self.image = UIGraphicsGetImageFromCurrentImageContext();

        // self.scrollView.hidden = YES; //uncomment again
        // self.imageView.hidden = YES; //uncomment again

        UIGraphicsEndImageContext();
        //NSLog(@"End %d",count);
    };

    // Execute on main thread synchronously
    if ([NSThread isMainThread]) {
        renderBlock();
    } else {
        dispatch_sync(dispatch_get_main_queue(), renderBlock);
    }
}
-(void)receiveNotification:(NSNotification*)notification
{
    /*  */
    if([notification.name isEqualToString:ssiv_notification_snapshotmode_enter])
    {
        //if(nil != self.imageView.image)
        //{
        if(self.curShape != SHAPE_NOSHAPE)
        {
            /* get the scale */
            float scale = [[notification.userInfo objectForKey:@"scale"]floatValue];
            [self snapshotWithScale:scale];
        }
        // else
        //{
        //   NSLog(@"ssiv_notification_snapshotmode_enter: self.curShape is SHAPE_NOSHAPE");
        //}
        // NSLog(@"Image or touchview is not nil..");
        //}
        //else
        //{
        //    NSLog(@"ssiv_notification_snapshotmode_enter: self.imageview.image is nil");
        //}
    }
    else if([notification.name isEqualToString:ssiv_notification_snapshotmode_exit])
    {
        // if(nil != self.imageView.image)
        // {
        
        if((self.curShape == SHAPE_NOSHAPE)||(self.curShape >= SHAPE_LAST))
        {
            return;
        }
        self.image = nil;
        self.backgroundColor = self.bgclr;
        // self.scrollView.hidden = NO;//uncomment again
        // self.imageView.hidden = NO; //uncomment again
        if (@available(iOS 14, *)) {
            
            // NSLog(@"IOS!4 device-----");
        } else {
            // NSLog(@"IOS 13 device-----");
        }
        /*
         if ([[NSUserDefaults standardUserDefaults] integerForKey:@"TouchViewHide"] == 0)
         {
         self.imageView.hidden = NO;
         self.scrollView.hidden = NO;
         //NSLog(@"Image or touchview Hided----");
         }
         else
         {
         if ([[NSUserDefaults standardUserDefaults] integerForKey:@"TouchViewHided"] == 1)
         {
         [self EnableImageview];
         
         // self.imageView.hidden = NO;
         // NSLog(@"touchview Showing----");
         }
         // self.imageView.hidden = YES;
         //  NSLog(@"Image or touchview is not nil..*******");
         }
         
         */
        self.bgclr = nil;
        //}
    }
    
    //    else if([notification.name isEqualToString:@"AddAdditionalAudioToPlayer"])
    //    {
    //        NSURL *audioURL = notification.userInfo[@"audioURL"];
    //        if (audioURL) {
    //            NSLog(@"audio url %@",audioURL);
    //        // Process the audio URL
    //            self.additionalAudioURL = audioURL;
    //        }
    //        else
    //        {
    //            [self setupVideoPlayer];
    //        }
    //    }
}



-(void)EnableImageview
{
    //[self performSelector:@selector(enablingImageview) withObject:nil afterDelay:0.0f];
    self.scrollView.hidden = NO;
    self.imageView.hidden = NO;
}
-(void)enablingImageview
{
    self.scrollView.hidden = NO;
    self.imageView.hidden = NO;
    
    NSLog(@"Imageview Enabled...2");
}

//
//-(void)receiveNotification:(NSNotification*)notification
//{
//    /*  */
//    if([notification.name isEqualToString:ssiv_notification_snapshotmode_enter])
//    {
//        //if(nil != self.imageView.image)
//        //{
//            if(self.curShape != SHAPE_NOSHAPE)
//            {
//                /* get the scale */
//                float scale = [[notification.userInfo objectForKey:@"scale"]floatValue];
//                [self snapshotWithScale:scale];
//            }
//           // else
//           // {
//             //   NSLog(@"ssiv_notification_snapshotmode_enter: self.curShape is SHAPE_NOSHAPE");
//           // }
//        //}
//      //  else
//       // {
//          //  NSLog(@"ssiv_notification_snapshotmode_enter: self.imageview.image is nil");
//       // }
//    }
//    else if([notification.name isEqualToString:ssiv_notification_snapshotmode_exit])
//    {
//        if((self.curShape == SHAPE_NOSHAPE)||(self.curShape >= SHAPE_LAST))
//        {
//            return;
//        }
//        self.image = nil;
//        self.backgroundColor = self.bgclr;
//        self.scrollView.hidden = NO;
//        self.imageView.hidden = NO;//uncommentagain
//        self.bgclr = nil;
//    }
//}

-(void)dealloc
{
    NSLog(@"[ssiveview dealloc]is being deallocated");
    [self removePlayer];
    [self unregisterForNotifications];
    //    [_bgclr release];
    //    [_player release];
    [super dealloc];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Video Playback Setup

- (void)setupVideoPlayer {
    NSLog(@"set up video player");
    self.isAudioMuted =  self.isvideoMute;
    // 1. Clean up existing player properly
    [self removePlayerWithMute:NO]; // Don't mute during setup

    NSLog(@"set up video player");
    // 1. Clean up existing player
   // [self removePlayer];
    if (!self.videoURL) return;

    // 2. Prepare video asset
    AVAsset *videoAsset = [AVAsset assetWithURL:self.videoURL];
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    if (!videoTrack) return;

    // 3. Calculate time range based on trim settings
    CMTime videoDuration = videoAsset.duration;
    double videoDurationSeconds = CMTimeGetSeconds(videoDuration);

    // Determine start and end times based on trim properties
    CMTime startTime = kCMTimeZero;
    CMTime endTime = videoDuration;

    // Apply trim range if set (videoTrimEnd > 0 means trim was applied)
    if (self.videoTrimEnd > 0) {
        double trimStart = MAX(0, self.videoTrimStart);
        double trimEnd = MIN(self.videoTrimEnd, videoDurationSeconds);

        startTime = CMTimeMakeWithSeconds(trimStart, 600);
        endTime = CMTimeMakeWithSeconds(trimEnd, 600);

        NSLog(@"🎬 Applying trim range: %.2fs - %.2fs", trimStart, trimEnd);
    }

    // Calculate duration and apply 30-second max limit
    CMTime maxDuration = CMTimeMakeWithSeconds(30, 600);
    CMTime duration = CMTimeSubtract(endTime, startTime);
    if (CMTimeCompare(duration, maxDuration) > 0) {
        duration = maxDuration;
    }

    CMTimeRange timeRange = CMTimeRangeMake(startTime, duration);

    // 4. Create composition
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    // 5. Add video track
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                             preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:timeRange
                                 ofTrack:videoTrack
                                  atTime:kCMTimeZero
                                   error:nil];
    BOOL masterAudioSet = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY] boolValue];
    
    // 6. Handle audio
        NSLog(@"Original audio track is being used");
        AVAssetTrack *originalAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    if (originalAudioTrack ) { //!masterAudioSet  ||  //&& !self.isvideoMute
            AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionAudioTrack insertTimeRange:timeRange
                                         ofTrack:originalAudioTrack
                                          atTime:kCMTimeZero
                                           error:nil];
        }

    // 7. Create audio mix for volume control
    NSMutableArray<AVMutableAudioMixInputParameters *> *mixParameters = [NSMutableArray array];
    NSArray<AVCompositionTrack *> *audioTracks = [composition tracksWithMediaType:AVMediaTypeAudio];
    
    for (AVCompositionTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *parameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        [parameters setVolume:1.0 atTime:kCMTimeZero];
        [mixParameters addObject:parameters];
    }
    
    self.audioMixInputParameters = [mixParameters copy];
    self.audioMix = [AVMutableAudioMix audioMix];
    self.audioMix.inputParameters = self.audioMixInputParameters;
    self.isAudioMuted = NO;
    // 8. Handle video orientation
    CGAffineTransform transform = videoTrack.preferredTransform;
    BOOL needsFix = !CGAffineTransformIsIdentity(transform);
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:composition];
    playerItem.audioMix = self.audioMix;
    
    if (needsFix) {
        CGSize naturalSize = videoTrack.naturalSize;
        CGSize renderSize = naturalSize;
        
        if (transform.a == 0 && fabs(transform.b) == 1.0 && fabs(transform.c) == 1.0 && transform.d == 0) {
            renderSize = CGSizeMake(naturalSize.height, naturalSize.width);
        }
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        
        
        videoComposition.renderSize = renderSize;
        videoComposition.frameDuration = videoTrack.minFrameDuration; //CMTimeMake(1, 30);
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration);
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction =
            [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        [layerInstruction setTransform:transform atTime:kCMTimeZero];
        
        instruction.layerInstructions = @[layerInstruction];
        videoComposition.instructions = @[instruction];
        
        playerItem.videoComposition = videoComposition;
    }

    // 9. Create player
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.imageView.bounds;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.imageView.layer addSublayer:_playerLayer];

     //10. Set up observers
    __weak typeof(self) weakSelf = self;
    _playerObserver = [[NSNotificationCenter defaultCenter]
        addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                    object:playerItem
                     queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note) {
                    [weakSelf.player seekToTime:kCMTimeZero];
                    // Play at the configured speed (default 1.0)
                    float speed = weakSelf.playbackSpeed > 0 ? weakSelf.playbackSpeed : 1.0;
                    weakSelf.player.rate = speed;
                }];

    // Add observer for play/pause state
    [_player addObserver:self
             forKeyPath:@"rate"
                options:NSKeyValueObservingOptionNew
                context:nil];
    if(self.isvideoMute)
        [self muteAudio];
    // 11. Start playback at configured speed
    float speed = self.playbackSpeed > 0 ? self.playbackSpeed : 1.0;
    _player.rate = speed;
}


- (void)pausePlayer {
    self.isProgrammaticPause = YES;
    //[self muteAudio];
    if(self.isvideoMute)
        [self muteAudioPlayer];
    else [self unmuteAudioPlayer];
    [self.player pause];
    self.isProgrammaticPause = NO;
}

- (void)stopPlayer {
    [self muteAudio];  // Mute audio immediately
    [self.player pause];   // Pause video
    [self.player seekToTime:kCMTimeZero]; // Reset to beginning
}

- (void)playPlayer {
    self.isProgrammaticPlaybackChange = YES;
    // Start video at configured speed
    float speed = self.playbackSpeed > 0 ? self.playbackSpeed : 1.0;
    self.player.rate = speed;
    //[self muteAudio];   // Then unmute audio
    if(self.isvideoMute)
        [self muteAudioPlayer];
    else [self unmuteAudioPlayer];
    self.isProgrammaticPlaybackChange = NO;
}


// New comprehensive player removal method
- (void)removePlayerWithMute:(BOOL)shouldMute {
    NSLog(@"Removing player (mute: %@)", shouldMute ? @"YES" : @"NO");
    
    // Store current mute state
    BOOL wasMuted = self.isAudioMuted;
    
    // 1. Clean up player
    if (_player) {
        [_player pause];
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
        
        @try {
            [_player removeObserver:self forKeyPath:@"rate"];
        } @catch (NSException *exception) {
            NSLog(@"Observer removal exception: %@", exception);
        }
        _player = nil;
    }
    
    // 2. Remove notification observer
    if (_playerObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:_playerObserver];
        _playerObserver = nil;
    }
    
    // 3. Clean up player layer
    if (_playerLayer) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
    
    // 4. Handle audio state
    if (shouldMute) {
        [self _internalMuteAudio:YES]; // Force mute without checks
    } else {
        // Restore original mute state
        _isAudioMuted = wasMuted;
    }
    
    // 5. Clean up audio mix
    self.audioMix = nil;
    self.audioMixInputParameters = nil;
    
    NSLog(@"Player removal complete");
}

// Private mute method for internal use
- (void)_internalMuteAudio:(BOOL)mute {
    _isAudioMuted = mute;
    
    AVPlayerItem *playerItem = self.player.currentItem;
    if (!playerItem) return;
    
    NSMutableArray *newParameters = [NSMutableArray array];
    NSArray<AVAssetTrack *> *audioTracks = [playerItem.asset tracksWithMediaType:AVMediaTypeAudio];
    
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *params =
            [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        [params setVolume:mute ? 0.0f : 1.0f atTime:kCMTimeZero];
        [newParameters addObject:params];
    }
    
    AVMutableAudioMix *newAudioMix = [AVMutableAudioMix audioMix];
    newAudioMix.inputParameters = newParameters;
    playerItem.audioMix = newAudioMix;
    
    self.audioMix = newAudioMix;
    self.audioMixInputParameters = newParameters;
}


-(void)muteAudioPlayer
{
    self.isProgrammaticMuteChange = YES;
    AVPlayerItem *playerItem = self.player.currentItem;
    if (!playerItem) return;
    
    NSMutableArray *newParameters = [NSMutableArray array];
    NSArray<AVAssetTrack *> *audioTracks = [playerItem.asset tracksWithMediaType:AVMediaTypeAudio];
    
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *params =
            [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        [params setVolume: 0.0f atTime:kCMTimeZero];
        [newParameters addObject:params];
    }
    
    AVMutableAudioMix *newAudioMix = [AVMutableAudioMix audioMix];
    newAudioMix.inputParameters = newParameters;
    playerItem.audioMix = newAudioMix;
    
    self.audioMix = newAudioMix;
    self.audioMixInputParameters = newParameters;
    self.isProgrammaticMuteChange = NO;
}

-(void)unmuteAudioPlayer
{
    self.isProgrammaticMuteChange = YES;
    AVPlayerItem *playerItem = self.player.currentItem;
    if (!playerItem) return;
    
    NSMutableArray *newParameters = [NSMutableArray array];
    NSArray<AVAssetTrack *> *audioTracks = [playerItem.asset tracksWithMediaType:AVMediaTypeAudio];
    
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *params =
            [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        [params setVolume: 1.0f atTime:kCMTimeZero];
        [newParameters addObject:params];
    }
    
    AVMutableAudioMix *newAudioMix = [AVMutableAudioMix audioMix];
    newAudioMix.inputParameters = newParameters;
    playerItem.audioMix = newAudioMix;
    
    self.audioMix = newAudioMix;
    self.audioMixInputParameters = newParameters;
    self.isProgrammaticMuteChange = NO;
}


- (void)muteAudio {
    NSLog(@"mute %@ isAudioMuted %@", self.isvideoMute ? @"YES" : @"NO", self.isAudioMuted ? @"YES" : @"NO");
    
    // Check if we're already in the desired state
    if (self.isAudioMuted == self.isvideoMute) return;
    
    int masterAudioSet = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MasterAudioPlayerSet"];
    if (masterAudioSet == 1) {
        // Use a flag to prevent observer feedback
        self.isProgrammaticMuteChange = YES;
        [self _internalMuteAudio:YES];
        self.isProgrammaticMuteChange = NO;
    } else {
        // Use a flag to prevent observer feedback
        self.isProgrammaticMuteChange = YES;
        [self _internalMuteAudio:self.isvideoMute];
        self.isProgrammaticMuteChange = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    NSLog(@"Rate changed to %f", [change[NSKeyValueChangeNewKey] floatValue]);
    if ([keyPath isEqualToString:@"rate"]) {
        if (self.isProgrammaticPlaybackChange || self.isProgrammaticMuteChange || self.isProgrammaticPause) {
            // Ignore changes we triggered ourselves
            return;
        }
        
        float rate = [change[NSKeyValueChangeNewKey] floatValue];
        if (rate == 0.0) {
            // Player paused - mute the audio immediately
            [self muteAudio];
        } else if (rate == 1.0) {
            // Player resumed - unmute the audio
            [self muteAudio];
        }
    }
    else if ([keyPath isEqualToString:@"status"]) {
            AVPlayerItem *playerItem = (AVPlayerItem *)object;
            if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
                NSLog(@"Player item is ready to play");
                [self.player play];
            } else if (playerItem.status == AVPlayerItemStatusFailed) {
                NSLog(@"Player item failed: %@", playerItem.error);
            }
        }
}


- (void)removePlayer {
    NSLog(@"Remove Player");
    
    // 1. Pause and nil player first to stop all playback
    if (_player) {
        [_player pause];
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
        
        // Remove rate observer
        @try {
            [_player removeObserver:self forKeyPath:@"rate"];
        } @catch (NSException *exception) {
            NSLog(@"Already removed rate observer");
        }
        _player = nil;
    }
    
    // 2. Remove notification observer
    if (_playerObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:_playerObserver];
        _playerObserver = nil;
    }
    
    // 3. Clean up player layer
    if (_playerLayer) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
    
    // 4. Reset audio mix
    self.audioMixInputParameters = nil;
    self.audioMix = nil;
    
    // 5. Clean up audio session completely instead of just muting
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (error) {
        NSLog(@"Audio session deactivation error: %@", error.localizedDescription);
    }
    
    // 6. Reset any temporary state
    NSLog(@"Remove Player done");
}

- (void)setVideoURL:(NSURL *)videoURL {
    if (_videoURL == videoURL) return;
    
    _videoURL = videoURL;
    
    if (videoURL) {
        [self setupVideoPlayer];
    } else {
        [self removePlayer];
    }
}


//-(void)setAdditionalAudioURL:(NSURL *)additionalAudioURL
//{
//    NSLog(@"new audio murl is %@", additionalAudioURL);
//    _additionalAudioURL = additionalAudioURL;
//    NSLog(@"old audio url - %@ new audio murl is %@",_additionalAudioURL , additionalAudioURL);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (additionalAudioURL) {
//            NSLog(@"set up audio url");
//            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"IsAdditionalAudioSet"];
//            //[self setupVideoPlayer];
//            [self updateAudioTrack];
//        }
//    });
//}


//- (void)updateAudioTrack {
//    if (!_player || !_player.currentItem) {
//        [self setupVideoPlayer];
//        return;
//    }
//    
//    // Store current playback state
//    BOOL wasPlaying = (_player.rate > 0 && !_player.error);
//    CMTime currentTime = _player.currentItem.currentTime;
//    
//    AVAsset *compositionAsset = (AVAsset *)_player.currentItem.asset;
//    if (![compositionAsset isKindOfClass:[AVMutableComposition class]]) {
//        [self setupVideoPlayer];
//        return;
//    }
//    
//    AVMutableComposition *mutableComposition = (AVMutableComposition *)compositionAsset;
//    
//    // 1. Remove all existing audio tracks
//    NSArray<AVCompositionTrack *> *audioTracks = [mutableComposition tracksWithMediaType:AVMediaTypeAudio];
//    for (AVCompositionTrack *track in audioTracks) {
//        [mutableComposition removeTrack:track];
//    }
//    
//    // 2. Get the video time range
//    CMTime maxDuration = CMTimeMakeWithSeconds(30, 600);
//    CMTime videoDuration = mutableComposition.duration;
//    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMinimum(videoDuration, maxDuration));
//    
//    // 3. Add the new audio track
//    if (self.additionalAudioURL) {
//        AVAsset *audioAsset = [AVAsset assetWithURL:self.additionalAudioURL];
//        AVAssetTrack *audioTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//        
//        if (audioTrack) {
//            AVMutableCompositionTrack *compositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio
//                                                                                           preferredTrackID:kCMPersistentTrackID_Invalid];
//            
//            CMTime audioDuration = audioAsset.duration;
//            CMTimeRange audioTimeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMinimum(audioDuration, maxDuration));
//            
//            NSError *error = nil;
//            [compositionAudioTrack insertTimeRange:audioTimeRange
//                                         ofTrack:audioTrack
//                                          atTime:kCMTimeZero
//                                           error:&error];
//            
//            if (error) {
//                NSLog(@"Error inserting audio track: %@", error);
//            }
//            
//            // Loop the audio if it's shorter than the video
//            if (CMTimeCompare(audioDuration, maxDuration) < 0) {
//                CMTime remainingTime = CMTimeSubtract(maxDuration, audioDuration);
//                CMTime insertionTime = audioDuration;
//                
//                while (CMTimeCompare(remainingTime, kCMTimeZero) > 0) {
//                    CMTime segmentDuration = CMTimeMinimum(audioDuration, remainingTime);
//                    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, segmentDuration)
//                                                ofTrack:audioTrack
//                                                 atTime:insertionTime
//                                                  error:nil];
//                    insertionTime = CMTimeAdd(insertionTime, segmentDuration);
//                    remainingTime = CMTimeSubtract(remainingTime, segmentDuration);
//                }
//            }
//        }
//    } else {
//        // If no additional audio, use original audio from video
//        AVAsset *videoAsset = [AVAsset assetWithURL:self.videoURL];
//        AVAssetTrack *originalAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//        if (originalAudioTrack) {
//            AVMutableCompositionTrack *compositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio
//                                                                                           preferredTrackID:kCMPersistentTrackID_Invalid];
//            [compositionAudioTrack insertTimeRange:timeRange
//                                         ofTrack:originalAudioTrack
//                                          atTime:kCMTimeZero
//                                           error:nil];
//        }
//    }
//    
//    // 4. Create new audio mix
//    NSMutableArray<AVMutableAudioMixInputParameters *> *mixParameters = [NSMutableArray array];
//    NSArray<AVCompositionTrack *> *newAudioTracks = [mutableComposition tracksWithMediaType:AVMediaTypeAudio];
//    
//    for (AVCompositionTrack *track in newAudioTracks) {
//        AVMutableAudioMixInputParameters *parameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
//        [parameters setVolume:1.0 atTime:kCMTimeZero];
//        [mixParameters addObject:parameters];
//    }
//    
//    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
//    audioMix.inputParameters = mixParameters;
//    
//    // 5. Create a new player item with the updated composition
//    AVPlayerItem *newPlayerItem = [AVPlayerItem playerItemWithAsset:mutableComposition];
//    newPlayerItem.audioMix = audioMix;
//    
//    // Copy over video composition if it exists
//    if (_player.currentItem.videoComposition) {
//        newPlayerItem.videoComposition = _player.currentItem.videoComposition;
//    }
//    
//    // 6. Replace the current item
//    [_player replaceCurrentItemWithPlayerItem:newPlayerItem];
//    
//    // 7. Restore playback state
//    if (wasPlaying) {
//        [_player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
//            if (finished) {
//                [_player play];
//            }
//        }];
//    } else {
//        [_player seekToTime:currentTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
//    }
//    // 8. Re-add observers if needed
//    [self setupPlayerObserversForItem:newPlayerItem];
//}
//
//- (void)setupPlayerObserversForItem:(AVPlayerItem *)playerItem {
//    // Remove existing observers first
//    [self removePlayerObservers];
//    
//    // Add your observers here (same as in your setupVideoPlayer method)
//    __weak typeof(self) weakSelf = self;
//    _playerObserver = [[NSNotificationCenter defaultCenter]
//        addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
//                    object:playerItem
//                     queue:[NSOperationQueue mainQueue]
//                usingBlock:^(NSNotification *note) {
//                    [weakSelf.player seekToTime:kCMTimeZero];
//                    [weakSelf.player play];
//                }];
//    
//    [_player addObserver:self
//             forKeyPath:@"rate"
//                options:NSKeyValueObservingOptionNew
//                context:nil];
//}
//
//- (void)removePlayerObservers {
//    // Remove the play-to-end observer
//    if (_playerObserver) {
//        [[NSNotificationCenter defaultCenter] removeObserver:_playerObserver
//                                                       name:AVPlayerItemDidPlayToEndTimeNotification
//                                                     object:_player.currentItem];
//        _playerObserver = nil;
//    }
//    
//    // Remove rate observer
//    @try {
//        [_player removeObserver:self forKeyPath:@"rate"];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Error removing rate observer: %@", exception);
//    }
//    
//    // Remove any other observers you might have added
//    // For example, if you observe the player item's status:
//    @try {
//        [_player.currentItem removeObserver:self forKeyPath:@"status"];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Error removing status observer: %@", exception);
//    }
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playerLayer.frame = self.imageView.bounds;
}


- (void)play {
    [_player play];
}

- (void)pause {
    [_player pause];
}

- (void)stop {
    [self removePlayer];
}

#pragma mark - Shape Border Methods

- (CGPathRef)createBorderPathForShape:(eShape)shape withSize:(CGSize)size {
    // For SHAPE_NOSHAPE, return rectangular path
    if (shape == SHAPE_NOSHAPE) {
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
        return CGPathRetain(rectPath.CGPath);
    }

    // For circle, use bezierPathWithOvalInRect for perfect circle
    if (shape == SHAPE_CIRCLE) {
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
        return CGPathRetain(circlePath.CGPath);
    }

    // For other shapes, extract path from PNG alpha channel
    UIImage *shapeImage = [ssivView imageForShape:shape];
    if (!shapeImage) {
        // Fallback to rectangle if shape image not found
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
        return CGPathRetain(rectPath.CGPath);
    }

    // Scale the image to match the view size for accurate border
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [shapeImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // Extract path from alpha channel using edge detection
    CGImageRef cgImage = scaledImage.CGImage;
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);

    // Create bitmap context to read pixel data
    unsigned char *pixelData = (unsigned char *)calloc(width * height * 4, sizeof(unsigned char));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixelData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);

    // Create path by tracing the edge of non-transparent pixels
    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    BOOL foundFirstPoint = NO;

    // Simple edge detection: find pixels where alpha > 0 and neighbor has alpha == 0
    for (size_t y = 0; y < height; y++) {
        for (size_t x = 0; x < width; x++) {
            size_t index = (y * width + x) * 4;
            unsigned char alpha = pixelData[index + 3];

            // Check if this pixel is visible (alpha > 128)
            if (alpha > 128) {
                // Check if any neighbor is transparent (edge pixel)
                BOOL isEdge = NO;

                // Check 4-connected neighbors
                if (x == 0 || x == width - 1 || y == 0 || y == height - 1) {
                    isEdge = YES;
                } else {
                    // Check left neighbor
                    if (pixelData[((y * width + (x-1)) * 4) + 3] <= 128) isEdge = YES;
                    // Check right neighbor
                    if (pixelData[((y * width + (x+1)) * 4) + 3] <= 128) isEdge = YES;
                    // Check top neighbor
                    if (pixelData[(((y-1) * width + x) * 4) + 3] <= 128) isEdge = YES;
                    // Check bottom neighbor
                    if (pixelData[(((y+1) * width + x) * 4) + 3] <= 128) isEdge = YES;
                }

                if (isEdge) {
                    CGFloat pointX = (x / (CGFloat)width) * size.width;
                    CGFloat pointY = (y / (CGFloat)height) * size.height;

                    if (!foundFirstPoint) {
                        [borderPath moveToPoint:CGPointMake(pointX, pointY)];
                        foundFirstPoint = YES;
                    } else {
                        [borderPath addLineToPoint:CGPointMake(pointX, pointY)];
                    }
                }
            }
        }
    }

    [borderPath closePath];

    // Cleanup
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixelData);

    return CGPathRetain(borderPath.CGPath);
}

- (void)updateBorderForCurrentShape {
    // Default: black dotted border for unselected state
    [self setBorderStyle:[UIColor blackColor]
              lineWidth:2.0f
            dashPattern:@[@2, @2]];
}

- (void)setBorderStyle:(UIColor *)color lineWidth:(CGFloat)width dashPattern:(NSArray *)pattern {
    // Remove existing border
    if (self.shapeBorderLayer) {
        [self.shapeBorderLayer removeFromSuperlayer];
        self.shapeBorderLayer = nil;
    }

    // Skip for SHAPE_NOSHAPE (handled by scrollView.layer)
    if (self.curShape == SHAPE_NOSHAPE) {
        return;
    }

    // Calculate border size (matching mask layer)
    CGSize borderSize;
    if (self.frame.size.height >= self.frame.size.width) {
        borderSize = CGSizeMake(self.frame.size.width, self.frame.size.width);
    } else {
        borderSize = CGSizeMake(self.frame.size.height, self.frame.size.height);
    }

    // Create border path
    CGPathRef borderPath = [self createBorderPathForShape:self.curShape withSize:borderSize];

    // Create border layer with specified style
    CAShapeLayer *border = [CAShapeLayer layer];
    border.path = borderPath;
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.lineWidth = width;
    border.lineDashPattern = pattern;  // nil = solid, @[@2, @2] = dotted

    // Position to match mask layer
    border.bounds = CGRectMake(0, 0, borderSize.width, borderSize.height);
    border.position = CGPointMake(self.center.x - self.frame.origin.x,
                                  self.center.y - self.frame.origin.y);

    [self.layer addSublayer:border];
    self.shapeBorderLayer = border;

    CGPathRelease(borderPath);
}

- (void)removeBorder {
    if (self.shapeBorderLayer) {
        [self.shapeBorderLayer removeFromSuperlayer];
        self.shapeBorderLayer = nil;
    }
}

@end
