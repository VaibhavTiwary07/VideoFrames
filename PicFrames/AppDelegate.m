//
//  AppDelegate.m
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#if ADS_ENABLE
#import "Mobclix.h"
#import "OT_Config.h"
#import "OT_AdContorl.h"
#endif
#import <RevMobAds/RevMobAds.h>
#import "configparser.h"
#import "PushWizard.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize firstViewController = _firstViewController;
@synthesize navigationController = _navigationController;

static NSString *kAppKey = pushwizard_dev_sdkkey;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_navigationController release];
    [super dealloc];
}

-(void)customizeAlertviewLook
{
    [WCAlertView setDefaultCustomiaztonBlock:^(WCAlertView *alertView){
        alertView.labelTextColor = [UIColor whiteColor];//[UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
    alertView.labelShadowColor = [UIColor blackColor];
    
    UIColor *topGradient = [UIColor colorWithRed:53.0f/256.0f green:55.0f/256.0f blue:56.0f/256.0f alpha:1.0f];
        
    UIColor *middleGradient = [UIColor colorWithRed:53.0f/256.0f green:55.0f/256.0f blue:56.0f/256.0f alpha:1.0f];
    UIColor *bottomGradient = [UIColor colorWithRed:53.0f/256.0f green:55.0f/256.0f blue:56.0f/256.0f alpha:1.0f];
    alertView.gradientColors = @[topGradient,middleGradient,bottomGradient];
    
    alertView.outerFrameColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    
        alertView.buttonTextColor = [UIColor whiteColor];//[UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
    alertView.buttonShadowColor = [UIColor blackColor];
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    NSDictionary *payload = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (payload) {
        [self application:application didReceiveRemoteNotification:payload];
    }



    [[configparser Instance]startSessionWithId:[NSString stringWithFormat:@"%d",iosAppId]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];


#if ADS_ENABLE
    UILocalNotification *localNotif = [launchOptions
                                       objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]; 
    
    if (localNotif) 
    {
        pull = [[OT_PullNotifications alloc]init];
        [pull loadNotifications];
        if(pull)
        {
            [pull showPullNotification];
        } 
    }
#endif
    
    /* Generate help images */
    [Utility generateImagesForHelp];
    
    /* Generate the thumbnail images */
    [Utility generateThumnailsForFrames];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.firstViewController = [[[BackgroundSliderViewController alloc] init] autorelease];
    self.navigationController = [[[UINavigationController alloc]initWithRootViewController:self.firstViewController]autorelease];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

    //self.viewController = [[ViewController alloc]init];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

#if ADS_ENABLE
    [FlurryAds initialize:self.window.rootViewController];
    
    OT_FlurryAd *flurryAd = [OT_FlurryAd sharedInstance];
    [FlurryAds initialize:self.window.rootViewController];

#if FULLSCREENADS_ENABLE
    flurryAd.fullscreenAdView = self.viewController.view;
    [[OT_AdControl sharedInstance]initializeInterstitials];
#endif
#endif

    // Configure the Yozio SDK for Instapicframe - photo collage &amp; photo frames for instagram frames
    [Harpy checkVersion];
    
    /* Set default setting of app booted to YES */
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"applicationbooted"];
    
    [self customizeAlertviewLook];
    
    
    [[OT_Facebook SharedInstance]loginToFacebook:NO onCompletion:nil];

    if(CONFIG_ADVERTISEMENTS_ENABLE == [configparser Instance].advertisements)
    {
        if(NO == bought_watermarkpack)
        {
           // [[RevMobAds session] showFullscreen];
        }
    }
    else
    {
        NSLog(@"Advertisements are disabled, so not showing revmob ad %d",[configparser Instance].advertisements);
    }
    
    //[[InAppPurchaseManager Instance]loadStore];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PushWizard handleNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    [PushWizard startWithToken:token andAppKey:kAppKey andValues:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register for notifications %@",error);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
#if ADS_ENABLE
    [OT_PullNotifications scheduleNotification];
#if BANNERADS_ENABLE
    [self.viewController hideBannerAd];
#endif
#endif  
    self.viewController.applicationSuspended = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [PushWizard endSession];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //[RevMobAds showPopupWithAppID:ot_revmob_appid withDelegate:nil];
    [Harpy checkVersionDaily];
    
    [Appirater appEnteredForeground:YES];
    [FrameSelectionController handleIfAnySocialFollowInProgress];
#if FULLSCREENADS_ENABLE
    /*if ([FlurryAds adReadyForSpace:ot_flurryfullscreenad_name])
    {
        NSLog(@"Displaying Fullscreen Ad ===========");
        [FlurryAds displayAdForSpace:ot_flurryfullscreenad_name onView:self.viewController.view];
    }
    else
    {
        [FlurryAds fetchAdForSpace:ot_flurryfullscreenad_name frame:self.viewController.view.frame size:FULLSCREEN];
    }*/
    
    //[[OT_FlurryAd sharedInstance]showFullscreenAd];
#endif
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
#if ADS_ENABLE
#if FULLSCREENADS_ENABLE
    [[OT_AdControl sharedInstance] cacheInterstitials];
#endif
    
    [[OT_AdControl sharedInstance] enablePeriodicAds];
#if BANNERADS_ENABLE    
    [self.viewController showBannerAd];
#endif
#endif    
    [[OT_Facebook SharedInstance]handleApplicationDidBecomeActive];
    
    [PushWizard updateSessionWithValues:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
#if ADS_ENABLE
#if BANNERADS_ENABLE
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.viewController hideBannerAd];
#endif
#endif    
    [[OT_Facebook SharedInstance]handleApplicationWillTerminate];
}

-(void)application: (UIApplication *)app didReceiveLocalNotification:(UILocalNotification *) notif
{
#if ADS_ENABLE
    pull = [[OT_PullNotifications alloc]init];
    [pull loadNotifications];
    if(pull)
    {
        [pull showPullNotification];
    }
#endif
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[OT_Facebook SharedInstance]handleOpenUrl:url];
}

@end
