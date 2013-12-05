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
@property (nonatomic , assign)bool finished;
@end

@implementation HelpScreenViewController
@synthesize slideshow;
@synthesize finished;
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

    if ([str isEqualToString:@"SHOW"])
    {
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view bringSubviewToFront:but];
            but.frame = CGRectMake(0, 0, full_screen.size.width, colorBurttonHeight);

        }completion:^(BOOL finished) {


        }];
    }else
    {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view bringSubviewToFront:but];
            but.frame = CGRectMake(0, 0, full_screen.size.width, 00);

        }completion:^(BOOL finished) {
        }];

    }
}

-(void)option1
{
    CGRect fullScreen = [[UIScreen mainScreen] bounds];
   

    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(00, 0, full_screen.size.width, full_screen.size.height)];
    backgroundView . userInteractionEnabled = YES;
    backgroundView. tag = 50;
    [self.view addSubview:backgroundView];

    slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0, 0, fullScreen.size.width , fullScreen.size.height)];
    slideshow.delegate = self;
    [slideshow addGesture:KASlideShowGestureAll];
    [slideshow setDelay:3]; // Delay between transitions
    [slideshow setTransitionDuration:1]; // Transition duration
    [slideshow setTransitionType:KASlideShowTransitionSlide]; // Choose a transition type (fade or slide)
    [slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display



    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && (fullScreen . size. height>480))
    {

    [slideshow addImagesFromResources:@[@"help-01_1136.png",@"help-02_1136.png",@"help-03_1136.png",@"help-04_1136.png",@"help-05_1136.png",@"help-06_1136.png",@"help-07_1136.png",@"help-08_1136.png"]];

    }else if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) && (fullScreen.size.height== 480))
    {
    [slideshow addImagesFromResources:@[@"help-01.png",@"help-02.png",@"help-03.png",@"help-04.png",@"help-05.png",@"help-06.png",@"help-07.png",@"help-08.png"]];
    }


    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [slideshow addImagesFromResources:@[@"help-01_1024.png",@"help-02_1024.png",@"help-03_1024.png",@"help-04_1024.png",@"help-05_1024.png",@"help-06_1024.png",@"help-07_1024.png",@"help-08_1024.png"]];

    }

    [backgroundView addSubview:slideshow];
    [slideshow start];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton . frame = CGRectMake(0, 0, full_screen.size.width, 0);
    closeButton . tag = 10;
   
    [closeButton setImage:[UIImage imageNamed:help_close_Button] forState:UIControlStateNormal];
    [closeButton  addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:closeButton];
    [backgroundView bringSubviewToFront:closeButton];

}
-(void)close
{
    UIView *backgroundView = (UIView *)[self.view viewWithTag:50];
    UIButton *but = (UIButton *)[self.view viewWithTag:10];
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        
                        [but removeFromSuperview];
                        [slideshow stop];
                        [slideshow removeFromSuperview];
                    }
                    completion:^(BOOL finish){
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationDidreachLastImage" object:nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"didEnterToTouchDetectedMode" object:nil];
                        [backgroundView removeFromSuperview];
                        [self.view removeFromSuperview];

                    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
