//
//  config.h
//  pullalerts
//
//  Created by Vijay Kumar Reddy Doddavala on 5/24/12.
//  Copyright (c) 2012 Out Thinking Private Limited. All rights reserved.
//

#import "config.h"
#import "InAppPurchaseManager.h"
#ifndef ot_config_h
#define ot_config_h

/* This macro is used to control the banner ads 
   uncomment it to show banner ads 
   comment it to disable banner ads */
#define OT_SDK_BANNERADS     0

/* This macro is used to control the interstitial ads 
 uncomment it to show interstitial ads 
 comment it to disable interstitial ads */
#define OT_SDK_INTERSTITIALADS   0

/* This macro is used to control the periodic ads 
 uncomment it to show periodic ads 
 comment it to disable periodic ads */
#define OT_SDK_PERIODICADS   0

#define OT_SDK_REVMOBADS 0

#define OT_SDK_CHARTBOOST 0

#define OT_SDK_TAPJOYADS 0

/* Fill the Application Id you can find it in itunes connect */
//#define iosAppId  531461090

/* Fill the  */
#define ot_config_url @"http://photoandvideoapps.com/News/instapicframesnews.xml"

//#define ot_control_url @"http://photoandvideoapps.com/News/instapicframescontrol.xml"
#define ot_control_url @"http://photoandvideoapps.com/News/test4.xml"

/* Default cache size */
#define ot_default_ad_cache_size 1

/* Lead Bolt Offer Wall URL */
//#define ot_lb_offerwall @"http://ad.leadboltads.net/show_app_wall?section_id=798710377"

/* Lead Bolt Offer Wall URL */
#define ot_lb_offerwall @"http://ad.leadboltads.net/show_app_wall?section_id=441389911"

/* MobClix App Id */
#define ot_mobclix_appid @"F0FD49C0-115F-4477-B92C-F592A036C33F"
//x#define ot_mobclix_appid @"F0FD49C0-115F-4477-B92C-F592A036C33F"
//     #define mobclixId @"464E6D66-037E-4F3C-A6AB-4D03311CC7C9"
/* Tapjoy App Id */
#define ot_tapjoy_appid  @"40a616d2-1fe7-41db-aa7a-5ac00c0d4531"

/* Tapjoy Secret Key */
#define ot_tapjoy_secretkey @"K7r3rYGvIsodGCwdpkeZ"

/* Tapjoy App Id */
//#define ot_tapjoy_appid  @"5b2e332d-af97-497a-9e60-2ef38c9083ca"


/* Tapjoy Secret Key */
//#define ot_tapjoy_secretkey @"DG8hrS3sds4h2v9RT2jB"

/* Revmob appid */
#define ot_revmob_appid @"523a11f96600eacc66000006"

/* Chartboost Appid */
//#define ot_chartboost_appid @"50256b899c890d2527000016"
#define ot_chartboost_appid @"5044a2c917ba475c42000047"

/* millinial media banner ad api key */
#define ot_mmedia_bannerad @"109688"

/* millinial media banner ad api key */
#define ot_mmedia_fullscreen @"110187"

#define ot_inmobi_appid      @"12fe390a7a4042c3a5997eb1b4e96ce7"

#define ot_flurry_key        flurrykey
/* Chartboost Appsignature */
//#define ot_chartboost_appsignature @"51660ad5d9001c4ae0aec9e4ddb38d549eea5fac"
#define ot_chartboost_appsignature @"93f4ae2bb3d607dd9d04f31b0a5d00e1e3673b9d"

#define admobId_ipad @"51266bd4923d43d1"

#define admobId_iphone @"4965f34510b246a4"

#define upgradedToPro ([[InAppPurchaseManager Instance]anyPurchasesMadeSoFar])
#endif
