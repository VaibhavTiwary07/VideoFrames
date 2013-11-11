//
//  HelpScreenViewController.m
//  HelpScreen
//
//  Created by Outthinking Mac 1 on 30/08/13.
//  Copyright (c) 2013 OutThinking India Pvt Ltd. All rights reserved.
//

#import "HelpScreenViewController.h"
#import "Config.h"
@interface HelpScreenViewController ()
@property(nonatomic,retain)KASlideShow * slideshow;
@end

@implementation HelpScreenViewController
@synthesize slideshow;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self option1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCloseButton:) name:@"notificationDidreachLastImage" object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)showCloseButton:(NSNotification *)notification
{
    NSString *str = (NSString *)notification.object;
     UIButton *but = (UIButton *)[self.view viewWithTag:10];
    if ([str isEqualToString:@"SHOW"]) {
        but . enabled = YES;
    }else
    {
        [but setImage:[UIImage imageNamed:@"close_help.png"] forState:UIControlStateDisabled];
      but . enabled = YES;
    }
   
    
}
-(void)option1
{
    CGRect fullScreen = [[UIScreen mainScreen] bounds];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fullScreen.size.width, 50)];
    backgroundImage . image = [UIImage imageNamed:@"background.png"];
    backgroundImage . userInteractionEnabled = YES;
    [self.view addSubview:backgroundImage];

    UIImageView *barImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fullScreen.size.width, 50)];
    barImage . image = [UIImage imageNamed:@"top-bar_vpf.png"];
    barImage . userInteractionEnabled = YES;
    [self.view addSubview:barImage];

    UILabel *helpTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    helpTextLabel . center = CGPointMake(fullScreen.size.width/2, barImage.frame.size.height/2);
    helpTextLabel . backgroundColor = [UIColor clearColor];
    helpTextLabel . text = @"HELP";
    helpTextLabel . textColor = [UIColor whiteColor];
    helpTextLabel . font = [UIFont boldSystemFontOfSize:16];
    helpTextLabel . textAlignment = NSTextAlignmentCenter;
    [barImage addSubview:helpTextLabel];


    UIImageView *bottomBarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, fullScreen.size.height-50, fullScreen.size.width, 50)];
    bottomBarImage . image = [UIImage imageNamed:@"bottom bar.png"];
    bottomBarImage . userInteractionEnabled = YES;
    [self.view addSubview:bottomBarImage];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton . frame = CGRectMake(220, 0, 200, 40);
    closeButton. center = CGPointMake(fullScreen.size.width/2, bottomBarImage.frame.size.height/2);
    closeButton . tag = 10;
    closeButton . enabled = NO;
    [closeButton setImage:[UIImage imageNamed:@"close_active.png"] forState:UIControlStateNormal];
    [closeButton  addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarImage addSubview:closeButton];

    slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0, 50, fullScreen.size.width , fullScreen.size.height-100)];

    slideshow.delegate = self;
    [slideshow addGesture:KASlideShowGestureAll];
    [slideshow setDelay:3]; // Delay between transitions
    [slideshow setTransitionDuration:1]; // Transition duration
    [slideshow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [slideshow addImagesFromResources:@[@"help-01.png",@"help-02.png",@"help-03.png",@"help-04.png",@"help-05.png",@"help-06.png",@"help-07.png",@"help-08.png"]];

    [self.view addSubview:slideshow];
    [slideshow start];

}
-(void)close
{
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        [slideshow removeFromSuperview];
                    }
                    completion:^(BOOL finish){
                        [self.view removeFromSuperview];
                    }];
}
-(void)showPrevious
{
    NSLog(@"%d",slideshow.currentIndex);
    [slideshow previous];
}
-(void)showNext
{
    [slideshow next];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
