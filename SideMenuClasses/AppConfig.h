//
//  AppConfig.h
//  FaceBookNativeAdTest
//
//  Created by Deepti's Mac on 12/3/15.
//  Copyright © 2015 D.Yoganjulu  Reddy. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#define applicationId 712175767
#define applicationName @"VideoCollage"

#define appReviewUrl @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"
#define websiteUrl @"http://www.outthinkingindia.com"
#define facebookId @"564692443591238"
#define instagramUrl @"instagram://user?username=outthinking"
#define facebookUrl @"fb://profile/%@",@"564692443591238"
//#define moreAppsUrl @"http://appstore.com/outthinkinglimited"
#define moreAppsUrl @"http://www.appstore.com/outthinkinglimited"
#define appIconName @"Sidecon.png"
#define facebookPlacementId @"960095180677895_1025341224153290"
#define aboutAppScreenHightGap        (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ?300 : 50)
#define adHieghtPercentage         (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ?0.45f : 0.4f)
#define full_Screen [[UIScreen mainScreen]bounds]
#define toolbarHeight 50.0
#define adView_height 0.5
#define  adBagViewTag 100
#define  adScrollviewTag 101
#define addSize         (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ?350 : 120)
#define ad_gap         (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ?45 : 30)

#define startAdHieghtPercentage         (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ?0.47f : 0.45f)

#define Purchased_Number_defaults [NSUserDefaults standardUserDefaults]

#define Subscription_Number_defaults [NSUserDefaults standardUserDefaults]

#define NativeAd_Home_defaults [NSUserDefaults standardUserDefaults]

#define secondScreenbuttonWidth  (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 52.0f : 45.0f)

#define activeTextColor ([UIColor colorWithRed:9.0f/255.0f green:255.0f/255.0f blue:246.0f/255.0f alpha:255.0f/255.0f])

#define backButtonWidthHeight (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ?50.0f : 40.0f)

#define lowerstripheight  (([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)?50:(UIUserInterfaceIdiomPhone==[UIDevice currentDevice].userInterfaceIdiom) && (fullScreen.size.height>568.0)?50:(UIUserInterfaceIdiomPhone==[UIDevice currentDevice].userInterfaceIdiom) && (fullScreen.size.height>480.0)?50:50)

#define backStripHeight ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?30.0:20.0)

#define GDPR_Ads_Access [NSUserDefaults standardUserDefaults]

#endif /* AppConfig_h */
