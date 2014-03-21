//
//  ShareViewController.m
//  VideoFrames
//
//  Created by Deepti's Mac on 1/24/14.
//
//

#import "ShareViewController.h"
#import "Config.h"
#import <MediaPlayer/MediaPlayer.h>
#import "OT_TabBar.h"
#import "VideoUploadHandler.h"
#import "UploadHandler.h"
#define videoPlayButtonTag 9876
@interface ShareViewController ()<OT_TabBarDelegate>
{
OT_TabBar *customTabBar;
}
@property (nonatomic, retain) MPMoviePlayerViewController *playerViewController;
@end

@implementation ShareViewController
@synthesize frameSize;
@synthesize videoPath;
@synthesize isVideo;
@synthesize sess;
@synthesize playerViewController = _playerViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    nvm = [Settings Instance];
    nvm.noAdMode = YES;
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView . frame = CGRectMake(0, 0, full_screen.size.width, full_screen.size.height);
    backgroundView . image =[UIImage imageNamed:share_background_Image];
    backgroundView . userInteractionEnabled = YES;
    [self.view addSubview:backgroundView];
    [self.view bringSubviewToFront:backgroundView];
    [backgroundView release];
    
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && full_screen.size.height>480) {
        backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"background_1136@2x" ofType:@"png"]];
    }
    
    [self allocateResourcesForTopToolBar];
    [self allocateResourcesForPreview];
    [self allocateToolBarForShareOptions];
	// Do any additional setup after loading the view.
}
- (void)allocateResourcesForTopToolBar
{
    UIImageView *topToolBar = [[UIImageView alloc] init];
    topToolBar . frame = CGRectMake(0, 0, full_screen.size.width, topBarHeight);
    topToolBar . userInteractionEnabled = YES;
    [self.view addSubview:topToolBar];
    [topToolBar release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, full_screen.size.width, customBarHeight)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = UIColorFromRGB(0xFFFFFFFF);
    label.text = @"Share";
    label.font = [UIFont systemFontOfSize:20.0];
    [topToolBar addSubview:label];
    [label release];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton . frame = CGRectMake(0, 0, customBarHeight, customBarHeight);
    [backButton setImage:[UIImage imageNamed:share_back_Image] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backButton];

}
- (void)goBack
{
    nvm.noAdMode = NO;
    [_playerViewController.view removeFromSuperview];
     [_playerViewController release];
    _playerViewController = nil;

    [self.view removeFromSuperview];
}

- (void)allocateResourcesForPreview
{
    UIImageView *playerView = [[UIImageView alloc] init];
    playerView . userInteractionEnabled = YES;
    playerView . backgroundColor = [UIColor clearColor];
    playerView . frame = CGRectMake(0, 0, frameSize, frameSize);
    playerView . center = CGPointMake(full_screen.size.width/2, full_screen.size.height/2);
    [self.view addSubview:playerView];
    [playerView release];
    
    if (isVideo)
    {
        if (_playerViewController != nil)
        {
            [_playerViewController.view removeFromSuperview ];
            [_playerViewController release];
            _playerViewController = nil;
        }
    _playerViewController = [[MPMoviePlayerViewController alloc] init];
    _playerViewController.moviePlayer.contentURL = [NSURL fileURLWithPath:videoPath];
    _playerViewController .moviePlayer. shouldAutoplay = NO;
    _playerViewController.view.frame = CGRectMake(0, 0,frameSize, frameSize);
    _playerViewController .moviePlayer. controlStyle = MPMovieControlStyleNone;
    [playerView addSubview:_playerViewController.view];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.playerViewController.moviePlayer];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(moviePlayerDidEnterFullScreen)
                                                      name:MPMoviePlayerDidEnterFullscreenNotification
                                                    object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerDidExitFromFullScreen)
                                                     name:MPMoviePlayerDidExitFullscreenNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerPlaybackStateDidChange:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:self.playerViewController.moviePlayer];
        
        
         UIButton *playVideo = [UIButton buttonWithType:UIButtonTypeCustom];
        playVideo . tag = videoPlayButtonTag;
        playVideo . frame = CGRectMake(0, 0, 100, 100);
        playVideo . center = CGPointMake(full_screen.size.width/2, full_screen.size.height/2);
        [playVideo setImage:[UIImage imageNamed:@"play_03.png"] forState:UIControlStateNormal];
        [playVideo addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:playVideo];
    }
    else
    {
        playerView.image = [sess.frame renderToImageOfSize:nvm.uploadSize];
    }
}
-(void)moviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playbackState = moviePlayer.playbackState;
    
    if(playbackState == MPMoviePlaybackStateStopped) {
        NSLog(@"MPMoviePlaybackStateStopped");
    } else if(playbackState == MPMoviePlaybackStatePlaying) {
        NSLog(@"MPMoviePlaybackStatePlaying");
    } else if(playbackState == MPMoviePlaybackStatePaused) {
        NSLog(@"MPMoviePlaybackStatePaused");
    } else if(playbackState == MPMoviePlaybackStateInterrupted) {
        NSLog(@"MPMoviePlaybackStateInterrupted");
    } else if (playbackState == MPMoviePlaybackStateSeekingBackward)
    {
        NSLog(@"MPMoviePlaybackStateSeekingBackward");
    }else if (playbackState == MPMoviePlaybackStateSeekingForward)
    {
        NSLog(@"MPMoviePlaybackStateSeekingForward");
    }
}
- (void)playVideo:(UIButton *)sender
{
   [customTabBar unselectCurrentSelectedTab];
    sender.hidden = YES;
    [_playerViewController.moviePlayer setControlStyle:MPMovieControlStyleDefault];
    [_playerViewController.moviePlayer setFullscreen:YES animated:YES];
    [_playerViewController.moviePlayer play];
    
    
}
- (void)moviePlayerDidFinish:(NSNotification *)notification
{
    
    [_playerViewController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_playerViewController.moviePlayer setFullscreen:NO animated:YES];
    [_playerViewController.moviePlayer.view setNeedsDisplay];
   
    
}
- (void)moviePlayerDidEnterFullScreen
{
  //  NSLog(@" enter to full screen");

}

- (void)moviePlayerDidExitFromFullScreen
{
  //  NSLog(@"exit from full screen");
    [_playerViewController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_playerViewController.moviePlayer stop];
    [_playerViewController.moviePlayer prepareToPlay];
    [_playerViewController.moviePlayer.view setNeedsDisplay];
    UIButton *playButton = (UIButton *)[self.view viewWithTag:videoPlayButtonTag];
    [playButton setHidden:NO];
    [self.view bringSubviewToFront:playButton];
}
- (void)allocateToolBarForShareOptions
{
    if (customTabBar != nil) {
        [customTabBar removeFromSuperview];
        customTabBar = nil;
    }
    CGRect rect = CGRectMake(0, full_screen.size.height-customBarHeight, full_screen.size.width, customBarHeight);
    customTabBar = [[OT_TabBar alloc]initWithFrame:rect];
    customTabBar .tag = 333;
    OT_TabBarItem *album = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_album_Image]
                                                  selectedImage:[UIImage imageNamed:share_album_active_Image]
                                                            tag:1];
    
    OT_TabBarItem *email = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_mail_Image]
                                                           selectedImage:[UIImage imageNamed:share_mail_active_Image]
                                                                     tag:2];
    
    OT_TabBarItem *facebook = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_facebook_Image]
                                                          selectedImage:[UIImage imageNamed:share_facebook_active_Image]
                                                                    tag:3];
    
    OT_TabBarItem *instagram = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_instagram_Image]
                                                     selectedImage:[UIImage imageNamed:share_instagram_active_Image]
                                                               tag:4];
    
    OT_TabBarItem *viddy = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_viddy_Image]
                                                  selectedImage:[UIImage imageNamed:share_viddy_active_Image]
                                                            tag:5];
    
    OT_TabBarItem *copyToclipboard = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_clipboard_Image]
                                                           selectedImage:[UIImage imageNamed:share_clipboard_active_Image]
                                                                     tag:5];
    
    OT_TabBarItem *youtube = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_youtube_Image]
                                                         selectedImage:[UIImage imageNamed:share_youtube_active_Image]
                                                                   tag:6];
    
    customTabBar.showOverlayOnSelection = NO;
    customTabBar.backgroundImage = [UIImage imageNamed:bottombarImage];
    customTabBar.delegate        = self;
    
    if (isVideo)
    {
         customTabBar.items = [NSArray arrayWithObjects:album,email,facebook,instagram,viddy,youtube, nil];
    }else
    {
    customTabBar.items = [NSArray arrayWithObjects:album,email,facebook,instagram,copyToclipboard, nil];
    }
    [self.view addSubview:customTabBar];
}

- (void)otTabBar:(OT_TabBar*)tbar didSelectItem:(OT_TabBarItem*)tItem
{
    switch (tItem.tag) {
        case 1:
        {
            nvm.uploadCommand = UPLOAD_PHOTO_ALBUM;
            break;
        }
        case 2:
        {
            nvm.uploadCommand = UPLOAD_EMAIL;
            
            break;
        }
        case 3:
        {
            nvm.uploadCommand= UPLOAD_FACEBOOK_ALBUM;
            
            break;
        }
        case 4:
        {
            nvm.uploadCommand = UPLOAD_INSTAGRAM;
            break;
        }
        case 5:
        {
            if (isVideo)
            {
                nvm.uploadCommand = UPLOAD_VIDDY;
            }else
            {
                nvm.uploadCommand = UPLOAD_CLIPBOARD;
            }

            break;
        }
        case 6:
        {
            nvm.uploadCommand = UPLOAD_YOUTUBE;
            break;
        }
        default:
            break;
    }
    
    if (isVideo)
    {
        [self uploadVideo];
    }else
    {
        [self uploadImage];
    }


}
- (void)uploadVideo
{
    VideoUploadHandler *vHandler = [VideoUploadHandler alloc];
    vHandler.viewController = self;
    vHandler . _view = self.view;
    vHandler.applicationName = appname;
    vHandler.downloadUrl = @"http://www.videocollageapp.com";
    vHandler.website = @"http://www.videocollageapp.com";
    [vHandler uploadVideoAtPath:videoPath to:nvm.uploadCommand];
}
- (void)uploadImage
{
    UploadHandler *uploadH = nil;
    
    uploadH = [UploadHandler alloc];
    uploadH.view = self.view;
    uploadH.viewController = self;
    uploadH.cursess = sess;
    
    [uploadH upload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
