//
//  AppDelegate.h
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Tapjoy/Tapjoy.h>
//#import "Appoxee.h"
//#import "AppoxeeManager.h"
#import "Harpy.h"
#if ADS_ENABLE
#import "OT_Config.h"
#import "OT_PullNotifications.h"
#import "OT_FlurryAd.h"
#endif
#import "OT_Config.h"
#import "WCAlertView.h"
#import "BackgroundSliderViewController.h"
#import "GADInterstitial.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,GADInterstitialDelegate>
{
#if ADS_ENABLE
    OT_PullNotifications *pull;

#endif


}
@property(nonatomic, retain) GADInterstitial *interstitial;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) BackgroundSliderViewController *firstViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
