//
//  AppDelegate.m
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Appirater.h"
#import "Config.h"
#import "DEMONavigationController.h"
#import "DEMOMenuViewController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
@import FirebaseCore;
@import FirebaseDynamicLinks;
#import "VideoCollage-Swift.h"
#import "VideoFrames-Bridging-Header.h"
#import <StoreKit/StoreKit.h>


@class VideoCollagePro;

@implementation AppDelegate

@synthesize window = _window;
//@synthesize viewController = _viewController;
//@synthesize firstViewController = _firstViewController;
@synthesize navigationController = _navigationController;


- (void)dealloc
{
   // [_window release];
   // [_viewController release];
//    [_firstViewController release];
 //   [_navigationController release];
//    [_demomenuController release];
//    [_firstViewController release];
//    [_universalController release];
 //   [super dealloc];
}

- (NSString *)getSKAdNetworkVersion {
    if (@available(iOS 16.1, *)) {
        return @"SKAdNetwork v4";
    } else if (@available(iOS 14.8, *)) {
        return @"SKAdNetwork v3";
    } else if (@available(iOS 14.6, *)) {
        return @"SKAdNetwork v2";
    } else if (@available(iOS 14.0, *)) {
        return @"SKAdNetwork v1";
    } else {
        return @"Not Supported";
    }
}


-(void)customizeAlertviewLook
{
    [WCAlertView setDefaultCustomiaztonBlock:^(WCAlertView *alertView){
        alertView.labelTextColor = [UIColor whiteColor];//[UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
    alertView.labelShadowColor = [UIColor blackColor];
    
    UIColor *topGradient = [UIColor colorWithRed:(9.0/255.0) green:(22.0/255.0) blue:(48.0/255.0) alpha:1.0];
        
    UIColor *middleGradient = [UIColor colorWithRed:(9.0/255.0) green:(22.0/255.0) blue:(48.0/255.0) alpha:1.0];
    UIColor *bottomGradient = [UIColor colorWithRed:(9.0/255.0) green:(22.0/255.0) blue:(48.0/255.0) alpha:1.0];
    alertView.gradientColors = @[topGradient,middleGradient,bottomGradient];
    
    alertView.outerFrameColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    
        alertView.buttonTextColor = [UIColor whiteColor];//[UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
    alertView.buttonShadowColor = [UIColor blackColor];
    }];
}

-(void)callingThumbnails
{
   
    [Utility generateThumnailsForFrames];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"callingFromEffects"];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    NSLog(@"incomingDynamicLink url is----didfinishlaunchwithoptions %@",self.incomingDynamicLink);

    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    //-----loading InAppManager-----//
    
    if (@available(iOS 11.2, *)) {
        [[InAppPurchaseManager Instance]loadStore];
    } else {
        // Fallback on earlier versions
        [[InAppPurchaseManager Instance]loadStore];
    }
    NSLog(@"Load store from appdelegate");
    [SRSubscriptionModel shareKit];
    [[SRSubscriptionModel shareKit]loadProducts]; // newly added here
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    
    NSString *skADNetwork = [self getSKAdNetworkVersion];
    NSLog(@"SK AD Network version is %@ ",skADNetwork);
    
     //firebase initializing
    [FIRApp configure];
//    [FIRCrashlytics initialize];
//#if DEBUG
//    [[FIRCrashlytics crashlytics] setCrashlyticsCollectionEnabled:YES];
//#else
//    [[FIRCrashlytics crashlytics] setCrashlyticsCollectionEnabled:YES];
//#endif
    
  //  [FIROptions defaultOptions].deepLinkURLScheme = FIRDynamicLinks.description;
    
 //   NSLog(@"dynamic link description here---%@",FIRDynamicLinks.description);
  
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = DARK_GRAY_BG;


        // Create an instance of the Swift view controller
    
    StartViewController *homeVC = [[StartViewController alloc] init];
    
    //[homeVC remoteConfigurationSetUp];
        // Create a navigation controller with the Swift view controller as its root
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeVC];
        
        // Set the navigation controller as the window's root view controller
        self.window.rootViewController = navController;
    
    // Enforce dark mode
       if (@available(iOS 13.0, *)) {
           self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
       }

    
        [self.window makeKeyAndVisible];
        
        return YES;

     //Existing one
    
    /* Set default setting of app booted to YES */
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"applicationbooted"];
    
    [self customizeAlertviewLook];

    [Appirater setAppId:iosAppIdString];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setDebug:NO];
    [Appirater setTimeBeforeReminding:1];
    [Appirater setSignificantEventsUntilPrompt:1];

 
    return YES;
}


-(void)loadingFrmesAndHelpScreen
{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        /* Generate help images */
        [Utility generateImagesForHelp];

        /* Generate the thumbnail images */
        [Utility generateThumnailsForFrames];

    });
 

    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"application Will Resign Active");
 
    //Existing one
}

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    NSLog(@"application Did Enter Background");
//   // [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
////commented
//   
//    //self.viewController . app
//    
//}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"############# application Did Enter Background");
    // Start a background task to prevent immediate termination
    self.backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up if we run out of time
        [application endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    // You have about 30 seconds to complete tasks
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Perform your background work here
        
        // When done, end the task
        [application endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"############# application Will Enter Foreground");
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        [application endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
    // Social follow handling removed - not used in refactored FrameSelectionController
    // [FrameSelectionController handleIfAnySocialFollowInProgress];
}

//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    NSLog(@"application Will Enter Foreground");
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    //[RevMobAds showPopupWithAppID:ot_revmob_appid withDelegate:nil];
//   // [Harpy checkVersionDaily];
//        //[Appirater appEnteredForeground:YES];
//    [FrameSelectionController handleIfAnySocialFollowInProgress];
//
//}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"application Did Become Active");
//    StartViewController *homeVC = [[StartViewController alloc] init];
//    [homeVC remoteConfigurationSetUp];
}


// Enable state preservation
//- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
//    return YES;
//}

- (BOOL)application:(UIApplication *)application
shouldSaveSecureApplicationState:(NSCoder *)coder
{
    return YES; // or your custom logic
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}


-(void)application: (UIApplication *)app didReceiveLocalNotification:(UILocalNotification *) notif
{
    NSLog(@"did Receive Local Notification");
#if ADS_ENABLE
    pull = [[OT_PullNotifications alloc]init];
    [pull loadNotifications];
    if(pull)
    {
        [pull showPullNotification];
    }
#endif
    
}


//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
////    return [[FBSDKApplicationDelegate sharedInstance] application:application
////                                                          openURL:url
////                                                sourceApplication:sourceApplication
////                                                       annotation:annotation];
//    return NULL;
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"File opened from URL: %@", url);
    // You can handle or forward the file here
    return YES;
}

-(void)settingPopUpAlertDelegate
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

   // saving an Integer
   [prefs setInteger:1 forKey:@"PopUpShowed"];
   
}
-(void)settingPopUpAlertSecondTime
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // saving an Integer
   [prefs setInteger:1 forKey:@"PopUpSecondTime"];
   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Application Terminate -----");
    [self settingPopUpAlertDelegate];
    [self settingPopUpAlertSecondTime];
//    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(popupSelectionSecondTime) name:UIApplicationWillTerminateNotification
//  object:nil];
    //Removing Transaction Details//
   // [SKPaymentQueue.defaultQueue removeTransactionObserver:self];
    //commented
}

- (void)requestIDFA {
  [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
  }];
}


- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response { 
    
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions { 
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
