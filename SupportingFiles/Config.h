//
//  Config.h
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "DeviceHw.h"
#import "PubTypes.h"
#ifndef PicFrames_Config_h
#define PicFrames_Config_h

#if defined(VideoCollagePRO)
#define proVersion 1
#define freeVersion 0
#define BANNERADS_ENABLE 0
#else
#define proVersion 0
#define freeVersion 1
#define BANNERADS_ENABLE 1
#endif

#define KeyWindow ({ \
    UIWindow *window = nil; \
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) { \
        if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) { \
            window = scene.windows.firstObject; \
            break; \
        } \
    } \
    window; \
})

#define SafeAreaBottomPadding KeyWindow.safeAreaInsets.bottom
#define SafeAreaTopPadding KeyWindow.safeAreaInsets.top

//VideoGrid
#define fullScreen ([[UIScreen mainScreen]bounds])
#define small_Detent (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?(fullScreen.size.height * 0.25):fullScreen.size.height * 0.25)
#define mediumSmall_Detent (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?(fullScreen.size.height * 0.18):fullScreen.size.height * 0.20)
#define verySmall_Detent (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?(fullScreen.size.height * 0.15):fullScreen.size.height * 0.18)
#define buttonPlacementOffset 10
#define mainBGTag  121212
#define toolBarOffset 5
#define terms_n_conditions_text @"                           \n\n All the payments or transactions made through iTunes handled and controlled by Apple. upon confirmation of purchase, the payment will be charged to the iTunes account. Until you turn off the auto-renew at least 24 hours before the end of the current period it will be automatically renewed. The account will be charged for renewal within 24 hours prior to the end of the current period, and identify the cost of the renewal.  any unused portion of a free trial period, if offered, will be forfeited if you purchase a subscription to that publication, where applicable - If you decide to turn off auto-renewal, you can turn it off by going to iTunes account settings after purchase"
#define subscription_Details @"\n\u2022 No Ads \n\u2022 No Watermark on your videos \n\u2022 Unlimited music,video,all effects \n\u2022 Unlimited background color,patterns\n"

#define secreteSharedKeyForSubcription @"5fc96744668a430fbe7d7d4efeb010c6"



#define gridCornerSticker_size ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?50.0:40.0)
#define gridCornerSticker_font ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?18.0:15.0)
#define gridCornerSticker_label_size ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?30.0:30.0)
//end here

//effect screen
#define effect_done_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"done_ipad.png":@"done_effect.png")
#define effect_cancel_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"close_ipad.png":@"close_effect.png")

//end
//shareView
#define play_but_width ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?50:30)
#define frame_size ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?600.0:600.0)
#define share_background_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"background_ipad.png":@"background_1136@2x")
#define share_back_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"back_ipad.png":@"share_back.png")
#define share_album_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_album_ipad.png":@"share_album.png")
#define share_mail_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_mail_ipad.png":@"share_mail.png")
#define share_facebook_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_facebook_ipad.png":@"share_facebook.png")
#define share_instagram_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_instagram_ipad.png":@"share_instagram.png")
#define share_clipboard_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_clipboard_ipad.png":@"share_clipboard.png")
#define share_viddy_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_viddy_ipad":@"share_viddy.png")
#define share_youtube_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_youtube_ipad":@"share_youtube.png")

#define share_album_active_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_album_active_ipad.png":@"share_album_active.png")
#define share_mail_active_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_mail_active_ipad.png":@"share_mail_active.png")
#define share_facebook_active_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_facebook_active_ipad.png":@"share_facebook_active.png")
#define share_instagram_active_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_instagram_active_ipad.png":@"share_instagram_active.png")
#define share_clipboard_active_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_clipboard_active_ipad.png":@"share_clipboard_active.png")
#define share_viddy_active_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_viddy_active_ipad":@"share_viddy_active.png")
#define share_youtube_active_Image ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_youtube_activeIpad":@"share_youtube_active.png")
//new



//end here
#define help_close_Button ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"exit-button_ipad2.png":@"exit-button2.png")
#define videoGridViewHeight ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?300.0:200.0)
#define colorBackgroundBarHeightHeight ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?80.0:60.0)
#define colorBurttonHeight ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?75.0:50.0)
#define bottombarImage ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"bottom bar_ipad.png":@"bottom bar.png")
#define backgroundBarImage ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"backgroundStrip_ipad.png":@"backgroundStrip.png")

#define colorPatternBarImage ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"color-gallery-strip_ipad.png":@"color-gallery-strip.png")
#define colorButtonImage ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"color_button_ipad.png":@"color_button.png")
#define sliderBackGroundImage ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"settings-popup-1024.png":@"settings_popup1136.png")

#define patternButtonImage ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"pattern_button_ipad.png":@"pattern_button.png")

#define colorButtonImage_active ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"color_active_ipad.png":@"color-active_button.png")

#define patternButtonImage_active ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"pattern_button_active_ipad.png":@"pattern_active_button.png")

#define customBarHeight ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?44.0:49.0)

#define ad_x ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?75.0:25.0)
#define ad_y ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?35.0:10.0)
#define ad_size ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?50.0:25.0)
#define install_size_width ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?150.0:75.0)
#define pro_x ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?150.0:90.0)

#define hepl_button_x ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?30.0:0.0)
#define appoxee_button_x ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?70.0:42.50)

#define frame_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"frame~ipad":@"frames_vpf")

#define select_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"color~ipad":@"color_vpf")

#define effects_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"effects_button_ipad":@"effects_button")

#define setting_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"settings~ipad":@"settings_vpf")

#define play_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"preview~ipad":@"preview_vpf")

#define swap_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"video-settings~ipad":@"video-settings_vpf")

#define share_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share~ipad":@"share_vpf")

#define frame_frame_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"frame~ipad":@"frames_vpf")

#define rateus_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"like~ipad":@"like_vpf")

#define share_facebook_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"facebook~ipad":@"facebook_vpf")

#define share_email_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"email~ipad":@"email_vpf")

#define share_message_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"message~ipad":@"message_vpf")

#define more_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"upgrade~ipad":@"upgrade_vpf")


#define frame_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"frame_active~ipad":@"frames_vpf_active")

#define select_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"color_active~ipad":@"color_vpf_active")

#define effects_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"effects_active_button_ipad":@"effects_active_button")

#define setting_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"settings_active~ipad":@"settings_vpf_active")

#define play_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"preview_active~ipad":@"preview_vpf_active")

#define swap_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"video-settings_active~ipad":@"video-settings_vpf_active")

#define share_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"share_active~ipad":@"share_vpf_active")

#define frame_frame_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"frame_active~ipad":@"frames_vpf_active")

#define rateus_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"like_active~ipad":@"like_vpf_active")

#define share_facebook_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"facebook_active~ipad":@"facebook_vpf")
#define share_email_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"email_active~ipad":@"email_vpf_active")
#define share_message_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"message_active~ipad":@"message_vpf_active")

#define more_active_imageName ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"upgrade_active~ipad":@"upgrade_vpf_active")


#define topBarHeight    ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?44.0:44.0)
/* Feature macros */
#define FEATURE_ENABLE  1
#define FEATURE_DISABLE 0
#define IMAGE_SELECTION_LEGACY    1
#define IMAGE_SELECTION_CMPOPVIEW 1
#define CMTIPPOPVIEW_ENABLE 0

#define FULLSCREENADS_ENABLE 1
#define SESSIONSUPPORT_ENABLE 0
#define FIX_FACEBOOK_NEGATIVEFEEDBACK 1

#define ADS_ENABLE        0

/* feature enabling macros */
#define IMAGE_SELECTION IMAGE_SELECTION_LEGACY
#define IMAGE_OPTIMIZATION FEATURE_ENABLE

#define RADIUS_SETTINGS_X     0.0
#define RADIUS_SETTINGS_Y     0.0
#define RADIUS_SETTINGS_WIDTH  (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?600.0:320.0)
//#define RADIUS_SETTINGS_WIDTH  (380.0)
#define RADIUS_SETTINGS_HEIGHT (130.0)
//#define RADIUS_SETTINGS_SLIDER_WIDTH (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?420.0:140.0)
#define RADIUS_SETTINGS_SLIDER_WIDTH (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?500.0:180.0)
#define RADIUS_SETTINGS_MAXIMUM 60


/* Size limit per device */
#define IPHONE_FRAME_SIZE 300.0
#define IPAD_FRAME_SIZE   700.0
#define DEV_MULTIPLIER (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?(IPAD_FRAME_SIZE/IPHONE_FRAME_SIZE):1.0)
//#define DEV_MULTIPLIER (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?1.0:1.0)
#define IPAD_POPOVER_WIDTH  400.0
#define IPAD_POPOVER_HEIGHT 700.0

/* Application theame related settings */
#define PHOTO_DEFAULT_COLOR_R (0.08f)
#define PHOTO_DEFAULT_COLOR_G (0.08f)
#define PHOTO_DEFAULT_COLOR_B (0.08f)
#define PHOTO_DEFAULT_COLOR_A (1.0f)

#define PHOTO_DEFAULT_COLOR ([UIColor colorWithRed:PHOTO_DEFAULT_COLOR_R green:PHOTO_DEFAULT_COLOR_G blue:PHOTO_DEFAULT_COLOR_B alpha:PHOTO_DEFAULT_COLOR_A])

// Dark gray background for all screens
#define DARK_GRAY_BG [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1]

#define popup_color ([UIColor colorWithRed:28/255.5 green:31/255.0 blue:38/255.0 alpha:1.0])
//102,154,174
//#define EDITOR_DEFAULT_COLOR ([UIColor colorWithRed:(28.0f/255.0f) green:(31.0f/255.0f) blue:(38.0f/255.0f) alpha:PHOTO_DEFAULT_COLOR_A])
//102,154,174

#if defined(VideoCollage)
#define FRAME_COUNT 52//change again
#define STARTINGFRAME_COUNT 7

#else
#define FRAME_COUNT 53
#define STARTINGFRAME_COUNT 7
#endif
#define UNEVEN_FRAME_COUNT 48
#define STARTINGUNEVEN_FRAME_COUNT 7//change again
#define UNEVEN_FRAME_INDEX 1001

/* notifications */
#define selectImageForPhoto     @"selectImageForPhoto"
#define selectImageForSession   @"selectImageForSession"
#define editImageForPhoto       @"editImageForPhoto"
#define selectImageForApplyingEffect @"selectImageForEffect"
#define editImageForSession     @"editImageForSession"
#define swapmodeentered         @"swapmodeentered"
#define swapFromSelected        @"selectedSwapFrom"
#define swapToSelected          @"selectedSwapTo"
#define swapCancelled           @"cancelledSwap"
#define scaleAndOffsetChanged   @"scaleAndOffsetChanged"
#define createNewSession        @"createNewSession"
#define loadSession             @"loadSession"
#define photoDimensionsChanged  @"photoDimensionsChanged"
#define backgroundImageSelected @"backgroundImageSelected"
#define backgroundVideoSelected @"backgroundVideoSelected"
#define show_RateUsPanel @"showRateUsPanel"
#define newframeselected        @"newframeselected"
#define aspectratiochanged      @"aspectratiochanged"
#define optionselected      @"optionselected"
#define filterchanged      @"filterchanged"
#define applyfilter     @"applyfilter"
#define uploaddone              @"uploaddonenotification"
#define notification_updateFrameImages            @"notification_updateFrameImages"
#define addWaterMark @"addWaterMark"

/* Application information */
#define kInAppPurchaseProUpgradeProductId @"com.outtinking.vidframe.removewatermark"
#define kInAppPurchaseShapesPack  @"com.dsrtech.piccells.extendedpack"
#define kInAppPurchaseAllEffects  @"com.dsrtech.piccells.extendedpack"
#define kInAppPurchaseBokehPack   @"com.dsrtech.piccells.extendedpack"
#define kInAppPurchaseCartoonPack @"com.dsrtech.piccells.extendedpack"
#define kInAppPurchaseGrungePack  @"com.dsrtech.piccells.extendedpack"
#define kInAppPurchaseSketchPack  @"com.dsrtech.piccells.extendedpack"
#define kInAppPurchaseSpacePack   @"com.dsrtech.piccells.extendedpack"
#define kInAppPurchaseTexturePack @"com.dsrtech.piccells.extendedpack"
#define kInAppPurchaseVintaePack  @"com.dsrtech.piccells.extendedpack"

#define kInAppPurchaseRemoveWaterMarkPack  @"com.outtinking.vidframe.removewatermark"
#define kInAppPurchaseSubScriptionPack  @"com.outtinking.vidframe.allfeatures"
#define kInAppPurchaseSubScriptionPackYearly @"com.outthinking.vidframe.yearly"
#define kInAppPurchaseSubScriptionPackWeekly @"com.outthinking.vidframe.weekly"
//com.outthinking.videocollagepro.effects2
//com.outthinking.picblur.allfeatures
#define key_boughtAnyProduct @"key_boughtAnyProduct"

#define kInAppPurchasePacks ([NSArray arrayWithObjects:kInAppPurchaseSubScriptionPack,kInAppPurchaseSubScriptionPackYearly,kInAppPurchaseSubScriptionPackWeekly, nil])

#define bought_staticfilters ([[NSUserDefaults standardUserDefaults]boolForKey:kInAppPurchaseAllEffects])
#define bought_allpackages   ([[NSUserDefaults standardUserDefaults]boolForKey:kInAppPurchaseProUpgradeProductId])
#define bought_watermarkpack ([[NSUserDefaults standardUserDefaults]boolForKey:kInAppPurchaseRemoveWaterMarkPack])
#define bought_allfeaturespack ([[NSUserDefaults standardUserDefaults]boolForKey:kInAppPurchaseSubScriptionPack])
#define bought_allfeaturespackYearly ([[NSUserDefaults standardUserDefaults]boolForKey:kInAppPurchaseSubScriptionPackYearly])
#define bought_allfeaturespackWeekly ([[NSUserDefaults standardUserDefaults]boolForKey:kInAppPurchaseSubScriptionPackWeekly])

#define userDefaultForLimitSave [NSUserDefaults standardUserDefaults]


#define flurrykey   @"2283GYBGQX9NYDBCVK5J"
#define tapjoyAppId @"9e1f8880-1d30-468e-ae6c-6c1c8c5cd91e"
#define tapjoySec   @"jI91fR0KoGjux2xMQRLa"
#if defined(VideoCollagePRO)

//#define iosAppId         722633887
//#define iosAppIdString @"722633887"
//#define iosProAppIdString  @"722633887"

#define iosAppId         712175767
#define iosAppIdString @"712175767"
#define iosProAppIdString  @"712175767"
#else

#define iosAppId         712175767
#define iosAppIdString @"712175767"
//#define iosProAppIdString  @"722633887"
#define iosProAppIdString  @"712175767"

#endif
#define admobpublishedid_iphone @"ca-app-pub-8572140050384873/8625652341"
#define admobmediationid_iphone @"ca-app-pub-8572140050384873/8625652341"
#define admobmediationid_ipad @"ca-app-pub-8572140050384873/8625652341"
#define admobpublishedid_ipad @"ca-app-pub-8572140050384873/8625652341"
//#define fullscreen_admob_id   @"5ca06978c5a04f6a"
#define fullscreen_admob_id  @"ca-app-pub-8572140050384873/1755440420"



#define fullscreen_test_admob_id @"ca-app-pub-3940256099942544/4411468910"

#define fullscreen_admob_Launch @"ca-app-pub-8572140050384873/4407210680"
#define fullscreen_admob_Homepage @"ca-ca-app-pub-8572140050384873/9142067580"
#define fullscreen_admob_HomeButtonClick @"ca-app-pub-8572140050384873/1755440420"
#define fullscreen_admob_sharePage @"ca-app-pub-8572140050384873/8923484000"


#define native_home_admob_id @"ca-app-pub-8572140050384873/2715151497"

// ca-app-pub-8572140050384873/2715151497 //Original ID
// ca-app-pub-8572140050384873/8836302096 // other ID

#define Interestial_Launch_defaults [NSUserDefaults standardUserDefaults]
//#define Interestial_Home_defaults [NSUserDefaults standardUserDefaults]
#define Interestial_Share_defaults [NSUserDefaults standardUserDefaults]
#define Interestial_Button_defaults [NSUserDefaults standardUserDefaults]
#define Saving_Number_defaults [NSUserDefaults standardUserDefaults]
#define Sharing_Number_defaults [NSUserDefaults standardUserDefaults]
#define RateUs_Number_defaults [NSUserDefaults standardUserDefaults]

#define admobunitid_iphone @"c4c18ab3c700453e"
#define admobunitid_ipad @"027203f42678455b"

//#define appname  NSLocalizedString(@"appname", @"Pic Shells")
#define yozio_sdkkey    @"c773c740-5049-0130-2f2e-12314000ac7c"
#define yozio_secret    @"33929373ed554b27682a5fbbc9667730"

/* Push messafes */
#define pushwizard_prd_sdkkey @"523d270ba3fc27866c0000db"
#define pushwizard_dev_sdkkey @"1f0b28c337bd292a861071286e7dff2b"

#define flurry_bannerad_name ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"InstapiciPadBannerAd":@"Top Banner Ads")

#define flurry_fullscreenad_name ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?@"PicCellsFullScreenIpad":@"PicCellsFullScreenIphone")

#define youtube_clienID   @"744994249119.apps.googleusercontent.com"
#define youtube_developerKey   @"AIzaSyAEf9zMTD7hNPrsuUXcXzGrWZLqb1tW9j8"
#define appname  @"VideoCollage"
#define linktoAdvXml @"http://photoandvideoapps.com/News/instacollage.xml"
#define applicationUrl @"<a href=\"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=710076092&mt=8\" target=\"itunes_store\">VideoCollage</a>"

#define apptinyurl            @"http://tinyurl.com/VideoCollage"
#define fb_stream_heading     @"VideoCollage (Video Frames + Collage) Iphone Application"
#define fb_stream_caption     @"I just uploaded new image to my photo album"
#define fb_stream_description @"Its great app, fun to use it and good effects"
//https://apps.apple.com/tw/app/line/id443904275
// http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8 - old Url link
//#define ituneslinktoApp       [NSString stringWithFormat:@"https://apps.apple.com/tw/app/line/id%@",iosAppIdString]

#define ituneslinktoApp       [NSString stringWithFormat:@"https://apps.apple.com/us/app/video-collage-collage-maker/id712175767"]

#define ituneslinktoProVersion       [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",iosProAppIdString]
#define websiteOfApp @"www.videocollageapp.com"
#if defined(VideoCollagePRO)

#define fbAppId                   @"166101283588955"

#define applicationlikebuttonurl @"<iframe src=\"http://www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww.facebook.com%2Fpages%2FOutthinking-Pvt-Ltd%2F564692443591238&amp;width=292&amp;height=80&amp;colorscheme=light&amp;layout=standard&amp;action=like&amp;show_faces=true&amp;send=false\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:292px; height:80px;\" allowTransparency=\"true\"></iframe>"

#define applicationlikebuttonurliphoneFull @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fpicshells&amp;width=320&amp;height=590&amp;colorscheme=dark&amp;show_faces=true&amp;border_color&amp;stream=true&amp;header=true&amp;appId=282818615134789\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:320px; height:590px;\" allowTransparency=\"true\"></iframe>"

#define applicationlikebuttonipadfull @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fpicshells&amp;width=768&amp;height=590&amp;colorscheme=dark&amp;show_faces=true&amp;border_color&amp;stream=true&amp;header=true&amp;appId=282818615134789\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:768px; height:590px;\" allowTransparency=\"true\"></iframe>"

#define applicationlikebuttonurlFull (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?applicationlikebuttonipadfull:applicationlikebuttonurliphoneFull)

#else
#define fbAppId                   @"960095180677895"

#define applicationlikebuttonurl @"<iframe src=\"http://www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww.facebook.com%2Fpages%2FOutthinking-Pvt-Ltd%2F564692443591238&amp;width=292&amp;height=80&amp;colorscheme=light&amp;layout=standard&amp;action=like&amp;show_faces=true&amp;send=false\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:292px; height:80px;\" allowTransparency=\"true\"></iframe>"

#define applicationlikebuttonurliphoneFull @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fpicshells&amp;width=320&amp;height=590&amp;colorscheme=dark&amp;show_faces=true&amp;border_color&amp;stream=true&amp;header=true&amp;appId=282818615134789\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:320px; height:590px;\" allowTransparency=\"true\"></iframe>"

#define applicationlikebuttonipadfull @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fpicshells&amp;width=768&amp;height=590&amp;colorscheme=dark&amp;show_faces=true&amp;border_color&amp;stream=true&amp;header=true&amp;appId=282818615134789\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:768px; height:590px;\" allowTransparency=\"true\"></iframe>"

#define applicationlikebuttonurlFull (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?applicationlikebuttonipadfull:applicationlikebuttonurliphoneFull)
#endif
/* Tags */
#define RADIUS_TAG_INDEX 100
#define TAG_WEBVIEW      110
#define TAG_CLOSEBUTTON  111

#define TAG_COLORPICKER_TIPVIEW 120
#define TAG_COLORPICKER         121
#define TAG_PATTERNPICKER       122
#define TAG_COLORPICKER_BG      123
#define TAG_ADJUST_BG           124
#define TAG_ADJUST_BGPAD        125
#define TAG_ADJUST_TOUCHSHEILD  126
#define TAG_PREVIEW_BGPAD        127
#define TAG_VIDEOSETTINGS_BGPAD        128
#define TAG_VIDEOGRIDVIEW       129
#define TAG_SLIDERS_TIPVIEW     130

#define TAG_BASEFRAME_GRIDVIEW      140
#define TAG_EVENFRAME_GRIDVIEW      140
#define TAG_UNEVENFRAME_GRIDVIEW    141

#define TAG_CLEARANIMATION      150

#define TAG_ASPECTRATIO_BG      160
#define TAG_ASPECTRATIO_TIPVIEW 161
#define TAG_ASPECTRATIO_BUTTON  162

#define TAG_SHADOW_VIEW         170

#define TAG_FRAMEGRID_CONTROLLER 180

/* Tags for toolbar tags for tab bar modes */
#define TAG_TOOLBAR_EDIT         200
#define TAG_TOOLBAR_FRAMES       201
#define TAG_TOOLBAR_SWAP         202
#define TAG_TOOLBAR_SHARE        203
#define TAG_TOOLBAR_FREEAPPS     204
#define TAG_TOOLBAR_ADJUST       205
#define TAG_TOOLBAR_PREVIEW      206
#define TAG_TOOLBAR_SETTINGS     207
#define TAG_TOOLBAR_EFFECT       208

/* tags for views */
#define TAG_FREEAPPS_VIEW        300

/* tags for gridview */
#define TAG_GRIDVIEW_COLOR       400
#define TAG_GRIDVIEW_PATTERN     401

#define TAG_BANNERAD_VIEW        500
#define TAG_PREVIEW_STOP         501
#define TAG_PREVIEW_PLAY         502
#define TAG_PREVIEW_PAUSE        503
#define TAG_PREVIEW_RESUME       504
#define TAG_PREVIEW_BLOCKTOUCHES 505
#define TAG_AUDIO_CELL_TITLE     506
#define TAG_AUDIO_CELL_IMAGE     507
#define TAG_AUDIO_CELL_SWITCH    508
#define TAG_AUDIO_CELL_SELECT_AUDIO_RECT    5091
#define TAG_AUDIO_CELL_SELECT_AUDIO    509
#define TAG_WATERMARKPARENT_View     10000
#define TAG_WATERMARK_LABEL      510
#define TAG_WATERMARK_BUTTON     511

#define TAG_SEQUENTIAL_BUTTON    512
#define TAG_SQUENTIAL_CELL_SWITCH    513
#define TAG_STICKERVIEW 555

#define KEY_AUDIOID_SELECTED_FROM_LIBRARY   @"KEY_AUDIOID_SELECTED_FROM_LIBRARY"
#define KEY_USE_AUDIO_SELECTED_FROM_LIBRARY @"KEY_USE_AUDIO_SELECTED_FROM_LIBRARY"
#define KEY_AUDIO_SELECTED_FROM_FILES @"KEY_AUDIO_SELECTED_FROM_FILES"
#define KEY_USE_SEQUENTIAL_Play_STATUS @"KEY_USE_SEQUENTIAL_Play_STATUS"
#define KEY_AUDIOURL_SELECTED_FROM_FILES @"KEY_AUDIOURL_SELECTED_FROM_FILES"
/* Settings positions and tags*/
#define DEFAULT_FRAME_WIDTH 7
#define DEFAULT_ADJUSTOR_OVERLAP 2
#define DEFAULT_ADJUSTOR_WIDTH (DEFAULT_FRAME_WIDTH + (DEFAULT_ADJUSTOR_OVERLAP * 2))

//#define FILENAME_PATTERN_PREFIX @"pattern"
//#define FILENAME_PATTERN_FORMAT @"%@_%d"
#define FILENAME_PATTERN_PREFIX @"patt"
#define FILENAME_PATTERN_FORMAT @"%@%d"

#define FILENAME_FRAME_REGULAR_PREFIX @"frame_t"
#define FILENAME_FRAME_IRREGULAR_PREFIX @"unevenframe_t"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBSub(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 252))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 217))/255.0 \
blue:((float)((rgbValue & 0xFF)>>21 ))/255.0 alpha:1.0]

#define DEFAULT_FRAMES_PACK_PRICE    @"$1.99"
#define DEFAULT_WATERMARK_PACK_PRICE @"$5.99"
#define DEFAULT_YEARLY_PACK_PRICE @"$29.99"
#define DEFAULT_Weekly_PACK_PRICE @"$2.99"
#define DEFAULT_Trail_Period 3
#define DEFAULT_FRAMES_PACK_TITLE    @"Frames Pack"
#define DEFAULT_WATERMARK_PACK_TITLE @"Remove Watermark"
#define DEFAULT_FRAMES_PACK_DESCRIPTION    @"Purchasing this pack will get you access to all the frames and also all future frames upgrades for FREE,Also ads will be removed forever"
#define DEFAULT_WATERMARK_PACK_DESCRIPTION @"Purchasing this pack will let you create watermark free videos and images, also ads will be removed forever"

#define kStringArray [NSArray arrayWithObjects:@"Select Photo", @"Select Video",@"Remove", nil]

#endif

