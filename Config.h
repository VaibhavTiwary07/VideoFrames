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
#define proVersion 0
#define help_close_Button ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"exit-button_ipad.png":@"exit-button.png")

#define colorBackgroundBarHeightHeight ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?100.0:60.0)
#define colorBurttonHeight ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?80.0:50.0)
#define bottombarImage ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"bottom bar_ipad.png":@"bottom bar.png")
#define backgroundBarImage ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"backgroundStrip_ipad.png":@"backgroundStrip.png")
#define colorPatternBarImage ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"color-gallery-strip_ipad.png":@"color-gallery-strip.png")
#define colorButtonImage ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"color_button_ipad.png":@"color_button.png")

#define patternButtonImage ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"pattern_button_ipad.png":@"pattern_button.png")

#define colorButtonImage_active ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"color_active_ipad.png":@"color-active_button.png")

#define patternButtonImage_active ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"pattern_button_active_ipad.png":@"pattern_active_button.png")

#define customBarHeight ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?70.0:50.0)

#define ad_x ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?75.0:25.0)
#define ad_y ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?35.0:10.0)
#define ad_size ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?50.0:25.0)
#define install_size_width ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?150.0:75.0)
#define pro_x ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?150.0:90.0)

#define hepl_button_x ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?30.0:0.0)
#define appoxee_button_x ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?70.0:42.50)

#define frame_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"frame~ipad":@"frames_vpf")

#define select_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"color~ipad":@"color_vpf")

#define setting_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"settings~ipad":@"settings_vpf")

#define play_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"preview~ipad":@"preview_vpf")

#define swap_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"video-settings~ipad":@"video-settings_vpf")

#define share_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"share~ipad":@"share_vpf")

#define frame_frame_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"frame~ipad":@"frames_vpf")

#define rateus_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"like~ipad":@"like_vpf")

#define share_facebook_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"facebook~ipad":@"facebook_vpf")
#define share_email_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"email~ipad":@"email_vpf")
#define share_message_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"message~ipad":@"message_vpf")

#define more_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"upgrade~ipad":@"upgrade_vpf")




#define frame_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"frame_active~ipad":@"frames_vpf_active")

#define select_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"color_active~ipad":@"color_vpf_active")

#define setting_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"settings_active~ipad":@"settings_vpf_active")

#define play_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"preview_active~ipad":@"preview_vpf_active")

#define swap_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"video-settings_active~ipad":@"video-settings_vpf_active")

#define share_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"share_active~ipad":@"share_vpf_active")

#define frame_frame_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"frame_active~ipad":@"frames_vpf_active")

#define rateus_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"like_active~ipad":@"like_vpf_active")

#define share_facebook_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"facebook_active~ipad":@"facebook_vpf")
#define share_email_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"email_active~ipad":@"email_vpf_active")
#define share_message_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"message_active~ipad":@"message_vpf_active")

#define more_active_imageName ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"upgrade_active~ipad":@"upgrade_vpf_active")


#define topBarHeight    ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?60.0:50.0)
/* Feature macros */
#define FEATURE_ENABLE  1
#define FEATURE_DISABLE 0
#define IMAGE_SELECTION_LEGACY    1
#define IMAGE_SELECTION_CMPOPVIEW 1
#define CMTIPPOPVIEW_ENABLE 0
#define BANNERADS_ENABLE 1
#define FULLSCREENADS_ENABLE 1
#define SESSIONSUPPORT_ENABLE 0
#define FIX_FACEBOOK_NEGATIVEFEEDBACK 1

#define ADS_ENABLE        0

/* feature enabling macros */
#define IMAGE_SELECTION IMAGE_SELECTION_LEGACY
#define IMAGE_OPTIMIZATION FEATURE_ENABLE

#define RADIUS_SETTINGS_X     0.0
#define RADIUS_SETTINGS_Y     0.0
//#define RADIUS_SETTINGS_WIDTH  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?600.0:280.0)
#define RADIUS_SETTINGS_WIDTH  (280.0)
#define RADIUS_SETTINGS_HEIGHT (130.0)
//#define RADIUS_SETTINGS_SLIDER_WIDTH ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?420.0:140.0)
#define RADIUS_SETTINGS_SLIDER_WIDTH ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?500.0:180.0)
#define RADIUS_SETTINGS_MAXIMUM 60.0


/* Size limit per device */
#define IPHONE_FRAME_SIZE 300.0
#define IPAD_FRAME_SIZE   700.0
#define DEV_MULTIPLIER ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?(IPAD_FRAME_SIZE/IPHONE_FRAME_SIZE):1.0)
//#define DEV_MULTIPLIER ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?1.0:1.0)
#define IPAD_POPOVER_WIDTH  400.0
#define IPAD_POPOVER_HEIGHT 700.0

/* Application theame related settings */
#define PHOTO_DEFAULT_COLOR_R (0.0f/256.0f) //28.0     //28 1c
#define PHOTO_DEFAULT_COLOR_G (113.0f/256.0f)  //184   //184 b8
#define PHOTO_DEFAULT_COLOR_B (148.0f/256.0f)  //233   //233 e9
#define PHOTO_DEFAULT_COLOR_A (1.0f)

#define PHOTO_DEFAULT_COLOR ([UIColor colorWithRed:PHOTO_DEFAULT_COLOR_R green:PHOTO_DEFAULT_COLOR_G blue:PHOTO_DEFAULT_COLOR_B alpha:PHOTO_DEFAULT_COLOR_A])

#define popup_color ([UIColor colorWithRed:0.05 green:0.14 blue:0.15 alpha:1.0])

#define EDITOR_DEFAULT_COLOR ([UIColor colorWithRed:(44.0f/256.0f) green:(44.0f/256.0f) blue:(44.0f/256.0f) alpha:PHOTO_DEFAULT_COLOR_A])

#define FRAME_COUNT 53
#define UNEVEN_FRAME_COUNT 48
#define UNEVEN_FRAME_INDEX 1001

/* notifications */
#define selectImageForPhoto     @"selectImageForPhoto"
#define selectImageForSession   @"selectImageForSession"
#define editImageForPhoto       @"editImageForPhoto"
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
#define openIpadPhotoAlbum      @"openIpadPhotoAlbum"
#define openIpadVideoAlbum      @"openIpadVideoAlbum"
#define newframeselected        @"newframeselected"
#define aspectratiochanged      @"aspectratiochanged"
#define uploaddone              @"uploaddonenotification"
#define notification_updateFrameImages            @"notification_updateFrameImages"

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
#define key_boughtAnyProduct @"key_boughtAnyProduct"

#define kInAppPurchasePacks ([NSArray arrayWithObjects:kInAppPurchaseRemoveWaterMarkPack, nil])

#define bought_staticfilters ([[NSUserDefaults standardUserDefaults]boolForKey:kInAppPurchaseAllEffects])
#define bought_allpackages   ([[NSUserDefaults standardUserDefaults]boolForKey:kInAppPurchaseProUpgradeProductId])
#define bought_watermarkpack ([[NSUserDefaults standardUserDefaults]boolForKey:kInAppPurchaseRemoveWaterMarkPack])

#define flurrykey   @"2283GYBGQX9NYDBCVK5J"
#define tapjoyAppId @"9e1f8880-1d30-468e-ae6c-6c1c8c5cd91e"
#define tapjoySec   @"jI91fR0KoGjux2xMQRLa"
#define iosAppId         712175767
#define iosAppIdString @"712175767"
//#define iosProAppIdString  @"722633887"
#define iosProAppIdString  @"722633887"
#define admobpublishedid_iphone @"4965f34510b246a4"
#define admobmediationid_iphone @"fa41477ba08c4abe"
#define admobmediationid_ipad @"baa65b9955184e72"
#define admobpublishedid_ipad @"51266bd4923d43d1"
#define fullscreen_admob_id   @"5ca06978c5a04f6a"

#define admobunitid_iphone @"c4c18ab3c700453e"
#define admobunitid_ipad @"027203f42678455b"
//#define appname  NSLocalizedString(@"appname", @"Pic Shells")
#define yozio_sdkkey    @"c773c740-5049-0130-2f2e-12314000ac7c"
#define yozio_secret    @"33929373ed554b27682a5fbbc9667730"

/* Push messafes */
#define pushwizard_prd_sdkkey @"523d270ba3fc27866c0000db"
#define pushwizard_dev_sdkkey @"1f0b28c337bd292a861071286e7dff2b"

#define flurry_bannerad_name ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"InstapiciPadBannerAd":@"Top Banner Ads")

#define flurry_fullscreenad_name ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"PicCellsFullScreenIpad":@"PicCellsFullScreenIphone")

#define youtube_clienID   @"744994249119.apps.googleusercontent.com"
#define youtube_developerKey   @"AIzaSyAEf9zMTD7hNPrsuUXcXzGrWZLqb1tW9j8"
#define appname  @"VideoCollage"
#define linktoAdvXml @"http://photoandvideoapps.com/News/instacollage.xml"
#define applicationUrl @"<a href=\"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=710076092&mt=8\" target=\"itunes_store\">VideoCollage</a>"

#define apptinyurl            @"http://tinyurl.com/VideoCollage"
#define fb_stream_heading     @"VideoCollage (Video Frames + Collage) Iphone Application"
#define fb_stream_caption     @"I just uploaded new image to my photo album"
#define fb_stream_description @"Its great app, fun to use it and good effects"
#define ituneslinktoApp       [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",iosAppIdString]
#define ituneslinktoProVersion       [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",iosProAppIdString]
#define websiteOfApp @"www.videocollageapp.com"
#define fbAppId                   @"532541016816841"

#define applicationlikebuttonurl @"<iframe src=\"http://www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww.facebook.com%2Fpages%2FOutthinking-Pvt-Ltd%2F564692443591238&amp;width=292&amp;height=80&amp;colorscheme=light&amp;layout=standard&amp;action=like&amp;show_faces=true&amp;send=false\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:292px; height:80px;\" allowTransparency=\"true\"></iframe>"

#define applicationlikebuttonurliphoneFull @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fpicshells&amp;width=320&amp;height=590&amp;colorscheme=dark&amp;show_faces=true&amp;border_color&amp;stream=true&amp;header=true&amp;appId=282818615134789\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:320px; height:590px;\" allowTransparency=\"true\"></iframe>"

#define applicationlikebuttonipadfull @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fpicshells&amp;width=768&amp;height=590&amp;colorscheme=dark&amp;show_faces=true&amp;border_color&amp;stream=true&amp;header=true&amp;appId=282818615134789\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:768px; height:590px;\" allowTransparency=\"true\"></iframe>"

#define applicationlikebuttonurlFull ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?applicationlikebuttonipadfull:applicationlikebuttonurliphoneFull)

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
#define TAG_AUDIO_CELL_SELECT_AUDIO    509
#define TAG_WATERMARK_LABEL      510
#define TAG_WATERMARK_BUTTON     511

#define TAG_SEQUENTIAL_BUTTON    512
#define TAG_SQUENTIAL_CELL_SWITCH    513

#define KEY_AUDIOID_SELECTED_FROM_LIBRARY   @"KEY_AUDIOID_SELECTED_FROM_LIBRARY"
#define KEY_USE_AUDIO_SELECTED_FROM_LIBRARY @"KEY_USE_AUDIO_SELECTED_FROM_LIBRARY"
#define KEY_USE_SEQUENTIAL_Play_STATUS @"KEY_USE_SEQUENTIAL_Play_STATUS"

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

#define DEFAULT_FRAMES_PACK_PRICE    @"$1.99"
#define DEFAULT_WATERMARK_PACK_PRICE @"$0.99"
#define DEFAULT_FRAMES_PACK_TITLE    @"Frames Pack"
#define DEFAULT_WATERMARK_PACK_TITLE @"Remove Watermark"
#define DEFAULT_FRAMES_PACK_DESCRIPTION    @"Purchasing this pack will get you access to all the frames and also all future frames upgrades for FREE,Also ads will be removed forever"
#define DEFAULT_WATERMARK_PACK_DESCRIPTION @"Purchasing this pack will let you create watermark free videos and images, also ads will be removed forever"

#endif
