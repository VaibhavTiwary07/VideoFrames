//
//  OT_AdContorl.h
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 8/11/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OT_Config.h"
#if OT_SDK_INTERSTITIALADS
#if OT_SDK_CHARTBOOST
#import "Chartboost.h"
#endif
#import "TapjoyConnect.h"
#import "OT_PullNotifications.h"
#endif
#if OT_SDK_REVMOBADS
#import <RevMobAds/RevMobAds.h>
#endif
#if OT_SDK_BANNERADS
#import "iAd/ADBannerView.h"
#import "MobclixAdView.h"
#if OT_SDK_MOPUB
#import "MPAdView.h"
#endif
#import "Mobclix.h"
#endif
#if OT_SDK_PERIODICADS
#import <GameBreak/CHADManager.h>
#endif
#import "InAppPurchaseManager.h"

typedef enum
{
    SELF_INTERSTITIAL,
    CHARTBOOST_INTERSTITIAL,
    TAPJOY_INTERSTITIAL,
    REVMOB_INTERSTITIAL,
    DISABLE_INTERSTITIAL = 100
}eOT_InterstitialAd;

typedef enum
{
    MOBCLIX_BANNERAD,
#if OT_SDK_MOPUB    
    MOPUB_BANNERAD,
#endif    
    MOBCLIX_IAD_IPAD_BANNERAD,
    DISABLE_BANNERAD = 100
}eOT_BannerAd;

typedef enum
{
	ADCONTROL_ELEMENT_INTERSTITIAL,
	ADCONTROL_ELEMENT_BANNER,
    ADCONTROL_ELEMENT_GAMEBREAK,
    ADCONTROL_ELEMENT_GAMEBREAK_FREQUENCY,
    ADCONTROL_ELEMENT_IGNORE
}eAdcontrol_Element;

#define element_Interstitial @"InterstitialAd"
#define element_Banner @"BannerAd"
#define element_Gamebreak @"GameBreak"
#define element_GamebreakFrequency @"GameBreak_Frequency"


@interface OT_AdControl : NSObject <NSXMLParserDelegate
#if OT_SDK_INTERSTITIALADS
#if OT_SDK_CHARTBOOST
,ChartboostDelegate
#endif
#endif
#if OT_SDK_BANNERADS
,MobclixAdViewDelegate,
#if OT_SDK_MOPUB
MPAdViewDelegate,
#endif
ADBannerViewDelegate
#endif
>
{
    
}

@property(nonatomic,readonly)eOT_InterstitialAd eInterstitial;
@property(nonatomic,readonly)eOT_BannerAd eBanner;
@property(nonatomic,readonly)BOOL synchedWithServer;
@property(nonatomic,assign)id viewcontroller;

+(OT_AdControl*)sharedInstance ;
-(void)initializeInterstitials;
-(void)cacheInterstitials;
-(void)showInterstitialIn:(id)viewcontroller;
-(eOT_BannerAd)getBannerAdSettingFromServer;

-(void)initializeBannerAds;
-(void)addBannerAdToViewController:(UIViewController*)viewCtrl;
-(void)bringBannerAdToFrontInSuperView:(UIView*)view;
-(void)unhideBannerAds;
-(void)hideBannerAds;
-(void)resumeBannerAds;
-(void)pauseBannerAds;
-(void)removeBannerAds;

-(void)enablePeriodicAds;

@end
