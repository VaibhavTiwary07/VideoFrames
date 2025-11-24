//
//  BackgroundSliderViewController.m
//  BackgroundSliderTest
//
//  Created by Outthinking Mac 1 on 26/09/13.
//  Copyright (c) 2013 OutThinking India Pvt Ltd. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BackgroundSliderViewController.h"
#import "ViewController.h"
#import "MainController.h"
#import "Config.h"
#define fullscreen   ([[UIScreen mainScreen]bounds])
#define animationTime ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?5.0f:15.0f)
#define foregroundImage ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"FirstScreen_background1024.png":@"FirstScreen_background.png")
#define cloudImage ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"bluecloud1024.png":@"blueCloud.png")
#define startButton_size ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?120:80)
#define logo_size ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?340:280)
#define socialButton_size ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?100:75)

@interface BackgroundSliderViewController ()
{
    int valueToADD;
    UIImageView *backgroundImageView,*foregroundImageView;
    NSTimer *timer1, *timer2;
    CABasicAnimation *move, *move2;
   // UIWebView *webView;
    
    MainController *viewController;
    
    UIView* separatedview;

}

@end

@implementation BackgroundSliderViewController
- (void)applicationWillEnterForeground
{
    [self moveAnimation];
    [backgroundImageView.layer addAnimation:move forKey:@"move"];


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad
{
    printf("--- BackgroundSliderViewController.m: viewDidLoad ---\n");
 [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(applicationWillEnterForeground)
                                              name:UIApplicationWillEnterForegroundNotification
                                            object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:@"notificationDidEnterToFirstScreen"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEntersBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [self setNeedsStatusBarAppearanceUpdate]; // Refresh the status bar visibility

    [super viewDidLoad];

    viewController = nil;
    NSString *image_name = foregroundImage;
//     CGRect fullScreen = [[UIScreen mainScreen] bounds];

//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && fullscreen.size.height>480)
//    {
//        image_name = @"bg1136.png";
//    }
//    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//    {
//      image_name= @"bg960.png";
//    }
    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height == 2208))
    {
        image_name = @"bg1136.png";
        
    }
    
    else if(([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ) && (fullScreen.size.height == 1334))
    {
        image_name = @"bg1136.png";
      
    }
    else if(([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ) && (fullScreen.size.height == 1136))
    {
        image_name = @"bg1136.png";
       
    }
    
    
    
    else  if(([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)&& (fullScreen.size.height== 2048))
    {
        
        image_name = @"bg.png";
       
        
    }
    else  if(([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)&& (fullScreen.size.height== 2048))
    {
        
         image_name = @"bg.png";
        
    }
    else
    {
         image_name = @"bg960.png";
    }



    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,2400,fullscreen.size.height)];
    backgroundImageView . image = [UIImage imageNamed:cloudImage];
    [self.view addSubview:backgroundImageView];
    [self moveAnimation];
    [backgroundImageView.layer addAnimation:move forKey:@"move"];


    foregroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(00,0,fullscreen.size.width,fullscreen.size.height)];
    foregroundImageView . image = [UIImage imageNamed:image_name];
    [self.view addSubview:foregroundImageView];
    
    UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoButton . frame = CGRectMake(100, 100,logo_size+100, logo_size+100);
    logoButton . center = CGPointMake(full_screen.size.width/2, full_screen.size.height/4);
    [logoButton setImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [self.view addSubview:logoButton];



    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton . frame = CGRectMake(100, 100, startButton_size, startButton_size);
    startButton . center = CGPointMake(full_screen.size.width/2, full_screen.size.height/1.45);
    [startButton setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];

    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookButton . tag = 1;
    facebookButton . frame = CGRectMake(0, 0, socialButton_size, socialButton_size);
    facebookButton . center = CGPointMake(fullscreen.size.width/2-(facebookButton.frame.size.width), fullscreen.size.height-(socialButton_size/2)-10);
    [facebookButton setBackgroundImage:[UIImage imageNamed:@"facebookF_vpf.png"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:facebookButton];

    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twitterButton . tag = 2;
    twitterButton . frame = CGRectMake(0, 00, socialButton_size, socialButton_size);
    twitterButton . center = CGPointMake(fullscreen.size.width/2, fullscreen.size.height-(socialButton_size/2)-10);
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"twitterF_vpf.png"] forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:twitterButton];

    UIButton *instagramButton = [UIButton buttonWithType:UIButtonTypeCustom];
    instagramButton . tag = 3;
    instagramButton . frame = CGRectMake(0, 00, socialButton_size, socialButton_size);
    instagramButton . center = CGPointMake(fullscreen.size.width/2+(instagramButton.frame.size.width), fullscreen.size.height-(socialButton_size/2)-10);
    [instagramButton setBackgroundImage:[UIImage imageNamed:@"instagramF_vpf.png"] forState:UIControlStateNormal];
    [instagramButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addSubview:instagramButton];

    [self addAnimationToButton:facebookButton];
    [self addAnimationToButton:twitterButton];
    [self addAnimationToButton:instagramButton];

}

-(void)appEntersBackground
{
    viewController . applicationSuspended = YES;
}
- (void)addAnimationToButton:(UIButton *)aButton
{
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.autoreverses = YES;
    fadeAnim.toValue = [NSNumber numberWithFloat:0.6];
    fadeAnim. repeatCount = FLT_MAX;
    fadeAnim.duration = 0.7;
    [aButton.layer addAnimation:fadeAnim forKey:@"opacity"];
}
#pragma ActivtyIndicator
-(void)showLoadingForFrames
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    // saving an NSString
    [prefs setObject:@"FramesSaved" forKey:@"FramesLoadedFirst"];
    
    [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Getting Frames",@"Getting Frames")];
    
    [self performSelector:@selector(startFramesdownloading) withObject:nil afterDelay:3.0 ];
    

}
-(void)startFramesdownloading
{
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:55.0 ];
    [self loadingFrmesAndHelpScreen];
}
-(void)loadingFrmesAndHelpScreen
{
    /* Generate help images */
    [Utility generateImagesForHelp];
    
    /* Generate the thumbnail images */
    [Utility generateThumnailsForFrames];
    
}

-(void)hideActivityIndicator
{
    [Utility removeActivityIndicatorFrom:self.view];
    
    if (viewController == nil)
    {
        viewController = [[MainController alloc] init];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationdidLoadView" object:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    
}
- (void)startAction
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    if([prefs objectForKey:@"FramesLoadedFirst"]!=nil )
    {
        
        if (viewController == nil)
        {
            viewController = [[MainController alloc] init];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationdidLoadView" object:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self showLoadingForFrames];
    }
   
    
    
}
- (void)moveAnimation
{
    move = [CABasicAnimation animationWithKeyPath:@"transform.translation.x" ];

    [move setFromValue:[NSNumber numberWithFloat:0.0f]];

    [move setToValue:[NSNumber numberWithFloat:(fullscreen.size.width-2400)]];
    [move setRepeatCount:FLT_MAX];

    [move setDuration:animationTime];
}

- (void)actionForButton:(UIButton *)aButton
{
    
    NSURL *url = [[NSURL alloc] init ];
    
    switch (aButton.tag)
    {
        case 1:
        {
           url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",@"564692443591238"]];
            break;
        }
        case 2:
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@",@"OutthinkingInd"]];
            break;
        }
        case 3:
        {
            url = [NSURL URLWithString:@"instagram://user?username=outthinking"];
            break;
        }

        default:
            break;
    }
    
    NSLog(@" Print URL : %@", url);
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{}  completionHandler:nil];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
