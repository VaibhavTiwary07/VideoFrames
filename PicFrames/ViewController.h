//
//  ViewController.h
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Frame.h"
#import "Photo.h"
#import "RSColorPickerView.h"
#import "RSBrightnessSlider.h"
#import "GridView.h"
#import "UploadManager.h"
#import "Settings.h"
#import "UploadHandler.h"
#if defined(APP_INSTAPICFRAMES)
#import "FrameGridView.h"
#import "InitSessionManager.h"
#import "MenuManager.h"
#import "UpgradesView.h"
#endif

#import "SNPopupView.h"
#import "HelpGridView.h"
#import "HelpFrame.h"

#if ADS_ENABLE
#import "OT_Config.h"
#import "OT_AdContorl.h"
#import "OT_OfferWallView.h"
#import "FlurryAds.h"
#import "FlurryAdDelegate.h"
#import "OT_FlurryAd.h"
#endif

#import "CustomUI.h"
#import "PopoverView.h"
#import "PopupMenu.h"
#import "ImageSelectionHandler.h"

#import "ShapeMapping.h"
#if SHAPE_CHAGING_SUPPORT
#import "sgwController.h"
#endif
#import "FrameSelectionController.h"
#import "FrameScrollView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

@interface ViewController : UIViewController <UITabBarDelegate,UINavigationControllerDelegate,RSColorPickerViewDelegate,GridViewDelegate,MFMailComposeViewControllerDelegate,FrameGridViewDelegate,UIImagePickerControllerDelegate,SNPopupViewModalDelegate,UIDocumentInteractionControllerDelegate,PopupMenuDelegate,GADBannerViewDelegate,GADInterstitialDelegate>
{
    Settings *nvm;

    UIDocumentInteractionController *documentInteractionController;
    BOOL bShowRevModAd;
}

@property(nonatomic,retain)IBOutlet UITabBar *tabBar;
@property(nonatomic,retain)UIImage *imageForEdit;
@property(nonatomic,readwrite)BOOL applicationSuspended;

-(void)uploadSelected;
-(void)updateNewsBadgeTo:(NSString*)badge flashState:(BOOL)flash;
#if ADS_ENABLE
-(void)showBannerAd;
-(void)hideBannerAd;
#endif
@end
