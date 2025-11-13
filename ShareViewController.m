//
//  ShareViewController.m
//  VideoFrames
//
//  Created by Deepti's Mac on 1/24/14.
//
//

#import "ShareViewController.h"
#import "Config.h"
#import <MediaPlayer/MediaPlayer.h>
#import "OT_TabBar.h"
#import "VideoUploadHandler.h"
#import "UploadHandler.h"
#import "Appirater.h"
#import "Photo.h"
#import "WCAlertView.h"
//#import "UniversalLayout.h"
#import "SimpleSubscriptionView.h"
#import <Firebase/Firebase.h>
#import "MainController.h"

#define videoPlayButtonTag 987677
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ShareViewController ()<OT_TabBarDelegate,MBProgressHUDDelegate>
{
    OT_TabBar *_customTabBar,*customTabbarback;
    VideoUploadHandler *vHandler ;
    //YouTubeHelper * youtubeUploader;
    MBProgressHUD *HUD;
    ShareViewController*shareViewRemove;
    
    SimpleSubscriptionView *SubscriptionView2;
    BOOL playerFinishedPlaying;
    //ExpiryStatus//
    NSUserDefaults *prefsTime;
    NSUserDefaults *prefsDate;
    
    int savingCountLimitIs;
    BOOL savedOnceImage;
    
    GADAdValuePrecision precision;
    UIImageView * Resume_view;
    
//    UIView *rateUsBgview;
//   // UIImageView *rateUsview;
//    NSInteger rateUsValue;
    
    NSInteger sharePageVisitCount;
    UIView *topToolBar;
}
//@property (nonatomic, retain) MPMoviePlayerViewController *_playerViewController;
@end

@implementation ShareViewController
@synthesize frameSize;
@synthesize videoPath;
@synthesize isVideo;
@synthesize sess;
//@synthesize  _playerViewController;
@synthesize play;
@synthesize player;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    SuccessStatus = [NSUserDefaults standardUserDefaults];
    
    [super viewDidAppear:animated];
    NSLog(@"Checking ExpiryHere share view controller -------");
    [[SRSubscriptionModel shareKit]loadProducts]; // newly added here
    [[SRSubscriptionModel shareKit]CheckingExpiryHere];
    
    if (![[SRSubscriptionModel shareKit]IsAppSubscribed]) {
       
        NSUserDefaults *prefsSession = [NSUserDefaults standardUserDefaults];
        [prefsSession setInteger:0 forKey:@"SubscriptionSessionExpired"];
    }
   
    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillEnterForegroundNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
    }
    
  //  [self.view bringSubviewToFront:_customTabBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    if (@available(iOS 11.0, *)) {
           [self setNeedsUpdateOfHomeIndicatorAutoHidden];
       }
    
    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        NSLog(@"Removing here---------");
        if(removeWaterMark!=nil)
        {
        [removeWaterMark removeFromSuperview];
            removeWaterMark = nil;
            NSLog(@"Removing here---------2");
        }
        [self removeWaterMarkFromFrame];
    }
    
//    else if (([SuccessStatus integerForKey:@"PurchasedYES"] == 1))
//    {
//        if(removeWaterMark!=nil)
//        {
//        [removeWaterMark removeFromSuperview];
//            removeWaterMark = nil;
//            NSLog(@"Removing here---------2");
//        }
//    }

    
    NSLog(@"viewDidAppear");
     NSLog(@"KpkShare---------");
    
    
}
-(BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}


- (void)viewDidLoad
{
    
    //Create a custom back button with your image
   UIImage *backButtonImage = [UIImage imageNamed:@"back_svg"]; // Ensure this image exists in your assets
   UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(goBack)];
   // Set the custom back button as the left bar button item
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self settingTouchViewUnHided];
    
    [self loadInterstitial2];
    
    [self gettingShareVisitCount];
    [self gettingInterestialCount];
    
    savedOnceImage = NO;
    
    //For Subscription Expiry Status
      prefsTime = [NSUserDefaults standardUserDefaults];
        prefsDate= [NSUserDefaults standardUserDefaults];
    
    if (NO == bought_allfeaturespack)
    {
        //[self addPreLoad];
       // [self showInterstitial];
        
        NSLog(@"Product Not purchased-------");
    }
    else
    {
        NSLog(@"Product purchased-------");
    }
   
    [self setNeedsStatusBarAppearanceUpdate]; // Refresh the status bar visibility
    [super viewDidLoad];
    
  //  youtubeUploader=[[YouTubeHelper alloc]initWithDelegate:self];
    
    nvm = [Settings Instance];
    nvm.noAdMode = YES;
    
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView . frame = CGRectMake(0, 0, full_screen.size.width, full_screen.size.height);
    backgroundView . backgroundColor =[UIColor colorWithRed:48.0f/255.0f green:51.0f/255.0f blue:58.0f/255.0f alpha:1.0f];
    backgroundView . userInteractionEnabled = YES;
    [self.view addSubview:backgroundView];
    [self.view bringSubviewToFront:backgroundView];
   // [backgroundView release];

    
    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && full_screen.size.height>480) {
        // backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"background_1136@2x" ofType:@"png"]];
    }
    if(isVideo)
    {
        NSLog(@"VIdeo pathis $$$$ %@",videoPath);
        [self avplayerview:[NSURL fileURLWithPath:videoPath]];
        NSLog(@"VIdeo pathis----%@",videoPath);
    }
    else
    {
        [self ForImageviewAllocation];
        NSLog(@"Imagepreview---");
    }
    self.title = @"Share";
   // [self allocateResourcesForTopToolBar];
    
    
    self.view.backgroundColor = [UIColor whiteColor];

       // Create a right bar button item with an image named "Home"
       UIImage *homeImage = [UIImage imageNamed:@"Home"];
       UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:homeImage
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(movingToHomePage)];

       // Set the tint color of the bar button item (optional)
       homeButton.tintColor = [UIColor whiteColor]; // Change to your preferred color

       // Set the right bar button item
       self.navigationItem.rightBarButtonItem = homeButton;
    
    [self allocateToolBarForShareOptions];
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [self RemoveWaterMarkButton];
        NSLog(@"Watermark is adding---");
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeWaterMarkHere) name:@"ClearAllLocksHere" object:nil];
    
    [self gettingRemoteCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gettingSavingValueHere) name:@"ImageSavedOnce" object:nil];
    
    //Lock Ads here//
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveView) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Resumepage) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
//    [self showRateUsPanel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLockedItems) name:@"removeSubscriptionPage" object:nil];
}

-(void)removeLockedItems
{
    [Resume_view removeFromSuperview];
    Resume_view = nil;
    [removeWaterMark removeFromSuperview];
    removeWaterMark = nil;
}

-(void)gettingShareVisitCount
{
     sharePageVisitCount = [userDefaultForLimitSave integerForKey:@"SharePageVisitCount"];
    NSLog(@"share Page Visit Count is in main controller %ld ",sharePageVisitCount);
   
}

-(void)ForImageviewAllocation
{
    UIImageView *playerView = [[UIImageView alloc] init];
    playerView . userInteractionEnabled = YES;
    playerView . backgroundColor = [UIColor clearColor];
    playerView.layer.shadowColor=[UIColor blueColor].CGColor;
    playerView.layer.shadowOffset  = CGSizeMake(2.0, 2.0);
//    float ratio = full_screen.size.width/nvm.uploadSize.width;
//    playerView.frame = CGRectMake(0, 0, nvm.uploadSize.width*ratio, nvm.uploadSize.height*ratio);
    playerView.frame = CGRectMake(0, 0, sess.frame.frame.size.width,sess.frame.frame.size.height);
    playerView.center = CGPointMake(full_screen.size.width/2, full_screen.size.height/2);
    [self.view addSubview:playerView];
   // [playerView release];
    NSLog(@"ForImageviewAllocation width %f height %f screen width is %f ",nvm.uploadSize.width,nvm.uploadSize.height,fullScreen.size.width);
    playerView.image = [sess.frame renderToImageOfSize:nvm.uploadSize];
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [self addWaterMarkToFrame:playerView];
    }
}


-(void)movingToHomePage
{
//    [picked_Number_defaults setBool:NO forKey:@"pickedImageNumber"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetFrameView" object:nil];
    sharePageVisitCount = [userDefaultForLimitSave integerForKey:@"SharePageVisitCount"];
    [userDefaultForLimitSave setInteger:sharePageVisitCount+1 forKey:@"SharePageVisitCount"];
    sharePageVisitCount = [userDefaultForLimitSave integerForKey:@"SharePageVisitCount"];

    NSLog(@"share Page Visit Count is in share view controller %ld ",sharePageVisitCount);
    [Appirater userDidSignificantEvent:YES];
    nvm.noAdMode = NO;
    [self pauseThePlayer];
//    [_playerViewController.view removeFromSuperview];
//    [_playerViewController release];
//    _playerViewController = nil;
    
//    [self removeNotification];
    
    if (vHandler!= nil) {
     //   [vHandler release];
        vHandler = nil;
    }
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)goBack
{
    sharePageVisitCount = [userDefaultForLimitSave integerForKey:@"SharePageVisitCount"];
    [userDefaultForLimitSave setInteger:sharePageVisitCount+1 forKey:@"SharePageVisitCount"];
    sharePageVisitCount = [userDefaultForLimitSave integerForKey:@"SharePageVisitCount"];
  
    
    NSLog(@"share Page Visit Count is in share view controller %ld ",sharePageVisitCount);
    [Appirater userDidSignificantEvent:YES];
    nvm.noAdMode = NO;
    [self pauseThePlayer];
//    [_playerViewController.view removeFromSuperview];
//    [_playerViewController release];
//    _playerViewController = nil;
    
//    [self removeNotification];
    
    if (vHandler!= nil) {
     //   [vHandler release];
        vHandler = nil;
    }
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnhideBackButton" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetStickersParent" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnableTheRightTabBarButton" object:nil];
}



-(void)appBecameActive
{
    NSLog(@" shareview > >app Became Active");
    self.navigationController.navigationBar.hidden = NO;
    if(playerFinishedPlaying)
    {
        playerFinishedPlaying = NO;
        [self reloadVideo];
    }
    else
    {
        [play setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}


- (void)allocateToolBarForShareOptions
{
    if (_customTabBar != nil)
    {
        [_customTabBar removeFromSuperview];
        _customTabBar = nil;
    }
    
    //Curvy background strips
    customTabbarback = [[OT_TabBar alloc]initWithFrame:CGRectMake(0,full_screen.size.height-35,full_screen.size.width,35)];
   
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        customTabbarback . frame = CGRectMake(0, full_screen.size.height-24, full_screen.size.width, 24);
    }
    customTabbarback.delegate = self;
    customTabbarback.backgroundColor = PHOTO_DEFAULT_COLOR;
   // _customTabBar.backgroundColor = PHOTO_DEFAULT_COLOR;
    customTabbarback.showOverlayOnSelection = NO;
    
    [self.view addSubview:customTabbarback];
 //   [customTabbarback release];
    CGFloat safeAreaBottom = 0;

    if (@available(iOS 11.0, *)) {
        safeAreaBottom = KeyWindow.safeAreaInsets.bottom;
    }
    // safe area here//
     if (@available(iOS 11.0, *))
     {
         if (safeAreaBottom > 0)
         {
             CGRect rect = CGRectMake(0, full_screen.size.height-70-safeAreaBottom/2, full_screen.size.width, 70);
             _customTabBar = [[OT_TabBar alloc]initWithFrame:rect];
         }
         else
         {
             CGRect rect = CGRectMake(0, full_screen.size.height-70, full_screen.size.width, 70);
             _customTabBar = [[OT_TabBar alloc]initWithFrame:rect];
         }
     }
     else
     {
        CGRect rect = CGRectMake(0, full_screen.size.height-70, full_screen.size.width, 70);
        _customTabBar = [[OT_TabBar alloc]initWithFrame:rect];
        
     }
    _customTabBar.layer.cornerRadius = 20;
    _customTabBar.tag = 333;
    
    OT_TabBarItem *album = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"album2"]
                                                 selectedImage:[UIImage imageNamed:@"album_active2"]
                                                           tag:11];
    
    OT_TabBarItem *share = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"share2"]
                                                 selectedImage:[UIImage imageNamed:@"share_active2"]
                                                           tag:12];
    
//    OT_TabBarItem *facebook = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"fb2"]
//                                                    selectedImage:[UIImage imageNamed:@"fb_active2"]
//                                                              tag:13];
//
//    OT_TabBarItem *instagram = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"instagram2"]
//                                                     selectedImage:[UIImage imageNamed:@"instagram_active2"]
//                                                               tag:14];
//
  //  OT_TabBarItem *viddy = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"viddy1"]
                                              //   selectedImage:[UIImage imageNamed:@"viddy"]
                                                         //  tag:15];
    
  //  OT_TabBarItem *copyToclipboard = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"clipboard1"]
                                                        //   selectedImage:[UIImage imageNamed:@"clipboard"]
                                                                     //tag:15];
    
   // OT_TabBarItem *youtube = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"youtube1"]
                                                   //selectedImage:[UIImage imageNamed:@"youtube"]
                                                            // tag:16];
    
    _customTabBar.showOverlayOnSelection = NO;
    _customTabBar.backgroundColor = PHOTO_DEFAULT_COLOR;
    _customTabBar.delegate        = self;
    
    if (isVideo)
    {
        _customTabBar.itemTitleArray = [NSArray arrayWithObjects:@"Save",@"Share",nil]; //,@"Facebook",@"Instagram", nil];
        _customTabBar.items = [NSArray arrayWithObjects:album,share,nil]; //,facebook,instagram, nil];
    }else
    {
        _customTabBar.itemTitleArray = [NSArray arrayWithObjects:@"Save",@"Share",nil];//,@"Facebook",@"Instagram", nil];
        _customTabBar.items = [NSArray arrayWithObjects:album,share,nil]; //,facebook,instagram, nil];
    }
    [self.view addSubview:_customTabBar];
    
  //  [album release];
   // [share release];
   // [facebook release];
   // [instagram release];
   // [viddy release];
    //[copyToclipboard release];
    //[youtube release];
  //  [_customTabBar release];
}



- (void)otTabBar:(OT_TabBar*)tbar didSelectItem:(OT_TabBarItem*)tItem
{
    switch (tItem.tag) {
        case 11:
        {
            [self pauseThePlayer];
            //nvm.uploadCommand = UPLOAD_PHOTO_ALBUM;
            nvm.uploadCommand = UPLOAD_EMAIL;
            if (isVideo)
            {
                if(self.savingCountNumber ==0)
                {
                    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                    {
                        [self ShowSubscriptionView];
                    }
                    else
                    {
                        [self uploadVideo];
                        NSLog(@"Afrer purchase saving here---Video");
                    }
                    
                    
                }
               
                
             else if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                {
                    if(sharePageVisitCount<self.savingCountNumber)
                    {
                        [self uploadVideo];
                    }
                    else
                    {
                        [self ShowSubscriptionView];
                    }
                    
                }
                else
                {
                    [self uploadVideo];
                }
                
               
                }
            
         
            else
            {
                if(self.savingCountNumber ==0)
                {
                   // [self uploadImage];
                    
                   // [self limitForSaving];
                    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                    {
                        [self ShowSubscriptionView];
                    }
                    
                    else
                    {
                        NSLog(@"Afrer purchase saving here---Image");
                        [self uploadImage];
                    }
                    
                    NSLog(@"image saving first time");
                    
                }
              
               
             else  if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                {
                    if(sharePageVisitCount<self.savingCountNumber)
                    {
                        [self uploadImage];
                    }
                    else
                    {
                        [self ShowSubscriptionView];
                    }
                    
                }
                else
                {
                    [self uploadImage];
                }
                
               
                
                
                
            }
            break;
        }
        case 12:
        {
            [self pauseThePlayer];
           // nvm.uploadCommand = UPLOAD_EMAIL;
            if(self.savingCountNumber ==0)
            {
                // [self limitForSaving];
                
                if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                {
                    [self ShowSubscriptionView];
                }
                else
                {
                    
                    NSLog(@"Afrer purchase sharing here---");
                    
                                    NSArray *activityItems = nil;
                                    NSURL  *exportUrl = nil;
                                    if(isVideo)
                                    {
                                        exportUrl = [NSURL fileURLWithPath:videoPath];
                                        activityItems = @[exportUrl];
                                    }
                                    else
                                    {
                                        UploadHandler *uploadH = nil;
                                        uploadH = [UploadHandler alloc];
                                        uploadH.view = self.view;
                                        uploadH.viewController = self;
                                        uploadH.cursess = sess;
                                        UIImage *img = [uploadH getTheSnapshot];
                                        activityItems = @[img];
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
                                    NSLog(@"Done Perform share Action Perform");
                }
            }
            
          else  if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
            {
         
                if(sharePageVisitCount<savingCountLimitIs)
                {
                    NSArray *activityItems = nil;
                    NSURL  *exportUrl = nil;
                    if(isVideo)
                    {
                        exportUrl = [NSURL fileURLWithPath:videoPath];
                        activityItems = @[exportUrl];
                    }
                    else
                    {
                        UploadHandler *uploadH = nil;
                        uploadH = [UploadHandler alloc];
                        uploadH.view = self.view;
                        uploadH.viewController = self;
                        uploadH.cursess = sess;
                        UIImage *img = [uploadH getTheSnapshot];
                        activityItems = @[img];
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
                    NSLog(@"Done Perform share Action Perform");
                }
                
                else
                {
                   // [self limitExceedAlert];
                    [self ShowSubscriptionView];
                }
                
               // [self ShowSubscriptionView];
            }
            else
            {
                
                    NSArray *activityItems = nil;
                    NSURL  *exportUrl = nil;
                    if(isVideo)
                    {
                        exportUrl = [NSURL fileURLWithPath:videoPath];
                        activityItems = @[exportUrl];
                    }
                    else
                    {
                        UploadHandler *uploadH = nil;
                        uploadH = [UploadHandler alloc];
                        uploadH.view = self.view;
                        uploadH.viewController = self;
                        uploadH.cursess = sess;
                        UIImage *img = [uploadH getTheSnapshot];
                        activityItems = @[img];
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
                    NSLog(@"Done Perform share Action Perform");
                
                
               
            }
            break;
        }
      
        default:
            break;
    }
    
}

/*
- (void)otTabBar:(OT_TabBar*)tbar didSelectItem:(OT_TabBarItem*)tItem
{
    switch (tItem.tag) {
        case 11:
        {
            [self pauseThePlayer];
            nvm.uploadCommand = UPLOAD_PHOTO_ALBUM;
            if (isVideo)
            {
                if(self.savingCountNumber ==0)
                {
                   // [self uploadVideo];
                   // [self limitForSaving];
                    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                    {
                        [self ShowSubscriptionView];
                    }
                    else
                    {
                        [self uploadVideo];
                        NSLog(@"Afrer purchase saving here---Video");
                    }
                    
                    
                }
                
              else  if(!savedOnceImage)
                {
                    NSInteger savingCount = [savingAlbumCount integerForKey:@"SavingAlbumCount"];
                    [savingAlbumCount setInteger:savingCount+1 forKey:@"SavingAlbumCount"];
                    savingCount = [savingAlbumCount integerForKey:@"SavingAlbumCount"];
                    NSLog(@"Saving Count video is in share view controller %ld ",savingCount);
                    NSLog(@"Saving limit video is in share view controller %d ",savingCountLimitIs);
                    if(savingCount<=savingCountLimitIs)
                    {
                        [self uploadVideo];
                    }
                    else
                    {
                        if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                        {
                          //  [self limitExceedAlert];
                            [self ShowSubscriptionView];
                        }
                        
                        else
                        {
                            [self uploadVideo];
                        }
                      
                    }
                    
                   
                }
                else
                {
                    NSLog(@"image saved Once");
                   // [self imageSavedAlert];
                    
                    
                    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                    {
                        
                        NSInteger savingCount = [savingAlbumCount integerForKey:@"SavingAlbumCount"];
                        
                        if(savingCount<savingCountLimitIs)
                        {
                            NSLog(@"image saved Once");
                            [self imageSavedAlert];
                        }
                        else
                        {
                           // [self limitExceedAlert];
                            [self ShowSubscriptionView];
                        }
                    }
                    
                    else
                    {
                        [self imageSavedAlert];
                    }
                }

            }else
            {
                if(self.savingCountNumber ==0)
                {
                   // [self uploadImage];
                    
                   // [self limitForSaving];
                    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                    {
                        [self ShowSubscriptionView];
                    }
                    
                    else
                    {
                        NSLog(@"Afrer purchase saving here---Image");
                        [self uploadImage];
                    }
                    
                    NSLog(@"image saving first time");
                    
                }
               else if(!savedOnceImage)
                {
                    NSInteger savingCount = [savingAlbumCount integerForKey:@"SavingAlbumCount"];
                    [savingAlbumCount setInteger:savingCount+1 forKey:@"SavingAlbumCount"];
                    savingCount = [savingAlbumCount integerForKey:@"SavingAlbumCount"];
                    NSLog(@"Saving Count image is in share view controller %ld ",savingCount);
                    NSLog(@"Saving limit image is in share view controller %d ",savingCountLimitIs);
                    if(savingCount<=savingCountLimitIs)
                    {
                        [self uploadImage];
                    }
                    else
                    {
                        if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                        {
                           // [self limitExceedAlert];
                            [self ShowSubscriptionView];
                        }
                        
                        else
                        {
                            [self uploadImage];
                        }
                    }
                   
                }
                else
                {
                    NSLog(@"image saved Once");
                   // [self imageSavedAlert];
                    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                    {
                        
                        NSInteger savingCount = [savingAlbumCount integerForKey:@"SavingAlbumCount"];
                        
                        if(savingCount<savingCountLimitIs)
                        {
                            NSLog(@"image saved Once");
                            [self imageSavedAlert];
                        }
                        else
                        {
                          //  [self limitExceedAlert];
                            [self ShowSubscriptionView];
                        }
                    }
                    
                    else
                    {
                        [self imageSavedAlert];
                    }
                }
            }
            break;
        }
        case 12:
        {
            [self pauseThePlayer];
           // nvm.uploadCommand = UPLOAD_EMAIL;
            if(self.savingCountNumber ==0)
            {
                // [self limitForSaving];
                
                if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
                {
                    [self ShowSubscriptionView];
                }
                else
                {
                    
                    NSLog(@"Afrer purchase sharing here---");
                    
                                    NSArray *activityItems = nil;
                                    NSURL  *exportUrl = nil;
                                    if(isVideo)
                                    {
                                        exportUrl = [NSURL fileURLWithPath:videoPath];
                                        activityItems = @[exportUrl];
                                    }
                                    else
                                    {
                                        UploadHandler *uploadH = nil;
                                        uploadH = [UploadHandler alloc];
                                        uploadH.view = self.view;
                                        uploadH.viewController = self;
                                        uploadH.cursess = sess;
                                        UIImage *img = [uploadH getTheSnapshot];
                                        activityItems = @[img];
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
                                    NSLog(@"Done Perform share Action Perform");
                }
            }
            
          else  if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
            {
                NSInteger savingCount = [sharingAlbumCount integerForKey:@"SharingingAlbumCount"];
                [sharingAlbumCount setInteger:savingCount+1 forKey:@"SharingingAlbumCount"];
                savingCount = [sharingAlbumCount integerForKey:@"SharingingAlbumCount"];
                NSLog(@"Sharing Count video is in share view controller %ld ",savingCount);
               // NSLog(@"Sharing limit video is in share view controller %d ",savingCountLimitIs);
                
                
                if(savingCount<=savingCountLimitIs)
                {
                    NSArray *activityItems = nil;
                    NSURL  *exportUrl = nil;
                    if(isVideo)
                    {
                        exportUrl = [NSURL fileURLWithPath:videoPath];
                        activityItems = @[exportUrl];
                    }
                    else
                    {
                        UploadHandler *uploadH = nil;
                        uploadH = [UploadHandler alloc];
                        uploadH.view = self.view;
                        uploadH.viewController = self;
                        uploadH.cursess = sess;
                        UIImage *img = [uploadH getTheSnapshot];
                        activityItems = @[img];
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
                    NSLog(@"Done Perform share Action Perform");
                }
                
                else
                {
                   // [self limitExceedAlert];
                    [self ShowSubscriptionView];
                }
                
               // [self ShowSubscriptionView];
            }
            else
            {
                
                    NSArray *activityItems = nil;
                    NSURL  *exportUrl = nil;
                    if(isVideo)
                    {
                        exportUrl = [NSURL fileURLWithPath:videoPath];
                        activityItems = @[exportUrl];
                    }
                    else
                    {
                        UploadHandler *uploadH = nil;
                        uploadH = [UploadHandler alloc];
                        uploadH.view = self.view;
                        uploadH.viewController = self;
                        uploadH.cursess = sess;
                        UIImage *img = [uploadH getTheSnapshot];
                        activityItems = @[img];
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
                    NSLog(@"Done Perform share Action Perform");
                
                
               
            }
            break;
        }
      
        default:
            break;
    }
    
}

*/

- (void)uploadVideo
{
    vHandler = [VideoUploadHandler alloc];
    vHandler.viewController = self;
    vHandler . _view = self.view;
    vHandler.applicationNames = appname;
    vHandler.downloadUrl = @"http://www.videocollageapp.com";
    vHandler.website = @"http://www.videocollageapp.com";
    [LoadingClass removeActivityIndicatorFrom:self.view];
    [vHandler uploadVideoAtPath:videoPath to:nvm.uploadCommand];
           NSLog(@"Saving Video......");
    
//    NSLog(@"Retain count of vHandler : %d",vHandler.retainCount);
//    if (vHandler != nil) {
//        [vHandler release];
//        vHandler = nil;
//    }
    
//    UILabel *waterMark = (UILabel*)[playerView viewWithTag:TAG_WATERMARK_LABEL];
//    
//    // Add processing animation
//    [LoadingClass addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Saving",@"Saving")];
//    [self addOverlayToVideo:[NSURL fileURLWithPath:videoPath]  withLabel:waterMark completion:^(NSURL *outputURL, NSError *error) {
//        if (!error) {
//            NSLog(@"Video exported to: %@", outputURL);
//            vHandler = [VideoUploadHandler alloc];
//            vHandler.viewController = self;
//            vHandler . _view = self.view;
//            vHandler.applicationNames = appname;
//            vHandler.downloadUrl = @"http://www.videocollageapp.com";
//            vHandler.website = @"http://www.videocollageapp.com";
//            [LoadingClass removeActivityIndicatorFrom:self.view];
//            [vHandler uploadVideoAtPath:outputURL.path to:nvm.uploadCommand];
//                   NSLog(@"Saving Video......");
//        } else {
//            NSLog(@"Error: %@", error.localizedDescription);
//        }
//    }];
//    [LoadingClass removeActivityIndicatorFrom:self.view];
}
- (void)uploadImage
{
    UploadHandler *uploadH = nil;
    
    uploadH = [UploadHandler alloc];
    uploadH.view = self.view;
    uploadH.viewController = self;
    uploadH.cursess = sess;
    
    uploadH.savingCountLimit = savingCountLimitIs;
    [uploadH upload];
    //[uploadH release];
}
-(void)dealloc
{
    NSLog(@"dealloc of share view called -------------");
//    [_playerViewController release];
//    [_SharingURL release];
//    [player release];
//    [sess release];
//    [videoPath release];

   // [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////-----------------YoutubeMethods------------//

//-(NSString *)youtubeAPIClientID
//{
//    return@"304715988357-8vuq0b89imqh0474ri4ceigpn7m145h6.apps.googleusercontent.com";
//}
//
//- (NSString *)youtubeAPIClientSecret
//{
//    return @"rCcqhEdkZsOkQ4bEEqfM6i47";
//}
//
//- (void)showAuthenticationViewController:(UIViewController *)authView;
//
//{
//    [self.navigationController pushViewController:authView animated:YES];
//}
//
//- (void)authenticationEndedWithError:(NSError *)error;
//{
//    NSLog(@"Error   vvvvvv    %@", error.description);
//    if (error==nil) {
//        [youtubeUploader uploadPrivateVideoWithTitle:@"Video Made with Video Collage"
//                                         description:@"Video Made with Video Collage"
//                                  commaSeperatedTags:@"4 VideoTag1, 4 VideoTag2"
//                                             andPath:videoPath];
//        
//        
//    }
//    else{
//        NSLog(@"authentication failed");
//    }
//    
//    
//}
//
//
//- (void)uploadProgressPercentage:(int)percentage;
//{
//    
//    if ((percentage==100)||(percentage>=1))
//    {
//        
//        NSLog(@"hundred");
//        [HUD hide:YES];
//    }
//    else{
//        HUD.labelText = @"Uploading";
//        [HUD show:YES];
//        NSLog(@"less than 100");
//        NSLog(@"uploaded %d",percentage);
//    }
//    
//    
//}
//
//-(void)youtubedone
//{
//    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.mode = MBProgressHUDModeIndeterminate;
//   // youtubeUploader=[[YouTubeHelper alloc]initWithDelegate:self];
//    [youtubeUploader uploadPrivateVideoWithTitle:@"Video Made with Video Collage"
//                                     description:@"Video Made with Video Collage"
//                              commaSeperatedTags:@"4 VideoTag1, 4 VideoTag2"
//                                         andPath:videoPath];
//    
//}
//--------------------AvPlayer----------------------//
#pragma NewPlayer
-(void)avplayerview:(NSURL*)videoURLPath
{
    if (playerView!= nil)
    {
        [playerView removeFromSuperview];
        playerView = nil;
    }

    AVURLAsset* assetnew = [AVURLAsset URLAssetWithURL:videoURLPath options:nil];
    playerView = [[UIView alloc] init];
    float frameSize = fullScreen.size.width*0.95;
   /* if ([UIDevice currentDevice].userInterfaceIdiom== UIUserInterfaceIdiomPhone && fullScreen.size.height<=480)
    {
        playerView.frame = CGRectMake(0.0, strip_height+strip_height/2, fullScreen.size.width, 300);
    }
    else if ([UIDevice currentDevice].userInterfaceIdiom== UIUserInterfaceIdiomPhone && fullScreen.size.height>568)
    {
         playerView.frame = CGRectMake(0.0, strip_height+strip_height/2, fullScreen.size.width, 500);
    }

    else
    {
        playerView.frame = CGRectMake(0.0, strip_height*2+strip_height/2, fullScreen.size.width, backView_width);
    }*/
//    if ([UIDevice currentDevice].userInterfaceIdiom== UIUserInterfaceIdiomPad)
//    {
//        playerView.frame = CGRectMake(0.0, 0.0, full_screen.size.width, full_screen.size.width-200);
//    }
//    else if (full_screen.size.height>480.0) {
//        playerView.frame = CGRectMake(0,0, full_screen.size.width, full_screen.size.width);
//    }
//    else
//    {
//        playerView.frame = CGRectMake(0,0, full_screen.size.width, full_screen.size.width-100);
//    }
    
    eAspectRatio aspectRatio = nvm.aspectRatio;
    NSLog(@"aspect ratio is %d width %f height %f ",aspectRatio,sess.frame.frame.size.width,sess.frame.frame.size.height);
    CGSize  size = [Settings aspectRatioToValues:aspectRatio];
    CGFloat ratio = size.width/size.height;
    
    CGRect avFrame = CGRectMake(0,0, sess.frame.frame.size.width, sess.frame.frame.size.height);
    playerView.frame = avFrame; //CGRectMake(0,0, size.width*300, size.height*300);
    playerView.center = CGPointMake(fullScreen.size.width/2, fullScreen.size.height/2);
   // playerView . backgroundColor = [UIColor blackColor];
    playerView.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:51.0/255.0 blue:58.0/255.0 alpha:1.0];
     playerView.center = CGPointMake(full_screen.size.width/2, full_screen.size.height/2);
    playerView.layer.masksToBounds = YES;
    playerView.clipsToBounds = YES;
    [self.view addSubview:playerView];
 //   [playerView release];

    AVPlayerItem* item = [AVPlayerItem playerItemWithAsset:assetnew];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    AVPlayerLayer* lay = [AVPlayerLayer playerLayerWithPlayer:self.player];
    lay.videoGravity = AVLayerVideoGravityResizeAspect;

  /*  if ([UIDevice currentDevice].userInterfaceIdiom== UIUserInterfaceIdiomPhone && fullScreen.size.height<=480)
    {
        lay.frame = CGRectMake(0.0, 0.0, fullScreen.size.width, 300);
    }
    else if ([UIDevice currentDevice].userInterfaceIdiom== UIUserInterfaceIdiomPhone && fullScreen.size.height>568)
    {
        lay.frame = CGRectMake(0.0, 0.0, fullScreen.size.width, 500);
    }
    else
    {
        lay.frame = CGRectMake(0.0, 0.0, fullScreen.size.width, backView_width);
    }*/
//    if ([UIDevice currentDevice].userInterfaceIdiom== UIUserInterfaceIdiomPad)
//    {
//        lay.frame = CGRectMake(0.0, 0.0, full_screen.size.width, full_screen.size.width-200);
//    }
//    else if (full_screen.size.height>480.0) {
//        lay.frame = CGRectMake(0,0, full_screen.size.width, full_screen.size.width);
//    }
//    else
//    {
//        lay.frame = CGRectMake(0,0, full_screen.size.width, full_screen.size.width-100);
//    }
    //[playerView.layer addSublayer:lay];
    lay.frame = CGRectMake(0,0, avFrame.size.width, avFrame.size.height);
    lay.masksToBounds = YES;
    [playerView.layer insertSublayer:lay atIndex:0];
    [self.player pause];
    
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [self addWaterMarkToFrame:playerView];
    }
    
    
    
    play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.frame = CGRectMake(full_screen.size.width/2-back_width/2, full_screen.size.height/2-back_width/2, back_width, back_width);
    [play setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [play addTarget:self action:@selector(playOrPauseMusic) forControlEvents:UIControlEventTouchUpInside];
    play.center = CGPointMake(fullScreen.size.width/2, fullScreen.size.height/2);
    [self.view addSubview:play];

    UILabel *playerControlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, playerView.frame.size.height-64, full_screen.size.width, 64)];
    playerControlLabel.backgroundColor = [UIColor clearColor];
    [playerView addSubview:playerControlLabel];
   // [self.player release];
    [self.view bringSubviewToFront:play];
}


- (void)addWaterMarkToFrame:(UIView*)parentView
{
    float width = 180.0;
    float height = 50.0;
    CGRect waterMarkRect = CGRectMake(parentView.frame.size.width-width, parentView.frame.size.height-height, width, height);
    UILabel *waterMark;
    waterMark = [[UILabel alloc]initWithFrame:waterMarkRect];
    waterMark.backgroundColor = [UIColor clearColor];
    waterMark.tag = TAG_WATERMARK_LABEL;
    waterMark.font = [UIFont boldSystemFontOfSize:13.0];
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
    // Add gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WaterMarkTapped)];
    [waterMark addGestureRecognizer:tapGesture];
    waterMark.userInteractionEnabled = YES;
    [parentView addSubview:waterMark];
}

- (void)removeWaterMarkFromFrame
{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"remove water mark -- removing");
    UILabel *waterMark = (UILabel*)[playerView viewWithTag:TAG_WATERMARK_LABEL];
        if(nil != waterMark)
        {
            [waterMark removeFromSuperview];
        }
        waterMark = nil;
    });
}

-(void)WaterMarkTapped
{
    NSLog(@"watermark was tapped!");
    [self ShowSubscriptionView];
}


- (void)addOverlayToVideo:(NSURL *)videoURL withLabel:(UILabel *)label completion:(void (^)(NSURL *outputURL, NSError *error))completion {
    // Step 1: Load the video asset
    AVAsset *videoAsset = [AVAsset assetWithURL:videoURL];
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    // Add video track
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    
    // Step 2: Create the video composition
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.renderSize = videoTrack.naturalSize;
    videoComposition.frameDuration = CMTimeMake(1, 30); // 30 FPS
    
    // Create instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // Layer instruction
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
    instruction.layerInstructions = @[layerInstruction];
    videoComposition.instructions = @[instruction];
    
    // Step 3: Add overlay using UILabel
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, videoTrack.naturalSize.width, videoTrack.naturalSize.height);
    
    // Ensure UILabel has a valid size
    [label sizeToFit];
    
    // Render UILabel into a CALayer using UIGraphicsImageRenderer
    CGSize labelSize = label.bounds.size;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:labelSize];
    UIImage *labelImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [label.layer renderInContext:rendererContext.CGContext];
    }];
    
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.contents = (__bridge id)labelImage.CGImage;
    overlayLayer.frame = CGRectMake(50, 50, labelSize.width, labelSize.height); // Adjust position
    overlayLayer.opacity = 1.0; // Fully opaque
    
    // Create a parent layer
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoTrack.naturalSize.width, videoTrack.naturalSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    // Add parent layer to video composition
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    // Step 4: Export the final video
    NSString *outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"output.mov"];
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.videoComposition = videoComposition;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(outputURL, nil);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(nil, exportSession.error);
            });
        }
    }];
}



+ (NSSet *)keyPathsForValuesAffectingDuration
{
    return [NSSet setWithObjects:@"player.currentItem", @"player.currentItem.status", nil];
}

- (double)duration
{
    AVPlayerItem *playerItem = [[self player] currentItem];
    if ([playerItem status] == AVPlayerItemStatusReadyToPlay)
        return CMTimeGetSeconds([[playerItem asset] duration]);
    else
        return 0.f;
}

- (double)currentTime
{
    return CMTimeGetSeconds([[self player] currentTime]);
}

- (void)setCurrentTime:(double)time
{
    [[self player] seekToTime:CMTimeMakeWithSeconds(time, 1)];
}

- (void)itemDidFinishPlaying:(NSNotification *)notification
{
    [play setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    playerFinishedPlaying = YES;
}

- (void)playOrPauseMusic
{
         if ([[self player] rate] != 1.f)
        {
            NSLog(@"Playing.....");
            if ([self currentTime] == [self duration])
                [self setCurrentTime:0.f];
            [play setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            [[self player] play];
        }
        else
        {
            [play setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            [[self player] pause];
            NSLog(@"Pause.....");
        }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [Resume_view removeFromSuperview];
    Resume_view = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{

}

- (void)pauseThePlayer
{
    [player pause];
    [play setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
}

-(void)settingTouchViewUnHided
{
    NSLog(@"TouchViewUnHide---!!!!!!");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

   // saving an Integer
   [prefs setInteger:1 forKey:@"TouchViewHided"];
   
}

-(void)reloadVideo
{
    NSLog(@" shareview > >reload Video");
    if (self.player != nil) {
        //Play Video...
        if(isVideo)
        {
            NSLog(@" shareview > >VIdeo pathis $$$$ %@",videoPath);
            [self avplayerview:[NSURL fileURLWithPath:videoPath]];
            NSLog(@" shareview > >VIdeo pathis----%@",videoPath);
        }
    }
}

-(void)RemoveWaterMarkButton
{
    NSLog(@"watermark button---");
    
     
    removeWaterMark = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSLog(@"top height is %f",self.navigationController.navigationBar.frame.size.height);
    CGFloat safeAreaTop = 0;

    if (@available(iOS 11.0, *)) {
        safeAreaTop = KeyWindow.safeAreaInsets.top;
    }
    if (@available(iOS 11.0, *)) {
        if (safeAreaTop > 0) {
              
            removeWaterMark.frame = CGRectMake(full_screen.size.width*0.25,self.navigationController.navigationBar.frame.size.height+safeAreaTop+topToolBar.frame.size.height/2+10,full_screen.size.width/2,50);
            NSLog(@"safe area problem ---");
            
        }
        else
        {
            removeWaterMark.frame = CGRectMake(full_screen.size.width*0.25,self.navigationController.navigationBar.frame.size.height+15,full_screen.size.width/2,50);
            NSLog(@"2222 efcdvcdvc");
        }
    }
    else
    {
        removeWaterMark.frame = CGRectMake(full_screen.size.width*0.25,self.navigationController.navigationBar.frame.size.height+10,full_screen.size.width/2,50);
        NSLog(@"1122121 efcdvcdvc");
    }
        removeWaterMark.layer.cornerRadius = 25;
         removeWaterMark.backgroundColor = PHOTO_DEFAULT_COLOR;
        //font change here//
         [removeWaterMark setTitle:@"Remove Watermark" forState:UIControlStateNormal];
        removeWaterMark.titleLabel.font = [UIFont fontWithName:@"Gilroy-Medium" size:13.0f];
         removeWaterMark.alpha = 1.0;
      //   removeWaterMark.showsTouchWhenHighlighted = YES;
         removeWaterMark.tag = TAG_WATERMARK_BUTTON;
    [removeWaterMark addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
         
         if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
         {
             [self.view addSubview:removeWaterMark];
         }
  
}

- (void)buttonTapped:(UIButton *)sender {
    // Animation for button tap
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         sender.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              sender.transform = CGAffineTransformIdentity;
                                          }
                                          completion:^(BOOL completed)
                          {
                             [self removeWaterMark];
                         }
                         ];
                     }];
    
    // Perform additional actions here
    NSLog(@"Button was tapped!");
}

-(void)removeWaterMarkHere
{
    // mainthread //
    dispatch_async(dispatch_get_main_queue(), ^{
        

    [removeWaterMark removeFromSuperview];
    if(removeWaterMark!=nil)
    {
    [removeWaterMark removeFromSuperview];
        removeWaterMark = nil;
        NSLog(@"Removing here---------2");
    }
    });
}
- (void)removeWaterMark
{
    NSLog(@"subscription page---1");
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [self pauseThePlayer];
        [self ShowSubscriptionView];
    }
}




-(void)ShowSubscriptionView
{
    NSLog(@"subscription page---2");
    SubscriptionView2 = [[SimpleSubscriptionView alloc]init];
    [self.navigationController pushViewController:SubscriptionView2 animated:YES];
    NSLog(@"subscription page---3");
}

- (void)showInterstitial {

    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        NSLog(@"Pro Version is purchased Ads won't be served");
    }else{
        NSLog(@"Not purchased----");
        
        __weak ShareViewController *weakSelf = self;
        ShareViewController *strongSelf = weakSelf;
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
//                                           NSLog(@"precision Here $$$$$ %ld",(long)precision);
                                           
                                        

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


- (void)adDidPresentFullScreenContent:(id)ad {
  NSLog(@"Ad did present full screen content.");
}

- (void)ad:(id)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
  NSLog(@"Ad failed to present full screen content with error %@.", [error localizedDescription]);
}

- (void)adDidDismissFullScreenContent:(id)ad {
  NSLog(@"Ad did dismiss full screen content.");
   // [self loadInterstitial];
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
      self.interstitial = ad;
      self.interstitial.fullScreenContentDelegate = self;
      }];
}



-(void)gettingRemoteCount
{
    NSInteger saveCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"SavingCountValue"];
    
  //  NSInteger saveCount = [Saving_Number_defaults integerForKey:@"SavingCount"];
  
   self. savingCountNumber = (int) saveCount;
  
    savingCountLimitIs = self. savingCountNumber;
    
    NSLog(@"saving count  is in Share controller %d ",self.savingCountNumber );
}
-(void)gettingSavingValueHere
{
    savedOnceImage = YES;
}


- (void)imageSavedAlert
{
     UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Saved...!"
                                 message:@"Exists in gallery!"
                                 preferredStyle:UIAlertControllerStyleAlert];

    //Add Buttons

    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                   // [self clearAllData];
                                }];



    //Add your buttons to alert controller

    [alert addAction:yesButton];
   

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)limitExceedAlert
{
     UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Saving limit...!"
                                 message:@"Go to premium version for unlimited access!"
                                 preferredStyle:UIAlertControllerStyleAlert];

    //Add Buttons

    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [self ShowSubscriptionView];
                                }];



    //Add your buttons to alert controller

    [alert addAction:yesButton];
   

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)limitForSaving
{
     UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Unlimited saving...!"
                                 message:@"Go to premium version for unlimited access!"
                                 preferredStyle:UIAlertControllerStyleAlert];

    //Add Buttons

    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [self ShowSubscriptionView];
                                }];



    //Add your buttons to alert controller

    [alert addAction:yesButton];
   

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma  mark ResumeAdHere

-(void)showLoadingForAd
{
  
    [self loadInterstitial];
   // [Utility addActivityIndicatotTo:self.view withMessage:@"Wait"];
    [LoadingClass addActivityIndicatotTo:Resume_view withMessage:NSLocalizedString(@"Loading",@"Loading")];

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
    [Resume_view removeFromSuperview];
     Resume_view = nil;
    
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
        if (![[SRSubscriptionModel shareKit]IsAppSubscribed])
        {
            if(self.interestial_HomeButtonClickCount>0)
            {
             
                [self showLoadingForAd];
            }
            else
            {
                [Resume_view removeFromSuperview];
                 Resume_view = nil;
            }
            NSLog(@"Adds not ------:");
        }
        else
        {
            [Resume_view removeFromSuperview];
             Resume_view = nil;
            NSLog(@"Adds are purchased----");
        }
    if(Resume_view)
    {
        [Resume_view removeFromSuperview];
         Resume_view = nil;
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

-(void)Resumepage
{
    UIViewController *topVC = [ShareViewController topViewController];
    NSLog(@"Current view controller: %@", NSStringFromClass([topVC class]));
    if([topVC class] == ShareViewController.class)
    {
        if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        else{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        NSLog(@"Resume Page Here--- share view");
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
        Resume_view.backgroundColor =[UIColor whiteColor];
        Resume_view.contentMode = UIViewContentModeScaleAspectFit;
        Resume_view.userInteractionEnabled = YES;
        
        
        
        
        //            [[[UIApplication sharedApplication] keyWindow] addSubview:Resume_view];
        
        
        [self.view addSubview:Resume_view];
        
        
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
}

-(void)RemoveView
{
    if (Resume_view !=nil) {
        [Resume_view removeFromSuperview];
        Resume_view = nil;
    }
}

-(void)gettingInterestialCount
{
    NSInteger shareInterestialCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"ShareValue"];//[Interestial_Share_defaults integerForKey:@"Interestial_ShareScreen"];
   
   self. interestial_ShareCount = (int) shareInterestialCount;
//    NSInteger native_shareCount = [NativeAd_defaults integerForKey:@"native_share"];
//    self.nativeAd_shareNumber = (int)native_shareCount;
  
 //  self.savingCountNumber = (int) saveCount;
    
   
    NSInteger buttonInterestialCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"HomeClickValue"];//[Interestial_Button_defaults integerForKey:@"Interestial_HomeButtonClick"];
    
    self.interestial_HomeButtonClickCount = (int) buttonInterestialCount;
 
    NSLog(@"interestial_HomeButtonClickCount is in ShareviewController %d ",self.interestial_HomeButtonClickCount);
    
    NSLog(@"interestial_ShareCount is in ShareviewController %d ",self.interestial_ShareCount);
}



#pragma mark MailAndRateUsPanel

-(void)showRateUsPanel
{
    NSLog(@"Rate Us Value %ld",[[NSUserDefaults standardUserDefaults] integerForKey:@"VideoCollageRateUsValue"]);
    // Show only once for apps life time
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"VideoCollageRateUsValue"] == 0)
    {
        [SKStoreReviewController requestReviewInScene:self.view.window.windowScene];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"VideoCollageRateUsValue"];
    }
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


- (void)showInterstitial2 {

    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        NSLog(@"Pro Version is purchased Ads won't be served");
    }else{
        NSLog(@"Not purchased----");
        __weak ShareViewController *weakSelf = self;
        ShareViewController *strongSelf = weakSelf;
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
