//
//  MainController.h
//  VideoFrames
//
//  Created by PAVANIOS on 08/01/21.
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
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#if defined(APP_INSTAPICFRAMES)
#import "FrameGridView.h"
#import "InitSessionManager.h"
#import "MenuManager.h"
#endif


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
//#import "PopupMenu.h"
//#import <PopUpMenu/PopupMenu.h>
#import "ImageSelectionHandler.h"
#import "Config.h"
#import "ShapeMapping.h"
#if SHAPE_CHAGING_SUPPORT
#import "sgwController.h"
#endif
#import "FrameSelectionController.h"
#import "FrameScrollView.h"
//#import <FBAudienceNetwork/FBAudienceNetwork.h>

//#import "CEMovieMaker.h"
//#import "ImageToVideoViewController.h"

#import "SRSubscriptionModel.h"
//--New Classes--//
//#import "SubscriptionPage.h"
//#import "UniversalLayout.h"
#import "SimpleSubscriptionView.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <StoreKit/StoreKit.h>
#import "DXPopover.h"
#import "LoadingClass.h"
#import "VideoFrames-Bridging-Header.h"
#import "Effects.h"

@import GoogleMobileAds;
@import Firebase;




@interface MainController : UIViewController

<UITabBarDelegate,UINavigationControllerDelegate,RSColorPickerViewDelegate,GridViewDelegate,MFMailComposeViewControllerDelegate,FrameGridViewDelegate,UIImagePickerControllerDelegate,SNPopupViewModalDelegate,UIDocumentInteractionControllerDelegate,PopupMenuDelegate,GADFullScreenContentDelegate,SKRequestDelegate>
//GADInterstitialDelegate
{
    UIView *bgview2;
    Settings *nvm;
    //ImageToVideoViewController*musicClass;
    
    UIDocumentInteractionController *documentInteractionController;
    
    BOOL bShowRevModAd;
    
//    UIView *toolbar;
    
}
@property(nonatomic, strong) GADInterstitialAd *interstitial;
//@property(nonatomic,retain)IBOutlet UITabBar *tabBar;
@property(nonatomic,strong)UIImage *imageForEdit;
@property(nonatomic,readwrite)BOOL applicationSuspended;
@property(nonatomic,strong)NSString *VideoPathExl;
@property(nonatomic)BOOL removeWaterMark;
@property (nonatomic,assign) int interestial_HomeButtonClickCount;
@property (nonatomic,assign) int interestial_ShareCount;



//-(void)uploadSelected;
-(void)updateNewsBadgeTo:(NSString*)badge flashState:(BOOL)flash;


//-(void)showBannerAd;
//-(void)hideBannerAd;
-(void)allocateResourcesForFrames;
-(void)ShareAction;
-(void)ChangeAspectRatio:(NSString *)aspectStr;
- (BOOL)isiPod;
@end


