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
#import "Config.h"
#define fullscreen   ([[UIScreen mainScreen]bounds])
#define animationTime ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?5.0f:15.0f)
#define foregroundImage ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"FirstScreen_background1024.png":@"FirstScreen_background.png")
#define cloudImage ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"bluecloud1024.png":@"blueCloud.png")
#define startButton_size ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?150:100)
#define socialButton_size ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?100:75)

@interface BackgroundSliderViewController ()
{
    int valueToADD;
    UIImageView *backgroundImageView,*foregroundImageView;
    NSTimer *timer1, *timer2;
    CABasicAnimation *move, *move2;
    UIWebView *webView;
     ViewController *viewController;

}

@end

@implementation BackgroundSliderViewController
-(void)applicationWillEnterForeground
{
    [self moveAnimation];
    [backgroundImageView.layer addAnimation:move forKey:@"move"];


}
- (void)viewDidLoad
{
 [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(applicationWillEnterForeground)
                                              name:UIApplicationWillEnterForegroundNotification
                                            object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:@"notificationDidEnterToFirstScreen"
                                               object:nil];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }


    [super viewDidLoad];

    NSString *image_name = foregroundImage;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fullscreen.size.height>480) {
        image_name = @"FirstScreen_background1136.png";
    }
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,2400,fullscreen.size.height)];
    backgroundImageView . image = [UIImage imageNamed:cloudImage];
    [self.view addSubview:backgroundImageView];
    [self moveAnimation];
    [backgroundImageView.layer addAnimation:move forKey:@"move"];


    foregroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(00,0,fullscreen.size.width,fullscreen.size.height)];
    foregroundImageView . image = [UIImage imageNamed:image_name];
    [self.view addSubview:foregroundImageView];


    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton . frame = CGRectMake(100, 100, startButton_size, startButton_size);
    startButton . center = CGPointMake(full_screen.size.width/2, full_screen.size.height/1.45);
    [startButton setImage:[UIImage imageNamed:@"start_new.png"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];

    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    facebookButton . tag = 1;
    facebookButton . frame = CGRectMake(0, 0, socialButton_size, socialButton_size);
    facebookButton . center = CGPointMake(fullscreen.size.width/2-(facebookButton.frame.size.width), fullscreen.size.height-(socialButton_size/2)-10);
    [facebookButton setBackgroundImage:[UIImage imageNamed:@"facebookF_vpf.png"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:facebookButton];

    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twitterButton . tag = 2;
    twitterButton . frame = CGRectMake(0, 00, socialButton_size, socialButton_size);
    twitterButton . center = CGPointMake(fullscreen.size.width/2, fullscreen.size.height-(socialButton_size/2)-10);
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"twitterF_vpf.png"] forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitterButton];

    UIButton *instagramButton = [UIButton buttonWithType:UIButtonTypeCustom];
    instagramButton . tag = 3;
    instagramButton . frame = CGRectMake(0, 00, socialButton_size, socialButton_size);
    instagramButton . center = CGPointMake(fullscreen.size.width/2+(instagramButton.frame.size.width), fullscreen.size.height-(socialButton_size/2)-10);
    [instagramButton setBackgroundImage:[UIImage imageNamed:@"instagramF_vpf.png"] forState:UIControlStateNormal];
    [instagramButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:instagramButton];

    [self addAnimationToButton:facebookButton];
    [self addAnimationToButton:twitterButton];
    [self addAnimationToButton:instagramButton];

}

-(void)addAnimationToButton:(UIButton *)aButton
{
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.autoreverses = YES;
    fadeAnim.toValue = [NSNumber numberWithFloat:0.6];
    fadeAnim. repeatCount = FLT_MAX;
    fadeAnim.duration = 0.7;
    [aButton.layer addAnimation:fadeAnim forKey:@"opacity"];
}

-(void)startAction
{
    if (viewController == nil)
    {
        viewController = [[ViewController alloc] init];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationdidLoadView" object:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)moveAnimation
{
    move = [CABasicAnimation animationWithKeyPath:@"transform.translation.x" ];

    [move setFromValue:[NSNumber numberWithFloat:0.0f]];

    [move setToValue:[NSNumber numberWithFloat:(fullscreen.size.width-2400)]];
    [move setRepeatCount:FLT_MAX];

    [move setDuration:animationTime];
}
-(void)actionForButton:(UIButton *)aButton
{
    
    NSURL *url = [[NSURL alloc] init];
    
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
        [[UIApplication sharedApplication] openURL:url];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
