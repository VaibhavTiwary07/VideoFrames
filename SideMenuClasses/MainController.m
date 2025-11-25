//
//  MainController.m
//  VideoFrames
//
//  Created by PAVANIOS on 08/01/21.
//
#import <stdlib.h>
#import "MainController.h"
#import "Config.h"
@import FirebaseAnalytics;
#import "kxmenu.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/CALayer.h>
#import "OT_TabBar.h"
#import "VideoUploadHandler.h"
//#import "configparser.h"
//#import "VideoSettings.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CMPopTipView.h"
//#import "VideoSettingsController.h"
//#import "HelpScreenViewController.h"
#import "VideoGridViewViewController.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Effects.h"
#import "ShareViewController.h"
//#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import "WCAlertView.h"
#import "MBProgressHUD.h"
#import "DXPopover.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import "VideoCollage-Swift.h"
#import "GridView.h"
#import "GPUImage.h"
#import "StaticFilterMapping.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WhatsAppShareManager.h"
#import "CircularProgressView.h"
//@import GoogleMobileAds;

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


//static CGFloat randomFloatBetweenLowAndHigh(CGFloat low, CGFloat high) {
//    CGFloat diff = high - low;
//    return (((CGFloat)rand() / RAND_MAX) * diff) + low;
//}

// Define MIN and MAX font sizes (adjust as needed)
static const CGFloat kMinFontSize = 12.0;  // Minimum allowed font size
static const CGFloat kMaxFontSize = 36.0;  // Maximum allowed font size


typedef struct {
    NSURL *url;
    CGRect frame;
} VideoInput;

@interface MainController ()<KxMenuDelegate,OT_TabBarDelegate,UIPopoverControllerDelegate,PopoverViewDelegate,AVAudioPlayerDelegate,MPMediaPickerControllerDelegate,UITableViewDataSource, UITableViewDelegate,UISheetPresentationControllerDelegate,UITextViewDelegate,UIColorPickerViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAdaptivePresentationControllerDelegate,UIDocumentPickerDelegate,  UIPrintInteractionControllerDelegate,MFMessageComposeViewControllerDelegate> //CTAssetsPickerControllerDelegate,UIDocumentPickerDelegate,UIPopoverPresentationControllerDelegate,MFMailComposeViewControllerDelegate

//InAppPurchasePreviewViewDelegate
{
    eAppMode eMode;
    UIView  *pickerView;
    
    /* Needs to delete */
    Frame *frm;
    Session *sess;
    ImageSelectionHandler *ish;
    /* Aspect Ratios and sizes
     1:1 -> 300:300F
     3:2 -> 300:200
     4:3 -> 300:225
     3:4 -> 225:300
     */
    
    SNPopupView *aspectRatioView;
    SNPopupView *sliders;
    SNPopupView *colorAndPatternView;
    CGFloat bottomAnchorConstant;
    BOOL _editWhileImageSelection;
    //UIImage *_selectedImageBeforeEdit;dsl;vjsl;dighsl;idfh
    UIButton *_appoxeeBadge;
    BOOL removeWaterMark;
    // BOOL isInEditMode; // Removed - old popup system
    // BOOL muteOptionActive; // Removed - old popup system
    UIView *curPopupViewParent;
    //   OT_TabBar *customTabBar,*customTabbarback;
    PopoverView *popOver;
    //GADBannerView *bannerView_;
    /* Video Preview Global Vars */
    BOOL gIsPreviewInProgress; //asdasdfsdfsdf
    BOOL gIsPreviewPaused;
    int  gCurPreviewFrameIndex; //sdfbljsdfbksjdbg
    int  gTotalPreviewFrames;
    int  gPreviewFrameCounterVariable;
    AVAudioPlayer *previewAudioPlayer;
    CMPopTipView *preViewControls;
    UISlider *previewAdjSlider;
    UILabel *previewTimeLabel;
    
    /* Add music */
    UIView *musicTrackCell;
    
    BOOL isSequentialPlay;
    
    //HelpScreenViewController  *helpScreen;
    NSMutableDictionary *dictionary, *dictionaryOfEffectInfo;
    VideoGridViewViewController *gridView;
    
    ShareViewController *shareView;
    //---New Implement----//
    // SubscriptionPage *SubscriptionView;
    // UniversalLayout *SubscriptionView2;
    SimpleSubscriptionView *SubscriptionView2;
    
    UIView *separatedview;
    UIView *imgview;
    UIBarButtonItem *backButton;
    
    bool  isEffectEnabled;
    UISlider *innerRadius;
    
    // FBInterstitialAd * interstitial;
    // GADInterstitial *interstitialAds;
    GADInterstitialAd *interstitialAds;

    BOOL PopUpShown;
    BOOL DontShow; // Still used in other parts

    NSString *firstsubscriptionPrice,*firstsubscriptionPriceYearly;
    long TrailPeriodDays;
    long TrailPeriodDaysYearly;
    NSUserDefaults *SuccessStatus;
    
    //ExpiryStatus//
    NSUserDefaults *prefsTime;
    NSUserDefaults *prefsDate;
    
    //Resumeview here //
    
    UIImageView * Resume_view;
    BOOL from_share;
    
    //Requesting//
    PHAuthorizationStatus phAuthorizationStatus;
    bool allowedAccessToPhoto;
    bool authorisedGallery;
    
    MPMediaLibraryAuthorizationStatus mpAuthorizationStatus;
    bool allowedAccessToMusic;
    NSInteger button_Index;
    PHAccessLevel accessLevel;


    // PopoverView *pv; // Removed - old popup system

    BOOL photosOptionPresent; // Still used in other parts
    // float popoverWidth; // Removed - old popup system
    // float popoverHeight; // Removed - old popup system
    int alertShownCount;
    UIImageView *lockImageView;
    UIButton *framButtonType1;
    UIButton *framButtonType2;
    
    GADAdValuePrecision precision;
    
    BOOL generatingVideo;
    
    BOOL effectSelected;
    int selectedFrameNumber;
    //  UIImageView *grabberImageView;
    
    
    UIColor *sessionFrameColor;
    // UIImage *borderImage;
    NSString *initString;
    UIColor *selectedOverlayColor;
    UIBarButtonItem *doneLockedRightBarButton;
    UIBarButtonItem *doneUnlockedRightBarButton;
    UIBarButtonItem *homeRightBarButton;
    int selectedEffectIndex;
    BOOL showSubscriptionCalledFromEffects;
    //    UIWindow *keyWindow;
    BOOL effectsApplied;
    BOOL effectBeingApplied;
    BOOL frameIsEdited;
    UIView *mainBackground;
    BOOL backgroundSubviewisAdded;
    BOOL sliderSubviewisAdded;
    BOOL effectSubviewAdded;
    BOOL textEditorSubviewAdded;
    NSLayoutConstraint *bottomConstraint;
    BOOL gotKeyBoardHeight;
    OptionsViewController * optionsView;
    UIView *backView;
    NSLayoutConstraint *waterMarkWidthConstraints;
    UIColorPickerViewController *colorPicker;
    UIWindow *keyWindow;
    BOOL dontShowOptionsUntilOldAssetsSaved; // Still used in other parts
    int currentClickedPhotoFrameNumber; // Still used in other parts
    float upscaleFactor;
    CGFloat durationOftheVideo;
    BOOL changeTitle;
    VideoUploadHandler * vHandler;
    UploadHandler *uploadH;
    CGFloat multiplier;
    CGFloat heightOfButtons;
    UIView *topButtonContainer;
    UIStackView *stackView;
    UIButton *removeWatermarkButton;
    UIButton *saveToLibraryButton;
  //  UIButton *dropdownButton;
    CircularProgressView *progressView;
    UIButton *previewPlayButton;
    UIImage *outputImage;
    CGFloat videoSaveprogress;
    BOOL doNotTouch;
    BOOL framesLoaded;
}

-(void)selectEditTab;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, strong) AspectRatioViewController *sheetVC;
@property (nonatomic, strong) BackgroundSelectionViewController *sheetBGVC;
@property (nonatomic, strong) EffectsViewController *sheetFilterVC;
@property (nonatomic, strong) SliderViewController *sliderVC;
@property (nonatomic, strong) StickerViewController *stickerVC;
@property (nonatomic, strong) VolumeViewController *volumeVC;
@property (nonatomic, strong) EditOptionsViewController *editOptionsVC;
//@property (nonatomic, assign)bool isVideoOrderChangedByUser;
@property(nonatomic   , assign) BOOL isVideoFile;
@property(nonatomic   , assign) BOOL imageToVideo;
//@property (nonatomic, strong) CEMovieMaker *movieMaker;//newly added

@property (nonatomic  , assign) BOOL isTouchWillDetect;
//@property (nonatomic  , assign) int videoTimeRange;
@property (nonatomic  , assign) int initialPhotoIndex;
@property (nonatomic , strong) NSMutableArray *videoImageInfo;
@property (nonatomic , strong) NSMutableArray *orderArrayForVideoItems;
@property (nonatomic  , assign) int counterVariable;
@property (nonatomic , assign) int currentSelectedPhotoNumberForEffect;

// Removed old popup properties: dxpopover, tableView, configs, timer

@property (nonatomic, strong) UISlider *fontSizeSlider;
@property (nonatomic, strong) UITextView *textBox;
@property (nonatomic, strong) NSMutableArray<UIView *> *textBoxes;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *trashBinView;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, strong) UIImageView *trackImgV;
@property (nonatomic, strong) UICollectionView *fontsCollectionView;
@property (nonatomic, strong) UICollectionView *ColorsCollectionView;
@property (nonatomic, strong) UICollectionView *alignmentCollectionView;
@property (nonatomic, strong) UIView *ellipsisOverlay;
@property (nonatomic, strong) UIToolbar *uitoolbar;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) BOOL isCollectionViewVisible;
@property (nonatomic, strong) UILabel *uititleLabel;
@property (nonatomic, strong) UILabel *titleLabelColor;
@property (nonatomic, strong) NSArray<NSString *> *fontNames;
@property (nonatomic, strong) NSArray<NSNumber *> *alignments;
@property (nonatomic, assign) NSTextAlignment selectedAlignment;
@property (nonatomic, assign) NSInteger alignmentIndex;
@property (nonatomic, assign) BOOL isCustomFrameEnabled;
@property (nonatomic, assign) BOOL showingFonts;
@property (nonatomic, weak) UITextView *lastActiveTextView;
@property (nonatomic, strong) NSMutableArray<UIView *> *addedstickes;
@property (nonatomic, assign) CGFloat customCenterY;
@property (nonatomic, strong) CIContext *sharedContext;
//@property (nonatomic, strong) NSMutableArray<NSURL *> *videoArray;
//@property (nonatomic, strong) NSMutableArray<NSValue *> *videoFrames;
//@property (nonatomic, strong) NSMutableArray<NSValue *> *shapeFrames;
//@property (nonatomic, strong) NSMutableArray<UIImage *> *shapeImages;
//@property (nonatomic, strong) NSArray<NSValue *> *layoutFrames; // NSValue-wrapped CGRects
@property (nonatomic) CGFloat totalProgress; // 0.0 to 1.0
@property (nonatomic) NSInteger totalMasks;
@property (strong, nonatomic) NSTimer *progressTimer;
@property (assign, nonatomic) float currentProgress;
@property(nonatomic , strong) NSURL *videoURL;
@property (assign, nonatomic) BOOL isDropdownExpanded;
@property (strong, nonatomic) NSArray *socialButtonsData;
@property (strong, nonatomic) NSArray<NSLayoutConstraint *> *topButtonConstraints;
@property (nonatomic, assign) BOOL isEffectProcessing;
@property (nonatomic, assign) BOOL appWentToBackground;
@property (nonatomic, assign) CGFloat currentScale; // Track the pinch scale

// Add these properties to your interface
@property (nonatomic, assign) CGAffineTransform currentTextViewTransform;
@property (nonatomic, assign) CGFloat currentTextViewScale;
@property (nonatomic, assign) CGFloat currentTextViewRotation;
// Add this property to your class
@property (nonatomic, assign) BOOL isResizingTextView;
@property (nonatomic, strong) NSDate *lastResizeTime;

// Enum for overlay shapes
typedef NS_ENUM(NSUInteger, OverlayShape) {
    OverlayNOShape,
    OverlayShapeRectangle,
    //OverlayShapeCircle,
    OverlayShapeOval,
    OverlayShapeRoundedRectangle,
    OverlayShapeCustomFrame
};

// Current shape property
@property (nonatomic, assign) OverlayShape currentShape;

@end




@implementation MainController
//@synthesize isVideoOrderChangedByUser;
//@synthesize videoTimeRange;
@synthesize isVideoFile;
@synthesize isTouchWillDetect;
//@synthesize tabBar;
//@synthesize imageForEdit;
@synthesize applicationSuspended;
@synthesize initialPhotoIndex;
@synthesize videoImageInfo;
@synthesize orderArrayForVideoItems;
@synthesize counterVariable;
@synthesize  currentSelectedPhotoNumberForEffect;
@synthesize removeWaterMark;
// @synthesize timer; // Removed - old popup system
@synthesize fontSizeSlider;
@synthesize textBox;
@synthesize maxWidth;
@synthesize maxHeight;
@synthesize trackImgV;
@synthesize fontsCollectionView;
@synthesize ColorsCollectionView;
@synthesize alignmentCollectionView;
@synthesize ellipsisOverlay;
@synthesize uitoolbar;
@synthesize keyboardHeight;
@synthesize isCollectionViewVisible;
@synthesize uititleLabel;
@synthesize titleLabelColor;
@synthesize fontNames;
@synthesize alignments;
@synthesize selectedAlignment;
@synthesize alignmentIndex;
@synthesize isCustomFrameEnabled;

//NSArray<NSString *> *videoSafeCIFilters = @[
//
//    @"CIPhotoEffectNoir",
//    @"CIPhotoEffectMono",
//    @"CIPhotoEffectChrome",
//    @"CIPhotoEffectFade",
//    @"CIPhotoEffectInstant",
//    @"CIPhotoEffectProcess",
//    @"CIPhotoEffectTonal",
//    @"CIPhotoEffectTransfer",
//    @"CIColorPosterize",
//    @"CISepiaTone",
//    @"CIHighlightShadowAdjust",
//    @"CIColorMonochrome",
//    @"CIFalseColor",];
#pragma mark image editing

- (void)doneWithPhotoEffectsEditor:(NSTimer*)t
{
    UIImage *img = [t.userInfo objectForKey:@"image"];
    
    if(nil == img)
    {
        return;
    }
    
    [sess imageSelectedForPhoto:img];
}


#if SHAPE_CHAGING_SUPPORT
- (int)numberOfItemsInSqwController:(sgwController*)sender
{
    return [ShapeMapping shapeCount];
}

- (NSString*)sgwController:(sgwController*)sender titleForTheItemAtIndex:(int)index
{
    return [ShapeMapping nameOfTheShapeAtIndex:index];
}

- (UIImage*)sgwController:(sgwController*)sender imageForTheItemAtIndex:(int)index
{
    return [ssivView imageForShape:index];
}

- (void)sgwController:(sgwController*)sender itemDidSelectAtIndex:(int)index
{
    [sess shapePreviewSelectedForPhoto:index];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notification_sgwcontroller_updatepreview object:nil];
}

- (BOOL)sgwController:(sgwController*)sender isItemLockedAtIndex:(int)index
{
    return [ShapeMapping getLockStatusOfShape:index group:FRAME_SHAPE_GROUP_1];
}

- (void)sgwControllerDidCancel:(sgwController*)sender initialItem:(int)index
{
    [sess shapeSelectedForPhoto:index];
}

- (void)sgwController:(sgwController*)sender didDoneSelectingItemAtIndex:(int)index
{
    [sess shapeSelectedForPhoto:index];
}

- (UIImage*)previewImageForSgwController:(sgwController*)sender
{
    return [sess.frame renderToImageOfScale:1.0]; // 2.0
}

- (void)showShapes
{
    sgwController *sgw = [[sgwController alloc]initWithDelegate:self currentItem:[sess shapeOfCurrentlySelectedPhoto]];
    [self.navigationController presentModalViewController:sgw animated:NO];
    [sgw release];
    
    //    if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    //    {
    //        sgw.backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"mainbackground_ipad" ofType:@"png"]];
    //    }
    //    else
    //    {
    //        sgw.backgroundView.image = [UIImage imageWithContentsOfFile:[Utility documentDirectoryPathForFile:@"mainbackground.jpg"]];
    //    }
}


#endif
#pragma mark imageselection

- (void)imageSelected:(UIImage *)img
{
    if(nil == img)
    {
        NSLog(@"Received invalid image from image selection");
        return;
    }
    
    [sess imageSelectedForPhoto:img];
    
    return;
}





- (void)showPhotoEffectsEditor
{
    [LoadingClass removeActivityIndicatorFrom:self.view];
}

-(float)getShadowValue
{
    return sess.getShadowValue;
}

- (float)getOuterRadius
{
    return sess.getOuterRadius;
}

- (float)getInnerRadius
{
    return sess.getInnerRadius;
}

-(float)getFrameWidth
{
    return sess.getFrameWidth;
}




- (void)presentPopoverFromSourceView:(UIView *)sourceView {
    // 1. Create the content view controller
    UIViewController *contentViewController = [[UIViewController alloc] init];
    contentViewController.preferredContentSize = CGSizeMake(300, 200);
    contentViewController.view.backgroundColor = DARK_GRAY_BG;
    
    // 2. Set the modal presentation style
    contentViewController.modalPresentationStyle = UIModalPresentationPopover;
    
    // 3. Access and configure the popover presentation controller
    UIPopoverPresentationController *popoverController = contentViewController.popoverPresentationController;
    if (popoverController) {
        popoverController.sourceView = sourceView; // The view to anchor the popover
        popoverController.sourceRect = sourceView.bounds; // The rectangle to anchor the popover
        popoverController.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
        popoverController.delegate = self; // Optional: Handle adaptive presentations
    }
    
    // 4. Present the popover
    [self presentViewController:contentViewController animated:YES completion:nil];
}




- (void)loadTheSession
{
    NSLog(@"load session is calling----");
    sess = [[Session alloc]initWithSessionId:nvm.currentSessionIndex];
    
    if(nil == sess)
    {
        sess = [[Session alloc]initWithFrameNumber:nvm.currentFrameNumber];
        if(nil == sess)
        {
            return;
        }
    }
    [sess showSessionOn:mainBackground];//self.view
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"IsAdditionalAudioSet"];
    NSLog(@"select edit tab is called from load the session");
    [self selectEditTab];
    [LoadingClass removeActivityIndicatorFrom:self.view];
    nvm = [Settings Instance];
    // don't show even first installation helpscreen slide show
    //    if(nvm.videoTutorialWatched == NO)
    //    {
    //        [self perform_Help];
    //        // in this method leaks are there
    //        nvm.videoTutorialWatched = YES;
    //    }
#if FULLSCREENADS_ENABLE
    if(bShowRevModAd)
    {
        bShowRevModAd = NO;
    }
#endif
    
}


#pragma mark Start saving video frames to HDD

- (UIImageOrientation)getOrientationFrom:(AVAssetTrack*)inputAssetTrack
{
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    CGAffineTransform videoTransform = inputAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        NSLog(@"UIImageOrientation right");
        videoAssetOrientation_ = UIImageOrientationRight;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        NSLog(@"UIImageOrientation left");
        videoAssetOrientation_ =  UIImageOrientationLeft;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        NSLog(@"UIImageOrientation up");
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        NSLog(@"UIImageOrientation down");
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    return videoAssetOrientation_;
}

- (CGSize)getOptimalSizeFor:(AVAssetTrack*)inputAssetTrack
{
    float maxWidth = full_screen.size.width;
    //float maxHeight = full_screen.size.width;
    float width = inputAssetTrack.naturalSize.width;
    float height = inputAssetTrack.naturalSize.height;
    
#if MIN_SIZE_320
    if(width > height)
    {
        if(height > 320.0)
        {
            width  = (320.0/height)*width;
            height = 320.0;
        }
    }
    else
    {
        if(width > 320.0)
        {
            height = (320.0/width)*height;
            width = 320.0;
        }
    }
#else
    if(width > height)
    {
        if(width > maxWidth)
        {
            height = (maxWidth/width)*height;
            width  = maxWidth;
        }
    }
    else
    {
        if(height > maxWidth)
        {
            width = (maxWidth/height)*width;
            height = maxWidth;
        }
    }
#endif
    CGSize naturalSize = inputAssetTrack.naturalSize;
    
    CGSize sze = CGSizeMake(width, height);
    NSLog(@"width %f height %f",width,height);
    return naturalSize; //sze; //sze
}


- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) {
        return image; // Already correct
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}


- (void)writeFrame:(UIImage*)image atFrameIndex:(int)frmIndex videoIndex:(int)vidIndex ofTotalFrame:(int)frames
{
    image = [self normalizedImage:image];
    @autoreleasepool {
        NSString *imgPath = [sess pathForImageAtIndex:frmIndex inPhoto:vidIndex];
        //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[UIImageJPEGRepresentation(image, 0.8) writeToFile:imgPath atomically:YES];
        NSData *pngData = UIImagePNGRepresentation(image);
        [pngData writeToFile:imgPath atomically:YES];
        //    });
        float pr = videoSaveprogress + ((float)frmIndex/(float)frames) * 0.5;
        // NSLog(@"import progress is %@",[NSNumber numberWithFloat:pr]);
        [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:pr] waitUntilDone:YES];
        // imgPath = nil;
    }
}

- (void)saveVideoFramesToHDD:(AVURLAsset*)inputAsset onCompletion:(void (^)(BOOL status, NSMutableDictionary *videoInfo))completion
{
    @autoreleasepool {
        NSError *error = nil;
        AVAssetTrack *inputAssetTrack = nil;
        
        if (inputAsset.tracks.count > 0) {
            inputAssetTrack = [[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        } else {
            NSLog(@"Tracks are not available.");
            if (completion) {
                completion(NO, nil);
            }
            return;
        }
        
        int nominalFrameRate = (int)roundf(inputAssetTrack.nominalFrameRate);
        double duration = CMTimeGetSeconds([inputAsset duration]);
        int desiredFps = 1;  // Desired output FPS (could be adjustable)
        
        double nrFrames = duration * desiredFps ;  //nominalFrameRate;
        
        
        // Adjust frame rate logic: calculate how many frames to drop or duplicate
        double resampleFactor = (double)nominalFrameRate / desiredFps;
        BOOL requiresDuplication = resampleFactor < 1.0;  // If less than desired fps, we need to duplicate frames
        BOOL requiresSkipping = resampleFactor > 1.0;     // If more than desired fps, we need to skip frames
        
        int frameIndex = 0;
        int origCount = 0;
        int duplicateFrequency = (int)roundf(resampleFactor); // How often we duplicate frames if needed
        
        NSLog(@"resampleFactor %f requiresDuplication %@ requiresSkipping %@ duplicateFrequency %d",resampleFactor,requiresDuplication?@"YES":@"NO",requiresSkipping?@"YES":@"NO",duplicateFrequency);
        
        float timeDurationLimit = 5.0; //30.0;
        if ([[SRSubscriptionModel shareKit] IsAppSubscribed]) {
            timeDurationLimit = 5.0; //120.0;
        }
        
        if (duration > timeDurationLimit) {
            duration = timeDurationLimit;
        }
        
        nrFrames = duration * desiredFps;  //nominalFrameRate;
        double outputFrameDuration = 1.0 / desiredFps;
        double currentOutputTime = 0.0;
        
        NSLog(@"Desired FPS: %d, Original FPS: %d, Duration: %f, Number of frames: %f", desiredFps, nominalFrameRate, duration, nrFrames);
        
        // Get video orientation
        UIImageOrientation videoAssetOrientation = [self getOrientationFrom:inputAssetTrack];
        
        AVKeyValueStatus tracksStatus = [inputAsset statusOfValueForKey:@"tracks" error:&error];
        if (!(tracksStatus == AVKeyValueStatusLoaded)) {
            if (completion) {
                completion(NO, nil);
            }
            return;
        }
        
        [sess deleteVideoFramesForPhotoAtIndex:currentClickedPhotoFrameNumber];
        [sess deleteVideoEffectFramesForPhotoAtIndex:currentSelectedPhotoNumberForEffect];
        
        // Read video samples from input asset video track
        AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:inputAsset error:&error];
        NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
        CGSize sze = [self getOptimalSizeFor:inputAssetTrack];
        NSLog(@"Save video frames to HDD width: %f height: %f", sze.width, sze.height);
        [outputSettings setObject:@(kCVPixelFormatType_32BGRA) forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
        
        
        [outputSettings setObject:@(sze.width) forKey:(NSString*)kCVPixelBufferWidthKey];
        [outputSettings setObject:@(sze.height) forKey:(NSString*)kCVPixelBufferHeightKey];
        
        AVAssetReaderTrackOutput *readerVideoTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[inputAsset tracksWithMediaType:AVMediaTypeVideo].firstObject outputSettings:outputSettings];
        [reader addOutput:readerVideoTrackOutput];
        
        if (![reader startReading]) {
            if (completion) {
                completion(NO, nil);
            }
            return;
        }
        
        while (reader.status == AVAssetReaderStatusReading) {
            @autoreleasepool {
                CMSampleBufferRef sampleBufferRef = [readerVideoTrackOutput copyNextSampleBuffer];
                if (sampleBufferRef) {
                    
                    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);
                    
                    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
                    CGImageRef newImage = [self.sharedContext createCGImage:ciImage fromRect:ciImage.extent];
                    
                    
                    //                    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
                    //
                    //                    CGRect imageRect = CGRectMake(0, 0, CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer));
                    //                    CGImageRef newImage = [self.sharedContext createCGImage:ciImage fromRect:imageRect];
                    
                    
                    //                    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);
                    //                    CVPixelBufferLockBaseAddress(imageBuffer, 0);
                    //                    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
                    //                    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
                    //                    size_t width = CVPixelBufferGetWidth(imageBuffer);
                    //                    size_t height = CVPixelBufferGetHeight(imageBuffer);
                    //                    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
                    //
                    //                    // Create a CGImageRef from the CVImageBufferRef
                    //                    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB); //CGColorSpaceCreateDeviceRGB();
                    //                    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
                    //                    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
                    //
                    //                    CGContextRelease(newContext);
                    //                    CGColorSpaceRelease(colorSpace);
                    
                    //                    if (requiresDuplication) {
                    //                        // Duplicate logic (for low FPS sources)
                    //                        if (origCount % duplicateFrequency == 0) {
                    //                            [self writeFrame:[UIImage imageWithCGImage:newImage scale:1.0 orientation:videoAssetOrientation]
                    //                                atFrameIndex:frameIndex
                    //                                  videoIndex:currentClickedPhotoFrameNumber
                    //                                ofTotalFrame:nrFrames];
                    //                            frameIndex++;
                    //                        }
                    //                    } else if (requiresSkipping) {
                    //                        // Skipping logic (for high FPS sources)
                    //                        if (origCount % (int)roundf(resampleFactor) == 0) {
                    //                            [self writeFrame:[UIImage imageWithCGImage:newImage scale:1.0 orientation:videoAssetOrientation]
                    //                                atFrameIndex:frameIndex
                    //                                  videoIndex:currentClickedPhotoFrameNumber
                    //                                ofTotalFrame:nrFrames];
                    //                            frameIndex++;
                    //                        }
                    //                    } else {
                    //                        // Equal FPS, save every frame
                    //                        [self writeFrame:[UIImage imageWithCGImage:newImage scale:1.0 orientation:videoAssetOrientation]
                    //                            atFrameIndex:frameIndex
                    //                              videoIndex:currentClickedPhotoFrameNumber
                    //                            ofTotalFrame:nrFrames];
                    //                        frameIndex++;
                    //                    }
                    CMTime sampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBufferRef);
                    double sampleTimeSec = CMTimeGetSeconds(sampleTime);
                    
                    // Write this frame if it matches or exceeds the next output time
                    while (sampleTimeSec >= currentOutputTime) {
                        [self writeFrame:[UIImage imageWithCGImage:newImage scale:1.0 orientation:videoAssetOrientation]
                            atFrameIndex:frameIndex
                              videoIndex:currentClickedPhotoFrameNumber
                            ofTotalFrame:nrFrames];
                        frameIndex++;
                        currentOutputTime += outputFrameDuration;
                    }
                    CGImageRelease(newImage);
                    CMSampleBufferInvalidate(sampleBufferRef);
                    CFRelease(sampleBufferRef);
                    sampleBufferRef = NULL;
                    
                    origCount++;
                    if (frameIndex >= nrFrames) break;
                    //                    if (nrFrames == frameIndex) {
                    //                        break;
                    //                    }
                }
            }
        }
        
        @autoreleasepool {
            NSMutableDictionary *videoInfo = [[NSMutableDictionary alloc] initWithCapacity:5];
            [videoInfo setObject:@(frameIndex) forKey:@"FrameCount"];
            [videoInfo setObject:@(currentClickedPhotoFrameNumber) forKey:@"VideoFrameIndex"];
            [videoInfo setObject:@(duration) forKey:@"Duration"];
            [videoInfo setObject:@(nominalFrameRate) forKey:@"Fps"];
            if([userDefault integerForKey:@"FirstVideoSelected"] == 0)
            {
                NSLog(@"Play audio at index 1");
                [userDefault setInteger:1 forKey:@"FirstVideoSelected"]; // First selected Video
                [videoInfo setObject:@(0) forKey:@"MuteAudio"]; // To keep video Unmute
            }else{
                NSLog(@"mute audio at index 1");
                [videoInfo setObject:@(1) forKey:@"MuteAudio"]; // To mute video
            }
            [[NSUserDefaults standardUserDefaults] setObject:videoInfo forKey:@"VideoInfo"];
            
            if (completion) {
                completion(YES, videoInfo);
            }
        }
    }
}


//- (void)saveVideoFramesToHDD:(AVURLAsset*)inputAsset onCompletion:(void (^)(BOOL status, NSMutableDictionary *videoInfo))completion
//{
//   // NSArray *videoTracks = [NSArray arrayWithArray: [inputAsset tracksWithMediaType:AVMediaTypeVideo]];
//   // NSAutoreleasePool *bpool = [NSAutoreleasePool new];
//  //  @autoreleasepool {
//
//        NSError           *error = nil;
//        //here is the problem
//        AVAssetTrack      *inputAssetTrack = nil;
//        //int tracks = 2;
//
//        if(inputAsset.tracks.count>0)
//        {
//            inputAssetTrack = [[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];//kasaram
//        }
//        else
//        {
//            inputAssetTrack = [[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];//kasaram
//            // inputAssetTrack = [[inputAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];//kasaram
//            NSLog(@"Tracks are not avaible----");
//            //inputAssetTrack = [[inputAsset tracksWithMediaType:AVMediaTypeVideo]firstObject];
//        }
//
//        // AVAssetTrack      *inputAssetTrack = [[inputAsset tracksWithMediaType:AVMediaTypeVideo] lastObject];
//
//        //    AVAssetTrack *inputAssetTrack2 = [[inputAsset tracksWithMediaType:AVMediaTypeVideo] lastObject];
//    //int trackFPS = (int)(inputAssetTrack.nominalFrameRate);
//  //  NSLog(@"track fps %d",trackFPS);
//
//    int nominalFrameRate = (int)roundf(inputAssetTrack.nominalFrameRate);
////    if (nominalFrameRate <= 0) {
////        nominalFrameRate = 30; // fallback
////        NSLog(@"Warning: invalid FPS from track, using fallback value.");
////    }
//    double duration = CMTimeGetSeconds([inputAsset duration]);
//    double nrFrames = CMTimeGetSeconds([inputAsset duration]) * nominalFrameRate; //30;
//        int frameIndex = 0;
//        int origCount  = 0;
//       // int duplicateFrequency = 0;
//       // BOOL requiresDuplication = NO;
//        float timeDurationLimit = 30.0;
//
//        if([[SRSubscriptionModel shareKit]IsAppSubscribed])
//        {
//            timeDurationLimit = 120.0;
//        }
//        //videoTimeRange =videoTimeRange+ duration;
//        //round the duration to 30 seconds
//        if(duration > timeDurationLimit)
//        {
//            duration = timeDurationLimit;
//            //videoTimeRange =videoTimeRange+ 30;
//        }
//    nrFrames = duration * nominalFrameRate; //30;
//        NSLog(@"timeDurationLimit %f duration  %f nrFrames %f  ",timeDurationLimit,duration,nrFrames);
//
//        /* Caluclate how often do we need to repeat the frames to achive 30fps, and inject those frames while
//         reading and saving those frames */
////        if(inputAssetTrack.nominalFrameRate < 30.0f)
////        {
////            float currentFrameCount          = inputAssetTrack.nominalFrameRate * duration;
////            float framesRequiredToReach30fps = (currentFrameCount/inputAssetTrack.nominalFrameRate)*30.0f;
////            float framesToDuplicate = framesRequiredToReach30fps - currentFrameCount;
////
////            /* How often do we need to Duplicate the frames */
////            duplicateFrequency = (int)((float)currentFrameCount/framesToDuplicate);
////            requiresDuplication = YES;
////        }
//
//  //  NSLog(@"========>>> inputAssetTrack.nominalFrameRate %f duplicateFrequency %d requiresDuplication %@ ",inputAssetTrack.nominalFrameRate,duplicateFrequency,requiresDuplication?@"YES":@"NO");
//        //print brief details of the track
//
//        //get video orientataion
//        UIImageOrientation videoAssetOrientation_ = [self getOrientationFrom:inputAssetTrack];
//
//        // Check status of "tracks", make sure they were loaded
//        AVKeyValueStatus tracksStatus = [inputAsset statusOfValueForKey:@"tracks" error:&error];
//        if (!(tracksStatus == AVKeyValueStatusLoaded))
//        {
//            // failed to load
//            if(nil != completion)
//            {
//                completion(NO,nil);
//            }
//            //  [bpool release];
//            return;
//        }
//
//        /* delete existing frames */
//    [sess deleteVideoFramesForPhotoAtIndex:currentClickedPhotoFrameNumber];
//    [sess deleteVideoEffectFramesForPhotoAtIndex:currentSelectedPhotoNumberForEffect];
//        /* Read video samples from input asset video track */
//        AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:inputAsset error:&error];
//        NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
//        CGSize sze = [self getOptimalSizeFor:inputAssetTrack];
//    NSLog(@"save video frames to hdd width %f heighjt %f ",sze.width,sze.height);
//        /* TBD uncomment below line if optimization doesn't work */
//        [outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
//        [outputSettings setObject:[NSNumber numberWithFloat:sze.width] forKey:(NSString*)kCVPixelBufferWidthKey];
//        [outputSettings setObject:[NSNumber numberWithFloat:sze.height] forKey:(NSString*)kCVPixelBufferHeightKey];
//
//        //[outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_24BGR]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
//        AVAssetReaderTrackOutput *readerVideoTrackOutput = nil;
//        if(inputAsset.tracks.count>0)
//        {
//            readerVideoTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] outputSettings:outputSettings];
//        }
//
//        //kasaram -//changed to LastObject from objectAtIndex:0
//
//        // Assign the tracks to the reader and start to read
//        [reader addOutput:readerVideoTrackOutput];
//        if ([reader startReading] == NO)
//        {
//            // Handle error
//
//            if(nil != completion)
//            {
//                completion(NO,nil);
//            }
//            //  [bpool release];
//            return;
//        }
//
//        while (reader.status == AVAssetReaderStatusReading)
//        {
//            // NSAutoreleasePool *pool = [NSAutoreleasePool new];
//            @autoreleasepool {
//                CMSampleBufferRef sampleBufferRef = [readerVideoTrackOutput copyNextSampleBuffer];
//                if (sampleBufferRef)
//                {
//                    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);
//                    /*Lock the image buffer*/
//                    CVPixelBufferLockBaseAddress(imageBuffer,0);
//                    /*Get information about the image*/
//                    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
//                    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//                    size_t width = CVPixelBufferGetWidth(imageBuffer);
//                    size_t height = CVPixelBufferGetHeight(imageBuffer);
//
//                    /*We unlock the  image buffer*/
//                    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//
//                    /*Create a CGImageRef from the CVImageBufferRef*/
//                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//                    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//                    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
//
//                    /*We release some components*/
//                    CGContextRelease(newContext);
//                    CGColorSpaceRelease(colorSpace);
//
//#if 0
//                    UIImage *image = [self scaledCopyOfImage:newImage toSize:sze inputOrientation:videoAssetOrientation_];
//                    [self writeFrame:image atFrameIndex:frameIndex videoIndex:currentIndex ofTotalFrame:nrFrames];
//#else
//                    [self writeFrame:[UIImage imageWithCGImage:newImage scale:1.0 orientation:videoAssetOrientation_] atFrameIndex:frameIndex videoIndex:currentClickedPhotoFrameNumber ofTotalFrame:nrFrames];
//#endif
//                    frameIndex++;
//
////                    if(requiresDuplication)
////                    {
////
////                        if((0 != duplicateFrequency)&&(0 ==(origCount%duplicateFrequency)))
////                        {
////                            [self writeFrame:[UIImage imageWithCGImage:newImage scale:1.0 orientation:videoAssetOrientation_] atFrameIndex:frameIndex videoIndex:currentClickedPhotoFrameNumber ofTotalFrame:nrFrames];
////                            frameIndex++;
////                        }
////                    }
//                    /*We release the CGImageRef*/
//                    CGImageRelease(newImage);
//
//                    CMSampleBufferInvalidate(sampleBufferRef);
//                    CFRelease(sampleBufferRef);
//                    sampleBufferRef = NULL;
//
//                    origCount++;
//
//                }
//
//                // [pool release];
//
//                if(nrFrames == frameIndex)
//                {
//                    break;
//                }
//            }
//        }
//
//
//        //    [bpool release];
//        @autoreleasepool
//        {
//        NSMutableDictionary *videoInfo = [[NSMutableDictionary alloc]initWithCapacity:3];
//        [videoInfo setObject:[NSNumber numberWithInt:frameIndex] forKey:@"FrameCount"];
//        [videoInfo setObject:[NSNumber numberWithInt:currentClickedPhotoFrameNumber] forKey:@"VideoFrameIndex"];
//        [videoInfo setObject:[NSNumber numberWithFloat:duration] forKey:@"Duration"];
//        [videoInfo setObject:[NSNumber numberWithFloat:nominalFrameRate] forKey:@"Fps"];
//        [[NSUserDefaults standardUserDefaults]setObject:videoInfo forKey:@"VideoInfo"];
//
//        if(nil != completion)
//        {
//            completion(YES,videoInfo);
//        }
//            videoInfo = nil;
//    }
////  }
//}


- (void)update_Progress:(float)prog
{
    UIImageView *touchBlock = (UIImageView*)[self.view viewWithTag:33658];
    if(nil != touchBlock)
    {
        UIProgressView *pv = (UIProgressView*)[touchBlock viewWithTag:3658];
        if(nil != pv)
        {
            [pv setProgress:prog];
        }
    }
    // Set progress (0.0 to 1.0)
    [progressView setProgress:prog animated:YES];
    
}



- (void)updateProgress:(NSNumber*)prog
{
    UIImageView *touchBlock = (UIImageView*)[self.view viewWithTag:33658];
    if(nil != touchBlock)
    {
        //[touchBlock removeFromSuperview];
        
        UIProgressView *pv = (UIProgressView*)[touchBlock viewWithTag:3658];
        if(nil != pv)
        {
            float value = [prog floatValue];
            [pv setProgress:value];
        }
    }
}

- (void)removeProgressBar
{
    UIImageView *touchBlock = (UIImageView*)[self.view viewWithTag:33658];
    if(nil != touchBlock)
    {
        //UIProgressView *pv = (UIProgressView*)[self.view viewWithTag:3658];
        UIProgressView *pv = (UIProgressView*)[touchBlock viewWithTag:3658];
        if(nil != pv)
        {
            [pv removeFromSuperview];
            //  [pv release];
        }
        [touchBlock removeFromSuperview];
        //   [touchBlock release];
        generatingVideo = NO;
    }
}

- (void)addprogressBarWithMsg:(NSString*)msgText
{
    CGRect full = [[UIScreen mainScreen]bounds];
    
    /* Add touch block view */
    UIImageView *touchBlock = [[UIImageView alloc]initWithFrame:full];
    touchBlock.userInteractionEnabled = YES;
    touchBlock.tag = 33658;
    [self.view addSubview:touchBlock];
    //[touchBlock release];
    
    /* add lable and bar display frame */
    UIView *displayArea = [[UIView alloc]initWithFrame:CGRectMake(0, 0, full.size.width-150, 100)];
    displayArea.backgroundColor = DARK_GRAY_BG;
    displayArea.alpha = 0.8;
    displayArea.layer.cornerRadius = 9.0;
    displayArea.center = touchBlock.center;
    [touchBlock addSubview:displayArea];
    
    // [displayArea release];
    
    /* Add label */
    UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, displayArea.frame.size.width, displayArea.frame.size.height/2.0)];
    msg.backgroundColor = [UIColor clearColor];
    msg.text = msgText;
    msg.textAlignment = NSTextAlignmentCenter;
    msg.textColor = [UIColor whiteColor];
    msg.font = [UIFont boldSystemFontOfSize:15.0];
    msg.center = CGPointMake(touchBlock.center.x, touchBlock.center.y-(msg.frame.size.height/2.0));
    [touchBlock addSubview:msg];
    //[msg release];
    
    UIProgressView *pv = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    pv.tag = 3658;
    pv.frame = CGRectMake(10, msg.frame.origin.y+msg.frame.size.height, displayArea.frame.size.width-20, displayArea.frame.size.height/2.0);
    pv.center = CGPointMake(touchBlock.center.x, pv.center.y+pv.frame.size.height/2.0);
    [touchBlock addSubview:pv];
    
    // [pv release];
    msg = nil;
    displayArea = nil;
    touchBlock = nil;
    pv = nil;
}

#pragma mark end saving video frames to HDD
#pragma mark start generating video from images

- (NSDictionary*)getVideoSettings
{
    int videoSize = [self getRenderSize];
    int width = [self getRenderSize]; //640; //sess.frame.frame.size.width;
    int height = [self getRenderSize]; //640; //sess.frame.frame.size.height;
    NSLog(@"aspect ratio is %d h ratio %f w ratio %f ",sess.aspectRatio,nvm.hRatio,nvm.wRatio);
    if(nvm.hRatio > nvm.wRatio) // Video is portrait
    {
        width = (int)((nvm.wRatio / nvm.hRatio) * videoSize);
    }
    else if(nvm.wRatio > nvm.hRatio) // Video is landscape
    {
        height = (int)((nvm.hRatio / nvm.wRatio) * videoSize);
    }
    
    //    NSLog(@"after computation video size is width %d height %d",width,height);
    //    int fps = 30;//[sess getFPSForPhotoAtIndex];
    //    NSDictionary *compressionProperties = @{
    //        AVVideoAverageBitRateKey: @(6000000), // adjust as needed
    //        AVVideoExpectedSourceFrameRateKey: @(fps), // 🔥 set FPS here
    //        AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
    //    };
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   //AVVideoCodecH264
                                   AVVideoCodecTypeH264, AVVideoCodecKey,
                                   // compressionProperties,AVVideoCompressionPropertiesKey,
                                   [NSNumber numberWithInt:width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:height], AVVideoHeightKey,
                                   nil];
    return videoSettings;
}

//- (NSDictionary*)getVideoSettings
//{
//    int videoSize = 640;
//    int width = 640; //sess.frame.frame.size.width;
//    int height = 640; //sess.frame.frame.size.height;
//    NSLog(@"aspect ratio is %d h ratio %f w ratio %f ",sess.aspectRatio,nvm.hRatio,nvm.wRatio);
//    if(nvm.hRatio > nvm.wRatio) // Video is portrait
//    {
//        width = (int)((nvm.wRatio / nvm.hRatio) * videoSize);
//    }
//    else if(nvm.wRatio > nvm.hRatio) // Video is landscape
//    {
//        height = (int)((nvm.hRatio / nvm.wRatio) * videoSize);
//    }
//    NSLog(@"after computation video size is width %d height %d",width,height);
//    NSDictionary *compressionProps = @{
//        AVVideoAverageBitRateKey: @(10000000), // 6 Mbps (adjust as needed)
//        AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
//    };
//
//    NSDictionary *videoSettings = @{
//        AVVideoCodecKey: AVVideoCodecTypeH264,
//        AVVideoWidthKey: @(width),
//        AVVideoHeightKey: @(height),
//        AVVideoCompressionPropertiesKey: compressionProps
//    };
//
//    return videoSettings;
//}


//- (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image size:(CGSize)size {
//    NSDictionary *options = @{
//        (NSString *)kCVPixelBufferCGImageCompatibilityKey: @YES,
//        (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES
//    };
//
//    CVPixelBufferRef pxbuffer = NULL;
//    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef)options, &pxbuffer);
//
//    if (status != kCVReturnSuccess) {
//        return NULL;
//    }
//
//    CVPixelBufferLockBaseAddress(pxbuffer, 0);
//    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//
//    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, CVPixelBufferGetBytesPerRow(pxbuffer), rgbColorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
//
//    // Clear the context to avoid artifacts
//    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
//
//    // Correct orientation and scale
//    CGContextTranslateCTM(context, 0, size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//
//    CGRect drawRect = AVMakeRectWithAspectRatioInsideRect(image.size, CGRectMake(0, 0, size.width, size.height));
//    CGContextDrawImage(context, drawRect, image.CGImage);
//
//    CGContextRelease(context);
//    CGColorSpaceRelease(rgbColorSpace);
//    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//
//    return pxbuffer;
//}


- (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image size:(CGSize)size {
    NSDictionary *options = @{
        (NSString *)kCVPixelBufferCGImageCompatibilityKey: @YES,
        (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES
    };
    
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef)options, &pxbuffer);
    
    if (status != kCVReturnSuccess) {
        return NULL;
    }
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, CVPixelBufferGetBytesPerRow(pxbuffer), rgbColorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if (!context) {
        CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
        CGColorSpaceRelease(rgbColorSpace);
        CVPixelBufferRelease(pxbuffer);
        return NULL;
    }
    
    // Clear the context to avoid artifacts
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // Apply the correct orientation transform
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            // No transformation needed
            break;
        case UIImageOrientationDown:
            CGContextTranslateCTM(context, size.width, size.height);
            CGContextRotateCTM(context, M_PI);
            break;
        case UIImageOrientationLeft:
            CGContextTranslateCTM(context, size.width, 0);
            CGContextRotateCTM(context, M_PI_2);
            break;
        case UIImageOrientationRight:
            CGContextTranslateCTM(context, 0, size.height);
            CGContextRotateCTM(context, -M_PI_2);
            break;
        case UIImageOrientationUpMirrored:
            CGContextTranslateCTM(context, size.width, 0);
            CGContextScaleCTM(context, -1.0, 1.0);
            break;
        case UIImageOrientationDownMirrored:
            CGContextTranslateCTM(context, 0, size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored:
            CGContextTranslateCTM(context, size.width, size.height);
            CGContextScaleCTM(context, -1.0, 1.0);
            CGContextRotateCTM(context, M_PI_2);
            break;
        case UIImageOrientationRightMirrored:
            CGContextTranslateCTM(context, 0, 0);
            CGContextScaleCTM(context, -1.0, 1.0);
            CGContextRotateCTM(context, -M_PI_2);
            break;
        default:
            break;
    }
    
    // Draw the image
    CGRect drawRect = AVMakeRectWithAspectRatioInsideRect(image.size, CGRectMake(0, 0, size.width, size.height));
    CGContextDrawImage(context, drawRect, image.CGImage);
    
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}



//- (CVPixelBufferRef)pixelBufferFromUIImage:(UIImage *)image size:(CGSize)size {
//    @autoreleasepool {
//        if (!image) {
//            NSLog(@"pixel Buffer From UIImage: Image is nil");
//            return NULL;
//        }
//
//        CGImageRef cgImage = image.CGImage;
//        if (!cgImage) {
//            NSLog(@"pixel Buffer From UIImage: CGImage is nil");
//            return NULL;
//        }
//
//        NSDictionary *options = @{
//            (__bridge NSString *)kCVPixelBufferCGImageCompatibilityKey : @YES,
//            (__bridge NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES
//        };
//
//        CVPixelBufferRef pxbuffer = NULL;
//        CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
//                                              size.width,
//                                              size.height,
//                                              kCVPixelFormatType_32ARGB,
//                                              (__bridge CFDictionaryRef)options,
//                                              &pxbuffer);
//
//        if (status != kCVReturnSuccess || pxbuffer == NULL) {
//            NSLog(@"Failed to create pixel buffer (status: %d)", status);
//            return NULL;
//        }
//
//        CVPixelBufferLockBaseAddress(pxbuffer, 0);
//        void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//        if (!pxdata) {
//            NSLog(@"Failed to get base address of pixel buffer");
//            CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//            CVPixelBufferRelease(pxbuffer);
//            return NULL;
//        }
//
//        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//        if (!rgbColorSpace) {
//            NSLog(@"Failed to create RGB color space");
//            CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//            CVPixelBufferRelease(pxbuffer);
//            return NULL;
//        }
//
//        CGContextRef context = CGBitmapContextCreate(pxdata,
//                                                     size.width,
//                                                     size.height,
//                                                     8,
//                                                     4 * size.width,
//                                                     rgbColorSpace,
//                                                     kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
//        CGColorSpaceRelease(rgbColorSpace); // Release color space as it's no longer needed.
//
//        if (!context) {
//            NSLog(@"Failed to create bitmap context");
//            CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//            CVPixelBufferRelease(pxbuffer);
//            return NULL;
//        }
//
//        // Draw the image into the context
//        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), cgImage);
//        CGContextRelease(context); // Release the context as it's no longer needed.
//
//        CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//        return pxbuffer;
//    }
//}


- (CVPixelBufferRef)pixelBufferFromUIImage:(UIImage *)image size:(CGSize)size {
    @autoreleasepool {
        if (!image || !image.CGImage) {
            NSLog(@"[Error] Image or its CGImage is nil");
            return NULL;
        }
        
        NSDictionary *options = @{
            (__bridge NSString *)kCVPixelBufferCGImageCompatibilityKey: @YES,
            (__bridge NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES
        };
        
        CVPixelBufferRef pixelBuffer = NULL;
        CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                              size.width,
                                              size.height,
                                              kCVPixelFormatType_32BGRA,
                                              (__bridge CFDictionaryRef)options,
                                              &pixelBuffer);
        if (status != kCVReturnSuccess || pixelBuffer == NULL) {
            NSLog(@"[Error] Failed to create CVPixelBuffer (status: %d)", status);
            return NULL;
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        void *baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
        
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(baseAddress,
                                                     size.width,
                                                     size.height,
                                                     8,
                                                     CVPixelBufferGetBytesPerRow(pixelBuffer),
                                                     rgbColorSpace,
                                                     kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
        CGColorSpaceRelease(rgbColorSpace);
        
        if (!context) {
            NSLog(@"[Error] Failed to create CGContext");
            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
            CVPixelBufferRelease(pixelBuffer);
            return NULL;
        }
        
        // Clear context to avoid garbage data
        CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
        
        // Handle image orientation
        switch (image.imageOrientation) {
            case UIImageOrientationUp:
                break;
            case UIImageOrientationDown:
                CGContextTranslateCTM(context, size.width, size.height);
                CGContextRotateCTM(context, M_PI);
                break;
            case UIImageOrientationLeft:
                CGContextTranslateCTM(context, size.width, 0);
                CGContextRotateCTM(context, M_PI_2);
                break;
            case UIImageOrientationRight:
                CGContextTranslateCTM(context, 0, size.height);
                CGContextRotateCTM(context, -M_PI_2);
                break;
            case UIImageOrientationUpMirrored:
                CGContextTranslateCTM(context, size.width, 0);
                CGContextScaleCTM(context, -1.0, 1.0);
                break;
            case UIImageOrientationDownMirrored:
                CGContextTranslateCTM(context, 0, size.height);
                CGContextScaleCTM(context, 1.0, -1.0);
                break;
            case UIImageOrientationLeftMirrored:
                CGContextTranslateCTM(context, size.width, size.height);
                CGContextScaleCTM(context, -1.0, 1.0);
                CGContextRotateCTM(context, M_PI_2);
                break;
            case UIImageOrientationRightMirrored:
                CGContextTranslateCTM(context, 0, 0);
                CGContextScaleCTM(context, -1.0, 1.0);
                CGContextRotateCTM(context, -M_PI_2);
                break;
            default:
                break;
        }
        
        // Preserve aspect ratio when drawing
        CGRect drawRect = AVMakeRectWithAspectRatioInsideRect(image.size, CGRectMake(0, 0, size.width, size.height));
        CGContextDrawImage(context, drawRect, image.CGImage);
        
        CGContextRelease(context);
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        
        return pixelBuffer;
    }
}




- (void)addAudioFilesAtPath:(NSArray*)audioInfoArray
                  usingMode:(BOOL)serialMixing
              toVideoAtPath:(NSString*)videoPath
        outputToFileAtApath:(NSString*)outputPath
               onCompletion:(void (^)(BOOL status))completion
{
    //  NSAutoreleasePool *pool = [NSAutoreleasePool new];
    @autoreleasepool {
        CMTime                videoClipStartTime = kCMTimeZero;
        CMTime                audioStartTime = kCMTimeZero;
        AVMutableComposition *mixComposition = [AVMutableComposition composition];
        NSURL                *video_inputFileUrl = [NSURL fileURLWithPath:videoPath];
        NSURL                *outputFileUrl = [NSURL fileURLWithPath:outputPath];
        float                 kRecordingFPS = 30.0;
        int                   audioFileCount = 0;
        double                 videoDuration = 0;
        
        /* delete if the putput file already exists */
        if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
        }
        
        //Add video Assets to the composition
        AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
        CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
        AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        NSArray *videoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        if (videoTracks.count > 0) {
            AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
            [a_compositionVideoTrack insertTimeRange:video_timeRange
                                             ofTrack:videoTrack
                                              atTime:videoClipStartTime
                                               error:nil];
        } else {
            NSLog(@"Error: No video track found in the video asset");
            if (completion) {
                completion(NO);
            }
            return;
        }
        
        videoDuration = CMTimeGetSeconds(videoAsset.duration);
        //add audio assets to the composition
        for (NSDictionary * audInfo in audioInfoArray)
        {
            NSURL *audioUrl = [audInfo objectForKey:@"audioFilePath"];
            AVURLAsset * urlAsset = [AVURLAsset URLAssetWithURL:audioUrl
                                                        options:nil];
            NSArray *tracks = [urlAsset tracksWithMediaType:AVMediaTypeAudio];
            audioFileCount = audioFileCount + 1;
            double audioDuration = [[audInfo objectForKey:@"audioDuration"] doubleValue];
            
            if(audioDuration > videoDuration)
            {
                audioDuration = videoDuration;
            }
            if(nil == tracks)
            {
                
                if (isSequentialPlay) {
                    CMTime audioAssetDuration = CMTimeMake((int) (audioDuration * kRecordingFPS), kRecordingFPS);
                    audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
                }
                continue;
            }
            
            if((nil != tracks)&&(0 == tracks.count))
            {
                
                if (isSequentialPlay) {
                    CMTime audioAssetDuration = CMTimeMake((int) (audioDuration * kRecordingFPS), kRecordingFPS);
                    audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
                }
                continue;
            }
            
            
            AVAssetTrack * audioAssetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
            if(audioAssetTrack != nil)
                NSLog(@"Audio is nil");
            
            AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                           preferredTrackID: kCMPersistentTrackID_Invalid];
            CMTime audioAssetDuration = CMTimeMake((int) (audioDuration * kRecordingFPS), kRecordingFPS);
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetDuration) ofTrack:audioAssetTrack atTime:audioStartTime error:nil];
            
            if(serialMixing)
            {
                audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
            }
        }
        
        AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        _assetExport.outputFileType = @"com.apple.quicktime-movie";
        _assetExport.outputURL = outputFileUrl;
        
        // [pool release];
        [_assetExport exportAsynchronouslyWithCompletionHandler:
         ^(void ) {
            
            if(nil != completion)
            {
                completion(YES);
            }
        }];
    }
}

- (float) getRenderSize
{
    //    @autoreleasepool {
    //        float renderSize;
    //        if (sess.frame.frame.size.width >= 700.0) {
    //            renderSize = 656.0;
    //        }else{
    //            renderSize = 639.0; //Original code
    //        }
    //
    //        float videoSettingSize = 640.0;
    //        int maxTries = 10;
    //        for(int photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
    //        {
    //            Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
    //
    //            UIImage *image;
    //            if(effectsApplied)
    //                image = [sess getEffectVideoFrameAtIndex:0 forPhoto:photoIndex];
    //            else
    //                image = [sess getVideoFrameAtIndex:0 forPhoto:photoIndex];
    //            if(nil != image)
    //            {
    //                pht.view.imageView.image = image;
    //            }
    //        }
    //
    //        /* render current frame */
    //        UIImage *img = [sess.frame renderToImageOfSize:CGSizeMake(640, 640)];
    //       // UIImage *img = [sess.frame quickRenderToImageOfSize:CGSizeMake(renderSize, renderSize)];
    //        if(img.size.width == videoSettingSize)
    //        {
    //            return 639.0;
    //        }
    //        else if(img.size.width < videoSettingSize)
    //        {
    //            for(int index = 0; index < maxTries;index++)
    //            {
    //                img = [sess.frame quickRenderToImageOfSize:CGSizeMake(renderSize+index, renderSize+index)];
    //                if(img.size.width == videoSettingSize)
    //                {
    //                    renderSize = renderSize+index;
    //                    break;
    //                }
    //            }
    //        }
    //        else
    //        {
    //            for(int index = 0; index < maxTries;index++)
    //            {
    //                img = [sess.frame quickRenderToImageOfSize:CGSizeMake(renderSize-index, renderSize-index)];
    //                if(img.size.width == videoSettingSize)
    //                {
    //                    renderSize = renderSize+index;
    //                    break;
    //                }
    //            }
    //        }
    //
    //        return renderSize;
    //    }
    return 720;
}


//-(void)CreateCollageVideo
//{
//    for(int index = 0; index < sess.frame.photoCount; index++)
//    {
//        NSURL *videoUrl = [sess getVideoUrlForPhotoAtIndex:[NSNumber numberWithInt:index].intValue];
//        [self.videoArray addObject:videoUrl];
//    }
////    dispatch_async(dispatch_get_main_queue(), ^{
////        [self addprogressBarWithMsg:@"Generating Video"];
////    });
//    NSLog(@"videos count %lu",self.videoArray.count);
//    AVMutableComposition *composition = [AVMutableComposition composition];
//    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
//    NSMutableArray *layerInstructions = [NSMutableArray array];
//
//    NSArray *layoutFrames = @[
//        [NSValue valueWithCGRect:CGRectMake(0, 0, 300, 150)],   // top
//        [NSValue valueWithCGRect:CGRectMake(0, 150, 300, 150)]   // bottom
//    ];
//
//    CMTime maxDuration = kCMTimeZero;
//
//    for (int i = 0; i < self.videoArray.count; i++) {
//        NSURL *videoURL = self.videoArray[i];
//        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:@{ AVURLAssetPreferPreciseDurationAndTimingKey: @YES }];
//        AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
//
//        AVMutableCompositionTrack *compTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//        [compTrack insertTimeRange:timeRange ofTrack:videoTrack atTime:kCMTimeZero error:nil];
//
//        // Layout positioning
//        CGRect layout = [layoutFrames[i] CGRectValue];
//        CGSize naturalSize = videoTrack.naturalSize;
//        CGFloat scaleX = layout.size.width / naturalSize.width;
//        CGFloat scaleY = layout.size.height / naturalSize.height;
//
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        transform = CGAffineTransformScale(transform, scaleX, scaleY);
//        transform = CGAffineTransformTranslate(transform, layout.origin.x / scaleX, layout.origin.y / scaleY);
//
//        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compTrack];
//        [layerInstruction setTransform:transform atTime:kCMTimeZero];
//        [layerInstructions addObject:layerInstruction];
//
//        if (CMTimeCompare(asset.duration, maxDuration) > 0) {
//            maxDuration = asset.duration;
//        }
//    }
//
//    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, maxDuration);
//    instruction.layerInstructions = [[layerInstructions reverseObjectEnumerator] allObjects]; // top = last
//
//    videoComposition.instructions = @[instruction];
//    videoComposition.renderSize = CGSizeMake(300, 300);
//    videoComposition.frameDuration = CMTimeMake(1, 30);
//
//    ///Video export to a file
//    NSString *outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"output.mp4"];
//    [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
//
//    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetPassthrough];
//
//    //NSString *currentVideoPath = [sess pathToCurrentVideo];
//    exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
//
//   // exportSession.outputURL = [NSURL fileURLWithPath:currentVideoPath];
//    exportSession.outputFileType = AVFileTypeMPEG4;
//    exportSession.videoComposition = videoComposition;
//    NSLog(@"Supported types: %@", exportSession.supportedFileTypes);
//
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
////        dispatch_async(dispatch_get_main_queue(), ^{
////            [self removeProgressBar];
////        });
//        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
//            NSLog(@"Export success: %@", outputPath);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self allocateShareResources];
//                    });
//
//        } else {
//            NSLog(@"Export failed: %@", exportSession.error);
//        }
//    }];
//}




- (void)continueGenerateVideo:(void (^)(BOOL status, NSString *videoPath))completion
{
    @autoreleasepool {
        NSLog(@"applicationSuspended************");
        NSString *interVideoPath = [sess pathToIntermediateVideo];
        NSString *currentVideoPath = [sess pathToCurrentVideo];
        AVAssetWriterInputPixelBufferAdaptor *adaptor = nil;
        float __block renderSize;
        dispatch_async(dispatch_get_main_queue(), ^{
            renderSize = [self getRenderSize];
        });
        /* check if we already have a generated video, if yes, no need to generate it again */
        if(YES == [[NSFileManager defaultManager]fileExistsAtPath:interVideoPath])
        {
            [[NSFileManager defaultManager]removeItemAtPath:interVideoPath error:nil];
        }
        
        NSLog(@"continue video generation frame Is Edited is %@",frameIsEdited?@"Yes":@"NO");
        if(YES == [[NSFileManager defaultManager]fileExistsAtPath:currentVideoPath] && !frameIsEdited)
        {
            if(nil != completion)
            {
                completion(YES,currentVideoPath);
            }
            
            return;
        }
        else if(YES == [[NSFileManager defaultManager]fileExistsAtPath:currentVideoPath] && frameIsEdited)
        {
            [[NSFileManager defaultManager]removeItemAtPath:currentVideoPath error:nil];
        }
        
        /* Setup the writer */
        //   NSAutoreleasePool *bpool = [NSAutoreleasePool new];
        NSError *error = nil;
        AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:interVideoPath]
                                                               fileType:AVFileTypeQuickTimeMovie
                                                                  error:&error];
        NSParameterAssert(videoWriter);
        
        NSDictionary *videoSettings     = [self getVideoSettings];
        AVAssetWriterInput* writerInput = [AVAssetWriterInput
                                           assetWriterInputWithMediaType:AVMediaTypeVideo
                                           outputSettings:videoSettings];// retain];
        writerInput.expectsMediaDataInRealTime = NO;
        
        adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                   sourcePixelBufferAttributes:nil];
        NSParameterAssert(writerInput);
        NSParameterAssert([videoWriter canAddInput:writerInput]);
        [videoWriter addInput:writerInput];
        
        //Start a session:
        [videoWriter startWriting];
        [videoWriter startSessionAtSourceTime:kCMTimeZero];
        
        /* Find number of iterations that we need to make to generate video
         it is going to be the photo with maximum number of frames */
        int frameCount = [sess getFrameCountOfFrame:sess.frame];
        NSLog(@"before Frames Count is %d",frameCount);
        int frameIndex = 0;
        int photoIndex = 0;
        
        int counter_Variable= 0;
        int currentPhotoIndex = 0;
        int currentFrameIndex = 0;
        [sess enterNoTouchMode];
        
        int totalNumberOfFrames = 0;
        
        for (int i = 0; i < sess.frame.photoCount; i++)
        {
            totalNumberOfFrames = totalNumberOfFrames + [sess getFrameCountForPhotoAtIndex:i];
        }
        if (isSequentialPlay == TRUE) {
            frameCount = totalNumberOfFrames;
        }
        NSLog(@"after Frames Count is %d",frameCount);
        
        gTotalPreviewFrames = [sess getFrameCountOfFrame:sess.frame];
        if (isSequentialPlay)
        {
            gTotalPreviewFrames = totalNumberOfFrames;
        }
        
        /* we couldn't find the existing video, so lets generate one by ourself */
        for(frameIndex = 0; frameIndex < frameCount; frameIndex++)
        {
            
            //NSAutoreleasePool *pool = [NSAutoreleasePool new];
            @autoreleasepool {
                if (isSequentialPlay)
                {
                    if (counter_Variable>= sess.frame.photoCount) {
                        break;
                    }
                    
                    if (frameIndex ==0)
                    {
                        //initialize the frame
                        for(photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
                        {
                            @autoreleasepool {
                                Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
                                NSLog(@"Continue video generation 1 ==== single frame frame index = %d frame Count = %d current PhotoIndex = %d ",frameIndex,frameCount ,currentPhotoIndex );
                                UIImage *image;
                                if(effectsApplied)
                                    image = [sess getEffectVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
                                else
                                    image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
                                
                                if(nil != image)
                                {
                                    //dispatch_async
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                        pht.view.imageView.image = image;
                                    });
                                }
                                image = nil;
                            }
                        }
                    }else
                    {
                        @autoreleasepool {
                            if ([orderArrayForVideoItems count]==0)
                            {
                                /* if video order is not set , set them to default oreder*/
                                [self setTheDefaultOrderArray];
                            }
                            
                            
                            NSNumber *number =[orderArrayForVideoItems objectAtIndex:counter_Variable];
                            currentPhotoIndex = number.intValue;
                            gCurPreviewFrameIndex = frameIndex;
                            Photo  *pht= [sess.frame getPhotoAtIndex:currentPhotoIndex];
                            UIImage *image;
                            NSLog(@"Continue video generation 2 ==== single frame frame index = %d frame Count = %d current PhotoIndex = %d ",frameIndex,frameCount ,currentPhotoIndex );
                            if(effectsApplied)
                                image = [sess getEffectVideoFrameAtIndex:currentFrameIndex forPhoto:currentPhotoIndex];
                            else
                                image = [sess getVideoFrameAtIndex:currentFrameIndex forPhoto:currentPhotoIndex];
                            if(nil != image)
                            {
                                //dispatch_async
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    pht.view.imageView.image = image;
                                });
                                image = nil;
                            }else
                            {
                                counter_Variable++;
                                currentFrameIndex = 0;
                            }
                            currentFrameIndex++;
                        }
                    }
                }else
                {
                    for(photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
                    {
                        @autoreleasepool {
                            Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
                            NSLog(@"frameCount = %d frameIndex =  %d photoIndex = %d",frameCount,frameIndex,photoIndex);
                            NSLog(@"Continue video generation3 ==== single frame");
                            UIImage *image;
                            if(effectsApplied)
                                image = [sess getEffectVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
                            else
                                image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
                            if(nil != image)
                            {
                                //dispatch_async
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    pht.view.imageView.image = image;
                                });
                            }
                            image = nil;
                        }
                    }
                }
                
                @autoreleasepool {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //    [self ChangeParent:mainBackground :sess.frame];
                        
                        
                        
                        /* render current frame */
                        UIImage *img = [sess.frame renderToImageOfSize:CGSizeMake(renderSize, renderSize)];
                        
                        //UIImage *img = [sess.frame quickRenderToImageOfSize:CGSizeMake(639, 639)];
                        if (!img) {
                            NSLog(@"Rendered image is nil!");
                            return;
                        }
                        // NSLog(@"outter radius is %f",sess.outerRadius);
                        //UIImage *roundedImg = [self imageWithRoundedCorners:img cornerRadius:sess.outerRadius];
                        
                        CVPixelBufferRef buffer = [self pixelBufferFromUIImage:img size:img.size];
                        
                        //                                            UIImage *outputImage = [self imageFromPixelBuffer:buffer];
                        //                                            // Write to file system
                        //                                            NSString *savedPath = [self writeImageToFileSystem:outputImage fileName:@"output_image.png"];
                        //                                            if (savedPath) {
                        //                                             NSLog(@"Image saved at path: %@", savedPath);
                        //                                            } else {
                        //                                           NSLog(@"Failed to save image.");
                        //                                           }
                        if(buffer)
                        {
                            //crash related modify
                            @try {
                                if ([writerInput isReadyForMoreMediaData]) {
                                    [adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frameIndex, 30)];
                                    //                                    CMTime presentationTime = CMTimeMake(frameIndex, maxfps);
                                    //                                    if (CMTIME_IS_NUMERIC(presentationTime)) {
                                    //                                                    [adaptor appendPixelBuffer:buffer withPresentationTime:presentationTime];
                                    //                                                } else {
                                    //                                                    NSLog(@"Invalid CMTime at frame %d", frameIndex);
                                    //                                                }
                                }
                            }
                            @catch (NSException *exception) {}
                            @finally {
                                CVPixelBufferRelease(buffer);
                            }
                        }
                        else {
                            NSLog(@"Buffer creation failed, skipping frame %d", frameIndex);
                        }
                    });
                }
            }
            
            float prg = (float)frameIndex/(float)frameCount;
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:prg] waitUntilDone:YES];
            if(self.applicationSuspended)
            {
                if(nil != completion)
                {
                    completion(NO,nil);
                }
                
                self.applicationSuspended = NO;
                /* restore frame images */
                [sess exitNoTouchMode];
                [self performSelectorOnMainThread:@selector(shoeErrorMessage) withObject:self waitUntilDone:YES];
                return;
            }
        }
        [writerInput markAsFinished];
        [videoWriter endSessionAtSourceTime:CMTimeMake(frameIndex-1, 30)];
        //        CMTime lastpresentationTime = CMTimeMake(frameIndex-1, maxfps);
        //        if (CMTIME_IS_NUMERIC(lastpresentationTime)) {
        //            [videoWriter endSessionAtSourceTime:lastpresentationTime];
        //        }
        
        // [bpool release];
        
        [videoWriter finishWritingWithCompletionHandler:^{
            
            NSLog(@"Status: %ld, Error: %@ disc %@", (long)videoWriter.status, videoWriter.error,videoWriter.error.localizedDescription);
            
            
            //  NSAutoreleasePool *bpool = [NSAutoreleasePool new];
            @autoreleasepool {
                /* Mix audio */
                NSMutableArray *audioFiles = [[NSMutableArray alloc]initWithCapacity:1];
                BOOL useLibraryAudio = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY]boolValue];
                BOOL librarayAudioValid = NO;
                if(useLibraryAudio)
                {
                    NSNumber *persistentId = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
                    MPMediaItem *mItem = [self getMediaItemFromMediaItemId:persistentId];
                    if(nil != mItem)
                    {
                        NSURL *audioUrl = [mItem valueForProperty:MPMediaItemPropertyAssetURL];
                        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
                        double duration = CMTimeGetSeconds( songAsset.duration);
                        songAsset = nil;
                        NSArray *objs = [NSArray arrayWithObjects:audioUrl,[NSNumber numberWithDouble:duration], nil];
                        NSArray *keys = [NSArray arrayWithObjects:@"audioFilePath",@"audioDuration", nil];
                        NSDictionary *dict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
                        [audioFiles addObject:dict];
                        audioUrl = nil;
                        dict = nil;
                        mItem = nil;
                        persistentId = nil;
                        objs = nil;
                        keys=nil;
                        librarayAudioValid = YES;
                        
                    }
                }
                
                if(NO == librarayAudioValid)
                {
                    int tempIndex = 0;
                    for(int index = 0; index < sess.frame.photoCount; index++)
                    {
                        NSNumber *videoNumber = [NSNumber numberWithInt:index];
                        if (isSequentialPlay)
                        {
                            if (tempIndex < [orderArrayForVideoItems count])
                            {
                                videoNumber = [orderArrayForVideoItems objectAtIndex:tempIndex];
                                
                            }else
                            {
                                continue;
                            }
                        }
                        if (isSequentialPlay) {
                            tempIndex++;
                        }
                        NSURL *audioUrl = [sess getVideoUrlForPhotoAtIndex:videoNumber.intValue];
                        if(nil == audioUrl)
                        {
                            continue;
                        }
                        
                        double duration = [sess getVideoDurationForPhotoAtIndex:videoNumber.intValue];
                        if(duration == 0.0)
                        {
                            continue;
                        }
                        
                        NSArray *objs = [NSArray arrayWithObjects:audioUrl,[NSNumber numberWithDouble:duration], nil];
                        NSArray *keys = [NSArray arrayWithObjects:@"audioFilePath",@"audioDuration", nil];
                        NSDictionary *dict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
                        [audioFiles addObject:dict];
                        objs = nil;
                        keys = nil;
                        dict = nil;
                        audioUrl = nil;
                        videoNumber = nil;
                    }
                }
                //  [bpool release];
                
                if(self.applicationSuspended)
                {
                    NSLog(@"application suspended.....");
                    if(nil != completion)
                    {
                        completion(NO,nil);
                    }
                    
                    self.applicationSuspended = NO;
                    
                    
                    /* restore frame images */
                    [sess exitNoTouchMode];
                    
                    
                    [WCAlertView showAlertWithTitle:@"Failed"
                                            message:@"Failed to generate video. Application is interrupted while generating video, please do not close/interrupt the application while generating video"
                                 customizationBlock:nil
                                    completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
                     {
                        //                        [customTabBar unselectCurrentSelectedTab];
                    }
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
                    return;
                }
                __weak typeof(self) weakSelf = self;
                [weakSelf addAudioFilesAtPath:audioFiles usingMode:isSequentialPlay toVideoAtPath:interVideoPath outputToFileAtApath:currentVideoPath onCompletion:^(BOOL status) {
                    typeof(weakSelf) strongSelf = weakSelf;
                    if (!strongSelf) return; // Exit if strongSelf is nil (self has been deallocated)
                    if(nil != completion)
                    {
                        completion(status,currentVideoPath);
                    }
                    
                    /* restore frame images */
                    //[sess exitNoTouchMode];
                    [strongSelf sessionExitNoTouchMode];
                }];
                audioFiles = nil;
            }
        }];
        
        return;
        
    }
}


- (NSString *)writeImageToFileSystem:(UIImage *)image fileName:(NSString *)fileName {
    // Get the path for Documents directory
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // Create the file path
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    // Convert UIImage to NSData (JPEG or PNG format)
    NSData *imageData = UIImagePNGRepresentation(image);  // PNG format
    // NSData *imageData = UIImageJPEGRepresentation(image, 0.8);  // JPEG format with 80% quality
    
    if ([imageData writeToFile:filePath atomically:YES]) {
        NSLog(@"✅ Image successfully saved at %@", filePath);
        return filePath;
    } else {
        NSLog(@"❌ Failed to save image.");
        return nil;
    }
}

- (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:ciImage fromRect:ciImage.extent];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return image;
}

- (UIImage *)imageWithRoundedCorners:(UIImage *)image cornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [image drawInRect:rect];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}


-(void)sessionExitNoTouchMode
{
    [sess exitNoTouchMode];
}

-(void)shoeErrorMessage
{
    [WCAlertView showAlertWithTitle:@"Failed"
                            message:@"Failed to generate video. Application is interrupted while generating video, please do not close/interrupt the application while generating video"
                 customizationBlock:nil
                    completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
     {
        // [customTabBar unselectCurrentSelectedTab];
    }
                  cancelButtonTitle:@"OK"
                  otherButtonTitles:nil];
}

-(NSURL*)createVideoCopyFromReferenceUrl:(NSURL*)inputUrlFromVideoPicker{
    
    NSURL __block *videoURL;
    // Fetch the asset using PHFetchResult
    PHFetchResult *assets = [PHAsset fetchAssetsWithOptions:nil];
    NSLog(@"1----------");
    // Access the first asset if it exists
    PHAsset *phAsset = assets.firstObject;
    NSLog(@"2----------");
    
    //        PHFetchResult *phAssetFetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[inputUrlFromVideoPicker] options:nil];
    //        NSLog(@"1----------");
    //        PHAsset *phAsset = [phAssetFetchResult firstObject];
    //        NSLog(@"2----------");
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    NSLog(@"3----------");
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:nil resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
        NSLog(@"4----------");
        
        if ([asset isKindOfClass:[AVURLAsset class]]) {
            
            NSLog(@"5----------");
            NSURL *url = [(AVURLAsset *)asset URL];
            
            NSLog(@"Final URL %@",url);
            NSData *videoData = [NSData dataWithContentsOfURL:url];
            
            // optionally, write the video to the temp directory
            NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.mp4",[NSDate timeIntervalSinceReferenceDate]]];
            
            videoURL = [NSURL fileURLWithPath:videoPath];
            BOOL writeResult = [videoData writeToURL:videoURL atomically:true];
            
            if(writeResult) {
                NSLog(@"video success");
            }
            else {
                NSLog(@"video failure");
            }
            dispatch_group_leave(group);
            // use URL to get file content
        }
    }];
    dispatch_group_wait(group,  DISPATCH_TIME_FOREVER);
    return videoURL;
}


- (BOOL)isTimelapseVideoTrack:(NSURL *)video_URL
{
    // 2. Prepare video asset
    AVAsset *videoAsset = [AVAsset assetWithURL:video_URL];
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    for (AVMetadataItem *item in videoTrack.metadata) {
        if ([item.identifier isEqualToString:@"mdta/com.apple.photos.captureMode"] ||
            ([item.key isKindOfClass:[NSString class]] &&
             [((NSString *)item.key) isEqualToString:@"com.apple.photos.captureMode"])) {
            
            NSString *captureMode = (NSString *)item.value;
            NSLog(@"Capture Mode: %@", captureMode);
            
            if ([captureMode isEqualToString:@"Time-lapse"]) {
                return YES;
            } else {
                return NO;
            }
        }
    }
    return NO;
}


- (void)showTimelapseWarningAlert {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Timelapse Detected"
                                    message:@"Playback of timelapse videos may not work optimally in this app."
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * _Nonnull action) {
            doNotTouch = NO;
            isTouchWillDetect = YES;
            [sess exitNoTouchMode];
            dontShowOptionsUntilOldAssetsSaved = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self enableLeftBarButtonItem];
            });
            return;
        }];
        
        [alert addAction:cancel];
        
        // Present on topmost view controller
        UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        
        [topController presentViewController:alert animated:YES completion:nil];
    });
}



#pragma mark end saving video frames to HDD
#pragma mark video import
- (void)importVideo:(NSTimer *)timer
{
    isTouchWillDetect = NO;
    doNotTouch = YES;
    [sess enterNoTouchMode];
    [sess deleteVideoAtPhototIndex:sess.photoNumberOfCurrentSelectedPhoto];
    [sess deleteEffectVideoAtPhototIndex:sess.photoNumberOfCurrentSelectedPhoto];
    dontShowOptionsUntilOldAssetsSaved = YES;
    @autoreleasepool {
        [self disableLeftBarButtonItem];
        //isVideoOrderChangedByUser = NO;
        if (orderArrayForVideoItems != nil && [orderArrayForVideoItems count]>0) {
            [self.orderArrayForVideoItems removeAllObjects];
        }
        
        NSURL *videoURL = [timer.userInfo objectForKey:@"videoPath"];
        
        if([self isTimelapseVideoTrack:videoURL])
        {
            [self showTimelapseWarningAlert];
            return;
        }
        
        if(nil == videoURL)
        {
            NSAssert(nil != videoURL,@"Video path is nil to import");
            NSLog(@"Video path is nil to import----%@",videoURL);
        }
        NSLog(@"import Video:%@",videoURL);
        [self performSelectorOnMainThread:@selector(addprogressBarWithMsg:) withObject:@"Importing Video" waitUntilDone:YES];
        
        
        [sess saveVideoToDocDirectory:videoURL completion:^(NSString *localVideoPath)  {
            NSLog(@"inside-----1");
            // [self performSelectorOnMainThread:@selector(addprogressBarWithMsg:) withObject:@"Prepairing to import" waitUntilDone:YES];
            //  [self performSelectorOnMainThread:@selector(addprogressBarWithMsg:) withObject:@"Importing Video" waitUntilDone:YES];
            NSLog(@"save Video To Doc Directory inside-----2 local Video Path %@ videoURL %@",localVideoPath,videoURL);
            // To collage directly the video instead of frames extracting
            //            if (localVideoPath) {
            //                    [self.videoArray addObject:[NSURL URLWithString:localVideoPath]];
            //                }
            
            
            // NSString *localPath = [localVideoPath retain];
            /* Initialize AVImage Generator */
            //      AVAsset *asset = [AVAsset assetWithURL:videoURL];
            //      NSLog(@"tracks with AVAssets URL is  %lu",(unsigned long)asset.tracks.count);
            //            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:videoSaveprogress] waitUntilDone:YES];
            AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
            NSLog(@"tracks After getting URL is  %lu",(unsigned long)inputAsset.tracks.count);
            [self clearCurImage];
            NSLog(@"input asset is %@",inputAsset);
            [inputAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"]completionHandler: ^{
                NSLog(@"input asset %%%% %@",inputAsset);
                //  [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                //                [self performSelectorOnMainThread:@selector(addprogressBarWithMsg:) withObject:@"Importing Video" waitUntilDone:YES];
                NSLog(@"tracks count is %lu",(unsigned long)inputAsset.tracks.count);
                NSLog(@"track is %@",inputAsset);
                //here is the problem
                @autoreleasepool {
                    [self saveVideoFramesToHDD:inputAsset onCompletion:^(BOOL status, NSMutableDictionary *videoInfo){
                        [sess enterNoTouchMode];
                        if (inputAsset.tracks.count<1) {
                            
                            NSLog(@"Tracks count is nil----");
                        }
                        NSLog(@"track is----2 %@",inputAsset);
                        if(status == YES)
                        {
                            NSLog(@"track is----3 %@",inputAsset);
                            
                            NSLog(@"save hdd video Info dictionary: %@", videoInfo);
                            NSLog(@"save Video Frames To HDD video FrameCount is---- %@",[videoInfo objectForKey:@"FrameCount"]);
                            NSLog(@"save Video Frames To HDD video VideoFrameIndex is---- %@",[videoInfo objectForKey:@"VideoFrameIndex"]);
                            NSLog(@"save Video Frames To HDD video is---- Duration %@",[videoInfo objectForKey:@"Duration"]);
                            NSLog(@"save Video Frames To HDD video is---- Fps %@",[videoInfo objectForKey:@"Fps"]);
                            
                            
                            isTouchWillDetect = YES;
                            doNotTouch = NO;
                            [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                            NSLog(@"path for the image is %@",[sess pathForImageAtIndex:0 inPhoto:currentClickedPhotoFrameNumber]);
                            /* Get the first image */
                            UIImage *img = [UIImage imageWithContentsOfFile:[sess pathForImageAtIndex:0 inPhoto:currentClickedPhotoFrameNumber]];
                            [sess enterNoTouchMode];
                            NSLog(@"info ---- > img size width %f height %f ",img.size.width,img.size.height);
                            @autoreleasepool {
                                NSAssert(nil != img, @"Image in Video is nil, looks like video parsing went wrong");
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self enableLeftBarButtonItem];
                                });
                                NSURL *url = [NSURL fileURLWithPath:localVideoPath];
                                [videoInfo setObject:url forKey:@"videoPath"];
                                //                    [videoInfo setObject:img forKey:@"image"];
                                NSDictionary *info = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:img,videoInfo, nil]
                                                                                 forKeys:[NSArray arrayWithObjects:@"image",@"videoInfo", nil]];
                                [self performSelectorOnMainThread:@selector(handleVideoSelectionWithInfo:) withObject:info waitUntilDone:NO];
                            }
                        }
                        else
                        {
                            doNotTouch = NO;
                            isTouchWillDetect = YES;
                            [sess exitNoTouchMode];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self enableLeftBarButtonItem];
                            });
                            NSLog(@"track is----Else part %@",inputAsset);
                        }
                        
                    }];
                }
            }];
        } progress:^(float progress) {
            [self updateProgress:@(progress * videoSaveprogress)];
        }];
        return;
    }
}


- (void)generateVideo:(void (^)(BOOL status,NSString *videoPath))complete
{
    // @autoreleasepool {
    [self disableLeftBarButtonItem];
    //[[configparser Instance] badgeAdUserInteractionDisable];
    //crash related commented
    generatingVideo = YES;
    
    BOOL optOutVideoHelp = [[[NSUserDefaults standardUserDefaults]objectForKey:@"optOutVideoGenerationHelp"]boolValue];
    
    self.applicationSuspended = NO;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES]; //uncomment again
    
    if(NO == optOutVideoHelp)
    {
        NSLog(@"Ok pressed....");
        [self settingTouchViewHide];
        [WCAlertView showAlertWithTitle:@"Info"
                                message:@"Please do not close the application while generating video, On doing so Video generation will fail!!"
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
         {
            isTouchWillDetect = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addprogressBarWithMsg:@"Generating Video"];
            });
            if(buttonIndex == 1)
            {
                
                //TouchViewHide//
                [self settingTouchViewHide];
                NSLog(@"Got it pressed....&&&");
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:@"optOutVideoGenerationHelp"];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self continueGenerateVideo:^(BOOL status, NSString *videoPath) {
                    NSLog(@"Completed generating video with Status %d path %@",status,videoPath);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self enableLeftBarButtonItem];
                    });
                    [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//uncomment again
                    });
                    isTouchWillDetect = YES;
                    //  [[configparser Instance] badgeAdUserInteractionEnable];
                    // crash related commented
                    if(nil != complete)
                    {
                        complete(status,videoPath);
                    }
                }];
            });
        }
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:@"Got It",nil];
    }
    else
    {
        isTouchWillDetect = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addprogressBarWithMsg:@"Generating Video"];
        });
        //TouchViewHide//
        [self settingTouchViewHide];
        NSLog(@"Got it pressed....");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                [self continueGenerateVideo:^(BOOL status, NSString *videoPath) {
                    NSLog(@"Completed generating video with Status %d path %@",status,videoPath);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self enableLeftBarButtonItem];
                    });
                    [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                    });
                    isTouchWillDetect = YES;
                    //uncomment again
                    if(nil != complete)
                    {
                        complete(status,videoPath);
                    }
                }];
            }
        });
    }
    //    }
}

- (void)generateAudioOfVideoFrame:(void (^)(BOOL status, NSString *audioPath))completion
{
    //  NSAutoreleasePool *bpool = [NSAutoreleasePool new];
    @autoreleasepool {
        CMTime                audioStartTime = kCMTimeZero;
        int                   audioFileCount = 0;
        float                  kRecordingFPS = 30.0;
        BOOL                    serialMixing = isSequentialPlay;
        AVMutableComposition *mixComposition = [AVMutableComposition composition];
        BOOL userMusicEnabled = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY]boolValue];
        BOOL userMusicIsValid = NO;
        
        if(userMusicEnabled)
        {
            NSLog(@"Deleting current audio mix");
            [sess deleteCurrentAudioMix];
            NSLog(@"after pick deleting-----2");
            //audio is deleting here//
        }
        
        NSString *audioPath = [sess pathToCurrentAudioMix];
        if([[NSFileManager defaultManager]fileExistsAtPath:audioPath])
        {
            NSAssert(userMusicEnabled == NO, @"Failed to delete audio mix in above step");
            NSLog(@"No Need to mix Audio, Mixed file already exists");
            dispatch_async(dispatch_get_main_queue(), ^{
                if(nil != completion)
                {
                    completion(YES,audioPath);
                }});
            // [bpool release];
            return;
        }
        
        if(userMusicEnabled)
        {
            NSNumber *persistentId = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
            NSURL *audioUrl        = [self getUrlFromMediaItemId:persistentId];
            AVURLAsset *urlAsset   = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
            NSArray      *tracks   = [urlAsset tracksWithMediaType:AVMediaTypeAudio];
            double duration        = CMTimeGetSeconds( urlAsset.duration);
            
            if((nil != tracks)&&(0 != tracks.count))
            {
                audioFileCount++;
                
                double maxVideoDuration = [sess getMaxVideoDuration:isSequentialPlay];
                
                if(duration > maxVideoDuration)
                {
                    duration = maxVideoDuration;
                }
                if (isSequentialPlay== TRUE) {
                    duration = maxVideoDuration;
                }
                
                NSLog(@" maximum duration :%f",duration);
                AVAssetTrack * audioAssetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
                AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID: kCMPersistentTrackID_Invalid];
                CMTime audioAssetDuration = CMTimeMake((int) (duration * kRecordingFPS), kRecordingFPS);
                [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetDuration) ofTrack:audioAssetTrack atTime:audioStartTime error:nil];
                
                userMusicIsValid = YES;
            }
        }
        
        if(NO == userMusicIsValid)
        {
            int tempIndex = 0;
            for(int index = 0; index < sess.frame.photoCount; index++)
            {
                NSLog(@"tempIndex :%d", tempIndex);
                NSNumber *videoNumber = [NSNumber numberWithInt:index];
                if (isSequentialPlay)
                {
                    if (tempIndex < [orderArrayForVideoItems count]) {
                        videoNumber = [orderArrayForVideoItems objectAtIndex:tempIndex];
                    }else
                    {
                        continue;
                    }
                }
                if (isSequentialPlay) {
                    tempIndex++;
                }
                
                NSURL *audioUrl = [sess getVideoUrlForPhotoAtIndex:videoNumber.intValue];
                if(nil == audioUrl)
                {
                    continue;
                }
                
                double duration = [sess getVideoDurationForPhotoAtIndex:videoNumber.intValue];
                if(duration == 0.0)
                {
                    continue;
                }
                
                AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
                NSArray      *tracks = [urlAsset tracksWithMediaType:AVMediaTypeAudio];
                audioFileCount++;
                if(nil == tracks)
                {
                    //tempIndex++;
                    CMTime audioAssetDuration = CMTimeMake((int) (duration * kRecordingFPS), kRecordingFPS);
                    if (serialMixing) {
                        audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
                    }
                    NSLog(@"Audio Tracks doesn't exist 1");
                    continue;
                }
                
                if((nil != tracks)&&(0 == tracks.count))
                {
                    // tempIndex++;
                    CMTime audioAssetDuration = CMTimeMake((int) (duration * kRecordingFPS), kRecordingFPS);
                    if (serialMixing) {
                        audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
                    }
                    NSLog(@"Audio Tracks Doesn't exist 2");
                    continue;
                }
                
                AVAssetTrack * audioAssetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
                AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID: kCMPersistentTrackID_Invalid];
                CMTime audioAssetDuration = CMTimeMake((int) (duration * kRecordingFPS), kRecordingFPS);
                // [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetDuration) ofTrack:audioAssetTrack atTime:audioStartTime error:nil];
                [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetDuration) ofTrack:audioAssetTrack atTime:audioStartTime error:nil];
                
                
                if(serialMixing)
                {
                    // tempIndex++;
                    audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
                }
            }
        }
        
        if(audioFileCount > 0)
        {
            NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
            AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
            _assetExport.outputFileType = AVFileTypeAppleM4A;
            _assetExport.outputURL = audioUrl;
            
            [_assetExport exportAsynchronouslyWithCompletionHandler:
             ^(void ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(_assetExport.status != AVAssetExportSessionStatusCompleted)
                    {
                        if(nil != completion)
                        {
                            completion(NO,nil);
                        }
                    }
                    else
                    {
                        if(nil != completion)
                        {
                            completion(YES,audioPath);
                        }
                    }
                });
                
            }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(nil != completion)
                {
                    completion(YES,nil);
                }
            });
        }
    }
    //  [bpool release];
}

- (void)addWaterMarkToFrame
{
    NSLog(@"add watermark to frame");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(sess != nil && ![[SRSubscriptionModel shareKit]IsAppSubscribed])
        {
            UIView * water_MarkView;
            water_MarkView = (UIView*)[self.view viewWithTag:TAG_WATERMARKPARENT_View];
            if(water_MarkView == nil)
            {
                water_MarkView = [[UIView alloc]initWithFrame:sess.frame.frame];
            }
            water_MarkView.frame = sess.frame.frame;
            water_MarkView.tag = TAG_WATERMARKPARENT_View;
            water_MarkView.backgroundColor = [UIColor clearColor];
            water_MarkView.userInteractionEnabled = NO;
            [mainBackground addSubview:water_MarkView];
            [mainBackground bringSubviewToFront:water_MarkView];
            NSLog(@"watermark parent adding %@",water_MarkView);
            NSLog(@"sess rect  %@",NSStringFromCGRect(sess.frame.frame));
            float width = sess.frame.frame.size.width*0.75;
            float height = 50.0;
            CGRect waterMarkRect = CGRectMake(sess.frame.frame.size.width-width, sess.frame.frame.size.height-height, width, height);
            UILabel *waterMark;
            waterMark = (UILabel*)[water_MarkView viewWithTag:TAG_WATERMARK_LABEL];
            waterMark.translatesAutoresizingMaskIntoConstraints = NO;
            NSLog(@"watermark adding %@",waterMark);
            if(nil == waterMark)
            {
                waterMark = [[UILabel alloc]init];//WithFrame:waterMarkRect];
                // Add gesture recognizer
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WaterMarkTapped)];
                [waterMark addGestureRecognizer:tapGesture];
                waterMark.userInteractionEnabled = YES;
            }
            [water_MarkView addSubview:waterMark];
            [waterMark.trailingAnchor constraintEqualToAnchor:water_MarkView.trailingAnchor constant:-10].active = YES;
            NSLog(@"sess frame width is %f",sess.frame.frame.size.width);
            if(waterMarkWidthConstraints != nil)
                waterMarkWidthConstraints.active = NO;
            waterMarkWidthConstraints = [waterMark.widthAnchor constraintEqualToConstant:width];
            waterMarkWidthConstraints.active = YES;
            [waterMark.heightAnchor constraintEqualToConstant:height].active = YES;
            [waterMark.bottomAnchor constraintEqualToAnchor:water_MarkView.bottomAnchor constant:-10].active = YES;
            
            waterMark.adjustsFontSizeToFitWidth = YES;
            //waterMark.frame = waterMarkRect;
            waterMark.backgroundColor = [UIColor clearColor];
            waterMark.tag = TAG_WATERMARK_LABEL;
            waterMark.font = [UIFont boldSystemFontOfSize:13.0];
            waterMark.textAlignment = NSTextAlignmentRight;
            if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
            {
                waterMark.text = @"www.videocollageapp.com";
            }
            else
            {
                waterMark.text = @"";
                waterMark.hidden = YES;
            }
            waterMark.textColor = [UIColor whiteColor];
            
            [mainBackground bringSubviewToFront:waterMark];
        }
    });
}


-(void)BringAllStickersTextviewFront
{
    CGFloat ratio = nvm.wRatio /nvm.hRatio;
    NSLog(@"w ratio = %f h ratio = %f, ratio is %f",nvm.wRatio,nvm.hRatio,ratio);
    for (UIView *subview in mainBackground.subviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview.tag == TAG_STICKERVIEW) {
            [sess.frame bringSubviewToFront:subview];
            NSLog(@"did bring the  sticker view to front ");
        }
    }
    
    for (UIView *textview in self.textBoxes) {
        [sess.frame bringSubviewToFront:textview];
        CGRect newFrame = textview.frame;
        NSLog(@"textview container old frame is %@",NSStringFromCGRect(newFrame));
    }
    [mainBackground bringSubviewToFront:self.fontSizeSlider];
}

-(void)rePostionStickersfromOldSession:(CGRect)oldSession
                          toNewSession:(CGRect)newSession {
    for (UIView *subview in mainBackground.subviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview.tag == TAG_STICKERVIEW) {
            CGRect oldFrame = subview.frame;
            NSLog(@"old Sticker Frame: %@", NSStringFromCGRect(oldFrame));
            CGRect stickerInNewSession = [self convertStickerFrame:oldFrame
                                                    fromOldSession:oldSession
                                                      toNewSession:newSession];
            
            NSLog(@"New Sticker Frame: %@", NSStringFromCGRect(stickerInNewSession));
            subview.frame = stickerInNewSession;
        }
    }
    for (UIView *textviewContainer in self.textBoxes) {
        CGRect textviewInNewSession = [self convertStickerFrame:textviewContainer.frame
                                                 fromOldSession:oldSession toNewSession:newSession];
        NSLog(@"New Sticker Frame: %@", NSStringFromCGRect(textviewInNewSession));
        textviewContainer.frame = textviewInNewSession;
        
        UITextView *textview = textviewContainer.subviews.firstObject;
        // 1. Calculate scaling ratio between sessions
        CGFloat widthRatio = newSession.size.width / oldSession.size.width;
        CGFloat heightRatio = newSession.size.height / oldSession.size.height;
        //CGFloat scaleFactor = MIN(widthRatio, heightRatio);
        
        CGFloat scaleFactor;
        if(newSession.size.width < newSession.size.height)
            scaleFactor = newSession.size.width/newSession.size.height; //MIN(widthRatio, heightRatio);
        else
            scaleFactor = newSession.size.height/newSession.size.width;
        
        NSLog(@"scaleFactor %f",scaleFactor);
        // 5. Update font size proportionally (optional)
        [self adjustFontSizeForTextView:textview scaleFactor:widthRatio];
        [self applyShapeToActiveTextView];
    }
}


- (void)adjustFontSizeForTextView:(UITextView *)textView scaleFactor:(CGFloat)scaleFactor {
    // Define font size constraints
    static const CGFloat kMinFontSize = 10.0;
    static const CGFloat kMaxFontSize = 50.0;
    
    UIFont *currentFont = textView.font;
    CGFloat newFontSize = currentFont.pointSize * scaleFactor;
    
    // Clamp font size to readable range
    newFontSize = MAX(kMinFontSize, MIN(newFontSize, kMaxFontSize));
    
    if (newFontSize != currentFont.pointSize) {
        textView.font = [UIFont fontWithName:currentFont.fontName size:newFontSize];
    }
    // 4. Force layout update
    [textView layoutIfNeeded];
    
    // 5. Trigger container adjustment (if needed)
    if ([self respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self textViewDidEndEditing:textView];
    }
}





- (CGRect)convertStickerFrame:(CGRect)stickerFrame
               fromOldSession:(CGRect)oldSession
                 toNewSession:(CGRect)newSession {
    
    // 1. Normalize sticker position (0-1 range in old session)
    CGFloat normalizedX = (stickerFrame.origin.x - oldSession.origin.x) / oldSession.size.width;
    CGFloat normalizedY = (stickerFrame.origin.y - oldSession.origin.y) / oldSession.size.height;
    CGFloat normalizedWidth = stickerFrame.size.width / oldSession.size.width;
    CGFloat normalizedHeight = stickerFrame.size.height / oldSession.size.height;
    
    // 2. Scale to new session size
    CGFloat newX = newSession.origin.x + (normalizedX * newSession.size.width);
    CGFloat newY = newSession.origin.y + (normalizedY * newSession.size.height);
    CGFloat newWidth = normalizedWidth * newSession.size.width;
    CGFloat newHeight = normalizedHeight * newSession.size.height;
    
    return CGRectMake(newX, newY, newWidth, newHeight);
}


-(void)AddStickerTOFrame:(UIImage *)image
{
    if(sess != nil)
    {
        frameIsEdited = YES;
        UIImageView *stickerImageView = [[UIImageView alloc]init];
        //  stickerImageView.frame = CGRectMake(sess.frame.frame.origin.x+sess.frame.frame.size.width/2-75, sess.frame.frame.origin.y+sess.frame.frame.size.height/2-75, 200, 200);
        CGFloat sizeOfSticker = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 150 : 90;
        CGFloat padding  = 10;
        
        NSLog(@"sess height is %f",sess.frame.bounds.size.height);
        
        CGFloat minXValue = (fullScreen.size.width - sess.frame.bounds.size.width)/2;
        CGFloat minYValue = sess.frame.bounds.size.height/4; //(fullScreen.size.height - sess.frame.bounds.size.height)/2;
        // Random X position within bounds
        CGFloat newX = minXValue + arc4random_uniform(sess.frame.bounds.size.width - sizeOfSticker )- padding;
        
        // Random Y position within the safe area above the keyboard
        CGFloat newY = minYValue + arc4random_uniform(sess.frame.bounds.size.height*0.35);
        
        stickerImageView.frame =  CGRectMake(newX, newY, sizeOfSticker + padding, sizeOfSticker + padding);//CGRectMake(0,0, sizeOfSticker, sizeOfSticker);
        
        stickerImageView.image = image;
        stickerImageView.backgroundColor = [UIColor clearColor];
        stickerImageView.tag = TAG_STICKERVIEW;
        stickerImageView.userInteractionEnabled = YES;
        stickerImageView.contentMode = UIViewContentModeScaleAspectFit;
        stickerImageView.clipsToBounds = YES;
        // Add gestures
        [self addGesturesToView:stickerImageView];
        [sess.frame addSubview:stickerImageView];//mainBackground
        [self.addedstickes addObject:stickerImageView];
    }
}


- (void)addGesturesToView:(UIImageView *)stickerImageView {
    // Pan Gesture (Drag)
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleStickerPanGesture:)];
    [stickerImageView addGestureRecognizer:panGesture];
    
    // Tap Gesture (Bring to Front)
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [stickerImageView addGestureRecognizer:tapGesture];
    
    // Add rotation gesture
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [stickerImageView addGestureRecognizer:rotationGesture];
    
    //    // Long Press Gesture (Options Menu)
    //    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    //    [stickerImageView addGestureRecognizer:longPressGesture];
    
    // Pinch Gesture (Zoom In/Out)
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [stickerImageView addGestureRecognizer:pinchGesture];
}



// Handle Tap Gesture (Bring to Front)
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    frameIsEdited = YES;
    UIView *stickerView = gesture.view;
    [stickerView.superview bringSubviewToFront:stickerView];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    frameIsEdited = YES;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil  // No title
                                                                       message:nil  // No message
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Delete Option
        [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [gesture.view removeFromSuperview]; // Remove the sticker
        }]];
        
        // Cancel Option
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        
        // Fix for iPad (Popover presentation)
        UIPopoverPresentationController *popover = alert.popoverPresentationController;
        if (popover) {
            popover.sourceView = gesture.view;  // Use the sticker as source
            popover.sourceRect = gesture.view.bounds;  // Center popover on sticker
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        
        // Present the alert
        UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
        [vc presentViewController:alert animated:YES completion:nil];
    }
}



- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture {
    frameIsEdited = YES;
    UIView *stickerView = gesture.view;
    
    // Scale the sticker based on pinch scale
    stickerView.transform = CGAffineTransformScale(stickerView.transform, gesture.scale, gesture.scale);
    
    // Reset scale factor to prevent compounding transformations
    gesture.scale = 1.0;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)gesture {
    NSLog(@"stickerView: handle rotation called ");
    UIView *stickerView = gesture.view;

    // Apply rotation transformation
    stickerView.transform = CGAffineTransformRotate(stickerView.transform, gesture.rotation);

    // Reset the gesture rotation
    gesture.rotation = 0;
}


- (void)resizeSticker:(UIView *)stickerView {
    [UIView animateWithDuration:0.3 animations:^{
        stickerView.transform = CGAffineTransformMakeScale(1.5, 1.5); // Scale up
    }];
}



-(void)WaterMarkTapped
{
    NSLog(@"watermark was tapped!");
    [self ShowSubscriptionView];
}


- (void)removeWaterMarkFromFrame
{
    NSLog(@"remove watermark from frame");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"remove water mark -- removing");
        UIView *  water_MarkView = (UIView*)[self.view viewWithTag:TAG_WATERMARKPARENT_View];
        UILabel *waterMark = (UILabel*)[water_MarkView viewWithTag:TAG_WATERMARK_LABEL];
        if(nil != waterMark)
        {
            [waterMark removeFromSuperview];
        }
        waterMark = nil;
        if(water_MarkView!= nil)
        {
            [water_MarkView removeFromSuperview];
        }
        water_MarkView = nil;
    });
}

- (void)updatePreviewFrame:(NSTimer *)timer
{
    NSLog(@"update preview Frame");
    int frameIndex = gCurPreviewFrameIndex;
    int   photoIndex = initialPhotoIndex;
    if(frameIndex == gTotalPreviewFrames)
    {
        [timer invalidate];
        gIsPreviewInProgress  = NO;
        gCurPreviewFrameIndex = 0;
        gTotalPreviewFrames   = 0;
        gPreviewFrameCounterVariable = 0;
        
        [sess exitNoTouchMode];
        
        [self releaseToolBarIfAny];
        
        UIView *blockTouches = [self.view viewWithTag:TAG_PREVIEW_BLOCKTOUCHES];
        if(nil != blockTouches)
        {
            [blockTouches removeFromSuperview];
        }
        
        if(nil != preViewControls)
        {
            [preViewControls dismissAnimated:NO];
            //  [preViewControls release];
            //   preViewControls = nil;
        }
        
        //        [customTabBar unselectCurrentSelectedTab];
        
        [self selectEditTab];
        
        
        return;
    }
    
    if(gIsPreviewPaused)
    {
        return;
    }
    if (isSequentialPlay) {
        
        Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
        UIImage *image;
        if(effectsApplied)
            image = [sess getEffectVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
        else
            image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
        
        if(nil != image)
        {
            pht.view.imageView.image = image;
        }else
        {
            
            photoIndex++;
            counterVariable++;
            if (counterVariable >= [orderArrayForVideoItems count])
            {
                initialPhotoIndex     = 0;
                gPreviewFrameCounterVariable = 0;
                gCurPreviewFrameIndex = gTotalPreviewFrames;
                counterVariable = 0;
                
                return;
                
            }else
            {
                
                frameIndex = 0;
                NSNumber *number =[orderArrayForVideoItems objectAtIndex:counterVariable];
                initialPhotoIndex = number.intValue;
                gCurPreviewFrameIndex = frameIndex;
                pht= [sess.frame getPhotoAtIndex:initialPhotoIndex];
                
            }
        }
        [previewAdjSlider setValue:gPreviewFrameCounterVariable];
        
        gCurPreviewFrameIndex++;
        gPreviewFrameCounterVariable++;
        
        if(gPreviewFrameCounterVariable == (gPreviewFrameCounterVariable % gTotalPreviewFrames))
        {
            previewTimeLabel.text = [self getCurrentPreviewTime];
            
        }
        
    }else
    {
        for (int photo_Index = 0; photo_Index< sess.frame.photoCount; photo_Index++)
        {
            Photo *pht = [sess.frame getPhotoAtIndex:photo_Index];
            UIImage *image;
            if(effectsApplied)
                image = [sess getEffectVideoFrameAtIndex:frameIndex forPhoto:photo_Index];
            else
                image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photo_Index];
            if(nil != image)
            {
                pht.view.imageView.image = image;
            }
        }
        
        [previewAdjSlider setValue:gCurPreviewFrameIndex];
        gCurPreviewFrameIndex++;
        
        if(gCurPreviewFrameIndex == (gCurPreviewFrameIndex%gTotalPreviewFrames))
        {
            previewTimeLabel.text = [self getCurrentPreviewTime];
        }
    }
}


- (void)playPreviewOfVideoFrame
{
    /* First check if the preview is in progress */
    if(gIsPreviewInProgress == YES)
    {
        NSLog(@"Preview is already in progress");
        return;
    }
    
    gIsPreviewInProgress = YES;
    gIsPreviewPaused = NO;
    
    [sess enterNoTouchMode];
    
    /* Mix audio */
    [self generateAudioOfVideoFrame:^(BOOL status, NSString *audioPath) {
        if(status == YES)
        {
            if(nil != audioPath)
            {
                NSURL *audioUrl1 = [NSURL fileURLWithPath:audioPath];
                previewAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl1 error:NULL];
                previewAudioPlayer.delegate = self;
                [previewAudioPlayer prepareToPlay];
            }
            else
            {
                previewAudioPlayer = nil;
            }
            int totalNumberOfFrames = 0;
            for (int i = 0; i < sess.frame.photoCount; i++)
            {
                totalNumberOfFrames = totalNumberOfFrames + [sess getFrameCountForPhotoAtIndex:i];
                
            }
            counterVariable = 0;
            gTotalPreviewFrames = [sess getFrameCountOfFrame:sess.frame];
            if (isSequentialPlay)
            {
                if ([orderArrayForVideoItems count]==0)
                {
                    [self setTheDefaultOrderArray];
                }
                gTotalPreviewFrames = totalNumberOfFrames;
                NSNumber *value = [orderArrayForVideoItems objectAtIndex:0];
                initialPhotoIndex = value.intValue;
                
            }
            gCurPreviewFrameIndex = 0;
            
            
            NSLog(@"print : %d", initialPhotoIndex);
            /* Started  */
            
            if(NO == gIsPreviewPaused)
            {
                
                [previewAdjSlider setMaximumValue:gTotalPreviewFrames];
                /* start perodic timer to change the frames of the video */
                [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                                 target:self
                                               selector:@selector(updatePreviewFrame:)
                                               userInfo:nil
                                                repeats:YES];
                if(nil != previewAudioPlayer)
                {
                    [previewAudioPlayer play];
                }
                
            }
        }
        else
        {
            gIsPreviewInProgress  = NO;
            gIsPreviewPaused      = NO;
            gTotalPreviewFrames   = 0;
            gCurPreviewFrameIndex = 0;
            
        }
    }];
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // [player release];
    previewAudioPlayer = nil;
}

- (void)previewVideo
{
    [self playPreviewOfVideoFrame];
}

- (void)pausePreView
{
    if(gIsPreviewInProgress)
    {
        if(nil != previewAudioPlayer)
        {
            /* First Pause the audio */
            [previewAudioPlayer pause];
        }
        
        /* Also make sure that we stop frame updates */
        gIsPreviewPaused = YES;
    }
}

- (void)resumePreview
{
    if(gIsPreviewInProgress)
    {
        if(YES == gIsPreviewPaused)
        {
            gIsPreviewPaused = NO;
            
            if(nil != previewAudioPlayer)
            {
                [previewAudioPlayer play];
            }
        }
    }
}

- (void)stopPreview
{
    if(gIsPreviewInProgress)
    {
        /* Below 3 initializtion for serial play not required in ParallelPlay*/
        if (isSequentialPlay) {
            initialPhotoIndex = 0;
            gCurPreviewFrameIndex = 0;
            gTotalPreviewFrames   = 0;
            gPreviewFrameCounterVariable = gTotalPreviewFrames;
        }else
        {
            gCurPreviewFrameIndex = gTotalPreviewFrames;
        }
        
        if (nil != previewAudioPlayer)
        {
            [previewAudioPlayer stop];
            
        }
        
        gIsPreviewInProgress = NO;
    }
}

- (void)handleVideoSelectionWithInfo:(NSDictionary*)info
{
    UIImage *img = [info objectForKey:@"image"];
    NSLog(@"handle Video Selection With Info info ---- > img size width %f height %f ",img.size.width,img.size.height);
    NSDictionary *videoInfo = [info objectForKey:@"videoInfo"];
    [sess videoSelectedForCurrentPhotoWithInfo:videoInfo image:img];
    dontShowOptionsUntilOldAssetsSaved = NO;
    //  [sess exitNoTouchMode];
}

- (void)handleImageSelection:(NSTimer*)timer
{
    NSMutableArray *imageArray =  [timer.userInfo objectForKey:@"imageArray"];
    
    NSMutableArray *arrayOfEmptyIndex = [[NSMutableArray alloc] init];
    [arrayOfEmptyIndex addObject:[NSNumber numberWithInt:sess.photoNumberOfCurrentSelectedPhoto]];
    
    for (int i = 0; i< sess.frame.photoCount; i++)
    {
        if (i == sess.photoNumberOfCurrentSelectedPhoto)
        {
            continue;
        }
        else
        {
            Photo *pht = [sess.frame getPhotoAtIndex:i];
            if (pht.image == nil) {
                [arrayOfEmptyIndex addObject:[NSNumber numberWithInt:i]];
            }
        }
    }
    
    
    for (int index = 0; index< [imageArray count]; index++)
    {
        int photoNumber = [[arrayOfEmptyIndex objectAtIndex:index] intValue];
        UIImage *image = [imageArray objectAtIndex:index];
        [sess imageSelectedForPhoto:image  indexOfPhoto:photoNumber];
        
    }
    
    //   [arrayOfEmptyIndex release];
    arrayOfEmptyIndex = nil;
    /*
     for (int index = 0; index<[imageArray count]; index++)
     {
     UIImage *image = [imageArray objectAtIndex:index];
     if (index == 0)
     {
     [sess imageSelectedForPhoto:image indexOfPhoto:sess.photoNumberOfCurrentSelectedPhoto];
     
     }else
     {
     for (int photoNumber = 0; photoNumber<sess.frame.photoCount; photoNumber++)
     {
     Photo *pht = [sess.frame getPhotoAtIndex:photoNumber];
     
     if (photoNumber == sess.photoNumberOfCurrentSelectedPhoto)
     {
     continue;
     }
     
     if (pht.image ==  Nil)
     {
     NSLog(@" image is nill at photo index : %d", photoNumber);
     
     [sess imageSelectedForPhoto:image indexOfPhoto:photoNumber];
     image = nil;
     break;
     
     }
     }
     }
     }
     */
    //   [imageArray release];
    imageArray = nil;
    
    [LoadingClass removeActivityIndicatorFrom:self.view];
}

-(void)AddVideoPlayers
{
    // Add video players if not added
    for (int photoIndex= 0; photoIndex< sess.frame.photoCount; photoIndex++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:photoIndex ];
        if(pht.isContentTypeVideo)
        {
            NSURL *videoURL;
            NSString *effectPath = [sess pathToEffectVideoAtIndex:photoIndex];
            NSLog(@"effects applied effect Path %@ ",effectPath);
            if([[NSFileManager defaultManager]fileExistsAtPath:effectPath])
            {
                NSLog(@"effects applied file exists ");
                videoURL = [NSURL fileURLWithPath:effectPath];
            }
            else
            {
                NSLog(@"effects applied file doesn't exists ");
                videoURL = [sess getVideoUrlForPhotoAtIndex:photoIndex];
            }
            pht.view.videoURL = videoURL;
        }
    }
}

#pragma mark notification center methods
- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:selectImageForSession])
    {
        // Removed old popup menu - now using PhotoActionViewController
        // isInEditMode = NO;
        // [sess.frame hideInfoTextView];
        // [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showPhotoOptions:) userInfo:notification.userInfo repeats:NO];
    }
    else if([[notification name] isEqualToString:editImageForSession])
    {
        // Removed old popup menu - now using PhotoActionViewController
        // isInEditMode = YES;
        // self.imageForEdit = notification.object;
        // NSLog(@"edit Image For Session in main controller");
        // [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showPhotoOptions:) userInfo:notification.userInfo repeats:NO];
    }
    
    else if([[notification name] isEqualToString:@"DoneApplyingfilter"])
    {
        [self AddVideoPlayers];
    }
    else if([[notification name] isEqualToString:createNewSession])
    {
        if(nil == nvm)
        {
            nvm = [Settings Instance];
        }
        
        [LoadingClass addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Creating",@"Creating")];
        
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(loadTheSession) userInfo:nil repeats:NO];
    }
    else if([[notification name] isEqualToString:newframeselected])
    {
        [self finishEffectProcessing];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    keyWindow = windowScene.windows.firstObject;
                    break;
                }
            }
            optionsView.view.hidden = NO;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationController.navigationBar.hidden = NO;
        });
        [userDefault setInteger:0 forKey:@"FirstVideoSelected"];
        NSLog(@" fra_me Selected %@",sess);
        // To reset to original music
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"MasterAudioPlayerSet"];
        [self switchOffMasterAudio];
        dontShowOptionsUntilOldAssetsSaved = NO;
        if([[SRSubscriptionModel shareKit]IsAppSubscribed])
        {
            
            UIButton *removeWaterMark = (UIButton*)[self.view viewWithTag:TAG_WATERMARK_BUTTON];
            if(nil != removeWaterMark)
            {
                [removeWaterMark removeFromSuperview];
            }
        }
        if(notification.userInfo == nil)
        {
            NSLog(@"Invalid new frame selected Event, No frame number is passed");
            return;
        }
        NSNumber *frame = [notification.userInfo objectForKey:@"FrameNumber"];
        NSLog(@"ViewController: New frame selected %ld",(long)[frame integerValue]);
        NSLog(@"after pick deleting-----3");
        selectedFrameNumber = (int)frame.integerValue;
        sessionFrameColor = [UIColor blackColor];
        if(sess == nil)
        {
            [self loadTheSession];
        }
        else
        {
            [self frameSelectedAtIndex:selectedFrameNumber ofGridView:nil];
            [self setTheDefaultOrderArray];
        }
        [sess setColor:sessionFrameColor];
        [optionsView AnimateView];
    }
    else if([[notification name] isEqualToString:optionselected])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            NSString *option = userInfo[@"option"];
            NSLog(@"selcted option is %@",option);
            [self ShowSelectedOption:option];
        }
    }
    else if([[notification name] isEqualToString:scaleAndOffsetChanged])
    {
        frameIsEdited = YES;
    }
    else if([[notification name] isEqualToString:@"EnableTheRightTabBarButton"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 16.0, *)) {
                if(self.navigationItem.rightBarButtonItem != nil && isTouchWillDetect)
                    self.navigationItem.rightBarButtonItem.hidden = NO;
                else
                {
                    if(isTouchWillDetect)
                        [self assignRightBarButtonItem];
                }
            } else {
                if(isTouchWillDetect)
                    [self assignRightBarButtonItem];
            }
        });
    }
    else if([[notification name] isEqualToString:@"ExitNOTouchMode"])
    {
        [sess exitNoTouchMode];
    }
    else if([[notification name] isEqualToString:aspectratiochanged])
    {
        if(notification.userInfo == nil)
        {
            NSLog(@"Invalid aspect ratio changed Event, No aspect ratio number is passed");
            return;
        }
        
        NSNumber *aspect = [notification.userInfo objectForKey:@"aspectratio"];
        if(nil == aspect)
        {
            NSLog(@"Couldn't find aspectratio object in aspect ratio changed event");
            return;
        }
        NSLog(@"session frame width %f height %f",sess.frame.frame.size.width , sess.frame.frame.size.height);
        if(nvm.aspectRatio != [aspect intValue])
        {
            [self ChangeParent:sess.frame :mainBackground];
            frameIsEdited = YES;
            CGRect oldRect = sess.frame.frame;
            // [self ChangeParent:sess.frame :mainBackground];
            nvm = [Settings Instance];
            NSLog(@"old aspect ratio is %d new aspect ratio %d",nvm.aspectRatio,[aspect intValue]);
            nvm.aspectRatio = [aspect intValue];
            eAspectRatio eRat = [aspect intValue];
            if(sess.aspectRatio == eRat)
            {
                [LoadingClass removeActivityIndicatorFrom:self.view];
                return;
            }
            [sess setAspectRatio:eRat];
            NSLog(@"new session frame width %f height %f",sess.frame.frame.size.width , sess.frame.frame.size.height);
            
            // get sess color and set it
            [sess setColor:sessionFrameColor];
            //   [sess setColor:sess.frame.backgroundColor];
            
            [self addWaterMarkToFrame];
            NSLog(@"aspect ratio width %f height %f",nvm.wRatio,nvm.hRatio);
            // [self changeAspectRatioOfStickerWidth:nvm.wRatio height:nvm.hRatio];
            [self rePostionStickersfromOldSession:oldRect toNewSession:sess.frame.frame];
            [self ChangeParent:mainBackground :sess.frame];
            [self BringAllStickersTextviewFront];
        }
    }
    else if([[notification name] isEqualToString:@"customspectRatioSelected"])
    {
        CGRect oldRect = sess.frame.frame;
        [self ChangeParent:sess.frame :mainBackground];
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            NSString *width = userInfo[@"width"] ?: @"N/A";
            NSString *height = userInfo[@"height"] ?: @"N/A";
            NSLog(@"Width: %@, Height: %@", width, height);
            nvm = [Settings Instance];
            //   [nvm setCustomAspectRatioWidth:[width floatValue] height:[height floatValue]];
            [Settings setCustomWidth:[width floatValue]];
            [Settings setCustomHeight:[height floatValue]];
        }
        [sess setAspectRatio:ASPECTRATIO_CUSTOM];
        // get sess color and set it
        [sess setColor:sessionFrameColor];
        [self addWaterMarkToFrame];
        [self rePostionStickersfromOldSession:oldRect toNewSession:sess.frame.frame];
        [self ChangeParent:mainBackground :sess.frame];
        [self BringAllStickersTextviewFront];
    }
    else if([[notification name] isEqualToString:loadSession])
    {
        
        if((nil != sess)&&(sess.sessionId == nvm.currentSessionIndex))
        {
            return;
        }
        if(nil == nvm)
        {
            nvm = [Settings Instance];
        }
        
        [LoadingClass addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Loading",@"Loading")];
        
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(loadTheSession) userInfo:nil repeats:NO];
    }
    else if([[notification name] isEqualToString:backgroundImageSelected])
    {
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        imageArray = [[notification userInfo] objectForKey:@"backgroundImageSelected"];
        if ([imageArray count]== 0) {
            return;
        }
        
        _editWhileImageSelection = YES;
        //self.imageForEdit = img;
        [sess deleteCurrentAudioMix];
        NSLog(@"after pick deleting-----4");
        //audio is deleting here//
        [LoadingClass removeActivityIndicatorFrom:self.view];
        [LoadingClass addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Loading",@"Loading")];
        //    NSDictionary *input = [NSDictionary dictionaryWithObject:img forKey:@"image"];
        //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showPhotoEffectsEditor) userInfo:nil repeats:NO];
        NSDictionary *input = [NSDictionary dictionaryWithObject:imageArray forKey:@"imageArray"];
        NSLog(@"Play all video player 6");
        [self playAllPreviewPlayers];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleImageSelection:) userInfo:input repeats:NO];
        //   [imageArray release];
        imageArray = nil;
    }
    else if([[notification name] isEqualToString:backgroundVideoSelected])
    {
        _editWhileImageSelection = YES;
        self.imageForEdit        = nil;
        effectsApplied = NO;
        frameIsEdited = YES;
        /* Get the video path and send it to importer */
        NSLog(@"user info inside notification handler %@",notification.userInfo);
        //  NSURL *videoPath = [notification.userInfo objectForKey:backgroundVideoSelected];
        NSURL *videoPath = [notification.userInfo objectForKey:backgroundVideoSelected];
        NSAssert(nil != videoPath, @"Received nil videoPathUrl in backgroundvideoSelected notification");
        NSLog(@"Not Supported format---%@",videoPath);
        NSDictionary *info = [NSDictionary dictionaryWithObject:videoPath forKey:@"videoPath"];
        [sess deleteCurrentAudioMix];
        NSLog(@"background Video Selected-----5 video path %@",videoPath);
        //audio is deleting here//
        NSLog(@"Play all video player 7");
        [self playAllPreviewPlayers];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(importVideo:) userInfo:info repeats:NO];
    }
    else if([[notification name] isEqualToString:kInAppPurchaseManagerTransactionSucceededNotification])
    {
        if([[SRSubscriptionModel shareKit]IsAppSubscribed])
        {
            [self removeWaterMarkFromFrame];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *waterMarkRemove = (UIButton*)[self.view viewWithTag:TAG_WATERMARK_BUTTON];
                if(nil != waterMarkRemove)
                {
                    [waterMarkRemove removeFromSuperview];
                }
            });
        }
        else
        {
            if([SuccessStatus integerForKey:@"PurchasedYES"] == 1)
            {
                [self removeWaterMarkFromFrame];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIButton *waterMarkRemove = (UIButton*)[self.view viewWithTag:TAG_WATERMARK_BUTTON];
                    if(nil != waterMarkRemove)
                    {
                        [waterMarkRemove removeFromSuperview];
                    }
                });
            }
        }
    }
    
    else if([[notification name]isEqualToString:swapmodeentered])
    {
        [sess.frame enterSwapMode];
    }
    else if([[notification name]isEqualToString:uploaddone])
    {
        //[self KxMenuWillDismissByUser:nil];
    }
    else if([[notification name]isEqualToString:@"notificationdidfinishwithframeview"])
    {
        
        [self.navigationController popViewControllerAnimated:NO];
        NSLog(@"remove watermark");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetFrameView];
        });
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationDidEnterToFirstScreen" object:nil];
    }
    else if([[notification name]isEqualToString:@"ResetFrameView"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetFrameView];
        });
    }
    else if([[notification name]isEqualToString:@"notificationdidLoadView"])
    {
        //// reducing time is causing crash while selecting image/video
        
        
        
        
        //        __weak typeof(self) weakSelf = self;
        //                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                      [weakSelf showFrameSelectionController];
        //                  });
        
        self.navigationItem.rightBarButtonItem = nil;
        __weak typeof(self) weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf || !strongSelf.isViewLoaded || !strongSelf.view.window) {
                return;
            }
            [strongSelf showFrameSelectionController];
        });
        NSLog(@"Called loading frames ");
    }
    else if ([[notification name]isEqualToString:@"didEnterToTouchDetectedMode"])
    {
        isTouchWillDetect = YES;
        //        helpScreen = nil;
    }else if ([[notification name]isEqualToString:selectImageForApplyingEffect])
    {
        NSDictionary *dict = [notification userInfo];
        NSNumber *PhotoNumber = [dict objectForKey:@"photoNumber"];
        int currentSelectedPhotoNumber = PhotoNumber.intValue;
        for(int index = 0; index < sess.frame.photoCount; index++)
        {
            Photo *pht = [sess.frame getPhotoAtIndex:index];
            if(nil != pht)
            {
                NSLog(@"select ImageFor Applying Effect current Selected Photo Number For Effect %d",currentSelectedPhotoNumber);
                currentSelectedPhotoNumberForEffect = currentSelectedPhotoNumber;
                pht.view.scrollView.layer.borderColor = [UIColor redColor].CGColor;
                pht.view.scrollView.layer. borderWidth = 0.0;
                if (index== currentSelectedPhotoNumber) {
                    [pht.view removePlayer]; // to make red border visible for the selected photo - to indicate selection
                    pht.view.scrollView.layer.borderWidth = 5.0;
                }
            }
        }
    }
    else if ([[notification name] isEqualToString:addWaterMark])
    {
        NSLog(@"adding watermark from notification");
        [self addWaterMarkToFrame];
    }
    else if([[notification name] isEqualToString:@"ChangeSessionColor"])
    {
        frameIsEdited = YES;
        NSDictionary *dict = [notification userInfo];
        UIColor *color = [dict objectForKey:@"color"];
        // borderImage = [dict objectForKey:@"bgImage"];
        sess.color = color;
        sessionFrameColor = color;
        for (int photoIndex= 0; photoIndex< sess.frame.photoCount; photoIndex++)
        {
            Photo *pht = [sess.frame getPhotoAtIndex:photoIndex ];
            pht.view.scrollView.backgroundColor = sessionFrameColor;
        }
    }
    else if([[notification name] isEqualToString:@"SliderValueChanged"])
    {
        frameIsEdited = YES;
        NSDictionary *dict = [notification userInfo];
        UISlider *slider = [dict objectForKey:@"Slider"];
        NSString *name = [dict objectForKey:@"Name"];
        if([name isEqual:@"Outer Radius"])
        {
            [self outerRadiusChanged:slider];
        }
        else if([name isEqual:@"Inner Radius"])
        {
            [self innerRadiusChanged:slider];
        }
        else if([name isEqual:@"Width"])
        {
            [self widthChanged:slider];
        }
        else //([name isEqual:@"Shadow"])
        {
            [self shadowValueChanged:slider];
        }
    }
    else if([[notification name] isEqualToString:@"BringUIBacktoNormal"])
    {
        [self SetOriginalUI];
    }
    else if([[notification name] isEqualToString:@"BringUIUP"])
    {
        NSLog(@"Show notification re_Align");
        [self reAlignUI];
    }
    else if([[notification name] isEqualToString:@"AddSticker"])
    {
        frameIsEdited = YES;
        NSDictionary *dict = [notification userInfo];
        NSString *stickerName = [dict objectForKey:@"StickerImageName"];
        NSLog(@"Added sticker image name is %@",stickerName);
        //        if([stickerName containsString:@"heart"])// || [stickerName containsString:@"friendship"])
        //        {
        //            NSString *path = [[NSBundle mainBundle] pathForResource:stickerName ofType:@"webp"];
        //            NSData *imageData = [NSData dataWithContentsOfFile:path];
        //            UIImage *webpImage = [UIImage imageWithData:imageData];
        //            [self AddStickerTOFrame:webpImage];
        //        }
        //        else {
        //            [self AddStickerTOFrame:[UIImage imageNamed:stickerName]];
        //        }
        frameIsEdited = YES;
        [self AddStickerTOFrame:[UIImage imageNamed:stickerName]];
    }
    else if([[notification name] isEqualToString:filterchanged])
    {
        NSDictionary *dict = [notification userInfo];
        id value = dict[@"filterselected"];
        if ([value respondsToSelector:@selector(intValue)]) {
            selectedEffectIndex = [value intValue];
        }
        //        NSNumber *number = dict[@"filterselected"];
        //        selectedEffectIndex = [number intValue]; // Extract int from NSNumber
        [self applySelectedeffectOnPhoto:selectedEffectIndex];
        
        effectsApplied = YES;
        frameIsEdited = YES;
    }
    else if([[notification name] isEqualToString:applyfilter])
    {
        effectsApplied = YES;
        frameIsEdited = YES;
        NSDictionary *dict = [notification userInfo];
        NSNumber *number = dict[@"SelectedFilter"];
        NSLog(@"number %@",number);
        [self checkmarkButtonTapped];
    }
    else if([notification.name isEqualToString:@"RemoveAllVideoPlayer"])
    {
        [self removeAllPreviewPlayers];
    }
    return;
}

-(void)CheckIfAllFramesFilled
{
    int maximumNumberOfImage = 0;
    int photoIndex = 0;
    for (photoIndex= 0; photoIndex< sess.frame.photoCount; photoIndex++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:photoIndex ];
        if (pht.image != nil) {
            maximumNumberOfImage ++;
        }
    }
    NSLog(@"maximum Number Of Image %d photoCount %d",maximumNumberOfImage,sess.frame.photoCount);
    if( maximumNumberOfImage > 0)
    {
        if(maximumNumberOfImage == sess.frame.photoCount)
        {
            [self assignRightBarButtonItem];
        }
    }
}

- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:)name:nil
                                               object:sess];
}

-(void)resetFrameView
{
    optionsView.view.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationController.navigationBar.hidden = YES;
    if(sess != nil)
        [sess hideSession];
    [self removeWaterMarkFromFrame];
}


-(void)changeAspectRatioOfStickerWidth:(CGFloat) width  height:(CGFloat)height // Change aspect Ratio
{
    // [self ChangeParent:mainBackground :sess.frame];
    for (UIView *stickerToResize in self.addedstickes) {
        [self adjustView:stickerToResize toAspectRatioWidth:width height:height]; // Change to 16:9 aspect ratio
    }
    //    for (UIView *textviewToResize in self.textBoxes) {
    //        [self adjustView:textviewToResize toAspectRatioWidth:width height:height];
    //    }
    //[self ChangeParent:sess.frame :mainBackground];
    [self BringAllStickersTextviewFront];
}



- (void)adjustView:(UIView *)view toAspectRatioWidth:(CGFloat)width height:(CGFloat)height {
    CGRect frame = view.frame;
    // Maintain the original width and adjust height accordingly
    if(height>width)
        frame.size.height = frame.size.width * (width / height); //(height / width);
    else
        frame.size.height = frame.size.width * (height / width);
    
    // OR Maintain original height and adjust width accordingly
    // frame.size.width = frame.size.height * (width / height);
    
    view.frame = frame;
}

- (void)updateView:(UIView *)view toWidth:(CGFloat)width toHeight:(CGFloat)height {
    CGRect frame = view.frame;
    frame.size.width = width;
    frame.size.height = height;
    view.frame = frame;
}


- (void)dealloc
{
    NSLog(@"**********  view controller dealloc called***********");
    [self unregisterForNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [_movieMaker release];
    //    [_VideoPathExl release];
    //    [imageForEdit release];
    //    [orderArrayForVideoItems release];
    //    [tabBar release];
    //    [videoImageInfo release];
    //    [super dealloc];
    videoImageInfo = nil;
    orderArrayForVideoItems = nil;
    dictionary = nil;
    dictionaryOfEffectInfo = nil;
    
    
}

#pragma frame thumbnail image generation

#pragma mark first time processing
- (void)generateTheResourcesRequiredOnFirstRun
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *filename     = [NSString stringWithFormat:@"mainbackground.jpg"];
    NSString *path         = [docDirectory stringByAppendingPathComponent:filename];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    /* First generate the main background image */
    if(NO == [filemgr fileExistsAtPath:path])
    {
        UIImage *mainBgnd = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mainbackground_ipad" ofType:@"png"]];
        if(nil != mainBgnd)
        {
            UIImage *optimizedImage = [Utility optimizedImage:mainBgnd withMaxResolution:480];
            NSData *data = UIImageJPEGRepresentation(optimizedImage, 1.0);
            [filemgr createFileAtPath:path contents:data attributes:attributes];
            NSLog(@"generateTheResourcesRequiredOnFirstRun: Created Mainbackground");
        }
        else
        {
            NSLog(@"mainbackground_ipad doesn't exists");
        }
    }
}

#pragma mark viewcontroller methods

- (void)showFrameSelectionController
{
#if SESSIONSUPPORT_ENABLE
    InitSessionManager *mg = [[InitSessionManager alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:mg];
    navBar.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController presentModalViewController:navBar animated:YES];
    [navBar release];
    [mg release];
#else
    // Create and allocate the FrameSelectionController using the new initializer
    FrameSelectionController *sc = [[FrameSelectionController alloc] init];
    
    if (nil == sc)
    {
        return;
    }
    NSLog(@"Frame selection controller reference");
    // Push the view controller on the main thread using dispatch_async
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"////////////// ");
        [self.navigationController pushViewController:sc animated:NO];
        NSLog(@"============= ");
    });
    NSLog(@"Frame selection controller reference end ");
    framesLoaded = YES;
    // Release the controller after pushing
    //[sc release];
#endif
}



- (void)removeWaterMark:(id)sender
{
    
    //[[InAppPurchaseManager Instance]puchaseProductWithId:kInAppPurchaseRemoveWaterMarkPack];
    //    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //    if ([prefs integerForKey:@"Productpurchased"] == 0)
    //    {
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [self ShowSubscriptionView];
    }
    
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerForNotifications];
    }
    return self;
}

// Helper method to create a rounded UIImage for bottom corners
- (UIImage *)createRoundedNavBarImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 88); // Adjust height as needed
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Define bottom-left and bottom-right rounded corners
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                     cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    
    [color setFill];
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// Method to get shuffled font family names
- (NSArray<NSString *> *)shuffledFontFamilies {
    NSArray<NSString *> *fontFamilies = [UIFont familyNames];
    NSMutableArray<NSString *> *shuffledArray = [fontFamilies mutableCopy];
    
    for (NSInteger i = shuffledArray.count - 1; i > 0; i--) {
        NSInteger j = arc4random_uniform((uint32_t)(i + 1));
        [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    return [shuffledArray copy];
}


-(void)showRateUsPanel
{
    [self assignRightBarButtonItem];
    NSLog(@"Rate Us Value %ld",[[NSUserDefaults standardUserDefaults] integerForKey:@"VideoCollageRateUsValue"]);
    // Show only once for apps life time
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"VideoCollageRateUsValue"] == 0)
    {
        [SKStoreReviewController requestReviewInScene:self.view.window.windowScene];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"VideoCollageRateUsValue"];
    }
}

- (void)viewDidLoad
{
    printf("--- MainController.m: viewDidLoad ---\n");
    self.appWentToBackground = NO;
    framesLoaded = false;
    videoSaveprogress = 0.5;
    self.showingFonts = NO;
    multiplier = (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?0.6:0.8;
    heightOfButtons = (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?80:50;
    NSLog(@"screen width %f height %f",fullScreen.size.width , fullScreen.size.height);
    [self finishEffectProcessing];
    [super viewDidLoad];
    // Add observer for app termination
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillTerminate:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    self.currentScale = 1.0;
    doNotTouch = NO;
    changeTitle = NO;
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"MasterAudioPlayerSet"];
    self.socialButtonsData = @[
        
        // @{@"title": @"Facebook", @"imageName": @"facebook_icon"},
        // @{@"title": @"Messenger", @"imageName": @"messenger_icon"},
       // @{@"title": @"WhatsApp", @"imageName": @"whatsapp"},
        @{@"title": @"iMessage", @"imageName": @"imessage"},
        @{@"title": @"Email", @"imageName": @"mail"},
        @{@"title": @"More", @"imageName": @"more"}
    ];
    
    [self setupTopActionButtons];
    [self hideTopButtonContainer];
    upscaleFactor = 2.5f;
    durationOftheVideo = 30;
    NSDictionary *options = @{
        kCIContextWorkingColorSpace : (__bridge id)CGColorSpaceCreateDeviceRGB()
    };
    self.sharedContext = [CIContext contextWithOptions:options];
    currentClickedPhotoFrameNumber = 0;
    dontShowOptionsUntilOldAssetsSaved = NO;
    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            keyWindow = windowScene.windows.firstObject;
            break;
        }
    }
    self.navigationController.navigationBar.hidden = NO;
    selectedOverlayColor = [UIColor clearColor];
    gotKeyBoardHeight = NO;
    frameIsEdited = YES;
    effectBeingApplied = NO;
    // Add observer for keyboard appearance
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    // Create a hidden UITextField
    UITextField *hiddenTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    hiddenTextField.tag = 999;  // Tag for identification
    [self.view addSubview:hiddenTextField];
    
    // Trigger keyboard appearance
    [hiddenTextField becomeFirstResponder];
    
    // Dismiss it immediately
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hiddenTextField resignFirstResponder];
        [hiddenTextField removeFromSuperview];
    });
    effectsApplied = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    initString = @"Enter Text";
    self.textBoxes = [[NSMutableArray alloc] init]; // Initialize the array
    self.addedstickes = [[NSMutableArray alloc] init];
    fontNames = [self shuffledFontFamilies];
    alignments = @[@(NSTextAlignmentLeft), @(NSTextAlignmentCenter), @(NSTextAlignmentRight), @(NSTextAlignmentJustified)];
    selectedAlignment = NSTextAlignmentCenter;
    alignmentIndex = 0;
    isCustomFrameEnabled = NO;
    
    // Hide the default back button
    self.navigationItem.hidesBackButton = YES;
    
    sessionFrameColor = [UIColor blackColor];
    
    // Navigation bar appearance (matching FrameSelectionController style)
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.backgroundColor = [UIColor blackColor];
        appearance.shadowColor = nil;
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.compactAppearance = appearance;
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        self.navigationController.navigationBar.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_svg"]
                                                  style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    // Set the custom back button as the left bar button item
    self.navigationItem.leftBarButtonItem = backButton;
    doneLockedRightBarButton = [self createLockDoneButton];
    doneUnlockedRightBarButton = [self createUnlockDoneButton];
    homeRightBarButton = [self createHomeAsRightButton];
    
    
    alertShownCount = 0;
    generatingVideo = NO;
    photosOptionPresent = NO;
    
    
    
    if (@available(iOS 11.2, *)) {
        [[InAppPurchaseManager Instance]loadStore];
    }
    else
    {
        // Fallback on earlier versions
        [[InAppPurchaseManager Instance]loadStore];
    }
    [self SubscriptionDetails];
    [self SubscriptionDetailsYearly];
    prefsTime = [NSUserDefaults standardUserDefaults];
    prefsDate= [NSUserDefaults standardUserDefaults];
    SuccessStatus = [NSUserDefaults standardUserDefaults];
    button_Index = -1;
    //    allowedAccessToPhoto =NO;
    //    authorisedGallery = NO;
    //    allowedAccessToMusic =NO;
    
    NSLog(@"INIT %p", self);
    
    //----Changes made----//
    
    //[self CustomiseBarButtonItem];
    DontShow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRateUsPanel) name:show_RateUsPanel object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SessionExpired) name:@"SubscriptionSessionExpired" object:nil];
    
    NSLog(@"View did load maincontroller-----");
    //isVideoOrderChangedByUser = NO;
    isEffectEnabled = NO;
    currentSelectedPhotoNumberForEffect =  [sess photoNumberOfCurrentSelectedPhoto];
    
    BOOL enableStatus = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_SEQUENTIAL_Play_STATUS]boolValue];
    isSequentialPlay = enableStatus;
    isTouchWillDetect = YES;
    videoImageInfo = [[NSMutableArray alloc] init];
    
    if (orderArrayForVideoItems != nil) {
        [orderArrayForVideoItems removeAllObjects];
        // [orderArrayForVideoItems release];
        orderArrayForVideoItems = nil;
    }
    orderArrayForVideoItems = [[NSMutableArray alloc] init];
    initialPhotoIndex = 0;
    
    
    [self setNeedsStatusBarAppearanceUpdate]; // Refresh the status bar visibility
    [self gettingInterestialCount];
    
    /* Get the settings instance */
    nvm = [Settings Instance];
    nvm.aspectRatio = ASPECTRATIO_1_1;
    [self generateTheResourcesRequiredOnFirstRun];
    //    /* First register for notifications */
    //    [self registerForNotifications];
    
    
    
    //[self loadInterstitial2];
    mainBackground = [[UIView alloc]initWithFrame:self.view.frame ];
    mainBackground.backgroundColor = [UIColor blackColor];
    mainBackground.tag = mainBGTag;
    mainBackground.userInteractionEnabled = YES;
    imgview = [[UIView alloc]initWithFrame:self.view.frame ];
    self.view = imgview;
    self.view.userInteractionEnabled = YES;
    
    [self.view addSubview:mainBackground];
    
    
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        UIButton *removeWaterMark = [UIButton buttonWithType:UIButtonTypeCustom];
        removeWaterMark.frame = CGRectMake(0,customBarHeight,full_screen.size.width,30);
        removeWaterMark.backgroundColor = PHOTO_DEFAULT_COLOR;
        [removeWaterMark setTitle:@"Remove Watermark" forState:UIControlStateNormal];
        removeWaterMark.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        removeWaterMark.alpha = 0.8;
        //  removeWaterMark.showsTouchWhenHighlighted = YES;
        removeWaterMark.tag = TAG_WATERMARK_BUTTON;
        [removeWaterMark addTarget:self action:@selector(removeWaterMark:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    //    //Curvy background strips
    //
    //    customTabbarback = [[OT_TabBar alloc]initWithFrame:CGRectMake(0,full_screen.size.height-35,full_screen.size.width,35)];
    //
    //    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    //    {
    //        customTabbarback . frame = CGRectMake(0, full_screen.size.height-24, full_screen.size.width, 24);
    //    }
    //    customTabbarback.delegate = self;
    //    customTabbarback.backgroundColor = PHOTO_DEFAULT_COLOR;
    //    customTabbarback.showOverlayOnSelection = NO;
    //
    //    [self.view addSubview:customTabbarback];
    //   [customTabbarback release];
    //Bottom2//
    if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        imgview.backgroundColor=[UIColor blackColor];
        
        //        if (@available(iOS 11.0, *)) {
        //            if (SafeAreaBottomPadding > 0) {
        //                   // iPhone with notch
        //
        //                CGFloat bottomPadding = SafeAreaBottomPadding;
        //                [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-customBarHeight-customBarHeight/2-bottomPadding/2,full_screen.size.width,customBarHeight+20)];
        //            }
        //            else
        //            {
        //                [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-70,full_screen.size.width,70)];
        //            }
        //        }
        //        else
        //        {
        //            [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-70,full_screen.size.width,70)];
        //        }
    }
    else
    {
        imgview.backgroundColor=[UIColor blackColor];
        //        //safe area here //
        //        if (@available(iOS 11.0, *)) {
        //            if (SafeAreaBottomPadding > 0) {
        //                   // iPhone with notch
        //
        //                CGFloat bottomPadding = SafeAreaBottomPadding;
        //                [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-customBarHeight-customBarHeight/2-bottomPadding/2,full_screen.size.width,customBarHeight+20)];
        //            }
        //            else
        //            {
        //                [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-70,full_screen.size.width,70)];
        //            }
        //        }
        //        else
        //        {
        //            [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-70,full_screen.size.width,70)];
        //        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        durationOftheVideo = 30;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                          name:UIApplicationDidEnterBackgroundNotification
                                                        object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                          name:UIApplicationWillEnterForegroundNotification
                                                        object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveView) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Resumepage) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    else{
        durationOftheVideo = 120;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                          name:UIApplicationDidEnterBackgroundNotification
                                                        object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                          name:UIApplicationWillEnterForegroundNotification
                                                        object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseVideoPreviewPlayBack:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeVideoPreviewPlayBack:) name:UIApplicationWillEnterForegroundNotification object:nil];
        NSLog(@"added observers ");
    }
    
    backView = [[UIView alloc]init];
    backView.frame = CGRectMake(0,full_screen.size.height-22,full_screen.size.width,22);
    backView.backgroundColor = PHOTO_DEFAULT_COLOR;
    [self.view addSubview:backView];
    
    CGFloat optionsViewHeight = 92;
    if([self isiPod])
    {
        optionsViewHeight = 85;
    }
    else if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        optionsViewHeight = 100;
    }
    
    
    // Add custom opions view
    optionsView = [[OptionsViewController alloc]init];
    if([self isiPod])
    {
        optionsView.view.frame = CGRectMake(0,full_screen.size.height-optionsViewHeight,full_screen.size.width,optionsViewHeight);
    }
    else if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        optionsView.view.frame = CGRectMake(0,full_screen.size.height-optionsViewHeight,full_screen.size.width,optionsViewHeight);
    }
    else{
        optionsView.view.frame = CGRectMake(0,full_screen.size.height-optionsViewHeight,full_screen.size.width,optionsViewHeight);
    }
    optionsView.view.hidden = YES;
    [self.view addSubview:optionsView.view];
    
    
    NSLog(@"before show frame selection controller ");
    
#if FULLSCREENADS_ENABLE
    bShowRevModAd = YES;
#endif
    
    NSLog(@"before show frame selection controller ");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popOverMenuClosed) name:@"PopoverMenuClosed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllLocksHere) name:@"ClearAllLocksHere" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePhotoSlotSelected:) name:@"photoSlotSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSelectImageForPhoto:) name:selectImageForPhoto object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEditImageForPhoto:) name:editImageForPhoto object:nil];

    // Photo Selection Feature Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePhotoActionSelected:) name:@"photoActionSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAdjustActionSelected:) name:@"adjustActionSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAdjustOptionsBack:) name:@"adjustOptionsBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSpeedViewBack:) name:@"speedViewBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTrimViewBack:) name:@"trimViewBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSpeedChanged:) name:@"speedChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVideoTrimmed:) name:@"videoTrimmed" object:nil];

    // Removed old configs array and tableView initialization
    NSLog(@"end of the main controller view did load  ");
    
    // Adding the gesture recognizer
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    //    [self.view addGestureRecognizer:tapGesture];
    
    [self setUpConstraints];
    //[self setupSlider];
    return;
}

- (void)appWillTerminate:(NSNotification *)notification {
    NSLog(@"App will terminate. Clean up resources here.");
    // Do your cleanup or saving work here
    [self removeAllEffectVideos];
}

- (void)handleDidBecomeActive:(NSNotification *)notification {
    NSLog(@"############# App did become active (e.g., after unlock or power button pressed again)");
    // Resume tasks, restart timers, refresh UI, etc.
    if(!self.appWentToBackground)
    {
        if(!changeTitle)
            [self playAllPreviewPlayers];
    }
    NSLog(@"pause Video Preview Play Back");
}

- (void)handleWillResignActive:(NSNotification *)notification {
    NSLog(@"############# App will resign active (e.g., power button pressed, call, home button)");
    // Pause ongoing tasks, animations, etc
    NSLog(@"resume Video Preview Play Back");
    [self pauseAllPreviewPlayers];
}

- (void)pauseVideoPreviewPlayBack:(NSNotification *)notification
{
//    [self pauseAllPreviewPlayers];
//    NSLog(@"pause Video Preview Play Back");
}

- (void)resumeVideoPreviewPlayBack:(NSNotification *)notification
{
//    NSLog(@"resume Video Preview Play Back");
//    if(!changeTitle)
//    [self playAllPreviewPlayers];
}

// Method to dismiss the keyboard
- (void)dismissKeyboard {
    [self.view endEditing:YES];
    NSLog(@"dismiss keyboard");
    fontSizeSlider.hidden = YES;
    ellipsisOverlay.hidden = YES;
    fontsCollectionView.hidden = YES;
    ColorsCollectionView.hidden = YES;
}

-(void)clearAllLocksHere
{
    //Color And Pattern Locks
    [framButtonType1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [framButtonType2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    //effeects Lock
    lockImageView.image = [UIImage imageNamed:@""];

}

-(void)SessionExpired
{
    NSLog(@"Subscription Session Expired");
    [[SRSubscriptionModel shareKit]IsSessionExpired];
}

-(void)popOverMenuClosed
{
    [[KeyWindow viewWithTag:5005] removeFromSuperview];
    PopUpShown = NO;
}

//- (void)allocateUIForTabbar:(CGRect)rect
//{
//    NSLog(@"custom tabbar of view controller allocated -------");
//    if (customTabBar != nil) {
//        [customTabBar removeFromSuperview];
//        customTabBar = nil;
//    }
//    customTabBar = [[OT_TabBar alloc]initWithFrame:rect];
//    customTabBar.layer.cornerRadius=20;
//    OT_TabBarItem *frames = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"frames2"] selectedImage:[UIImage imageNamed:@"frames_active2"]tag:MODE_FRAMES];
//    OT_TabBarItem *colorAndPattern = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"colors2"]selectedImage:[UIImage imageNamed:@"colors_active2"]tag:MODE_COLOR_AND_PATTERN];
//    OT_TabBarItem *adjustSettings = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"adjust2"]selectedImage:[UIImage imageNamed:@"adjust_active2"]tag:MODE_ADJUST_SETTINGS];
//    OT_TabBarItem *effect = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"fx2"]selectedImage:[UIImage imageNamed:@"fx_active2"]
//        tag:MODE_ADD_EFFECT];
//    OT_TabBarItem *preview = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:play_imageName]selectedImage:[UIImage imageNamed:play_active_imageName]tag:MODE_PREVIEW];
//    OT_TabBarItem *videoSettings = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"settings2"]selectedImage:[UIImage imageNamed:@"settings_active2"]tag:MODE_VIDEO_SETTINGS];
//    OT_TabBarItem *sizes = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"Ratio"] selectedImage:[UIImage imageNamed:@"Ratio_active"]tag:MODE_SIZES];
//
//
//
//    UIImage *stickerimg = [UIImage systemImageNamed:@"face.smiling"];
//    UIImage *tintedImageSticker = [stickerimg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIImage *tintedwhiteImageSticker = [tintedImageSticker imageWithTintColor:[UIColor whiteColor]];
//
//    UIImage *tintedblueImageSticker = [tintedImageSticker imageWithTintColor:[UIColor blueColor]];
//
//
//
//    OT_TabBarItem *stickers = [[OT_TabBarItem alloc]initWithImage:tintedwhiteImageSticker selectedImage:tintedblueImageSticker tag:MODE_STICKERS];
//
//    UIImage *textrimg = [UIImage systemImageNamed:@"textformat.size"];
//    UIImage *tintedImageText = [textrimg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    UIImage *tintedwhiteImageText = [tintedImageText imageWithTintColor:[UIColor whiteColor]];
//
//    OT_TabBarItem *text = [[OT_TabBarItem alloc]initWithImage:tintedwhiteImageText selectedImage:tintedwhiteImageText tag:MODE_TEXT];
//
//
////    OT_TabBarItem *share = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"share2"]selectedImage:[UIImage imageNamed:@"share_active2"]tag:MODE_SHARE];
//
//    preview.nestedSelectionEnabled = NO;
//    customTabBar.showOverlayOnSelection = NO;
//    customTabBar.backgroundColor = PHOTO_DEFAULT_COLOR;
//    customTabBar.delegate        = self;
//    customTabBar.itemTitleArray = [NSArray arrayWithObjects:@"Frames",@"Background",@"Adjust",@"Effect",@"Settings",@"Ratios",@"Stickers",@"Text", nil];//@"Share",
//    customTabBar.items = [NSArray arrayWithObjects:frames,colorAndPattern,adjustSettings,effect,videoSettings, sizes,stickers,text,nil];//share,
//    [self.view addSubview:customTabBar];
////    customTabBar = nil;
////    frames = nil;
////    colorAndPattern = nil;
////    adjustSettings = nil;
////    videoSettings = nil;
////    share = nil;
////    [customTabBar release];
////    [frames release];
////    [colorAndPattern release];
////    [adjustSettings release];
////    [preview release];
////    [videoSettings release];
////    [share release];
//
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self resetFrameView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    //    if(([[NSUserDefaults standardUserDefaults] integerForKey:@"PopUpSecondTime"] == 1))
    //    {
    //        NSLog(@"secondtime popupalert----");
    //        PopUpShown = YES;
    //
    //    }
    
    [super viewWillAppear:animated];
    if(!effectBeingApplied)
        self.navigationController.navigationBar.hidden = NO;
    NSLog(@" viewwill appear--------------maincontroller");
    if(!changeTitle)
    {
        NSLog(@"Play all video player 8");
        [self playAllPreviewPlayers];
    }
    if(optionsView.view.hidden) {
        optionsView.view.hidden = NO;
    }
    if(self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden = NO;
    }
    if(sess != nil) {
        [sess showSessionOn:mainBackground];
    }
    [self assignRightBarButtonItem];
    if(from_share == FALSE)
    {
        [Resume_view removeFromSuperview];
        Resume_view = nil;
        from_share = TRUE;
    }
    
    if(effectSelected)
    {
        NSLog(@"Effect selected");
    }
    
//    [Resume_view removeFromSuperview];
//    Resume_view = nil;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonView) name:@"UnhideBackButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resettingViewAfterPurchase) name:@"HideNativeAdd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetStickersParent) name:@"ResetStickersParent" object:nil];
}

-(void)resetStickersParent
{
    //[self ChangeParent:sess.frame :mainBackground];
    for (int photoIndex= 0; photoIndex< sess.frame.photoCount; photoIndex++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:photoIndex ];
        if(pht.isContentTypeVideo)
        {
            [pht.view playPlayer];
        }
    }
}

-(void)resettingViewAfterPurchase
{
    [self removeWaterMarkFromFrame];
    [framButtonType1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [framButtonType2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    lockImageView.image = [UIImage imageNamed:@""];
    
}
-(void)hidingBarButtonItem
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    NSLog(@"Barbutton clicked....");
}



-(void)assignRightBarButtonItem
{
    if(framesLoaded)
    {
        if(generatingVideo)
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else{
            if((( sess.frameNumber <3 || sess.frameNumber ==1003 ||  sess.frameNumber ==1007 ||  sess.frameNumber == 1013 || sess.frameNumber ==1018 ||  sess.frameNumber ==21 ||  sess.frameNumber ==1033   ||  sess.frameNumber == 37 ||  sess.frameNumber ==43)||[[SRSubscriptionModel shareKit]IsAppSubscribed]) && !changeTitle)
            {
                self.navigationItem.rightBarButtonItem = doneUnlockedRightBarButton;
            }
            else if(changeTitle)
            {
                if(isTouchWillDetect)
                    self.navigationItem.rightBarButtonItem = homeRightBarButton;
            }
            else{
                if(isTouchWillDetect)
                    self.navigationItem.rightBarButtonItem = doneLockedRightBarButton;
            }
            if (@available(iOS 16.0, *)) {
                if(isTouchWillDetect)
                    self.navigationItem.rightBarButtonItem.hidden = NO;
            } else {
                // Fallback on earlier versions
            }
        }
        self.navigationController.navigationBar.hidden = NO;
        if(changeTitle)
            self.title = @"Save or Share";
        else
            self.title = @"Images or Videos";//@"Select Images"
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    currentSelectedPhotoNumberForEffect =  [sess photoNumberOfCurrentSelectedPhoto];
    [self assignRightBarButtonItem];
    photosOptionPresent = NO;
    NSLog(@"Checking ExpiryHere Main controller view-------");
    [[SRSubscriptionModel shareKit]loadProducts]; // newly added here
    [[SRSubscriptionModel shareKit]CheckingExpiryHere];
    NSLog(@" view did appear--------------maincontroller");
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    }
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"callingFromEffects"] == 1)
    {
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"callingFromEffects"];
        [self ShowFiltersViewController];
    }
    
    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillEnterForegroundNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseVideoPreviewPlayBack:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeVideoPreviewPlayBack:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}


-(BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

-(void)clearingWhiteScreenfirst
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // saving an Integer
    [prefs setInteger:0 forKey:@"whiteScreen"];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"shouldAutorotateToInterfaceOrientation");
    //return NO;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark comman exit function for settings
-(void)exitAnySettings
{
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView *v1 = (CMPopTipView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v1)
    {
        [v1 dismissAnimated:YES];
        [v1 release];
    }
    
    v1 = (CMPopTipView*)[self.view viewWithTag:TAG_COLORPICKER_TIPVIEW];
    if(nil != v1)
    {
        [v1 dismissAnimated:YES];
        [v1 release];
    }
    
    CMPopTipView *v = (CMPopTipView*)[self.view viewWithTag:TAG_ASPECTRATIO_TIPVIEW];
    if(nil != v)
    {
        [v dismissAnimated:YES];
        [v release];
    }
    
#else
    if(nil != sliders)
    {
        [sliders dismissModal];
        // [sliders release];
        // sliders = nil;
    }
    
    if(nil != colorAndPatternView)
    {
        [colorAndPatternView dismissModal];
        //    [colorAndPatternView release];
        //   colorAndPatternView = nil;
    }
    
    if(nil != aspectRatioView)
    {
        [aspectRatioView dismissModal];
        //   [aspectRatioView release];
        //    aspectRatioView = nil;
    }
#endif
    
    if(nil != sess)
    {
        [sess updateTheSessionIcon];
    }
    return;
}

#pragma mark inner and outer radius implementation
-(void)outerRadiusChanged:(UISlider*)slider
{
    /* needs to delete */
    [sess setOuterRadius:slider.value];
    NSLog(@"set outerradius %f",sess.getOuterRadius);
    
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView *v = (CMPopTipView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v)
    {
        [v setNeedsDisplay];
    }
#else
    //SNPopupView *v = (SNPopupView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    //if(nil != v)
    //{
    //    [v setNeedsDisplay];
    //}
#endif
}

-(void)shadowValueChanged:(UISlider *)slider
{
    [sess setShadowValue:slider.value cornerRad:sess.getInnerRadius];
    NSLog(@"inner Radious value is %f",innerRadius.value);
    NSLog(@"slider value changed is %f",slider.value);
}

-(void)innerRadiusChanged:(UISlider*)slider
{
    [sess setInnerRadius:slider.value];
    
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView *v = (CMPopTipView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v)
    {
        [v setNeedsDisplay];
    }
#else
    //SNPopupView *v = (SNPopupView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    //if(nil != v)
    //{
    //    [v setNeedsDisplay];
    //}
#endif
}

-(void)widthChanged:(UISlider*)slider
{
    
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView *v = (CMPopTipView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v)
    {
        [v setNeedsDisplay];
    }
    //#else
    SNPopupView *v = (SNPopupView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v)
    {
        [v setNeedsDisplay];
    }
#endif
    
    [sess setFrameWidth:slider.value];
    //v.hidden = NO;
}

//-(void)showRadiusSettings:(id)sender fromFrame:(CGRect)fromRect
//{
//    /* First exit the settings menu if it exists */
//    [self exitAnySettings];
//
//    CGRect       rect              = CGRectMake(RADIUS_SETTINGS_X, RADIUS_SETTINGS_Y, RADIUS_SETTINGS_WIDTH, RADIUS_SETTINGS_HEIGHT);
//    UISlider    *outerRadius       = nil;
//    //UISlider    *innerRadius       = nil;
//    innerRadius       = nil;
//    UIView *radiusSettingsBgnd = nil;
//    UIFont *lblFont = [UIFont systemFontOfSize:14.0];
//    float outerRadiusIndex = 10.0;
//    float innerRadiusIndex = 50.0;
//    float widthIndex       = 90.0;
//
//
//    /* Set the background image */
//    radiusSettingsBgnd = [[UIView alloc]initWithFrame:rect];
//    radiusSettingsBgnd.alpha = 0.8;
//    radiusSettingsBgnd.userInteractionEnabled = YES;
//    radiusSettingsBgnd.tag = RADIUS_TAG_INDEX;
//
//    UILabel *innerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+innerRadiusIndex, 150, 25)];
//    innerRadiusLbl.tag = RADIUS_TAG_INDEX+1;
//    innerRadiusLbl.font = lblFont;
//    innerRadiusLbl.text = NSLocalizedString(@"Inner Radius", @"Inner Radius");
//    innerRadiusLbl.textAlignment = UITextAlignmentLeft;
//    innerRadiusLbl.backgroundColor = [UIColor clearColor];
//    innerRadiusLbl.textColor = [UIColor whiteColor];
//
//    //innerRadius = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+140.0, rect.origin.y+innerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 23.0)];
//    innerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+140.0, rect.origin.y+innerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 23.0)];
//    innerRadius.tag = RADIUS_TAG_INDEX+2;
//    /* Configure the brush Slider  */
//    innerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
//    innerRadius.minimumValue     = 0.0;
//    innerRadius.continuous       = YES;
//    innerRadius.value            = sess.getInnerRadius;
//    [innerRadius addTarget:self action:@selector(innerRadiusChanged:)
//          forControlEvents:UIControlEventValueChanged];
//
//    UILabel *outerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+outerRadiusIndex, 150, 25)];
//    outerRadiusLbl.tag =RADIUS_TAG_INDEX+3;
//    //outerRadiusLbl.text = NSLocalizedString(@"OUTERRADIUS",@"Outer Radius");
//    outerRadiusLbl.text = @"Outer Radius";
//    outerRadiusLbl.font = lblFont;
//    outerRadiusLbl.textAlignment = UITextAlignmentLeft;
//    outerRadiusLbl.backgroundColor = [UIColor clearColor];
//    outerRadiusLbl.textColor = [UIColor whiteColor];
//
//    /* Allocate the slider */
//    //outerRadius = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+140.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 23.0)];
//    outerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+140.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 23.0)];
//    outerRadius.tag = RADIUS_TAG_INDEX+4;
//    /* Configure the brush Slider  */
//    outerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
//    outerRadius.minimumValue     = 0;
//    outerRadius.continuous       = YES;
//    outerRadius.value            = sess.getOuterRadius;
//
//    [outerRadius addTarget:self action:@selector(outerRadiusChanged:)
//          forControlEvents:UIControlEventValueChanged];
//
//    UILabel *widthLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+widthIndex, 150, 25)];
//    widthLbl.tag =RADIUS_TAG_INDEX+5;
//    widthLbl.text = NSLocalizedString(@"Width",@"Width");
//    widthLbl.font = lblFont;
//    widthLbl.textAlignment = UITextAlignmentLeft;
//    widthLbl.backgroundColor = [UIColor clearColor];
//    widthLbl.textColor = [UIColor whiteColor];
//
//    //UISlider *width = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+140.0, rect.origin.y+widthIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 24.0)];
//    UISlider *width = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+140.0, rect.origin.y+widthIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 24.0)];
//    width.tag = RADIUS_TAG_INDEX+6;
//    /* Configure the brush Slider  */
//    width.maximumValue     = 30;
//    width.minimumValue     = 0;
//    width.continuous       = YES;
//    width.value            = sess.getFrameWidth;
//
//    [width addTarget:self action:@selector(widthChanged:)
//    forControlEvents:UIControlEventValueChanged];
//
//    [radiusSettingsBgnd addSubview:innerRadiusLbl];
//    [radiusSettingsBgnd addSubview:outerRadiusLbl];
//    [radiusSettingsBgnd addSubview:innerRadius];
//    [radiusSettingsBgnd addSubview:outerRadius];
//    [radiusSettingsBgnd addSubview:widthLbl];
//    [radiusSettingsBgnd addSubview:width];
//
//    radiusSettingsBgnd.backgroundColor = [UIColor clearColor];
//#if CMTIPPOPVIEW_ENABLE
//    CMPopTipView *sliders = [[CMPopTipView alloc]initWithCustomView:radiusSettingsBgnd];
//    sliders.backgroundColor = [UIColor blackColor];
//    sliders.alpha = 0.5;
//    sliders.tag = TAG_SLIDERS_TIPVIEW;
//    sliders.disableTapToDismiss = YES;
//    UIBarButtonItem *bar = (UIBarButtonItem*)sender;
//    [sliders presentPointingAtBarButtonItem:bar animated:YES];
//#else
//    sliders = [[SNPopupView alloc]initWithContentView:radiusSettingsBgnd contentSize:radiusSettingsBgnd.frame.size];
//    //UIBarButtonItem *bar = (UIBarButtonItem*)sender;
//    sliders.tag = TAG_SLIDERS_TIPVIEW;
//    sliders.delegate = self;
//    NSLog(@"SettingsBgnd (%f,%f,%f,%f)",radiusSettingsBgnd.frame.origin.x,radiusSettingsBgnd.frame.origin.y,radiusSettingsBgnd.frame.size.width,radiusSettingsBgnd.frame.size.height);
//    //UIView *targetView = (UIView *)[bar performSelector:@selector(view)];
//    //CGPoint tipPoint = CGPointMake(targetView.center.x, targetView.frame.origin.y+targetView.frame.size.height);
//    CGPoint tipPoint = CGPointMake(fromRect.origin.x+fromRect.size.width/2.0, fromRect.origin.y);
//    [sliders presentModalAtPoint:tipPoint inView:self.view];
//#endif
////    width = nil;
////    widthLbl = nil;
////    radiusSettingsBgnd = nil;
////    innerRadiusLbl = nil;
////    outerRadius = nil;
////    innerRadius = nil;
////    outerRadiusLbl = nil;
////    [width release];
////    [widthLbl release];
////    [radiusSettingsBgnd release];
////    [innerRadiusLbl release];
////    [outerRadius release];
////    [innerRadius release];
////    [outerRadiusLbl release];
//
//    return;
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch;
    CGPoint location;
    
    /* Get the location */
    touch    = [touches anyObject];
    location = [touch locationInView:self.view];
    
    CGRect settingsRect = CGRectMake(RADIUS_SETTINGS_X, RADIUS_SETTINGS_Y, RADIUS_SETTINGS_WIDTH, RADIUS_SETTINGS_HEIGHT);
    if(CGRectContainsPoint(settingsRect, location))
    {
        //[self exitRadiusSettings];
    }
    UIImageView *adjustImageView = (UIImageView *)[self.view viewWithTag:TAG_ADJUST_BG];
    UIImageView *previewImageView  = (UIImageView *)[self.view viewWithTag:TAG_PREVIEW_BGPAD];
    UIImageView *settings = (UIImageView *)[self.view viewWithTag:TAG_VIDEOSETTINGS_BGPAD];
    
    // [self releaseResourcesForColorAndPatternSettings_updated];
    if (isTouchWillDetect) {
        
        if (eMode == MODE_VIDEO_SETTINGS)
        {
            NSLog(@"Mode video Setting");
            if ((location.y >settings.frame.origin.y+settings.frame.size.height) || (location.y < settings.frame.origin.y))
            {
                [self releaseResourcesForVideoSetttings];
            }
            
            
        }
        else if (eMode == MODE_PREVIEW)
        {
            if ((location.y >previewImageView.frame.origin.y+previewImageView.frame.size.height) || (location.y < previewImageView.frame.origin.y))
            {
                //                [self releaseResourcesForPreview];
            }
        }
    }
    
    if(!generatingVideo && !doNotTouch)
    {
        //[self backButtonView];
        NSLog(@"view touched here--- **********");
        [self CallCancel];
    }
    else
    {
        NSLog(@"view touched here---Generating Video");
    }
    if(!doNotTouch){
        UIView *touchedView = touch.view;
        if (touchedView != self.view) { // Ensure it's not the main view
            NSLog(@"Touched view tag: %ld", (long)touchedView.tag);
            if(touchedView.tag == 111111)
            {
                
            }
            if(touchedView.tag == mainBGTag)
            {
                NSLog(@"Touched main background");
                // remove the subview added
                if(backgroundSubviewisAdded)
                {
                    [self SetOriginalUI];
                    [self removeBgViewController];
                }
                if(sliderSubviewisAdded)
                {
                    [self SetOriginalUI];
                    [self removeSliderViewController];
                }
                if(effectSubviewAdded)
                {
                    NSLog(@"effect Subview Added");
                    effectSubviewAdded = NO;
                    [self removeEffectsViewController];
                    [self AddVideoPlayers];
                    [self SetOriginalUI];
                }
                if(textEditorSubviewAdded)
                {
                    NSLog(@"textEditorSubviewAdded doneBtnTapped called");
                    [self doneBtnTapped];
                }
            }
        } else {
            [self doneBtnTapped];
            NSLog(@"Touched the main view");
        }
    }
    
}

-(void)CallCancel
{
//    effectSelected = NO;
//    
//    for (int index = 0; index<sess.frame.photoCount; index++)
//    {
//        Photo *pht = [sess.frame getPhotoAtIndex:index];
//        UIImage *image= nil;
//        if ([sess getFrameCountForPhotoAtIndex:index]==0)
//        {
//            image = [sess getImageAtIndex:index];
//        }else
//        {
//            image = [sess getImageAtIndex:index];
//        }
//        if (pht.view.imageView.image != nil)
//        {
//            pht.view.imageView.image = nil;
//            pht.view.imageView.image = image;
//            
//            [pht.view.imageView setNeedsDisplay];
//        }
//    }
//    self.navigationItem.leftBarButtonItem = backButton;
//    [self assignRightBarButtonItem];
}

#pragma mark color and pattern picker
-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{
    sess.color = [cp selectionColor];
    
    [pickerView setNeedsDisplay];
}

- (void)itemSelectedAtIndex:(int)index ofGridView:(GridView*)gView
{
    if(gView.tag == TAG_PATTERNPICKER)
    {
        NSLog(@"itemSelectedAtIndex %d of pattern picker",index);
        sess.pattern = index;
        
        return;
    }
    else
    {
        NSLog(@"itemSelectedAtIndex %d of unknown picker",index);
    }
}

#if CMTIPPOPVIEW_ENABLE
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    UIView *cView = nil;
    UIView *pView = nil;
    NSLog(@"popTipViewWasDismissedByUser");
    cView = [pickerView viewWithTag:TAG_COLORPICKER];
    if(nil != cView)
    {
        NSLog(@"Removing color picker");
        [cView removeFromSuperview];
    }
    
    pView = [pickerView viewWithTag:TAG_PATTERNPICKER];
    if(nil != pView)
    {
        NSLog(@"Removing pattern picker");
        [pView removeFromSuperview];
    }
    
    if(nil != pickerView)
    {
        [pickerView removeFromSuperview];
        pickerView = nil;
    }
    
    return;
}
#endif

- (void)didDismissModal:(SNPopupView*)popupview;
{
    UIView *cView = nil;
    UIView *pView = nil;
    NSLog(@"didDismissModal");
    cView = [pickerView viewWithTag:TAG_COLORPICKER];
    if(nil != cView)
    {
        NSLog(@"Removing color picker");
        [cView removeFromSuperview];
    }
    
    pView = [pickerView viewWithTag:TAG_PATTERNPICKER];
    if(nil != pView)
    {
        NSLog(@"Removing pattern picker");
        [pView removeFromSuperview];
    }
    
    pView = [pickerView viewWithTag:TAG_SLIDERS_TIPVIEW];
    {
        NSLog(@"Removing radius settings");
        [sess updateTheSessionIcon];
        [pView removeFromSuperview];
    }
    
    if(nil != pickerView)
    {
        [pickerView removeFromSuperview];
        pickerView = nil;
    }
    
    return;
}

-(UIView*)allocateColorPicker
{
    NSLog(@"color picker selected---2");
    /* make sure that we ignore colo */
    UIView *pickerBg =[[UIView alloc]initWithFrame:CGRectMake(0.0, 40.0, 250.0, 200.0) ];
#if defined(APP_INSTAPICFRAMES)
    /* RS color picker */
    RSColorPickerView *colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(40.0, 0.0, 150.0, 150.0)];
#else
    RSColorPickerView *colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(25.0, 0.0, 150.0, 150.0)];
#endif
    [colorPicker setDelegate:self];
    [colorPicker setBrightness:1.0];
    [colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
    [colorPicker setBackgroundColor:[UIColor clearColor]];
    
    /* Allocate bright ness slider */
    RSBrightnessSlider *brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake((colorPicker.frame.origin.x + colorPicker.frame.size.width/2.0 + 30.0), (colorPicker.center.y-15.0), colorPicker.frame.size.width, 30.0)];
    [brightnessSlider setColorPicker:colorPicker];
    [brightnessSlider setUseCustomSlider:YES]; // Defaults to NO
    brightnessSlider.layer.cornerRadius = 9.0;
    brightnessSlider.layer.masksToBounds = YES;
    brightnessSlider.layer.borderColor = [UIColor redColor].CGColor;
    brightnessSlider.layer.borderWidth = 3.0;
    brightnessSlider.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    /* Add color picker */
    [pickerBg addSubview:colorPicker];
    [pickerBg addSubview:brightnessSlider];
    
    /* Release memory for color pickers */
    //    [colorPicker release];
    //    [brightnessSlider release];
    //    colorPicker = nil;
    //    brightnessSlider = nil;
    pickerBg.tag = TAG_COLORPICKER;
    
    return pickerBg;
}

#pragma mark Aspect Ratio UI
-(void)releaseAspectRatioMenu
{
    
#if CMTIPPOPVIEW_ENABLE
    
    CMPopTipView * v = (CMPopTipView*)[self.view viewWithTag:TAG_ASPECTRATIO_TIPVIEW];
    if(nil == v)
    {
        NSLog(@"releaseAspectRatioMenu: something is seriously wrong, CMPopTipView is nil");
        return;
    }
    [v dismissAnimated:NO];
    [v release];
    
#else
    
    if(nil == aspectRatioView)
    {
        NSLog(@"releaseAspectRatioMenu: something is seriously wrong, SNPopupView is nil");
        return;
    }
    [aspectRatioView dismissModal];
    aspectRatioView = nil;
    
#endif
    
    return;
}

-(void)performAspectRatioChange:(NSTimer*)theTimer
{
    NSNumber *num    = theTimer.userInfo;
    eAspectRatio eRat = [num intValue];
    
    /* Release aspect ratio menu */
    [self releaseAspectRatioMenu];
    
    /* No need to proceed further of the user selects the same aspect ratio */
    if(sess.aspectRatio == eRat)
    {
        [LoadingClass removeActivityIndicatorFrom:self.view];
        return;
    }
    
    [sess setAspectRatio:eRat];
    UIToolbar *toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_EDIT];
    if(nil != toolBar)
    {
        UIBarButtonItem *itm = [toolBar.items objectAtIndex:8];
        itm.title = [NSString stringWithFormat:@"%d:%d",(int)nvm.wRatio,(int)nvm.hRatio];
    }
    [LoadingClass removeActivityIndicatorFrom:self.view];
}

-(void)aspectRatioChanged:(id)sender
{
    UIButton *btn     = sender;
    eAspectRatio eRat = (int)btn.tag - TAG_ASPECTRATIO_BUTTON;
    NSNumber *num     = [NSNumber numberWithInt:eRat];
    
    /* First show the activity indicator */
    // [LoadingClass addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Processing", @"Processing")];
    
    /* Schdule the timer to process the aspect ratio change */
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(performAspectRatioChange:) userInfo:num repeats:NO];
    
    return;
}


- (void)showAspectRatiosViewController {
    // Initialize the view controller to present
    self.sheetVC = [[AspectRatioViewController alloc] init];
    
    // Set the modal presentation style to page sheet
    self.sheetVC.modalPresentationStyle = UIModalPresentationFormSheet;
    self.sheetVC.modalInPresentation = NO; // Allows the sheet
    self.sheetVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.sheetVC.edgesForExtendedLayout = UIRectEdgeAll;
    self.sheetVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    // Optionally, configure the sheet for iOS 15+ using UISheetPresentationController
    if (@available(iOS 15.0, *)) {
        UISheetPresentationController *sheetController = self.sheetVC.sheetPresentationController;
        if (sheetController) {
            if (@available(iOS 16.0, *)) {
                // Define a custom detent at 400 points
                UISheetPresentationControllerDetent * smallDetent =
                [UISheetPresentationControllerDetent customDetentWithIdentifier:@"small" resolver:^CGFloat(id<UISheetPresentationControllerDetentResolutionContext>  _Nonnull context) { return small_Detent; }];
                // Configure the sheet presentation
                sheetController.detents = @[ smallDetent, [UISheetPresentationControllerDetent largeDetent] ];
            }else
            {
                // Configure the sheet presentation
                sheetController.detents = @[[UISheetPresentationControllerDetent mediumDetent], [UISheetPresentationControllerDetent largeDetent] ];
            }
            sheetController.prefersGrabberVisible = YES; // Hide the default grabber
            self.sheetVC.preferredContentSize = CGSizeMake(fullScreen.size.width, fullScreen.size.height*0.9);
            sheetController.prefersEdgeAttachedInCompactHeight = YES;
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = YES;
            
            //                    // Add custom grabber view
            //                    UIView *customGrabberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sheetVC.view.bounds.size.width, 20)];
            //            customGrabberView.backgroundColor = [UIColor clearColor];
            //
            //                    // Add UIImageView for custom grabber
            //                    grabberImageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.compact.up"]];
            //                    grabberImageView.contentMode = UIViewContentModeScaleAspectFill;
            //            grabberImageView.backgroundColor = [UIColor clearColor];
            
            //            UIView *containerView = sheetController.containerView;
            //            CGRect frame = containerView.frame;
            //             // Log the frame to the console
            //            NSLog(@"Sheet Frame: %@", NSStringFromCGRect(frame));
            //            NSLog(@"Screen bounds %@",NSStringFromCGRect(fullScreen));
            //            NSLog(@"viewcontroller bounds %@",NSStringFromCGRect(sheetVC.view.bounds));
            //            //grabberImageView.frame = CGRectMake(300, 5, 40, 10);
            //            grabberImageView.tintColor = [UIColor whiteColor];
            //            grabberImageView.translatesAutoresizingMaskIntoConstraints = NO;
            //            [customGrabberView addSubview:grabberImageView];
            //            [sheetVC.view addSubview:customGrabberView];
            //            CGFloat centerX = 0 ;
            //            if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
            //                centerX = -50;
            //            }
            //            [NSLayoutConstraint activateConstraints:@[
            //                [grabberImageView.topAnchor constraintEqualToAnchor:customGrabberView.topAnchor],
            //                [grabberImageView.bottomAnchor constraintEqualToAnchor:customGrabberView.bottomAnchor],
            ////                [grabberImageView.leadingAnchor constraintEqualToAnchor:customGrabberView.leadingAnchor],
            ////                [grabberImageView.trailingAnchor constraintEqualToAnchor:customGrabberView.trailingAnchor]
            //                [grabberImageView.widthAnchor constraintEqualToConstant:40],
            //                [grabberImageView.heightAnchor constraintEqualToConstant: 10],
            //                [grabberImageView.centerXAnchor constraintEqualToAnchor:customGrabberView.centerXAnchor constant:centerX]
            //
            //            ]];
            //            [sheetVC.view bringSubviewToFront:customGrabberView];
            
            sheetController.delegate = self;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isViewLoaded && self.view.window) {
            if (self.presentedViewController == nil) {
                [self presentViewController:self.sheetVC animated:YES completion:nil];
            }
        }
    });
    NSLog(@"Show Aspect ratio VC re_Align");
    [self reAlignUI];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if (self.isViewLoaded && self.view.window) {
    //            // Present the view controller
    //            [self presentViewController:sheetVC animated:YES completion:^{
    //                    // After the sheet has been presented, access the frame
    //                    UISheetPresentationController *sheetController = sheetVC.sheetPresentationController;
    //                    if (sheetController) {
    //                        // Access the containerView or presentedView to get the frame (width)
    //                        CGRect sheetFrame = sheetController.containerView.frame; // Or use presentedView.frame
    //                        NSLog(@"Sheet width: %.2f", sheetFrame.size.width);
    //                    }
    //                }];
    //        } else {
    //            NSLog(@"_controller is not in the view hierarchy");
    //        }
    //    });
}


// UISheetPresentationControllerDelegate method
-(void)sheetPresentationControllerDidChangeSelectedDetentIdentifier:(UISheetPresentationController *)sheetPresentationController API_AVAILABLE(ios(15.0)) {
    
    NSLog(@"Selected detent changed to: %@ detents %@" , sheetPresentationController.selectedDetentIdentifier,sheetPresentationController.detents);
    if(self.sheetVC == (AspectRatioViewController*)sheetPresentationController.presentedViewController)
    {
        if (sheetPresentationController) {
            NSArray<UISheetPresentationControllerDetent *> *detents = sheetPresentationController.detents;
            NSLog(@"Sheet Detents: %@", detents);
        }
        NSLog(@"Selected detent changed to: %@", sheetPresentationController.selectedDetentIdentifier);
        //        if (@available(iOS 15.0, *)) {
        if(sheetPresentationController.selectedDetentIdentifier == UISheetPresentationControllerDetentIdentifierMedium || [sheetPresentationController.selectedDetentIdentifier  isEqual: @"small"])
        {
            NSLog(@" aspect horizontal re_Align");
            [self reAlignUI];
            [self.sheetVC reloadStickerInHorizontalCollectionView];
        }else
        {
            NSLog(@" vertical ");
            [self.sheetVC reloadStickerInVerticalCollectionView];
        }
        //        }
    }
}

-(void)reAlignUI
{
    CGFloat i = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?0.4:0.35;
    CGFloat centerY = fullScreen.size.height*i;
    NSLog(@"re Align UI  current y ==  %f  set y %f",mainBackground.center.y ,centerY);
    if(mainBackground.center.y != centerY )
    {
        // dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"re Align UIn ht %f",fullScreen.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            NSLog(@"animate frame center");
            self.customCenterY = centerY;
            mainBackground.center   = CGPointMake(self.view.center.x, self.customCenterY);
        }];
        [self.view layoutIfNeeded];
        [self.view setNeedsLayout];
        NSLog(@"center y is %f",self.view.center.y);
        if (@available(iOS 16.0, *)) {
            self.navigationItem.leftBarButtonItem.hidden = YES;
        } else {
            // Fallback on earlier versions
            self.navigationItem.leftBarButtonItem = nil;
        }
        
        NSLog(@"Enable the right button after video generation nil ==== ");
        if (@available(iOS 16.0, *)) {
            self.navigationItem.rightBarButtonItem.hidden = YES;
        } else {
            // Fallback on earlier versions
            self.navigationItem.rightBarButtonItem = nil;
        }
        self.navigationController.navigationBar.hidden = YES;
        self.title = @"";
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        //   });
    }
}

-(void)SetOriginalUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"Set Original UI");
        [UIView animateWithDuration:0.3 animations:^{
            self.customCenterY = fullScreen.size.height/2;
            mainBackground.center   = CGPointMake(self.view.center.x, fullScreen.size.height/2);
        }];
        if(!effectBeingApplied){
            [self refreshNavigationBar];
        }
    });
    if(backgroundSubviewisAdded)
    {
        [self removeBgViewController];
        backgroundSubviewisAdded = NO;
    }
    if(sliderSubviewisAdded)
    {
        [self removeSliderViewController];
        sliderSubviewisAdded = NO;
    }
    if(effectSubviewAdded)
    {
        [self removeEffectsViewController];
        effectSubviewAdded = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"resetSelectedItems" object:nil];
    for(int index = 0; index < sess.frame.photoCount; index++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            pht.view.scrollView.layer.borderWidth = 0.0;
        }
    }
    [sess exitTouchModeForSlectingImage];
    [self DeselectAllSelectedItemForText];
}

-(void)refreshNavigationBar
{
    if (@available(iOS 16.0, *)) {
        self.navigationItem.leftBarButtonItem.hidden = NO;
    } else {
        // Fallback on earlier versions
        self.navigationItem.leftBarButtonItem = backButton;
    }
    if (@available(iOS 16.0, *)) {
        if(isTouchWillDetect)
            self.navigationItem.rightBarButtonItem.hidden = NO;
    } else {
        if(isTouchWillDetect)
            [self assignRightBarButtonItem];
    }
    self.navigationController.navigationBar.hidden = NO;
    if(changeTitle)
        self.title = @"Save or Share";
    else
        self.title = @"Images or Videos";
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}


// Delegate method when user tries to dismiss
- (void)presentationControllerDidAttemptToDismiss:(UIPresentationController *)presentationController {
    NSLog(@"User attempted to dismiss the sheet.");
}

// This method is called when the sheet is dismissed
- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController {
    NSLog(@"Sheet dismissed!");
    UIViewController *dismissedVC = presentationController.presentedViewController;
    NSLog(@"Dismissed ViewController: %@", NSStringFromClass([dismissedVC class]));
    [self SetOriginalUI];
}



-(void)showAspectRatioMenu:(id)sender
{
    [self exitAnySettings];
    
    int index = 0;
    UIScrollView *aspectRatioMenu = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 295, 60)];
    aspectRatioMenu.tag = TAG_ASPECTRATIO_BG;
    aspectRatioMenu.scrollEnabled = YES;
    aspectRatioMenu.bounces = YES;
    aspectRatioMenu.alwaysBounceHorizontal = YES;
    float aspectButtonWidth = aspectRatioMenu.frame.size.width/6;
    float aspectButtonY     = 4.0;
    float aspectButtonX     = 0.0;
    for(index = 0; index < ASPECTRATIO_MAX; index++)
    {
        UIButton *aspect = [[UIButton alloc]initWithFrame:CGRectMake(aspectButtonX, aspectButtonY, aspectButtonWidth, aspectButtonWidth)];
        CGPoint cntr = aspect.center;
        CGSize  ratio = [Settings aspectRatioToValues:index];
        float   maxRatio = (ratio.width > ratio.height)?ratio.width:ratio.height;
        aspect.frame = CGRectMake(aspect.frame.origin.x, aspect.frame.origin.y, aspect.frame.size.width * ratio.width / maxRatio, aspect.frame.size.height * ratio.height / maxRatio);
        aspect.center = CGPointMake(aspect.center.x, cntr.y);
        aspect.tag = TAG_ASPECTRATIO_BUTTON + index;
        aspect.layer.cornerRadius = 5.0;
        aspectButtonX = aspectButtonX + aspect.frame.size.width + 10.0;
        [aspect addTarget:self action:@selector(aspectRatioChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *title = [NSString stringWithFormat:@"%d:%d",(int)ratio.width,(int)ratio.height];
        if(nvm.aspectRatio == index)
        {
            aspect.backgroundColor = PHOTO_DEFAULT_COLOR;
            
        }
        else
        {
            aspect.backgroundColor = DARK_GRAY_BG;
        }
        
        [aspect setTitle:title forState:UIControlStateNormal];
        aspect.titleLabel.font            = [UIFont boldSystemFontOfSize: 12];
        aspect.titleLabel.lineBreakMode   = UILineBreakModeTailTruncation;
        aspect.titleLabel.textColor       = [UIColor blackColor];
        [aspectRatioMenu addSubview:aspect];
        //     [aspect release];
        //    aspect = nil;
        aspectRatioMenu.contentSize = CGSizeMake(aspectButtonWidth * index + 70.0, 50.0);
    }
#if CMTIPPOPVIEW_ENABLE
    /* add it on top of tipview */
    CMPopTipView *aspectRatioView = [[CMPopTipView alloc]initWithCustomView:aspectRatioMenu];
    aspectRatioView.backgroundColor = DARK_GRAY_BG;
    aspectRatioView.alpha = 0.5;
    aspectRatioView.tag = TAG_ASPECTRATIO_TIPVIEW;
    aspectRatioView.disableTapToDismiss = YES;
    
    [aspectRatioMenu release];
    UIBarButtonItem *bar = (UIBarButtonItem*)sender;
    [aspectRatioView presentPointingAtBarButtonItem:bar animated:YES];
#else
    aspectRatioView      = [[SNPopupView alloc]initWithContentView:aspectRatioMenu contentSize:aspectRatioMenu.frame.size];
    UIBarButtonItem *bar = (UIBarButtonItem*)sender;
    aspectRatioMenu.tag  = TAG_ASPECTRATIO_TIPVIEW;
    UIView *targetView   = (UIView *)[bar performSelector:@selector(view)];
    CGPoint tipPoint     = CGPointMake(targetView.center.x, targetView.frame.origin.y+targetView.frame.size.height);
    [aspectRatioView presentModalAtPoint:tipPoint inView:self.view];
#endif
}

#pragma mark save

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        NSLog(@"Successfuly saved the image");
    }
    else
    {
        /* update the status */
        NSLog(@"failed to save the image");
    }
    
    return;
}

-(void)saveImage
{
    UIImage *img = [sess.frame renderToImageOfSize:CGSizeMake(2400, 2400)];
    
    if(nil != img)
    {
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }
    else
    {
        NSLog(@"Image is NULL to save ");
    }
}

#pragma mark clear implementation
-(void)clearSessionAnimationStopedfinished:(BOOL)finished context:(void *)context
{
    int index = 0;
    for(index = 0; index < MAX_PHOTOS_SUPPORTED; index++)
    {
        UIImageView *v = (UIImageView*)[self.view viewWithTag:(index + TAG_CLEARANIMATION)];
        [v removeFromSuperview];
    }
    
    [sess updateTheSessionIcon];
}

-(void)clearCurImage
{
    @autoreleasepool {
        NSLog(@"clear sessions ");
        //UIBarButtonItem *dest             = (UIBarButtonItem*)sender;
        __block int             index             = 0;
        NSMutableArray *viewsForAnimation = [sess eraseCurImageAndReturnImageForAnimation];
        UIView *targetView                = (UIView *)[viewsForAnimation objectAtIndex:0];
        
        for(index = 0; index < [viewsForAnimation count]; index++)
        {
            UIImageView *img = [viewsForAnimation objectAtIndex:index];
            CGRect rect = [sess.frame convertRect:img.frame toView:self.view];
            img.frame   = rect;
            img.tag     = TAG_CLEARANIMATION + index;
            [self.view addSubview:img];
        }
        
        
        CAKeyframeAnimation *rotationAnimation;
        rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        rotationAnimation.values = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0 * M_PI],
                                    [NSNumber numberWithFloat:0.75 * M_PI],
                                    [NSNumber numberWithFloat:1.5 * M_PI],
                                    [NSNumber numberWithFloat:2.0 * M_PI], nil];
        rotationAnimation.calculationMode = kCAAnimationPaced;
        
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationAnimation.duration = 0.5;
        
        //    [UIView beginAnimations:@"ClearTheSessionAnimation" context:nil];
        //    [UIView setAnimationDelegate:self];
        //    [UIView setAnimationDidStopSelector:@selector(clearSessionAnimationStopedfinished:context:)];
        //    [UIView setAnimationDuration:0.5f];
        
        //    /* Now Animate the view */
        //    for(index = 0; index < [viewsForAnimation count]; index++)
        //    {
        //        UIImageView *img = [viewsForAnimation objectAtIndex:index];
        //        img.frame        = CGRectMake(targetView.center.x, targetView.center.y, 0, 0);
        //        [img.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        //        //img.frame        = targetView.frame;
        //    }
        //    [UIView commitAnimations];
        
        //  [viewsForAnimation release];
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            /* Now Animate the view */
            for(index = 0; index < [viewsForAnimation count]; index++)
            {
                UIImageView *img = [viewsForAnimation objectAtIndex:index];
                img.frame        = CGRectMake(targetView.center.x, targetView.center.y, 0, 0);
                [img.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                //img.frame        = targetView.frame;
            }
        }
                         completion:^(BOOL finished){
            int i = 0;
            for(i = 0; i < MAX_PHOTOS_SUPPORTED; i++)
            {
                UIImageView *v = (UIImageView*)[self.view viewWithTag:(index + TAG_CLEARANIMATION)];
                [v removeFromSuperview];
            }
            
            [sess updateTheSessionIcon];
        }];
        
    }
}

-(void)clearTheSession:(id)sender
{
    @autoreleasepool {
        UIBarButtonItem *dest             = (UIBarButtonItem*)sender;
        __block int             index             = 0;
        NSMutableArray *viewsForAnimation = [sess eraseAndReturnImagesForAnimation];
        UIView *targetView                = (UIView *)[dest performSelector:@selector(view)];
        
        for(index = 0; index < [viewsForAnimation count]; index++)
        {
            UIImageView *img = [viewsForAnimation objectAtIndex:index];
            CGRect rect = [sess.frame convertRect:img.frame toView:self.view];
            img.frame   = rect;
            img.tag     = TAG_CLEARANIMATION + index;
            [self.view addSubview:img];
        }
        
        
        CAKeyframeAnimation *rotationAnimation;
        rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        rotationAnimation.values = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0 * M_PI],
                                    [NSNumber numberWithFloat:0.75 * M_PI],
                                    [NSNumber numberWithFloat:1.5 * M_PI],
                                    [NSNumber numberWithFloat:2.0 * M_PI], nil];
        rotationAnimation.calculationMode = kCAAnimationPaced;
        
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationAnimation.duration = 0.5;
        
        //    [UIView beginAnimations:@"ClearTheSessionAnimation" context:nil];
        //    [UIView setAnimationDelegate:self];
        //    [UIView setAnimationDidStopSelector:@selector(clearSessionAnimationStoped:finished:context:)];
        //    [UIView setAnimationDuration:0.5f];
        
        /* Now Animate the view */
        //    for(index = 0; index < [viewsForAnimation count]; index++)
        //    {
        //        UIImageView *img = [viewsForAnimation objectAtIndex:index];
        //        img.frame        = CGRectMake(targetView.center.x, targetView.center.y, 0, 0);
        //        [img.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        //        //img.frame        = targetView.frame;
        //    }
        //    [UIView commitAnimations];
        // [viewsForAnimation release];
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            for(index = 0; index < [viewsForAnimation count]; index++)
            {
                UIImageView *img = [viewsForAnimation objectAtIndex:index];
                img.frame        = CGRectMake(targetView.center.x, targetView.center.y, 0, 0);
                [img.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                //img.frame        = targetView.frame;
            }
        }
                         completion:^(BOOL finished){
            int i = 0;
            for(i = 0; i < MAX_PHOTOS_SUPPORTED; i++)
            {
                UIImageView *v = (UIImageView*)[self.view viewWithTag:(index + TAG_CLEARANIMATION)];
                [v removeFromSuperview];
            }
            
            [sess updateTheSessionIcon];
        }];
    }
}

#pragma mark help implementation
-(void)perform_Help
{
    //    helpScreen = [[HelpScreenViewController alloc] init];
    //    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && full_screen.size.height== 812)
    //    {
    //        NSLog(@"Iphone x---ok");
    //        helpScreen.view.frame = CGRectMake(0, 0,250,250);
    //        helpScreen.view.center = CGPointMake(full_screen.size.width*0.32, full_screen.size.height*0.5) ;
    //    }
    
    //here leak is there
    // @autoreleasepool {
    
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
        isTouchWillDetect = NO;
        // here leak is there
        //                            [self.view addSubview:helpScreen.view];
        //                            [self.view bringSubviewToFront:helpScreen.view];
        //
    }
                    completion:nil ];
}



//}

#pragma utility functions mainly to clean the resources
-(void)releaseToolBarIfAny
{
    [self removeviewforEffectsBack]; //newly added
    UIToolbar *toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_EDIT];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_FRAMES];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_SWAP];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_SHARE];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_FREEAPPS];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_ADJUST];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_PREVIEW];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_SETTINGS];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_EFFECT];
    if (nil!= toolBar) {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
}




-(void)allocateResourcesForEdit
{
    [self releaseToolBarIfAny];
    if(changeTitle)
        self.title = @"Save or Share";
    else
        self.title = @"Images or Videos";
    [self assignRightBarButtonItem];
//    if(nil == sess)
//    {
//        [self loadTheSession];
//    }else{
//        [sess showSessionOn:mainBackground];//self.view
//    }
    
    //// We have to check it
    //// Major change the for effects applied - to set original image itself
    // [self SetOriginalImageForAllFrames];
    
    [self CheckIfAllFramesFilled];
    [self setupTrashBin];
    [self setupSlider];
    [self BringAllStickersTextviewFront];
    return;
}

-(void)SetOriginalImageForAllFrames
{
    for (int phototIndex = 0; phototIndex<sess.frame.photoCount; phototIndex++)
    {
        UIImage *image = [sess getOriginalImageAtIndex:phototIndex];
        /*replace image with old image and save it*/
        [sess saveImage:image atIndex:phototIndex];
        Photo *pht = [sess.frame getPhotoAtIndex:phototIndex];
        if (pht.view.imageView.image != nil)
        {
            pht.view.imageView.image = nil;
            pht.view.imageView.image = image;
            [pht.view.imageView setNeedsDisplay];
        }
    }
}

-(void)selectEditTab
{
#if STANDARD_TABBAR
    UITabBarItem *edit = (UITabBarItem*)[[tabBar items] objectAtIndex:1];
    [self tabBar:tabBar didSelectItem:edit];
    [tabBar setSelectedItem:edit];
#else
    //[customTabBar setSelectedItem:1];
    //in this method leaks are there
    [self releaseResourcesForModeChange];
    // [customTabBar unselectCurrentSelectedTab];
    
    [self allocateResourcesForEdit];
    //in this method leaks are there
    
    eMode = MODE_MAX;
#endif
}

-(void)frameSelectedAtIndex:(int)index ofGridView:(FrameGridView *)gView
{
    NSLog(@"Frame selected at index");
  //  sess.initialization = NO;
    sess.frameNumber   = index;
    sess. frameWidth   = 10.0;
    sess .innerRadius = 0.0;
    sess .outerRadius = 0.0;
    [sess initAspectRatio:ASPECTRATIO_1_1];

    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(selectEditTab) userInfo:nil repeats:NO];
}

- (void)allocateResourcesForFrames
{
    
    // Properly initializing the FrameSelectionController
    FrameSelectionController *sc = [[FrameSelectionController alloc] init];
    
    if (nil == sc) {
        return;
    }
    
    // Push the new FrameSelectionController onto the navigation stack
    [self.navigationController pushViewController:sc animated:NO];
    
    return;
}



-(void)releaseResourcesForFrames
{
    
    /* Release tool bar if available */
    [self releaseToolBarIfAny];
    
#if defined(APP_INSTAPICFRAMES)
    /* release grid view */
    FrameGridView *fgv = (FrameGridView*)[self.view viewWithTag:TAG_EVENFRAME_GRIDVIEW];
    if(nil != fgv)
    {
        [fgv removeFromSuperview];
    }
#endif
    
    self.navigationController.navigationBarHidden = NO;
    [sess showSessionOn:mainBackground];//self.view
    
#if defined(APP_INSTAPICFRAMES)
    self.title = NSLocalizedString(@"APPNAME",@"InstapicFrames");
#elif defined(APP_PICCELLS)
    self.title = @"PicCells";
#endif
}



-(void)togglePreviewState:(UIButton*)sender
{
    
    if(sender.tag == TAG_PREVIEW_PAUSE)
    {
        sender.tag = TAG_PREVIEW_PLAY;
        [sender setImage:[UIImage imageNamed:@"playNew"] forState:UIControlStateNormal];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [sender setImage:[UIImage imageNamed:@"play_ipad"] forState:UIControlStateNormal];
        }
        [self pausePreView];
    }
    else if(sender.tag == TAG_PREVIEW_PLAY)
    {
        sender.tag = TAG_PREVIEW_PAUSE;
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [sender setImage:[UIImage imageNamed:@"pause_ipad"] forState:UIControlStateNormal];
            
        }
        [self resumePreview];
    }
}



-(NSString*)getCurrentPreviewTime
{
    int totalTime = gTotalPreviewFrames * (1.0/30.0);
    int elapsedTime= 0;
    if (isSequentialPlay) {
        elapsedTime = gPreviewFrameCounterVariable * (1.0/30.0);
    }else
    {
        elapsedTime =  gCurPreviewFrameIndex*(1.0/30.0);
    }
    int remainingSeconds = totalTime-elapsedTime;
    
    int mins = remainingSeconds/60;
    int seconds = remainingSeconds%60;
    
    return [NSString stringWithFormat:@"%d:%d",mins,seconds];
}


-(UIView*)allocateVideoSettingsCellWithRect:(CGRect)rect
{
    UIImageView *bgnd = [[UIImageView alloc]initWithFrame:rect];
    UIImageView *color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgnd.frame.size.width, bgnd.frame.size.height)];
    color.backgroundColor = [UIColor blackColor];
    //color.backgroundColor = [UIColor colorWithRed:102/255.0 green:154/255.0 blue:174/255.0 alpha:1.0];
    //color.backgroundColor=[UIColor whiteColor];
    [bgnd addSubview:color];
    // [color release];
    
    /* Enable user interaction for the views */
    bgnd.userInteractionEnabled = YES;
    color.userInteractionEnabled = YES;
    
    return bgnd;
}

-(UIView*)allocateVideoSettingsCellWithRect:(CGRect)rect
                                      title:(NSString*)title
{
    UIView *cell = [self allocateVideoSettingsCellWithRect:rect];
    /* Add title to it */
    UILabel *songTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    songTitle.backgroundColor = [UIColor clearColor];
    songTitle.text = title;
    songTitle.textColor = [UIColor whiteColor];
    songTitle.font = [UIFont boldSystemFontOfSize:16];
    songTitle.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:songTitle];
    // [songTitle release];
    cell.userInteractionEnabled = YES;
    
    return cell;
}

-(UIView*)allocateVideoSettingsCellWithRect:(CGRect)rect
                                      title:(NSString*)title
                                      image:(UIImage*)img
                                     enable:(BOOL)enableStatus
{
    NSLog(@"allocate Video Settings Cell With Rect");
    UIView *cell         = [self allocateVideoSettingsCellWithRect:rect];
    float   imageSize    = cell.frame.size.height;
    float   switchWidth  = cell.frame.size.height + 10;
    float   switchHeight = cell.frame.size.height;
    int   imageBoderSize = 5;
    
    /* Add title to it */
    UILabel *songTitle = [[UILabel alloc]initWithFrame:CGRectMake(imageSize, 0, cell.frame.size.width-imageSize-switchWidth, cell.frame.size.height)];
    songTitle.backgroundColor = [UIColor clearColor];
    songTitle.text = title;
    songTitle.textColor = [UIColor whiteColor];
    songTitle.font = [UIFont boldSystemFontOfSize:16];
    songTitle.textAlignment = UITextAlignmentCenter;
    songTitle.tag = TAG_AUDIO_CELL_TITLE;
    [cell addSubview:songTitle];
    //   [songTitle release];
    
    /* Add image to it */
    UIImageView *albumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageBoderSize, imageBoderSize, imageSize-imageBoderSize-imageBoderSize, imageSize-imageBoderSize-imageBoderSize)];
    albumImageView.image = img;
    albumImageView.tag = TAG_AUDIO_CELL_IMAGE;
    [cell addSubview:albumImageView];
    //   [albumImageView release];
    
    
    /* Add switch */
    UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(cell.frame.size.width-switchWidth, 15, switchWidth, switchHeight)];
    swit.on = enableStatus;
    swit.tag = TAG_AUDIO_CELL_SWITCH;
    //[swit setOnTintColor: [UIColor blueColor]];
    // 25, 184, 250
    swit.tintColor = [UIColor colorWithRed:25.0/255.0 green:184.0/255.0 blue:250.0/255.0 alpha:1.0];
    swit.onTintColor = [UIColor colorWithRed:25.0/255.0 green:184.0/255.0 blue:250.0/255.0 alpha:1.0];
    
    [cell addSubview:swit];
    
    /* Add action to switch */
    [swit addTarget:self
             action:@selector(handleUpadteAudioFromLibraraySwitchStatus:)
   forControlEvents:UIControlEventValueChanged];
    
    // [swit release];
    
    return cell;
}

-(UIView*)allocateSquentialPlayButtonCellWithRect:(CGRect)rect  enable:(BOOL)enableStatus
{
    UIView *cell         = [self allocateVideoSettingsCellWithRect:rect];
    float   labelSize    = cell.frame.size.height;
    float   switchWidth  = cell.frame.size.height + 10;
    float   switchHeight = cell.frame.size.height;
    
    
    UILabel *songTitle = [[UILabel alloc]initWithFrame:CGRectMake(labelSize, 0, cell.frame.size.width-labelSize-switchWidth, cell.frame.size.height)];
    songTitle.backgroundColor = [UIColor clearColor];
    songTitle.text = @"SequentialPlay";
    songTitle.textColor = [UIColor whiteColor];
    songTitle.font = [UIFont boldSystemFontOfSize:16];
    songTitle.textAlignment = UITextAlignmentCenter;
    // songTitle.tag = TAG_AUDIO_CELL_TITLE;
    [cell addSubview:songTitle];
    //   [songTitle release];
    
    /* Add switch */
    UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(cell.frame.size.width-switchWidth, 15, switchWidth, switchHeight)];
    swit.on = enableStatus;
    swit.tag = TAG_SQUENTIAL_CELL_SWITCH;
    // swit.tintColor = [UIColor colorWithRed:25/255 green:184/255 blue:250/255 alpha:1.0];
    swit.tintColor = [UIColor colorWithRed:25.0/255.0 green:184.0/255.0 blue:250.0/255.0 alpha:1.0];
    swit.onTintColor = [UIColor colorWithRed:25.0/255.0 green:184.0/255.0 blue:250.0/255.0 alpha:1.0];
    /* Add action to switch */
    [swit addTarget:self
             action:@selector(handleUpdateFromSquentialPlaySwitchStatus:)
   forControlEvents:UIControlEventValueChanged];
    [cell addSubview:swit];
    
    // [swit release];
    
    return cell;
    
}

-(void)callAudioRefresh
{
    NSDictionary *userInfo = nil;
    NSURL *audioUrl;
    BOOL useLibraryAudio = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY] boolValue];
    if (useLibraryAudio) {
        NSNumber *persistentId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
        
        if(persistentId != nil)
        {
            MPMediaItem *mItem = [self getMediaItemFromMediaItemId:persistentId];
            audioUrl = [mItem valueForProperty:MPMediaItemPropertyAssetURL];
        }
        else
        {
            audioUrl = [[NSUserDefaults standardUserDefaults] URLForKey:KEY_AUDIOURL_SELECTED_FROM_FILES];
        }
        userInfo = @{@"audioURL": audioUrl};
        NSLog(@"audioURL %@",audioUrl);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAdditionalAudioToPlayer"
                                                          object:self
                                                        userInfo:userInfo];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MuteMasterAudioPlayer"
                                                          object:self
                                                        userInfo:self];
    }
    
    
}

-(void)handleUpadteAudioFromLibraraySwitchStatus:(UISwitch*)swit
{
    /* Store enable status */
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:swit.on]
                                             forKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY];
    [self callAudioRefresh];
    [sess handleVideoFrameSettingsUpdate];
    [sess deleteCurrentAudioMix];
    NSLog(@"after pick deleting-----6");
    //audio is deleting here//
}


-(void)handleUpdateFromSquentialPlaySwitchStatus:(UISwitch *)swt
{
    if (swt.on)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:swt.on]
                                                 forKey:KEY_USE_SEQUENTIAL_Play_STATUS];
        
        swt.tintColor = [UIColor colorWithRed:25.0/255.0 green:184.0/255.0 blue:250.0/255.0 alpha:1.0];
        swt.onTintColor = [UIColor colorWithRed:25.0/255.0 green:184.0/255.0 blue:250.0/255.0 alpha:1.0];
        isSequentialPlay = TRUE;
        [self setTheDefaultOrderArray];
        UIImageView *settingImageView = (UIImageView *)[self.view viewWithTag:TAG_VIDEOSETTINGS_BGPAD];
        CGRect rect = CGRectMake(0,settingImageView.frame.origin.y , full_screen.size.width, 0);
        [self addVideoGrid:rect];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:swt.on]
                                                 forKey:KEY_USE_SEQUENTIAL_Play_STATUS];
        isSequentialPlay = FALSE;
        UIImageView *gridBackGroundView = (UIImageView *)[self.view viewWithTag:TAG_VIDEOGRIDVIEW];
        
        [gridBackGroundView removeFromSuperview];
    }
    
    [sess handleVideoFrameSettingsUpdate];
    
    [sess deleteCurrentAudioMix];
    NSLog(@"after pick deleting-----7");
    //audio is deleting here//
    
}

-(void)addVideoGrid:(CGRect) aRect
{
    [videoImageInfo removeAllObjects];
    [sess handleVideoFrameSettingsUpdate];
    [sess deleteCurrentAudioMix];
    NSLog(@"after pick deleting-----8");
    //audio is deleting here//
    
    if ( dictionary != nil) {
        [dictionary removeAllObjects];
        //  [dictionary release];
        dictionary = nil;
    }
    dictionary = [[NSMutableDictionary alloc] init];
    int photoIndex = 0;
    for (int index = 0; index<sess.frame.photoCount; index++)
    {
        eFrameResourceType type = [sess getFrameResourceTypeAtIndex:index];
        
        if (type == FRAME_RESOURCE_TYPE_VIDEO)
        {
            UIImage *image;
            if(effectsApplied)
                image = [sess getEffectVideoFrameAtIndex:1 forPhoto:index];
            else
                image = [sess getVideoFrameAtIndex:1 forPhoto:index];
            if(image != nil)
            {
                [videoImageInfo addObject:image];
            }
            [dictionary setObject:[NSNumber numberWithInt:index] forKey:[NSNumber numberWithInt:photoIndex]];
            photoIndex++;
            
        }
    }
    if (photoIndex == 0) {
        return;
    }
    [WCAlertView showAlertWithTitle:@"Help" message:@"To select video longpress on video item and move using your finger to alter order of videos" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    UIImageView *gridBackGroundView ;
    
    // Remove if already added
    gridBackGroundView = (UIImageView *)[self.view viewWithTag:TAG_VIDEOGRIDVIEW];
    if(gridBackGroundView)
        [gridBackGroundView removeFromSuperview];
    
    
    gridBackGroundView = [[UIImageView alloc] init];
    gridBackGroundView . userInteractionEnabled = YES;
    gridBackGroundView . backgroundColor = PHOTO_DEFAULT_COLOR;
    gridBackGroundView . tag   =  TAG_VIDEOGRIDVIEW;
    gridBackGroundView . frame = CGRectMake(0,aRect.origin.y, aRect.size.width, 0);
    gridBackGroundView . image = [UIImage imageNamed:@"1gridPopupBg2.png"];
    // gridBackGroundView . layer . borderColor = [UIColor colorWithRed:127/255.0 green:181/255.0 blue:202/255.0 alpha:1.0].CGColor;
    gridBackGroundView . layer . borderColor =  PHOTO_DEFAULT_COLOR.CGColor;
    //change here PHOTO_DEFAULT_COLOR
    
    gridBackGroundView . layer . borderWidth = 2.0;
    [self.view addSubview:gridBackGroundView];
    
    //    [videoImageInfo retain];
    
    if (gridView != nil)
    {
        [gridView.view removeFromSuperview];
        gridView = nil;
    }
    gridView = [[VideoGridViewViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    gridView . frameOfView = CGRectMake(0, 0, full_screen.size.width, videoGridViewHeight);
    gridView.totalNumberOfItems = (int)[videoImageInfo count];
    gridView . imageArray = videoImageInfo;
    
    if ([orderArrayForVideoItems count]>0)
    {
        [orderArrayForVideoItems removeAllObjects];
    }
    
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        gridBackGroundView . frame =   CGRectMake(0, aRect.origin.y-videoGridViewHeight, full_screen.size.width, videoGridViewHeight);
        
    }completion:^(BOOL finished)
     {
        [gridBackGroundView addSubview:gridView.view];
        
    }];
}

-(void)setTheDefaultOrderArray
{
    NSLog(@"set TheDefault OrderArray");
    if ([orderArrayForVideoItems count]>0)
    {
        [orderArrayForVideoItems removeAllObjects];
    }
    for (int index = 0; index<sess.frame.photoCount; index++)
    {
        eFrameResourceType type = [sess getFrameResourceTypeAtIndex:index];
        
        if (type == FRAME_RESOURCE_TYPE_VIDEO)
        {
            NSLog(@"ORDER OF ARRAY :%@", orderArrayForVideoItems);
            [orderArrayForVideoItems addObject:[NSNumber numberWithInt:index]];
        }
    }
}


-(void)audioCell:(UIView*)cell setTitle:(NSString*)title
{
    NSLog(@"audio cell title %@",title);
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:TAG_AUDIO_CELL_TITLE];
    if(nil == titleLabel)
    {
        return;
    }
    
    titleLabel.text = title;
    [titleLabel setNeedsLayout];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return;
}

-(void)audioCell:(UIView*)cell setImage:(UIImage*)image
{
    NSLog(@"audio cell set image");
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:TAG_AUDIO_CELL_IMAGE];
    if(nil == imgView)
    {
        NSLog(@"imageView is nil");
        return;
    }
    
    imgView.image = image;
    [imgView setNeedsLayout];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return;
}

-(void)audioCell:(UIView*)cell setStatus:(BOOL)enableStatus
{
    NSLog(@"audio cell Status is %@ ",enableStatus?@"YES":@"NO");
    UISwitch *swit = (UISwitch*)[cell viewWithTag:TAG_AUDIO_CELL_SWITCH];
    if(nil == swit)
    {
        return;
    }
    
    swit.on = enableStatus;
    
    /* Store enable status */
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:enableStatus]
                                             forKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY];
    [swit setNeedsLayout];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return;
}


- (BOOL)isAppleMusicAppInstalled {
    if (@available(iOS 10.0, *)) {
        NSURL *url = [NSURL URLWithString:@"music://"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"Music app is not actually installed");
            }
        }];
        // Unfortunately we have to rely on the completion handler
        // The canOpenURL: will still return YES
        return [[UIApplication sharedApplication] canOpenURL:url];
    } else {
        // Fallback for earlier versions
        return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"music://"]];
    }
}

// Present the document picker
- (void)presentAudioDocumentPickerFrom:(UIViewController *)viewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Only available on iOS 14+
        UTType *audioType = [UTType typeWithIdentifier:@"public.audio"];
        
        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[audioType] asCopy:YES];
        picker.delegate = self;
        picker.allowsMultipleSelection = NO;
        
        [viewController presentViewController:picker animated:YES completion:nil];
    });
}

-(void)showAudioPicker
{
    [self presentAudioDocumentPickerFrom:self];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        BOOL isMusicAppInstalled = [self isAppleMusicAppInstalled]; //[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"music://"]];
    //       // BOOL musicAppInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"music:"]];
    //
    //        if (!isMusicAppInstalled) {
    //            NSLog(@"Apple Music app is NOT installed.");
    //            // Show alert to indicate to install apple music app
    //          //  [WCAlertView showAlertWithTitle:@"Oops.." message:@"Please make sure Apple Music app is installed" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //            [self presentAudioDocumentPickerFrom:self];
    //        }
    //        else
    //        {
    //            NSLog(@"Apple Music app is installed.");
    //            MPMediaPickerController *picker =
    //            [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    //
    //            picker.delegate                     = self;
    //            picker.allowsPickingMultipleItems   = NO;
    //            picker.prompt                       = NSLocalizedString (@"Select any song from the list", @"Prompt to user to choose some songs to play");
    //
    //            //[self presentModalViewController: picker animated: YES];
    //            [self presentViewController:picker animated:NO completion:nil];
    //            //  [picker release];
    //        }
    //    });
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        UTType *audioType = [UTType typeWithIdentifier:@"public.audio"];
    //        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[audioType]];
    //        picker.delegate = self;
    //        picker.allowsMultipleSelection = NO;
    //        [self presentViewController:picker animated:YES completion:nil];
    //    });
}



//- (void)getAudioMetadataFromURL:(NSURL *)audioURL completion:(void (^)(NSString *title, UIImage *artworkImage))completion {
//
//    // Create an AVAsset from the audio file URL
//    AVAsset *asset = [AVAsset assetWithURL:audioURL];
//
//    // Load the metadata from the audio file asynchronously
//    [asset loadValuesAsynchronouslyForKeys:@[@"commonMetadata"] completionHandler:^{
//        // Get the common metadata items (title, artwork, etc.)
//        NSArray *metadata = [asset commonMetadata];
//
//        NSString *title = nil;
//        UIImage *artworkImage = nil;
//
//        for (AVMetadataItem *item in metadata) {
//            if ([item.commonKey isEqualToString:AVMetadataCommonKeyTitle]) {
//                title = (NSString *)item.value;
//            } else if ([item.commonKey isEqualToString:AVMetadataCommonKeyArtwork]) {
//                // Extract artwork data
//                NSData *artworkData = (NSData *)item.value;
//                if (artworkData) {
//                    artworkImage = [UIImage imageWithData:artworkData];
//                }
//            }
//        }
//
//        // Return the extracted title and artwork via the completion handler
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(title, artworkImage);
//        });
//    }];
//}
//
//
//- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
//    NSURL *audioURL = urls.firstObject;
//    NSLog(@"Picked audio file: %@", audioURL.path);
//    // Handle or play the selected audio file
//    [self getAudioMetadataFromURL:audioURL completion:^(NSString *title, UIImage *artworkImage) {
//        if (title) {
//            NSLog(@"Title: %@", title);
//            [self audioCell:musicTrackCell setTitle:title];
//        }
//
//        if (artworkImage) {
//            // You can display the artwork image in an image view, for example:
//            [self audioCell:musicTrackCell setImage:artworkImage];
//        }
//    }];
//}
//
//// Called when user cancels the picker
//- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
//    NSLog(@"User canceled audio picker");
//    [controller dismissViewControllerAnimated:YES completion:nil];
//}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    // [self dismissModalViewControllerAnimated: YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(NSURL*)getUrlFromMediaItemId:(NSNumber*)persistentId
{
    /* Get the title from the media item */
    MPMediaItem *mItem = [self getMediaItemFromMediaItemId:persistentId];
    
    return [mItem valueForProperty:MPMediaItemPropertyAssetURL];
}

-(UIImage*)getImageFromMediaItem:(MPMediaItem*)mItem
{
    /* Extract artwork and title and assign it to Audio Cell */
    MPMediaItemArtwork *itemArtwork = [mItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artWorkImage = nil;
    
    if (itemArtwork != nil)
    {
        artWorkImage = [itemArtwork imageWithSize:CGSizeMake(250.0, 250.0)];
    }
    
    return artWorkImage;
}

-(NSString*)getTitleFromMediaItem:(MPMediaItem*)mItem
{
    NSString *title = [mItem valueForProperty:MPMediaItemPropertyTitle];
    
    return title;
}

-(MPMediaItem*)getMediaItemFromMediaItemId:(NSNumber*)persistentId
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"MusicLibraryPermission"] == 1)
    {
        MPMediaQuery *query = [MPMediaQuery songsQuery];
        MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:persistentId
                                                                               forProperty:MPMediaItemPropertyPersistentID];
        [query addFilterPredicate:predicate];
        
        /* Query for media items */
        NSArray *mediaItems = [query items];
        NSLog(@" Media item :%@", mediaItems);
        if(nil == mediaItems || [mediaItems count]==0)
        {
            return nil;
        }
        
        /* Get the title from the media item */
        MPMediaItem *mediaItem = [mediaItems objectAtIndex:0];
        
        return mediaItem;
    }
    else{
        [self checkMediaLibraryPermissions];
    }
}

-(NSString*)getTitleFromMediaItemId:(NSNumber *)persistentId
{
    /* Get the title from the media item */
    MPMediaItem *mediaItem = [self getMediaItemFromMediaItemId:persistentId];
    
    return [self getTitleFromMediaItem:mediaItem];
}

-(UIImage*)getImageFromMediaItemId:(NSNumber *)persistentId
{
    /* Get the title from the media item */
    MPMediaItem *mediaItem = [self getMediaItemFromMediaItemId:persistentId];
    
    return [self getImageFromMediaItem:mediaItem];
}

//-(void)reshowPopoverForVideoSettings:(NSTimer*)timer
//{
//    if([customTabBar isTabbarBusy])
//    {
//        return;
//    }
//
//    [timer invalidate];
//
//    [customTabBar setSelectedItem:MODE_VIDEO_SETTINGS];
//
//}

- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    BOOL selectedAudioForFirstTime = NO;
    frameIsEdited = YES;
    [sess deleteCurrentAudioMix];
    NSLog(@"after pick deleting-----9");
    //audio is deleting here//
    
    /* Save MPMediaItem persistent ID */
    MPMediaItem *mediaItem = [[mediaItemCollection items]objectAtIndex:0];
    NSNumber *persistentId = [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
    
    /* if we are seleting music for the first time then we need to reopen the popover */
    if(nil == [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY])
    {
        selectedAudioForFirstTime = YES;
        [popOver dismiss];
    }
    
    /* save persistent ID of the current selected Item */
    [[NSUserDefaults standardUserDefaults] setObject:persistentId
                                              forKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
    
    
    if(selectedAudioForFirstTime)
    {
        //        [NSTimer scheduledTimerWithTimeInterval:1.0
        //                                         target:self
        //                                       selector:@selector(reshowPopoverForVideoSettings:)
        //                                       userInfo:nil
        //                                        repeats:YES];
    }
    else
    {
        /* Extract artwork and title and assign it to Audio Cell */
        MPMediaItem *item = [[mediaItemCollection items]objectAtIndex:0];
        MPMediaItemArtwork *itemArtwork = [item valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *artWorkImage = nil;
        
        if (itemArtwork != nil)
        {
            artWorkImage = [itemArtwork imageWithSize:CGSizeMake(250.0, 250.0)];
            if(nil != artWorkImage)
            {
                [self audioCell:musicTrackCell setImage:artWorkImage];
            }
        }
        
        NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
        if(nil != title)
        {
            [self audioCell:musicTrackCell setTitle:title];
        }
        
        [self audioCell:musicTrackCell setStatus:YES];
    }
    [self callRefresh];
    // [self dismissModalViewControllerAnimated: YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}

- (void)refreshAudioCell {
    NSNumber *mediaItemId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
    NSURL *audioUrl = [[NSUserDefaults standardUserDefaults] URLForKey:KEY_AUDIOURL_SELECTED_FROM_FILES];
    BOOL enableStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY] boolValue];
    
    // Remove old cell if exists
    if (musicTrackCell) {
        [musicTrackCell removeFromSuperview];
        musicTrackCell = nil;
    }
    UIView *settings = [self.view viewWithTag:TAG_VIDEOSETTINGS_BGPAD];
    UIView *selectAudio = [self.view viewWithTag:TAG_AUDIO_CELL_SELECT_AUDIO_RECT];
    
    // Create new cell if needed
    if (mediaItemId || audioUrl) {
        NSString *title = nil;
        UIImage *image = nil;
        
        if (mediaItemId) {
            title = [self getTitleFromMediaItemId:mediaItemId];
            image = [self getImageFromMediaItemId:mediaItemId];
        } else if (audioUrl) {
            title = audioUrl.lastPathComponent;
            image = [UIImage systemImageNamed:@"music.note"];
        }
        
        CGRect musicTrackRect = CGRectMake(0, 60+1.25, full_screen.size.width, 60);
        musicTrackCell = [self allocateVideoSettingsCellWithRect:musicTrackRect
                                                          title:title
                                                          image:image
                                                         enable:enableStatus];
        [settings addSubview:musicTrackCell];
    }
}

-(void)allocateResourcesForVideoSettings //:(OT_TabBarItem*)tItem
{
    NSLog(@"allocate Resources For Video Settings");
    [self releaseToolBarIfAny];
    
    // isVideoOrderChangedByUser = YES;
    
    /* Add settings title to toolbar */
    self.title = @"Music Settings";
    //[self addToolbarWithTitle:@"Video Settings" tag:TAG_TOOLBAR_SETTINGS];
   
    CGRect  settingsRect = CGRectMake(0, optionsView.view.frame.origin.y-180, full_screen.size.width, 180);
    CGRect selectSqlRect = CGRectMake(0, 0,
                                      settingsRect.size.width, 60);
   
    CGRect selectTrackRect = CGRectMake(0, 120+2.50,
                                        settingsRect.size.width, 60.0-1.25);
    
    
    /* Add touch sheild */
    CGRect full = [[UIScreen mainScreen]bounds];
    CGRect frameForTouchShieldView = CGRectMake(0, 0.0, full.size.width, optionsView.view.frame.origin.y+optionsView.view.frame.size.height+colorBackgroundBarHeightHeight);
    
    UIView *touchSheiled = [[UIView alloc]initWithFrame:frameForTouchShieldView];
    touchSheiled.tag = TAG_ADJUST_TOUCHSHEILD;
    touchSheiled.userInteractionEnabled = YES;
    [self.view addSubview:touchSheiled];
    // [touchSheiled release];
    
    
    
    UIImageView       *settings = nil;
    
    
    settings = [[UIImageView alloc]initWithFrame:CGRectMake(0, optionsView.view.frame.origin.y, full_screen.size.width, 0)];
    settings . tag = TAG_VIDEOSETTINGS_BGPAD;
    // settings . backgroundColor = [UIColor colorWithRed:127/255.0 green:181/255.0 blue:202/255.0 alpha:1.0];
    settings . backgroundColor = [UIColor colorWithRed:99/255.0 green:104/255.0 blue:117/255.0 alpha:1.0];
   
    
    settings.userInteractionEnabled = YES;
    [self.view addSubview:settings];
    
    
    NSURL *audioUrl = [[NSUserDefaults standardUserDefaults]
                       URLForKey:KEY_AUDIOURL_SELECTED_FROM_FILES];
    BOOL enableStatus = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY]boolValue];
    NSNumber *mediaItemId  = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
    CGRect  musicTrackRect = CGRectMake(0, 60+1.25, settingsRect.size.width, 60);
    NSLog(@"audio url from files %@",audioUrl);
    
    if(nil != mediaItemId)
    {
        
        NSString *musicTitle   = [self getTitleFromMediaItemId:mediaItemId];
        UIImage  *musicImage   = [self getImageFromMediaItemId:mediaItemId];
        
        /* Allocate music track cell */
        musicTrackCell = [self allocateVideoSettingsCellWithRect:musicTrackRect
                                                           title:musicTitle
                                                           image:musicImage
                                                          enable:enableStatus];
        
        
    }
    else if(audioUrl != NULL)
    {
        
        NSString *title = audioUrl.lastPathComponent;
        NSLog(@"title %@",title);
        UIImage *thumbnail = [UIImage systemImageNamed:@"music.note"]; // your default speaker/note icon
        /* Allocate music track cell */
        musicTrackCell = [self allocateVideoSettingsCellWithRect:musicTrackRect
                                                           title:title
                                                           image:thumbnail
                                                          enable:enableStatus];
    }
    else
    {
        settingsRect = CGRectMake(settingsRect.origin.x, optionsView.view.frame.origin.y-120,settingsRect.size.width, 120.0);
        selectTrackRect = CGRectMake(0, 60+1.25,settingsRect.size.width, 60.0);
    }
    
    
    
    /* Allocate select video button cell */
    UIView *selectMusic = [self allocateVideoSettingsCellWithRect:selectTrackRect
                                                            title:@"Select Music"];
    selectMusic.tag = TAG_AUDIO_CELL_SELECT_AUDIO_RECT;
    /* Add button to Select Music */
    UIButton *selectMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    selectMusicButton.showsTouchWhenHighlighted = YES;
    selectMusicButton.frame = selectMusic.frame;
    selectMusicButton.center = CGPointMake(selectMusic.center.x-selectMusic.frame.origin.x, selectMusic.center.y-selectMusic.frame.origin.y);
    selectMusicButton.tag = TAG_AUDIO_CELL_SELECT_AUDIO;
    //    [selectMusicButton addTarget:self action:@selector(showAudioPicker) forControlEvents:UIControlEventTouchUpInside];
    [selectMusicButton addTarget:self action:@selector(checkMediaLibraryPermissions) forControlEvents:UIControlEventTouchUpInside];
    /* Lets add popup with music items */
    selectMusic.userInteractionEnabled = YES;
    //    [selectMusicButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    //    [selectMusicButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    UIView *selectSquentialPlayView = [self allocateSquentialPlayButtonCellWithRect:selectSqlRect enable:isSequentialPlay];
    
    if (isSequentialPlay) {
        [self setTheDefaultOrderArray];
    }
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self allocateviewforEffectsBack];
        settings.frame = settingsRect;
        
    }completion:^(BOOL finished)
     {
        if (nil != mediaItemId || audioUrl != NULL)
        {
            [settings addSubview:musicTrackCell];
            //[musicTrackCell release];
        }
        [settings addSubview:selectSquentialPlayView];
        //selectSquentialPlayView.layer.cornerRadius = 15;
        //settings.layer.cornerRadius = 15;
        [settings addSubview:selectMusic];
        [selectMusic addSubview:selectMusicButton];
        //  [selectSquentialPlayView release];
        //  [selectMusic release];
        if (isSequentialPlay)
        {
            [self addVideoGrid:CGRectMake(0, settings.frame.origin.y, full_screen.size.width, videoGridViewHeight)];
        }
    }];
    //[self backButtonView];
    [self reAlignUI];
    return;
}

- (void)buttonTouchDown:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.alpha = 0.5; // Dim the button
    }];
}

- (void)buttonTouchUp:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.alpha = 1.0; // Restore original alpha
    }];
}





-(void)releaseResourcesForVideoSetttings
{
    NSLog(@"release Resources For Video Setttings");
    [self releaseToolBarIfAny];
    if(changeTitle)
        self.title = @"Save or Share";
    else
        self.title = @"Images or Videos";
    NSMutableArray *gridOrderArray = [gridView getOrderOfItem];
    NSLog(@"release Resources For Video Setttings ====> %lu ",[gridOrderArray count]);
    frameIsEdited = YES;
    for (int index = 0; index<[gridOrderArray count];index++)
    {
        NSNumber *element = [dictionary objectForKey:[gridOrderArray objectAtIndex:index]];
        [orderArrayForVideoItems addObject:element];
    }
    
    UIView *a  = (UIView*)[self.view viewWithTag:TAG_ADJUST_TOUCHSHEILD];
    if(nil != a)
    {
        [a removeFromSuperview];
    }
    UIImageView *gridBackGroundView = (UIImageView *)[self.view viewWithTag:TAG_VIDEOGRIDVIEW];
    if (isSequentialPlay)
    {
        [gridView.view removeFromSuperview];
        gridView  = nil;
        [gridBackGroundView removeFromSuperview];
    }
    UIImageView *settings = (UIImageView *)[self.view viewWithTag:TAG_VIDEOSETTINGS_BGPAD];
    NSArray *viewToRemove = [settings subviews];
    for (UIView *v in viewToRemove)
    {
        [v removeFromSuperview];
    }
    if (nil != settings)
    {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            settings.frame = CGRectMake(0, optionsView.view.frame.origin.y, full_screen.size.width, 0);
            
        }completion:^(BOOL finished)
         {
            //             [customTabBar unselectCurrentSelectedTab];
            [settings removeFromSuperview];
            //  [settings release];
        }];
    }
    [self SetOriginalUI];
}

-(void)releaseResourcesForSwap
{
    [self releaseToolBarIfAny];
    [sess.frame exitSwapMode];
}

-(void)allocateResourcesForSwap
{
    //    [self addToolbarWithTitle:NSLocalizedString(@"Swap Images", @"Swap Images") tag:TAG_TOOLBAR_SWAP];
    
    [sess.frame enterSwapMode];
}




-(void)perform_Cancel
{
    effectSelected = NO;
    
    for (int index = 0; index<sess.frame.photoCount; index++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:index];
        UIImage *image= nil;
        if ([sess getFrameCountForPhotoAtIndex:index]==0)
        {
            image = [sess getImageAtIndex:index];
        }else
        {
            image = [sess getImageAtIndex:index];
        }
        if (pht.view.imageView.image != nil)
        {
            pht.view.imageView.image = nil;
            pht.view.imageView.image = image;
            
            [pht.view.imageView setNeedsDisplay];
        }
    }
    [self closeButtonTapped];
}



// Save effects in differnt file location ///
- (void)applySelectedEffectToAllImages {
    
    effectBeingApplied = YES;
    frameIsEdited = YES;
    [sess exitTouchModeForSlectingImage];
    isTouchWillDetect = NO;
    generatingVideo = YES;
    effectSelected = NO; // new
    self.navigationController.navigationBar.hidden = YES;
    if([sess anyVideoFrameSelected])
    {
        [self performSelectorOnMainThread:@selector(addprogressBarWithMsg:) withObject:@"Applying effect" waitUntilDone:YES];
    }
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperationWithBlock:^{
        [self applyEffectAndSaveImage:^(BOOL isFinished) {
            
            if (isFinished) {
                isTouchWillDetect = YES;
                effectBeingApplied = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //self.navigationController.navigationBar.hidden = NO;
                    [self refreshNavigationBar];
                    NSLog(@"Enable navigationbar items assigned");
                });
                if([sess anyVideoFrameSelected])
                {
                    [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                }
                [self performSelectorOnMainThread:@selector(perform_Cancel) withObject:nil waitUntilDone:YES];
            }
        }];
    }];
    
    //  [operationQueue release];
    
    //  [self closeButtonTapped];
    //  [self SetOriginalUI];
}

- (void)enableLeftBarButtonItem {
    
    self.navigationItem.leftBarButtonItem.enabled = YES;
    NSLog(@"Enable the right button after video generation");
    self.navigationController.navigationBar.hidden = NO;
    [self assignRightBarButtonItem];
}

-(void)disableLeftBarButtonItem
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.leftBarButtonItem.enabled = NO;
        if(generatingVideo)
        {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        else{
            if (@available(iOS 16.0, *)) {
                self.navigationItem.rightBarButtonItem.hidden = YES;
            } else {
                // Fallback on earlier versions
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
    });
}

-(void)applyEffectAndSaveImage:(void (^)(BOOL isCompleted))complete
{
    NSString *currentVideoPath = [sess pathToCurrentVideo];
    NSLog(@"path to current video path %@",currentVideoPath);
    if(YES == [[NSFileManager defaultManager]fileExistsAtPath:currentVideoPath])
    {
        [[NSFileManager defaultManager]removeItemAtPath:currentVideoPath error:nil];
    }
    Effects *effect = [Effects alloc];
    int totalNoOfPhoto=0;
    int  currentFrameNumber = 0;
    int totalNumberOfFrames = 0;
    for (int photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
    {
        NSNumber *effectNo = [dictionaryOfEffectInfo objectForKey:[NSNumber numberWithInt:photoIndex]];
        
        if (nil == effectNo)
        {
            continue;
        }
        NSLog(@"effect nu %@",effectNo);
        totalNumberOfFrames = totalNumberOfFrames + [sess getFrameCountForPhotoAtIndex:photoIndex];
    }
    
    for (int phototIndex = 0; phototIndex<sess.frame.photoCount; phototIndex++)
    {
        
        totalNoOfPhoto++;
        NSNumber *effectNo = [dictionaryOfEffectInfo objectForKey:[NSNumber numberWithInt:phototIndex]];
        
        if (nil == effectNo)
        {
            continue;
        }
        if ([sess getFrameCountForPhotoAtIndex:phototIndex]==0)
        {
            NSLog(@"frame count 0");
            currentFrameNumber ++;
            //   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            @autoreleasepool {
                
                UIImage *image = [sess getImageAtIndex:phototIndex];
                
                if(effectNo.intValue == 0)
                {
                    image =  [sess getOriginalImageAtIndex:phototIndex];
                }
                else
                {
                    /* applly effect on image */
                    image = [effect applyCurrentSelectedCIFilterEffect:image withEffect:effectNo.intValue-1];
                    //[effect applyCurrentSelectedEffcect:image withEffect:effectNo.intValue-1];
                }
                /*replace image with old image and save it*/
                [sess saveImage:image atIndex:phototIndex];
                // [pool release];
            }
            continue;
        }
        for (int frameIndex = 0; frameIndex<[sess getFrameCountForPhotoAtIndex:phototIndex]; frameIndex++)
        {
            @autoreleasepool {
                //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                /* get images form photo */
                UIImage *image = [sess getVideoFrameAtIndex:frameIndex forPhoto:phototIndex];
                UIImage* processedImage;
                if(effectNo.intValue == 0)
                {
                    processedImage =  [sess getOriginalImageAtIndex:phototIndex];
                    /* replace effect applied image with old image */
                    [sess saveImageAfterApplyingEffect:image atPhotoIndex:phototIndex atFrameIndex:frameIndex];
                }
                else
                {
                    /* apply effect on image */
                    processedImage = [effect applyCurrentSelectedEffcect:image withEffect:effectNo.intValue-1];
                    /* replace effect applied image with old image */
                    [sess saveImageAfterApplyingEffect:processedImage atPhotoIndex:phototIndex atFrameIndex:frameIndex];
                }
                if (frameIndex == 0) {
                    NSLog(@"frame index is 0");
                   // [sess saveImage:processedImage atIndex:phototIndex];
                    [sess saveImageAfterApplyingEffect:processedImage atPhotoIndex:phototIndex atFrameIndex:frameIndex];
                }
                currentFrameNumber++;
                
                float prg = (float)currentFrameNumber/(float)totalNumberOfFrames;
                //  dispatch_async(dispatch_get_main_queue(), ^{
                
                // update your UI here
                // [self updateProgress:[NSNumber numberWithFloat:prg]];
                [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:prg] waitUntilDone:YES];
                
            }
            // });
            //   [pool release];
        }
        
    }
    if (totalNoOfPhoto==sess.frame.photoCount )
    {
        complete(YES);
        
    }else
    {
        complete(NO);
    }
}


-(void)addAnimationToProButton:(UIButton *)aButton
{
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = 0.5;
    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.2];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = FLT_MAX;
    [aButton.layer addAnimation:pulseAnimation forKey:nil];
}


-(void)open_ProVersion
{
    //    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    UIView *backgroundView = [[UIView alloc] initWithFrame:fullScreen];
    backgroundView . tag = 5000;
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]];
    
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
        [self.view addSubview:backgroundView];
    }
                    completion:NULL];
    
    
    UIImageView *proImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,fullScreen.size.width , fullScreen.size.height)];
    [proImageView setImage:[UIImage imageNamed:@"ProAd.png"]];
    
    if ([UIDevice currentDevice].userInterfaceIdiom== UIUserInterfaceIdiomPhone && fullScreen.size.height>480)
    {
        [proImageView setImage:[UIImage imageNamed:@"ProAd1136.png"] ];
        
    }else if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [proImageView setImage:[UIImage imageNamed:@"ProAd~ipad.png"]];
    }
    [backgroundView addSubview:proImageView];
    
    UIButton *bigInstall = [UIButton buttonWithType:UIButtonTypeCustom];
    bigInstall . frame = proImageView.frame;
    //[bigInstall setImage:[UIImage imageNamed:@"install.png"] forState:UIControlStateNormal];
    [bigInstall addTarget:self action:@selector(openProApp) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:bigInstall];
    
    UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crossButton . frame = CGRectMake(fullScreen.size.width- ad_x, ad_y, ad_size, ad_size);
    [crossButton setImage:[UIImage imageNamed:@"close_ad.png"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:crossButton];
    
    UIButton *installButton = [UIButton buttonWithType:UIButtonTypeCustom];
    installButton . frame = CGRectMake(ad_x, ad_y+20, install_size_width, ad_size);
    [installButton setImage:[UIImage imageNamed:@"install.png"] forState:UIControlStateNormal];
    [installButton addTarget:self action:@selector(openProApp) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:installButton];
}

-(void)openProApp
{
    NSURL *proUrl = [NSURL URLWithString:ituneslinktoProVersion];
    if([[UIApplication sharedApplication]canOpenURL:proUrl])
    {
        // [[UIApplication sharedApplication] openURL:proUrl];
        [self Open_URL:ituneslinktoProVersion];
    }
}

-(void)Open_URL:(NSString*) urlStr
{
    NSURL* url =[NSURL URLWithString: urlStr];
    
    [[UIApplication sharedApplication] openURL:url
                                       options:@{}
                             completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"URL was opened successfully.");
        } else {
            NSLog(@"Failed to open URL.");
        }
    }];
}

-(void)closeView
{
    UIView *viewToClose =(UIView *)[self.view viewWithTag:5000];
    [UIView transitionWithView:viewToClose
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
        [viewToClose removeFromSuperview];
    }
                    completion:Nil];
    viewToClose = nil;
    
}

-(void)handleResolutionOptionSelection:(KxMenuItem*)item
{
    nvm.uploadResolution = item.tag;
    [self allocateShareResources];
}



-(void)allocateResourcesForUpload
{
    //    [self releaseToolBarIfAny];
    //    [self ChangeParent:mainBackground :sess.frame];
    //    /* First release resources of the previous mode */
    //    [self releaseResourcesForModeChange];
    //
    //    self.title = @"Images or Videos";
    //
    //    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    //    {
    //        nvm.noAdMode = YES;
    //    }
    //    /* first check if the frame is video frame or not */
    //    if([sess anyVideoFrameSelected])
    //    {
    //        NSLog(@"VideoSelected----");
    //        [self showVideoResolutionOptios];
    //    }
    //    else
    //    {
    //
    //        _imageToVideo = YES;
    //        isVideoFile = NO;
    //        nvm.uploadResolution = RESOLUTION_PIXCOUNT_MED0;
    //        [self allocateShareResources];
    //        // [self showResolutionOptios];
    //    }
    [self showSaveorShareView];
}


/**
 * Disables user interaction for all UIButton objects within a stack view
 * @param stackView The stack view containing buttons to disable
 * @param disabled YES to disable buttons, NO to enable them
 * @param visualState Whether to also update the visual appearance (alpha/enabled state)
 */
- (void)setButtonsInStackView:(UIStackView *)stackView
                    disabled:(BOOL)disabled
                 visualState:(BOOL)visualState
                currentButton:(UIButton*)currentButton
{
    
    for (UIView *view in stackView.arrangedSubviews) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                // Disable/enable interaction
                button.userInteractionEnabled = !disabled;
                if (visualState) {
                    // Update visual appearance
                    button.enabled = !disabled;
                    button.alpha = disabled ? 0.5 : 1.0;
                }
            }
        }
    }
    currentButton.userInteractionEnabled = !disabled;
   // dropdownButton.userInteractionEnabled = !disabled;
    removeWatermarkButton.userInteractionEnabled = !disabled;
    if (visualState) {
        // Update visual appearance
        //currentButton.enabled = !disabled;
      //  dropdownButton.enabled = !disabled;
        //removeWatermarkButton.enabled = !disabled;
        removeWatermarkButton.alpha = disabled ? 0.75 : 1.0;
        removeWatermarkButton.titleLabel.alpha = disabled ? 0.75 : 1.0;
        removeWatermarkButton.imageView.alpha = disabled ? 0.75 : 1.0;
        currentButton.alpha = disabled ? 0.75 : 1.0;
        currentButton.titleLabel.alpha = disabled ? 0.75 : 1.0;
        currentButton.imageView.alpha = disabled ? 0.75 : 1.0;
    //    dropdownButton.alpha = disabled ? 0.5 : 1.0;
        removeWatermarkButton.alpha = disabled ? 0.8 : 1.0;
    }
}

-(void)pauseVideoPreviewPlaying
{
    if(previewPlayButton)
    {
      int masterAudioSet = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MasterAudioPlayerSet"];
      for (int photoIndex= 0; photoIndex< sess.frame.photoCount; photoIndex++)
      {
        Photo *pht = [sess.frame getPhotoAtIndex:photoIndex ];
        if(pht.isContentTypeVideo)
        {
            if(pht.view.player.rate > 0)
            {
                [pht.view pausePlayer];
                if(masterAudioSet)
                {
                    [sess muteMasterAudio];
                }
            }
        }
      }
    [previewPlayButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}


-(void)exportVideoOrImageIndex:(UIButton *)button
{
    NSLog(@"button is interactive is Touch Will Detect %@ frame Is Edited %@",isTouchWillDetect?@"YES":@"NO",frameIsEdited?@"YES":@"NO");
    if(isTouchWillDetect)
    {
        if(frameIsEdited)
        {
            NSString *currentVideoPath = [sess pathToCurrentVideo];
            if(YES == [[NSFileManager defaultManager]fileExistsAtPath:currentVideoPath])
            {
                [[NSFileManager defaultManager]removeItemAtPath:currentVideoPath error:nil];
            }
            [self pauseVideoPreviewPlaying];
            [self disableLeftBarButtonItem];
            generatingVideo = YES;
            
            // ---- ? -----
            BOOL optOutVideoHelp = [[[NSUserDefaults standardUserDefaults]objectForKey:@"optOutVideoGenerationHelp"]boolValue];

            self.applicationSuspended = NO;
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES]; //uncomment again

            isTouchWillDetect = NO;
            [self setButtonsInStackView:stackView disabled:YES visualState:YES currentButton:button];
            previewPlayButton.hidden = YES;
            frameIsEdited = NO;
            [self releaseToolBarIfAny];
            //   [self ChangeParent:mainBackground :sess.frame];
            /* First release resources of the previous mode */
            [self releaseResourcesForModeChange];
            
            if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
            {
                nvm.noAdMode = YES;
            }
            /* first check if the frame is video frame or not */
            if([sess anyVideoFrameSelected])
            {
                CFTimeInterval startTime = CACurrentMediaTime();
                
                Photo *photo = [sess.frame getPhotoAtIndex:0];
                if(photo.view.curShape == SHAPE_NOSHAPE)
                {
                    [self createCroppedVideoCollageCompletion:^(BOOL success, NSError *error) {
                        if(success)
                        {
                            NSLog(@"Collage video saved at");
                            isVideoFile = YES;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                CFTimeInterval duration = CACurrentMediaTime() - startTime;
                                NSLog(@"Total processing time: %.2f seconds", duration);
                                self.videoURL = [NSURL fileURLWithPath:[sess pathToCurrentVideo]];
                                //[self removeProgressBar];
                                [self removeCircularProgressView];
                                if(button.tag != 5)
                                {
                                    // Handle multiple pop ups
                                    [userDefaultss setInteger:1 forKey:@"CalledShareOptions"];
                                    [self saveVideo];
                                }
                                //  [self allocateShareResources];
                                [self CallShare:button];
                                
                            });
                        }
                        else
                        {
                            NSLog(@"Collage video failed %@",error.description);
                        }
                    }];
                }
                else
                {
                    
                    [self createMaskedVideoCollageWithShapeImagesCompletion:^(BOOL success, NSError *error) {
                        isVideoFile = YES;
                        //[self removeProgressBar];
                        [self removeCircularProgressView];
                        if(button.tag != 5)
                        {
                            [userDefaultss setInteger:1 forKey:@"CalledShareOptions"];
                            [self saveVideo];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            CFTimeInterval duration = CACurrentMediaTime() - startTime;
                            NSLog(@"Total processing time: %.2f seconds", duration);
                            self.videoURL = [NSURL fileURLWithPath:[sess pathToCurrentVideo]];
                            // [self allocateShareResources];
                            [self CallShare:button];
                        });
                    }];
                }
            }
            else
            {
                isVideoFile = NO;
                [self addCircularProgressViewWithMsg:@"Saving..."];
                
                // 1. Slower progress animation (every 0.05s for smoother updates)
                __block float prog = 0.0;
                NSTimeInterval totalDuration = 2.0; // Total animation duration (adjust as needed)
                NSTimeInterval updateInterval = 0.05; // Slower than 0.01s for better visibility
                
                // 2. Start progress timer
                NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:updateInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
                    prog += (updateInterval / totalDuration);
                    
                    // Cap at 95% to leave room for completion
                    if (prog >= 0.95) {
                        prog = 0.95;
                        [timer invalidate];
                    }
                    
                    [progressView setProgress:prog animated:YES];
                }];
                
                // 3. Run the actual task
                UploadHandler *uploadH = [[UploadHandler alloc] init];
                uploadH.view = self.view;
                uploadH.viewController = self;
                uploadH.cursess = sess;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // Perform task (blocking call)
                    outputImage = [uploadH getTheSnapshot];
                    if(button.tag != 5)
                    {
                        [self saveVideo];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Force progress to 100% when done
                        [progressTimer invalidate]; // Stop timer if still running
                        [progressView setProgress:1.0 animated:YES];
                        
                        // Briefly show 100% before dismissing
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self removeCircularProgressView];
                            [self CallShare:button];
                        });
                    });
                });
            }
        }
        else{
            //call all function with existing video url and image
            [self CallShare:button];
        }
    }
}

-(void)CallShare:(UIButton *)button
{
    //----- completion
    generatingVideo = NO;
    [self enableLeftBarButtonItem];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

    previewPlayButton.hidden = NO;
    [self setButtonsInStackView:stackView disabled:NO visualState:YES currentButton:button];
    UILabel *label = [button.superview viewWithTag:1000+button.tag];
    NSString *appName = label.text;
    NSLog(@"Label text: %@", appName);
    
//    if ([appName isEqualToString:@"Print"]) {
//        [self printAction];
//    }
//    else if ([appName isEqualToString:@"Copy"]) {
//        [self copyLinkAction];
//    }
//   
//    else if ([appName isEqualToString:@"Instagram"]) {
//        [self shareToInstagram:self.videoURL];
//    }
//    else if ([appName isEqualToString:@"Facebook"]) {
//        [self shareToFacebook:self.videoURL];
//    }
//    else if ([appName isEqualToString:@"Messenger"]) {
//        [self shareToMessenger:self.videoURL];
//    }
//    else
        
    if ([appName isEqualToString:@"Email"]) {
        [self emailAction];
    }
    else if ([appName isEqualToString:@"WhatsApp"]) {
        [self shareToWhatsApp:self.videoURL];
    }
    else if ([appName isEqualToString:@"iMessage"]) {
        if(isVideoFile)
        {
            [self shareToiMessage:self.videoURL];
        }
        else
        {
//            UploadHandler *uploadH = nil;
//            uploadH = [UploadHandler alloc];
//            uploadH.view = self.view;
//            uploadH.viewController = self;
//            uploadH.cursess = sess;
//            UIImage *img = [uploadH getTheSnapshot];
            [self shareToiMessageImage:outputImage];
        }
    }
    else if ([appName isEqualToString:@"More"]) {
        [self shareMedia];
    }
    else if(appName == nil)
    {
        if(button.tag == 5)
        {
            [userDefaultss setInteger:0 forKey:@"CalledShareOptions"];
            [self saveVideo];
        }
    }
    isTouchWillDetect = YES;
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }];
}

-(void)saveVideo
{
    nvm.uploadCommand = UPLOAD_PHOTO_ALBUM;
    if(isVideoFile)
        [self uploadVideo];
    else
        [self uploadImage];
}

-(void)callVideoGaneration
{
    CFTimeInterval startTime = CACurrentMediaTime();
    Photo *photo = [sess.frame getPhotoAtIndex:0];
    if(photo.view.curShape == SHAPE_NOSHAPE)
    {
        [self createCroppedVideoCollageCompletion:^(BOOL success, NSError *error) {
            if(success)
            {
                NSLog(@"Collage video saved at");
                isVideoFile = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    CFTimeInterval duration = CACurrentMediaTime() - startTime;
                    NSLog(@"Total processing time: %.2f seconds", duration);
                    self.videoURL = [NSURL fileURLWithPath:[sess pathToCurrentVideo]];
                    //[self removeProgressBar];
                    [self removeCircularProgressView];
                    [self allocateShareResources];
                });
            }
            else
            {
                NSLog(@"Collage video failed %@",error.description);
            }
        }];
    }
    else
    {
        
        [self createMaskedVideoCollageWithShapeImagesCompletion:^(BOOL success, NSError *error) {
            isVideoFile = YES;
            //[self removeProgressBar];
            [self removeCircularProgressView];
            dispatch_async(dispatch_get_main_queue(), ^{
                CFTimeInterval duration = CACurrentMediaTime() - startTime;
                NSLog(@"Total processing time: %.2f seconds", duration);
                self.videoURL = [NSURL fileURLWithPath:[sess pathToCurrentVideo]];
                [self allocateShareResources];
            });
        }];
    }
}



- (void)checkmarkButtonTapped {
    // Handle checkmark button action
    //if([sess anyVideoFrameSelected])
    [self applySelectedEffectToAllImages];
    NSLog(@"Checkmark button tapped");
}


- (void)closeButtonTapped { //Sachin Added
    // Handle close button action (e.g., dismiss or hide the view)
    NSLog(@"Close button tapped");
    self.navigationItem.leftBarButtonItem = backButton;
    [self assignRightBarButtonItem];
}

-(void)applyFilter:(UIButton *)button
{
    [self applySelectedeffectOnPhoto:(int)button.tag];
}



-(void)applySelectedeffectOnPhoto:(int)index //(UIButton *)button
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"current Selected PhotoNumber For Effect %d",currentSelectedPhotoNumberForEffect);
        Effects *effect = [Effects alloc];
        [self applyFilter:index photoIndex:currentSelectedPhotoNumberForEffect completion:^(BOOL success, NSError *error) {
            NSLog(@"effects applied");
            Photo *photo = [sess.frame getPhotoAtIndex:currentSelectedPhotoNumberForEffect];
            NSURL *videoURL;
            NSString *effectPath = [sess pathToEffectVideoAtIndex:currentSelectedPhotoNumberForEffect];
            NSLog(@"effects applied effect Path %@ ",effectPath);
            if([[NSFileManager defaultManager]fileExistsAtPath:effectPath])
            {
                NSLog(@"effects applied file exists ");
                videoURL = [NSURL fileURLWithPath:effectPath];
            }
            else
            {
                videoURL = [sess getVideoUrlForPhotoAtIndex:currentSelectedPhotoNumberForEffect];
            }
            [photo.view removePlayer];
            [self callAudioRefresh];
            photo.view.videoURL = videoURL;
            //[photo.view playPlayer];
        }];
    });
}


-(void)applyColor:(UIButton *)but
{
    BOOL isLock = ([GridView getLockStatusOfColor:(int)but.tag] && ![[SRSubscriptionModel shareKit]IsAppSubscribed]);
    if (isLock)
        [self ShowSubscriptionView];
    else
        sess.color = [GridView getColorAtIndex:(int)but.tag];
}

-(void)applyPattern:(UIButton *)but
{
    BOOL isLock = ([GridView getLockStatusOfPatern:(int)but.tag] && ![[SRSubscriptionModel shareKit]IsAppSubscribed] );
    if (isLock)
        [self ShowSubscriptionView];
    else
        sess.color = [GridView getPatternAtIndex:(int)but.tag];
}

-(void)colorItemSelected:(UIColor *)selectedColor
{
    sess.color = selectedColor;
}

-(void)releaseResourcesForUpload
{
    [self releaseToolBarIfAny];
}



-(void)releaseResourcesForModeChange
{
    NSLog(@"Release resource for mode change");
    // [self backButtonView];
    switch (eMode)
    {
        case MODE_FRAMES:
        {
            
            [self releaseResourcesForFrames];
            
            break;
        }
        case MODE_VIDEO_SETTINGS:
        {
            [self releaseResourcesForVideoSetttings];
            break;
        }
        case MODE_SHARE:
        {
            [self releaseResourcesForUpload];
            break;
        }
            //need to delete
        case MODE_PREVIEW:
        {
            // [self releaseResourcesForPreview];
            break;
        }
            //end
        default:
        {
            break;
        }
            
    }
    
}


-(void)ShowSelectedOption:(NSString *)name
{
    if([name  isEqual:  @"Frames"])
    {
        eMode = MODE_FRAMES;
        if(changeTitle)
        {
            // Reset to editing mode
            [self resetToEditingMode];
        }
        [self removeAllEffectVideos]; // It removes all effects video if present when switching to frames view
        [self removeAllPreviewPlayers];
        [self allocateResourcesForFrames];
    }
    else if([name  isEqual:  @"Background"])
    {
        // Background now shows the adjust/slider view
        eMode = MODE_ADJUST_SETTINGS;
        [self ShowSlidersViewController];
    }
    else if([name  isEqual:  @"Adjust"])
    {
        eMode = MODE_ADJUST_SETTINGS;
        [self ShowSlidersViewController];
    }
    else if([name  isEqual:  @"Effects"])
    {
        eMode = MODE_ADD_EFFECT;
        [self ShowFiltersViewController];
    }
    else if([name  isEqual:  @"Music"])
    {
        eMode = MODE_VIDEO_SETTINGS;
        [self allocateResourcesForVideoSettings];
    }
    else if([name  isEqual:  @"Ratio"])
    {
        eMode = MODE_SIZES;
        [self showAspectRatiosViewController];
    }
    else if([name  isEqual:  @"Stickers"])
    {
        eMode = MODE_STICKERS;
        [self ShowStickersViewController];
    }
    else if([name  isEqual:  @"Text"])
    {
        eMode = MODE_TEXT;
        [self ShowTextView];
    }
    else if([name  isEqual:  @"Edit"])
    {
        // Show the Edit secondary tabbar
        [self showEditOptionsViewController];
    }
    else if([name  isEqual:  @"Volume"])
    {
        // Show volume control for selected photo slot
        [self showVolumeViewController];
    }
    else if([name  isEqual:  @"EditBackground"])
    {
        // Background from Edit submenu shows color/pattern selection
        eMode = MODE_COLOR_AND_PATTERN;
        [self ShowBackgroundViewController];
    }
}

-(void)showEditOptionsViewController
{
    // Hide main options view and show edit options
    if(optionsView != nil)
    {
        optionsView.view.hidden = YES;
    }

    if(self.editOptionsVC == nil)
    {
        self.editOptionsVC = [[EditOptionsViewController alloc] init];
    }

    CGFloat optionsViewHeight = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 110 : 85;
    self.editOptionsVC.view.frame = CGRectMake(0, fullScreen.size.height - optionsViewHeight, fullScreen.size.width, optionsViewHeight);

    [self.view addSubview:self.editOptionsVC.view];
    [self addChildViewController:self.editOptionsVC];
    [self.editOptionsVC didMoveToParentViewController:self];

    // Listen for back button
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEditOptionsBack)
                                                 name:@"editOptionsBack"
                                               object:nil];
}

-(void)handleEditOptionsBack
{
    // Remove edit options and show main options
    if(self.editOptionsVC != nil)
    {
        [self.editOptionsVC.view removeFromSuperview];
        [self.editOptionsVC removeFromParentViewController];
    }

    if(optionsView != nil)
    {
        optionsView.view.hidden = NO;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"editOptionsBack" object:nil];
}

-(void)showVolumeViewController
{
    self.volumeVC = [[VolumeViewController alloc] init];

    // Get current volume from selected photo if available
    if(currentSelectedPhotoNumberForEffect >= 0 && currentSelectedPhotoNumberForEffect < sess.frame.photoCount)
    {
        Photo *selectedPhoto = [sess.frame getPhotoAtIndex:currentSelectedPhotoNumberForEffect];
        if(selectedPhoto != nil)
        {
            self.volumeVC.currentVolume = selectedPhoto.videoVolume;
        }
    }

    if (@available(iOS 16.0, *)) {
        self.volumeVC.modalPresentationStyle = UIModalPresentationFormSheet;
        self.volumeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.volumeVC.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 200);

        if (@available(iOS 15.0, *)) {
            UISheetPresentationController *sheetController = (UISheetPresentationController *)self.volumeVC.presentationController;
            if (@available(iOS 16.0, *)) {
                UISheetPresentationControllerDetent *smallDetent =
                [UISheetPresentationControllerDetent customDetentWithIdentifier:@"volumeSmall" resolver:^CGFloat(id<UISheetPresentationControllerDetentResolutionContext>  _Nonnull context) {
                    return 200;
                }];
                sheetController.largestUndimmedDetentIdentifier = @"volumeSmall";
                sheetController.detents = @[smallDetent];
            } else {
                sheetController.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
            }
            sheetController.preferredCornerRadius = 10;
            sheetController.prefersEdgeAttachedInCompactHeight = YES;
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = YES;
            sheetController.prefersGrabberVisible = NO;
        }

        [self presentViewController:self.volumeVC animated:YES completion:nil];
    } else {
        [self presentViewController:self.volumeVC animated:YES completion:nil];
    }

    // Listen for volume changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleVolumeChanged:)
                                                 name:@"VolumeValueChanged"
                                               object:nil];
}

-(void)handleVolumeChanged:(NSNotification *)notification
{
    float volume = [[notification.userInfo objectForKey:@"Volume"] floatValue];

    // Apply volume to selected photo
    if(currentSelectedPhotoNumberForEffect >= 0 && currentSelectedPhotoNumberForEffect < sess.frame.photoCount)
    {
        Photo *selectedPhoto = [sess.frame getPhotoAtIndex:currentSelectedPhotoNumberForEffect];
        if(selectedPhoto != nil)
        {
            selectedPhoto.videoVolume = volume;
            NSLog(@"Set volume %.2f for photo %d", volume, currentSelectedPhotoNumberForEffect);
        }
    }
}

-(void)ShowFiltersViewController
{
    if (dictionaryOfEffectInfo!= nil)
    {
        dictionary = nil;
    }
    dictionaryOfEffectInfo = [[NSMutableDictionary alloc] init];
    [sess enterTouchModeForSlectingImage:currentSelectedPhotoNumberForEffect];
    
    // Initialize the view controller to present
    self.sheetFilterVC = [[EffectsViewController alloc] init];
    if (@available(iOS 16.0, *)) {
        // Set the modal presentation style to page sheet
        self.sheetFilterVC.modalPresentationStyle = UIModalPresentationFormSheet; //UIModalPresentationPageSheet;
        self.sheetFilterVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.sheetFilterVC.edgesForExtendedLayout = UIRectEdgeAll;
        // Set the preferred content size to match screen width
        self.sheetFilterVC.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 400); // Adjust height as needed
        //sheetFilterVC.modalInPresentation = YES;
        // Disable dragging
        if (@available(iOS 15.0, *)) {
            UISheetPresentationController *sheetController = (UISheetPresentationController *)self.sheetFilterVC.presentationController;
            if (@available(iOS 16.0, *)) {
                // Define a custom detent at 400 points
                UISheetPresentationControllerDetent *verySmallDetent =
                [UISheetPresentationControllerDetent customDetentWithIdentifier:@"verysmall" resolver:^CGFloat(id<UISheetPresentationControllerDetentResolutionContext>  _Nonnull context) {
                    return verySmall_Detent;
                }];
                sheetController.largestUndimmedDetentIdentifier = @"verysmall";
                
                // Configure the sheet presentation
                sheetController.detents = @[verySmallDetent];
            }else
            {
                sheetController.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
            }
            sheetController.preferredCornerRadius = 10;
            self.sheetFilterVC.preferredContentSize = CGSizeMake(fullScreen.size.width, fullScreen.size.height*0.9);
            sheetController.prefersEdgeAttachedInCompactHeight = YES;
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = YES; // Ensures full width
            sheetController.delegate = self;
            sheetController.prefersGrabberVisible = NO; // Optional: Hide the grabber
            //        sheetController.topMargin = 0; // Optional: Adjust the top margin if needed
            //        sheetController.allowsDragging = NO; // Disable dragging
        }
        else {
            // Fallback code for earlier iOS versions (before iOS 15)
            self.sheetFilterVC.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isViewLoaded && self.view.window) {
                [self presentViewController:self.sheetFilterVC animated:YES completion:nil];
            }
        });
    }else{
        CGFloat viewHeight;
        NSLog(@"screen height %f ", fullScreen.size.height);
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            viewHeight = fullScreen.size.height * 0.18;
        }
        else{
            
            viewHeight = fullScreen.size.height * 0.20;
        }
        // Set the custom frame for the view
        self.sheetFilterVC.view.frame = CGRectMake(0, fullScreen.size.height - viewHeight, fullScreen.size.width, viewHeight);
        
        // Add it as a child view controller
        [self addChildViewController:self.sheetFilterVC];
        [self.view addSubview:self.sheetFilterVC.view];
        [self.sheetFilterVC didMoveToParentViewController:self];
    }
    
    effectSubviewAdded = YES;
    NSLog(@"Show filter re_Align");
    [self reAlignUI];
}


// Delegate method to add UITextView to parent
- (void)addTextViewToParent:(UITextView *)textView {
    //  textView.frame = CGRectMake(20, 300, 300, 100);
    NSLog(@"textview is being added");
    [sess.frame addSubview:textView]; // Add UITextView to Parent View
}

-(void)setUpConstraints {
    
    keyboardHeight = 216;
    
    fontSizeSlider = [[UISlider alloc] init];
    
    trackImgV = [[UIImageView alloc] init];
    trackImgV.image = [UIImage imageNamed:@"slidertrackImage"];
    trackImgV.contentMode = UIViewContentModeScaleAspectFill;
    trackImgV.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    UICollectionViewFlowLayout *colorsLayout = [[UICollectionViewFlowLayout alloc] init];
    colorsLayout.minimumInteritemSpacing = 10;
    colorsLayout.minimumLineSpacing = 10;
    colorsLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    colorsLayout.sectionInset = UIEdgeInsetsMake(20, 5, 5, 20);
    
    
    ColorsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:colorsLayout];
    [ColorsCollectionView registerClass:[BGCell class] forCellWithReuseIdentifier:BGCell.identifier ];
    ColorsCollectionView.userInteractionEnabled = YES;
    ColorsCollectionView.showsVerticalScrollIndicator = NO;
    ColorsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    ColorsCollectionView.delegate = self;
    ColorsCollectionView.dataSource = self ;
    ColorsCollectionView.showsHorizontalScrollIndicator = NO;
    ColorsCollectionView.showsVerticalScrollIndicator = NO;
    
    UICollectionViewFlowLayout *fontsLayout = [[UICollectionViewFlowLayout alloc] init];
    fontsLayout.minimumInteritemSpacing = 10;
    fontsLayout.minimumLineSpacing = 10;
    fontsLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    fontsLayout.sectionInset = UIEdgeInsetsMake(20, 20, 10, 20);
    
    fontsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fontsLayout];
    [fontsCollectionView registerClass:[FontCell class] forCellWithReuseIdentifier:@"FontCell"];
    fontsCollectionView.userInteractionEnabled = YES;
    fontsCollectionView.showsVerticalScrollIndicator = NO;
    fontsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    fontsCollectionView.delegate = self;
    fontsCollectionView.dataSource = self ;
    
    UICollectionViewFlowLayout *alignmentLayout = [[UICollectionViewFlowLayout alloc] init];
    alignmentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    alignmentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:alignmentLayout];
    [alignmentCollectionView registerClass:[AlignmentCell class] forCellWithReuseIdentifier:@"AlignmentCell"];
    alignmentCollectionView.showsHorizontalScrollIndicator = NO;
    alignmentCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    alignmentCollectionView.delegate = self;
    alignmentCollectionView.dataSource = self;
    
    ellipsisOverlay = [[UIView alloc] init];
    ellipsisOverlay.backgroundColor = DARK_GRAY_BG;
    ellipsisOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    
    uitoolbar = [[UIToolbar alloc] init];
    isCollectionViewVisible = NO; // Flag to track visibility
    
    uititleLabel = [[UILabel alloc] init];
    uititleLabel.text = @"Alignment:";
    uititleLabel.textColor = [UIColor lightGrayColor];
    uititleLabel.numberOfLines = 0;
    uititleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    uititleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    titleLabelColor = [[UILabel alloc] init];
    titleLabelColor.text = @"Text Overlay Color:";
    titleLabelColor.textColor = [UIColor lightGrayColor];
    titleLabelColor.numberOfLines = 0;
    titleLabelColor.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    titleLabelColor.translatesAutoresizingMaskIntoConstraints = NO;
    
    fontsCollectionView.hidden = YES;
    ColorsCollectionView.hidden = YES;
    [self.view addSubview:self.ColorsCollectionView];
    [self.view addSubview:self.fontsCollectionView];
    self.ColorsCollectionView.backgroundColor = DARK_GRAY_BG;
    self.fontsCollectionView.backgroundColor = DARK_GRAY_BG;
    uitoolbar.hidden = YES;
    [self.view addSubview:self.uitoolbar];
    self.uitoolbar.translatesAutoresizingMaskIntoConstraints = NO;
    self.uitoolbar.layer.cornerRadius = 12;
    // self.uitoolbar.backgroundColor = [UIColor blackColor];
    self.uitoolbar.translucent = NO;
    self.uitoolbar.barTintColor = PHOTO_DEFAULT_COLOR; // Solid black background
    self.uitoolbar.tintColor = [UIColor whiteColor];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.uitoolbar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.uitoolbar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        //        [self.uitoolbar.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-312],
        [self.uitoolbar.heightAnchor constraintEqualToConstant:44] // Standard toolbar height
    ]];
    
    // Store the bottom constraint reference
    bottomConstraint = [self.uitoolbar.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-keyboardHeight];
    bottomConstraint.active = YES;
    
    
    [NSLayoutConstraint activateConstraints:@[
        [self.ColorsCollectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.ColorsCollectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.ColorsCollectionView.heightAnchor constraintEqualToConstant:75],
        [self.ColorsCollectionView.topAnchor constraintEqualToAnchor:self.uitoolbar.bottomAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.fontsCollectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.fontsCollectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.fontsCollectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.fontsCollectionView.topAnchor constraintEqualToAnchor:self.ColorsCollectionView.bottomAnchor]
    ]];
    
    [self.view addSubview:self.ellipsisOverlay];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.ellipsisOverlay.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.ellipsisOverlay.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.ellipsisOverlay.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.ellipsisOverlay.topAnchor constraintEqualToAnchor:self.uitoolbar.bottomAnchor]
    ]];
    
    [self.ellipsisOverlay addSubview:self.uititleLabel];
    [self.ellipsisOverlay addSubview:self.titleLabelColor];
    [self.ellipsisOverlay addSubview:self.alignmentCollectionView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.uititleLabel.leadingAnchor constraintEqualToAnchor:self.ellipsisOverlay.safeAreaLayoutGuide.leadingAnchor constant:15],
        [self.uititleLabel.topAnchor constraintEqualToAnchor:self.ellipsisOverlay.safeAreaLayoutGuide.topAnchor constant:20],
        
        [self.alignmentCollectionView.leadingAnchor constraintEqualToAnchor:self.ellipsisOverlay.safeAreaLayoutGuide.leadingAnchor constant:15],
        [self.alignmentCollectionView.trailingAnchor constraintEqualToAnchor:self.ellipsisOverlay.safeAreaLayoutGuide.trailingAnchor constant:-15],
        [self.alignmentCollectionView.topAnchor constraintEqualToAnchor:self.uititleLabel.bottomAnchor constant:7],
        [self.alignmentCollectionView.heightAnchor constraintEqualToConstant:100],
        
        [titleLabelColor.topAnchor constraintEqualToAnchor:self.alignmentCollectionView.bottomAnchor],
        [titleLabelColor.leadingAnchor constraintEqualToAnchor:self.alignmentCollectionView.leadingAnchor]
    ]];
    
    // Assign toolbar items
    self.uitoolbar.items = [self createToolbarItems];
    
    self.uitoolbar.hidden = YES;
    self.ellipsisOverlay.hidden = YES;
    
    // Add keyboard observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}

- (void)keyboardDidShow:(NSNotification *)notification {
    if(!gotKeyBoardHeight){
        gotKeyBoardHeight = YES;
        // Get keyboard size
        NSDictionary *userInfo = notification.userInfo;
        CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardHeight = keyboardFrame.size.height;
        [self setUIToolbarHeight];
        NSLog(@"did show Keyboard height: %f", keyboardHeight);
    }
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardHeight = keyboardFrame.size.height;
    NSLog(@"outside did show Keyboard height: %f", keyboardHeight);
}


- (void)keyboardWillShow:(NSNotification *)notification {
    //    if(!gotKeyBoardHeight){
    //        gotKeyBoardHeight = YES;
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    
    if (keyboardFrameValue) {
        CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
        self->keyboardHeight = keyboardFrame.size.height;
        [self setUIToolbarHeight];
        NSLog(@"will show keyboard Height %f",keyboardHeight);
        // Call method to adjust toolbar position if needed
        // [self adjustToolbarPosition];
    }
    //    }
}

-(void)setUIToolbarHeight
{
    NSLog(@"screen height %f screen width %f", fullScreen.size.height,fullScreen.size.width);
    bottomAnchorConstant = keyboardHeight;
    if(SafeAreaBottomPadding >0)
    {
        bottomAnchorConstant = keyboardHeight - SafeAreaBottomPadding;
    }
    bottomConstraint.constant = -bottomAnchorConstant; //-keyboardHeight;
    bottomConstraint.active = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    });
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // Call method to adjust toolbar position if needed
    // [self adjustToolbarPosition];
    
    //
    if(!self.showingFonts)
    {
        UITextView *activeTextView = [self findActiveTextView];
        [activeTextView resignFirstResponder];
        [self CloseTextEditorUI];
    }
    NSLog(@"keyboard gets hidden ");
}


- (NSArray<UIBarButtonItem *> *)createToolbarItems {
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"text.alignleft"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(changeTextAlignment:)];
    button1.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"textformat"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(showFontsCollection)];
    button2.tintColor = [UIColor whiteColor];
    // button2.menu = [self createMenu]; // Attach UIMenu
    
    UIBarButtonItem *button6 = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"character.textbox"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(changeOverlayShape)];
    button6.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"paintpalette"] style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(applyOverlayForText)];
    // menu:[self createMenu]]; // Directly attach menu
    button3.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    return @[button2, flexibleSpace, button1, flexibleSpace, button6, flexibleSpace, button3];//, flexibleSpace, button5
}


-(void)applyOverlayForText
{
    frameIsEdited = YES;
    self.showingFonts = NO;
    NSLog(@"Apply overlay for text");
    // Find the active text box
    UITextView *activeTextView = [self findActiveTextView];
    [activeTextView resignFirstResponder];
    self.fontSizeSlider.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FontPressed"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"OverlayPressed"];
    [self CloseTextEditorAllUIExceptColorPickker];
    [self showColorPicker];
}


- (UIMenu *)createMenu {
    
    // Find the active text box
    UITextView *activeTextView = [self findActiveTextView];
    self.fontSizeSlider.hidden = YES;
    
    UIAction *option1Action = [UIAction actionWithTitle:@"Choose Text Color"
                                                  image:[UIImage systemImageNamed:@"camera.fill"]
                                             identifier:nil
                                                handler:^(__kindof UIAction * _Nonnull action) {
        NSLog(@"Option 1 selected");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"OverlayPressed"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FontPressed"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ObjPressed"];
        [self showColorPicker];
        // [self checkCameraPermissions];
    }];
    
    UIAction *option2Action = [UIAction actionWithTitle:@"Choose Overlay Color"
                                                  image:[UIImage systemImageNamed:@"photo"]
                                             identifier:nil
                                                handler:^(__kindof UIAction * _Nonnull action) {
        NSLog(@"Option 2 selected");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FontPressed"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"OverlayPressed"];
        [self showColorPicker];
    }];
    
    return [UIMenu menuWithTitle:@"" children:@[option1Action, option2Action]];
}



- (void)showColorPicker {
    
    self.ellipsisOverlay.hidden = YES;
    NSLog(@"Open color picker");
    colorPicker = [[UIColorPickerViewController alloc] init];
    colorPicker.delegate = self;
    colorPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    colorPicker.edgesForExtendedLayout = UIRectEdgeAll;
    
    if (colorPicker.sheetPresentationController) {
        UISheetPresentationController *sheet = colorPicker.sheetPresentationController;
        
        if (@available(iOS 16.0, *)) {
            sheet.detents = @[
                [UISheetPresentationControllerDetent customDetentWithIdentifier:UISheetPresentationControllerDetentIdentifierMedium resolver:^CGFloat(id<UISheetPresentationControllerDetentResolutionContext>  _Nonnull context) {
                    //return 650;
                    return fullScreen.size.height*0.5;
                }]
            ];
        } else {
            sheet.detents = @[UISheetPresentationControllerDetent.mediumDetent];
        }
        
        sheet.selectedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;
        sheet.prefersGrabberVisible = YES; // Show the grabber for resizing
        sheet.preferredCornerRadius = 20; // Round the corners
        sheet.largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium; // Background remains visible
        sheet.prefersEdgeAttachedInCompactHeight = YES;
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = YES; // Ensures full width
        sheet.delegate = self;
        sheet.prefersScrollingExpandsWhenScrolledToEdge = NO;
    }
    
    [self.parentViewController presentViewController:colorPicker animated:YES completion:nil];
}

// Delegate method when color picker is dismissed
- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController {
    //    frameIsEdited = YES;
    //    BOOL isFont = [[NSUserDefaults standardUserDefaults] boolForKey:@"FontPressed"];
    //    BOOL isOverlay = [[NSUserDefaults standardUserDefaults] boolForKey:@"OverlayPressed"];
    // Find the active text box
    UITextView *activeTextView = [self findActiveTextView];
    if(activeTextView != nil)
    {
        // Before calling become FirstResponder, save the current selection
        NSRange selectedRange = activeTextView.selectedRange;
        [activeTextView becomeFirstResponder];
        // Restore the selection
        activeTextView.selectedRange = selectedRange;
        // Show the toolbar and slider
        uitoolbar.hidden = NO;
        fontSizeSlider.hidden = NO;
        [mainBackground bringSubviewToFront:self.fontSizeSlider];
        textEditorSubviewAdded = YES;
    }
    else{
        [self CloseTextEditorAllUIExceptColorPickker];
    }
}

// Delegate method when a color is selected
- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController {
    frameIsEdited = YES;
    BOOL isFont = [[NSUserDefaults standardUserDefaults] boolForKey:@"FontPressed"];
    BOOL isOverlay = [[NSUserDefaults standardUserDefaults] boolForKey:@"OverlayPressed"];
    // Find the active text box
    UITextView *activeTextView = [self findActiveTextView];
    if(activeTextView != nil)
    {
        // Before calling become FirstResponder, save the current selection
        NSRange selectedRange = activeTextView.selectedRange;
        if (isFont) {
            activeTextView.textColor = viewController.selectedColor;
        } else if (isOverlay) {
            selectedOverlayColor = viewController.selectedColor;
            NSLog(@"did select overlaye pressed");
            CAShapeLayer *shapeLayer = [self findCAShapeLayerInView:activeTextView.superview];
            shapeLayer.fillColor = viewController.selectedColor.CGColor;
            //activeTextView.superview.backgroundColor = viewController.selectedColor;
        }
        // [activeTextView becomeFirstResponder];
        // Restore the selection
        activeTextView.selectedRange = selectedRange;
    }
    else
    {
        [self CloseTextEditorAllUIExceptColorPickker];
    }
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.fontsCollectionView) {
        return self.fontNames.count;
    }else if(collectionView == self.ColorsCollectionView)
    {
        return 53;
    }
//    else if(collectionView == self.collectionView)
//    {
//        return self.buttonsData.count;
//    }
//    else if (collectionView == self.socialCollectionView) {
//        return self.socialButtonsData.count;
//    }
    else {
        return self.alignments.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.fontsCollectionView) {
        FontCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FontCell" forIndexPath:indexPath];
        [cell configureWith:self.fontNames[indexPath.row]];
        return cell;
    }else if(collectionView == self.ColorsCollectionView)
    {
        BGCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BGCell.identifier forIndexPath:indexPath];
        if(indexPath.row == 0)
        {
            // Get color Picker image and convert to color and configure
            // [cell configureWithColor:[GridView getColorForImage:[UIImage imageNamed:@"colors"]]];
            [cell configureWithImageName:@"colors"];
        }
        else{
            
            [cell configureWithColor:[GridView getColorAtIndex:(int)(indexPath.row-1)]];
        }
        return cell;
    }
//    else if (collectionView == self.socialCollectionView) {
//        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SocialButtonCell" forIndexPath:indexPath];
//        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        
//        
//        // Create container
//        UIView *container = [[UIView alloc] init];
//        container.translatesAutoresizingMaskIntoConstraints = NO;
//        [cell.contentView addSubview:container];
//        
//        // Create button with PNG image
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; // Use Custom type for PNG images
//        button.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        // Set PNG image (make sure these are in your assets)
//         //[UIImage imageNamed:buttonData[@"imageName"]];
//        
////        if(indexPath.item == 0 )
////        {
////           
////        }
////        else{
////            buttonImage = [UIImage systemImageNamed:buttonData[@"imageName"]
////                                  withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:20 weight:UIImageSymbolWeightBold]];
////        }
//        UIImage *buttonImage;
//        NSDictionary *buttonData = self.socialButtonsData[indexPath.item];
//        
//        buttonImage = [UIImage imageNamed:buttonData[@"imageName"]];
//        
//        [button setImage:buttonImage forState:UIControlStateNormal];
//        
//        button.tintColor = [UIColor whiteColor];
//        
//        // Button styling - transparent background since we're using PNGs
//        button.backgroundColor = PHOTO_DEFAULT_COLOR;
//        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        // SHADOW CONFIGURATION
//        button.layer.shadowColor = [UIColor blackColor].CGColor;
//        button.layer.shadowOffset = CGSizeMake(0, 3); // Shadow direction (x, y)
//        button.layer.shadowRadius = 5.0; // Blur amount
//        button.layer.shadowOpacity = 0.25; // Transparency
//        button.layer.masksToBounds = NO;
//        button.layer.cornerRadius = 30;
//        int tag = (int)indexPath.item;
//        button.tag = tag;
//        
//        // Create label
//        UILabel *label = [[UILabel alloc] init];
//        label.translatesAutoresizingMaskIntoConstraints = NO;
//        label.text = buttonData[@"title"];
//        label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor whiteColor];
//        label.tag = 1000+tag;
//        // Add to container
//        [container addSubview:button];
//        [container addSubview:label];
//        
//        // Constraints
//        [NSLayoutConstraint activateConstraints:@[
//            // Container constraints
//            [container.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor],
//            [container.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor],
//            [container.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor],
//            [container.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor],
//            
//            // Button constraints
//            [button.widthAnchor constraintEqualToConstant:60],
//            [button.heightAnchor constraintEqualToConstant:60],
//            [button.topAnchor constraintEqualToAnchor:container.topAnchor constant:15],
//            [button.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
//            
//            // Label constraints
//            [label.topAnchor constraintEqualToAnchor:button.bottomAnchor constant:3],
//            [label.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
//            [label.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
//            [label.bottomAnchor constraintLessThanOrEqualToAnchor:container.bottomAnchor]
//        ]];
//        
//        // If you want to add a subtle tap animation
//        [button addTarget:self action:@selector(exportVideoOrImageIndex:) forControlEvents:UIControlEventTouchDown];
//        [button addTarget:self action:@selector(socialButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
//        [button addTarget:self action:@selector(socialButtonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
//        
//        return cell;
//    }
//    else if(collectionView == self.collectionView)
//    {
//        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ButtonCell" forIndexPath:indexPath];
//        
//        // Remove any existing subviews
//        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        
//        NSDictionary *buttonData = self.buttonsData[indexPath.item];
//        
//        // Create button container
//        UIView *container = [[UIView alloc] initWithFrame:cell.contentView.bounds];
//        container.translatesAutoresizingMaskIntoConstraints = NO;
//        [cell.contentView addSubview:container];
//        
//        // Circular button
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        button.translatesAutoresizingMaskIntoConstraints = NO;
//        int tag =  (int)indexPath.item;
//        button.tag = tag;
//        //[button setImage:buttonData[@"image"] forState:UIControlStateNormal];
//        // Get the image from buttonData
//        UIImage *image = buttonData[@"image"];
//        
//        // Create configuration for larger size
//        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:18]; // Adjust size as needed
//        
//        // Apply configuration to image
//        UIImage *scaledImage = [image imageWithConfiguration:config];
//        
//        // Set the scaled image
//        [button setImage:scaledImage forState:UIControlStateNormal];
//        
//        
//        
//        // 1. Configure the button appearance
//        button.tintColor = [UIColor whiteColor];
//        button.backgroundColor = PHOTO_DEFAULT_COLOR;
//        button.layer.cornerRadius = 22; // Half of your button height (60/2)
//        
//        // 2. Setup shadow properties
//        button.layer.shadowColor = [UIColor blackColor].CGColor;
//        button.layer.shadowOffset = CGSizeMake(0, 3); // Shadow direction (x, y)
//        button.layer.shadowRadius = 5.0; // Blur amount
//        button.layer.shadowOpacity = 0.25; // Transparency (0.0 to 1.0)
//        
//        // 3. Important performance optimization
//        button.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds cornerRadius:22].CGPath;
//        
//        // 4. These are crucial for shadows to appear
//        button.layer.masksToBounds = NO;
//        button.clipsToBounds = NO;
//        // 5. Update shadow after layout completes
//        dispatch_async(dispatch_get_main_queue(), ^{
//            button.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds cornerRadius:22].CGPath;
//        });
//        [button addTarget:self action:@selector(exportVideoOrImageIndex:) forControlEvents:UIControlEventTouchUpInside];
//        
//        // Label
//        UILabel *label = [[UILabel alloc] init];
//        label.translatesAutoresizingMaskIntoConstraints = NO;
//        label.text = buttonData[@"title"];
//        label.font = [UIFont systemFontOfSize:12];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor whiteColor];
//        label.tag = 1000+tag;
//        
//        // Add to container
//        [container addSubview:button];
//        [container addSubview:label];
//        
//        // Constraints
//        [NSLayoutConstraint activateConstraints:@[
//            // Button (60x60 circle)
//            [button.widthAnchor constraintEqualToConstant:44],
//            [button.heightAnchor constraintEqualToConstant:44],
//            [button.topAnchor constraintEqualToAnchor:container.topAnchor],
//            [button.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
//            
//            // Label
//            [label.topAnchor constraintEqualToAnchor:button.bottomAnchor constant:3],
//            [label.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
//            [label.widthAnchor constraintEqualToConstant:50],
//            [label.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
//            
//            // Container
//            [container.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor],
//            [container.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor],
//            [container.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor],
//            [container.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor]
//        ]];
//        
//        return cell;
//    }
    else {
        AlignmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlignmentCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor systemGrayColor];
        NSTextAlignment alignment = self.alignments[indexPath.row].intValue; // NSTextAlignmentCenter
        [cell configureWithAlignment:alignment];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
//                        layout:(UICollectionViewFlowLayout *)collectionViewLayout
//        insetForSectionAtIndex:(NSInteger)section {
//    if(collectionView == self.socialCollectionView)
//    {
//        return UIEdgeInsetsMake(0, 5, 0, 5);
//    }else{
//        // Default insets for all sections
//        return UIEdgeInsetsMake(0, 10, 0, 10); // Left and right padding for all cells
//    }
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(UICollectionViewLayout *)collectionViewLayout
//minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    if(collectionView == self.socialCollectionView)
//    {
//        return 5;
//    }
//    else
//    {
//        return 12; // Space between cells
//    }
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Find the active text box
    if (!self.lastActiveTextView) {
        return;
    }
    frameIsEdited = YES;
    UITextView *activeTextView = self.lastActiveTextView;
    if (collectionView == self.fontsCollectionView) {
        NSString *fontName = self.fontNames[indexPath.row];
        activeTextView.font = [UIFont fontWithName:fontName size:fontSizeSlider.value];
        [self applyShapeToActiveTextView];
        //activeTextView.font = [UIFont fontWithName:fontName size:26];
    }else if(collectionView == self.ColorsCollectionView)
    {
        if(indexPath.row == 0)
        {
            //Open Color picker and set font color selected
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"OverlayPressed"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FontPressed"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ObjPressed"];
            [self showColorPicker];
        }else
        {
            activeTextView.textColor = [GridView getColorAtIndex:(int)(indexPath.row-1)];
        }
    }
    else if (collectionView == self.alignmentCollectionView) {
        self.selectedAlignment = [self.alignments[indexPath.row] integerValue];
        activeTextView.textAlignment = self.selectedAlignment;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.fontsCollectionView) {
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            return CGSizeMake(fullScreen.size.width/3.4, 50);
        }
        else
        {
            return CGSizeMake(fullScreen.size.width/2.5, 50);
        }
    }else if(collectionView == self.ColorsCollectionView)
    {
        return CGSizeMake(60, 60);
    }
//    else if(collectionView == self.socialCollectionView)
//    {
////        // Calculate equal width for all cells
////        CGFloat buttonCount = self.socialButtonsData.count;
////        CGFloat totalSpacing = 40; // 20pts padding on each side
////        CGFloat availableWidth = [UIScreen mainScreen].bounds.size.width - totalSpacing;
////        CGFloat cellWidth = availableWidth / buttonCount;
//        
//        return CGSizeMake(100, 100); // Fixed height
//    }
//    else if(collectionView == self.collectionView)
//    {
//        // Make first cell wider to create extra padding
//        CGFloat width = (indexPath.item == 0) ? 46 : 44; // First cell 100pt, others 80pt
//        return CGSizeMake(width, 62); // Width matches label width, height for button + label
//    }
    else {
        return CGSizeMake(60, 60);
    }
}

// Button touch effects
- (void)socialButtonTouchDown:(UIButton *)button {
    UILabel *label = [button.superview viewWithTag:1000+button.tag];
    NSString *appName = label.text;
    NSLog(@"Label text: %@", appName);
    if ([appName isEqualToString:@"Instagram"]) {
        [self shareToInstagram:self.videoURL];
    }
    else if ([appName isEqualToString:@"Facebook"]) {
        [self shareToFacebook:self.videoURL];
    }
    else if ([appName isEqualToString:@"Messenger"]) {
        [self shareToMessenger:self.videoURL];
    }
    else if ([appName isEqualToString:@"WhatsApp"]) {
        [self shareToWhatsApp:self.videoURL];
    }
    else if ([appName isEqualToString:@"iMessage"]) {
        [self shareToiMessage:self.videoURL];
    }
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }];
}



- (UIView *)createButtonContainerWithImage:(NSString *)imageName
                                    label:(NSString *)label
                                     index:(int)index
{
    // Create container view
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat buttonSize = (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?80:50;
    
    // Create button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.backgroundColor = PHOTO_DEFAULT_COLOR;
    button.layer.cornerRadius = buttonSize/2; // Half of desired height for circle
    [button addTarget:self action:@selector(exportVideoOrImageIndex:) forControlEvents:UIControlEventTouchDown];
    button.tag = index;
    // Create label
    UILabel *labelView = [[UILabel alloc] init];
    labelView.translatesAutoresizingMaskIntoConstraints = NO;
    labelView.text = label;
    labelView.textColor = [UIColor whiteColor];
    labelView.font = [UIFont systemFontOfSize:12];
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.numberOfLines = 1;
    labelView.lineBreakMode = NSLineBreakByTruncatingTail;
    [labelView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [labelView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    labelView.tag = 1000+index;

    // Add to container
    [container addSubview:button];
    [container addSubview:labelView];
    
    // Constraints
    [NSLayoutConstraint activateConstraints:@[
        // Button constraints
        [button.topAnchor constraintEqualToAnchor:container.topAnchor],
        [button.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [button.widthAnchor constraintEqualToConstant:buttonSize],
        [button.heightAnchor constraintEqualToConstant:buttonSize],
        
        // Label constraints
        [labelView.topAnchor constraintEqualToAnchor:button.bottomAnchor constant:8],
        [labelView.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [labelView.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        
        // Container width (will be managed by stack view distribution)
        [container.widthAnchor constraintLessThanOrEqualToConstant:100]
    ]];
    
    return container;
}



- (void)ShowTextView {
    self.showingFonts = NO;
    [userDefault setInteger:1 forKey:@"SubscriptionExpired"];
    frameIsEdited = YES;
    // Update UserDefaults
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fromText"];
    
    // Stop editing in the current text box (if any)
    for (UIView *existingOverlay in self.textBoxes) {
        UITextView *existingTextView = (UITextView *)[existingOverlay.subviews firstObject];
        if ([existingTextView isKindOfClass:[UITextView class]]) {
            [existingTextView resignFirstResponder];
        }
    }
    
    // Create new overlay and text box
    UIView *overlayView = [[UIView alloc] init];
    overlayView.layer.cornerRadius = 10;
    overlayView.clipsToBounds = YES;
    overlayView.userInteractionEnabled = YES;
    overlayView.backgroundColor = [UIColor clearColor];
    
    textBox = [[UITextView alloc] init];
    textBox.text = @"Enter Text";  // Placeholder text
    textBox.font = [UIFont systemFontOfSize:26];
    textBox.textColor = [UIColor whiteColor];  // Placeholder color
    textBox.textAlignment = NSTextAlignmentLeft;
    textBox.scrollEnabled = NO;
    textBox.editable = YES;
    textBox.delegate = self;
    textBox.backgroundColor = [UIColor clearColor];
    textBox.returnKeyType = UIReturnKeyDefault;
    selectedOverlayColor = [UIColor clearColor];
    
    
    // Initial frame setup
    CGFloat textWidth = 250;
    CGFloat textHeight = 50;
    CGFloat padding = 20; // 20
    
    // Calculate safe area above the keyboard
    // keyboardHeight = 216;  // Default keyboard height (adjust dynamically if needed)
    CGFloat safeAreaTop = fullScreen.size.height - keyboardHeight - textHeight - padding;
    
    // Find a non-overlapping position
    int maxAttempts = 10;
    int attempts = 0;
    CGRect newFrame;
    BOOL intersects = NO;
    
    //    do {
    //        CGFloat newX = arc4random_uniform(sess.frame.bounds.size.width - textWidth - padding * 2) + padding;
    //        CGFloat newY = arc4random_uniform(safeAreaTop - padding * 2) + padding;
    //        newFrame = CGRectMake(newX, newY, textWidth + 20, textHeight + 20);
    //
    //        intersects = NO;
    //        for (UIView *box in self.textBoxes) {
    //            if (CGRectIntersectsRect(box.frame, newFrame)) {
    //                intersects = YES;
    //                break;
    //            }
    //        }
    //        attempts++;
    //    } while (intersects && attempts < maxAttempts);
    // Find a non-overlapping position
    
    do {
        
        CGFloat minXValue = (fullScreen.size.width - sess.frame.bounds.size.width)/2;
        CGFloat minYValue = sess.frame.bounds.size.height/4; //(fullScreen.size.height - sess.frame.bounds.size.height)/2;
        
        // Random X position within bounds
        //CGFloat newX = arc4random_uniform(sess.frame.bounds.size.width - textWidth - 2 * padding) + padding;
        CGFloat newX;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            newX = minXValue + arc4random_uniform(sess.frame.bounds.size.width - textWidth - 2 * padding) + padding;
        }else
        {
            newX = minXValue + arc4random_uniform(sess.frame.bounds.size.width/2);
        }
        // Random Y position within the safe area above the keyboard
        CGFloat newY = minYValue + arc4random_uniform(sess.frame.bounds.size.height*0.4);
        
        newFrame = CGRectMake(newX, newY, textWidth + padding, textHeight + padding);
        NSLog(@"safeAreaTop %f newy %f arc 4 %u",safeAreaTop,(safeAreaTop - 2 * padding),arc4random_uniform(safeAreaTop - 2 * padding));
        NSLog(@"newFrame rect is %@",NSStringFromCGRect(newFrame));
        attempts++;
        
    } while ([self isFrameOverlapping:newFrame] && attempts < maxAttempts);
    
    // Set frame and add subviews
    overlayView.frame = newFrame;
    textBox.frame = CGRectMake(10, 10, textWidth, textHeight);
    
    [overlayView addSubview:textBox];
    [sess.frame addSubview:overlayView]; //mainBackground
    [self.textBoxes addObject:overlayView];  // Track new text box
    
    // Bring the new text box to the front
    [mainBackground bringSubviewToFront:overlayView];
    
    // Add Gesture Recognizers
    [self addGestureRecognizersTo:overlayView];
    
    // Make the new text box the first responder
    [textBox becomeFirstResponder];
    
    // Set the cursor to the beginning of the placeholder text
    UITextRange *range = [textBox textRangeFromPosition:textBox.beginningOfDocument
                                             toPosition:textBox.beginningOfDocument];
    textBox.selectedTextRange = range;
    NSLog(@"Show textview re_Align");
    [self reAlignUI];
    [self DeselectAllSelectedItemForText];
    textEditorSubviewAdded = YES;
}

-(void)DeselectAllSelectedItemForText
{
    NSArray<NSIndexPath *> *selectedIndexFontPaths = [self.fontsCollectionView indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in selectedIndexFontPaths) {
        [self.fontsCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    
    NSArray<NSIndexPath *> *selectedIndexColorPaths = [self.ColorsCollectionView indexPathsForSelectedItems];
    for (NSIndexPath *indexPath in selectedIndexColorPaths) {
        [self.ColorsCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}



- (BOOL)isPointInsideShape:(CGPoint)point inLayer:(CAShapeLayer *)shapeLayer {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:shapeLayer.path];
    return [bezierPath containsPoint:point];
}


- (void)triggerHapticFeedback {
    // Use the heavy impact style for a stronger, one-time haptic feedback
    UIImpactFeedbackGenerator *impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    [impactFeedbackGenerator prepare]; // Prepares the generator for immediate feedback
    [impactFeedbackGenerator impactOccurred]; // Trigger the feedback
}

- (void)setupTrashBin {
    self.trashBinView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"trash.fill"]];
    self.trashBinView.tintColor = [UIColor systemRedColor];
    CGFloat tabBarHeight = 110.0;  // Your tab bar height
    CGFloat binPadding = 20.0;     // Padding above the tab bar
    
    CGFloat binSize = 40.0;  // New, smaller size
    //  CGFloat binY = sess.frame.bounds.size.height + tabBarHeight + binPadding + binSize;
    CGFloat binY;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
       // binY = fullScreen.size.height - tabBarHeight - binPadding - binSize;
    }
    else if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && fullScreen.size.height == 568)
    {
        binSize = 35;
        binPadding = 10;
        binY = sess.frame.frame.size.height - binSize - binPadding; //fullScreen.size.height - tabBarHeight - binPadding;
    }
    else
    {
       // binY = fullScreen.size.height - tabBarHeight - binPadding - binSize;
    }
    binY = sess.frame.frame.size.height - binSize - binPadding;
    
//    self.trashBinView.frame = CGRectMake((fullScreen.size.width / 2) - (binSize / 2),
//                                         binY,
//                                         binSize,
//                                         binSize
//                                         );
    self.trashBinView.frame = CGRectMake((sess.frame.frame.size.width / 2) - (binSize / 2),
                                         binY,
                                         binSize,
                                         binSize
                                         );
    
    self.trashBinView.hidden = YES;
    [sess.frame addSubview:self.trashBinView];//sess.frame
}


-(void)ChangeParent:(UIView *) oldParent :(UIView *)newParent
{
    //    UIView *oldParent = self.view; // Assuming all views share the same parent
    //    UIView *newParent = sif(self.addedstickes)
    if(self.addedstickes.count > 0)
    {
        for (UIView *viewToMove in self.addedstickes) {
            if (viewToMove.superview == oldParent) { // Ensure it belongs to old parent
                // Convert frame to new parent's coordinate space
                NSLog(@"main background frame is %@",NSStringFromCGRect(mainBackground.frame));
                NSLog(@"session frame is %@",NSStringFromCGRect(sess.frame.frame));
                NSLog(@"before view frame is %@",NSStringFromCGRect(viewToMove.frame));
                CGRect newFrame = [oldParent convertRect:viewToMove.frame toView:newParent];
                NSLog(@"after view frame is %@",NSStringFromCGRect(newFrame));
                
                // Change parent
                [viewToMove removeFromSuperview];
                [newParent addSubview:viewToMove];
                
                // Set the adjusted frame
                viewToMove.frame = newFrame;
                [newParent bringSubviewToFront:viewToMove];
            }
        }

    }
    if(self.textBoxes.count > 0)
    {
        for (UIView *viewToMove in self.textBoxes) {
            if (viewToMove.superview == oldParent){ // Ensure it belongs to old parent
                // Convert frame to new parent's coordinate space
                CGRect newFrame = [oldParent convertRect:viewToMove.frame toView:newParent];
                
                // Change parent
                [viewToMove removeFromSuperview];
                [newParent addSubview:viewToMove];
                
                // Set the adjusted frame
                viewToMove.frame = newFrame;
                [newParent bringSubviewToFront:viewToMove];
            }
        }
    }
    CGRect newFrame = [oldParent convertRect:self.trashBinView.frame toView:newParent];
    
    // Change parent
    [self.trashBinView removeFromSuperview];
    [newParent addSubview:self.trashBinView];
    
    // Set the adjusted frame
    self.trashBinView.frame = newFrame;
    [newParent bringSubviewToFront:self.trashBinView];

}

- (void)handleStickerPanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    frameIsEdited = YES;
    UIView *stickerView = gestureRecognizer.view;
    [sess.frame bringSubviewToFront:stickerView]; //mainBackground // to make to it come forward
    if (!stickerView) return;
    CGPoint translation = [gestureRecognizer translationInView:sess.frame];
    stickerView.center = CGPointMake(stickerView.center.x + translation.x, stickerView.center.y + translation.y);
    [gestureRecognizer setTranslation:CGPointZero inView:sess.frame];
    
    CGRect trashDetectionFrame = CGRectInset(self.trashBinView.frame, -1, -1);
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.trashBinView.hidden = NO; // Show trash bin while dragging
            break;
            
        case UIGestureRecognizerStateChanged:
            if (CGRectIntersectsRect(stickerView.frame, trashDetectionFrame)) {
                stickerView.alpha = 0.5; // Fade effect to indicate it's in the trash area
                [self triggerHapticFeedback]; // Trigger haptic feedback when near the trash bin
            } else {
                stickerView.alpha = 1.0;
            }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.trashBinView.hidden = YES; // Hide trash when done
            if (CGRectIntersectsRect(stickerView.frame, trashDetectionFrame)) {
                [self deleteSticker:stickerView]; // Delete only when the user lifts their finger
            } else {
                stickerView.alpha = 1.0; // Restore full opacity if not deleted
            }
            
            break;
            
        default:
            break;
    }
}

- (void)deleteSticker:(UIView *)stickerView {
    frameIsEdited = YES;
    [self triggerHapticFeedback];
    [stickerView removeFromSuperview];
    [self.addedstickes removeObject:stickerView];
    self.trashBinView.hidden = YES;
}




- (void)doneBtnTapped {
    // Find the active text box
    UITextView *activeTextView = [self findActiveTextView];
    [activeTextView resignFirstResponder];
    [self CloseTextEditorUI];
}

-(void)CloseTextEditorUI
{
    self.ellipsisOverlay.hidden = YES;
    self.uitoolbar.hidden = YES;
    self.fontsCollectionView.hidden = YES;
    self.ColorsCollectionView.hidden = YES;
    self.fontSizeSlider.hidden = YES;
    if(colorPicker != nil)
        [colorPicker dismissViewControllerAnimated:YES completion:nil];
    textEditorSubviewAdded = NO;
    [self SetOriginalUI];
}

-(void)CloseTextEditorAllUIExceptColorPickker
{
    self.ellipsisOverlay.hidden = YES;
    self.uitoolbar.hidden = YES;
    self.fontsCollectionView.hidden = YES;
    self.ColorsCollectionView.hidden = YES;
    self.fontSizeSlider.hidden = YES;
    textEditorSubviewAdded = NO;
    [self SetOriginalUI];
}

- (void)changeTextAlignment:(UIBarButtonItem *)sender {
    frameIsEdited = YES;
    self.showingFonts = NO;
    // Find the active text box
    UITextView *activeTextView = [self findActiveTextView];
    self.fontSizeSlider.hidden = NO;
    [mainBackground bringSubviewToFront:self.fontSizeSlider];
    // Define available alignments
    NSArray *alignments = @[@(NSTextAlignmentLeft), @(NSTextAlignmentCenter), @(NSTextAlignmentRight), @(NSTextAlignmentJustified)];
    
    // Update to the next alignment
    self.alignmentIndex = (self.alignmentIndex + 1) % alignments.count;
    activeTextView.textAlignment = (NSTextAlignment)[alignments[self.alignmentIndex] integerValue];
    switch (activeTextView.textAlignment) {
        case NSTextAlignmentLeft:
            sender.image = [UIImage systemImageNamed:@"text.alignleft"];
            break;
        case NSTextAlignmentCenter:
            sender.image = [UIImage systemImageNamed: @"text.aligncenter"];
            break;
        case NSTextAlignmentRight:
            sender.image = [UIImage systemImageNamed: @"text.alignright"];
            break;
        case NSTextAlignmentJustified:
            sender.image = [UIImage systemImageNamed: @"text.justify"];
            break;
        default:
            break;
    }
    [self applyShapeToActiveTextView];
}


- (void)showFontsCollection {
    self.showingFonts = YES;
    self.ellipsisOverlay.hidden = YES;
    self.fontSizeSlider.hidden = YES;
    
    UITextView *activeTextView = [self findActiveTextView];
    if (activeTextView) {
        [activeTextView resignFirstResponder]; // Dismiss keyboard
    }
    
    self.ColorsCollectionView.hidden = NO;
    self.fontsCollectionView.hidden = NO;
}

// Button action to toggle the frame
- (void)toggleFrame {
    //self.isCustomFrameEnabled = !self.isCustomFrameEnabled;
    [self applyCustomFrame];//:self.isCustomFrameEnabled
}

// Function to apply the custom frame or reset to the default frame
- (void)applyCustomFrame {
    // Find the active text box
    UITextView *activeTextView = [self findActiveTextView];
    CAShapeLayer *shapeLayer = [self findCAShapeLayerInView:activeTextView.superview];
    shapeLayer.hidden = NO;
}






- (void)changeOverlayShape {
    self.showingFonts = NO;
    frameIsEdited = YES;
    // Cycle through shapes
    switch (self.currentShape) {
        case OverlayNOShape:
            self.currentShape = OverlayShapeRectangle;
            break;
        case OverlayShapeRectangle:
            self.currentShape = OverlayShapeOval; //OverlayShapeCircle
            break;
//        case OverlayShapeCircle:
//            self.currentShape = OverlayShapeOval;
//            break;
        case OverlayShapeOval:
            self.currentShape = OverlayShapeRoundedRectangle;
            break;
        case OverlayShapeRoundedRectangle:
            self.currentShape = OverlayShapeCustomFrame;  // Fallback to circle
            break;
        case OverlayShapeCustomFrame:
            self.currentShape = OverlayNOShape;
            break;
        
        default:
            self.currentShape = OverlayShapeRectangle;  // Fallback to rectangle
            break;
    }
    
    // Apply the new shape to the active text box
    [self applyShapeToActiveTextView];
}


//- (void)applyShapeToActiveTextView {
//    UITextView *activeTextView = [self findActiveTextView];
//    if (!activeTextView || !activeTextView.superview) {
//        return;
//    }
//    activeTextView.backgroundColor = [UIColor clearColor];
//    UIView *overlayView = activeTextView.superview;
//    
//    // Remove existing shape layers (if any)
//    for (CALayer *layer in [overlayView.layer.sublayers copy]) {
//        if ([layer isKindOfClass:[CAShapeLayer class]]) {
//            [layer removeFromSuperlayer];
//        }
//    }
//    if(selectedOverlayColor == [UIColor clearColor])
//    {
//        NSLog(@"selected OverlayColor is clear");
//        selectedOverlayColor = [UIColor systemGrayColor];
//    }
//    activeTextView.clipsToBounds = NO;
//    activeTextView.layer.masksToBounds = NO;
//    CAShapeLayer *shapeLayer = [self findCAShapeLayerInView:activeTextView];
//    if(!shapeLayer)
//    {
//        shapeLayer = [CAShapeLayer layer];
//        shapeLayer.frame = activeTextView.bounds;
//        shapeLayer.fillColor = selectedOverlayColor.CGColor;
//        //shapeLayer.strokeColor = selectedOverlayColor.CGColor ?: [UIColor redColor].CGColor;
//        shapeLayer.lineWidth = 3.0; // Make more visible
//        shapeLayer.lineDashPattern = nil; // Ensure solid line
//        shapeLayer.zPosition = 0;
//        // [activeTextView.layer insertSublayer:shapeLayer atIndex:0];
//    }
//    
//    // [overlayView.layer addSublayer:shapeLayer];
//    [overlayView.layer insertSublayer:shapeLayer below:activeTextView.layer];
//    NSLog(@"shape layer bounds %@",NSStringFromCGRect(shapeLayer.bounds));
//    NSLog(@"activeTextView bounds %@",NSStringFromCGRect(activeTextView.bounds));
//    // Reset corner radius and mask
//    overlayView.layer.cornerRadius = 0;
//    overlayView.layer.mask = nil;
//    
//    //  overlayView.backgroundColor = selectedOverlayColor; // Clears background
//    NSLog(@"selected Overlay Color %@",selectedOverlayColor);
//    // Apply the new shape
//    switch (self.currentShape) {
//        case OverlayShapeRectangle:
//            NSLog(@"Rectangle");
//            // overlayView.layer.cornerRadius = 0;
//            shapeLayer.path  =
//            [self getCustomShapeForActiveTextWithType].CGPath;
//            //[UIBezierPath bezierPathWithRect:CGRectMake(0, 0,shapeLayer.frame.size.width, shapeLayer.frame.size.height)].CGPath;
//            break;
//        case OverlayShapeOval:
//        {
//            shapeLayer.path = [self getCustomShapeForActiveTextWithType].CGPath;
//            break;
//        }
//            
//        case OverlayShapeRoundedRectangle: {
//            NSLog(@"rounded Rectangle");
//            CGFloat cornerRadius = 20;  // Define your corner radius here
//            // overlayView.layer.cornerRadius = cornerRadius;
//            shapeLayer.path = [self getCustomShapeForActiveTextWithType].CGPath;
//            //[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,shapeLayer.frame.size.width, shapeLayer.frame.size.height)cornerRadius:15.0].CGPath;
//            break;
//        }
//            
//        case OverlayShapeCustomFrame:
//        {
//            shapeLayer.path = [self getcustomShape].CGPath;
//            break;
//        }
//        case OverlayNOShape:
//        {
//            NSLog(@"no shape");
//            shapeLayer.path = nil;
//            // overlayView.backgroundColor = [UIColor clearColor]; // Clears background
//            break;
//        }
//            
//            
//        default:
//            break;
//    }
//    
//    // Clip the text view to the new shape
//    // overlayView.clipsToBounds = YES;
//    [activeTextView.layer setNeedsDisplay];
//    [activeTextView setNeedsLayout];
//    [activeTextView layoutIfNeeded];
//    // Ensure the text view resizes to fit its content
//    //  [self resizeTextViewAndOverlay:activeTextView];
//}




// Resize the text view and overlay
- (void)resizeTextViewAndOverlay:(UITextView *)textView {
    UIView *overlayView = textView.superview;
    if (!overlayView) {
        return;
    }
    
    // Calculate text size
    CGFloat maxWidth = sess.frame.bounds.size.width - 40;
    CGFloat maxHeight = sess.frame.bounds.size.height - 40;
    
    NSDictionary *textAttributes = @{NSFontAttributeName: textView.font};
    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:textAttributes
                                                  context:nil].size;
    
    // Add padding
    CGFloat padding = 20;
    CGFloat newTextBoxWidth = MIN(textSize.width + padding, maxWidth);
    CGFloat newTextBoxHeight = MIN(textSize.height + padding, maxHeight);
    
    // Resize the text view
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, newTextBoxWidth, newTextBoxHeight);
    
    // Resize the overlay view
    overlayView.frame = CGRectMake(overlayView.frame.origin.x, overlayView.frame.origin.y, newTextBoxWidth + padding, newTextBoxHeight + padding);
    
    // Center text view within overlay
    textView.center = CGPointMake(CGRectGetMidX(overlayView.bounds), CGRectGetMidY(overlayView.bounds));
    
    // Ensure overlay stays within imageView bounds
    CGFloat maxY = sess.frame.bounds.size.height - overlayView.frame.size.height;
    CGFloat maxX = sess.frame.bounds.size.width - overlayView.frame.size.width;
    
    CGRect newOverlayFrame = overlayView.frame;
    
    // Restrict position
    if (newOverlayFrame.origin.x < 0) newOverlayFrame.origin.x = 0;
    if (newOverlayFrame.origin.y < 0) newOverlayFrame.origin.y = 0;
    if (newOverlayFrame.origin.x > maxX) newOverlayFrame.origin.x = maxX;
    if (newOverlayFrame.origin.y > maxY) newOverlayFrame.origin.y = maxY;
    
    overlayView.frame = newOverlayFrame;
}

- (BOOL)isiPod {
    UIDevice *device = [UIDevice currentDevice];
    return (device.userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
            CGRectGetHeight(UIScreen.mainScreen.bounds) == 568);
}


- (void)setupSlider {
    CGFloat sliderWidth = 40;  // Thickness of the slider (since it's rotated)
    CGFloat sliderHeight = 230; // Length of the slider
    
    if([self isiPod])
    {
        sliderWidth = 30;
        sliderHeight = 180;
    }
    
    // Initialize slider
    fontSizeSlider = [[UISlider alloc] init];
    fontSizeSlider.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    
    // Slider range
    fontSizeSlider.minimumValue = 10;
    fontSizeSlider.maximumValue = 50;
    fontSizeSlider.value = 16;
    
    //    // Set custom thumb image
    UIImage *thumbImage = [UIImage systemImageNamed:@"circle.fill"
                                  withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:20 weight:UIImageSymbolWeightBold]];
    
    // Render the image with a white color
    UIImage *whiteThumbImage = [[thumbImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] imageWithTintColor:[UIColor whiteColor]];
    
    
    [fontSizeSlider setThumbImage:whiteThumbImage forState:UIControlStateNormal];
    
    // Set custom track image
    //   UIImage *trackImage = [UIImage imageNamed:@"slidertrackImage"];
    // Generate triangle with 50% transparency (alpha = 0.5)
    UIImage *triangleImage = [self triangleTrackImageWithSize:CGSizeMake(30, 20) color:[UIColor whiteColor] alpha:0.5];
    
    
    if (triangleImage) {
        //        UIImage *rotatedTrackImage = [self rotateImage:trackImage byDegrees:90];
        //        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        //        UIImage *resizedTrackImage = [rotatedTrackImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        //
        [fontSizeSlider setMinimumTrackImage:triangleImage forState:UIControlStateNormal];
        [fontSizeSlider setMaximumTrackImage:triangleImage forState:UIControlStateNormal];
    }
    
    fontSizeSlider.tintColor = [UIColor whiteColor]; // Track color (fallback if no image is set)
    
    // Add target for value change
    [fontSizeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Positioning (left-most, center vertically)
    CGFloat xPosition = 20; // Close to the left edge
    CGFloat yPosition = (self.view.bounds.size.height - sliderHeight) / 2 - 50; // Centered vertically
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        xPosition = 14;
    }
    else{
        xPosition = 0;
    }
    
    // Set frame for slider
    fontSizeSlider.frame = CGRectMake(xPosition, yPosition, sliderWidth, sliderHeight);
    fontSizeSlider.hidden = YES;
    // Add slider to the view
    [mainBackground addSubview:fontSizeSlider];
}

- (UIImage *)triangleTrackImageWithSize:(CGSize)size color:(UIColor *)color alpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *transparentColor = [color colorWithAlphaComponent:alpha];
    CGContextSetFillColorWithColor(context, transparentColor.CGColor);
    
    // Draw a left-pointing triangle (-90-degree rotated)
    CGContextMoveToPoint(context, size.width, 0);               // Top-right
    CGContextAddLineToPoint(context, 0, size.height / 2);       // Center-left
    CGContextAddLineToPoint(context, size.width, size.height);  // Bottom-right
    CGContextClosePath(context);
    
    CGContextFillPath(context);
    
    UIImage *triangleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return triangleImage;
}


// Helper function to rotate an image by a specified number of degrees
- (UIImage *)rotateImage:(UIImage *)image byDegrees:(CGFloat)degrees {
    CGFloat radians = degrees * M_PI / 180;
    CGSize rotatedSize = CGRectApplyAffineTransform(CGRectMake(0, 0, image.size.width, image.size.height), CGAffineTransformMakeRotation(radians)).size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        CGContextTranslateCTM(context, rotatedSize.width / 2, rotatedSize.height / 2);
        CGContextRotateCTM(context, radians);
        [image drawInRect:CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height)];
        UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return rotatedImage ?: image;
    }
    return image;
}

- (void)sliderValueChanged:(UISlider *)sender {
    frameIsEdited = YES;
    CGFloat fontSize = sender.value;
    
    // Find the active text view and its overlay
    UITextView *activeTextView = [self findActiveTextView];
    if (!activeTextView || !activeTextView.superview) {
        return;
    }
    
    UIView *overlayView = activeTextView.superview;
    
    // Update font size if changed
    if (activeTextView.font.pointSize != fontSize) {
        activeTextView.font = [activeTextView.font fontWithSize:fontSize];
    }
    
    // Calculate new text size
    CGFloat maxWidth = self.view.frame.size.width - 40;
    CGFloat maxHeight = self.view.frame.size.height - 200;
    
    NSDictionary *textAttributes = @{NSFontAttributeName: activeTextView.font};
    CGSize textSize = [activeTextView.text boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:textAttributes
                                                        context:nil].size;
    
    // Calculate new dimensions
    CGFloat padding = 20;
    CGFloat newTextBoxWidth = MIN(textSize.width + padding, maxWidth);
    CGFloat newTextBoxHeight = MIN(textSize.height + padding, maxHeight);
    CGFloat newOverlayWidth = newTextBoxWidth + padding;
    CGFloat newOverlayHeight = newTextBoxHeight + padding;
    
    // Capture current rotation
    CGFloat rotation = atan2(overlayView.transform.b, overlayView.transform.a);
    
    [UIView animateWithDuration:0.1 animations:^{
        // Reset transform to avoid frame distortion
        overlayView.transform = CGAffineTransformIdentity;
        
        // Resize overlay and text view
        overlayView.frame = CGRectMake(overlayView.frame.origin.x,
                                       overlayView.frame.origin.y,
                                       newOverlayWidth,
                                       newOverlayHeight);
        
        activeTextView.frame = CGRectMake(activeTextView.frame.origin.x,
                                          activeTextView.frame.origin.y,
                                          newTextBoxWidth,
                                          newTextBoxHeight);
        
        // Center the text view within the overlay
        activeTextView.center = CGPointMake(CGRectGetMidX(overlayView.bounds),
                                            CGRectGetMidY(overlayView.bounds));
        
        // Reapply the rotation transform
        overlayView.transform = CGAffineTransformMakeRotation(rotation);
    }];
    [self applyShapeToActiveTextView];
}

/// 3
//- (void)textViewDidChange:(UITextView *)textView {
//    
//    UITextInputMode *mode = textView.textInputMode;
//    NSLog(@"Input mode is now: %@", mode.primaryLanguage);
//    
//    
//    frameIsEdited = YES;
//    // Calculate the new text size
//    CGFloat maxWidth = self.view.bounds.size.width - 40;  // Leave padding on sides
//    CGFloat maxHeight = self.view.bounds.size.height - 40; // Leave padding on top and bottom
//    
//    NSDictionary *textAttributes = @{
//        NSFontAttributeName: textView.font
//    };
//    
//    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
//                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                               attributes:textAttributes
//                                                  context:nil].size;
//    
//    // Calculate new dimensions for the text box and overlay view
//    CGFloat padding = 20; // Padding around the text box
//    CGFloat newTextBoxWidth = MIN(textSize.width + padding, maxWidth);
//    CGFloat newTextBoxHeight = MIN(textSize.height + padding, maxHeight);
//    
//    CGFloat newOverlayWidth = newTextBoxWidth + padding;  // Add additional padding for the overlay
//    CGFloat newOverlayHeight = newTextBoxHeight + padding;
//    
//    // Get the overlay view
//    UIView *overlayView = textView.superview;
//    if (!overlayView) return;
//    // Capture the current rotation transform
//    CGFloat rotation = atan2(overlayView.transform.b, overlayView.transform.a);
//    
//    // Animate changes smoothly
//    [UIView animateWithDuration:0.1 animations:^{
//        // Reset transform to avoid frame distortion during resizing
//        overlayView.transform = CGAffineTransformIdentity;
//        
//        // Resize the text box
//        textView.frame = CGRectMake(textView.frame.origin.x,
//                                    textView.frame.origin.y,
//                                    newTextBoxWidth,
//                                    newTextBoxHeight);
//        
//        // Resize the overlay view
//        overlayView.frame = CGRectMake(overlayView.frame.origin.x,
//                                       overlayView.frame.origin.y,
//                                       newOverlayWidth,
//                                       newOverlayHeight);
//        
//        // Center the text box within the overlay view
//        textView.center = CGPointMake(CGRectGetMidX(overlayView.bounds),
//                                      CGRectGetMidY(overlayView.bounds));
//        
//        // Reapply the rotation transform
//        overlayView.transform = CGAffineTransformMakeRotation(rotation);
//    }];
//    
//    // Ensure the overlay view stays within the bounds of the imageView
//    CGFloat maxX = self.view.bounds.size.width - overlayView.frame.size.width;
//    CGFloat maxY = self.view.bounds.size.height - overlayView.frame.size.height;
//    
//    CGRect newOverlayFrame = overlayView.frame;
//    
//    // Restrict X and Y position inside imageView
//    if (newOverlayFrame.origin.x < 0) newOverlayFrame.origin.x = 0;
//    if (newOverlayFrame.origin.y < 0) newOverlayFrame.origin.y = 0;
//    if (newOverlayFrame.origin.x > maxX) newOverlayFrame.origin.x = maxX;
//    if (newOverlayFrame.origin.y > maxY) newOverlayFrame.origin.y = maxY;
//    
//    overlayView.frame = newOverlayFrame;
//    [self applyShapeToActiveTextView];
//}


- (void)textViewDidChange:(UITextView *)textView {
    
    UITextInputMode *mode = textView.textInputMode;
    NSLog(@"Input mode is now: %@", mode.primaryLanguage);
    
    frameIsEdited = YES;
    
    // Calculate the new text size
    CGFloat maxWidth = self.view.bounds.size.width - 40;
    CGFloat maxHeight = self.view.bounds.size.height - 40;
    
    NSDictionary *textAttributes = @{
        NSFontAttributeName: textView.font
    };
    
    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:textAttributes
                                                  context:nil].size;
    
    // Calculate new dimensions
    CGFloat padding = 20;
    CGFloat newTextBoxWidth = MIN(textSize.width + padding, maxWidth);
    CGFloat newTextBoxHeight = MIN(textSize.height + padding, maxHeight);
    
    CGFloat newOverlayWidth = newTextBoxWidth + padding;
    CGFloat newOverlayHeight = newTextBoxHeight + padding;
    
    UIView *overlayView = textView.superview;
    if (!overlayView) return;
    
    // Capture the current transform BEFORE any changes
    CGAffineTransform currentTransform = overlayView.transform;
    CGFloat rotation = atan2(currentTransform.b, currentTransform.a);
    CGFloat scale = sqrt(currentTransform.a * currentTransform.a + currentTransform.c * currentTransform.c);
    
    // Remove animation or make it instant
    [UIView performWithoutAnimation:^{
        // Reset transform temporarily for accurate frame calculations
        overlayView.transform = CGAffineTransformIdentity;
        
        // Resize the text box
        textView.frame = CGRectMake(textView.frame.origin.x,
                                    textView.frame.origin.y,
                                    newTextBoxWidth,
                                    newTextBoxHeight);
        
        // Resize the overlay view
        overlayView.frame = CGRectMake(overlayView.frame.origin.x,
                                       overlayView.frame.origin.y,
                                       newOverlayWidth,
                                       newOverlayHeight);
        
        // Center the text box within the overlay view
        textView.center = CGPointMake(CGRectGetMidX(overlayView.bounds),
                                      CGRectGetMidY(overlayView.bounds));
        
        // Reapply the original transform
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotation);
        CGAffineTransform scaleTransform = CGAffineTransformScale(rotationTransform, scale, scale);
        overlayView.transform = scaleTransform;
    }];
    
    // Ensure the overlay view stays within bounds (without animation)
    CGFloat maxX = self.view.bounds.size.width - overlayView.frame.size.width;
    CGFloat maxY = self.view.bounds.size.height - overlayView.frame.size.height;
    
    CGRect newOverlayFrame = overlayView.frame;
    
    if (newOverlayFrame.origin.x < 0) newOverlayFrame.origin.x = 0;
    if (newOverlayFrame.origin.y < 0) newOverlayFrame.origin.y = 0;
    if (newOverlayFrame.origin.x > maxX) newOverlayFrame.origin.x = maxX;
    if (newOverlayFrame.origin.y > maxY) newOverlayFrame.origin.y = maxY;
    
    // Apply bounds checking without animation
    if (!CGRectEqualToRect(overlayView.frame, newOverlayFrame)) {
        overlayView.frame = newOverlayFrame;
    }
    
    [self applyShapeToActiveTextView];
}


- (CAShapeLayer *)findCAShapeLayerInView:(UIView *)view {
    for (CALayer *layer in view.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            return (CAShapeLayer *)layer;
        }
    }
    return nil; // Return nil if no CAShapeLayer is found
}


//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    
//    NSLog(@"textview begin editing re_Align");
//    //    if(colorPicker != nil)
//    //        [colorPicker dismissViewControllerAnimated:YES completion:nil];
//    [self reAlignUI];
//    // Set the last active text view
//    self.lastActiveTextView = textView;
//    
//    // Update the slider value to match the font size of the selected text box
//    fontSizeSlider.value = textView.font ? textView.font.pointSize : 16;
//    
//    // Show the placeholder text when the text box is active
//    if (textView.text.length == 0) {
//        textView.text = @"Enter Text";
//        textView.textColor = [UIColor whiteColor]; // Placeholder color
//    }
//    CAShapeLayer *shapeLayer = [self findCAShapeLayerInView:textView.superview];
//    if(shapeLayer)
//    {
//        selectedOverlayColor = [UIColor colorWithCGColor:shapeLayer.fillColor];
//    }
//    // Set the cursor to the beginning of the text view
//    UITextRange *beginning = [textView textRangeFromPosition:textView.beginningOfDocument
//                                                  toPosition:textView.beginningOfDocument];
//    textView.selectedTextRange = beginning;
//    
//    // Show the toolbar and slider
//    uitoolbar.hidden = NO;
//    fontSizeSlider.hidden = NO;
//    [mainBackground bringSubviewToFront:self.fontSizeSlider];
//    textEditorSubviewAdded = YES;
//    
//    // Add a border to indicate the text view is active
//    textView.layer.borderWidth = 2;
//    textView.layer.borderColor = [UIColor clearColor].CGColor;
//    
//    // Update UserDefaults
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fromText"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}





//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//       if ([text isEqualToString:@"\n"]) {
//           return YES;
//       }
//       return YES;
//}



-(void)ShowStickersViewController
{
    self.stickerVC = [[StickerViewController alloc]init];
    self.stickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
    self.stickerVC.edgesForExtendedLayout = UIRectEdgeAll;
    if (@available(iOS 15.0, *)) {
        UISheetPresentationController *sheetController = (UISheetPresentationController *)self.stickerVC.presentationController;
        sheetController.detents = @[[UISheetPresentationControllerDetent mediumDetent],[UISheetPresentationControllerDetent largeDetent]];
        sheetController.preferredCornerRadius = 10;
        self.stickerVC.preferredContentSize = CGSizeMake(fullScreen.size.width, fullScreen.size.height*0.9);
        sheetController.prefersEdgeAttachedInCompactHeight = YES;
        sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = YES; // Ensures full width
        sheetController.delegate = self;
        sheetController.prefersGrabberVisible = YES; // Optional: Hide the grabber
        sheetController.prefersScrollingExpandsWhenScrolledToEdge = NO;
    }
    else {
        // Fallback code for earlier iOS versions (before iOS 15)
        self.stickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isViewLoaded && self.view.window) {
            if (self.presentedViewController == nil) {
                [self presentViewController:self.stickerVC animated:YES completion:nil];
            }
        }
    });
    NSLog(@"Show stickers VC re_Align");
    [self reAlignUI];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO; // Prevents conflict with button taps
}

-(void)ShowSlidersViewController
{
    //    // Initialize the view controller to present
    self.sliderVC = [[SliderViewController alloc] init];
    
    self.sliderVC.inner_Radius = [NSString stringWithFormat:@"%.2f", sess.getInnerRadius];
    self.sliderVC.outter_Radius = [NSString stringWithFormat:@"%.2f", sess.getOuterRadius];
    self.sliderVC.frame_Width = [NSString stringWithFormat:@"%.2f", sess.getFrameWidth];
    self.sliderVC.shadow_Value = [NSString stringWithFormat:@"%.2f", sess.getShadowValue];
    if (@available(iOS 16.0, *)) {
        //    // Set the modal presentation style to page sheet
        self.sliderVC.modalPresentationStyle = UIModalPresentationFormSheet;// UIModalPresentationAutomatic ; //UIModalPresentationPageSheet;
        self.sliderVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.sliderVC.edgesForExtendedLayout = UIRectEdgeAll;
        if (@available(iOS 15.0, *)) {
            UISheetPresentationController *sheetController = (UISheetPresentationController *)self.sliderVC.presentationController;
            if (@available(iOS 16.0, *)) {
                // Define a custom detent at 400 points
                UISheetPresentationControllerDetent *smallDetent =
                [UISheetPresentationControllerDetent customDetentWithIdentifier:@"small" resolver:^CGFloat(id<UISheetPresentationControllerDetentResolutionContext>  _Nonnull context) { return small_Detent; }];
                // Configure the sheet presentation
                sheetController.detents = @[smallDetent];
            }else
            {
                sheetController.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
            }
            sheetController.preferredCornerRadius = 10;
            self.sliderVC.preferredContentSize = CGSizeMake(fullScreen.size.width, fullScreen.size.height*0.25);
            sheetController.prefersEdgeAttachedInCompactHeight = YES;
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = YES; // Ensures full width
            sheetController.delegate = self;
            sheetController.prefersGrabberVisible = NO; // Optional: Hide the grabber
        }
        else {
            // Fallback code for earlier iOS versions (before iOS 15)
            self.sliderVC.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isViewLoaded && self.view.window) {
                if (self.presentedViewController == nil) {
                    [self presentViewController:self.sliderVC animated:YES completion:nil];
                }
            }
        });
    }else
    {
        CGFloat viewHeight;
        NSLog(@"screen height %f ", fullScreen.size.height);
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            viewHeight = fullScreen.size.height * 0.25;
        }
        else{
            
            viewHeight = fullScreen.size.height * 0.28;
        }
        // Set the custom frame for the view
        self.sliderVC.view.frame = CGRectMake(0, fullScreen.size.height - viewHeight, fullScreen.size.width, viewHeight);
        
        // Add it as a child view controller
        [self addChildViewController:self.sliderVC];
        [self.view addSubview:self.sliderVC.view];
        sliderSubviewisAdded = YES;
        [self.sliderVC didMoveToParentViewController:self];
    }
    NSLog(@"Show sliders VC re_Align");
    [self reAlignUI];
}

//// Adaptive presentation delegate method
//- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
//    return UIModalPresentationFullScreen; // Forces full-screen on compact devices
//}

-(void)ShowBackgroundViewController
{
    // Initialize the view controller to present
    self.sheetBGVC = [[BackgroundSelectionViewController alloc] init];
    if (@available(iOS 16.0, *)) {
        // Set the modal presentation style to page sheet
        self.sheetBGVC.modalPresentationStyle = UIModalPresentationFormSheet; //UIModalPresentationPageSheet;
        self.sheetBGVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.sheetBGVC.edgesForExtendedLayout = UIRectEdgeAll;
        // Set the preferred content size to match screen width
        self.sheetBGVC.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 400); // Adjust height as needed
        //  sheetBGVC.modalInPresentation = YES;
        // Disable dragging
        if (@available(iOS 15.0, *)) {
            UISheetPresentationController *sheetController = (UISheetPresentationController *)self.sheetBGVC.presentationController;
            if (@available(iOS 16.0, *)) {
                // Define a custom detent at 400 points
                UISheetPresentationControllerDetent *verySmallDetent =
                [UISheetPresentationControllerDetent customDetentWithIdentifier:@"verysmall" resolver:^CGFloat(id<UISheetPresentationControllerDetentResolutionContext>  _Nonnull context) {
                    //                            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){return fullScreen.size.height * 0.3;
                    //                            }else{return fullScreen.size.height * 0.25;}
                    return verySmall_Detent;
                }];
                // Configure the sheet presentation
                sheetController.detents = @[verySmallDetent];
            }else
            {
                sheetController.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
            }
            sheetController.preferredCornerRadius = 10;
            self.sheetBGVC.preferredContentSize = CGSizeMake(fullScreen.size.width, fullScreen.size.height*0.9);
            sheetController.prefersEdgeAttachedInCompactHeight = YES;
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = YES; // Ensures full width
            sheetController.delegate = self;
            sheetController.prefersGrabberVisible = NO; // Optional: Hide the grabber
            //        sheetController.topMargin = 0; // Optional: Adjust the top margin if needed
            //        sheetController.allowsDragging = NO; // Disable dragging
        }
        else {
            // Fallback code for earlier iOS versions (before iOS 15)
            self.sheetBGVC.modalPresentationStyle = UIModalPresentationFullScreen;
            self.sheetBGVC.preferredContentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 300); // Fallback height
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isViewLoaded && self.view.window) {
                if (self.presentedViewController == nil) {
                    [self presentViewController:self.sheetBGVC animated:YES completion:nil];
                }
            }
        });
    }else{
        CGFloat viewHeight;
        NSLog(@"screen height %f ", fullScreen.size.height);
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            viewHeight = fullScreen.size.height * 0.25;
        }
        else{
            
            viewHeight = fullScreen.size.height * 0.25;
        }
        // Set the custom frame for the view
        self.sheetBGVC.view.frame = CGRectMake(0, fullScreen.size.height - viewHeight, fullScreen.size.width, viewHeight);
        
        // Add it as a child view controller
        [self addChildViewController:self.sheetBGVC];
        [self.view addSubview:self.sheetBGVC.view];
        backgroundSubviewisAdded = YES;
        [self.sheetBGVC didMoveToParentViewController:self];
    }
    NSLog(@"Show BG VC re_Align");
    [self reAlignUI];
}

- (void)removeBgViewController{
    [self.sheetBGVC willMoveToParentViewController:nil];   // Notify it will be removed
    [self.sheetBGVC.view removeFromSuperview];              // Remove its view from superview
    [self.sheetBGVC removeFromParentViewController];        // Detach it from parent
    backgroundSubviewisAdded = NO;
}

- (void)removeSliderViewController{
    [self.sliderVC willMoveToParentViewController:nil];   // Notify it will be removed
    [self.sliderVC.view removeFromSuperview];              // Remove its view from superview
    [self.sliderVC removeFromParentViewController];        // Detach it from parent
    sliderSubviewisAdded = NO;
}

- (void)removeEffectsViewController{
    [self.sheetFilterVC willMoveToParentViewController:nil];   // Notify it will be removed
    [self.sheetFilterVC.view removeFromSuperview];              // Remove its view from superview
    [self.sheetFilterVC removeFromParentViewController];        // Detach it from parent
    effectSubviewAdded = NO;
    if (self.sheetFilterVC.presentingViewController) {
        [self.sheetFilterVC dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)DismissBGSheet
{
    [self.sheetBGVC dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)presentationControllerShouldDismiss:(UIPresentationController *)presentationController
{
    return YES;
}


// This method working for shapes videos
- (void)renderMaskedVideoWithVideoURL:(NSURL *)videoURL
                                index:(int)index
                           shapeImage:(UIImage *)shapeImage
                           videoFrame:(CGRect)videoFrame
                           shapeFrame:(CGRect)shapeFrame
                        progressBlock:(void (^)(float))progressBlock
                            outputURL:(NSURL *)outputURL
                           completion:(void (^)(BOOL success, NSError *error))completion
{
    
    
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    if (!track) {
        completion(NO, [NSError errorWithDomain:@"Video" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"No video track"}]);
        return;
    }
    
    CGSize canvasSize = videoFrame.size;
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                              ofTrack:track
                               atTime:kCMTimeZero
                                error:nil];
    
    // Add audio track if available
    if (audioTrack) {
        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                       ofTrack:audioTrack
                                        atTime:kCMTimeZero
                                         error:nil];
    }
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = canvasSize;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    //instruction.backgroundColor = sessionFrameColor.CGColor;
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction =
    [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionTrack];
    
    CGSize naturalSize = track.naturalSize;
    CGAffineTransform preferredTransform = track.preferredTransform;
    CGSize transformedSize = CGSizeApplyAffineTransform(naturalSize, preferredTransform);
    transformedSize.width = fabs(transformedSize.width);
    transformedSize.height = fabs(transformedSize.height);
    NSLog(@"video natural size is %@",NSStringFromCGSize(naturalSize));
    NSLog(@"canvas size is %@",NSStringFromCGSize(canvasSize));
    NSLog(@"video frame is %@",NSStringFromCGRect(videoFrame));
    NSLog(@"shape frame is %@",NSStringFromCGRect(shapeFrame));
    CGFloat scale = MIN(canvasSize.width / transformedSize.width,
                        canvasSize.height / transformedSize.height);
    NSLog(@"scale is %f",scale);
    CGFloat scaledWidth = transformedSize.width * scale;
    CGFloat scaledHeight = transformedSize.height * scale;
    
    CGFloat tx = (canvasSize.width - scaledWidth) / 2.0;
    CGFloat ty = (canvasSize.height - scaledHeight) / 2.0;
    NSLog(@"tx is %f ty is %f",tx,ty);
    
    Photo *pt = [sess.frame getPhotoAtIndex:index];
    
    CGFloat zoom = pt.view.scrollView.zoomScale - pt.view.scrollView.minimumZoomScale;
    // Step 1: Apply custom zoom scale
    CGFloat zoomScale = scale + zoom ; //pt.view.scrollView.zoomScale; // from scrollView.zoomScale scale; //
    CGFloat finalScale = pt.view.scrollView.zoomScale * upscaleFactor;
    NSLog(@"zoom scale is %f zoomScale %f",pt.view.scrollView.zoomScale,zoomScale);
    // Step 2: Translate to apply content offset (pan)
    CGPoint offset = pt.view.scrollView.contentOffset; // from scrollView.contentOffset
    NSLog(@"offset x is %f offset y is %f",offset.x,offset.y);
    
    CGSize scaledVideoSize = CGSizeMake(transformedSize.width * finalScale,
                                        transformedSize.height * finalScale);
    
    NSLog(@"scaled Video Size %@",NSStringFromCGSize(scaledVideoSize));
    // Centering logic
    CGFloat extraX = MAX((canvasSize.width - scaledVideoSize.width) / 2.0, 0);
    CGFloat extraY = MAX((canvasSize.height - scaledVideoSize.height) / 2.0, 0);
    
    NSLog(@"extraX : %f , extraY : %f",extraX,extraY);
    // Final transform
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // 1. Translate by offset + centering gap (unscaled)
    transform = CGAffineTransformTranslate(transform,
                                           -offset.x + extraX,
                                           -offset.y + extraY);
    
    // 2. Apply zoom scale
    transform = CGAffineTransformScale(transform, finalScale, finalScale);
    
    
    [layerInstruction setTransform:transform atTime:kCMTimeZero];
    instruction.layerInstructions = @[layerInstruction];
    videoComposition.instructions = @[instruction];
    videoComposition.renderSize = canvasSize;
    videoComposition.renderScale = 1.0;
    
    
    if (@available(iOS 13.0, *)) {
        // Enable hardware acceleration for alpha compositing
        videoComposition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2;
        videoComposition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2;
        videoComposition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2;
    }
    
    //    CALayer *backgroundLayer = [CALayer layer];
    //    backgroundLayer.frame = parentLayer.bounds;
    //    backgroundLayer.backgroundColor = UIColor.clearColor.CGColor;
    //    [parentLayer addSublayer:backgroundLayer];
      
    
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    parentLayer.masksToBounds = YES;

    // 1. Prepare your background image (replace with your image source)
    UIImage *backgroundImage = [self tiledImagetoCanvasSize:sess.frame.frame.size];
    UIImage *resizedBackground = [self resizeImageAspectFit:backgroundImage toSize:videoFrame.size];
    
    // 3. Add background image layer
    CALayer *backgroundImageLayer = [CALayer layer];
    backgroundImageLayer.frame = parentLayer.bounds;
    backgroundImageLayer.contents = (id)resizedBackground.CGImage;
    backgroundImageLayer.contentsGravity = kCAGravityResizeAspectFill;
    [parentLayer addSublayer:backgroundImageLayer];
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = parentLayer.bounds;
    
    CALayer *maskedLayer = [CALayer layer];
    maskedLayer.frame = parentLayer.bounds;
    [maskedLayer addSublayer:videoLayer];
    
    CGRect relativeShapeFrame = CGRectMake(
                                           shapeFrame.origin.x - videoFrame.origin.x,
                                           shapeFrame.origin.y - videoFrame.origin.y,
                                           shapeFrame.size.width,
                                           shapeFrame.size.height
                                           );
    NSLog(@"relativeShapeFrame %@", NSStringFromCGRect(relativeShapeFrame));
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = relativeShapeFrame;
    maskLayer.contents = (__bridge id)shapeImage.CGImage;
    maskLayer.contentsGravity = kCAGravityResizeAspectFill;
    maskedLayer.mask = maskLayer;
    
    [parentLayer addSublayer:maskedLayer];
    
    NSLog(@"Canvas: %@", NSStringFromCGSize(canvasSize));
    NSLog(@"Shape Frame: %@", NSStringFromCGRect(shapeFrame));
    
#if TARGET_OS_SIMULATOR
    NSLog(@"Skipping animationTool in simulator to avoid XPC crash.");
#else
    videoComposition.animationTool =
    [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
#endif
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                           presetName:AVAssetExportPresetHEVC1920x1080WithAlpha];
    exportSession.outputURL = outputURL;
    NSLog(@"output url is %@",outputURL);
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.videoComposition = videoComposition;
    
    __block NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (progressBlock) {
            progressBlock(exportSession.progress);
        }
    }];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [progressTimer invalidate];
        progressTimer = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                completion(YES, nil);
            } else {
                completion(NO, exportSession.error);
            }
        });
    }];
}

-(void)removeCircularProgressView
{
    // 1. Remove from superview
    [progressView removeFromSuperview];

    // 2. Release all subviews and layers
    [progressView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // 3. Remove all layers (important for CAShapeLayers)
//    for (CALayer *layer in progressView.layer.sublayers) {
//        [layer removeFromSuperlayer];
//    }
    // Create a copy of the sublayers array before enumeration
    NSArray *sublayers = [progressView.layer.sublayers copy];
    for (CALayer *layer in sublayers) {
        [layer removeFromSuperlayer];
    }
    // 4. Release the strong reference (let ARC handle deallocation)
    progressView = nil;
}

-(void)addCircularProgressViewWithMsg:(NSString*)msgText
{
    // Create progress view
    progressView = [[CircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 180, 200)];
    progressView.center = self.view.center;

    // Customize appearance
    progressView.progressColor = [UIColor colorWithRed:25.0/255.0 green:184.0/255.0 blue:250.0/255.0 alpha:1.0]; //[UIColor systemBlueColor];
    progressView.trackColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    progressView.lineWidth = 8.0;
    progressView.bottomText = msgText;
    progressView.viewBackgroundColor = PHOTO_DEFAULT_COLOR;
    progressView.cornerRadius = 12.0;

    // Customize labels
    progressView.percentageFont = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    progressView.percentageColor = [UIColor whiteColor];
    progressView.bottomTextFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    progressView.bottomTextColor = [UIColor whiteColor];

    // Add to view and animate
    [self.view addSubview:progressView];
}

// this is working code for cropped videos
- (void)createCroppedVideoCollageCompletion:(void (^)(BOOL success, NSError *error))completion
{
   // [self addprogressBarWithMsg:@"Generating Video"];
    [self addCircularProgressViewWithMsg:@"Saving..."];
    
    
    NSMutableArray<NSURL *> *croppedVideoURLs = [NSMutableArray array];
    self.totalMasks = sess.frame.photoCount;
    __block NSInteger completed = 0;
    __block float totalProgress = 0.0f;
    __block float lastReportedProgress = 0.0f;
    float constVideoProgress = 0.25f;
    float remainingPart = 1.0f - constVideoProgress;
    const float videoStageWeight = constVideoProgress / self.totalMasks;
    if ([orderArrayForVideoItems count]==0)
    {
        /* if video order is not set , set them to default oreder*/
        [self setTheDefaultOrderArray];
    }
    // Create a serial queue for progress updates to prevent race conditions
    dispatch_queue_t progressQueue = dispatch_queue_create("com.your.app.progressQueue", DISPATCH_QUEUE_SERIAL);
    @autoreleasepool {
        for (int i = 0; i < self.totalMasks; i++) {
            NSURL *inputURL;
            NSString *effectPath = [sess pathToEffectVideoAtIndex:i];
            if([[NSFileManager defaultManager]fileExistsAtPath:effectPath])
            {
                inputURL = [NSURL fileURLWithPath:effectPath];
            }
            else
            {
                inputURL = [sess getVideoUrlForPhotoAtIndex:i];
            }
            NSLog(@"Input URL is %@",inputURL);
            NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"masked_%ld.mov", (long)i]];
            
            if(YES == [[NSFileManager defaultManager]fileExistsAtPath:tempPath])
            {
                NSLog(@"Delete old files");
                [[NSFileManager defaultManager]removeItemAtPath:tempPath error:nil];
            }
            NSURL *outputURL = [NSURL fileURLWithPath:tempPath];
            
            if(FRAME_RESOURCE_TYPE_PHOTO == [sess getFrameResourceTypeAtIndex:i])
            {
                // change code to collage all cropped videos
                completed++;
                if (completed == self.totalMasks) {
                    // [self finishCroppedCollageExportWithCroppedURLs:croppedVideoURLs completion:completion];
                    [self createVideoCollageFromCroppedVideos:croppedVideoURLs playbackOrder:orderArrayForVideoItems progressBlock:^(float finalStageProgress) {
                        //update progress here
                        // Final export stage is 25% → 100%
                        //  NSLog(@"final Stage Progress %f",finalStageProgress);
                        [self update_Progress:(constVideoProgress + finalStageProgress * remainingPart)];
                    } completion:^(BOOL success, NSError *error) {
                        [self update_Progress:1.0];
                        completion(success, error);
                    }];
                }
            }
            else
            {
                [self renderVideo:inputURL index:i outputURL:outputURL progressBlock:^(float videoProgress) {
                    // Calculate this video's contribution to total progress
                    float videoContribution = videoProgress * videoStageWeight;
                    dispatch_async(progressQueue, ^{
                        // Only allow progress to move forward (not decrease)
                        
                        float newProgress = MIN(totalProgress + videoContribution, (i + 1) * videoStageWeight);
                        
                        if (newProgress > lastReportedProgress) {
                            lastReportedProgress = newProgress;
                            totalProgress = newProgress;
                            // NSLog(@"totalProgress %f",totalProgress);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self update_Progress:totalProgress];
                            });
                        }
                    });
                } completion:^(BOOL success, NSError *error) {
                    if (success) {
                        @synchronized (croppedVideoURLs) {
                            [croppedVideoURLs addObject:outputURL];
                        }
                    }
                    completed++;
                    if (completed == self.totalMasks) {
                        //[self finishCroppedCollageExportWithCroppedURLs:croppedVideoURLs completion:completion];
                        // Ensure we're at least at 25%
                        dispatch_async(dispatch_get_main_queue(), ^{
                            @autoreleasepool {
                                [self createVideoCollageFromCroppedVideos:croppedVideoURLs playbackOrder:orderArrayForVideoItems progressBlock:^(float finalStageProgress) {
                                    // Update progress here
                                    // Final export stage is 80% → 100%
                                    [self update_Progress:(constVideoProgress + finalStageProgress * remainingPart)];
                                } completion:^(BOOL success, NSError *error) {
                                    [self update_Progress:1.0];
                                    completion(success, error);
                                }];
                            }
                        });
                        
                    }
                }];
            }
            
        }
    }
}



- (UIImage *)cropImage:(UIImage *)image
        toVisibleFrame:(CGSize)visibleSize
                  zoom:(CGFloat)zoomScale
               offsetX:(CGFloat)offsetX
               offsetY:(CGFloat)offsetY
{
    
    // Create a graphics context of the visible (cropped) size
    UIGraphicsBeginImageContextWithOptions(visibleSize, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Apply transform: zoom, then offset (mimicking scrollView zoom and scroll)
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // Translate to simulate scrolling (offset)
    transform = CGAffineTransformTranslate(transform, -offsetX, -offsetY);
    
    // Apply zoom (scaling)
    transform = CGAffineTransformScale(transform, zoomScale, zoomScale);
    
    CGContextConcatCTM(context, transform);
    
    // Draw the image into context
    [image drawAtPoint:CGPointZero];
    
    // Extract cropped image
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}


// This is working code for shapes videos


//- (void)createVideoCollageFromCroppedVideos:(NSArray<NSURL *> *)videoURLs
//                              playbackOrder:(NSArray<NSNumber *> *)playbackOrder
//                              progressBlock:(void (^)(float))progressBlock
//                                 completion:(void (^)(BOOL success, NSError *error))completion
//{
//    CGSize canvasSize  = CGSizeMake(sess.frame.frame.size.width *upscaleFactor, sess.frame.frame.size.height *upscaleFactor);
//
//    UIImage *image = [self tiledImagetoCanvasSize:sess.frame.frame.size];
//
//    UIImage *resizedImg = [self resizeImageAspectFit:image toSize:canvasSize];
//
//    NSURL *outputURL = [NSURL fileURLWithPath:[sess pathToCurrentVideo]];
//    //    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
//
//    AVMutableComposition *composition = [AVMutableComposition composition];
//    NSMutableArray<AVMutableVideoCompositionLayerInstruction *> *layerInstructions = [NSMutableArray array];
//
//    CALayer *parentLayer = [CALayer layer];
//    parentLayer.geometryFlipped = YES;
//    parentLayer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
//    parentLayer.contents = (id)resizedImg.CGImage;
//    parentLayer.contentsGravity = kCAGravityResizeAspectFill; // or Resize, ResizeAspect depending on your layout
//    //parentLayer.backgroundColor = UIColor.whiteColor.CGColor;
//    parentLayer.opaque = YES;
//
//    // Step A: Create the main video layer
//    CALayer *videoLayer = [CALayer layer];
//    videoLayer.frame = parentLayer.bounds;
//    videoLayer.backgroundColor = UIColor.clearColor.CGColor;
//    videoLayer.opaque = NO;
//    [parentLayer addSublayer:videoLayer];
//
//    CALayer *imageOverlayLayer = [CALayer layer];
//    imageOverlayLayer.frame = videoLayer.bounds;
//    imageOverlayLayer.backgroundColor = UIColor.clearColor.CGColor;
//    [videoLayer addSublayer:imageOverlayLayer];
//
//
//    CMTime currentTime = kCMTimeZero;
//    CMTime maxDurationPerVideo = CMTimeMakeWithSeconds(durationOftheVideo, 600);
//
//    // Calculate total duration in advance for white background
//    CMTime totalDuration = kCMTimeZero;
//
//    int countOfMaskedVideo = 0;
//
//    // Step 2: Add white background (only if NOT sequential)
//    if (!isSequentialPlay) {
//        for (int i = 0; i < videoURLs.count; i++) {
//            AVAsset *asset = [AVAsset assetWithURL:videoURLs[i]];
//            CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
//            totalDuration = CMTimeMaximum(totalDuration, duration);
//        }
//        currentTime = totalDuration;
//    }
//
//    // Step 3: Add video layers
//    CMTime sequentialTime = kCMTimeZero;
//
//    for (int i = 0; i < sess.frame.photoCount; i++) {
//        Photo *poto = [sess.frame getPhotoAtIndex:i];
//        if(FRAME_RESOURCE_TYPE_PHOTO == [sess getFrameResourceTypeAtIndex:i])
//        {
//            CGRect imgFrame = CGRectMultiply(poto.frame, upscaleFactor);
//            CGFloat imgZoom = poto.view.scrollView.zoomScale * upscaleFactor;
//            CGPoint imgOffset = CGPointMake(poto.view.scrollView.contentOffset.x * upscaleFactor, poto.view.scrollView.contentOffset.y * upscaleFactor);
//            UIImage *croppedImg = [self cropImage:poto.view.imageView.image toVisibleFrame:imgFrame.size zoom:imgZoom offsetX:imgOffset.x offsetY:imgOffset.y];
//            CALayer *imageLayer = [CALayer layer];
//            imageLayer.frame = imgFrame;
//            imageLayer.contents = (__bridge id)croppedImg.CGImage;
//            imageLayer.contentsGravity = kCAGravityResizeAspectFill;
//            [videoLayer addSublayer:imageLayer];
//        }
//        else {
//            NSURL *videoURL = videoURLs[countOfMaskedVideo];
//            CGPoint videoOffset = CGPointMake(poto.view.scrollView.contentOffset.x * upscaleFactor, poto.view.scrollView.contentOffset.y * upscaleFactor);
//            CGRect videoFrame = CGRectMultiply(poto.actualFrame,upscaleFactor);
//            NSLog(@"shape frame %@ video actual %@",NSStringFromCGRect(poto.frame),NSStringFromCGRect(poto.actualFrame));
//            AVAsset *asset = [AVAsset assetWithURL:videoURL];
//            AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//            if (!track) continue;
//
//            CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
//            CMTime startTime = isSequentialPlay ? sequentialTime : kCMTimeZero;
//
//            // Insert into composition
//            AVMutableCompositionTrack *compTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//
//            [compTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
//                               ofTrack:track
//                                atTime:startTime
//                                 error:nil];
//
//            // Audio selected from library
//                NSMutableArray *audioFiles = [[NSMutableArray alloc]initWithCapacity:1];
//                BOOL useLibraryAudio = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY]boolValue];
//            NSLog(@"use Library Audio %@",useLibraryAudio?@"Yes":@"NO");
//                if(useLibraryAudio)
//                {
//                    NSNumber *persistentId = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
//                    NSLog(@"use Library Audio document picker audio file url is %@ ",[[NSUserDefaults standardUserDefaults] URLForKey:KEY_AUDIOURL_SELECTED_FROM_FILES]);
//                    MPMediaItem *mItem = [self getMediaItemFromMediaItemId:persistentId];
//                    NSLog(@"m item is %@",mItem);
//                    NSURL *audioUrl;
//                    if(nil != mItem)
//                    {
//                        audioUrl = [mItem valueForProperty:MPMediaItemPropertyAssetURL];
//                    }
//                    else{
//                        audioUrl = [[NSUserDefaults standardUserDefaults] URLForKey:KEY_AUDIOURL_SELECTED_FROM_FILES];
//
//                    }
//                        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
//                        AVAssetTrack *audioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//                        if (audioTrack) {
//                            AVMutableCompositionTrack *compAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//                            [compAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
//                                                    ofTrack:audioTrack
//                                                     atTime:startTime
//                                                      error:nil];
//                        }
//                }
//                else{
//                    // Insert audio track if available
//                    AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//                    if (audioTrack) {
//                        AVMutableCompositionTrack *compAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//                        [compAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
//                                                ofTrack:audioTrack
//                                                 atTime:startTime
//                                                  error:nil];
//                    }
//                }
//
//            // Transform
//            CGSize naturalSize = track.naturalSize;
//            CGAffineTransform preferredTransform = track.preferredTransform;
//            CGSize transformedSize = CGSizeApplyAffineTransform(naturalSize, preferredTransform);
//            transformedSize.width = fabs(transformedSize.width);
//            transformedSize.height = fabs(transformedSize.height);
//
//            CGFloat scale = MIN(videoFrame.size.width / transformedSize.width,
//                                videoFrame.size.height / transformedSize.height);
//
//            NSLog(@"naturalSize %@ , transformedSize %@",NSStringFromCGSize(naturalSize),NSStringFromCGSize(transformedSize));
//            CGFloat scaledWidth = transformedSize.width * scale;
//            CGFloat scaledHeight = transformedSize.height * scale;
//            NSLog(@"videoframe %@",NSStringFromCGRect(videoFrame));
//            NSLog(@"scaledWidth: %f scaledHeight: %f",scaledWidth,scaledHeight);
//            CGFloat tx = videoFrame.origin.x + (videoFrame.size.width - scaledWidth) / 2.0;
//            CGFloat ty = videoFrame.origin.y + (videoFrame.size.height - scaledHeight) / 2.0;
//            NSLog(@"tx: %f ty: %F",tx,ty);
//            CGAffineTransform finalTransform = CGAffineTransformConcat(preferredTransform, CGAffineTransformMakeScale(scale, scale));
//            finalTransform = CGAffineTransformTranslate(finalTransform, tx / scale, ty / scale);
//
//            AVMutableVideoCompositionLayerInstruction *layerInstruction =
//            [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compTrack];
//
//            [layerInstruction setTransform:finalTransform atTime:kCMTimeZero];
//            [layerInstructions addObject:layerInstruction];
//            if(isSequentialPlay)
//            {
//                for (int j = 0; j < videoURLs.count; j++) {
//                    NSLog(@"before masked video as thumbnail image is j %d countOfMaskedVideo %d ",j,countOfMaskedVideo);
//                    if (j == countOfMaskedVideo) continue;
//                    NSLog(@"after masked video as thumbnail image is j %d countOfMaskedVideo %d",j,countOfMaskedVideo);
//                    Photo *pt = [sess.frame getPhotoAtIndex:j];
//
//                    CGRect thumbImgFrame = CGRectMultiply(pt.frame, upscaleFactor);
//                    CGFloat thumbImgZoom = pt.view.scrollView.zoomScale * upscaleFactor;
//                    CGPoint thumbImgOffset = CGPointMake(pt.view.scrollView.contentOffset.x * upscaleFactor, pt.view.scrollView.contentOffset.y * upscaleFactor);
//                    UIImage *croppedThumbImg = [self cropImage:pt.view.imageView.image toVisibleFrame:thumbImgFrame.size zoom:thumbImgZoom offsetX:thumbImgOffset.x offsetY:thumbImgOffset.y];
//
//                    CALayer *imageLayer = [CALayer layer];
//                    imageLayer.frame = thumbImgFrame;
//                    imageLayer.contents = (__bridge id)croppedThumbImg.CGImage;
//                    imageLayer.contentsGravity = kCAGravityResizeAspectFill;
//                    imageLayer.opacity = 1;
////                    imageLayer.masksToBounds = YES;
////                    imageLayer.beginTime = CMTimeGetSeconds(sequentialTime);
////                    imageLayer.duration = CMTimeGetSeconds(duration);
////                    [imageOverlayLayer addSublayer:imageLayer];
//
//                    CAKeyframeAnimation *fadeAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//                    fadeAnim.values = @[@0.0, @1.0, @1.0, @0.0];
//                    fadeAnim.keyTimes = @[@0.0, @0.01, @0.99, @1.0];
//                    fadeAnim.beginTime = AVCoreAnimationBeginTimeAtZero + CMTimeGetSeconds(sequentialTime);
//                    fadeAnim.duration = CMTimeGetSeconds(duration);
//                    fadeAnim.removedOnCompletion = NO;
//                    fadeAnim.fillMode = kCAFillModeBoth;
//                    [imageLayer addAnimation:fadeAnim forKey:@"opacityKeyframe"];
//                    imageLayer.opacity = 0; // Ensure base layer is hidden outside animation
//                    [imageOverlayLayer addSublayer:imageLayer];
//                }
//                sequentialTime = CMTimeAdd(sequentialTime, duration);
//            }
//            countOfMaskedVideo++;
//        }
//    }
//
//    CMTime finalDuration = isSequentialPlay ? sequentialTime : totalDuration;
//
//    ///// ------------------------------------------------------------------------------------------------------------------
//
//    // 4. Apply rounded corner mask to parent layer
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:parentLayer.bounds cornerRadius:sess.getOuterRadius * upscaleFactor];
//    maskLayer.path = roundedPath.CGPath;
//    maskLayer.frame = parentLayer.bounds;
//    parentLayer.mask = maskLayer;
//
//    // 1. Prepare your mask path (already done)
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, canvasSize.width, canvasSize.height) cornerRadius:sess.getOuterRadius * upscaleFactor];
//
//    for (int k = 0; k < sess.frame.photoCount; k++) {
//        Photo *poto = [sess.frame getPhotoAtIndex:k];
//        CGRect shapeRect = CGRectMultiply(poto.frame, upscaleFactor); // poto.frame;
//        NSLog(@"Index is %d Frame is %@",k,NSStringFromCGRect(shapeRect));
//        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:shapeRect cornerRadius:sess.getInnerRadius * upscaleFactor];
//        [maskPath appendPath:roundedRect];
//    }
//    maskPath.usesEvenOddFillRule = YES;
//
//    // 2. Create a shape layer for the even-odd mask
//    CAShapeLayer *mask_Layer = [CAShapeLayer layer];
//    mask_Layer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
//    mask_Layer.path = maskPath.CGPath;
//    mask_Layer.fillRule = kCAFillRuleEvenOdd;
//
//    // 3. Create an image layer that fills the area
//    CALayer *imageFillLayer = [CALayer layer];
//    imageFillLayer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
//    imageFillLayer.contents = (id)resizedImg.CGImage;
//    imageFillLayer.contentsGravity = kCAGravityResizeAspectFill; // or Resize, ResizeAspect depending on your layout
//    imageFillLayer.mask = mask_Layer; // apply the complex mask
//
//    // 5. Add to video layer
//    [videoLayer addSublayer:imageFillLayer];
//
//
//    // To add all text overlays
//    CALayer *overlaysLayer = [CALayer layer];
//    overlaysLayer.frame = parentLayer.bounds;
//    overlaysLayer.backgroundColor = UIColor.clearColor.CGColor;
//    [parentLayer addSublayer:overlaysLayer];
//
//    // To add all sticker overlays
//    CALayer *stickersLayer = [CALayer layer];
//    stickersLayer.frame = overlaysLayer.bounds;
//    stickersLayer.backgroundColor = UIColor.clearColor.CGColor;
//    [overlaysLayer addSublayer:stickersLayer];
//
//    if(self.addedstickes.count > 0)
//    {
//        for (UIView *addedSticker in self.addedstickes) {
//            // For Retina-quality (2x or 3x)
//            CGFloat nativeScale = [UIScreen mainScreen].scale;
//            UIImage *snapshot = [self snapshotViewAccurately:addedSticker scale:nativeScale];
//
//            NSLog(@"Snapshot size: %.0f x %.0f", snapshot.size.width * snapshot.scale, snapshot.size.height * snapshot.scale);
//
//            CALayer *imageLayer = [CALayer layer];
//            imageLayer.contents = (__bridge id)snapshot.CGImage;
//            imageLayer.frame = CGRectMultiply(addedSticker.frame, upscaleFactor);
//            imageLayer.geometryFlipped = YES; // Optional for AVFoundation export
//            [stickersLayer addSublayer:imageLayer];
//        }
//    }
//
//
//    // To add all text overlays
//    CALayer *textsLayer = [CALayer layer];
//    textsLayer.frame = overlaysLayer.bounds;
//    textsLayer.backgroundColor = UIColor.clearColor.CGColor;
//    [overlaysLayer addSublayer:textsLayer];
//
//    if(self.textBoxes.count > 0)
//    {
//        for (UIView *addedText in self.textBoxes) {
//
//            // For Retina-quality (2x or 3x)
//            CGFloat nativeScale = [UIScreen mainScreen].scale;
//            UIImage *snapshot = [self snapshotViewAccurately:addedText scale:nativeScale];
//
//            NSLog(@"Snapshot size: %.0f x %.0f", snapshot.size.width * snapshot.scale, snapshot.size.height * snapshot.scale);
//
//            CALayer *imageLayer = [CALayer layer];
//            imageLayer.contents = (__bridge id)snapshot.CGImage;
//            imageLayer.frame = CGRectMultiply(addedText.frame, upscaleFactor); //addedText.frame;
//            imageLayer.geometryFlipped = YES; // Optional for AVFoundation export
//            [textsLayer addSublayer:imageLayer];
//
//        }
//    }
//
//
//    ////------------------------------------------------------------------------------------------------------------------
//
//
//    // Compose final video
//    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, finalDuration);
//    instruction.layerInstructions = layerInstructions;
//
//    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
//    videoComposition.renderSize = canvasSize;
//    videoComposition.frameDuration = CMTimeMake(1, 30);
//    videoComposition.instructions = @[instruction];
//
//    if (@available(iOS 13.0, *)) {
//        // Enable hardware acceleration for alpha compositing
//        videoComposition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2;
//        videoComposition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2;
//        videoComposition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2;
//    }
//
//#if TARGET_OS_SIMULATOR
//    NSLog(@"Skipping animationTool in simulator to avoid XPC crash.");
//#else
//    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool
//                                      videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
//#endif
//
//    // Use HEVC with alpha when available (iOS 11+)
//    NSString *preset = AVAssetExportPresetHEVCHighestQualityWithAlpha;
//    if (@available(iOS 13.0, *)) {
//        preset = AVAssetExportPresetHEVC1920x1080WithAlpha; // Faster than HighestQuality
//    }
//    // Export
//    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:preset];
//    exportSession.outputURL = outputURL;
//    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
//    exportSession.videoComposition = videoComposition;
//    exportSession.shouldOptimizeForNetworkUse = YES;
//
//
//    __block NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (progressBlock) {
//            progressBlock(exportSession.progress);
//        }
//    }];
//
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//        [progressTimer invalidate];
//        progressTimer = nil;
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
//                completion(YES, nil);
//            } else {
//                completion(NO, exportSession.error);
//            }
//        });
//    }];
//}


- (void)createVideoCollageFromCroppedVideos:(NSArray<NSURL *> *)videoURLs
                              playbackOrder:(NSArray<NSNumber *> *)playbackOrder
                              progressBlock:(void (^)(float))progressBlock
                                 completion:(void (^)(BOOL success, NSError *error))completion
{
    // 1. Setup canvas and background
    CGSize canvasSize = CGSizeMake(sess.frame.frame.size.width * upscaleFactor, sess.frame.frame.size.height * upscaleFactor);
    UIImage *image = [self tiledImagetoCanvasSize:sess.frame.frame.size];
    UIImage *resizedImg = [self resizeImageAspectFit:image toSize:canvasSize];
    NSURL *outputURL = [NSURL fileURLWithPath:[sess pathToCurrentVideo]];
    
    // 2. Create composition and layers
    AVMutableComposition *composition = [AVMutableComposition composition];
    NSMutableArray<AVMutableVideoCompositionLayerInstruction *> *layerInstructions = [NSMutableArray array];
    BOOL useLibraryAudio = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY] boolValue];

    CALayer *parentLayer = [CALayer layer];
    parentLayer.geometryFlipped = YES;
    parentLayer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
//    parentLayer.contents = (id)resizedImg.CGImage;
//    parentLayer.opaque = YES;
    parentLayer.contentsGravity = kCAGravityResizeAspectFill;
    parentLayer.opaque = NO; // Critical for transparency
    parentLayer.backgroundColor = [UIColor clearColor].CGColor;

    
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = parentLayer.bounds;
    videoLayer.backgroundColor = UIColor.clearColor.CGColor;
    videoLayer.opaque = NO;
    [parentLayer addSublayer:videoLayer];
    
    CMTime currentTime = kCMTimeZero;
    CMTime maxDurationPerVideo = CMTimeMakeWithSeconds(durationOftheVideo, 600);
    
    // 3. Calculate total duration for non-sequential play
    CMTime totalDuration = kCMTimeZero;
    if (!isSequentialPlay) {
        for (NSURL *videoURL in videoURLs) {
            AVAsset *asset = [AVAsset assetWithURL:videoURL];
            CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
            totalDuration = CMTimeMaximum(totalDuration, duration);
        }
        currentTime = totalDuration;
    }

    // 4. Create mapping between photo indices and video indices
    NSMutableDictionary *photoIndexToVideoIndex = [NSMutableDictionary dictionary];
    NSMutableArray *allPhotoIndices = [NSMutableArray array];
    int videoIndex = 0;
    for (int i = 0; i < sess.frame.photoCount; i++) {
        if ([sess getFrameResourceTypeAtIndex:i] == FRAME_RESOURCE_TYPE_VIDEO) {
            photoIndexToVideoIndex[@(i)] = @(videoIndex);
            videoIndex++;
        }
        [allPhotoIndices addObject:@(i)]; // Include both photo and video indices
    }
    
    // 5. Determine processing order - use custom order if provided, otherwise natural order
    // NSArray *processingOrder = playbackOrder ?: allPhotoIndices;
    NSArray *processingOrder = isSequentialPlay ? (playbackOrder ?: allPhotoIndices) : allPhotoIndices;
    CMTime sequentialTime = kCMTimeZero;
    for (int k = 0; k < [processingOrder count]; k++) {
        NSLog(@"processingOrder index k %d item is %d ",k,[processingOrder[k] intValue]);
    }
    
    @autoreleasepool {
    // 6. Process all elements in the determined order
    for (NSNumber *photoIndexNum in processingOrder) {
        int i = photoIndexNum.intValue;
        NSLog(@"photoIndexNum is i %d ",i);
        Photo *poto = [sess.frame getPhotoAtIndex:i];
        
        if (FRAME_RESOURCE_TYPE_PHOTO == [sess getFrameResourceTypeAtIndex:i]) {
            // Handle photo elements
            CGRect imgFrame = CGRectMultiply(poto.frame, upscaleFactor);
            CGFloat imgZoom = poto.view.scrollView.zoomScale * upscaleFactor;
            CGPoint imgOffset = CGPointMake(poto.view.scrollView.contentOffset.x * upscaleFactor,
                                            poto.view.scrollView.contentOffset.y * upscaleFactor);
            UIImage *croppedImg = [self cropImage:poto.view.imageView.image
                                   toVisibleFrame:imgFrame.size
                                             zoom:imgZoom
                                          offsetX:imgOffset.x
                                          offsetY:imgOffset.y];
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = imgFrame;
            imageLayer.contents = (__bridge id)croppedImg.CGImage;
            imageLayer.opacity = 1.0;
            imageLayer.contentsGravity = kCAGravityResizeAspectFill;
            [videoLayer addSublayer:imageLayer];
        } else {
            // Handle video elements
            int videoArrayIndex = [photoIndexToVideoIndex[@(i)] intValue];
            NSLog(@"index -  %d video URL -  %@",videoArrayIndex,videoURLs[videoArrayIndex]);
            NSURL *videoURL = videoURLs[videoArrayIndex];
            CGPoint videoOffset = CGPointMake(poto.view.scrollView.contentOffset.x * upscaleFactor,poto.view.scrollView.contentOffset.y * upscaleFactor);
            CGRect videoFrame = CGRectMultiply(poto.actualFrame, upscaleFactor);
            
            AVAsset *asset = [AVAsset assetWithURL:videoURL];
            AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
            if (!track) continue;
            
            CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
            CMTime startTime = isSequentialPlay ? sequentialTime : kCMTimeZero;
            
            // Add video track to composition
            AVMutableCompositionTrack *compTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
            [compTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
                               ofTrack:track
                                atTime:startTime
                                 error:nil];
            
            // Handle audio
            if (useLibraryAudio) {
            } else {
                BOOL isAudioMuted = [sess getAudioMuteValueForPhotoAtIndex:i];
                NSLog(@"cropped isAudioMuted %@",isAudioMuted?@"YES":@"NO");
                if(!isAudioMuted){
                    AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
                    if (audioTrack) {
                        AVMutableCompositionTrack *compAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                             preferredTrackID:kCMPersistentTrackID_Invalid];
                        [compAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
                                                ofTrack:audioTrack
                                                 atTime:startTime
                                                  error:nil];
                    }
                }
            }
            
            // Calculate transform
            CGSize naturalSize = track.naturalSize;
            CGAffineTransform preferredTransform = track.preferredTransform;
            CGSize transformedSize = CGSizeApplyAffineTransform(naturalSize, preferredTransform);
            transformedSize.width = fabs(transformedSize.width);
            transformedSize.height = fabs(transformedSize.height);
            
            CGFloat scale = MIN(videoFrame.size.width / transformedSize.width,
                                videoFrame.size.height / transformedSize.height);
            CGFloat scaledWidth = transformedSize.width * scale;
            CGFloat scaledHeight = transformedSize.height * scale;
            CGFloat tx = videoFrame.origin.x + (videoFrame.size.width - scaledWidth) / 2.0;
            CGFloat ty = videoFrame.origin.y + (videoFrame.size.height - scaledHeight) / 2.0;
            
            CGAffineTransform finalTransform = CGAffineTransformConcat(
                                                                       preferredTransform,
                                                                       CGAffineTransformMakeScale(scale, scale)
                                                                       );
            finalTransform = CGAffineTransformTranslate(finalTransform, tx / scale, ty / scale);
            
            // Create layer instruction
            AVMutableVideoCompositionLayerInstruction *layerInstruction =
            [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compTrack];
            [layerInstruction setTransform:finalTransform atTime:kCMTimeZero];
            [layerInstructions addObject:layerInstruction];
            
            // For sequential play, add thumbnails of other videos
            if (isSequentialPlay) {
                for (int j = 0; j < sess.frame.photoCount; j++) {
                    NSLog(@"i %d j %d",i,j);
                    if (j == i) continue; // Skip current video
                    Photo *pt = [sess.frame getPhotoAtIndex:j];
                    
                    CGRect thumbImgFrame = CGRectMultiply(pt.frame, upscaleFactor);
                    CGFloat thumbImgZoom = pt.view.scrollView.zoomScale * upscaleFactor;
                    CGPoint thumbImgOffset = CGPointMake(pt.view.scrollView.contentOffset.x * upscaleFactor,
                                                         pt.view.scrollView.contentOffset.y * upscaleFactor);
                    UIImage *croppedThumbImg = [self cropImage:pt.view.imageView.image
                                                toVisibleFrame:thumbImgFrame.size
                                                          zoom:thumbImgZoom
                                                       offsetX:thumbImgOffset.x
                                                       offsetY:thumbImgOffset.y];
                   
//                    NSString *filename = [@"croppedThumbImg" stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%d.png", j]];
//                    [self writeImageToFileSystem:croppedThumbImg fileName:filename];
//                    NSLog(@"croppedThumbImg width %f file name %@",croppedThumbImg.size.width,filename);
                    NSLog(@"i %d , j %dsequentialTime %f duration %f",i,j,CMTimeGetSeconds(sequentialTime),CMTimeGetSeconds(duration));
                    CALayer *imageLayer = [CALayer layer];
                    imageLayer.frame = thumbImgFrame;
                    imageLayer.contents = (__bridge id)croppedThumbImg.CGImage;
                    imageLayer.contentsGravity = kCAGravityResizeAspectFill;
                    imageLayer.opacity = 1.0;
                    
//                    CAKeyframeAnimation *fadeAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//                    fadeAnim.values = @[@1.0, @0.0];
//                    fadeAnim.keyTimes = @[@0.99, @1.0];
//                    fadeAnim.beginTime = AVCoreAnimationBeginTimeAtZero + CMTimeGetSeconds(sequentialTime);
//                    fadeAnim.duration = CMTimeGetSeconds(duration);
//                    fadeAnim.removedOnCompletion = YES;
//                    fadeAnim.fillMode = kCAFillModeForwards; //kCAFillModeBoth;
                    
                    // With this:
                    CAKeyframeAnimation *fadeAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
                    fadeAnim.values = @[@1.0, @1.0, @0.0]; // Stay visible for most of the duration
                    fadeAnim.keyTimes = @[@0.0, @0.95, @1.0]; // Only fade out at the very end
                    fadeAnim.beginTime = AVCoreAnimationBeginTimeAtZero + CMTimeGetSeconds(sequentialTime);
                    fadeAnim.duration = CMTimeGetSeconds(duration);
                    fadeAnim.removedOnCompletion = NO;
                    fadeAnim.fillMode = kCAFillModeForwards;
                    
                    
                    [imageLayer addAnimation:fadeAnim forKey:@"opacityKeyframe"];
                    imageLayer.opacity = 0; // Ensure base layer is hidden outside animation
                    [videoLayer addSublayer:imageLayer];
                }
                sequentialTime = CMTimeAdd(sequentialTime, duration);
            }
        }
    }
    }
    // 7. Final duration calculation
    CMTime finalDuration = isSequentialPlay ? sequentialTime : totalDuration;
    
    // Add this before the video processing loop (after creating the composition)
    AVMutableCompositionTrack *libraryAudioTrack = nil;
    if (useLibraryAudio) {
        NSNumber *persistentId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
        NSURL *audioUrl;
        if (persistentId != nil) {
            MPMediaItem *mItem = [self getMediaItemFromMediaItemId:persistentId];
            audioUrl = [mItem valueForProperty:MPMediaItemPropertyAssetURL];
        } else {
            audioUrl = [[NSUserDefaults standardUserDefaults] URLForKey:KEY_AUDIOURL_SELECTED_FROM_FILES];
        }
        
        if (audioUrl) {
            AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
            AVAssetTrack *audioAssetTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
            if (audioAssetTrack) {
                libraryAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                           preferredTrackID:kCMPersistentTrackID_Invalid];
                [libraryAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, finalDuration)
                                          ofTrack:audioAssetTrack
                                           atTime:kCMTimeZero
                                            error:nil];
            }
        }
    }
    
    
    // 8. Apply masks and overlays
    // Outer rounded corners mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:parentLayer.bounds
                                                           cornerRadius:sess.getOuterRadius * upscaleFactor];
    maskLayer.path = roundedPath.CGPath;
    maskLayer.frame = parentLayer.bounds;
    parentLayer.mask = maskLayer;
    
    // Inner frames mask
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, canvasSize.width, canvasSize.height)
                                                        cornerRadius:sess.getOuterRadius * upscaleFactor];
    
    for (int k = 0; k < sess.frame.photoCount; k++) {
        Photo *poto = [sess.frame getPhotoAtIndex:k];
        CGRect shapeRect = CGRectMultiply(poto.frame, upscaleFactor);
        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:shapeRect
                                                               cornerRadius:sess.getInnerRadius * upscaleFactor];
        [maskPath appendPath:roundedRect];
    }
    maskPath.usesEvenOddFillRule = YES;
    
    CAShapeLayer *mask_Layer = [CAShapeLayer layer];
    mask_Layer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    mask_Layer.path = maskPath.CGPath;
    mask_Layer.fillRule = kCAFillRuleEvenOdd;
    
    CALayer *imageFillLayer = [CALayer layer];
    imageFillLayer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    imageFillLayer.contents = (id)resizedImg.CGImage;
    imageFillLayer.contentsGravity = kCAGravityResizeAspectFill;
    imageFillLayer.mask = mask_Layer;
    [videoLayer addSublayer:imageFillLayer];
    
    // 9. Add overlays (stickers and text)
    CALayer *overlaysLayer = [CALayer layer];
    overlaysLayer.frame = parentLayer.bounds;
    overlaysLayer.backgroundColor = UIColor.clearColor.CGColor;
    [parentLayer addSublayer:overlaysLayer];
    
    // Stickers
    if (self.addedstickes.count > 0) {
        CALayer *stickersLayer = [CALayer layer];
        stickersLayer.frame = overlaysLayer.bounds;
        stickersLayer.backgroundColor = UIColor.clearColor.CGColor;
        [overlaysLayer addSublayer:stickersLayer];
        
        for (UIView *addedSticker in self.addedstickes) {
            CGFloat nativeScale = [UIScreen mainScreen].scale;
            UIImage *snapshot = [self snapshotViewAccurately:addedSticker scale:nativeScale];
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.contents = (__bridge id)snapshot.CGImage;
            imageLayer.frame = CGRectMultiply(addedSticker.frame, upscaleFactor);
            imageLayer.geometryFlipped = YES;
            [stickersLayer addSublayer:imageLayer];
        }
    }
    
    // Text
    if (self.textBoxes.count > 0) {
        CALayer *textsLayer = [CALayer layer];
        textsLayer.frame = overlaysLayer.bounds;
        textsLayer.backgroundColor = UIColor.clearColor.CGColor;
        [overlaysLayer addSublayer:textsLayer];
        
        for (UIView *addedText in self.textBoxes) {
            CGFloat nativeScale = [UIScreen mainScreen].scale;
            UIImage *snapshot = [self snapshotViewAccurately:addedText scale:nativeScale];
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.contents = (__bridge id)snapshot.CGImage;
            imageLayer.frame = CGRectMultiply(addedText.frame, upscaleFactor);
            imageLayer.geometryFlipped = YES;
            [textsLayer addSublayer:imageLayer];
        }
    }
    
    //To add watermark to video
    CALayer *watermarkLayer = [CALayer layer];
    watermarkLayer.frame = overlaysLayer.bounds;
    watermarkLayer.backgroundColor = UIColor.clearColor.CGColor;
    [overlaysLayer addSublayer:watermarkLayer];
    
    UIView *water_MarkView = (UIView*)[self.view viewWithTag:TAG_WATERMARKPARENT_View];
    if(water_MarkView && ![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        CGFloat nativeScale = [UIScreen mainScreen].scale;
        UIImage *snapshot = [self snapshotViewAccurately:water_MarkView scale:nativeScale];
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.contents = (__bridge id)snapshot.CGImage;
        imageLayer.frame = CGRectMultiply(water_MarkView.frame, upscaleFactor);
        imageLayer.geometryFlipped = YES;
        [watermarkLayer addSublayer:imageLayer];
    }
    
    // 10. Create video composition
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, finalDuration);
    instruction.layerInstructions = layerInstructions;
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = canvasSize;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    videoComposition.instructions = @[instruction];
    
    if (@available(iOS 13.0, *)) {
        videoComposition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2;
        videoComposition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2;
        videoComposition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2;
    }
    
#if !TARGET_OS_SIMULATOR
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool
                                      videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                      inLayer:parentLayer];
#endif
    
    // 11. Export
    NSString *preset = AVAssetExportPresetHEVCHighestQualityWithAlpha;
    if (@available(iOS 13.0, *)) {
        preset = AVAssetExportPresetHEVC1920x1080WithAlpha;
    }
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:preset];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.videoComposition = videoComposition;
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    __block NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (progressBlock) {
            progressBlock(exportSession.progress);
        }
    }];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [progressTimer invalidate];
        progressTimer = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                completion(YES, nil);
            } else {
                completion(NO, exportSession.error);
            }
        });
    }];
}



- (void)renderVideo:(NSURL *)inputURL
              index:(int)index
          outputURL:(NSURL *)outputURL
      progressBlock:(void (^)(float))progressBlock
         completion:(void (^)(BOOL success, NSError *error))completion {
    Photo *photo = [sess.frame getPhotoAtIndex:index];
    CGRect videoFrame = CGRectMultiply(photo.frame, upscaleFactor);
    CGFloat zoom = photo.view.scrollView.zoomScale * upscaleFactor;
    NSLog(@"scrolview zoom scale is %f",zoom);
    CGPoint offset = CGPointMake(photo.view.scrollView.contentOffset.x * upscaleFactor, photo.view.scrollView.contentOffset.y * upscaleFactor);
    NSLog(@"scrolview offset is %@",NSStringFromCGPoint(offset));
    // Remove existing file
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    
    AVAsset *asset = [AVAsset assetWithURL:inputURL];
    AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    CGSize naturalSize = track.naturalSize;
    
    CGAffineTransform preferredTransform = track.preferredTransform;
    BOOL isPortrait = NO;
    
    if ((preferredTransform.a == 0 && fabs(preferredTransform.b) == 1.0 &&
         fabs(preferredTransform.c) == 1.0 && preferredTransform.d == 0)) {
        // 90° or 270°
        isPortrait = YES;
    }
    
    CMTime duration = CMTimeMinimum(asset.duration, CMTimeMakeWithSeconds(durationOftheVideo, 600));
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
                              ofTrack:track
                               atTime:kCMTimeZero
                                error:nil];
    
    AVAssetTrack *audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    // Add audio track (if present)
    if (audioTrack) {
        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
                                       ofTrack:audioTrack atTime:kCMTimeZero error:nil];
    }
    
    // --- VIDEO COMPOSITION ---
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    
    //UIImage *patternImage = [self imageWithDynamicColor:sessionFrameColor
                                                //  size:videoFrame.size];
    UIImage *image = [self tiledImagetoCanvasSize:videoFrame.size];
    
    //UIImage *resizedImg = [self resizeImageAspectFit:image toSize:canvasSize];
    
   
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, duration);
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction =
    [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionTrack];
    
    // --- Aspect Fill Zooming ---
    CGFloat videoAspect = naturalSize.width / naturalSize.height;
    CGFloat frameAspect = videoFrame.size.width / videoFrame.size.height;
    
    
    
    NSLog(@"video frame %@",NSStringFromCGRect(videoFrame));
    NSLog(@"natural size %@",NSStringFromCGSize(naturalSize));
    NSLog(@"videoAspect = %f  frameAspect = %f",videoAspect,frameAspect);
    CGFloat scaleFactor = 0;
    if (videoAspect > frameAspect) {
        // Wider video – fit height
        scaleFactor = videoFrame.size.height / naturalSize.height;
    } else {
        // Taller video – fit width
        scaleFactor = videoFrame.size.width / naturalSize.width;
    }
    NSLog(@"Scale factor before adding zoom %f",scaleFactor);
    scaleFactor *= zoom; // 👈 Apply user zoom
    NSLog(@"Scale factor after adding zoom %f",scaleFactor);
    
    // Compute the scaled video size
    CGSize scaledVideoSize = CGSizeMake(naturalSize.width * zoom, naturalSize.height * zoom);
    
    // Get visible scroll view size in export scale
    CGSize scrollViewSize = CGSizeApplyAffineTransform(photo.view.scrollView.bounds.size, CGAffineTransformMakeScale(upscaleFactor, upscaleFactor));
    
    NSLog(@"scaled Video Size %@",NSStringFromCGSize(scaledVideoSize));
    NSLog(@"scroll View Size %@",NSStringFromCGSize(scrollViewSize));
    // Compute padding needed to center video when it's smaller than scrollView
    CGFloat extraX = MAX((scrollViewSize.width - scaledVideoSize.width) / 2.0, 0);
    CGFloat extraY = MAX((scrollViewSize.height - scaledVideoSize.height) / 2.0, 0);
    
    NSLog(@"extraX = %f  extraY = %f",extraX,extraY);
    
    
    CGAffineTransform transform ;
    // If the video is portrait, we need to adjust the translation
    if (isPortrait) {
        // Start with the preferred transform to handle orientation
        transform = preferredTransform;
        
        // Apply zoom
        transform = CGAffineTransformScale(transform, zoom, zoom);
        
        // For portrait videos, swap the translation components to account for the rotation
        CGFloat tempX = -offset.y + extraY;
        CGFloat tempY = -offset.x + extraX;
        transform = CGAffineTransformTranslate(transform, tempX, tempY);
    }
    else
    {
        // Final transform
        transform = CGAffineTransformIdentity;
        
        // Move video origin (for offsetX/Y = scroll)
        // transform = CGAffineTransformTranslate(transform, -offset.x, -offset.y);
        
        // Translate considering scroll offset and centering
        transform = CGAffineTransformTranslate(transform, -offset.x + extraX , -offset.y + extraY );
        
        // Apply zoom
        transform = CGAffineTransformScale(transform, zoom, zoom);
    }
    NSLog(@"Current transform: %@", NSStringFromCGAffineTransform(transform));
    [layerInstruction setTransform:transform atTime:kCMTimeZero];
    
    instruction.layerInstructions = @[layerInstruction];
    videoComposition.instructions = @[instruction];
    videoComposition.renderSize = videoFrame.size; // 👈 Crop output to just the frame size
    NSLog(@"Current frame %@",NSStringFromCGRect(videoFrame));
    
    if (@available(iOS 13.0, *)) {
        // Enable hardware acceleration for alpha compositing
        videoComposition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2;
        videoComposition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2;
        videoComposition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2;
    }
    
    // --- Export ---
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                           presetName:AVAssetExportPresetHighestQuality];
    exportSession.videoComposition = videoComposition;
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    NSLog(@"render cropped video %@",outputURL);
    __block NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (progressBlock) {
            progressBlock(exportSession.progress);
        }
    }];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [progressTimer invalidate];
        progressTimer = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                completion(YES, nil);
            } else {
                completion(NO, exportSession.error);
            }
        });
    }];
}


- (CGRect)frameFromTransform:(CGAffineTransform)transform
               originalSize:(CGSize)originalSize
               anchorPoint:(CGPoint)anchorPoint {
    
    // Create a rectangle with the original size
    CGRect originalRect = CGRectMake(0, 0, originalSize.width, originalSize.height);
    
    // Create a transform that accounts for the anchor point
    CGAffineTransform anchorTransform = CGAffineTransformMakeTranslation(-anchorPoint.x * originalSize.width,
                                                                        -anchorPoint.y * originalSize.height);
    anchorTransform = CGAffineTransformConcat(transform, anchorTransform);
    
    // Apply the transform to the rectangle
    CGRect transformedRect = CGRectApplyAffineTransform(originalRect, anchorTransform);
    
    return transformedRect;
}

// 1. Create a pattern-colored image
- (UIImage *)imageWithDynamicColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    // Fill with your dynamic color
    [color setFill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)] fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


// this is working code for shapes videos
- (void)createMaskedVideoCollageWithShapeImagesCompletion:(void (^)(BOOL success, NSError *error))completion
{
    //[self addprogressBarWithMsg:@"Generating Video"];
    [self addCircularProgressViewWithMsg:@"Saving..."];
    //NSString *interVideoPath = [sess pathToIntermediateVideo];
    
    NSMutableArray<NSURL *> *maskedVideoURLs = [NSMutableArray array];
    self.totalMasks = sess.frame.photoCount;
    __block NSInteger completed = 0;
    __block float totalProgress = 0.0f;
    __block float lastReportedProgress = 0.0f;
    const float videoProgressConst = 0.25f;
    float remainingPart = 1.0f - videoProgressConst;
    const float videoStageWeight = videoProgressConst / self.totalMasks;
    // Create a serial queue for progress updates to prevent race conditions
    dispatch_queue_t progressQueue = dispatch_queue_create("com.your.app.progressQueue", DISPATCH_QUEUE_SERIAL);
    @autoreleasepool {
        for (int i = 0; i < self.totalMasks; i++) {
            NSURL *inputURL;
            NSString *effectPath = [sess pathToEffectVideoAtIndex:i];
            if([[NSFileManager defaultManager]fileExistsAtPath:effectPath])
            {
                inputURL = [NSURL fileURLWithPath:effectPath];
            }
            else
            {
                inputURL = [sess getVideoUrlForPhotoAtIndex:i];
            }
            NSLog(@"Input URL is %@",inputURL);
            Photo *poto = [sess.frame getPhotoAtIndex:i];
            UIImage *maskimage = [poto.view getCurrentAssignedShapeImage];
            CGRect frame = CGRectMultiply(poto.actualFrame, upscaleFactor); //poto.actualFrame;
            CGRect shapeframe = CGRectMultiply(poto.frame, upscaleFactor); //poto.frame;
            NSLog(@"index i = %d target frame is %@ mask frame is %@ ",i,NSStringFromCGRect(frame),NSStringFromCGRect(shapeframe));
            NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"masked_%ld.mov", (long)i]];
            if(YES == [[NSFileManager defaultManager]fileExistsAtPath:tempPath])
            {
                NSLog(@"Delete old files");
                [[NSFileManager defaultManager]removeItemAtPath:tempPath error:nil];
            }
            NSURL *outputURL = [NSURL fileURLWithPath:tempPath];
            
            if(FRAME_RESOURCE_TYPE_PHOTO == [sess getFrameResourceTypeAtIndex:i])
            {
                completed++;
                if (completed == self.totalMasks) {
                    NSLog(@"----- create collage from masked videos -----");
                    //  [self finishMaskedCollageExportWithMaskedURLs:maskedVideoURLs completion:completion];
                    [self createVideoCollageFromMaskedVideos:maskedVideoURLs
                                               playbackOrder:orderArrayForVideoItems
                                               progressBlock:^(float finalStageProgress) {
                        //update progress here
                        // Final export stage is 80% → 100%
                        // NSLog(@"final Stage Progress %f",finalStageProgress);
                        [self update_Progress:(videoProgressConst + finalStageProgress * remainingPart)];
                    } completion:^(BOOL success, NSError *error) {
                        [self update_Progress:1.0];
                        completion(success, error);
                    }];
                }
            }
            else
            {
                NSLog(@"render Masked Video With Video URL frame %@ shapeframe %@",NSStringFromCGRect(frame),NSStringFromCGRect(shapeframe));
                [self renderMaskedVideoWithVideoURL:inputURL index:i shapeImage:maskimage videoFrame:shapeframe shapeFrame:shapeframe progressBlock:^(float videoProgress) {
                    // Calculate this video's contribution to total progress
                    float videoContribution = videoProgress * videoStageWeight;
                    dispatch_async(progressQueue, ^{
                        // Only allow progress to move forward (not decrease)
                        float newProgress = MIN(totalProgress + videoContribution, (i + 1) * videoStageWeight);
                        if (newProgress > lastReportedProgress) {
                            lastReportedProgress = newProgress;
                            totalProgress = newProgress;
                            //  NSLog(@"totalProgress %f",totalProgress);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self update_Progress:totalProgress];
                            });
                        }
                    });
                }
                                          outputURL:outputURL completion:^(BOOL success, NSError *error) {
                    if (success) {
                        @synchronized (maskedVideoURLs) {
                            [maskedVideoURLs addObject:outputURL];
                        }
                    }
                    completed++;
                    if (completed == self.totalMasks) {
                        //[self finishMaskedCollageExportWithMaskedURLs:maskedVideoURLs completion:completion];
                        NSLog(@"----- create collage from masked videos -----");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            @autoreleasepool {
                                [self createVideoCollageFromMaskedVideos:maskedVideoURLs
                                                           playbackOrder:orderArrayForVideoItems
                                                           progressBlock:^(float finalStageProgress) {
                                    //update progress here
                                    // Final export stage is 80% → 100%
                                    //  NSLog(@"final Stage Progress %f",finalStageProgress);
                                    [self update_Progress:(videoProgressConst + finalStageProgress * remainingPart)];
                                } completion:^(BOOL success, NSError *error) {
                                    [self update_Progress:1.0];
                                    completion(success, error);
                                }];
                            }
                        });
                    }
                }];
            }
            
        }
    }
}


- (void)createVideoCollageFromMaskedVideos:(NSArray<NSURL *> *)videoURLs
                             playbackOrder:(NSArray<NSNumber *> *)playbackOrder
                             progressBlock:(void (^)(float))progressBlock
                                completion:(void (^)(BOOL success, NSError *error))completion
{
    if ([orderArrayForVideoItems count]==0)
    {
        /* if video order is not set , set them to default oreder*/
        [self setTheDefaultOrderArray];
    }
    // 1. Setup canvas and background
    CGSize canvasSize = CGSizeMake(sess.frame.frame.size.width * upscaleFactor, sess.frame.frame.size.height * upscaleFactor);
    UIImage *image = [self tiledImagetoCanvasSize:sess.frame.frame.size];
    UIImage *resizedImg = [self resizeImageAspectFit:image toSize:canvasSize];
    NSURL *outputURL = [NSURL fileURLWithPath:[sess pathToCurrentVideo]];
    
    // 2. Create composition and layers
    AVMutableComposition *composition = [AVMutableComposition composition];
    NSMutableArray<AVMutableVideoCompositionLayerInstruction *> *layerInstructions = [NSMutableArray array];
    
    CALayer *parentLayer = [CALayer layer];
    parentLayer.geometryFlipped = YES;
    parentLayer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
    parentLayer.contents = (id)resizedImg.CGImage;
    parentLayer.contentsGravity = kCAGravityResizeAspectFill;
    parentLayer.opaque = NO; // Critical for transparency
    parentLayer.backgroundColor = [UIColor clearColor].CGColor;

    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = parentLayer.bounds;
    videoLayer.backgroundColor = UIColor.clearColor.CGColor;
    videoLayer.opaque = NO;
    [parentLayer addSublayer:videoLayer];
    
    CMTime currentTime = kCMTimeZero;
    CMTime maxDurationPerVideo = CMTimeMakeWithSeconds(durationOftheVideo, 600);
    
    BOOL useLibraryAudio = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY] boolValue];
    
    // 3. Calculate total duration for non-sequential play
    CMTime totalDuration = kCMTimeZero;
    if (!isSequentialPlay) {
        for (NSURL *videoURL in videoURLs) {
            AVAsset *asset = [AVAsset assetWithURL:videoURL];
            CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
            totalDuration = CMTimeMaximum(totalDuration, duration);
        }
        currentTime = totalDuration;
    }
    
    // 4. Create mapping between photo indices and video indices
    NSMutableDictionary *photoIndexToVideoIndex = [NSMutableDictionary dictionary];
    int videoIndex = 0;
    
    //    for (int i = 0; i < sess.frame.photoCount; i++) {
    //        if (FRAME_RESOURCE_TYPE_VIDEO == [sess getFrameResourceTypeAtIndex:i]) {
    //            photoIndexToVideoIndex[@(i)] = @(videoIndex);
    //            [videoPhotoIndices addObject:@(i)];
    //            NSLog(@"videoPhotoIndices %@",videoPhotoIndices[i]);
    //            videoIndex++;
    //        }
    //    }
    //
    //
    //    // 5. Determine processing order - use custom order if provided, otherwise natural order
    //    NSArray *processingOrder = playbackOrder ?: videoPhotoIndices;
   
    NSMutableArray *allPhotoIndices = [NSMutableArray array];
    
    for (int i = 0; i < sess.frame.photoCount; i++) {
        if ([sess getFrameResourceTypeAtIndex:i] == FRAME_RESOURCE_TYPE_VIDEO) {
            photoIndexToVideoIndex[@(i)] = @(videoIndex);
            videoIndex++;
        }
        [allPhotoIndices addObject:@(i)]; // Include both photo and video indices
    }
    
    // 5. Determine processing order - use custom order if provided, otherwise natural order
    // NSArray *processingOrder = playbackOrder ?: allPhotoIndices;
    NSArray *processingOrder = isSequentialPlay ? (playbackOrder ?: allPhotoIndices) : allPhotoIndices;
    CMTime sequentialTime = kCMTimeZero;
    NSLog(@"processingOrder %lu",(unsigned long)processingOrder.count);
    for (int k = 0; k < [processingOrder count]; k++) {
        NSLog(@"processingOrder index k %d item is %d ",k,[processingOrder[k] intValue]);
    }
    
    @autoreleasepool {
        // 6. Process all elements in the determined order
        for (NSNumber *photoIndexNum in processingOrder) {
            int i = photoIndexNum.intValue;
            NSLog(@"photoIndexNum is i %d ",i);
            Photo *poto = [sess.frame getPhotoAtIndex:i];
            
            if (FRAME_RESOURCE_TYPE_PHOTO == [sess getFrameResourceTypeAtIndex:i]) {
                // Handle photo elements
                CGRect imgFrame = CGRectMultiply(poto.frame, upscaleFactor);
                CGFloat imgZoom = poto.view.scrollView.zoomScale * upscaleFactor;
                CGPoint imgOffset = CGPointMake(poto.view.scrollView.contentOffset.x * upscaleFactor,
                                                poto.view.scrollView.contentOffset.y * upscaleFactor);
                UIImage *croppedImg = [self cropImage:poto.view.imageView.image
                                       toVisibleFrame:imgFrame.size
                                                 zoom:imgZoom
                                              offsetX:imgOffset.x
                                              offsetY:imgOffset.y];
                
                CALayer *imageLayer = [CALayer layer];
                imageLayer.frame = imgFrame;
                imageLayer.contents = (__bridge id)croppedImg.CGImage;
                imageLayer.contentsGravity = kCAGravityResizeAspectFill;
                
                // Apply shape mask
                UIImage *shapeImage = [poto.view getCurrentAssignedShapeImage];
                NSLog(@"CGImageGetAlphaInfo %u",CGImageGetAlphaInfo(shapeImage.CGImage));
                if (shapeImage) {
                    CALayer *maskLayer = [CALayer layer];
                    maskLayer.frame = imageLayer.bounds;
                    maskLayer.contents = (__bridge id)shapeImage.CGImage;
                    // maskLayer.contentsGravity = kCAGravityResizeAspectFill;
                    imageLayer.mask = maskLayer;
                }
                
                [videoLayer addSublayer:imageLayer];
            } else {
                // Handle video elements
                int videoArrayIndex = [photoIndexToVideoIndex[@(i)] intValue];
                NSURL *videoURL = videoURLs[videoArrayIndex];
                CGPoint videoOffset = CGPointMake(poto.view.scrollView.contentOffset.x * upscaleFactor,
                                                  poto.view.scrollView.contentOffset.y * upscaleFactor);
                CGRect videoFrame = CGRectMultiply(poto.actualFrame, upscaleFactor);
                
                AVAsset *asset = [AVAsset assetWithURL:videoURL];
                AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
                if (!track) continue;
                
                CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
                CMTime startTime = isSequentialPlay ? sequentialTime : kCMTimeZero;
                
                // Add video track to composition
                AVMutableCompositionTrack *compTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                preferredTrackID:kCMPersistentTrackID_Invalid];
                [compTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
                                   ofTrack:track
                                    atTime:startTime
                                     error:nil];
                
                // Handle audio
                
                if (useLibraryAudio) {
//                    NSNumber *persistentId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
//                    MPMediaItem *mItem = [self getMediaItemFromMediaItemId:persistentId];
//                    NSURL *audioUrl = mItem ? [mItem valueForProperty:MPMediaItemPropertyAssetURL] :
//                    [[NSUserDefaults standardUserDefaults] URLForKey:KEY_AUDIOURL_SELECTED_FROM_FILES];
//                    
//                    if (audioUrl) {
//                        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
//                        AVAssetTrack *audioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//                        if (audioTrack) {
//                            AVMutableCompositionTrack *compAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
//                                                                                                 preferredTrackID:kCMPersistentTrackID_Invalid];
//                            [compAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
//                                                    ofTrack:audioTrack
//                                                     atTime:startTime
//                                                      error:nil];
//                        }
//                    }
                } else {
                    BOOL isAudioMuted = [sess getAudioMuteValueForPhotoAtIndex:i];
                    NSLog(@"isAudioMuted %@",isAudioMuted?@"YES":@"NO");
                    if(!isAudioMuted){
                        AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
                        if (audioTrack) {
                            AVMutableCompositionTrack *compAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                                 preferredTrackID:kCMPersistentTrackID_Invalid];
                            [compAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
                                                    ofTrack:audioTrack
                                                     atTime:startTime
                                                      error:nil];
                        }
                    }
                }
                
                // Calculate transform
                CGSize naturalSize = track.naturalSize;
                CGAffineTransform preferredTransform = track.preferredTransform;
                CGSize transformedSize = CGSizeApplyAffineTransform(naturalSize, preferredTransform);
                transformedSize.width = fabs(transformedSize.width);
                transformedSize.height = fabs(transformedSize.height);
                
                CGFloat scale = MIN(videoFrame.size.width / transformedSize.width,
                                    videoFrame.size.height / transformedSize.height);
                CGFloat scaledWidth = transformedSize.width * scale;
                CGFloat scaledHeight = transformedSize.height * scale;
                CGFloat tx = videoFrame.origin.x + (videoFrame.size.width - scaledWidth) / 2.0;
                CGFloat ty = videoFrame.origin.y + (videoFrame.size.height - scaledHeight) / 2.0;
                
                CGAffineTransform finalTransform = CGAffineTransformConcat(
                                                                           preferredTransform,
                                                                           CGAffineTransformMakeScale(scale, scale)
                                                                           );
                finalTransform = CGAffineTransformTranslate(finalTransform, tx / scale, ty / scale);
                
                // Create layer instruction
                AVMutableVideoCompositionLayerInstruction *layerInstruction =
                [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compTrack];
                [layerInstruction setTransform:finalTransform atTime:kCMTimeZero];
                [layerInstructions addObject:layerInstruction];
                
                // For sequential play, add thumbnails of other videos
                if (isSequentialPlay) {
                    for (int j = 0; j < sess.frame.photoCount; j++) {
                        NSLog(@"i %d j %d",i,j);
                        if (j == i) continue; // Skip current video
                        Photo *pt = [sess.frame getPhotoAtIndex:j];
                        
                        CGRect thumbImgFrame = CGRectMultiply(pt.frame, upscaleFactor);
                        CGFloat thumbImgZoom = pt.view.scrollView.zoomScale * upscaleFactor;
                        CGPoint thumbImgOffset = CGPointMake(pt.view.scrollView.contentOffset.x * upscaleFactor,
                                                             pt.view.scrollView.contentOffset.y * upscaleFactor);
                        UIImage *croppedThumbImg = [self cropImage:pt.view.imageView.image
                                                    toVisibleFrame:thumbImgFrame.size
                                                              zoom:thumbImgZoom
                                                           offsetX:thumbImgOffset.x
                                                           offsetY:thumbImgOffset.y];
                        
                        NSLog(@"i %d , j %dsequentialTime %f duration %f",i,j,CMTimeGetSeconds(sequentialTime),CMTimeGetSeconds(duration));
                        CALayer *imageLayer = [CALayer layer];
                        imageLayer.frame = thumbImgFrame;
                        imageLayer.contents = (__bridge id)croppedThumbImg.CGImage;
                        imageLayer.contentsGravity = kCAGravityResizeAspectFill;
                        
                        // Apply shape mask
                        UIImage *shapeImage = [pt.view getCurrentAssignedShapeImage];
                        NSLog(@"CGImageGetAlphaInfo %u",CGImageGetAlphaInfo(shapeImage.CGImage));
                        if (shapeImage) {
                            CALayer *maskLayer = [CALayer layer];
                            maskLayer.frame = imageLayer.bounds;
                            maskLayer.contents = (__bridge id)shapeImage.CGImage;
                            // maskLayer.contentsGravity = kCAGravityResizeAspectFill;
                            imageLayer.mask = maskLayer;
                        }
                        imageLayer.opacity = 1.0;
                        CAKeyframeAnimation *fadeAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
                        fadeAnim.values = @[@1.0, @0.0];
                        fadeAnim.keyTimes = @[@0.99, @1.0];
                        fadeAnim.beginTime = AVCoreAnimationBeginTimeAtZero + CMTimeGetSeconds(sequentialTime);
                        fadeAnim.duration = CMTimeGetSeconds(duration);
                        fadeAnim.removedOnCompletion = YES;
                        fadeAnim.fillMode = kCAFillModeForwards; //kCAFillModeBoth;
                        [imageLayer addAnimation:fadeAnim forKey:@"opacityKeyframe"];
                        imageLayer.opacity = 0; // Ensure base layer is hidden outside animation
                        [videoLayer addSublayer:imageLayer];
                    }
                    sequentialTime = CMTimeAdd(sequentialTime, duration);
                }
            }
        }
    }
    
    // 7. Final duration calculation
    CMTime finalDuration = isSequentialPlay ? sequentialTime : totalDuration;
    
    
    // Add this before the video processing loop (after creating the composition)
    AVMutableCompositionTrack *libraryAudioTrack = nil;
    if (useLibraryAudio) {
        NSNumber *persistentId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
        NSURL *audioUrl;
        if (persistentId != nil) {
            MPMediaItem *mItem = [self getMediaItemFromMediaItemId:persistentId];
            audioUrl = [mItem valueForProperty:MPMediaItemPropertyAssetURL];
        } else {
            audioUrl = [[NSUserDefaults standardUserDefaults] URLForKey:KEY_AUDIOURL_SELECTED_FROM_FILES];
        }
        
        if (audioUrl) {
            AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
            AVAssetTrack *audioAssetTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
            if (audioAssetTrack) {
                libraryAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                           preferredTrackID:kCMPersistentTrackID_Invalid];
                [libraryAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, finalDuration)
                                          ofTrack:audioAssetTrack
                                           atTime:kCMTimeZero
                                            error:nil];
            }
        }
    }
    
    // 4. Apply rounded corner mask to parent layer
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:parentLayer.bounds cornerRadius:sess.getOuterRadius*upscaleFactor];
    maskLayer.path = roundedPath.CGPath;
    maskLayer.frame = parentLayer.bounds;
    parentLayer.mask = maskLayer;
    
    // Step C: Create a transparent base for the mask (so video is hidden by default)
    CALayer *invertedMaskLayer = [CALayer layer];
    invertedMaskLayer.frame = videoLayer.bounds;
    invertedMaskLayer.backgroundColor = UIColor.clearColor.CGColor; // black = video hidden
    
    
    for (int i = 0; i < sess.frame.photoCount; i++) {
        Photo *poto = [sess.frame getPhotoAtIndex:i];
        
        UIImage *shapeImage = [poto.view getCurrentAssignedShapeImage];
        
        // 1. Compute the square side from the smaller dimension
        CGFloat squareSide = MIN(poto.frame.size.width*upscaleFactor, poto.frame.size.height*upscaleFactor);
        
        // 2. Compute the scaling factor to fit the shapeImage into that square
        CGSize imageSize = shapeImage.size;
        CGFloat scale = MIN(squareSide / imageSize.width, squareSide / imageSize.height);
        CGFloat fittedWidth = imageSize.width * scale;
        CGFloat fittedHeight = imageSize.height * scale;
        
        // 3. Compute x/y so the fitted shape is centered inside shapeFrame
        CGFloat x = poto.frame.origin.x * upscaleFactor + (poto.frame.size.width*upscaleFactor - fittedWidth) / 2.0;
        CGFloat y = poto.frame.origin.y*upscaleFactor + (poto.frame.size.height*upscaleFactor - fittedHeight) / 2.0;
        
        CGRect fittedRect = CGRectMake(x, y, fittedWidth, fittedHeight);
        
        // CGRect shapeRect = poto.frame;
        // Shape layer - must be fully white (opaque) where video should be visible
        CALayer *shapeLayer = [CALayer layer];
        shapeLayer.frame = fittedRect;
        shapeLayer.contents = (__bridge id)shapeImage.CGImage;
        shapeLayer.contentsGravity = kCAGravityResizeAspect;
        // Ensure the shape image has proper alpha: white (opaque) in shape, transparent elsewhere
        [invertedMaskLayer addSublayer:shapeLayer];
    }
    
    // Apply as mask — DO NOT add as sublayer
    videoLayer.mask = invertedMaskLayer;
    
    // 9. Add overlays (stickers and text)
    CALayer *overlaysLayer = [CALayer layer];
    overlaysLayer.frame = parentLayer.bounds;
    overlaysLayer.backgroundColor = UIColor.clearColor.CGColor;
    [parentLayer addSublayer:overlaysLayer];
    
    // Stickers
    if (self.addedstickes.count > 0) {
        CALayer *stickersLayer = [CALayer layer];
        stickersLayer.frame = overlaysLayer.bounds;
        stickersLayer.backgroundColor = UIColor.clearColor.CGColor;
        [overlaysLayer addSublayer:stickersLayer];
        
        for (UIView *addedSticker in self.addedstickes) {
            CGFloat nativeScale = [UIScreen mainScreen].scale;
            UIImage *snapshot = [self snapshotViewAccurately:addedSticker scale:nativeScale];
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.contents = (__bridge id)snapshot.CGImage;
            imageLayer.frame = CGRectMultiply(addedSticker.frame, upscaleFactor);
            imageLayer.geometryFlipped = YES;
            [stickersLayer addSublayer:imageLayer];
        }
    }
    
    // Text
    if (self.textBoxes.count > 0) {
        CALayer *textsLayer = [CALayer layer];
        textsLayer.frame = overlaysLayer.bounds;
        textsLayer.backgroundColor = UIColor.clearColor.CGColor;
        [overlaysLayer addSublayer:textsLayer];
        
        for (UIView *addedText in self.textBoxes) {
            CGFloat nativeScale = [UIScreen mainScreen].scale;
            UIImage *snapshot = [self snapshotViewAccurately:addedText scale:nativeScale];
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.contents = (__bridge id)snapshot.CGImage;
            imageLayer.frame = CGRectMultiply(addedText.frame, upscaleFactor);
            imageLayer.geometryFlipped = YES;
            [textsLayer addSublayer:imageLayer];
        }
    }
    
    
    //To add watermark to video
    CALayer *watermarkLayer = [CALayer layer];
    watermarkLayer.frame = overlaysLayer.bounds;
    watermarkLayer.backgroundColor = UIColor.clearColor.CGColor;
    [overlaysLayer addSublayer:watermarkLayer];
    
    UIView *water_MarkView = (UIView*)[self.view viewWithTag:TAG_WATERMARKPARENT_View];
    if(water_MarkView && ![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        CGFloat nativeScale = [UIScreen mainScreen].scale;
        UIImage *snapshot = [self snapshotViewAccurately:water_MarkView scale:nativeScale];
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.contents = (__bridge id)snapshot.CGImage;
        imageLayer.frame = CGRectMultiply(water_MarkView.frame, upscaleFactor);
        imageLayer.geometryFlipped = YES;
        [watermarkLayer addSublayer:imageLayer];
    }
    
    
    // 10. Create video composition
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, finalDuration);
    instruction.layerInstructions = layerInstructions;
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = canvasSize;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    videoComposition.instructions = @[instruction];
    
    if (@available(iOS 13.0, *)) {
        videoComposition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2;
        videoComposition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2;
        videoComposition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2;
    }
    
#if !TARGET_OS_SIMULATOR
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool
                                      videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                      inLayer:parentLayer];
#endif
    
    // 11. Export
    NSString *preset = AVAssetExportPresetHEVCHighestQualityWithAlpha;
    if (@available(iOS 13.0, *)) {
        preset = AVAssetExportPresetHEVC1920x1080WithAlpha;
    }
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:preset];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.videoComposition = videoComposition;
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    __block NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (progressBlock) {
            progressBlock(exportSession.progress);
        }
    }];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [progressTimer invalidate];
        progressTimer = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                completion(YES, nil);
            } else {
                completion(NO, exportSession.error);
            }
        });
    }];
}




// This is working code for shapes videos
//- (void)createVideoCollageFromMaskedVideos:(NSArray<NSURL *> *)videoURLs
//                             playbackOrder:(NSArray<NSNumber *> *)playbackOrder
//                             progressBlock:(void (^)(float))progressBlock
//                                completion:(void (^)(BOOL success, NSError *error))completion
//{
//    CGSize canvasSize  = CGSizeMake(sess.frame.frame.size.width *upscaleFactor, sess.frame.frame.size.height *upscaleFactor);
//
//    UIImage *image = [self tiledImagetoCanvasSize:sess.frame.frame.size];
//
//    UIImage *resizedImg = [self resizeImageAspectFit:image toSize:canvasSize];
//
//    NSURL *outputURL = [NSURL fileURLWithPath:[sess pathToCurrentVideo]];
//    //    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
//
//    AVMutableComposition *composition = [AVMutableComposition composition];
//    NSMutableArray<AVMutableVideoCompositionLayerInstruction *> *layerInstructions = [NSMutableArray array];
//
//    CALayer *parentLayer = [CALayer layer];
//    parentLayer.geometryFlipped = YES;
//    parentLayer.frame = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
//    parentLayer.contents = (id)resizedImg.CGImage;
//    parentLayer.contentsGravity = kCAGravityResizeAspectFill; // or Resize, ResizeAspect depending on your layout
//    //parentLayer.backgroundColor = UIColor.whiteColor.CGColor;
//    parentLayer.opaque = YES;
//
//
//    // Step A: Create the main video layer
//    CALayer *videoLayer = [CALayer layer];
//    videoLayer.frame = parentLayer.bounds;
//    videoLayer.backgroundColor = UIColor.clearColor.CGColor;
//    videoLayer.opaque = NO;
//    [parentLayer addSublayer:videoLayer];
//
//    CMTime currentTime = kCMTimeZero;
//    CMTime maxDurationPerVideo = CMTimeMakeWithSeconds(durationOftheVideo, 600);
//
//    // Calculate total duration in advance for white background
//    CMTime totalDuration = kCMTimeZero;
//
//    int countOfMaskedVideo = 0;
//
//    // Step 2: Add white background (only if NOT sequential)
//    if (!isSequentialPlay) {
//        for (int i = 0; i < videoURLs.count; i++) {
//            AVAsset *asset = [AVAsset assetWithURL:videoURLs[i]];
//            CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
//            totalDuration = CMTimeMaximum(totalDuration, duration);
//        }
//        currentTime = totalDuration;
//    }
//
//    // Step 3: Add video layers
//    CMTime sequentialTime = kCMTimeZero;
//
//    for (int i = 0; i < sess.frame.photoCount; i++) {
//        Photo *poto = [sess.frame getPhotoAtIndex:i];
//        if(FRAME_RESOURCE_TYPE_PHOTO == [sess getFrameResourceTypeAtIndex:i])
//        {
//            CGRect imgFrame = CGRectMultiply(poto.frame, upscaleFactor);
//            CGFloat imgZoom = poto.view.scrollView.zoomScale * upscaleFactor;
//            CGPoint imgOffset = CGPointMake(poto.view.scrollView.contentOffset.x * upscaleFactor, poto.view.scrollView.contentOffset.y * upscaleFactor);
//            UIImage *croppedImg = [self cropImage:poto.view.imageView.image toVisibleFrame:imgFrame.size zoom:imgZoom offsetX:imgOffset.x offsetY:imgOffset.y];
//
//            CALayer *imageLayer = [CALayer layer];
//            imageLayer.frame = imgFrame;
//            imageLayer.contents = (__bridge id)croppedImg.CGImage;
//            imageLayer.contentsGravity = kCAGravityResizeAspectFill;
//            // Apply shape mask
//            UIImage *shapeImage = [poto.view getCurrentAssignedShapeImage];
//            NSLog(@"CGImageGetAlphaInfo %u",CGImageGetAlphaInfo(shapeImage.CGImage));
//            if (shapeImage) {
//                CALayer *maskLayer = [CALayer layer];
//                maskLayer.frame = imageLayer.bounds;
//                maskLayer.contents = (__bridge id)shapeImage.CGImage;
//                // maskLayer.contentsGravity = kCAGravityResizeAspectFill;
//                imageLayer.mask = maskLayer;
//            }
//            [videoLayer addSublayer:imageLayer];
//        }
//        else {
//            NSURL *videoURL = videoURLs[countOfMaskedVideo];
//            CGRect videoFrame = CGRectMultiply(poto.actualFrame,upscaleFactor);
//            NSLog(@"shape frame %@ video actual %@",NSStringFromCGRect(poto.frame),NSStringFromCGRect(poto.actualFrame));
//            AVAsset *asset = [AVAsset assetWithURL:videoURL];
//            AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//            if (!track) continue;
//
//            CMTime duration = CMTimeMinimum(asset.duration, maxDurationPerVideo);
//            CMTime startTime = isSequentialPlay ? sequentialTime : kCMTimeZero;
//
//            // Insert into composition
//            AVMutableCompositionTrack *compTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//
//            [compTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:track
//               atTime:startTime error:nil];
//
//            // Insert audio track if available
//            AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
//            if (audioTrack) {
//                AVMutableCompositionTrack *compAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//                [compAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration)
//                                        ofTrack:audioTrack
//                                         atTime:startTime
//                                          error:nil];
//            }
//
//            // Transform
//            CGSize naturalSize = track.naturalSize;
//            CGAffineTransform preferredTransform = track.preferredTransform;
//            CGSize transformedSize = CGSizeApplyAffineTransform(naturalSize, preferredTransform);
//            transformedSize.width = fabs(transformedSize.width);
//            transformedSize.height = fabs(transformedSize.height);
//
//            CGFloat scale = MAX(videoFrame.size.width / transformedSize.width,
//                                videoFrame.size.height / transformedSize.height);
//
//            CGFloat scaledWidth = transformedSize.width * scale;
//            CGFloat scaledHeight = transformedSize.height * scale;
//
//            CGFloat tx = videoFrame.origin.x + (videoFrame.size.width - scaledWidth) / 2.0;
//            CGFloat ty = videoFrame.origin.y + (videoFrame.size.height - scaledHeight) / 2.0;
//
//            CGAffineTransform finalTransform = CGAffineTransformConcat(preferredTransform, CGAffineTransformMakeScale(scale, scale));
//            finalTransform = CGAffineTransformTranslate(finalTransform, tx / scale, ty / scale);
//
//            AVMutableVideoCompositionLayerInstruction *layerInstruction =
//            [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compTrack];
//
//            [layerInstruction setTransform:finalTransform atTime:kCMTimeZero];
//            [layerInstructions addObject:layerInstruction];
//            if(isSequentialPlay)
//            {
//                for (int j = 0; j < videoURLs.count; j++) {
//                    NSLog(@"before masked video as thumbnail image is j %d countOfMaskedVideo %d ",j,countOfMaskedVideo);
//                    if (j == countOfMaskedVideo) continue;
//                    NSLog(@"after masked video as thumbnail image is j %d countOfMaskedVideo %d",j,countOfMaskedVideo);
//                    Photo *pt = [sess.frame getPhotoAtIndex:j];
//                    CGRect thumbImgFrame = CGRectMultiply(pt.frame, upscaleFactor);
//                    CGFloat thumbImgZoom = pt.view.scrollView.zoomScale * upscaleFactor;
//                    CGPoint thumbImgOffset = CGPointMake(pt.view.scrollView.contentOffset.x * upscaleFactor, pt.view.scrollView.contentOffset.y * upscaleFactor);
//                    UIImage *croppedThumbImg = [self cropImage:pt.view.imageView.image toVisibleFrame:thumbImgFrame.size zoom:thumbImgZoom offsetX:thumbImgOffset.x offsetY:thumbImgOffset.y];
//
//                    CALayer *imageLayer = [CALayer layer];
//                    imageLayer.frame = thumbImgFrame;
//                    imageLayer.contents = (__bridge id)croppedThumbImg.CGImage;
//                    imageLayer.contentsGravity = kCAGravityResizeAspectFill;
//                    //imageLayer.beginTime = CMTimeGetSeconds(sequentialTime);
//                    //imageLayer.duration = CMTimeGetSeconds(duration);
//                    // Apply shape mask
//                    UIImage *shapeImage = [pt.view getCurrentAssignedShapeImage];
//
//                    if (shapeImage) {
//                        CALayer *maskLayer = [CALayer layer];
//                        maskLayer.frame = imageLayer.bounds;
//                        maskLayer.contents = (__bridge id)shapeImage.CGImage;
//                        // maskLayer.contentsGravity = kCAGravityResizeAspectFill;
//                        imageLayer.mask = maskLayer;
//                    }
//
//                    CAKeyframeAnimation *fadeAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//                    fadeAnim.values = @[@1.0, @0.0];
//                    fadeAnim.keyTimes = @[@0.0, @1.0];
//                    fadeAnim.beginTime = AVCoreAnimationBeginTimeAtZero + CMTimeGetSeconds(sequentialTime);
//                    fadeAnim.duration = CMTimeGetSeconds(duration);
//                    fadeAnim.removedOnCompletion = YES;
//                    fadeAnim.fillMode = kCAFillModeForwards; //kCAFillModeBoth;
//                    [imageLayer addAnimation:fadeAnim forKey:@"opacityKeyframe"];
//                    imageLayer.opacity = 0; // Ensure base layer is hidden outside animation
//                    [videoLayer addSublayer:imageLayer];
//                }
//                sequentialTime = CMTimeAdd(sequentialTime, duration);
//            }
//            countOfMaskedVideo++;
//        }
//    }
//
//    // 4. Apply rounded corner mask to parent layer
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:parentLayer.bounds cornerRadius:sess.getOuterRadius*upscaleFactor];
//    maskLayer.path = roundedPath.CGPath;
//    maskLayer.frame = parentLayer.bounds;
//    parentLayer.mask = maskLayer;
//
//    // Step C: Create a transparent base for the mask (so video is hidden by default)
//    CALayer *invertedMaskLayer = [CALayer layer];
//    invertedMaskLayer.frame = videoLayer.bounds;
//    invertedMaskLayer.backgroundColor = UIColor.clearColor.CGColor; // black = video hidden
//
//
//    for (int i = 0; i < sess.frame.photoCount; i++) {
//        Photo *poto = [sess.frame getPhotoAtIndex:i];
//
//        UIImage *shapeImage = [poto.view getCurrentAssignedShapeImage];
//
//        // 1. Compute the square side from the smaller dimension
//        CGFloat squareSide = MIN(poto.frame.size.width*upscaleFactor, poto.frame.size.height*upscaleFactor);
//
//        // 2. Compute the scaling factor to fit the shapeImage into that square
//        CGSize imageSize = shapeImage.size;
//        CGFloat scale = MIN(squareSide / imageSize.width, squareSide / imageSize.height);
//        CGFloat fittedWidth = imageSize.width * scale;
//        CGFloat fittedHeight = imageSize.height * scale;
//
//        // 3. Compute x/y so the fitted shape is centered inside shapeFrame
//        CGFloat x = poto.frame.origin.x * upscaleFactor + (poto.frame.size.width*upscaleFactor - fittedWidth) / 2.0;
//        CGFloat y = poto.frame.origin.y*upscaleFactor + (poto.frame.size.height*upscaleFactor - fittedHeight) / 2.0;
//
//        CGRect fittedRect = CGRectMake(x, y, fittedWidth, fittedHeight);
//
//        // CGRect shapeRect = poto.frame;
//        // Shape layer - must be fully white (opaque) where video should be visible
//        CALayer *shapeLayer = [CALayer layer];
//        shapeLayer.frame = fittedRect;
//        shapeLayer.contents = (__bridge id)shapeImage.CGImage;
//        shapeLayer.contentsGravity = kCAGravityResizeAspect;
//        // Ensure the shape image has proper alpha: white (opaque) in shape, transparent elsewhere
//        [invertedMaskLayer addSublayer:shapeLayer];
//    }
//
//    // Apply as mask — DO NOT add as sublayer
//    videoLayer.mask = invertedMaskLayer;
//
//    CMTime finalDuration = isSequentialPlay ? sequentialTime : totalDuration;
//
//    // To add all text overlays
//    CALayer *overlaysLayer = [CALayer layer];
//    overlaysLayer.frame = parentLayer.bounds;
//    overlaysLayer.backgroundColor = UIColor.clearColor.CGColor;
//    [parentLayer addSublayer:overlaysLayer];
//
//
//    // To add all text overlays
//    CALayer *stickersLayer = [CALayer layer];
//    stickersLayer.frame = overlaysLayer.bounds;
//    stickersLayer.backgroundColor = UIColor.clearColor.CGColor;
//    [overlaysLayer addSublayer:stickersLayer];
//
//    if(self.addedstickes.count > 0)
//    {
//        for (UIView *addedSticker in self.addedstickes) {
//            // For Retina-quality (2x or 3x)
//            CGFloat nativeScale = [UIScreen mainScreen].scale;
//            UIImage *snapshot = [self snapshotViewAccurately:addedSticker scale:nativeScale];
//
//            NSLog(@"Snapshot size: %.0f x %.0f", snapshot.size.width * snapshot.scale, snapshot.size.height * snapshot.scale);
//
//            CALayer *imageLayer = [CALayer layer];
//            imageLayer.contents = (__bridge id)snapshot.CGImage;
//            imageLayer.frame = CGRectMultiply(addedSticker.frame, upscaleFactor);
//            imageLayer.geometryFlipped = YES; // Optional for AVFoundation export
//            [stickersLayer addSublayer:imageLayer];
//        }
//    }
//
//
//    // To add all text overlays
//    CALayer *textsLayer = [CALayer layer];
//    textsLayer.frame = overlaysLayer.bounds;
//    textsLayer.backgroundColor = UIColor.clearColor.CGColor;
//    [overlaysLayer addSublayer:textsLayer];
//
//    if(self.textBoxes.count > 0)
//    {
//        for (UIView *addedText in self.textBoxes) {
//
//            // For Retina-quality (2x or 3x)
//            CGFloat nativeScale = [UIScreen mainScreen].scale;
//            UIImage *snapshot = [self snapshotViewAccurately:addedText scale:nativeScale];
//
//            NSLog(@"Snapshot size: %.0f x %.0f", snapshot.size.width * snapshot.scale, snapshot.size.height * snapshot.scale);
//
//            CALayer *imageLayer = [CALayer layer];
//            imageLayer.contents = (__bridge id)snapshot.CGImage;
//            imageLayer.frame = CGRectMultiply(addedText.frame, upscaleFactor); //addedText.frame;
//            imageLayer.geometryFlipped = YES; // Optional for AVFoundation export
//            [textsLayer addSublayer:imageLayer];
//
//        }
//    }
//
//
//    // Compose final video
//    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, finalDuration);
//    instruction.layerInstructions = layerInstructions;
//
//    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
//    videoComposition.renderSize = canvasSize;
//    videoComposition.frameDuration = CMTimeMake(1, 30);
//    videoComposition.instructions = @[instruction];
//
//    if (@available(iOS 13.0, *)) {
//        // Enable hardware acceleration for alpha compositing
//        videoComposition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2;
//        videoComposition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2;
//        videoComposition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2;
//    }
//
//#if TARGET_OS_SIMULATOR
//    NSLog(@"Skipping animationTool in simulator to avoid XPC crash.");
//#else
//    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool
//                                      videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
//#endif
//
//    // Use HEVC with alpha when available (iOS 11+)
//    NSString *preset = AVAssetExportPresetHEVCHighestQualityWithAlpha;
//    if (@available(iOS 13.0, *)) {
//        preset = AVAssetExportPresetHEVC1920x1080WithAlpha; // Faster than HighestQuality
//    }
//    // Export
//    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:preset];
//    exportSession.outputURL = outputURL;
//    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
//    exportSession.videoComposition = videoComposition;
//    exportSession.shouldOptimizeForNetworkUse = YES;
//
//    __block NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (progressBlock) {
//            progressBlock(exportSession.progress);
//        }
//    }];
//
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//        [progressTimer invalidate];
//        progressTimer = nil;
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
//                completion(YES, nil);
//            } else {
//                completion(NO, exportSession.error);
//            }
//        });
//    }];
//}


- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


// Helper: Generate blank white image
- (UIImage *)blankWhiteImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [[UIColor whiteColor] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// Helper: Generate blank white image
- (UIImage *)blankColorImageWithSize:(CGSize)size color:(UIColor*)color{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

CGRect CGRectMultiply(CGRect rect, CGFloat scale) {
    return CGRectMake(rect.origin.x * scale,
                      rect.origin.y * scale,
                      rect.size.width * scale,
                      rect.size.height * scale);
}


- (UIImage *)resizeImageAspectFit:(UIImage *)image toSize:(CGSize)canvasSize {
    if (!image) return nil;
    
    CGSize imageSize = image.size;
    CGFloat scale = MIN(canvasSize.width / imageSize.width, canvasSize.height / imageSize.height);
    CGSize scaledSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale);
    CGPoint origin = CGPointMake((canvasSize.width - scaledSize.width) / 2,
                                 (canvasSize.height - scaledSize.height) / 2);
    
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0.0); // scale 0 = screen scale
    [image drawInRect:CGRectMake(origin.x, origin.y, scaledSize.width, scaledSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage *)tiledImagetoCanvasSize:(CGSize)canvasSize {
    
    // Start a graphics context with the desired canvas size
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0.0);
    
    // Fill the entire canvas with the pattern
    [sessionFrameColor setFill];
    UIRectFill(CGRectMake(0, 0, canvasSize.width, canvasSize.height));
    
    // Get the resulting image
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

#pragma mark - Helper Methods

- (void)cleanUpExistingFilesAtPaths:(NSArray<NSString *> *)paths {
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
}

- (UIImage *)preRenderedBackgroundForSession:(Session *)session canvasSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);
    UIImage *image = [self tiledImagetoCanvasSize:session.frame.frame.size];
    UIImage *resizedImg = [self resizeImageAspectFit:image toSize:size];
    [resizedImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (CALayer *)createImageLayerForPhoto:(Photo *)photo
                              session:(Session *)session
                        upscaleFactor:(CGFloat)factor {
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMultiply(photo.frame, factor);
    imageLayer.contents = (__bridge id)photo.view.imageView.image.CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspectFill;
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = session.getInnerRadius * factor;
    return imageLayer;
}

- (void)processVideoAssetAtURL:(NSURL *)videoURL
                     outputURL:(NSURL *)outputURL
                      forPhoto:(Photo *)photo
                 upscaleFactor:(CGFloat)factor
                    completion:(void (^)(BOOL success, NSURL *resultURL))completion {
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
    [asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        if (!track) {
            completion(NO, nil);
            return;
        }
        
        CGRect targetFrame = CGRectMultiply(photo.frame, factor);
        CGFloat zoom = photo.view.scrollView.zoomScale;
        CGPoint offset = photo.view.scrollView.contentOffset;
        
        // Calculate transform
        CGSize videoSize = track.naturalSize;
        CGPoint center = CGPointMake(videoSize.width / 2.0, videoSize.height / 2.0);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, -center.x + offset.x, -center.y + offset.y);
        transform = CGAffineTransformScale(transform, zoom, zoom);
        transform = CGAffineTransformTranslate(transform, targetFrame.size.width / 2.0, targetFrame.size.height / 2.0);
        
        // Video composition for cropping
        AVMutableVideoComposition *cropComposition = [AVMutableVideoComposition videoComposition];
        cropComposition.renderSize = targetFrame.size;
        cropComposition.frameDuration = CMTimeMake(1, 30);
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction =
        [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:track];
        [layerInstruction setTransform:transform atTime:kCMTimeZero];
        
        instruction.layerInstructions = @[layerInstruction];
        cropComposition.instructions = @[instruction];
        
        // Export cropped video
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                               presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.videoComposition = cropComposition;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            completion(exportSession.status == AVAssetExportSessionStatusCompleted, outputURL);
        }];
    }];
}






- (UIImage *)snapshotViewAccurately:(UIView *)view scale:(CGFloat)scale {
    if (!view || CGRectIsEmpty(view.bounds)) return nil;
    
    // Layout the view
    [view layoutIfNeeded];
    
    // Backup view state
    UIView *originalSuperview = view.superview;
    CGPoint originalOrigin = view.frame.origin;
    
    // Move to a temporary container (if offscreen)
    UIView *tempContainer = [[UIView alloc] initWithFrame:view.bounds];
    [tempContainer addSubview:view];
    view.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    
    // Start high-resolution context
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
    BOOL success = [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Restore view
    [view removeFromSuperview];
    if (originalSuperview) {
        [originalSuperview addSubview:view];
        view.frame = (CGRect){originalOrigin, view.frame.size};
    }
    
    if (!success || !snapshot) {
        NSLog(@"⚠️ Snapshot failed for view: %@", view);
    }
    
    return snapshot;
}



-(void)ShareAction
{
    NSLog(@"Share action ");
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        durationOftheVideo = 30;
    }
    else
    {
        durationOftheVideo = 120;
    }
    
    [self doneBtnTapped];
    // remove all added subviews
    if(backgroundSubviewisAdded)
    {
        [self removeBgViewController];
    }
    if(sliderSubviewisAdded)
    {
        [self removeSliderViewController];
    }
    if(effectSubviewAdded)
    {
        [self removeEffectsViewController];
    }
    
    if(( sess.frameNumber <3 || sess.frameNumber ==1003 ||  sess.frameNumber ==1007 ||  sess.frameNumber == 1013 || sess.frameNumber ==1018 ||  sess.frameNumber ==21 ||  sess.frameNumber ==1033   ||  sess.frameNumber == 37 ||  sess.frameNumber ==43)||[[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
     //   [self ChangeParent:mainBackground :sess.frame];
        NSLog(@"sess photo count %d",sess.frame.photoCount);
        int maximumNumberOfImage = 0;
        int photoIndex = 0;
        
        for (photoIndex= 0; photoIndex< sess.frame.photoCount; photoIndex++)
        {
            Photo *pht = [sess.frame getPhotoAtIndex:photoIndex ];
            if(pht.isContentTypeVideo)
            {
                [pht.view pausePlayer];
            }
            if (pht.image == nil) {
                maximumNumberOfImage ++;
            }
            
        }
        NSLog(@"photo index... %d",maximumNumberOfImage);
        
        
        
        if(maximumNumberOfImage<1)
        {
            [self allocateResourcesForUpload];
            NSLog(@"frame filled completely......");
            
        }
        else
        {
            //                 NSLog(@"Please fill the images before uploading....");
            [WCAlertView showAlertWithTitle:@"Oops.." message:@"Please fill the frame before sharing...." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
        }
    }
    else //(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [self ShowSubscriptionView];
    }
}





#pragma mark smooth transition
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if(self == viewController)
//    {
//        [self selectEditTab];
//    }
//}

#pragma mark upload implementation
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    /* Dismiss the modelview controller */
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    switch(result)
    {
        case MFMailComposeResultSent:
        {
            [WCAlertView showAlertWithTitle:NSLocalizedString(@"EMAIL",@"Email")
                                    message:NSLocalizedString(@"EMAILSUCCESS",@"Successfully Sent the email!!!")
                         customizationBlock:nil
                            completionBlock:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK",@"OK"), nil];
            
            [Appirater userDidSignificantEvent:YES];
            
            break;
        }
        case MFMailComposeResultFailed:
        {
            [WCAlertView showAlertWithTitle:NSLocalizedString(@"EMAIL",@"Email")
                                    message:[error localizedDescription]
                         customizationBlock:nil
                            completionBlock:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK",@"OK"), nil];
            break;
        }
        default:
        {
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:uploaddone object:nil];
    return;
}

-(void)uploadToEmail
{
    // NSAutoreleasePool *localPool     = [[NSAutoreleasePool alloc] init];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        /* We must always check whether the current device is configured for sending emails */
        if ([mailClass canSendMail])
        {
            NSString *appUrl = ituneslinktoApp;
            NSString *yoziohyperlink = [NSString stringWithFormat:
                                        @"<a href=\"%@\" target=\"itunes_store\">%@</a>",appUrl,appname];
            NSString *websiteLink    = [NSString stringWithFormat:
                                        @"<a href=\"%@\" target=\"www.videocollageapp.com \">%@</a>",appUrl,@"www.videocollageapp.com "];
            NSString *emailBody = [NSString stringWithFormat:@"Made with iphone application - %@. Download it from %@ \n",yoziohyperlink,websiteLink];
            
            NSString *emailSubject = [NSString stringWithFormat:@"From %@ iphone application",appname];
            
            /* Compose the email */
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate          = self;
            [picker setSubject:emailSubject];
            
            /* Set the model transition style */
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            /* Attach an image to the email */
            //[picker addAttachmentData:UIImagePNGRepresentation([sess.frame renderToImageOfSize:nvm.uploadSize])
            //                 mimeType:@"image/png" fileName:@"PicShells"];
            [picker addAttachmentData:UIImageJPEGRepresentation([sess.frame renderToImageOfSize:nvm.uploadSize],1.0)
                             mimeType:@"image/jpeg" fileName:@"PicShells"];
            
            /* Fill out the email body text */
            [picker setMessageBody:emailBody isHTML:YES];
            
            /* Present the email compose view to the user */
            // [self presentModalViewController:picker animated:YES];
            [self presentViewController:picker animated:YES completion:nil];
            
            /* Free the resources */
            //  [picker release];
        }
        else
        {
            [WCAlertView showAlertWithTitle:NSLocalizedString(@"EMAIL",@"Email")
                                    message:NSLocalizedString(@"NOEMAIL",@"Email is not configured for this device!!!")
                         customizationBlock:nil
                            completionBlock:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
        }
        
        /* Free the mailclass object */
        //   [mailClass release];
    }
    
    //  [localPool release];
    
    return;
}

-(void) saveImageToInstagram:(UIImage *)pImage
{
    if(nil == pImage)
    {
        NSLog(@"Image is nil");
    }
    /* First Save the Image to documents directory
     1. Generate the path to save the file*/
    NSString *pathToSave = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/captions1.ig"];
    
    /* 2. Save the file */
    [UIImageJPEGRepresentation(pImage, 1.0) writeToFile:pathToSave atomically:YES];
    
    /* Verify if the instagram app is installed */
    NSURL *instagramUrls = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication]canOpenURL:instagramUrls])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:uploaddone object:nil];
        documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:pathToSave]];//retain];
        NSString *caption = [NSString stringWithFormat:@"#VideoCollage, Created using @VideoCollage free iphone app"];
        documentInteractionController.UTI = @"com.instagram.photo";
        documentInteractionController.delegate = self;
        documentInteractionController.annotation = [NSDictionary dictionaryWithObject:caption forKey:@"InstagramCaption"];
        [documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:uploaddone object:nil];
        
        [WCAlertView showAlertWithTitle:@"Failed"
                                message:@"Instagram is not installed in your device. You need to install Instagram application to share your image with Instagram. Would you like to download it now?"
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
         {
            if(buttonIndex == 1)
            {
                //                 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/instagram/id389801252?mt=8"]];
                [self Open_URL:@"http://itunes.apple.com/us/app/instagram/id389801252?mt=8"];
            }
        }
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Download", nil];
        
    }
}

- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application
{
    // [documentInteractionController release];
    documentInteractionController = nil;
}


-(void)uploadVideo
{
    //@autoreleasepool {
    nvm = [Settings Instance];
    nvm.noAdMode = YES;
    //bShowRevModAd = NO;/* Rajesh Kumar*/
    //VideoUploadHandler *vHandler = [VideoUploadHandler alloc];
    vHandler = [[VideoUploadHandler alloc] init];
    vHandler.viewController = self;
    vHandler . _view = self.view;
    vHandler.applicationNames = appname;
    vHandler.downloadUrl = @"http://www.videocollageapp.com";
    vHandler.website = @"http://www.videocollageapp.com";
    [vHandler uploadVideoAtPath:[sess pathToCurrentVideo] to:nvm.uploadCommand];
}

- (void)uploadImage
{
    uploadH = [UploadHandler alloc];
    uploadH.view = self.view;
    uploadH.viewController = self;
    uploadH.cursess = sess;
   // uploadH.savingCountLimit = savingCountLimitIs;
    [uploadH upload];
    //[uploadH release];
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(YES == [[alertView title] isEqualToString:NSLocalizedString(@"EMAIL",@"Email")])
//    {
//        //[self retrieveAndDislayTodaysAdd];
//    }
//    else if(YES == [[alertView title] isEqualToString:NSLocalizedString(@"VIDEOTUT",@"Video Tutorial")])
//    {
//        if(buttonIndex == 1)
//        {
//            //[self showVideoTutorial];
//        }
//    }
//    else if(YES == [[alertView title] isEqualToString:NSLocalizedString(@"IVOKEHEAD",@"Personalized Items")])
//    {
//        if(buttonIndex == 1)
//        {
//            [LoadingClass addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Rendering",@"Rendering")];
//            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(orderPersanalItem) userInfo:nil repeats:NO];
//        }
//    }
//    else if(YES == [[alertView title] isEqualToString:@"Failed"])
//    {
//        if(buttonIndex == 1)
//        {
//           // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/instagram/id389801252?mt=8"]];
//            [self Open_URL:@"http://itunes.apple.com/us/app/instagram/id389801252?mt=8"];
//        }
//    }
//
//    return;
//}

#pragma Subscription CallBacks
-(void)kSRProductPurchasedNotification
{
    NSLog(@"1---------");
}

-(void)kSRProductUpdatedNotification
{
    NSLog(@"2---------");
    
}

-(void)kSRProductRestoredNotification
{
    NSLog(@"3---------");
}

-(void)kSRProductFailedNotification
{
    NSLog(@"4---------");
}

-(void)kSRProductLoadedNotification
{
    NSLog(@"5---------");
}

-(void)kSRSubscriptionResultNotification
{
    NSLog(@"6---------");
}


-(void)releaseResourcesForModeShare
{
    NSLog(@"release Resources For Mode Share");
    switch (eMode)
    {
        case MODE_FRAMES:
        {
            
            [self releaseResourcesForFrames];
            
            break;
        }
        case MODE_VIDEO_SETTINGS:
        {
            [self releaseResourcesForVideoSetttings];
            break;
        }
        case MODE_SHARE:
        {
            [self releaseResourcesForUpload];
            break;
        }
            //need to delete
        case MODE_PREVIEW:
        {
            //            [self releaseResourcesForPreview];
            break;
        }
            //end
        default:
        {
            break;
        }
            
    }
}


-(void)allocateShareResources
{
    frameIsEdited = NO;
    // Releasing Frames Related Things //
    [self assignRightBarButtonItem];
    [self releaseResourcesForModeShare];
    eMode = 0;
    [self releaseResourcesForFrames];
    //TouchViewUnHide//
    [self settingTouchViewUnHide];
    [self settingTouchViewUnHided];
    shareView = [[ShareViewController alloc] init];
    shareView.frameSize = frame_size;
    shareView.videoPath = [sess pathToCurrentVideo];
    NSLog(@" share video path is %@",[sess pathToCurrentVideo]);
    shareView.sess = sess;
    // shareView.SharingURL =
    shareView.isVideo = isVideoFile;
    //[self.view addSubview:shareView.view];
    /*
     if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
     {
     if(self.interestial_ShareCount>0)
     {
     [self showInterstitial2];
     }
     NSLog(@"Product Not purchased-------");
     }
     else
     {
     NSLog(@"Product purchased-------");
     
     }
     */
    generatingVideo = NO;
    [self.navigationController pushViewController:shareView animated:YES];
    
}


-(void)showResolutionOptios
{
    CGRect full               = [[UIScreen mainScreen]bounds];
    //  CGRect shareRect          = CGRectMake(full.size.width-55.0, customTabBar.frame.origin.y, full_screen.size.width, 50);
    CGRect shareRect          = CGRectMake(full.size.width-55.0, 0, full_screen.size.width, 50);
    // NSMutableArray *menuItems = [[NSMutableArray alloc]initWithCapacity:1];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        shareRect.origin.x = shareRect.origin.x - 60.0;
        
    }
    
    
    KxMenuItem *title    = [KxMenuItem menuItem:@"Resolution"
                                          image:nil
                                         target:nil
                                         action:nil];
    KxMenuItem *res_2400 = [KxMenuItem menuItem:@"2400 x 2400"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_2400.tag         = RESOLUTION_PIXCOUNT_HIGH0;
    KxMenuItem *res_2100 = [KxMenuItem menuItem:@"2100 x 2100"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_2100.tag         = RESOLUTION_PIXCOUNT_HIGH1;
    KxMenuItem *res_1800 = [KxMenuItem menuItem:@"1800 x 1800"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_1800.tag         = RESOLUTION_PIXCOUNT_MED0;
    KxMenuItem *res_1200 = [KxMenuItem menuItem:@"1200 x 1200"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_1200.tag         = RESOLUTION_PIXCOUNT_MED2;
    KxMenuItem *res_600  = [KxMenuItem menuItem:@"600 x 600"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_600.tag          = RESOLUTION_PIXCOUNT_LOW1;
    
    NSArray *menuItems   = @[title,res_2400,res_2100,res_1800,res_1200,res_600];
    
    for(int index = 0; index < [menuItems count]; index++)
    {
        KxMenuItem *menuitem = menuItems[index];
        
        menuitem.alignment = NSTextAlignmentCenter;
        
    }
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    KxMenuItem *first = menuItems[0];
    // first.foreColor = PHOTO_DEFAULT_COLOR;
    first.foreColor = [UIColor lightGrayColor];
    first.alignment = NSTextAlignmentCenter;
    [KxMenu showMenuInView:window
                  fromRect:shareRect
                 menuItems:menuItems
                  delegate:self];
    
}


-(void)showVideoResolutionOptios
{
    CGRect full               = [[UIScreen mainScreen]bounds];
    CGRect shareRect          = CGRectMake(full.size.width-55.0, 0, full_screen.size.width, 50);
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        shareRect.origin.x = shareRect.origin.x - 60.0;
    }
    
    KxMenuItem *title    = [KxMenuItem menuItem:@"Resolution"
                                          image:nil
                                         target:nil
                                         action:nil];
    KxMenuItem *res_standard = [KxMenuItem menuItem:@"Standard"
                                              image:nil
                                             target:self
                                             action:@selector(handleVideoResolutionOptionSelection:)];
    res_standard.tag         = RESOLUTION_PIXCOUNT_HIGH0;
    
    KxMenuItem *res_hd = [KxMenuItem menuItem:@"HD"
                                        image:nil
                                       target:self
                                       action:@selector(handleVideoResolutionOptionSelection:)];
    res_hd.tag         = RESOLUTION_PIXCOUNT_HIGH1;
    
    
    NSArray *menuItems   = @[title,res_standard,res_hd];
    
    for(int index = 0; index < [menuItems count]; index++)
    {
        KxMenuItem *menuitem = menuItems[index];
        menuitem.alignment = NSTextAlignmentCenter;
    }
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    KxMenuItem *first = menuItems[0];
    // first.foreColor = PHOTO_DEFAULT_COLOR;
    first.foreColor = [UIColor lightGrayColor];
    first.alignment = NSTextAlignmentCenter;
    [KxMenu showMenuInView:window
                  fromRect:shareRect
                 menuItems:menuItems
                  delegate:self];
    
}



-(void)handleVideoResolutionOptionSelection:(KxMenuItem*)item
{
    
    CGFloat screenResolution = 720;
    if(item.tag == RESOLUTION_PIXCOUNT_HIGH0)
    {
        screenResolution = 720;
    }
    else
    {
        screenResolution = 1280;
    }
    upscaleFactor = screenResolution / sess.frame.frame.size.width;
    NSLog(@"upscale factor %f",upscaleFactor);
    [self callVideoGaneration];
}

//- (void)viewMovieAtUrl:(NSURL *)fileURL
//{
//    MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL ];
//  //  playerController.moviePlayer.contentURL = [NSURL fileURLWithPath:fileURL.absoluteString];
//    [playerController.view setFrame:self.view.bounds];
//    [self presentMoviePlayerViewControllerAnimated:playerController];
//    [playerController.moviePlayer prepareToPlay];
//    [playerController.moviePlayer play];
//    [self.view addSubview:playerController.view];
//
////    AVPlayer *player = [AVPlayer playerWithURL:fileURL];
////    // Create an AVPlayerViewController and set the player
////    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
////    playerViewController.player = player;
////    // Present the AVPlayerViewController
////    [self presentViewController:playerViewController animated:YES completion:^{
////        // Start playing the video
////        [player play];
////    }];
//
//}




-(void)showLoadingForFrames
{
    separatedview = [[UIView alloc]init];
    separatedview.frame = CGRectMake(500,700 , 320, 320);
//    separatedview.backgroundColor = [UIColor greenColor];
    [self.view addSubview:separatedview];
    
    [LoadingClass addActivityIndicatotTo:separatedview withMessage:NSLocalizedString(@"GettingFrames",@"GettingFrames")];
    [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:60.0 ];
    
    
}

-(void)loadingFrmesAndHelpScreen
{
    
    /* Generate help images */
    [Utility generateImagesForHelp];
    
    /* Generate the thumbnail images */
    [Utility generateThumnailsForFrames];
    
}

-(void)hideActivityIndicator
{
    [LoadingClass removeActivityIndicatorFrom:separatedview];
}
-(void)settingTouchViewHide
{
    NSLog(@"TouchViewHide---%%%%%%%%");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an Integer
    [prefs setInteger:1 forKey:@"TouchViewHide"];
    
}
-(void)settingTouchViewUnHide
{
    NSLog(@"TouchViewUnHide---!!!!!!");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an Integer
    [prefs setInteger:0 forKey:@"TouchViewHide"];
    
}
-(void)settingTouchViewUnHided
{
    NSLog(@"TouchViewUnHide---!!!!!!");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an Integer
    [prefs setInteger:0 forKey:@"TouchViewHided"];
    
}

//getting subscriptionDetails
-(void)SubscriptionDetailsYearly
{
    if (@available(iOS 11.2, *)) {
        firstsubscriptionPriceYearly = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPackYearly];
        NSLog(@"Subscription price -----yearly %@",firstsubscriptionPriceYearly);
        NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPackYearly];
        NSLog(@"Subscription Title-----yearly %@",firstsubscriptionTitle);
        
        NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPackYearly];
        TrailPeriodDaysYearly = [[InAppPurchaseManager Instance]getTrailPeriodofProductForYear:kInAppPurchaseSubScriptionPackYearly];
        NSLog(@"Subscription Trail period-----yearly %ld",TrailPeriodDaysYearly);
        if(nil == firstsubscriptionPriceYearly)
        {
            firstsubscriptionPriceYearly = DEFAULT_YEARLY_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
            
        }
        
    }
    else
    {
        firstsubscriptionPriceYearly = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPackYearly];
        NSLog(@"Subscription price-----yearly %@",firstsubscriptionPriceYearly);
        NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPackYearly];
        NSLog(@"Subscription Title-----yearly %@",firstsubscriptionTitle);
        
        NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPackYearly];
        NSLog(@"Subscription Description-----yearly %@",firstsubscriptionDescription);
        if(nil == firstsubscriptionPriceYearly)
        {
            firstsubscriptionPriceYearly = DEFAULT_YEARLY_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
        }
    }
    
    
    // [preview showInAppPurchaseWithPackages:packages];
}
#pragma SubscriptionDetails

-(void)SubscriptionDetails
{
    if (@available(iOS 11.2, *)) {
        firstsubscriptionPrice = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription price----- %@",firstsubscriptionPrice);
        NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription Title----- %@",firstsubscriptionTitle);
        
        NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPack];
        TrailPeriodDays = [[InAppPurchaseManager Instance]getTrailPeriodofProductForMonth:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription Trail period----- %ld",TrailPeriodDays);
        if(nil == firstsubscriptionPrice)
        {
            firstsubscriptionPrice = DEFAULT_WATERMARK_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
            
        }
        
    }
    else
    {
        firstsubscriptionPrice = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription price----- %@",firstsubscriptionPrice);
        NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription Title----- %@",firstsubscriptionTitle);
        
        NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription Description----- %@",firstsubscriptionDescription);
        if(nil == firstsubscriptionPrice)
        {
            firstsubscriptionPrice = DEFAULT_WATERMARK_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
        }
    }
    
}

-(void)cancelAutoRenewalSubscription
{
    UIApplication *application = [UIApplication sharedApplication];
    //NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
    NSURL *URL = [NSURL URLWithString:@"https://apps.apple.com/account/subscriptions"];
    //https://apps.apple.com/account/subscriptions
    //https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions
    
    [application openURL:URL options:@{} completionHandler:nil];
    
    //    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
    //        if (success) {
    //             NSLog(@"Opened url");
    //        }
    //    }];
}
-(void)ShowSubscriptionView
{
    SubscriptionView2 = [[SimpleSubscriptionView alloc]init];
    if (self.navigationController)
        [self.navigationController pushViewController:SubscriptionView2 animated:YES];
}

#pragma GoogleMobileAds

/*
 - (GADInterstitial *)createAndLoadInterstitial
 {
 
 interstitialAds = [[GADInterstitial alloc] initWithAdUnitID:fullscreen_admob_id];
 interstitialAds.delegate = self;
 [interstitialAds loadRequest:[GADRequest request]];
 return interstitialAds;
 }
 
 
 -(void)interstitialWillPresentScreen:(GADInterstitial *)ad
 {
 interstitialAds = [self createAndLoadInterstitial];
 //[_player pause];
 NSLog(@"Google add gets loadedfr ffgf");
 }
 
 -(void)addPreLoad
 {
 if ([interstitialAds isReady])
 {
 
 NSLog(@"Google add gets loadedfr");
 
 [interstitialAds presentFromRootViewController:self.navigationController.visibleViewController];
 // [interstitialAds presentFromRootViewController:shareView];
 
 
 }
 
 }
 */
- (void)showInterstitial2 {
    
    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        NSLog(@"Pro Version is purchased Ads won't be served");
    }else{
        NSLog(@"Not purchased----");
        __weak MainController *weakSelf = self;
        MainController *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (strongSelf.interstitial &&
            [strongSelf.interstitial
             canPresentFromRootViewController:strongSelf
             error:nil])
        {
            // [strongSelf.interstitial presentFromRootViewController:strongSelf];
            [self.interstitial presentFromRootViewController:self.navigationController.visibleViewController];
            self.interstitial.paidEventHandler = ^void(GADAdValue * _Nonnull value){
                //  strongSelf.interstitial.paidEventHandler = ^void(GADAdValue * _Nonnull value){
                
                
                // TODO: Send the impression-level ad revenue information to your preferred analytics
                // server directly within this callback.
                
                // Extract the impression-level ad revenue data.
                NSDecimalNumber *value1 = value.value;
                NSString *currencyCode = value.currencyCode;
                precision = value.precision;
                
                NSLog(@"Impression Here $$$$$ %f",value.value.doubleValue);
                
                NSLog(@"Add Value Here $$$$$ %@",value1);
                NSLog(@"currencyCode Here $$$$$ %@",currencyCode);
                //NSLog(@"precision Here $$$$$ %ld",(long)precision);
                
            
            
                // These values below won’t be used in ROAS recipe.
                // But log for purposes of debugging and future reference.
                
                [FIRAnalytics logEventWithName:@"Paid_Ad_Impression"
                                    parameters:@{
                    @"value": value.value,
                    @"currency": value.currencyCode,
                    //  @"precision": precision,
                    @"adunitid_SharePage": fullscreen_admob_sharePage,
                    @"network": @"Admob"
                }];
                
                
            };
            
            
            // [self.interstitial presentFromRootViewController:self];
        } else {
            NSLog(@"Ad wasn't ready");
        }
    }
}
//- (void)adWillPresentFullScreenContent:(id)ad {
//  NSLog(@"Ad will present full screen content.");
//}
- (void)adDidPresentFullScreenContent:(id)ad {
    NSLog(@"Ad did present full screen content.");
}

- (void)ad:(id)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
    NSLog(@"Ad failed to present full screen content with error %@.", [error localizedDescription]);
}

- (void)adDidDismissFullScreenContent:(id)ad {
    NSLog(@"Ad did dismiss full screen content.");
    
}

-(void)settingPopUpAlert
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // saving an Integer
    [prefs setInteger:1 forKey:@"PopUpShowed"];
    
}




//-(void)menuAdding
//{
//    NSLog(@"menu Adding...PopUpShown  %@",PopUpShown?@"YES":@"NO");
//    NSLog(@"menu Adding...Dont Show  %@",DontShow?@"YES":@"NO");
//    if (!PopUpShown && !DontShow)
//    {
//        PopUpShown = YES;
//        [[UIApplication sharedApplication].keyWindow addSubview:menu];
//        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:menu];
//            NSLog(@"PopUpAdded...");
//    }
//}
//
//-(void)menuShownAlredy
//{
//    if(PopUpShown)
//    {
//        NSLog(@"Removing2...");
//        if(!([[NSUserDefaults standardUserDefaults] integerForKey:@"PopUpSecondTime"] == 1))
//        {
//             PopUpShown = NO;
//        }
//        [[[UIApplication sharedApplication].keyWindow viewWithTag:5005] removeFromSuperview];
//        NSLog(@"PopUpRemoved...");
//    }
//}


-(void)allocateviewforEffectsBack
{
    // UIView *toolbar;
    bgview2 = [[UIView alloc]initWithFrame:CGRectMake(0, optionsView.view.frame.origin.y-10, full_screen.size.width,45)];
    //toolbar.image = [UIImage imageNamed:@"top-bar_vpf"];
    bgview2.backgroundColor=PHOTO_DEFAULT_COLOR;
    bgview2.userInteractionEnabled = YES;
    bgview2.tag = TAG_TOOLBAR_EDIT;
    [self.view addSubview:bgview2];
    [self.view sendSubviewToBack:bgview2];
//      [bgview2 release];
    
}

-(void)removeviewforEffectsBack
{
    if (bgview2!=nil) {
        NSLog(@"Removing back tool bar bg view2 ");
        [bgview2  removeFromSuperview];
        bgview2 = nil;
    }
}


//-(void)popupSelectionSecondTime
//{
//    PopUpShown = YES;
//    [self settingPopUpAlertSecondTime];
//}

-(void)settingPopUpAlertSecondTime
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // saving an Integer
    [prefs setInteger:1 forKey:@"PopUpSecondTime"];
    
}
- (void)loadInterstitial {
    GADRequest *request = [GADRequest request];
    //ca-app-pub-3940256099942544/4411468910
    //fullscreen_admob_id
    [GADInterstitialAd
     loadWithAdUnitID:fullscreen_admob_HomeButtonClick
     request:request
     completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        NSLog(@"ad loaded");
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
    }];
}

- (void)loadInterstitial2 {
    GADRequest *request = [GADRequest request];
    //ca-app-pub-3940256099942544/4411468910
    //fullscreen_admob_id
    [GADInterstitialAd
     loadWithAdUnitID:fullscreen_admob_sharePage
     request:request
     completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
    }];
}
- (void)showInterstitial {
    
    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        NSLog(@"Pro Version is purchased Ads won't be served");
    }else{
        NSLog(@"Not purchased---- show Interstitial ");
        
        __weak MainController *weakSelf = self;
        MainController *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (strongSelf.interstitial &&
            [strongSelf.interstitial
             canPresentFromRootViewController:strongSelf
             error:nil])
        {
            [self.interstitial presentFromRootViewController:self.navigationController.visibleViewController];
            self.interstitial.paidEventHandler = ^void(GADAdValue * _Nonnull value){
                
                
                // TODO: Send the impression-level ad revenue information to your preferred analytics
                // server directly within this callback.
                
                // Extract the impression-level ad revenue data.
                NSDecimalNumber *value1 = value.value;
                NSString *currencyCode = value.currencyCode;
                precision = value.precision;
                
                NSLog(@"Impression Here $$$$$ %f",value.value.doubleValue);
                
                NSLog(@"Add Value Here $$$$$ %@",value1);
                NSLog(@"currencyCode Here $$$$$ %@",currencyCode);
                //   NSLog(@"precision Here $$$$$ %ld",(long)precision);
                
                
                
                // These values below won’t be used in ROAS recipe.
                // But log for purposes of debugging and future reference.
                
                [FIRAnalytics logEventWithName:@"Paid_Ad_Impression"
                                    parameters:@{
                    @"value": value.value,
                    @"currency": value.currencyCode,
                    //  @"precision": precision,
                    @"adunitid_Resumepage": fullscreen_admob_HomeButtonClick,
                    @"network": @"Admob"
                }];
            };
        }
        else {
            NSLog(@"Ad wasn't ready");
        }
        
    }
}

-(void)showLoadingForAd
{
    [self loadInterstitial];
    // [Utility addActivityIndicatotTo:self.view withMessage:@"Wait"];
    [LoadingClass addActivityIndicatotTo:Resume_view withMessage:NSLocalizedString(@"Loading",@"Loading")];
    NSLog(@"******* show loading for ad");
    [self performSelector:@selector(startAdsdownloading) withObject:nil afterDelay:4.0 ];
    
}
-(void)startAdsdownloading
{
    [self performSelector:@selector(hideActivityIndicatorForResumeAd) withObject:nil afterDelay:1.0 ];
    
}
-(void)hideActivityIndicatorForResumeAd
{
    // [Utility removeActivityIndicatorFrom:self.view];
    
    [LoadingClass removeActivityIndicatorFrom:Resume_view];
    NSLog(@"******* Removed loading for ad");
    [Resume_view removeFromSuperview];
    Resume_view = nil;
    self.appWentToBackground = NO;
    if(!changeTitle)
        [self playAllPreviewPlayers];
    [self showInterstitial];
}

+ (UIViewController *)topViewController {
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    return [self topViewControllerWithRootViewController:rootViewController];
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController) {
        return [self topViewControllerWithRootViewController:rootViewController.presentedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:nav.visibleViewController];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tab.selectedViewController];
    } else {
        return rootViewController;
    }
}


-(void)remove_resumeview
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if(!changeTitle)
//        [self playAllPreviewPlayers];
    //[self SetOriginalUI];
    if (![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        NSLog(@"interestial_HomeButtonClickCount %d",self.interestial_HomeButtonClickCount);
        if(self.interestial_HomeButtonClickCount>0)
        {
            [self showLoadingForAd];
        }
        else
        {
            self.appWentToBackground = NO;
            [Resume_view removeFromSuperview];
            Resume_view = nil;
            if(!changeTitle)
                [self playAllPreviewPlayers];
        }
        NSLog(@"Adds not ------:");
    }
    else
    {
        self.appWentToBackground = NO;
        [Resume_view removeFromSuperview];
        Resume_view = nil;
        if(!changeTitle)
            [self playAllPreviewPlayers];
        NSLog(@"Adds are purchased----");
    }
//    if(Resume_view)
//    {
//        [Resume_view removeFromSuperview];
//        Resume_view = nil;
//    }
    
}

-(void)Resumepage
{
    UIViewController *topVC = [MainController topViewController];
    NSLog(@"Current view controller: %@", NSStringFromClass([topVC class]));
    
    if([topVC class] == MainController.class)
    {
        if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        else{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        NSLog(@"Resume Page Here--- Main view controller");
        // Dismiss other views which are present
        if ([self.presentedViewController isKindOfClass:[AspectRatioViewController class]]) {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        if ([self.presentedViewController isKindOfClass:[SliderViewController class]]) {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        if ([self.presentedViewController isKindOfClass:[BackgroundSelectionViewController class]]) {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        if ([self.presentedViewController isKindOfClass:[StickerViewController class]]) {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        NSLog(@"Resume Page Here---");
        
        [self gettingInterestialCount];
        
        CGRect resume_frame,resume_button_frame;
        
        if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        {
            
            resume_frame =  CGRectMake(full_Screen.size.width/2-40, full_Screen.size.height*0.23, 80, 80);
            resume_button_frame = CGRectMake(full_Screen.size.width/2-50, full_Screen.size.height*0.30, 100, 50);
            
        }
        
        else
        {
            
            if (full_Screen.size.height > 600)
            {
                resume_frame =  CGRectMake(full_Screen.size.width/2-40, full_Screen.size.height*0.35, 80, 80);
                resume_button_frame = CGRectMake(full_Screen.size.width/2-50, full_Screen.size.height*0.45, 100, 50);
            }
            
            
            else if (full_Screen.size.height > 480.0)
            {
                resume_frame =  CGRectMake(full_Screen.size.width/2-40, full_Screen.size.height*0.37, 80, 80);
                resume_button_frame = CGRectMake(full_Screen.size.width/2-50, full_Screen.size.height*0.49, 100, 50);
            }
            
            
            else
            {
                resume_frame =  CGRectMake(full_Screen.size.width/2-40, full_Screen.size.height*0.23, 80, 80);
                resume_button_frame = CGRectMake(full_Screen.size.width/2-50, full_Screen.size.height*0.30, 100, 50);
                
            }
            
        }
        
        
        Resume_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, full_Screen.size.width, full_Screen.size.height+200)];
        Resume_view.image = [UIImage imageNamed:@"Resume_screen.png"];
        Resume_view.backgroundColor = DARK_GRAY_BG;
        Resume_view.contentMode = UIViewContentModeScaleAspectFit;
        Resume_view.userInteractionEnabled = YES;
        
        if(from_share == FALSE)
        {
            NSLog(@"this is the problem ---");
        }
        
        else
        {
            
            //            [[[UIApplication sharedApplication] keyWindow] addSubview:Resume_view];
            [keyWindow addSubview:Resume_view];
            [keyWindow bringSubviewToFront:Resume_view];
        }
        
        // [self.view addSubview:Resume_view];
        
        
        UIButton *Resume = [UIButton buttonWithType:UIButtonTypeCustom];
        Resume.userInteractionEnabled = YES;
        Resume . frame = resume_frame;
        [Resume setImage:[UIImage imageNamed:@"Res_button.png"] forState:UIControlStateNormal];
        [Resume addTarget:self action:@selector(remove_resumeview) forControlEvents:UIControlEventTouchUpInside];
        [Resume_view addSubview:Resume];
        
        UILabel * resume = [[UILabel alloc]initWithFrame:resume_button_frame];
        resume.textColor= [UIColor grayColor];
        resume.text = @"Resume";
        resume.textAlignment = NSTextAlignmentCenter;
        [Resume_view addSubview:resume];
        
        NSLog(@"ukhjkhjukhjkh");
    }
    else if([topVC class] == SimpleSubscriptionView.class)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}


-(void)RemoveView
{
    self.appWentToBackground = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
   // [self pauseAllPreviewPlayers];
    NSLog(@"pause Video Preview Play Back");
    [self SetOriginalUI];
    if (Resume_view !=nil) {
        [Resume_view removeFromSuperview];
        Resume_view = nil;
    }
}



-(void) checkMediaLibraryPermissions {
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"MusicLibraryPermission"] == 1)
    {
        [self showAudioPicker];
        NSLog(@"condition -----1");
    }
    else
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status){
            mpAuthorizationStatus = status;
            NSLog(@"condition -----2");
            if(mpAuthorizationStatus == MPMediaLibraryAuthorizationStatusAuthorized && !([[NSUserDefaults standardUserDefaults] integerForKey:@"MusicLibraryPermission"] == 1))
            {
                [self PermissionAuthorisedMusic];
                NSLog(@"condition -----3 %ld",mpAuthorizationStatus);
                [self showAudioPicker];
                
                // allowedAccessToMusic = YES;
            }
            else if(mpAuthorizationStatus == MPMediaLibraryAuthorizationStatusDenied )
            {
                NSLog(@"condition -----4");
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSAppleMusicUsageDescription"];
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:accessDescription message:@"To give permissions tap on 'Change Settings' button" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    
                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Change Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        [self Open_URL:UIApplicationOpenSettingsURLString];
                    }];
                    [alertController addAction:settingsAction];
                    if (self.presentedViewController) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [self presentViewController:alertController animated:YES completion:nil];
                        }];
                    } else {
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                });
            }
            else if(mpAuthorizationStatus == MPMediaLibraryAuthorizationStatusNotDetermined)
            {
                NSLog(@"condition -----5");
                NSLog(@"MPAuthorizationStatusNotDetermined ***********");
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status){
                    mpAuthorizationStatus = status;
                }];
                if(mpAuthorizationStatus == MPMediaLibraryAuthorizationStatusAuthorized )
                {
                    [self PermissionAuthorisedMusic];
                    
                    [self showAudioPicker];
                }
                else
                {
                    NSLog(@"opening settings ***********");
                }
            }
        }];
}

-(void)PermissionUnAuthorised
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // saving an Integer
    [prefs setInteger:0 forKey:@"PhotoLibraryPermission"];
}
-(void)PermissionAuthorised
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1 forKey:@"PhotoLibraryPermission"];
}
-(void)PermissionUnAuthorisedMusic
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // saving an Integer
    [prefs setInteger:0 forKey:@"MusicLibraryPermission"];
}

-(void)PermissionAuthorisedMusic
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1 forKey:@"MusicLibraryPermission"];
}


- (void)CheckingAccessLevel:(BOOL)isVideo numberofimages:(int)selectionCount
{
    NSLog(@"PhotoLibraryPermission %ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"PhotoLibraryPermission"]);
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PhotoLibraryPermission"] == 1)
    {
        if(isVideo)
            [ish pickVideo];
        else
            [ish pickImage:selectionCount];
    }
    else
    {
        if (@available(iOS 14, *)) {
            [PHPhotoLibrary requestAuthorizationForAccessLevel:accessLevel handler:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusLimited ) {
                    [self PermissionAuthorised];
                    if(isVideo)
                        [ish pickVideo];
                    else
                        [ish pickImage:selectionCount];
                    NSLog(@"Limited Access----");
                }
                else if (status == PHAuthorizationStatusAuthorized)
                {
                    [self PermissionAuthorised];
                    if(isVideo)
                        [ish pickVideo];
                    else
                        [ish pickImage:selectionCount];
                    NSLog(@"Full Access----");
                    
                }
                else if(status == PHAuthorizationStatusDenied)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:NO completion:nil];
                        [self OpenSettings];
                        NSLog(@"denied 1");
                    });
                }
                else if(status == PHAuthorizationStatusNotDetermined)
                {
                    [PHPhotoLibrary requestAuthorizationForAccessLevel:accessLevel handler:^(PHAuthorizationStatus status) {
                        if (status == PHAuthorizationStatusLimited || status == PHAuthorizationStatusAuthorized) {
                            [self PermissionAuthorised];
                            if(isVideo)
                                [ish pickVideo];
                            else
                                [ish pickImage:selectionCount];
                        }
                        else if(status == PHAuthorizationStatusDenied)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self dismissViewControllerAnimated:NO completion:nil];
                                [self OpenSettings];
                                NSLog(@"denied 2");
                            });
                            
                        }
                    }];
                }
            }];
        } else {
            
            [self CheckPermissionStatus:isVideo numberofimages:selectionCount];
        }
        //        if (@available(iOS 14, *)) {
        //            if([PHPhotoLibrary authorizationStatusForAccessLevel:accessLevel] ==PHAuthorizationStatusLimited) {
        //                NSLog(@"Permisiion is PHAuthorizationStatusLimited");
        //                [self PermissionAuthorised];
        //                if(isVideo)
        //                    [ish pickVideo];
        //                else
        //                    [ish pickImage:selectionCount];
        //            }
        //            else if([PHPhotoLibrary authorizationStatusForAccessLevel:accessLevel] == PHAuthorizationStatusDenied)
        //            {
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    [self dismissViewControllerAnimated:NO completion:nil];
        //                    [self OpenSettings];
        //                    NSLog(@"denied 3");
        //                });
        //            }
        //        }
    }
}


- (void)CheckPermissionStatus:(BOOL)isVideo numberofimages:(int)selectionCount
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PhotoLibraryPermission"] == 1)
    {
        if(isVideo)
            [ish pickVideo];
        else
            [ish pickImage:selectionCount];
    }
    else {
        NSLog(@"------------- ***********");
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            phAuthorizationStatus = status;
            NSLog(@"&&&&&&&&&&&&&&&&&&& ***********");
        }];
        phAuthorizationStatus = [PHPhotoLibrary authorizationStatus];
        if (@available(iOS 14, *)) {
            if(phAuthorizationStatus == PHAuthorizationStatusLimited)
            {
                NSLog(@"PHAuthorizationStatusAuthorized ***********");
                [self PermissionAuthorised];
                if(isVideo)
                    [ish pickVideo];
                else
                    [ish pickImage:selectionCount];
            }
            else if(phAuthorizationStatus == PHAuthorizationStatusAuthorized)
            {
                NSLog(@"PHAuthorizationStatusAuthorized ***********");
                [self PermissionAuthorised];
                if(isVideo)
                    [ish pickVideo];
                else
                    [ish pickImage:selectionCount];
            }
            else if(phAuthorizationStatus == PHAuthorizationStatusDenied)
            {
                [self OpenSettings];
                NSLog(@"PHAuthorizationStatusDenied ***********");
            }
            else if(phAuthorizationStatus == PHAuthorizationStatusNotDetermined)
            {
                NSLog(@"PHAuthorizationStatusNotDetermined ***********");
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    phAuthorizationStatus = status;
                    if(phAuthorizationStatus == PHAuthorizationStatusAuthorized )
                    {
                        [self PermissionAuthorised];
                        if(isVideo)
                            [ish pickVideo];
                        else
                            [ish pickImage:selectionCount];
                    }
                    else [self OpenSettings];
                }];
            }
        } else {
            if(phAuthorizationStatus == PHAuthorizationStatusAuthorized)
            {
                NSLog(@"PHAuthorizationStatusAuthorized ***********");
                [self PermissionAuthorised];
                if(isVideo)
                    [ish pickVideo];
                else
                    [ish pickImage:selectionCount];
            }
            else if(phAuthorizationStatus == PHAuthorizationStatusDenied)
            {
                [self dismissViewControllerAnimated:NO completion:nil];
                [self OpenSettings];
                NSLog(@"PHAuthorizationStatusDenied ***********");
            }
            else if(phAuthorizationStatus == PHAuthorizationStatusNotDetermined)
            {
                NSLog(@"PHAuthorizationStatusNotDetermined ***********");
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    phAuthorizationStatus = status;
                    if(phAuthorizationStatus == PHAuthorizationStatusAuthorized )
                    {
                        [self PermissionAuthorised];
                        if(isVideo)
                            [ish pickVideo];
                        else
                            [ish pickImage:selectionCount];
                    }
                    else
                    {
                        NSLog(@"opening settings ***********");
                        [self OpenSettings];
                    }
                }];
            }
        }
    }
}



-(void)OpenSettings
{
    //User don't give us permission. Showing alert with redirection to settings
    //Getting description string from info.plist file
    NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:accessDescription message:@"To give permissions tap on 'Change Settings' button" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Change Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self Open_URL:UIApplicationOpenSettingsURLString];
    }];
    [alertController addAction:settingsAction];
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    } else {
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //[self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL)getLockStatus
{
    return [[SRSubscriptionModel shareKit]IsAppSubscribed];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    //    [self ShowAlert:@"Alert!" message:@"More cache space required to save the video, please free up more storage and try again"];
}



-(void)ShowAlert:(NSString*)title message:(NSString*)msg
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}





- (void)toggleVideoMuteStatus:(int)photoIndex {
    frameIsEdited = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [sess getVideoInfoKeyForPhotoAtIndex:photoIndex];
    NSData *myData = [defaults objectForKey:key];
    
    if (myData) {
        // Unarchive the dictionary
        NSDictionary *videoInfo = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:myData];
        
        if (videoInfo) {
            // Create a mutable copy of the dictionary
            NSMutableDictionary *mutableVideoInfo = [videoInfo mutableCopy];
            
            // Toggle the mute status
            BOOL isMuted = [[mutableVideoInfo objectForKey:@"MuteAudio"] boolValue];
            [mutableVideoInfo setObject:@(!isMuted) forKey:@"MuteAudio"];
            
            // Archive and save back to UserDefaults
            NSData *updatedData = [NSKeyedArchiver archivedDataWithRootObject:mutableVideoInfo];
            [defaults setObject:updatedData forKey:key];
            [defaults synchronize];
            
            NSLog(@"Video mute status toggled for photo index %d: %@", photoIndex, !isMuted ? @"MUTED" : @"UNMUTED");
        }
    }
}

-(void)gettingInterestialCount
{
    
    NSInteger homeButtonClickCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"HomeClickValue"];
    NSInteger shareInterestialCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"ShareValue"];//[Interestial_Share_defaults integerForKey:@"Interestial_ShareScreen"];
    NSInteger buttonInterestialCount = homeButtonClickCount; //[Interestial_Button_defaults integerForKey:@"Interestial_HomeButtonClick"];
    
    
    self. interestial_ShareCount = (int) shareInterestialCount;
    self.interestial_HomeButtonClickCount = (int) buttonInterestialCount;
    
    NSLog(@"interestial_ShareCount is in Video controller %d ",self.interestial_ShareCount);
    NSLog(@"interestial_HomeButtonClickCount is in Main controller %ld ",(long)homeButtonClickCount);
}

-(void)backButtonView
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 11.0, *)) {
        if (SafeAreaBottomPadding > 0) {
            // iPhone with notch
            
            //CGFloat topPadding = keyWindow.safeAreaInsets.top;
            // CGFloat bottomPadding = keyWindow.safeAreaInsets.bottom;
            backButton . frame = CGRectMake(0, SafeAreaTopPadding/2, customBarHeight, customBarHeight);
        }
        else
        {
            backButton . frame = CGRectMake(0, 0, customBarHeight, customBarHeight);
        }
    }
    else
    {
        backButton . frame = CGRectMake(0, 0, customBarHeight, customBarHeight);
    }
    
    [backButton setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    // [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *backButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton2 . frame = CGRectMake(0, 0, customBarHeight+50, customBarHeight+50);
    // [backButton setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    //[backButton2 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton2];
}

- (void)animateBackgroundToCenter {
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        // Reset scaling and position
        mainBackground.transform = CGAffineTransformIdentity;
        
        // Optional: Reset corner radius
        mainBackground.layer.cornerRadius = 0;
        mainBackground.layer.masksToBounds = YES;
    } completion:nil];
}

-(void)resetToEditingMode
{
    changeTitle = NO;
    optionsView.view.hidden = NO;
    backView.hidden = NO;
    [self animateBackgroundToCenter];
    [self hideTopButtonContainer];
    if(previewPlayButton)
    {
        [previewPlayButton removeFromSuperview];
    }
    [self assignRightBarButtonItem];
    [sess exitNoTouchMode];
    NSLog(@"Play all video player 9");
    [self playAllPreviewPlayers];
}

-(void)removeAllPreviewPlayers
{
    for(int index = 0; index < sess.frame.photoCount; index++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            NSLog(@"pausing the video");
            [pht.view removePlayer];
        }
    }
    [sess removeAudioPlayer];
    [self switchOffMasterAudio];
}

-(void)removeAllEffectVideos
{
    for(int index = 0; index < sess.frame.photoCount; index++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            [sess saveImage:[sess getOriginalImageAtIndex:index] atIndex:index]; // Save original image back
            //Delete effect Video if it is present
            [sess deleteEffectVideoAtPhototIndex:index];
        }
    }
}


- (void)switchOffMasterAudio {
    [[NSUserDefaults standardUserDefaults]setObject:0
                                             forKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY];
}

-(void)pauseAllPreviewPlayers
{
    for(int index = 0; index < sess.frame.photoCount; index++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            NSLog(@"pausing the video");
            [pht.view pausePlayer];
        }
    }
    [sess muteMasterAudio];
}

-(void)playAllPreviewPlayers
{
    for(int index = 0; index < sess.frame.photoCount; index++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:index];
        if(nil != pht)
        {
            [pht.view playPlayer];
        }
    }
    [sess unmuteMasterAudio];
}


-(void)goBack
{
    if(changeTitle)
    {
        // Reset to editing mode
        [self resetToEditingMode];
    }
    else
    {
        frameIsEdited = YES;
        effectBeingApplied = NO;
        [self removeAllPreviewPlayers];
        dontShowOptionsUntilOldAssetsSaved = NO;
        [self doneBtnTapped];
        [self releaseResourcesForModeChange];
        [self assignRightBarButtonItem];
        eMode = 0;
        [self releaseResourcesForFrames];
        [self allocateResourcesForFrames]; //sc
        // [self.navigationController popViewControllerAnimated:YES];
        [self resetFrameView];
        NSLog(@"main class going back---");
        effectsApplied = NO;
        [self SetOriginalImageForAllFrames]; // changes made in VC 3.5 - 4.7
        [self removeAllTextviewsFromParent];
        [self removeAllStickerviewsFromParent];
        [self removeAllEffectVideos]; // It removes all effects video if present when switching to frames view
        [sess initAspectRatio:ASPECTRATIO_1_1];
       // [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)removeAllTextviewsFromParent
{
    for (UIView *view in self.textBoxes) {
        [view removeFromSuperview];
    }
    [self.textBoxes removeAllObjects];
    self.lastActiveTextView = nil;
}


-(void)removeAllStickerviewsFromParent
{
    for (UIView *view in self.addedstickes) {
        [view removeFromSuperview];
    }
    [self.addedstickes removeAllObjects];
}


-(UIBarButtonItem *)createLockDoneButton
{
    // Disabled state button - dark gray background, white text
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 70, 35);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    doneButton.backgroundColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
    doneButton.layer.cornerRadius = 5.0;
    doneButton.clipsToBounds = YES;
    [doneButton addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    return rightBarButton;
}






-(UIBarButtonItem *)createUnlockDoneButton
{
    // Enabled state button - green to cyan gradient, black text (matching FrameSelectionController)
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 70, 35);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    doneButton.layer.cornerRadius = 5.0;
    doneButton.clipsToBounds = YES;
    [doneButton addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];

    // Add gradient layer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = doneButton.bounds;
    UIColor *greenColor = [UIColor colorWithRed:188/255.0 green:234/255.0 blue:109/255.0 alpha:1.0];
    UIColor *cyanColor = [UIColor colorWithRed:20/255.0 green:249/255.0 blue:245/255.0 alpha:1.0];
    gradientLayer.colors = @[(id)greenColor.CGColor, (id)cyanColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    gradientLayer.cornerRadius = 5.0;
    [doneButton.layer insertSublayer:gradientLayer atIndex:0];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    return rightBarButton;
}

-(UIBarButtonItem*)createHomeAsRightButton
{
    // Create a right bar button item with an image named "Home"
    UIImage *homeImage = [UIImage imageNamed:@"Home"];
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:homeImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(movingToHomePage)];
    // Set the tint color of the bar button item (optional)
    homeButton.tintColor = [UIColor whiteColor]; // Change to your preferred color
    return homeButton;
}


- (UIBarButtonItem *)createDoneButton:(BOOL)locked {
    // Create button
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
    //config.baseBackgroundColor = [UIColor systemBlueColor]; // Background color
    config.baseForegroundColor = [UIColor whiteColor]; // Text and icon color
    // config.cornerStyle = UIButtonConfigurationCornerStyle; // Oval shape
    
    // Set title
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Done"
                                                                attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]}];
    config.attributedTitle = title;
    if(!locked)
    {
        doneButton.backgroundColor = [UIColor colorWithRed:25.0/255.0
                                                     green:184.0/255.0 blue:250.0/255.0 alpha:1.0];
        //[UIColor colorWithRed:30.0/255.0 green:168.0/255.0 blue:248.0/255.0 alpha:1];//[[UIColor systemCyanColor]colorWithAlphaComponent:1];
    }
    else
    {
        doneButton.backgroundColor = [[UIColor systemYellowColor]colorWithAlphaComponent:1]; //[UIColor colorWithRed:192.0/255.0 green:147.0/255.0 blue:8.0/255.0 alpha:1];
        // Set lock icon
        UIImage *lockIcon = [UIImage systemImageNamed:@"lock.fill"];
        config.image = lockIcon;
        config.imagePlacement = NSDirectionalRectEdgeTrailing; // Icon on right
        config.imagePadding = 5; // Space between text and icon
    }
    doneButton.configuration = config;
    
    doneButton.layer.cornerRadius = 15;
    // Add target action
    [doneButton addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    // Wrap button in UIBarButtonItem
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton ];
    return rightBarButton;
}




- (CGSize)videoSizeFromTransform:(CGAffineTransform)transform naturalSize:(CGSize)naturalSize {
    CGRect transformedRect = CGRectApplyAffineTransform(CGRectMake(0, 0, naturalSize.width, naturalSize.height), transform);
    CGSize adjustedSize = CGSizeMake(fabs(transformedRect.size.width), fabs(transformedRect.size.height));
    return adjustedSize;
}





- (void)makeBirthdayCardFromVideoAt:(NSURL *)videoURL
                            forName:(NSString *)name
                         onComplete:(void (^)(NSURL *outputURL))onComplete
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    if (!assetTrack) {
        NSLog(@"Video track not found.");
        onComplete(nil);
        return;
    }
    
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSError *error = nil;
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    [compositionTrack insertTimeRange:timeRange ofTrack:assetTrack atTime:kCMTimeZero error:&error];
    if (error) {
        NSLog(@"Video insert error: %@", error);
        onComplete(nil);
        return;
    }
    
    // Audio
    AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    if (audioTrack) {
        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:timeRange ofTrack:audioTrack atTime:kCMTimeZero error:nil];
    }
    
    compositionTrack.preferredTransform = assetTrack.preferredTransform;
    CGSize videoSize = [self videoSizeFromTransform:assetTrack.preferredTransform naturalSize:assetTrack.naturalSize];
    
    // CALayers
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    CGSize size = CGSizeMake(1920, 1080);
    UIImage *whiteImage = [self blankWhiteImageWithSize:size];
    backgroundLayer.contents = (id)whiteImage.CGImage;//[UIImage imageNamed:@"background"]
    backgroundLayer.contentsGravity = kCAGravityResizeAspectFill;
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(20, 20, videoSize.width - 40, videoSize.height - 40);
    
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    
    [self addConfettiToLayer:overlayLayer];
    [self addImageToLayer:overlayLayer videoSize:videoSize];
    //  [self addText:[NSString stringWithFormat:@"Happy Birthday,\n%@", name] toLayer:overlayLayer videoSize:videoSize];
    
    CALayer *outputLayer = [CALayer layer];
    outputLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [outputLayer addSublayer:backgroundLayer];
    [outputLayer addSublayer:videoLayer];
    [outputLayer addSublayer:overlayLayer];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = videoSize;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
#if TARGET_OS_SIMULATOR
    NSLog(@"Skipping animationTool in simulator to avoid XPC crash.");
#else
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool
                                      videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                      inLayer:outputLayer];
#endif
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = timeRange;
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionTrack];
    [layerInstruction setTransform:assetTrack.preferredTransform atTime:kCMTimeZero];
    instruction.layerInstructions = @[layerInstruction];
    videoComposition.instructions = @[instruction];
    
    // NSString *outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov", [NSUUID UUID].UUIDString]];
    NSURL *exportURL = [NSURL fileURLWithPath:[sess pathToCurrentVideo]];
    [self deleteFileIfExistsAtURL:exportURL];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputURL = exportURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.videoComposition = videoComposition;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                onComplete(exportURL);
            } else {
                NSLog(@"Export failed: %@", exportSession.error);
                onComplete(nil);
            }
        });
    }];
}

- (void)deleteFileIfExistsAtURL:(NSURL *)fileURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileURL.path]) {
        NSError *error = nil;
        [fileManager removeItemAtURL:fileURL error:&error];
        if (error) {
            NSLog(@"Error deleting file: %@", error.localizedDescription);
        } else {
            NSLog(@"Deleted file at path: %@", fileURL.path);
        }
    }
}


- (void)addImageToLayer:(CALayer *)layer videoSize:(CGSize)videoSize {
    UIImage *image = [UIImage imageNamed:@"overlay"];
    if (!image) return;
    
    CGFloat aspect = image.size.width / image.size.height;
    CGFloat width = videoSize.width;
    CGFloat height = width / aspect;
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, -height * 0.15, width, height);
    imageLayer.contents = (id)image.CGImage;
    
    [layer addSublayer:imageLayer];
}

- (void)addText:(NSString *)text toLayer:(CALayer *)layer frame:(CGRect)frame {
    UIFont *font = [UIFont fontWithName:@"ArialRoundedMTBold" size:60];
    UIColor *textColor = [UIColor colorNamed:@"rw-green"];
    
    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: textColor,
        NSStrokeColorAttributeName: UIColor.whiteColor,
        NSStrokeWidthAttributeName: @-3
    };
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = attributedText;
    textLayer.shouldRasterize = YES;
    textLayer.rasterizationScale = [UIScreen mainScreen].scale;
    textLayer.backgroundColor = UIColor.clearColor.CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.frame = frame; //CGRectMake(0, videoSize.height * 0.66, videoSize.width, 150);
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = @(0.8);
    scaleAnim.toValue = @(1.2);
    scaleAnim.duration = 0.5;
    scaleAnim.repeatCount = HUGE_VALF;
    scaleAnim.autoreverses = YES;
    scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnim.beginTime = AVCoreAnimationBeginTimeAtZero;
    scaleAnim.removedOnCompletion = NO;
    [textLayer addAnimation:scaleAnim forKey:@"scale"];
    
    [layer addSublayer:textLayer];
}

- (void)addConfettiToLayer:(CALayer *)layer {
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i <= 5; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"confetti%d", i]];
        if (img) [images addObject:img];
    }
    
    NSArray *colors = @[
        UIColor.systemGreenColor, UIColor.systemRedColor, UIColor.systemBlueColor,
        UIColor.systemPinkColor, UIColor.systemOrangeColor, UIColor.systemPurpleColor, UIColor.systemYellowColor
    ];
    
    NSMutableArray *cells = [NSMutableArray array];
    for (int i = 0; i < 16; i++) {
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.contents = (__bridge id)[images[arc4random_uniform((uint32_t)images.count)] CGImage];
        cell.birthRate = 3;
        cell.lifetime = 12;
        cell.velocity = arc4random_uniform(100) + 100;
        cell.emissionLongitude = 0;
        cell.emissionRange = 0.8;
        cell.spin = 4;
        cell.color = [colors[arc4random_uniform((uint32_t)colors.count)] CGColor];
        cell.scale = (CGFloat)(arc4random_uniform(60) + 20) / 100.0;
        [cells addObject:cell];
    }
    
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.emitterPosition = CGPointMake(layer.frame.size.width / 2, layer.frame.size.height + 5);
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.emitterSize = CGSizeMake(layer.frame.size.width, 2);
    emitter.emitterCells = cells;
    
    [layer addSublayer:emitter];
}

- (NSURL *)applicationTempDirectory {
    return [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
}


#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *fileURL = urls.firstObject;
    if (!fileURL) return;
    
    // Security-scoped resource access (if needed)
    BOOL access = [fileURL startAccessingSecurityScopedResource];
    
    NSString *title = fileURL.lastPathComponent;
    UIImage *thumbnail = [UIImage systemImageNamed:@"music.note"]; // your default speaker/note icon
    
    // Optionally copy to local app folder
    NSURL *targetURL = [[self applicationTempDirectory] URLByAppendingPathComponent:title];
    // Save the audio file reference instead of persistent ID
    [[NSUserDefaults standardUserDefaults] setURL:targetURL
                                           forKey:KEY_AUDIOURL_SELECTED_FROM_FILES];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSFileManager defaultManager] copyItemAtURL:fileURL toURL:targetURL error:nil];
    NSLog(@"media picked from document picker is %@",title);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self audioCell:musicTrackCell setImage:thumbnail];
        [self audioCell:musicTrackCell setTitle:title];
        [self audioCell:musicTrackCell setStatus:YES];
        [self callRefresh];
        //[self refreshAudioCell];
    });

    if (access) {
        [fileURL stopAccessingSecurityScopedResource];
    }
}


- (void)refreshVideoSettingsWithoutAnimation {
    // Remove existing views first
    UIView *touchShield = [self.view viewWithTag:TAG_ADJUST_TOUCHSHEILD];
    UIView *settingsView = [self.view viewWithTag:TAG_VIDEOSETTINGS_BGPAD];
    
    [touchShield removeFromSuperview];
    [settingsView removeFromSuperview];
    
    // Call the original method but skip animations
    [self allocateResourcesForVideoSettingsWithoutAnimation];
}

- (void)allocateResourcesForVideoSettingsWithoutAnimation {
    NSLog(@"allocate Resources For Video Settings Without Animation");
    [self releaseToolBarIfAny];
    
    self.title = @"Music Settings";
    NSNumber *mediaItemId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
    
    // Your existing frame calculations
    CGRect settingsRect = CGRectMake(0, optionsView.view.frame.origin.y-180, full_screen.size.width, 180);
    CGRect selectSqlRect = CGRectMake(0, 0, settingsRect.size.width, 60);
    CGRect musicTrackRect = CGRectMake(0, 60+1.25, settingsRect.size.width, 60);
    CGRect selectTrackRect = CGRectMake(0, 120+2.50, settingsRect.size.width, 60.0-1.25);
    
    // Add touch shield (no animation)
    CGRect full = [[UIScreen mainScreen] bounds];
    CGRect frameForTouchShieldView = CGRectMake(0, 0.0, full.size.width, optionsView.view.frame.origin.y+optionsView.view.frame.size.height+colorBackgroundBarHeightHeight);
    
    UIView *touchSheiled = [[UIView alloc] initWithFrame:frameForTouchShieldView];
    touchSheiled.tag = TAG_ADJUST_TOUCHSHEILD;
    touchSheiled.userInteractionEnabled = YES;
    [self.view addSubview:touchSheiled];
    
    // Create settings view (no animation)
    UIImageView *settings = [[UIImageView alloc] initWithFrame:settingsRect];
    settings.tag = TAG_VIDEOSETTINGS_BGPAD;
    settings.backgroundColor = [UIColor colorWithRed:99/255.0 green:104/255.0 blue:117/255.0 alpha:1.0];
    settings.userInteractionEnabled = YES;
    [self.view addSubview:settings];
    
    NSURL *audioUrl = [[NSUserDefaults standardUserDefaults] URLForKey:KEY_AUDIOURL_SELECTED_FROM_FILES];
    
    if (nil != mediaItemId) {
        NSString *musicTitle = [self getTitleFromMediaItemId:mediaItemId];
        UIImage *musicImage = [self getImageFromMediaItemId:mediaItemId];
        BOOL enableStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY] boolValue];
        
        musicTrackCell = [self allocateVideoSettingsCellWithRect:musicTrackRect
                                                          title:musicTitle
                                                          image:musicImage
                                                         enable:enableStatus];
        [settings addSubview:musicTrackCell];
    }
    else if (audioUrl != NULL) {
        NSString *title = audioUrl.lastPathComponent;
        UIImage *thumbnail = [UIImage systemImageNamed:@"music.note"];
        BOOL enableStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY] boolValue];
        
        musicTrackCell = [self allocateVideoSettingsCellWithRect:musicTrackRect
                                                          title:title
                                                          image:thumbnail
                                                         enable:enableStatus];
        [settings addSubview:musicTrackCell];
    }
    else {
        settingsRect = CGRectMake(settingsRect.origin.x, optionsView.view.frame.origin.y-120, settingsRect.size.width, 120.0);
        selectTrackRect = CGRectMake(0, 60+1.25, settingsRect.size.width, 60.0);
        settings.frame = settingsRect;
    }
    
    UIView *selectMusic = [self allocateVideoSettingsCellWithRect:selectTrackRect title:@"Select Music"];
    UIButton *selectMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectMusicButton.frame = selectMusic.frame;
    selectMusicButton.center = CGPointMake(selectMusic.center.x-selectMusic.frame.origin.x, selectMusic.center.y-selectMusic.frame.origin.y);
    selectMusicButton.tag = TAG_AUDIO_CELL_SELECT_AUDIO;
    [selectMusicButton addTarget:self action:@selector(checkMediaLibraryPermissions) forControlEvents:UIControlEventTouchUpInside];
    selectMusic.userInteractionEnabled = YES;
    [selectMusic addSubview:selectMusicButton];
    
    UIView *selectSquentialPlayView = [self allocateSquentialPlayButtonCellWithRect:selectSqlRect enable:isSequentialPlay];
    
   // [self allocateviewforEffectsBack];
    
    [settings addSubview:selectSquentialPlayView];
    [settings addSubview:selectMusic];
    
    if (isSequentialPlay) {
        [self addVideoGrid:CGRectMake(0, settings.frame.origin.y, full_screen.size.width, videoGridViewHeight)];
    }
    
    [self reAlignUI];
}

-(void)callRefresh
{
    [self refreshVideoSettingsWithoutAnimation];
    [self callAudioRefresh];
  //  [self releaseResourcesForVideoSetttings];
  //  [self performSelector:@selector(refreshUIAudioCell) withObject:nil afterDelay:1.0];
}

-(void)refreshUIAudioCell
{
    eMode = MODE_VIDEO_SETTINGS;
    [self allocateResourcesForVideoSettings];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSDictionary *)defaultParametersForFilter:(NSString *)filterName {
    if ([filterName isEqualToString:@"CIColorPosterize"]) {
        return @{@"inputLevels": @6.0};
    } else if ([filterName isEqualToString:@"CISepiaTone"]) {
        return @{@"inputIntensity": @1.0};
    } else if ([filterName isEqualToString:@"CIHighlightShadowAdjust"]) {
        return @{
            @"inputHighlightAmount": @0.7,
            @"inputShadowAmount": @0.3
        };
    } else if ([filterName isEqualToString:@"CIColorMonochrome"]) {
        return @{
            @"inputColor": [CIColor colorWithRed:0.8 green:0.2 blue:0.2],
            @"inputIntensity": @1.0
        };
    } else if ([filterName isEqualToString:@"CIFalseColor"]) {
        return @{
            @"inputColor0": [CIColor colorWithRed:0.0 green:0.0 blue:0.0],
            @"inputColor1": [CIColor colorWithRed:1.0 green:0.5 blue:0.0]
        };
    }
    return @{};
}


//-(void)applyFilter:(int)effectNumber
//        photoIndex:(int)photoIndex
//        completion:(void (^)(BOOL success, NSError *error))completion
//{
//    
//    CFTimeInterval startTime = CACurrentMediaTime();
//    Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
//        NSLog(@"content type is %u ",[sess getFrameResourceTypeAtIndex:photoIndex]);
//    
//    if (pht.view.imageView.image != nil)
//    {
//        effectBeingApplied = YES;
//        [self.sheetFilterVC enableDoneButtonWithEnable:NO];
//        [self pauseAllPreviewPlayers];
//        doNotTouch = YES;
//        isTouchWillDetect = NO;
//        UIImage *image = [sess getImageAtIndex:photoIndex];
//        if(effectNumber == 0)
//        {
//            if(FRAME_RESOURCE_TYPE_VIDEO == [sess getFrameResourceTypeAtIndex:photoIndex])
//            {
//                NSLog(@"content type is video");
//                [self addprogressBarWithMsg:@"Applying effect"];
//            }
//            image =  [sess getOriginalImageAtIndex:photoIndex];
//            if(FRAME_RESOURCE_TYPE_VIDEO == [sess getFrameResourceTypeAtIndex:photoIndex])
//            {
//                
//                // NSURL *inputURL = [sess getVideoUrlForPhotoAtIndex:photoIndex];
//                NSString *outputPath = [sess pathToEffectVideoAtIndex:photoIndex];
//                if(YES == [[NSFileManager defaultManager]fileExistsAtPath:outputPath])
//                {
//                    [[NSFileManager defaultManager]removeItemAtPath:outputPath error:nil];
//                }
//                self.currentProgress = 0.0;
//                doNotTouch = NO;
//                NSLog(@"Play all video player 1");
//                [self playAllPreviewPlayers];
//                self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
//                                                                      target:self
//                                                                    selector:@selector(showProgress)
//                                                                    userInfo:nil
//                                                                     repeats:YES];
//                completion(YES, nil);
//            }
//            else
//            {
//                self.currentProgress = 0.0;
//                doNotTouch = NO;
//                [self playAllPreviewPlayers];
//                NSLog(@"Play all video player 2");
//                self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
//                                                                      target:self
//                                                                    selector:@selector(showProgress)
//                                                                    userInfo:nil
//                                                                     repeats:YES];
//                completion(YES, nil);
//            }
//        }
//        else
//        {
//            Effects *effects = [Effects alloc];
//            if ([effects getItemLockStatus:effectNumber-1] && ![[SRSubscriptionModel shareKit]IsAppSubscribed] && effectNumber > 1)
//            {
//                [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"callingFromEffects"];
//                NSLog(@"show subscription from effects page");
//                //[[NSNotificationCenter defaultCenter]postNotificationName:@"FilterDoneInvoked" object:nil];
//                [self ShowSubscriptionView];
//                [self SetOriginalUI];
//                // [self checkmarkButtonTapped];
//            }
//            else
//            {
//                if(FRAME_RESOURCE_TYPE_VIDEO == [sess getFrameResourceTypeAtIndex:photoIndex])
//                {
//                    [pht.view pausePlayer];
//                    NSLog(@"content type is video");
//                    [self addprogressBarWithMsg:@"Applying effect"];
//                }
//                NSString * filterName = [effects getEffectNameForItem:effectNumber - 1 ];
//                NSLog(@"filter name %@ effect number  %d",filterName,effectNumber);
//                image = [effects applyCurrentSelectedCIFilterEffect:[sess getOriginalImageAtIndex:photoIndex] withEffect:effectNumber - 1];
//                if(FRAME_RESOURCE_TYPE_VIDEO == [sess getFrameResourceTypeAtIndex:photoIndex])
//                {
//                    NSURL *inputURL = [sess getVideoUrlForPhotoAtIndex:photoIndex];
//                    NSString *outputPath = [sess pathToEffectVideoAtIndex:photoIndex];
//                    if(YES == [[NSFileManager defaultManager]fileExistsAtPath:outputPath])
//                    {
//                        [[NSFileManager defaultManager]removeItemAtPath:outputPath error:nil];
//                    }
//                    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
//                    CGSize canvasSize = CGSizeMake(sess.frame.frame.size.width * upscaleFactor, sess.frame.frame.size.height * upscaleFactor);
//                    AVAsset *asset = [AVAsset assetWithURL:inputURL];
//                    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//                    CGSize naturalSize = videoTrack.naturalSize;
//                    
//                    AVMutableVideoComposition *videoComposition =
//                    [AVMutableVideoComposition videoCompositionWithAsset:asset
//                                            applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request) {
//                        @autoreleasepool {
//                            CIImage *source = request.sourceImage; //[request.sourceImage imageByClampingToExtent];
//                            CIFilter *filter = [CIFilter filterWithName:filterName];
//                            [filter setValue:source forKey:kCIInputImageKey];
//                            // For CIColorMonochrome specifically
//                            if ([filterName isEqualToString:@"CIColorMonochrome"]) {
//                                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//                                CIColor *monochromeColor = [CIColor colorWithRed:0.8 green:0.2 blue:0.2 colorSpace:colorSpace];
//                                CGColorSpaceRelease(colorSpace);  // Release the color space
//                                [filter setValue:monochromeColor forKey:@"inputColor"];
//                                [filter setValue:@1.0 forKey:@"inputIntensity"];
//                            }
//                            CIImage *output = filter.outputImage ?: source;
//                            [request finishWithImage:[output imageByCroppingToRect:request.sourceImage.extent] context:nil];
//                        }
//                    }];
//                    
//                    // ✅ Set mutable properties only after creating the composition
//                    videoComposition.renderSize = naturalSize;
//                    videoComposition.frameDuration = videoTrack.minFrameDuration; //CMTimeMake(1, 30); // 30 FPS
//                    videoComposition.renderScale = 1.0;
//                    videoComposition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2;
//                    videoComposition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2;
//                    videoComposition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2;
//                    
//                    // Then continue with export...
//                    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
//                    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
//                    exportSession.outputURL = outputURL;
//                    exportSession.videoComposition = videoComposition;
//                    CMTime maxDuration = CMTimeMakeWithSeconds(durationOftheVideo, 600); // 10 seconds
//                    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMinimum(asset.duration, maxDuration));
//                    exportSession.timeRange = timeRange;
//                    
//                    
//                    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull t) {
//                      //  NSLog(@"Export progress: %.2f%%", exportSession.progress * 100);
//                        [self update_Progress:exportSession.progress];
//                    }];
//                    
//                    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [timer invalidate];
//                            timer = nil;
//                            CFTimeInterval duration = CACurrentMediaTime() - startTime;
//                            NSLog(@"Total processing time: %.2f seconds", duration);
//                            [self removeProgressBar];
//                            isTouchWillDetect = YES;
//                            doNotTouch = NO;
//                            [self playAllPreviewPlayers];
//                            effectBeingApplied = NO;
//                            [self.sheetFilterVC enableDoneButtonWithEnable:YES];
//                            if (completion) {
//                                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
//                                    completion(YES, nil);
//                                } else {
//                                    NSLog(@"exportSession failed to export video : %@",exportSession.error.localizedDescription);
//                                    completion(NO, exportSession.error);
//                                }
//                            }
//                        });
//                    }];
//                }
//                else
//                {
//                    isTouchWillDetect = YES;
//                    self.currentProgress = 0.0;
//                    doNotTouch = NO;
//                    NSLog(@"Play all video player 4");
//                    [self playAllPreviewPlayers];
//                    effectBeingApplied = NO;
//                    [self.sheetFilterVC enableDoneButtonWithEnable:YES];
//                    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
//                                                                          target:self
//                                                                        selector:@selector(showProgress)
//                                                                        userInfo:nil
//                                                                         repeats:YES];
//                    completion(YES, nil);
//                }
//            }
//        }
//
//        pht.view.imageView.image = image;
//        /*replace image with old image and save it*/
//        [sess saveImage:image atIndex:photoIndex];
//    }
//    else
//    {
//        [WCAlertView showAlertWithTitle:@"Oops.." message:@"Please select image before applying effect" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    }
//}

// When starting processing:
- (void)startEffectProcessing {
    self.isEffectProcessing = YES;
    self.sheetFilterVC.view.userInteractionEnabled = NO;
    //self.sheetFilterVC.view.alpha = 0.7;
    [self.sheetFilterVC enableDoneButtonWithEnable:NO];
}

// When finishing processing:
- (void)finishEffectProcessing {
    self.isEffectProcessing = NO;
    effectBeingApplied = NO;
    if(self.sheetFilterVC != nil)
    {
        self.sheetFilterVC.view.userInteractionEnabled = YES;
       // self.sheetFilterVC.view.alpha = 1.0;
        [self.sheetFilterVC enableDoneButtonWithEnable:YES];
    }
}

- (void)applyFilter:(int)effectNumber
        photoIndex:(int)photoIndex
        completion:(void (^)(BOOL success, NSError *error))completion
{
    if(!self.isEffectProcessing)
    {
        // Set processing flag
        [self startEffectProcessing];
       
        // Validate inputs
        if (!completion) {
            NSLog(@"Error: Completion block is nil");
            [self finishEffectProcessing];
            return;
        }
        
        if (photoIndex < 0 || photoIndex >= sess.frame.photoCount) {
            NSError *error = [NSError errorWithDomain:@"com.yourdomain.error"
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey: @"Invalid photo index"}];
            completion(NO, error);
            return;
        }
        
        CFTimeInterval startTime = CACurrentMediaTime();
        Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
        NSLog(@"content type is %u", [sess getFrameResourceTypeAtIndex:photoIndex]);
        
        // Early return if no image
        if (!pht.view.imageView.image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WCAlertView showAlertWithTitle:@"Oops.."
                                        message:@"Please select image before applying effect"
                             customizationBlock:nil
                                completionBlock:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
                [self finishEffectProcessing];
            });
            return;
        }
        
        // Setup UI state
        effectBeingApplied = YES;
        [self.sheetFilterVC enableDoneButtonWithEnable:NO];
        [self pauseAllPreviewPlayers];
        doNotTouch = YES;
        isTouchWillDetect = NO;
        
        // Handle "no effect" case (effectNumber == 0)
        if (effectNumber == 0) {
            NSLog(@"apply effect zero");
            [self handleNoEffectCaseForPhotoIndex:photoIndex completion:completion];
            return;
        }
        
        // Handle locked effects
        if ([self isEffectLocked:effectNumber]) {
            [self handleLockedEffect];
            return;
        }
        
        // Apply filter to image or video
        [self applyFilterToMedia:effectNumber photoIndex:photoIndex photo:pht completion:completion startTime:startTime];
    }
}

#pragma mark - Helper Methods

- (BOOL)isEffectLocked:(int)effectNumber {
    Effects *effects = [[Effects alloc] init];
    return ([effects getItemLockStatus:effectNumber-1] &&
           ![[SRSubscriptionModel shareKit] IsAppSubscribed] &&
           effectNumber > 1);
}

- (void)handleLockedEffect {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"callingFromEffects"];
    NSLog(@"show subscription from effects page");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ShowSubscriptionView];
        [self finishEffectProcessing];
        [self SetOriginalUI];
    });
}

- (void)handleNoEffectCaseForPhotoIndex:(int)photoIndex completion:(void (^)(BOOL, NSError *))completion {
    if (FRAME_RESOURCE_TYPE_VIDEO == [sess getFrameResourceTypeAtIndex:photoIndex]) {
        NSLog(@"content type is video");
        [self addprogressBarWithMsg:@"Applying effect"];
        
        NSString *outputPath = [sess pathToEffectVideoAtIndex:photoIndex];
        [self removeFileIfExistsAtPath:outputPath];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentProgress = 0.0;
        doNotTouch = NO;
        NSLog(@"Play all video player 1");
        [self playAllPreviewPlayers];
        
        [self.progressTimer invalidate];
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                             target:self
                                                           selector:@selector(showProgress)
                                                           userInfo:nil
                                                            repeats:YES];
        [self finishEffectProcessing];
        completion(YES, nil);
    });
}

- (void)removeFileIfExistsAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        if (![fileManager removeItemAtPath:path error:&error]) {
            NSLog(@"Failed to remove file at path %@: %@", path, error.localizedDescription);
        }
    }
}

- (void)applyFilterToMedia:(int)effectNumber
                photoIndex:(int)photoIndex
                     photo:(Photo *)pht
               completion:(void (^)(BOOL, NSError *))completion
                startTime:(CFTimeInterval)startTime
{
    Effects *effects = [[Effects alloc] init];
    NSString *filterName = [effects getEffectNameForItem:effectNumber - 1];
    NSLog(@"filter name %@ effect number %d", filterName, effectNumber);
    
    if (FRAME_RESOURCE_TYPE_VIDEO == [sess getFrameResourceTypeAtIndex:photoIndex]) {
        [self applyFilterToVideo:effectNumber
                      photoIndex:photoIndex
                       filterName:filterName
                       startTime:startTime
                      completion:completion];
    } else {
        [self applyFilterToImage:effectNumber
                          photo:pht
                      photoIndex:photoIndex
                     filterName:filterName
                     completion:completion];
    }
}

- (void)applyFilterToImage:(int)effectNumber
                    photo:(Photo *)photo
                photoIndex:(int)photoIndex
               filterName:(NSString *)filterName
               completion:(void (^)(BOOL, NSError *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Effects *effects = [[Effects alloc] init];
        UIImage *originalImage = [sess getOriginalImageAtIndex:photoIndex];
        UIImage *filteredImage = [effects applyCurrentSelectedCIFilterEffect:originalImage withEffect:effectNumber - 1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            photo.view.imageView.image = filteredImage;
            [sess saveImage:filteredImage atIndex:photoIndex];
            
            isTouchWillDetect = YES;
            self.currentProgress = 0.0;
            doNotTouch = NO;
            NSLog(@"Play all video player 4");
            [self playAllPreviewPlayers];
            effectBeingApplied = NO;
            [self.sheetFilterVC enableDoneButtonWithEnable:YES];
            
            [self.progressTimer invalidate];
            self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                                 target:self
                                                               selector:@selector(showProgress)
                                                               userInfo:nil
                                                                repeats:YES];
            [self finishEffectProcessing];
            completion(YES, nil);
        });
    });
}

- (void)applyFilterToVideo:(int)effectNumber
                photoIndex:(int)photoIndex
                 filterName:(NSString *)filterName
                 startTime:(CFTimeInterval)startTime
                completion:(void (^)(BOOL, NSError *))completion
{
    Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
    [pht.view pausePlayer];
    NSLog(@"content type is video");
    [self addprogressBarWithMsg:@"Applying effect"];
    
    NSURL *inputURL = [sess getVideoUrlForPhotoAtIndex:photoIndex];
    NSString *outputPath = [sess pathToEffectVideoAtIndex:photoIndex];
    [self removeFileIfExistsAtPath:outputPath];
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    Effects *effects = [[Effects alloc] init];
    UIImage *originalImage = [sess getOriginalImageAtIndex:photoIndex];
    UIImage *filteredImage = [effects applyCurrentSelectedCIFilterEffect:originalImage withEffect:effectNumber - 1];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        pht.view.imageView.image = filteredImage;
        [sess saveImage:filteredImage atIndex:photoIndex];
    });
    AVAsset *asset = [AVAsset assetWithURL:inputURL];
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    if (!videoTrack) {
        NSError *error = [NSError errorWithDomain:@"com.yourdomain.error"
                                             code:-2
                                         userInfo:@{NSLocalizedDescriptionKey: @"No video track found"}];
        [self finishEffectProcessing];
        completion(NO, error);
        return;
    }
    
    CGSize naturalSize = videoTrack.naturalSize;
    AVMutableVideoComposition *videoComposition =
        [AVMutableVideoComposition videoCompositionWithAsset:asset
                                applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request) {
        @autoreleasepool {
            CIImage *source = request.sourceImage;
            CIFilter *filter = [CIFilter filterWithName:filterName];
            [filter setValue:source forKey:kCIInputImageKey];
            
            if ([filterName isEqualToString:@"CIColorMonochrome"]) {
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CIColor *monochromeColor = [CIColor colorWithRed:0.8 green:0.2 blue:0.2 colorSpace:colorSpace];
                CGColorSpaceRelease(colorSpace);
                [filter setValue:monochromeColor forKey:@"inputColor"];
                [filter setValue:@1.0 forKey:@"inputIntensity"];
            }
            
            CIImage *output = filter.outputImage ?: source;
            [request finishWithImage:[output imageByCroppingToRect:request.sourceImage.extent] context:nil];
        }
    }];
    
    videoComposition.renderSize = naturalSize;
    videoComposition.frameDuration = videoTrack.minFrameDuration;
    videoComposition.renderScale = 1.0;
    videoComposition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2;
    videoComposition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2;
    videoComposition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2;
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                          presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.outputURL = outputURL;
    exportSession.videoComposition = videoComposition;
    
    CMTime maxDuration = CMTimeMakeWithSeconds(durationOftheVideo, 600);
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMinimum(asset.duration, maxDuration));
    exportSession.timeRange = timeRange;
    
    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                             repeats:YES
                                                               block:^(NSTimer * _Nonnull t) {
        [self update_Progress:exportSession.progress];
    }];
    
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [timer invalidate];
            timer = nil;
            
            CFTimeInterval duration = CACurrentMediaTime() - startTime;
            NSLog(@"Total processing time: %.2f seconds", duration);
            
            [self removeProgressBar];
            isTouchWillDetect = YES;
            doNotTouch = NO;
            [self playAllPreviewPlayers];
            effectBeingApplied = NO;
            [self.sheetFilterVC enableDoneButtonWithEnable:YES];
            
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                [self finishEffectProcessing];
                completion(YES, nil);
            } else {
                NSLog(@"exportSession failed to export video: %@", exportSession.error.localizedDescription);
                [self finishEffectProcessing];
                completion(NO, exportSession.error);
            }
        });
    }];
}

NSDictionary *default_ParamsForFilter(NSString *filterName) {
    if ([filterName isEqualToString:@"CIColorPosterize"]) {
        return @{@"inputLevels": @6.0};
    } else if ([filterName isEqualToString:@"CISepiaTone"]) {
        return @{@"inputIntensity": @1.0};
    } else if ([filterName isEqualToString:@"CIHighlightShadowAdjust"]) {
        return @{
            @"inputHighlightAmount": @0.7,
            @"inputShadowAmount": @0.3
        };
    } else if ([filterName isEqualToString:@"CIColorMonochrome"]) {
        return @{
            @"inputColor": [CIColor colorWithRed:0.8 green:0.2 blue:0.2],
            @"inputIntensity": @1.0
        };
    } else if ([filterName isEqualToString:@"CIFalseColor"]) {
        return @{
            @"inputColor0": [CIColor colorWithRed:0.0 green:0.0 blue:0.0],
            @"inputColor1": [CIColor colorWithRed:1.0 green:0.5 blue:0.0]
        };
    }
    return @{};
}

//- (void)applyFilterWithMaxQuality:(int)effectNumber
//                       photoIndex:(int)photoIndex
//                       completion:(void (^)(BOOL success, NSError *error))completion
//{
//    CFTimeInterval startTime = CACurrentMediaTime();
//    Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
//    [self addprogressBarWithMsg:@"Applying effect"];
//    Effects *effects = [Effects alloc];
//    NSString * filterName = [effects getEffectNameForItem:effectNumber - 1 ];
//    NSURL *inputURL = [sess getVideoUrlForPhotoAtIndex:photoIndex];
//    NSString *outputPath = [sess pathToEffectVideoAtIndex:photoIndex];
//    if(YES == [[NSFileManager defaultManager]fileExistsAtPath:outputPath])
//    {
//        [[NSFileManager defaultManager]removeItemAtPath:outputPath error:nil];
//    }
//    UIImage *image = [sess getImageAtIndex:photoIndex];
//    image = [effects applyCurrentSelectedCIFilterEffect:[sess getOriginalImageAtIndex:photoIndex] withEffect:effectNumber - 1];
//    
//    // Clean up existing file
//    [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
//    
//    // Create Metal-accelerated context
//    id<MTLDevice> metalDevice = MTLCreateSystemDefaultDevice();
//    CIContext *ciContext = [CIContext contextWithMTLDevice:metalDevice options:@{
//        kCIContextWorkingFormat: @(kCIFormatRGBAh),
//        kCIContextHighQualityDownsample: @YES
//    }];
//    
//    AVAsset *asset = [AVAsset assetWithURL:inputURL];
//    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//    
//    // Create optimized video composition
//    AVMutableVideoComposition *videoComposition =
//    [AVMutableVideoComposition videoCompositionWithAsset:asset
//                            applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request) {
//        @autoreleasepool {
//            CIImage *source = request.sourceImage;
//            CIFilter *filter = [CIFilter filterWithName:filterName];
//            [filter setValue:source forKey:kCIInputImageKey];
//            
//            NSDictionary *defaults = default_ParamsForFilter(filterName);
//            for (NSString *key in defaults) {
//                [filter setValue:defaults[key] forKey:key];
//            }
//            
//            CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
//            [request finishWithImage:output context:ciContext];
//        }
//    }];
//    
//    videoComposition.renderSize = videoTrack.naturalSize;
//    videoComposition.frameDuration = videoTrack.minFrameDuration;
//    
//    // Configure high-quality export
//    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
//                                           initWithAsset:asset
//                                           presetName:AVAssetExportPresetHighestQuality];
//    
//    exportSession.outputFileType =  AVFileTypeQuickTimeMovie;
//    exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
//    exportSession.videoComposition = videoComposition;
//    exportSession.shouldOptimizeForNetworkUse = NO;
//    exportSession.canPerformMultiplePassesOverSourceMediaData = YES;
//    
//    // Progress monitoring
//    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer *t) {
//        [self update_Progress:exportSession.progress];
//    }];
//    
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//        [timer invalidate];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            CFTimeInterval duration = CACurrentMediaTime() - startTime;
//            NSLog(@"Total processing time: %.2f seconds", duration);
//            
//            [self removeProgressBar];
//            if (completion) {
//                pht.view.imageView.image = image;
//                /*replace image with old image and save it*/
//                [sess saveImage:image atIndex:photoIndex];
//                completion(exportSession.status == AVAssetExportSessionStatusCompleted, exportSession.error);
//            }
//        });
//    }];
//}

- (void)showProgress {
    self.currentProgress += 0.05;
    if (self.currentProgress >= 1.0) {
        self.currentProgress = 1.0;
        [self.progressTimer invalidate];
        self.progressTimer = nil;
        [self removeProgressBar];
    }
    [self update_Progress:self.currentProgress];
}

- (void)applyGPUFilterToVideoCompletion:(void (^)(BOOL success, NSError *error))completion {
    effectBeingApplied = YES;
    [self.sheetFilterVC enableDoneButtonWithEnable:NO];
    [self addprogressBarWithMsg:@"Applying effects"];
    Effects *effects = [Effects alloc];
    for (int photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
    {
        NSURL *inputURL = [sess getVideoUrlForPhotoAtIndex:photoIndex];
        NSURL *outputURL = [NSURL fileURLWithPath:[sess pathToEffectVideoAtIndex:photoIndex]];
        NSNumber *effectNo = [dictionaryOfEffectInfo objectForKey:[NSNumber numberWithInt:photoIndex]];
        NSString *filterName = @"CISepiaTone";// [effects getNameOfEffect:[effectNo intValue]];
        AVAsset *asset = [AVAsset assetWithURL:inputURL];
        AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        if (!videoTrack) {
            if (completion) completion(NO, [NSError errorWithDomain:@"Filter" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"No video track"}]);
            return;
        }
        
        AVVideoComposition *videoComposition = [AVVideoComposition videoCompositionWithAsset:asset
                                                                applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request) {
            @autoreleasepool {
                CIImage *source = request.sourceImage;
                
                CIFilter *filter = [CIFilter filterWithName:filterName];
                [filter setValue:source forKey:kCIInputImageKey];
                
                CIImage *filtered = filter.outputImage ?: source;
                [request finishWithImage:filtered context:nil];
            }
        }];
        
        // Export
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                               presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        exportSession.videoComposition = videoComposition;
        CMTime maxDuration = CMTimeMakeWithSeconds(durationOftheVideo, 600); // 10 seconds
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMinimum(asset.duration, maxDuration));
        exportSession.timeRange = timeRange;
        // Delete old file if it exists
        [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
        
        __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull t) {
          //  NSLog(@"Export progress: %.2f%%", exportSession.progress * 100);
            [self update_Progress:exportSession.progress];
        }];
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [timer invalidate];
                    timer = nil;
                    [self removeProgressBar];
                    effectBeingApplied = NO;
                    [self.sheetFilterVC enableDoneButtonWithEnable:YES];
                    completion(exportSession.status == AVAssetExportSessionStatusCompleted, exportSession.error);
                });
            }
        }];
    }
}
- (eGroupStaticFilter)getGroupIdForItem:(int)itemNo{
    eGroupStaticFilter groupId=  0;
    if (itemNo<=10)
    {
        groupId = GROUP_STATIC_GPU_FILTER_COLOR;
        
    }else if(itemNo>11)
    {
        groupId = GROUP_STATIC_GPU_FILTER_TONE;
        
    }
    return groupId;
}
- (GPUImageToneCurveFilter *)toneCurveFilterForType:(int)filterType {
    GPUImageToneCurveFilter *toneFilter = nil;
    
    switch (filterType) {
        case STATIC_GPU_FILTER_TONE_EFFECT1:
            toneFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow"];
            break;
            
        case STATIC_GPU_FILTER_TONE_EFFECT2:
            toneFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"zeebra"];
            break;
            
        case STATIC_GPU_FILTER_TONE_EFFECT3:
            toneFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"green"];
            break;
            
        case STATIC_GPU_FILTER_TONE_EFFECT4:
            toneFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
            break;
            
        case STATIC_GPU_FILTER_TONE_EFFECT5:
            toneFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"arrow"];
            break;
            
        case STATIC_GPU_FILTER_TONE_EFFECT6:
            toneFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"berry"];
            break;
            
        case STATIC_GPU_FILTER_TONE_EFFECT7:
            toneFilter = [[GPUImageToneCurveFilter alloc] initWithACV:@"mixed"];
            break;
            
        default:
            break;
    }
    
    return toneFilter;
}
- (GPUImageOutput<GPUImageInput> *)filterChainForFilterType:(int)filterType {
    GPUImageOutput<GPUImageInput> *finalFilter = nil;
    
    switch (filterType) {
        case STATIC_GPU_FILTER_COLOR_EFFECT1: {
            NSLog(@"STATIC_GPU_FILTER_COLOR_EFFECT 1 ");
            finalFilter = [[GPUImageAmatorkaFilter alloc] init];
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT2: {
            NSLog(@"STATIC_GPU_FILTER_COLOR_EFFECT 2 ");
            //            GPUImageAmatorkaFilter *amatorka = [[GPUImageAmatorkaFilter alloc] init];
            //
            UIImage *blendImg = [UIImage imageNamed:@"Jeans_0.jpeg"];
            NSLog(@"blendImg w %f  h %f",blendImg.size.width,blendImg.size.height);
            //                if (!blendImg || blendImg.size.width == 0 || blendImg.size.height == 0) {
            //                    NSLog(@"❌ ERROR: Jeans_0.jpeg not found or empty!");
            //                    return amatorka; // fail-safe
            //                }
            //            GPUImagePicture *texture = [[GPUImagePicture alloc] initWithImage:blendImg];
            //            GPUImageAlphaBlendFilter *blend = [[GPUImageAlphaBlendFilter alloc] init];
            //            blend.mix = 1.0;
            //
            //            GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
            //            [amatorka addTarget:blend];
            //            [texture addTarget:blend];
            //
            //            [group addTarget:amatorka];
            //            [group addTarget:blend];
            //            group.initialFilters = @[amatorka, texture];
            //            group.terminalFilter = blend;
            //            finalFilter = group;
            GPUImageAlphaBlendFilter *finalFilter = [[GPUImageAlphaBlendFilter alloc] init];
            finalFilter.mix = 1.0;
            
            GPUImagePicture *imageInput = [[GPUImagePicture alloc] initWithImage:blendImg];
            [imageInput addTarget:finalFilter];
            [imageInput processImage]; // Make sure the image is pushed to the pipeline
            
            
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT3: {
            NSLog(@"STATIC_GPU_FILTER_COLOR_EFFECT 3 ");
            GPUImageAmatorkaFilter *amatorka = [[GPUImageAmatorkaFilter alloc] init];
            GPUImagePicture *texture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"Pencil_0.jpeg"]];
            GPUImageAlphaBlendFilter *blend = [[GPUImageAlphaBlendFilter alloc] init];
            blend.mix = 1.0;
            
            GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
            [amatorka addTarget:blend];
            [texture addTarget:blend];
            
            [group addTarget:amatorka];
            [group addTarget:blend];
            group.initialFilters = @[amatorka, texture];
            group.terminalFilter = blend;
            finalFilter = group;
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT4: {
            NSLog(@"STATIC_GPU_FILTER_COLOR_EFFECT 4 ");
            GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
            contrast.contrast = 3.5;
            
            GPUImageToneCurveFilter *curve = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickblue"];
            GPUImageVignetteFilter *vignette = [[GPUImageVignetteFilter alloc] init];
            
            [contrast addTarget:curve];
            [curve addTarget:vignette];
            
            GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
            [group addTarget:contrast];
            [group addTarget:curve];
            [group addTarget:vignette];
            
            group.initialFilters = @[contrast];
            group.terminalFilter = vignette;
            
            finalFilter = group;
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT5: {
            NSLog(@"STATIC_GPU_FILTER_COLOR_EFFECT 5 ");
            finalFilter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT6: {
            NSLog(@"STATIC_GPU_FILTER_COLOR_EFFECT 6 ");
            GPUImageGrayscaleFilter *gray = [[GPUImageGrayscaleFilter alloc] init];
            GPUImageAmatorkaFilter *amatorka = [[GPUImageAmatorkaFilter alloc] init];
            GPUImageVignetteFilter *vignette = [[GPUImageVignetteFilter alloc] init];
            
            [gray addTarget:amatorka];
            [amatorka addTarget:vignette];
            
            GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
            [group addTarget:gray];
            [group addTarget:amatorka];
            [group addTarget:vignette];
            
            group.initialFilters = @[gray];
            group.terminalFilter = vignette;
            
            finalFilter = group;
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT7: {
            GPUImageGaussianBlurFilter *blur = [[GPUImageGaussianBlurFilter alloc] init];
            [blur setBlurRadiusInPixels:3.0];
            
            finalFilter = blur;
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT8: {
            finalFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT9: {
            GPUImageSepiaFilter *sepia = [[GPUImageSepiaFilter alloc] init];
            GPUImagePicture *grunge = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"grunge22_0.jpg"]];
            GPUImageAlphaBlendFilter *blend = [[GPUImageAlphaBlendFilter alloc] init];
            blend.mix = 0.6;
            
            GPUImageVignetteFilter *vignette = [[GPUImageVignetteFilter alloc] init];
            
            [sepia addTarget:blend];
            [grunge addTarget:blend];
            [blend addTarget:vignette];
            
            GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
            [group addTarget:sepia];
            [group addTarget:grunge];
            [group addTarget:blend];
            [group addTarget:vignette];
            
            group.initialFilters = @[sepia, grunge];
            group.terminalFilter = vignette;
            
            finalFilter = group;
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT10: {
            GPUImageToneCurveFilter *curve = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
            GPUImageVignetteFilter *vignette = [[GPUImageVignetteFilter alloc] init];
            
            [curve addTarget:vignette];
            
            GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
            [group addTarget:curve];
            [group addTarget:vignette];
            
            group.initialFilters = @[curve];
            group.terminalFilter = vignette;
            
            finalFilter = group;
            break;
        }
            
        case STATIC_GPU_FILTER_COLOR_EFFECT11: {
            finalFilter = [[GPUImageMissEtikateFilter alloc] init];
            break;
        }
            
            //        case STATIC_GPU_FILTER_COLOR_EFFECT12: {
            //            UIImage *lookupImage = [UIImage imageNamed:@"lookup_splittonecolor.png"];
            //            GPUImagePicture *lookup = [[GPUImagePicture alloc] initWithImage:lookupImage];
            //            GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
            //
            //            [lookup addTarget:lookupFilter];
            //            [lookup processImage];
            //
            //            finalFilter = lookupFilter;
            //            break;
            //        }
            //
            //        case STATIC_GPU_FILTER_COLOR_EFFECT13: {
            //            UIImage *lookupImage = [UIImage imageNamed:@"lookup_skyblue.png"];
            //            GPUImagePicture *lookup = [[GPUImagePicture alloc] initWithImage:lookupImage];
            //            GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
            //            [lookup addTarget:lookupFilter];
            //            [lookup processImage];
            //
            //            GPUImageToneCurveFilter *curve = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickmint"];
            //
            //            [lookupFilter addTarget:curve];
            //
            //            GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
            //            [group addTarget:lookupFilter];
            //            [group addTarget:curve];
            //
            //            group.initialFilters = @[lookupFilter];
            //            group.terminalFilter = curve;
            //
            //            finalFilter = group;
            //            break;
            //        }
            
        default:
            break;
    }
    
    return finalFilter;
}


- (void)applyGPUColorFilter:(int)filterType
                 photoIndex:(int)photoIndex
                 completion:(void (^)(BOOL success, NSError *error))completion {
    
    [self addprogressBarWithMsg:@"Applying effect"];
    NSURL *inputURL = [sess getVideoUrlForPhotoAtIndex:photoIndex];
    NSString *outputPath = [sess pathToEffectVideoAtIndex:photoIndex];
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    CGSize canvasSize = CGSizeMake(sess.frame.frame.size.width * upscaleFactor, sess.frame.frame.size.height * upscaleFactor);
    AVAsset *asset = [AVAsset assetWithURL:inputURL];
    GPUImageMovie *movie = [[GPUImageMovie alloc] initWithAsset:asset];
    movie.playAtActualSpeed = NO;
    
    eGroupStaticFilter groupId=  [self getGroupIdForItem:filterType];
    int itemNumber =0;
    itemNumber = filterType;
    if (filterType>10)
    {
        itemNumber = filterType-11;
    }
    NSLog(@"effect number is %d",itemNumber);
    unlink([outputURL.path UTF8String]); // delete old file
    
    GPUImageMovieWriter *writer = [[GPUImageMovieWriter alloc] initWithMovieURL:outputURL size:canvasSize];
    
    GPUImageToneCurveFilter *toneFilter;
    GPUImageOutput<GPUImageInput> *colorFilter;
    
    if(groupId == GROUP_STATIC_GPU_FILTER_TONE)
    {
        toneFilter = [self toneCurveFilterForType:itemNumber];
        [movie addTarget:toneFilter];
        [toneFilter addTarget:writer];
    }
    else
    {
        NSLog(@"color filter called");
        colorFilter = [self filterChainForFilterType:itemNumber];
        [movie addTarget:colorFilter];
        [colorFilter addTarget:writer];
    }
    
    movie.audioEncodingTarget = writer;
    writer.shouldPassthroughAudio = YES;
    
    [writer startRecording];
    [movie startProcessing];
    
    [self update_Progress:movie.progress];
    
    [writer setCompletionBlock:^{
        if(groupId == GROUP_STATIC_GPU_FILTER_TONE)
        {
            [toneFilter removeTarget:writer];
        }
        else
        {
            [colorFilter removeTarget:writer];
        }
        [writer finishRecording];
        [self removeProgressBar];
        NSLog(@"✅ Video export completed for filter %d", filterType);
        if (completion) completion(YES, nil);
    }];
    
    [writer setFailureBlock:^(NSError *error) {
        NSLog(@"❌ Video export failed: %@", error);
        if (completion) completion(NO, error);
    }];
}



-(void)movingToHomePage
{
    [self resetToEditingMode];
    [self removeAllPreviewPlayers];
    [Appirater userDidSignificantEvent:YES];
    nvm.noAdMode = NO;
    
    // ---------------------- changes made in VC 3.6 - 1.8 ----------------------
    frameIsEdited = YES;
    effectBeingApplied = NO;
    dontShowOptionsUntilOldAssetsSaved = NO;
    [self doneBtnTapped];
    [self releaseResourcesForModeChange];
    [self assignRightBarButtonItem];
    eMode = 0;
    [self releaseResourcesForFrames];
    [self allocateResourcesForFrames]; //sc
    [self resetFrameView];
    NSLog(@"moving to home page");
    effectsApplied = NO;
  //  [self SetOriginalImageForAllFrames]; // changes made in VC 3.5 - 4.7
    [self removeAllTextviewsFromParent];
    [self removeAllStickerviewsFromParent];
    [self removeAllEffectVideos]; // It removes all effects video if present when switching to frames view
    [sess initAspectRatio:ASPECTRATIO_1_1];
    //-----------------------------------------------------------------------------
    [self.navigationController popToRootViewControllerAnimated:YES];
}



-(void)showSaveorShareView
{
    [sess enterNoTouchMode];
    changeTitle = YES;
    optionsView.view.hidden = YES;
    backView.hidden = YES;
    CGFloat PlayButton_width = 50;
    [self pauseAllPreviewPlayers];
    if([sess anyVideoFrameSelected])
    {
        previewPlayButton = [UIButton buttonWithType:UIButtonTypeSystem];
        previewPlayButton.frame = CGRectMake(mainBackground.frame.size.width/2-PlayButton_width/2, mainBackground.frame.size.height/2-PlayButton_width/2, PlayButton_width, PlayButton_width);
        [previewPlayButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [previewPlayButton addTarget:self action:@selector(playOrPausePreview) forControlEvents:UIControlEventTouchUpInside];
        previewPlayButton.center = CGPointMake(mainBackground.frame.size.width/2, mainBackground.frame.size.height/2);
        previewPlayButton.tintColor = [UIColor whiteColor];
        [mainBackground addSubview:previewPlayButton];
    }
    [self assignRightBarButtonItem];
    [self animateBackgroundToTop];
    dispatch_async(dispatch_get_main_queue(), ^{
           [self showTopButtonContainer];
    });
}


- (void)hideTopButtonContainer {
    // Animate the hide for better UX
    [UIView animateWithDuration:0.3 animations:^{
        self->topButtonContainer.alpha = 0.0;
    } completion:^(BOOL finished) {
        self->topButtonContainer.hidden = YES;
        // Keep constraints active but view hidden
    }];
}

- (void)showTopButtonContainer {
    // Ensure view is in hierarchy
    if (![topButtonContainer isDescendantOfView:self.view]) {
        [self.view addSubview:topButtonContainer];
    }
    
    // Reactivate constraints if needed
    [self setupTopButtonConstraints];
    
    // Prepare for animation
    topButtonContainer.alpha = 0.0;
    topButtonContainer.hidden = NO;
    
    // Animate the show
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded]; // Ensure layout is updated
        self->topButtonContainer.alpha = 1.0;
    }];
}

// Animation method
- (void)animateBackgroundToTop {
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height +
    [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // 1. Define scale factors (e.g., 70% width, 50% height)
    CGFloat widthScale = 0.6f;
    CGFloat heightScale = 0.6f;
    
    // 2. Calculate the new position (adjust offsets as needed)
    CGFloat centerXOffset = 0.0f;  // 0 = centered, positive = move right
    CGFloat centerYOffset;
    if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        centerYOffset =  -240;
    else if(fullScreen.size.height == 568.0)
        centerYOffset =  -120.0f;
    else centerYOffset = -160.0f;
    float oldCenterYOffset = centerYOffset;
    
    if ([[SRSubscriptionModel shareKit] IsAppSubscribed]) {
        centerYOffset = centerYOffset * 0.8;
    }else{
        centerYOffset = oldCenterYOffset;
    }
    
    // 3. Apply transform (scale + translation)
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(widthScale, heightScale);
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(
                                                                            centerXOffset,
                                                                            centerYOffset - (navBarHeight * (1 - heightScale) / 2) // Adjust for scaling origin
                                                                            );
    CGAffineTransform combinedTransform = CGAffineTransformConcat(scaleTransform, translateTransform);
    
    // 4. Animate
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        mainBackground.transform = combinedTransform;
        mainBackground.layer.cornerRadius = 12;
        mainBackground.layer.masksToBounds = YES;
    } completion:nil];
}



- (void)shareButtonTapped:(UIButton *)sender {
    NSString *appName = sender.titleLabel.text;
    NSURL *videoURL = [NSURL URLWithString:@"https://example.com/video.mp4"]; // Replace with your video URL
    
    if ([appName isEqualToString:@"Instagram"]) {
        [self shareToInstagram:videoURL];
    }
    else if ([appName isEqualToString:@"Facebook"]) {
        [self shareToFacebook:videoURL];
    }
    else if ([appName isEqualToString:@"Messenger"]) {
        [self shareToMessenger:videoURL];
    }
    else if ([appName isEqualToString:@"WhatsApp"]) {
        [self shareToWhatsApp:videoURL];
    }
    else if ([appName isEqualToString:@"iMessage"]) {
        [self shareToiMessage:videoURL];
    }
}

#pragma mark - Sharing Methods

- (void)shareToInstagram:(NSURL *)videoURL {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        // Instagram doesn't support direct video sharing via URL scheme
        // You'll need to use UIDocumentInteractionController or the Instagram API
        //[self showAlert:@"Please download the video and share through Instagram directly"];
//        nvm.uploadCommand = UPLOAD_INSTAGRAM;
//        [self uploadVideo];
        UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:self.videoURL];
            interactionController.UTI = @"com.instagram.exclusivegram"; // .jpg only
            [interactionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];

    } else {
        [self showAlert:@"Instagram is not installed"];
    }
}

- (void)shareImageToInstagram:(UIImage *)image {
    // Save image to documents directory
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagramShare.ig"];
    [imageData writeToFile:filePath atomically:YES];
    
    // Create document interaction controller
    UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentController.UTI = @"com.instagram.exclusivegram";
    documentController.delegate = self;
    
    // Present the share sheet
    [documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (void)shareVideoToInstagram:(NSURL *)videoURL {
    // Verify the video is in the correct format (MP4)
//    if (![videoURL.pathExtension isEqualToString:@"mp4"]) {
//        NSLog(@"Video must be in MP4 format");
//        return;
//    }
    
    // Copy to documents directory with Instagram-compatible name
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagramShare.mp4"];
    [[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:[NSURL fileURLWithPath:tempPath] error:nil];
    
    // Create document interaction controller
    UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:tempPath]];
    documentController.UTI = @"com.instagram.exclusivegram";
    documentController.delegate = self;
    
    // Present the share sheet
    [documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (void)shareVideoUsingURLScheme:(NSURL *)videoURL {
    // Verify the video exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:videoURL.path]) {
        NSLog(@"Video file not found");
        return;
    }
    
//    // Verify it's an MP4 file (Facebook's preferred format)
//    if (![videoURL.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
//        NSLog(@"Video must be in MP4 format");
//        return;
//    }
    
    // Copy to temporary directory with Facebook-friendly name
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"fb_video.mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
    [[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:[NSURL fileURLWithPath:tempPath] error:nil];
    
    // Create Facebook URL
    NSString *urlString = [NSString stringWithFormat:@"fb://publish/?video=%@", tempPath];
    NSURL *fbURL = [NSURL URLWithString:urlString];
    
    // Try to open Facebook app
    if ([[UIApplication sharedApplication] canOpenURL:fbURL]) {
        [[UIApplication sharedApplication] openURL:fbURL options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                [self showAlert:@"Facebook is not installed"];
            }
        }];
    } else {
        [self showAlert:@"Facebook is not installed"];
    }
}

- (void)shareToFacebook:(NSURL *)videoURL {
//    NSURL *facebookURL = [NSURL URLWithString:@"fb://"];
//    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
//        // Facebook app sharing requires more complex implementation
//        // Consider using FBSDKShareKit for proper sharing
//        //[self showAlert:@"Please use the Facebook SDK for proper sharing"];
//        [self shareVideoUsingURLScheme:videoURL];
//    } else {
//        [self showAlert:@"Facebook is not installed"];
//    }
}

- (void)shareToMessenger:(NSURL *)videoURL {
    NSURL *messengerURL = [NSURL URLWithString:@"fb-messenger://"];
    if ([[UIApplication sharedApplication] canOpenURL:messengerURL]) {
        NSString *shareURL = [NSString stringWithFormat:@"fb-messenger://share?link=%@", videoURL.absoluteString];
        NSURL *url = [NSURL URLWithString:shareURL];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [self showAlert:@"Messenger is not installed"];
    }
}

//- (void)shareToWhatsApp:(NSURL *)videoURL {
//    NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=Check out this video!"];
//    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]) {
//        // To share a video:
//        if(isVideoFile)
//        {
//            [[WhatsAppShareManager sharedManager] shareVideoToWhatsApp:self.videoURL
//                                                    fromViewController:self];
//        }
//        else
//        {
//            [[WhatsAppShareManager sharedManager] shareImageToWhatsApp:outputImage fromViewController:self];
//        }
//    }else
//    {
//      [self showAlert:@"WhatsApp is not installed"];
//    }
//}

- (void)shareToWhatsApp:(NSURL *)videoURL {
    // Ensure this runs on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://app"];
        
        if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]) {
            //[self shareMedia];
            if(isVideoFile)
            {
                NSURL *tempURL = [self saveVideoToTempDirectory:self.videoURL];
                [self shareMediaToWhatsApp:tempURL fromView:self.view isImage:NO];

            }
            else
            {
                NSURL *imageURL = [self saveImageToTempDirectory:outputImage];
                [self shareMediaToWhatsApp:imageURL fromView:self.view isImage:YES];
            }
            
        } else {
            [self showAlert:@"WhatsApp is not installed"];
        }
    });
}




- (NSURL *)saveImageToTempDirectory:(UIImage *)image {
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"whatsapp-share.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [imageData writeToFile:filePath atomically:YES];
    return [NSURL fileURLWithPath:filePath];
}

- (NSURL *)saveVideoToTempDirectory:(NSURL *)videoURL {
//    NSString *outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"whatsapp-video.mp4"];
//    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
//
//    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
//    [[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:outputURL error:nil];
//
//    return outputURL;
        NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"videoToShare.mp4"];
        NSURL *tempURL = [NSURL fileURLWithPath:tempPath];

        // Remove existing
        [[NSFileManager defaultManager] removeItemAtURL:tempURL error:nil];

        // Copy to temp
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:tempURL error:&error];
        if (error) {
            NSLog(@"Error copying video: %@", error);
        }
        return tempURL;
}


- (void)shareMediaToWhatsApp:(NSURL *)fileURL fromView:(UIView *)view isImage:(BOOL)isImage {
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    
    if (isImage) {
        self.documentInteractionController.UTI = @"net.whatsapp.image";
    } else {
        self.documentInteractionController.UTI = @"public.movie";
    }
    
//    self.documentInteractionController.delegate = self;
//    [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    // OPTIONAL: To limit to WhatsApp only (some iOS versions)
    if (!isImage) {
        self.documentInteractionController.annotation = @{@"UTI": @"net.whatsapp.movie"};
    }
    else {
        self.documentInteractionController.annotation = @{@"UTI": @"net.whatsapp.image"};
    }
        self.documentInteractionController.delegate = self;

    // Present the WhatsApp-only share dialog
    BOOL success = [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:view animated:YES];

    if (!success) {
        NSLog(@"WhatsApp may not support this file type.");
        [self showAlert:@"WhatsApp may not support this file type."];
    }
}



- (NSString *)urlEncodeString:(NSString *)string {
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}



- (void)shareToiMessage:(NSURL *)videoURL {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController addAttachmentURL:videoURL withAlternateFilename:nil];
        [self presentViewController:messageController animated:YES completion:nil];
    } else {
        [self showAlert:@"iMessage is not available"];
    }
}

-(void)shareToiMessageImage:(UIImage *)image
{
    if (![MFMessageComposeViewController canSendText]) {
            [self showAlert:@"iMessage is not available"];
            return;
        }

        // Convert UIImage to NSData (JPEG or PNG)
        NSData *imageData = UIImageJPEGRepresentation(image, 0.9); // You can use UIImagePNGRepresentation() for PNG
        
        if (!imageData) {
            [self showAlert:@"Failed to prepare image for sharing"];
            return;
        }

        // Create and present message controller
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        
        // Determine MIME type (use "image/png" for PNG images)
        NSString *mimeType = @"image/jpeg";
        NSString *filename = @"image.jpg";
        
        // If you want to use PNG instead:
        // NSString *mimeType = @"image/png";
        // NSString *filename = @"image.png";
        // NSData *imageData = UIImagePNGRepresentation(image);
        
        // Attach the image data
        [messageController addAttachmentData:imageData typeIdentifier:mimeType filename:filename];
        
    [self presentViewController:messageController animated:YES completion:nil];
}


#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper

- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Action Implementations

- (void)printAction {
    if ([UIPrintInteractionController isPrintingAvailable]) {
        UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"Video Link";
        printController.printInfo = printInfo;
        
        printController.printingItem = self.videoURL;
        
        [printController presentAnimated:YES completionHandler:nil];
    } else {
        [self showAlert:@"Printing is not available on this device"];
    }
}

- (void)emailAction {
    if ([MFMailComposeViewController canSendMail]) {
//        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
//        mailComposer.mailComposeDelegate = self;
//        [mailComposer setSubject:@"Check out this video"];
//        //[mailComposer setMessageBody:[NSString stringWithFormat:@"Here's an interesting video: %@", self.videoURL.absoluteString] isHTML:NO];
//        
//        [self presentViewController:mailComposer animated:YES completion:nil];
        nvm.uploadCommand = UPLOAD_EMAIL;
        
        if(isVideoFile)
            [self uploadVideo];
        else
            [self uploadImage];
    } else {
        [self showAlert:@"Email is not configured on this device"];
    }
}

- (void)copyLinkAction {
    [UIPasteboard generalPasteboard].string = self.videoURL.absoluteString;
    [self showAlert:@"Link copied to clipboard"];
}


-(void)shareMedia
{
    NSArray *activityItems = nil;
    if(isVideoFile)
    {
        activityItems = @[self.videoURL];
    }
    else
    {
//        UploadHandler *uploadH = nil;
//        uploadH = [UploadHandler alloc];
//        uploadH.view = self.view;
//        uploadH.viewController = self;
//        uploadH.cursess = sess;
//        UIImage *img = [uploadH getTheSnapshot];
        activityItems = @[outputImage];
    }

    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }

    [activityViewControntroller setCompletionWithItemsHandler:^(UIActivityType _Nullable activityType, BOOL completed,
                                                                NSArray * _Nullable returnedItems,
                                                                NSError * _Nullable activityError) {
    }];
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}


-(void)playOrPausePreview
{
    if(previewPlayButton)
    {
        int masterAudioSet = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MasterAudioPlayerSet"];
        for (int photoIndex= 0; photoIndex< sess.frame.photoCount; photoIndex++)
        {
            Photo *pht = [sess.frame getPhotoAtIndex:photoIndex ];
            if(pht.isContentTypeVideo)
            {
                if(pht.view.player.rate > 0)
                {
                    [pht.view pausePlayer];
                    if(masterAudioSet)
                    {
                        [sess muteMasterAudio];
                    }
                    [previewPlayButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [pht.view playPlayer];
                    if(masterAudioSet)
                    {
                        [sess unmuteMasterAudio];
                    }
                    [previewPlayButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
                }
            }
        }
    }
}

//old
- (void)setupTopActionButtons {
    // Container view for top buttons
    topButtonContainer = [[UIView alloc] init];
    topButtonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:topButtonContainer];

    // Create horizontal stack view
    stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 20;
    stackView.backgroundColor = [UIColor clearColor];
    
    // Add buttons to stack view
    for (int i = 0; i < self.socialButtonsData.count; i++) {
        UIView *container = [self createButtonContainerWithImage:self.socialButtonsData[i][@"imageName"]
                                                           label:self.socialButtonsData[i][@"title"] index:i];
        [stackView addArrangedSubview:container];
    }
    
    // Add stack view to main view
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [topButtonContainer addSubview:stackView];
    

    // Remove Watermark button
    removeWatermarkButton = [self createActionButtonWithTitle:@"Remove Watermark and Ads"];
    [removeWatermarkButton addTarget:self action:@selector(ShowSubscriptionView) forControlEvents:UIControlEventTouchUpInside];
    removeWatermarkButton.layer.cornerRadius = heightOfButtons/2;
    [topButtonContainer addSubview:removeWatermarkButton];

    // Save to Library button
    saveToLibraryButton = [self createActionButtonWithTitle:@"Save to Library"];
    [saveToLibraryButton addTarget:self action:@selector(saveToLibraryTapped:) forControlEvents:UIControlEventTouchUpInside];
    saveToLibraryButton.tag = 5;
    saveToLibraryButton.layer.cornerRadius = heightOfButtons/2;
    [topButtonContainer addSubview:saveToLibraryButton];

//    // Dropdown button
//    dropdownButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    dropdownButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [dropdownButton setImage:[UIImage systemImageNamed:@"chevron.down"] forState:UIControlStateNormal];
//    [dropdownButton addTarget:self action:@selector(showSaveOptions) forControlEvents:UIControlEventTouchUpInside];
//    dropdownButton.backgroundColor = PHOTO_DEFAULT_COLOR;
//    dropdownButton.tintColor = [UIColor whiteColor];
//    dropdownButton.layer.cornerRadius = heightOfButtons/2;
//    [topButtonContainer addSubview:dropdownButton];
    [self assignConstraints];
}

-(void)assignConstraints
{
    NSLog(@"before heightOfButtons %f",heightOfButtons);
    CGFloat spacing;
    float multiple = 0.6;
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        spacing = heightOfButtons/2;
        multiple = 0.49;
    }
    else if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
    {
        spacing = heightOfButtons/2;
        multiple = 0.6;
    }
    else
    {
        spacing = heightOfButtons * 1.25;
        multiple = 0.6;
    }
    float oldsSpacing = spacing;
    float topAnchorYAnchorConstant = self.view.bounds.size.height/4;
    
    if ([[SRSubscriptionModel shareKit] IsAppSubscribed]) {
        removeWatermarkButton.hidden = YES;
        topAnchorYAnchorConstant = self.view.bounds.size.height/4 - (oldsSpacing * 1.25);
        spacing = oldsSpacing * 1.45;
    }else
    {
        removeWatermarkButton.hidden = NO;
        topAnchorYAnchorConstant = self.view.bounds.size.height/4;
        spacing = oldsSpacing;
    }
    
    NSLog(@"after  heightOfButtons spacing %f",spacing);
    self.topButtonConstraints = @[
        // Set width (80% of superview)
        [topButtonContainer.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:multiplier],
        
        // Set height (45% of superview height - slightly less than half)
        [topButtonContainer.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.45],
        
        // Center horizontally
        [topButtonContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        // Position in bottom half (centerY of bottom half)
        [topButtonContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor
                                                         constant:topAnchorYAnchorConstant],
        
        // Remove Watermark button
        [removeWatermarkButton.topAnchor constraintEqualToAnchor:topButtonContainer.topAnchor],
        [removeWatermarkButton.widthAnchor constraintEqualToConstant:fullScreen.size.width * multiplier],
        [removeWatermarkButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [removeWatermarkButton.heightAnchor constraintEqualToConstant:heightOfButtons],
        
        
        // Save to Library button
        [saveToLibraryButton.topAnchor constraintEqualToAnchor:removeWatermarkButton.bottomAnchor constant:spacing],
        [saveToLibraryButton.leadingAnchor constraintEqualToAnchor:topButtonContainer.leadingAnchor],
//        [saveToLibraryButton.widthAnchor constraintEqualToConstant:fullScreen.size.width * multiple],
        [saveToLibraryButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:multiplier],
        [saveToLibraryButton.heightAnchor constraintEqualToConstant:heightOfButtons],
        
//        // Dropdown button
//        [dropdownButton.topAnchor constraintEqualToAnchor:removeWatermarkButton.bottomAnchor constant:spacing],
//        [dropdownButton.leadingAnchor constraintEqualToAnchor:saveToLibraryButton.trailingAnchor constant:10],
//        [dropdownButton.trailingAnchor constraintEqualToAnchor:topButtonContainer.trailingAnchor],
//        [dropdownButton.heightAnchor constraintEqualToConstant:heightOfButtons],
        
        
        [stackView.topAnchor constraintEqualToAnchor:saveToLibraryButton.bottomAnchor constant:spacing],
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:multiplier]
    ];
}

-(void)setupTopButtonConstraints
{
    // Remove existing constraints first
        if (self.topButtonConstraints) {
            [NSLayoutConstraint deactivateConstraints:self.topButtonConstraints];
        }
    [self assignConstraints];
    [NSLayoutConstraint activateConstraints:self.topButtonConstraints];
}


-(void)saveToLibraryTapped:(UIButton*)button
{
//    NSLog(@"save To Library Tapped");
//    // Write code to show quality options
//    if([userDefault integerForKey:@"ShowDefaultSaveOption"] == 0)
//    {
//        [userDefault setInteger:1 forKey:@"ShowDefaultSaveOption"];
        [self showDefaultOptionSaveOptions:button];
//    }
//    else{
//        [self exportVideoOrImageIndex:button];
//    }
}


- (UIButton *)createActionButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    button.backgroundColor = [UIColor whiteColor];
    if([title  isEqual: @"Remove Watermark and Ads"])
    {
        button.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:184.0/255.0 blue:250.0/255.0 alpha:1.0];
        UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
        config.imagePadding = 20; // Set your desired spacing
        config.imagePlacement = NSDirectionalRectEdgeLeading;
        button.configuration = config;
        UIImage *crownImage = [UIImage imageNamed:@"crown.png"];
        [button setImage:crownImage forState:UIControlStateNormal];
    }else{
        [button setTitle:title forState:UIControlStateNormal];
        UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
        config.imagePadding = 20; // Set your desired spacing
        config.imagePlacement = NSDirectionalRectEdgeLeading;
        button.configuration = config;
        UIImage *saveToLibraryImage = [[UIImage systemImageNamed:@"square.and.arrow.down"]imageWithTintColor:[UIColor whiteColor] renderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setImage:[saveToLibraryImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
       // button.tintColor = [UIColor whiteColor];
        button.backgroundColor = PHOTO_DEFAULT_COLOR;
    }
    button.tintColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 8;
    button.clipsToBounds = YES;
    
    // Shadow
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 2);
    button.layer.shadowRadius = 4;
    button.layer.shadowOpacity = 0.1;
    button.layer.masksToBounds = NO;
    return button;
}


- (void)showSaveOptions {
    NSLog(@"show Save Options");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save as"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Standard Quality
    [alert addAction:[UIAlertAction actionWithTitle:@"Standard"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        if(nvm.uploadResolution != RESOLUTION_PIXCOUNT_HIGH0)
        {
            frameIsEdited = YES;
        }
        // [self saveVideoWithQuality:@"standard"];
        upscaleFactor = 720.0f / sess.frame.frame.size.width;
        nvm.uploadResolution = RESOLUTION_PIXCOUNT_HIGH0;
        NSLog(@"upscale factor %f",upscaleFactor);
    }]];
    
    // HD Quality
    [alert addAction:[UIAlertAction actionWithTitle:@"HD"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
        if(nvm.uploadResolution != RESOLUTION_PIXCOUNT_HIGH1)
        {
            frameIsEdited = YES;
        }
        // [self saveVideoWithQuality:@"hd"];
        nvm.uploadResolution = RESOLUTION_PIXCOUNT_HIGH1;
        upscaleFactor = 1280.0f / sess.frame.frame.size.width;
        NSLog(@"upscale factor %f",upscaleFactor);
    }]];
    
    // Cancel
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    // iPad Popover Presentation Configuration
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        alert.popoverPresentationController.sourceView = saveToLibraryButton;
        alert.popoverPresentationController.sourceRect = saveToLibraryButton.bounds;
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    // Present the alert
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)showDefaultOptionSaveOptions:(UIButton*)button {
    NSLog(@"show Save Options");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save as"
                                                                 message:nil
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Standard Quality
    UIAlertAction *standardAction = [UIAlertAction actionWithTitle:@"Standard"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        if(nvm.uploadResolution != RESOLUTION_PIXCOUNT_HIGH0)
        {
            self->frameIsEdited = YES;
        }
        self->upscaleFactor = 720.0f / self->sess.frame.frame.size.width;
        self->nvm.uploadResolution = RESOLUTION_PIXCOUNT_HIGH0;
        NSLog(@"upscale factor %f", self->upscaleFactor);
        [self exportVideoOrImageIndex:button];
    }];
    
    // HD Quality
    UIAlertAction *hdAction = [UIAlertAction actionWithTitle:@"HD"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        if(nvm.uploadResolution != RESOLUTION_PIXCOUNT_HIGH1)
        {
            self->frameIsEdited = YES;
        }
        self->nvm.uploadResolution = RESOLUTION_PIXCOUNT_HIGH1;
        self->upscaleFactor = 1280.0f / self->sess.frame.frame.size.width;
        NSLog(@"upscale factor %f", self->upscaleFactor);
        [self exportVideoOrImageIndex:button];
    }];
    
    // Cancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    
    [alert addAction:standardAction];
    [alert addAction:hdAction];
    [alert addAction:cancelAction];
    
    // Set default selected action (iOS 9+)
    if (@available(iOS 9.0, *)) {
        alert.preferredAction = standardAction;
    }
    
    // iPad Popover Presentation Configuration
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        alert.popoverPresentationController.sourceView = saveToLibraryButton;
        alert.popoverPresentationController.sourceRect = saveToLibraryButton.bounds;
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)addGestureRecognizersTo:(UIView *)overlayView {
    // Pan Gesture
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTextBoxPan:)];
    
    // Pinch Gesture
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handlePinch:)];
    
    // Rotate Gesture
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleRotate:)];
    
    // Tap Gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTap:)];
    
    // Add all gestures to the overlay view
    [overlayView addGestureRecognizer:pan];
    [overlayView addGestureRecognizer:pinch];
    [overlayView addGestureRecognizer:rotate];
    [overlayView addGestureRecognizer:tap];
}


- (void)handleTap:(UITapGestureRecognizer *)gesture {
    NSLog(@"Textview: handle tap called ");
    frameIsEdited = YES;
    UIView *overlayView = gesture.view;
    if (!overlayView) {
        return;
    }
    
    // Bring the overlay view to the front
    [mainBackground bringSubviewToFront:overlayView];
    if(colorPicker != nil)
        [colorPicker dismissViewControllerAnimated:YES completion:nil];
    // Activate the first responder
    UIView *firstSubview = overlayView.subviews.firstObject;
    [firstSubview becomeFirstResponder];
    self.showingFonts = NO;
    // Get the UITextView inside the overlay
    for (UIView *subview in overlayView.subviews) {
        if ([subview isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)subview;
            // Activate editing
            [textView becomeFirstResponder];
            
            // Set the last active text view
            self.lastActiveTextView = textView;
            
            // Update the slider value to match the text view's font size
            fontSizeSlider.value = textView.font ? textView.font.pointSize : 26;
            
            // Bring the selected text box to the front
            [mainBackground bringSubviewToFront:overlayView];
            
            break;  // Stop iterating after finding the UITextView
        }
    }
}

- (void)handleRotate:(UIRotationGestureRecognizer *)gesture {
    frameIsEdited = YES;
    NSLog(@"Textview: handle rotate  called ");
    [self SetOriginalUI];
    [self CloseTextEditorUI];
    UITextView *activeTextView = [self findActiveTextView];
    [activeTextView resignFirstResponder];
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        gesture.view.transform = CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
        gesture.rotation = 0;  // Reset the rotation to avoid cumulative rotations
    }
}


- (void)handleTextBoxPan:(UIPanGestureRecognizer *)gesture {
    NSLog(@"Textview: handle textbox pan called ");
    frameIsEdited = YES;
    UITextView *activeTextView = [self findActiveTextView];
    [activeTextView resignFirstResponder];
    [self SetOriginalUI];
    self.uitoolbar.hidden = YES;
    self.fontSizeSlider.hidden = YES;
    ellipsisOverlay.hidden = YES;
    fontsCollectionView.hidden = YES;
    ColorsCollectionView.hidden = YES;
    [self CloseTextEditorUI];
    
    UIView *overlayView = gesture.view;
    if (!overlayView) return;
    
    CGPoint translation = [gesture translationInView:sess.frame];
    overlayView.center = CGPointMake(
                                     overlayView.center.x + translation.x,
                                     overlayView.center.y + translation.y
                                     );
    [gesture setTranslation:CGPointZero inView:sess.frame];
    
    // Trash detection
    CGRect trashFrame = CGRectInset(self.trashBinView.frame, -1, -1);
    
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:
            self.trashBinView.hidden = NO;
            overlayView.alpha = CGRectIntersectsRect(overlayView.frame, trashFrame) ? 0.5 : 1.0;
            if (CGRectIntersectsRect(overlayView.frame, trashFrame)) {
                [self triggerHapticFeedback];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            sess.frame.clipsToBounds = YES;
        case UIGestureRecognizerStateCancelled:
            self.trashBinView.hidden = YES;
            if (CGRectIntersectsRect(overlayView.frame, trashFrame)) {
                [self triggerHapticFeedback];
                [overlayView removeFromSuperview];
                [self.textBoxes removeObject:overlayView];
                self.lastActiveTextView = nil;
            }
            fontSizeSlider.hidden = YES;
            uitoolbar.hidden = YES;
            overlayView.alpha = 1.0;
            break;
            
        default:
            break;
    }
    [self applyShapeToActiveTextView];
}


- (BOOL)isFrameOverlapping:(CGRect)frame {
    NSLog(@"Textview: is g=frame overlapping called ");
    for (UIView *existingView in self.textBoxes) {
        if (CGRectIntersectsRect(existingView.frame, frame)) {
            return YES;
        }
    }
    return NO;
}


- (UITextView *)findActiveTextView {
    if(self.textBoxes.count > 0)
    {
        for (UIView *overlay in self.textBoxes) {
            for (UIView *subview in overlay.subviews) {
                if ([subview isKindOfClass:[UITextView class]]) {
                    UITextView *textView = (UITextView *)subview;
                    if ([textView isFirstResponder]) {
                        self.lastActiveTextView = textView; // Update last active textView
                        return textView;
                    }
                }
            }
        }
        return self.lastActiveTextView; // Return the last active one if none is active
    }
    else
    {
        return nil;
    }
}



//- (void)textViewDidEndEditing:(UITextView *)textView {
//    NSLog(@"Textview: Did End Editing called");
//    UIView *container = textView.superview;
//    if (!container) return;
//    
//    // If the text box is empty or contains the placeholder text, delete it
//    if (textView.text.length == 0 || [textView.text isEqualToString:@"Enter Text"]) {
//        UIView *overlayView = textView.superview;
//        if (overlayView) {
//            [overlayView removeFromSuperview];
//            NSLog(@"did remove textview");
//            [self.textBoxes removeObject:overlayView];
//            self.lastActiveTextView = nil;
//        }
//    }
//    //    // Remove the border when editing ends
//    //    textView.layer.borderWidth = 0;
//    //    textView.layer.borderColor = [UIColor clearColor].CGColor;
//    // Calculate container size with padding
//    CGFloat padding = 8.0;
//    CGSize containerSize = CGSizeMake(
//                                      textView.frame.size.width + (padding * 2),
//                                      textView.frame.size.height + (padding * 2)
//                                      );
//    
//    // Center text view in container
//    textView.frame = CGRectMake(
//                                padding,
//                                padding,
//                                textView.frame.size.width,
//                                textView.frame.size.height
//                                );
//    
//    // Update container frame
//    [UIView animateWithDuration:0.2 animations:^{
//        container.frame = CGRectMake(
//                                     container.frame.origin.x,
//                                     container.frame.origin.y,
//                                     containerSize.width,
//                                     containerSize.height
//                                     );
//    }];
//}

//- (void)sliderValueChanged:(UISlider *)sender {
//    NSLog(@"Textview: slider value changed called");
//    frameIsEdited = YES;
//    CGFloat fontSize = sender.value;
//    
//    // Find the active text view and its overlay
//    UITextView *activeTextView = [self findActiveTextView];
//    if (!activeTextView || !activeTextView.superview) {
//        return;
//    }
//    
//    UIView *overlayView = activeTextView.superview;
//    
//    // Update font size if changed
//    if (activeTextView.font.pointSize != fontSize) {
//        activeTextView.font = [activeTextView.font fontWithSize:fontSize];
//    }
//    
//    // Calculate new text size, accounting for scale
//    CGFloat maxWidth = (self.view.frame.size.width - 40) / self.currentScale;
//    CGFloat maxHeight = (self.view.frame.size.height - 200) / self.currentScale;
//    
//    NSDictionary *textAttributes = @{NSFontAttributeName: activeTextView.font};
//    CGSize textSize = [activeTextView.text boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
//                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                     attributes:textAttributes
//                                                        context:nil].size;
//    
//    // Calculate new dimensions
//    CGFloat padding = 20 / self.currentScale; // Scale padding
//    CGFloat newTextBoxWidth = MIN(textSize.width + padding, maxWidth);
//    CGFloat newTextBoxHeight = MIN(textSize.height + padding, maxHeight);
//    CGFloat newOverlayWidth = newTextBoxWidth + padding;
//    CGFloat newOverlayHeight = newTextBoxHeight + padding;
//    
//    // Capture current rotation
//    CGFloat rotation = atan2(overlayView.transform.b, overlayView.transform.a);
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        // Reset transform to avoid frame distortion
//        overlayView.transform = CGAffineTransformIdentity;
//        
//        // Resize overlay and text view
//        overlayView.frame = CGRectMake(overlayView.frame.origin.x,
//                                       overlayView.frame.origin.y,
//                                       newOverlayWidth,
//                                       newOverlayHeight);
//        
//        activeTextView.frame = CGRectMake(activeTextView.frame.origin.x,
//                                          activeTextView.frame.origin.y,
//                                          newTextBoxWidth,
//                                          newTextBoxHeight);
//        
//        // Center the text view within the overlay
//        activeTextView.center = CGPointMake(CGRectGetMidX(overlayView.bounds),
//                                            CGRectGetMidY(overlayView.bounds));
//        
//        // Reapply both scale and rotation transforms
//        overlayView.transform = CGAffineTransformMakeScale(self.currentScale, self.currentScale);
//        overlayView.transform = CGAffineTransformRotate(overlayView.transform, rotation);
//    }];
//    
//    // Ensure the overlay view stays within the bounds of the imageView
//    CGFloat maxX = self.view.bounds.size.width - overlayView.frame.size.width * self.currentScale;
//    CGFloat maxY = self.view.bounds.size.height - overlayView.frame.size.height * self.currentScale;
//    
//    CGRect newOverlayFrame = overlayView.frame;
//    
//    // Restrict X and Y position inside imageView
//    if (newOverlayFrame.origin.x < 0) newOverlayFrame.origin.x = 0;
//    if (newOverlayFrame.origin.y < 0) newOverlayFrame.origin.y = 0;
//    if (newOverlayFrame.origin.x > maxX) newOverlayFrame.origin.x = maxX;
//    if (newOverlayFrame.origin.y > maxY) newOverlayFrame.origin.y = maxY;
//    
//    overlayView.frame = newOverlayFrame;
//    
//    // Update the shape layer
//    [self applyShapeToActiveTextView];
//}

/// 4
//- (void)textViewDidChange:(UITextView *)textView {
//    NSLog(@"Textview: Did change called");
//    UITextInputMode *mode = textView.textInputMode;
//    NSLog(@"Input mode is now: %@", mode.primaryLanguage);
//    
//    frameIsEdited = YES;
//    
//    // Calculate the new text size
//    CGFloat maxWidth = self.view.bounds.size.width - 40;  // Leave padding on sides
//    CGFloat maxHeight = self.view.bounds.size.height - 40; // Leave padding on top and bottom
//    
//    NSDictionary *textAttributes = @{
//        NSFontAttributeName: textView.font
//    };
//    
//    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(maxWidth / self.currentScale, maxHeight / self.currentScale)
//                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                               attributes:textAttributes
//                                                  context:nil].size;
//    
//    // Calculate new dimensions for the text box and overlay view
//    CGFloat padding = 20; // Padding around the text box
//    CGFloat newTextBoxWidth = MIN(textSize.width + padding, maxWidth / self.currentScale);
//    CGFloat newTextBoxHeight = MIN(textSize.height + padding, maxHeight / self.currentScale);
//    
//    CGFloat newOverlayWidth = newTextBoxWidth + padding;  // Add additional padding for the overlay
//    CGFloat newOverlayHeight = newTextBoxHeight + padding;
//    
//    // Get the overlay view
//    UIView *overlayView = textView.superview;
//    if (!overlayView) return;
//    
//    // Capture the current rotation transform
//    CGFloat rotation = atan2(overlayView.transform.b, overlayView.transform.a);
//    
//    // Animate changes smoothly
//    [UIView animateWithDuration:0.1 animations:^{
//        // Reset transform to avoid frame distortion during resizing
//        overlayView.transform = CGAffineTransformIdentity;
//        
//        // Resize the text box
//        textView.frame = CGRectMake(textView.frame.origin.x,
//                                    textView.frame.origin.y,
//                                    newTextBoxWidth,
//                                    newTextBoxHeight);
//        
//        // Resize the overlay view
//        overlayView.frame = CGRectMake(overlayView.frame.origin.x,
//                                       overlayView.frame.origin.y,
//                                       newOverlayWidth,
//                                       newOverlayHeight);
//        
//        // Center the text box within the overlay view
//        textView.center = CGPointMake(CGRectGetMidX(overlayView.bounds),
//                                      CGRectGetMidY(overlayView.bounds));
//        
//        // Reapply both scale and rotation transforms
//        overlayView.transform = CGAffineTransformMakeScale(self.currentScale, self.currentScale);
//        overlayView.transform = CGAffineTransformRotate(overlayView.transform, rotation);
//    }];
//    
//    // Ensure the overlay view stays within the bounds of the imageView
//    CGFloat maxX = self.view.bounds.size.width - overlayView.frame.size.width * self.currentScale;
//    CGFloat maxY = self.view.bounds.size.height - overlayView.frame.size.height * self.currentScale;
//    
//    CGRect newOverlayFrame = overlayView.frame;
//    
//    // Restrict X and Y position inside imageView
//    if (newOverlayFrame.origin.x < 0) newOverlayFrame.origin.x = 0;
//    if (newOverlayFrame.origin.y < 0) newOverlayFrame.origin.y = 0;
//    if (newOverlayFrame.origin.x > maxX) newOverlayFrame.origin.x = maxX;
//    if (newOverlayFrame.origin.y > maxY) newOverlayFrame.origin.y = maxY;
//    
//    overlayView.frame = newOverlayFrame;
//    
//    // Update the shape layer
//    [self applyShapeToActiveTextView];
//}

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    NSLog(@"Textview: Did begin Editing called");
//    NSLog(@"textview begin editing re_Align");
//    [self reAlignUI];
//    self.lastActiveTextView = textView;
//
//    // Update the slider value to match the font size
//    fontSizeSlider.value = textView.font ? textView.font.pointSize : 16;
//
//    // Show placeholder text if empty
//    if (textView.text.length == 0) {
//        textView.text = @"Enter Text";
//        textView.textColor = [UIColor whiteColor];
//    }
//
//    // Retrieve and update the shape layer
//    CAShapeLayer *shapeLayer = [self findCAShapeLayerInView:textView.superview];
//    if (shapeLayer) {
//        selectedOverlayColor = [UIColor colorWithCGColor:shapeLayer.fillColor];
//    }
//
//    // Update the shape layer to match the current transform
//    [self applyShapeToActiveTextView];
//
//    // Set cursor to the beginning
//    UITextRange *beginning = [textView textRangeFromPosition:textView.beginningOfDocument
//                                                  toPosition:textView.beginningOfDocument];
//    textView.selectedTextRange = beginning;
//
//    // Show toolbar and slider
//    uitoolbar.hidden = NO;
//    fontSizeSlider.hidden = NO;
//    [mainBackground bringSubviewToFront:self.fontSizeSlider];
//    textEditorSubviewAdded = YES;
//
//    // Add border to indicate active state
//    textView.layer.borderWidth = 2;
//    textView.layer.borderColor = [UIColor clearColor].CGColor;
//
//    // Update UserDefaults
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fromText"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}



- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"Textview: Did change selection called");
    // Prevent the user from moving the cursor within the placeholder text
    if ([textView.textColor isEqual:[UIColor whiteColor]] && [textView.text isEqualToString:@"Enter Text"]) {
        UITextRange *beginning = [textView textRangeFromPosition:textView.beginningOfDocument
                                                      toPosition:textView.beginningOfDocument];
        textView.selectedTextRange = beginning;
    }
    [self applyShapeToActiveTextView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"Textview: should chnage text in range called");
    // Combine the current text and the new text
    NSString *currentText = textView.text ?: @"";
    NSString *updatedText = [currentText stringByReplacingCharactersInRange:range withString:text];
    
    // If the updated text is empty, show the placeholder
    if (updatedText.length == 0) {
        textView.text = @"";//Enter Text
        textView.textColor = [UIColor whiteColor]; // Placeholder color
        
        // Set the cursor at the beginning
        UITextRange *beginning = [textView textRangeFromPosition:textView.beginningOfDocument
                                                      toPosition:textView.beginningOfDocument];
        textView.selectedTextRange = beginning;
        
        return NO; // Prevent empty string from being applied
    }
    
    // If the placeholder is still present, remove it
    if ([textView.textColor isEqual:[UIColor whiteColor]] && [textView.text isEqualToString:@"Enter Text"]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; // User text color
    }
    
    return YES;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
    NSLog(@"Textview: handle pinch called ");
    frameIsEdited = YES;
    UITextView *activeTextView = [self findActiveTextView];
    [activeTextView resignFirstResponder];
    [self CloseTextEditorUI];
    [self SetOriginalUI];
    UIView *textView = gesture.view;
    //[textView resignFirstResponder]; // to hide keyboard
    // Apply scaling transformation
    textView.transform = CGAffineTransformScale(textView.transform, gesture.scale, gesture.scale);
    
    // Reset the gesture scale
    gesture.scale = 1.0;
    [self applyShapeToActiveTextView];
}


//- (void)applyShapeToActiveTextView {
//    UITextView *activeTextView = [self findActiveTextView];
//    if (!activeTextView || !activeTextView.superview) {
//        return;
//    }
//    
//    activeTextView.backgroundColor = [UIColor clearColor];
//    UIView *overlayView = activeTextView.superview;
//
//    // Remove existing shape layers
//    for (CALayer *layer in [overlayView.layer.sublayers copy]) {
//        if ([layer isKindOfClass:[CAShapeLayer class]]) {
//            [layer removeFromSuperlayer];
//        }
//    }
//
//    if (selectedOverlayColor == [UIColor clearColor]) {
//        NSLog(@"selected OverlayColor is clear");
//        selectedOverlayColor = [UIColor systemGrayColor];
//    }
//
//    activeTextView.clipsToBounds = NO;
//    activeTextView.layer.masksToBounds = NO;
//
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    
//    // Calculate the scaled bounds based on the text view's transform
//    CGAffineTransform transform = activeTextView.transform;
//    CGRect scaledBounds = CGRectApplyAffineTransform(activeTextView.bounds, transform);
//    shapeLayer.frame = scaledBounds;
//    shapeLayer.fillColor = selectedOverlayColor.CGColor;
//    shapeLayer.lineWidth = 3.0;
//    shapeLayer.lineDashPattern = nil;
//    shapeLayer.zPosition = 0;
//
//    // Add the shape layer below the text view
//    [overlayView.layer insertSublayer:shapeLayer below:activeTextView.layer];
//
//    NSLog(@"shape layer bounds %@", NSStringFromCGRect(shapeLayer.bounds));
//    NSLog(@"activeTextView bounds %@", NSStringFromCGRect(activeTextView.bounds));
//
//    // Apply the new shape
//    UIBezierPath *path = [self getCustomShapeForActiveTextWithType];
//    if (path) {
//        // Apply the text view's transform to the path
//        CGAffineTransform pathTransform = activeTextView.transform;
//        [path applyTransform:pathTransform];
//        shapeLayer.path = path.CGPath;
//    }
//
//    // Reset corner radius and mask
//    overlayView.layer.cornerRadius = 0;
//    overlayView.layer.mask = nil;
//
//    [activeTextView.layer setNeedsDisplay];
//    [activeTextView setNeedsLayout];
//    [activeTextView layoutIfNeeded];
//}
//  
//- (UIBezierPath *)getCustomShapeForActiveTextWithType {
//    UITextView *textView = [self findActiveTextView];
//    if (!textView) return nil;
//    
//    NSLayoutManager *layoutManager = textView.layoutManager;
//    NSTextContainer *textContainer = textView.textContainer;
//    UIEdgeInsets insets = textView.textContainerInset;
//    
//    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
//    CGRect usedRect = [layoutManager usedRectForTextContainer:textContainer];
//    
//    CGFloat padding = 8.0;
//    CGRect textFrameInTextView = CGRectMake(
//                                            insets.left + usedRect.origin.x - padding,
//                                            insets.top + usedRect.origin.y - padding,
//                                            usedRect.size.width + 2 * padding,
//                                            usedRect.size.height + 2 * padding
//                                            );
//    
//    // Convert to superview coordinate space
//    CGRect shapeFrame = CGRectOffset(textFrameInTextView, textView.frame.origin.x, textView.frame.origin.y);
//    
//    if (self.currentShape == OverlayShapeRectangle) {
//        return [UIBezierPath bezierPathWithRect:shapeFrame];
//        
//    } else if (self.currentShape == OverlayShapeRoundedRectangle) {
//        CGFloat cornerRadius = 12.0;
//        return [UIBezierPath bezierPathWithRoundedRect:shapeFrame cornerRadius:cornerRadius];
//        
//    }
//    else if (self.currentShape == OverlayShapeOval) {
//        CGFloat cornerRadius = shapeFrame.size.height / 2;
//        return [UIBezierPath bezierPathWithRoundedRect:shapeFrame cornerRadius:cornerRadius];
//        
//       // return [UIBezierPath bezierPathWithOvalInRect:shapeFrame];
//        
//    } else if (self.currentShape == OverlayShapeCustomFrame) {
//        // Custom shape: rounded rect per line (your original logic)
//        NSMutableArray<NSValue *> *lineRects = [NSMutableArray array];
//        
//        for (NSUInteger i = 0; i < glyphRange.length; i++) {
//            NSRange range;
//            CGRect lineRect = [layoutManager lineFragmentUsedRectForGlyphAtIndex:i effectiveRange:&range];
//            if (!CGRectIsEmpty(lineRect)) {
//                CGRect convertedRect = CGRectMake(
//                                                  textView.frame.origin.x + lineRect.origin.x + insets.left,
//                                                  textView.frame.origin.y + lineRect.origin.y + insets.top,
//                                                  lineRect.size.width,
//                                                  lineRect.size.height
//                                                  );
//                [lineRects addObject:[NSValue valueWithCGRect:convertedRect]];
//            }
//        }
//        
//        UIBezierPath *compositePath = [UIBezierPath bezierPath];
//        CGFloat cornerRadius = 10.0;
//        
//        for (NSValue *value in lineRects) {
//            CGRect lineRect = [value CGRectValue];
//            CGRect paddedRect = CGRectInset(lineRect, -padding, -padding);
//            UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:paddedRect cornerRadius:cornerRadius];
//            [compositePath appendPath:roundedRect];
//        }
//        
//        return compositePath;
//    }
//    
//    return nil; // unsupported shape type
//}


- (void)applyShapeToActiveTextView {
    UITextView *activeTextView = [self findActiveTextView];
    if (!activeTextView || !activeTextView.superview) {
        return;
    }
    
    activeTextView.backgroundColor = [UIColor clearColor];
    UIView *overlayView = activeTextView.superview;

    // Remove existing shape layers
    for (CALayer *layer in [overlayView.layer.sublayers copy]) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }

    if (selectedOverlayColor == [UIColor clearColor]) {
        NSLog(@"selected OverlayColor is clear");
        selectedOverlayColor = [UIColor systemGrayColor];
    }

    activeTextView.clipsToBounds = NO;
    activeTextView.layer.masksToBounds = NO;

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // Set the shape layer's frame to match the text view's frame (including transform)
    shapeLayer.frame = activeTextView.frame;
    
    // Apply the same transform as the text view to the shape layer
    shapeLayer.transform = activeTextView.layer.transform;
    
    shapeLayer.fillColor = selectedOverlayColor.CGColor;
    shapeLayer.lineWidth = 3.0;
    shapeLayer.lineDashPattern = nil;
    shapeLayer.zPosition = 0;

    // Add the shape layer below the text view
    [overlayView.layer insertSublayer:shapeLayer below:activeTextView.layer];

    NSLog(@"shape layer frame %@", NSStringFromCGRect(shapeLayer.frame));
    NSLog(@"activeTextView frame %@", NSStringFromCGRect(activeTextView.frame));

    // Apply the new shape
    UIBezierPath *path = [self getCustomShapeForActiveTextWithType];
    if (path) {
        // Path is already in the correct coordinate space, no need for additional transform
        shapeLayer.path = path.CGPath;
    }

    // Reset corner radius and mask
    overlayView.layer.cornerRadius = 0;
    overlayView.layer.mask = nil;

    [activeTextView.layer setNeedsDisplay];
    [activeTextView setNeedsLayout];
    [activeTextView layoutIfNeeded];
}

- (UIBezierPath *)getCustomShapeForActiveTextWithType {
    UITextView *textView = [self findActiveTextView];
    if (!textView) return nil;
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    NSTextContainer *textContainer = textView.textContainer;
    UIEdgeInsets insets = textView.textContainerInset;
    
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
    CGRect usedRect = [layoutManager usedRectForTextContainer:textContainer];
    
    CGFloat padding = 8.0;
    
    // Calculate the shape in the text view's local coordinate space
    CGRect textFrameInTextView = CGRectMake(
        insets.left + usedRect.origin.x - padding,
        insets.top + usedRect.origin.y - padding,
        usedRect.size.width + 2 * padding,
        usedRect.size.height + 2 * padding
    );
    
    if (self.currentShape == OverlayShapeRectangle) {
        return [UIBezierPath bezierPathWithRect:textFrameInTextView];
        
    } else if (self.currentShape == OverlayShapeRoundedRectangle) {
        CGFloat cornerRadius = 12.0;
        return [UIBezierPath bezierPathWithRoundedRect:textFrameInTextView cornerRadius:cornerRadius];
        
    } else if (self.currentShape == OverlayShapeOval) {
        CGFloat cornerRadius = textFrameInTextView.size.height / 2;
        return [UIBezierPath bezierPathWithRoundedRect:textFrameInTextView cornerRadius:cornerRadius];
        
    } else if (self.currentShape == OverlayShapeCustomFrame) {
        // Custom shape: rounded rect per line
        NSMutableArray<NSValue *> *lineRects = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < glyphRange.length; i++) {
            NSRange range;
            CGRect lineRect = [layoutManager lineFragmentUsedRectForGlyphAtIndex:i effectiveRange:&range];
            if (!CGRectIsEmpty(lineRect)) {
                CGRect convertedRect = CGRectMake(
                    lineRect.origin.x + insets.left,
                    lineRect.origin.y + insets.top,
                    lineRect.size.width,
                    lineRect.size.height
                );
                [lineRects addObject:[NSValue valueWithCGRect:convertedRect]];
            }
        }
        
        UIBezierPath *compositePath = [UIBezierPath bezierPath];
        CGFloat cornerRadius = 10.0;
        
        for (NSValue *value in lineRects) {
            CGRect lineRect = [value CGRectValue];
            CGRect paddedRect = CGRectInset(lineRect, -padding, -padding);
            UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:paddedRect cornerRadius:cornerRadius];
            [compositePath appendPath:roundedRect];
        }
        
        return compositePath;
    }
    
    return nil; // unsupported shape type
}

//- (void)textViewDidChange:(UITextView *)textView {
//    NSLog(@"Textview: Did change called");
//    UITextInputMode *mode = textView.textInputMode;
//    NSLog(@"Input mode is now: %@", mode.primaryLanguage);
//    
//    frameIsEdited = YES;
//    
//    // Get the overlay view
//    UIView *overlayView = textView.superview;
//    if (!overlayView) return;
//    
//    // Step 1: Store the visual top-left point in the parent view's coordinate system (relative to sess.frame)
//    CGPoint originalTopLeft = overlayView.frame.origin; //[overlayView.superview convertPoint:overlayView.frame.origin fromView:overlayView.superview];
//    
//    // Step 2: Capture the current rotation and scale
//    CGAffineTransform currentTransform = overlayView.transform;
//    CGFloat rotation = atan2(currentTransform.b, currentTransform.a);
//    // Ensure self.currentScale is up-to-date
//    self.currentScale = sqrt(currentTransform.a * currentTransform.a + currentTransform.c * currentTransform.c);
//    
//    // Step 3: Calculate the new text size
//    CGFloat maxWidth = sess.frame.frame.size.width - 40;  // Leave padding on sides relative to sess.frame
//    CGFloat maxHeight = sess.frame.frame.size.height - 40; // Leave padding on top and bottom relative to sess.frame
//    
//    NSDictionary *textAttributes = @{
//        NSFontAttributeName: textView.font
//    };
//    
//    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(maxWidth / self.currentScale, maxHeight / self.currentScale)
//                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                               attributes:textAttributes
//                                                  context:nil].size;
//    
//    // Step 4: Calculate new dimensions for the text box and overlay view
//    CGFloat padding = 20; // Padding around the text box
//    CGFloat newTextBoxWidth = MIN(textSize.width + padding, maxWidth / self.currentScale);
//    CGFloat newTextBoxHeight = MIN(textSize.height + padding, maxHeight / self.currentScale);
//    
//    CGFloat newOverlayWidth = newTextBoxWidth + padding;  // Add additional padding for the overlay
//    CGFloat newOverlayHeight = newTextBoxHeight + padding;
//    
//    // Step 5: Reset transform to identity for frame adjustments
//    overlayView.transform = CGAffineTransformIdentity;
//    
//    // Step 6: Resize the text box and overlay view
//    [UIView animateWithDuration:0.1 animations:^{
//        // Resize the text box
//        textView.frame = CGRectMake(padding / 2, padding / 2, newTextBoxWidth, newTextBoxHeight);
//        
//        // Resize the overlay view, keeping the top-left aligned
//        overlayView.frame = CGRectMake(originalTopLeft.x, originalTopLeft.y, newOverlayWidth, newOverlayHeight);
//        
//        // Center the text box within the overlay view
//        textView.center = CGPointMake(CGRectGetMidX(overlayView.bounds), CGRectGetMidY(overlayView.bounds));
//        
//        // Step 7: Reapply scale and rotation
//        overlayView.transform = CGAffineTransformMakeScale(self.currentScale, self.currentScale);
//        overlayView.transform = CGAffineTransformRotate(overlayView.transform, rotation);
//        
//        // Step 8: Adjust frame origin to keep the visual top-left at the original position
//        CGPoint newTopLeft = [overlayView.superview convertPoint:overlayView.frame.origin fromView:overlayView.superview];
//        CGPoint offset = CGPointMake(originalTopLeft.x - newTopLeft.x, originalTopLeft.y - newTopLeft.y);
//        overlayView.frame = CGRectOffset(overlayView.frame, offset.x, offset.y);
//        
//        // Step 9: Ensure the overlay view stays within sess.frame bounds
//        // Calculate the scaled size of the overlayView
//        CGFloat scaledWidth = newOverlayWidth * self.currentScale;
//        CGFloat scaledHeight = newOverlayHeight * self.currentScale;
//        
//        // Define the bounds constraints based on sess.frame
//        CGFloat minX = sess.frame.frame.origin.x;
//        CGFloat minY = sess.frame.frame.origin.y;
//        CGFloat maxX = sess.frame.frame.origin.x + sess.frame.frame.size.width - scaledWidth;
//        CGFloat maxY = sess.frame.frame.origin.y + sess.frame.frame.size.height - scaledHeight;
//        
//        // Clamp the frame's origin to keep the entire scaled overlayView within sess.frame
//        CGRect newOverlayFrame = overlayView.frame;
//        if (newOverlayFrame.origin.x < minX) newOverlayFrame.origin.x = minX;
//        if (newOverlayFrame.origin.y < minY) newOverlayFrame.origin.y = minY;
//        if (newOverlayFrame.origin.x > maxX) newOverlayFrame.origin.x = maxX;
//        if (newOverlayFrame.origin.y > maxY) newOverlayFrame.origin.y = maxY;
//        
//        overlayView.frame = newOverlayFrame;
//    }];
//    
//    // Step 10: Update the shape layer
//    [self applyShapeToActiveTextView];
//}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"Textview: Did begin Editing called");
    NSLog(@"textview begin editing re_Align");
    [self reAlignUI];
    self.lastActiveTextView = textView;

    // Get the overlay view
    UIView *overlayView = textView.superview;
    if (!overlayView) return;

    // Step 1: Update self.currentScale from the current transform
    CGAffineTransform currentTransform = overlayView.transform;
    self.currentScale = sqrt(currentTransform.a * currentTransform.a + currentTransform.c * currentTransform.c);
    // Store rotation for consistency (optional, used in :)
    CGFloat rotation = atan2(currentTransform.b, currentTransform.a);

    // Step 2: Update the slider value to match the font size
    fontSizeSlider.value = textView.font ? textView.font.pointSize : 16;

    // Step 3: Show placeholder text if empty (no frame adjustment here)
    if (textView.text.length == 0) {
        textView.text = @"Enter Text";
        textView.textColor = [UIColor whiteColor];
    }

    // Step 4: Retrieve and update the shape layer
    CAShapeLayer *shapeLayer = [self findCAShapeLayerInView:overlayView];
    if (shapeLayer) {
        selectedOverlayColor = [UIColor colorWithCGColor:shapeLayer.fillColor];
    }

    // Step 5: Update the shape layer to match the current transform
    [self applyShapeToActiveTextView];

    // Step 6: Set cursor to the beginning
    UITextRange *beginning = [textView textRangeFromPosition:textView.beginningOfDocument
                                                  toPosition:textView.beginningOfDocument];
    textView.selectedTextRange = beginning;

    // Step 7: Show toolbar and slider
    uitoolbar.hidden = NO;
    fontSizeSlider.hidden = NO;
    [mainBackground bringSubviewToFront:self.fontSizeSlider];
    textEditorSubviewAdded = YES;

    // Step 8: Add border to indicate active state
    textView.layer.borderWidth = 2;
    textView.layer.borderColor = [UIColor clearColor].CGColor;

    // Step 9: Update UserDefaults
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fromText"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 1
//- (void)textViewDidChange:(UITextView *)textView {
//    NSLog(@"Textview: Did change called");
//    
//    // Prevent infinite recursion
//    if (self.isResizingTextView) return;
//    self.isResizingTextView = YES;
//    
//    frameIsEdited = YES;
//    
//    UIView *overlayView = textView.superview;
//    if (!overlayView) {
//        self.isResizingTextView = NO;
//        return;
//    }
//    
//    // Save current state
//    CGPoint originalCenter = overlayView.center;
//    CGAffineTransform originalTransform = overlayView.transform;
//    
//    // Remove transform temporarily for accurate sizing
//    overlayView.transform = CGAffineTransformIdentity;
//    
//    // Calculate text size WITHOUT considering scale
//    CGFloat maxWidth = self.view.bounds.size.width - 40;
//    CGFloat maxHeight = self.view.bounds.size.height - 40;
//    
//    NSDictionary *textAttributes = @{NSFontAttributeName: textView.font};
//    
//    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
//                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                               attributes:textAttributes
//                                                  context:nil].size;
//    
//    // Add padding
//    CGFloat padding = 20;
//    CGFloat newTextBoxWidth = MIN(textSize.width + padding, maxWidth);
//    CGFloat newTextBoxHeight = MIN(textSize.height + padding, maxHeight);
//    
//    // Minimum size to prevent collapse
//    newTextBoxWidth = MAX(newTextBoxWidth, 60);
//    newTextBoxHeight = MAX(newTextBoxHeight, 40);
//    
//    // Only resize if there's a significant change (prevent jitter)
//    CGFloat widthDifference = fabs(textView.frame.size.width - newTextBoxWidth);
//    CGFloat heightDifference = fabs(textView.frame.size.height - newTextBoxHeight);
//    
//    if (widthDifference > 2.0 || heightDifference > 2.0) {
//        [UIView animateWithDuration:0.1 animations:^{
//            // Resize text view
//            textView.frame = CGRectMake(textView.frame.origin.x,
//                                      textView.frame.origin.y,
//                                      newTextBoxWidth,
//                                      newTextBoxHeight);
//            
//            // Resize overlay to match text view with additional padding
//            CGFloat overlayPadding = 20;
//            overlayView.bounds = CGRectMake(0, 0,
//                                          newTextBoxWidth + overlayPadding,
//                                          newTextBoxHeight + overlayPadding);
//            
//            // Center text view within overlay
//            textView.center = CGPointMake(CGRectGetMidX(overlayView.bounds),
//                                        CGRectGetMidY(overlayView.bounds));
//            
//            // Restore center and transform
//            overlayView.center = originalCenter;
//            overlayView.transform = originalTransform;
//        }];
//    } else {
//        // No significant size change, just restore transform
//        overlayView.transform = originalTransform;
//    }
//    
//    // Ensure the overlay stays within bounds
//    [self ensureOverlayStaysInBounds:overlayView];
//    
//    // Update shape
//    [self applyShapeToActiveTextView];
//    
//    // Reset flag after a delay to prevent rapid consecutive calls
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.isResizingTextView = NO;
//    });
//}


/// 2
//- (void)textViewDidChange:(UITextView *)textView {
//    NSLog(@"Textview: Did change called");
//    frameIsEdited = YES;
//    
//    UIView *overlayView = textView.superview;
//    if (!overlayView) return;
//    
//    // Get the ACTUAL current scale from the transform (not stored variable)
//    CGFloat currentScale = sqrt(overlayView.transform.a * overlayView.transform.a +
//                               overlayView.transform.c * overlayView.transform.c);
//    
//    // Get current rotation
//    CGFloat rotation = atan2(overlayView.transform.b, overlayView.transform.a);
//    
//    // Calculate text size in UNTRANSFORMED space
//    CGFloat maxWidth = self.view.bounds.size.width - 40;
//    CGFloat maxHeight = self.view.bounds.size.height - 40;
//    
//    NSDictionary *textAttributes = @{NSFontAttributeName: textView.font};
//    
//    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
//                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                               attributes:textAttributes
//                                                  context:nil].size;
//    
//    // Calculate new dimensions (in untransformed space)
//    CGFloat padding = 20;
//    CGFloat newTextBoxWidth = MIN(textSize.width + padding, maxWidth);
//    CGFloat newTextBoxHeight = MIN(textSize.height + padding, maxHeight);
//    
//    CGFloat newOverlayWidth = newTextBoxWidth + padding;
//    CGFloat newOverlayHeight = newTextBoxHeight + padding;
//    
//    // Save current center position (in superview coordinates)
//    CGPoint currentCenter = overlayView.center;
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        // Remove transform temporarily for resizing
//        overlayView.transform = CGAffineTransformIdentity;
//        
//        // Resize the views
//        textView.frame = CGRectMake(0, 0, newTextBoxWidth, newTextBoxHeight);
//        overlayView.bounds = CGRectMake(0, 0, newOverlayWidth, newOverlayHeight);
//        
//        // Center text view within overlay
//        textView.center = CGPointMake(CGRectGetMidX(overlayView.bounds),
//                                     CGRectGetMidY(overlayView.bounds));
//        
//        // Restore original center position
//        overlayView.center = currentCenter;
//        
//        // Reapply transforms
//        overlayView.transform = CGAffineTransformMakeScale(currentScale, currentScale);
//        overlayView.transform = CGAffineTransformRotate(overlayView.transform, rotation);
//    }];
//    
//    // Apply bounds checking AFTER animation
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self ensureOverlayStaysInBounds:overlayView];
//    });
//    
//    [self applyShapeToActiveTextView];
//}

- (void)ensureOverlayStaysInBounds:(UIView *)overlayView {
    // Get the actual transformed size
    CGRect transformedBounds = CGRectApplyAffineTransform(overlayView.bounds, overlayView.transform);
    CGSize transformedSize = transformedBounds.size;
    
    CGFloat maxX = self.view.bounds.size.width - transformedSize.width;
    CGFloat maxY = self.view.bounds.size.height - transformedSize.height;
    
    CGPoint newCenter = overlayView.center;
    
    // Restrict position
    if (newCenter.x - transformedSize.width/2 < 0)
        newCenter.x = transformedSize.width/2;
    if (newCenter.y - transformedSize.height/2 < 0)
        newCenter.y = transformedSize.height/2;
    if (newCenter.x + transformedSize.width/2 > self.view.bounds.size.width)
        newCenter.x = self.view.bounds.size.width - transformedSize.width/2;
    if (newCenter.y + transformedSize.height/2 > self.view.bounds.size.height)
        newCenter.y = self.view.bounds.size.height - transformedSize.height/2;
    
    overlayView.center = newCenter;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"Textview: Did End Editing called");
    UIView *container = textView.superview;
    if (!container) return;
    
    // If the text box is empty or contains the placeholder text, delete it
    if (textView.text.length == 0 || [textView.text isEqualToString:@"Enter Text"]) {
        [container removeFromSuperview];
        NSLog(@"did remove textview");
        [self.textBoxes removeObject:container];
        self.lastActiveTextView = nil;
        return; // Exit early if we're deleting
    }
    
    // Save current transform and center
    CGAffineTransform currentTransform = container.transform;
    CGPoint currentCenter = container.center;
    
    // Remove transform temporarily for accurate sizing
    container.transform = CGAffineTransformIdentity;
    
    // Calculate container size with padding
    CGFloat padding = 8.0;
    CGSize containerSize = CGSizeMake(
        textView.frame.size.width + (padding * 2),
        textView.frame.size.height + (padding * 2)
    );
    
    // Center text view in container (in container's coordinate space)
    textView.frame = CGRectMake(
        padding,
        padding,
        textView.frame.size.width,
        textView.frame.size.height
    );
    
    // Update container bounds (not frame) to avoid transform issues
    CGRect oldBounds = container.bounds;
    container.bounds = CGRectMake(0, 0, containerSize.width, containerSize.height);
    
    // Restore transform and center
    container.transform = currentTransform;
    container.center = currentCenter;
    
    // Apply shape after resizing
    [self applyShapeToActiveTextView];
    
    NSLog(@"Container frame after editing: %@", NSStringFromCGRect(container.frame));
    NSLog(@"Container bounds after editing: %@", NSStringFromCGRect(container.bounds));
}

#pragma mark - Photo Selection Feature

- (void)handlePhotoSlotSelected:(NSNotification *)notification
{
    NSLog(@"Photo slot selected notification received");

    NSDictionary *userInfo = notification.userInfo;
    NSNumber *photoIndexNum = [userInfo objectForKey:@"photoIndex"];

    if (photoIndexNum) {
        int photoIndex = [photoIndexNum intValue];
        NSLog(@"Selected photo index: %d", photoIndex);

        self.currentSelectedPhotoIndex = photoIndex;
        self.isInPhotoSelectionMode = YES;

        // Apply green outline
        [sess enterPhotoSelectionMode:photoIndex];

        // Show PhotoActionViewController
        [self showPhotoActionViewController];
    }
}

- (void)handleSelectImageForPhoto:(NSNotification *)notification
{
    NSLog(@"handleSelectImageForPhoto called");
    Photo *photo = notification.object;
    if (photo) {
        int photoIndex = photo.photoNumber;
        NSLog(@"Selected photo index from selectImageForPhoto: %d", photoIndex);

        self.currentSelectedPhotoIndex = photoIndex;
        self.isInPhotoSelectionMode = YES;

        // Apply green border and enable selection mode
        [sess enterPhotoSelectionMode:photoIndex];

        // Show PhotoActionViewController
        [self showPhotoActionViewController];
    }
}

- (void)handleEditImageForPhoto:(NSNotification *)notification
{
    NSLog(@"handleEditImageForPhoto called");
    Photo *photo = notification.object;
    if (photo) {
        int photoIndex = photo.photoNumber;
        NSLog(@"Selected photo index from editImageForPhoto: %d", photoIndex);

        self.currentSelectedPhotoIndex = photoIndex;
        self.isInPhotoSelectionMode = YES;

        // Apply green border and enable selection mode
        [sess enterPhotoSelectionMode:photoIndex];

        // Show PhotoActionViewController
        [self showPhotoActionViewController];
    }
}

- (void)showPhotoActionViewController
{
    NSLog(@"Showing PhotoActionViewController");

    // CRITICAL FIX: Ensure optionsView is visible!
    optionsView.view.hidden = NO;

    // Remove existing child view controllers from options container
    [self removeOptionsChildViewController];

    // Create and add PhotoActionViewController
    if (!self.photoActionVC) {
        self.photoActionVC = [[PhotoActionViewController alloc] init];
    }

    // CORRECT: Add as child of optionsView, not self (MainController)
    [optionsView addChildViewController:self.photoActionVC];
    [optionsView.view addSubview:self.photoActionVC.view];
    self.photoActionVC.view.frame = optionsView.view.bounds;
    [self.photoActionVC didMoveToParentViewController:optionsView];
}

- (void)handlePhotoActionSelected:(NSNotification *)notification
{
    NSLog(@"Photo action selected notification received");

    NSDictionary *userInfo = notification.userInfo;
    NSString *action = [userInfo objectForKey:@"action"];

    if ([action isEqualToString:@"Replace"]) {
        NSLog(@"Replace action selected");
        [self handleReplaceAction];
    }
    else if ([action isEqualToString:@"Adjust"]) {
        NSLog(@"Adjust action selected");
        [self showAdjustOptionsViewController];
    }
    else if ([action isEqualToString:@"Delete"]) {
        NSLog(@"Delete action selected");
        [self handleDeleteAction];
    }
    else if ([action isEqualToString:@"Mute"]) {
        NSLog(@"Mute action selected");
        [self toggleVideoMuteStatus:self.currentSelectedPhotoIndex];
    }
}

- (void)handleReplaceAction
{
    NSLog(@"Handling replace action for photo index: %d", self.currentSelectedPhotoIndex);

    // Exit photo selection mode
    [sess exitPhotoSelectionMode];
    self.isInPhotoSelectionMode = NO;

    // Set the current photo index for replacement
    currentSelectedPhotoNumberForEffect = self.currentSelectedPhotoIndex;

    // Trigger photo/video selection - post notification that existing code handles
    [[NSNotificationCenter defaultCenter] postNotificationName:selectImageForPhoto
                                                        object:nil
                                                      userInfo:nil];

    // Go back to main options
    [self showMainOptionsViewController];
}

- (void)handleDeleteAction
{
    NSLog(@"Handling delete action for photo index: %d", self.currentSelectedPhotoIndex);

    // Get the photo at the selected index
    Photo *pht = [sess.frame getPhotoAtIndex:self.currentSelectedPhotoIndex];
    if (pht) {
        // Clear the photo/video
        [pht setTheImageToBlank];
        [sess deleteImageOfFrame:self.currentSelectedPhotoIndex frame:0];

        // If it's a video, delete video resources
        if (pht.isContentTypeVideo) {
            [sess deleteVideoAtPhototIndex:self.currentSelectedPhotoIndex];
            [sess deleteVideoFramesForPhotoAtIndex:self.currentSelectedPhotoIndex];
        }

        NSLog(@"Photo/video deleted at index: %d", self.currentSelectedPhotoIndex);
    }

    // Exit photo selection mode
    [sess exitPhotoSelectionMode];
    self.isInPhotoSelectionMode = NO;

    // Go back to main options
    [self showMainOptionsViewController];
}

- (void)showAdjustOptionsViewController
{
    NSLog(@"Showing AdjustOptionsViewController");

    // Remove current child view controller
    [self removeOptionsChildViewController];

    // Create and add AdjustOptionsViewController
    if (!self.adjustOptionsVC) {
        self.adjustOptionsVC = [[AdjustOptionsViewController alloc] init];
    }

    [self addChildViewController:self.adjustOptionsVC];
    [optionsView.view addSubview:self.adjustOptionsVC.view];
    self.adjustOptionsVC.view.frame = optionsView.view.bounds;
    [self.adjustOptionsVC didMoveToParentViewController:self];
}

- (void)handleAdjustActionSelected:(NSNotification *)notification
{
    NSLog(@"Adjust action selected notification received");

    NSDictionary *userInfo = notification.userInfo;
    NSString *action = [userInfo objectForKey:@"action"];

    if ([action isEqualToString:@"Speed"]) {
        NSLog(@"Speed action selected");
        [self showSpeedViewController];
    }
    else if ([action isEqualToString:@"Trim"]) {
        NSLog(@"Trim action selected");
        [self showTrimViewController];
    }
}

- (void)showSpeedViewController
{
    NSLog(@"Showing SpeedViewController");

    // Check if selected slot has a video
    Photo *pht = [sess.frame getPhotoAtIndex:self.currentSelectedPhotoIndex];
    if (!pht || !pht.isContentTypeVideo) {
        NSLog(@"Selected slot does not contain a video");
        // Show alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not a Video"
                                                                        message:@"Speed adjustment only works for videos."
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    // Remove current child view controller
    [self removeOptionsChildViewController];

    // Create and add SpeedViewController
    if (!self.speedVC) {
        self.speedVC = [[SpeedViewController alloc] init];
    }

    // Set current speed if available
    if (pht.videoSpeed > 0) {
        [self.speedVC setSpeed:pht.videoSpeed];
    }

    [self addChildViewController:self.speedVC];
    [optionsView.view addSubview:self.speedVC.view];
    self.speedVC.view.frame = optionsView.view.bounds;
    [self.speedVC didMoveToParentViewController:self];
}

- (void)showTrimViewController
{
    NSLog(@"Showing TrimViewController");

    // Check if selected slot has a video
    Photo *pht = [sess.frame getPhotoAtIndex:self.currentSelectedPhotoIndex];
    if (!pht || !pht.isContentTypeVideo) {
        NSLog(@"Selected slot does not contain a video");
        // Show alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not a Video"
                                                                        message:@"Trim only works for videos."
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    // Remove current child view controller
    [self removeOptionsChildViewController];

    // Create and add TrimViewController
    if (!self.trimVC) {
        self.trimVC = [[TrimViewController alloc] init];
    }

    // Get video duration
    double duration = [sess getVideoDurationForPhotoAtIndex:self.currentSelectedPhotoIndex];
    [self.trimVC setVideoDuration:duration];

    // Set current trim range if available
    if (pht.videoTrimStart >= 0 && pht.videoTrimEnd > 0) {
        [self.trimVC setTrimRangeWithStart:pht.videoTrimStart end:pht.videoTrimEnd];
    }

    [self addChildViewController:self.trimVC];
    [optionsView.view addSubview:self.trimVC.view];
    self.trimVC.view.frame = optionsView.view.bounds;
    [self.trimVC didMoveToParentViewController:self];
}

- (void)handleAdjustOptionsBack:(NSNotification *)notification
{
    NSLog(@"Adjust options back button tapped");

    // Go back to PhotoActionViewController
    [self showPhotoActionViewController];
}

- (void)handleSpeedViewBack:(NSNotification *)notification
{
    NSLog(@"Speed view back button tapped");

    // Go back to AdjustOptionsViewController
    [self showAdjustOptionsViewController];
}

- (void)handleTrimViewBack:(NSNotification *)notification
{
    NSLog(@"Trim view back button tapped");

    // Go back to AdjustOptionsViewController
    [self showAdjustOptionsViewController];
}

- (void)handleSpeedChanged:(NSNotification *)notification
{
    NSLog(@"Speed changed notification received");

    NSDictionary *userInfo = notification.userInfo;
    NSNumber *speedNum = [userInfo objectForKey:@"speed"];

    if (speedNum) {
        float speed = [speedNum floatValue];
        NSLog(@"New speed: %.2fx", speed);

        // Apply speed to the video
        Photo *pht = [sess.frame getPhotoAtIndex:self.currentSelectedPhotoIndex];
        if (pht && pht.isContentTypeVideo) {
            pht.videoSpeed = speed;
            [pht applyVideoSpeed:speed];
            NSLog(@"Speed applied to video at index: %d", self.currentSelectedPhotoIndex);
        }
    }
}

- (void)handleVideoTrimmed:(NSNotification *)notification
{
    NSLog(@"Video trimmed notification received");

    NSDictionary *userInfo = notification.userInfo;
    NSNumber *startTimeNum = [userInfo objectForKey:@"startTime"];
    NSNumber *endTimeNum = [userInfo objectForKey:@"endTime"];

    if (startTimeNum && endTimeNum) {
        double startTime = [startTimeNum doubleValue];
        double endTime = [endTimeNum doubleValue];
        NSLog(@"Trim range: %.2f to %.2f", startTime, endTime);

        // Apply trim to the video
        Photo *pht = [sess.frame getPhotoAtIndex:self.currentSelectedPhotoIndex];
        if (pht && pht.isContentTypeVideo) {
            pht.videoTrimStart = startTime;
            pht.videoTrimEnd = endTime;
            [pht applyVideoTrimWithStart:startTime end:endTime];
            NSLog(@"Trim applied to video at index: %d", self.currentSelectedPhotoIndex);
        }
    }
}

- (void)showMainOptionsViewController
{
    NSLog(@"Showing main OptionsViewController");

    // Exit photo selection mode
    if (self.isInPhotoSelectionMode) {
        [sess exitPhotoSelectionMode];
        self.isInPhotoSelectionMode = NO;
    }

    // Remove current child view controller
    [self removeOptionsChildViewController];

    // Re-add the main OptionsViewController
    [self addChildViewController:optionsView];
    [optionsView.view.superview addSubview:optionsView.view];
    optionsView.view.frame = optionsView.view.superview.bounds;
    [optionsView didMoveToParentViewController:self];
}

- (void)removeOptionsChildViewController
{
    // Remove all child view controllers from optionsView
    for (UIViewController *childVC in [self.childViewControllers copy]) {
        if ([childVC isKindOfClass:[PhotoActionViewController class]] ||
            [childVC isKindOfClass:[AdjustOptionsViewController class]] ||
            [childVC isKindOfClass:[SpeedViewController class]] ||
            [childVC isKindOfClass:[TrimViewController class]] ||
            [childVC isKindOfClass:NSClassFromString(@"OptionsViewController")] ||
            [childVC isKindOfClass:NSClassFromString(@"EditOptionsViewController")]) {

            [childVC willMoveToParentViewController:nil];
            [childVC.view removeFromSuperview];
            [childVC removeFromParentViewController];
        }
    }
}

@end
