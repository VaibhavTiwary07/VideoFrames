//
//  AppDelegate.h
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Harpy.h"
#if ADS_ENABLE
#import "OT_PullNotifications.h"
#import "OT_FlurryAd.h"
#endif
#import "WCAlertView.h"
#import "BackgroundSliderViewController.h"
#import "SRSubscriptionModel.h"
#import "ViewController.h"
//#import "StartViewController.h"
//#import "REFrostedViewController.h"
//#import <GoogleMobileAds/GoogleMobileAds.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

//#import "StartViewController.h"

#import "REFrostedViewController.h"
#import "SimpleSubscriptionView.h"

#import <FirebaseDynamicLinks/FirebaseDynamicLinks.h>
//#import "Firebase.h"

//@import GoogleMobileAds;

//kasaram pro newbuild trying
//Trail period working




@class ViewController;
//@class StartViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate,REFrostedViewControllerDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver,SKPaymentQueueDelegate,GADFullScreenContentDelegate>

{
  
#if ADS_ENABLE
    OT_PullNotifications *pull;

#endif

    //PaymentTransactionObserver * observer;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;
@property (strong, nonatomic) SimpleSubscriptionView *universalController;
@property (strong, nonatomic) DEMOMenuViewController *demomenuController;
@property (strong, nonatomic) UINavigationController *navigationController;

//DynamicLinks

@property(nonatomic,assign)NSURL*incomingDynamicLink,*urlParamerterIs;
@property(nonatomic,strong)NSURL *recievingDynamicLink;
@property(nonatomic,assign) BOOL isDynamicRecieved;
@property(nonatomic,assign) BOOL sendingOncePush;

//@property (strong, nonatomic) StartViewController *firstView;

//changes - done

@end
