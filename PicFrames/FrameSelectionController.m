//
//  FrameSelectionController.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 2/3/13.
//
#define NSLog(...) [[FIRCrashlytics crashlytics] logWithFormat: __VA_ARGS__]
#import "FrameSelectionController.h"
#import "WCAlertView.h"
#import "OT_TabBar.h"
#import "Config.h"
//#import "InAppPurchasePreview.h"
#import "FrameSelectionView.h"
//#import "FBLikeUsView.h"
//#import "InstagramFollowView.h"
//#import "HelpScreenViewController.h"
//#import <FBSDKShareKit/FBSDKShareKit.h>

//#import "SubscriptionPage.h"
//#import "UniversalLayout.h"
#import "MainController.h"
#import "SimpleSubscriptionView.h"
#import "VideoCollage-Swift.h"
#import "VideoFrames-Bridging-Header.h"


@interface FrameSelectionController ()<OT_TabBarDelegate,FrameSelectionViewDelegate> //FBSDKAppInviteDialogDelegate, InAppPurchasePreviewViewDelegate,FBLikeUsViewDelegate ,InstagramFollowViewDelegate
{
    //UITabBar *_tabbar;
    OT_TabBar *_customTabBar,*_customTabBarback;
    SNPopupView *aspectRatioView;
    PopupMenu *_lockedMenu;
    int _curSelectedFrame;
    int _curSelectedGroup;
    int _curTabSelection;
    int _curSelectedFrameIndex;
    UIButton *_appoxeeBadge;
    UIButton *_customDoneButton;  // Custom Done button for gradient support

    FrameSelectionView *frameSelectionView;
 //   SubscriptionPage *SubscriptionView;
    SimpleSubscriptionView *SubscriptionView2;

    //ExpiryStatus//
    NSUserDefaults *prefsTime;
    NSUserDefaults *prefsDate;
    NSUserDefaults *SuccessStatus;

}

@end

typedef struct
{
    int frameNumber;
    BOOL lock;
}tFrameMap;

//static
BOOL lockstatus[FRAMES_GROUP_LAST][FRAMES_MAX_PERGROUP];

//static
tFrameMap frame_mapping[FRAMES_MAX_PERGROUP] = {
    {1001, YES},
    {1002, YES},
    {1003, YES},
    {1004, YES},
    {1005, YES},
    {1006, YES},
    {1007, YES},
    {1008, YES},
    {1009, YES},
    {10010, YES},
    {10011, YES},
    {10012, YES},
    {10013, YES},
    {10014, YES},
    {10015, YES},
    {10016, YES},
    {10017, YES},
    {10018, YES},
    {10019, YES},
    {10020, YES},
    {10021, YES},
    {10022, YES},
    {10023, YES},
    {10024, YES},
    {10025, YES},
    {10026, YES},
    {10027, YES},
    {10028, YES},
    {10029, YES},
    {10030, YES},
    {10031, YES},
    {10032, YES},
    {10033, YES},
    {10034, YES},
    {10035, YES},
    {10036, YES},
    {10037, YES},
    {10038, YES},
    {10039, YES},
    {10040, YES},
    {10041, YES},
    {10042, YES},
    {10043, YES},
    {10044, YES},
    {10045, YES},
    {10046, YES},
    {10047, YES},
    {10048, YES},
    {10049, YES},
};

@implementation FrameSelectionController

NSString *__templateReviewURL = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";


+(void)setLockStatusOfFrame:(int)fil group:(int)grp to:(BOOL)newstatus
{
    if(lockstatus[grp][fil] == newstatus)
    {
        return;
    }
    
    lockstatus[grp][fil] = newstatus;
    NSData *data = [NSData dataWithBytes:&lockstatus[0] length:(sizeof(BOOL) * FRAMES_GROUP_LAST * FRAMES_MAX_PERGROUP)];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"framelockstatus"];
    
    return;
}

+(int)getLockStatusOfFrame:(int)fil group:(int)grp
{
    //ExpiryStatus//
    NSUserDefaults *prefsTime = nil;
    NSUserDefaults *prefsDate = nil;
    NSUserDefaults *SuccessStatus = nil;
    prefsTime = [NSUserDefaults standardUserDefaults];
    prefsDate= [NSUserDefaults standardUserDefaults];
    SuccessStatus = [NSUserDefaults standardUserDefaults];

    printf("[FRAME_DEBUG] getLockStatusOfFrame - frameIndex=%d group=%d\n", fil, grp);

    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
       // bought_allpackages
        NSLog(@"UnLocked-----");
        printf("[FRAME_DEBUG] getLockStatusOfFrame - SUBSCRIPTION ACTIVE: Frame=%d unlocked\n", fil);
        return NO;
    }
    else
    {
        NSLog(@" Locked-----");
        printf("[FRAME_DEBUG] getLockStatusOfFrame - NO SUBSCRIPTION: Checking lock status\n");
//        if([SuccessStatus integerForKey:@"PurchasedYES"] == 1)
//        {
//            return NO;
//        }
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"framelockstatus"];
    NSNumber *maxFrames = [[NSUserDefaults standardUserDefaults] objectForKey:@"MaximumFramesPerGroup"];
    if(nil != maxFrames)
    {
        int maxFrm = [maxFrames intValue];
        if(maxFrm != FRAMES_MAX_PERGROUP)
        {
            /* force sync */
            data = nil;
        }
    }
    
    /* also check if the application is booted */
    if(YES == [[NSUserDefaults standardUserDefaults]boolForKey:@"applicationbooted"])
    {
        /* force sync */
        data = nil;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"applicationbooted"];
    }
    
    if(nil == data)
    {
        printf("[FRAME_DEBUG] getLockStatusOfFrame - No stored lock data, initializing defaults\n");
        memset(&lockstatus[0],1,sizeof(BOOL) * FRAMES_GROUP_LAST * FRAMES_MAX_PERGROUP);

        /* store the values in lockstatus and upload to defaults */
        for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
        {
#if freeVersion
            lockstatus[FRAMES_GROUP_UNEVEN][i] = frame_mapping[i].lock;
#else
            lockstatus[FRAMES_GROUP_UNEVEN][i] = NO;
#endif

            /* By default all even frames are unlocked */
            lockstatus[FRAMES_GROUP_EVEN][i] = NO;
        }

        /* Also save Maximum frames per group */
        [[NSUserDefaults standardUserDefaults]setInteger:FRAMES_MAX_PERGROUP forKey:@"MaximumFramesPerGroup"];

        /* update in defaults */
        NSData *data = [NSData dataWithBytes:&lockstatus[0] length:(sizeof(BOOL) * FRAMES_GROUP_LAST * FRAMES_MAX_PERGROUP)];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"framelockstatus"];
    }
    else
    {
        printf("[FRAME_DEBUG] getLockStatusOfFrame - Loaded lock status from defaults\n");
        memcpy(&lockstatus[0], data.bytes, data.length);
    }

    BOOL lockState = lockstatus[grp][fil];
    printf("[FRAME_DEBUG] getLockStatusOfFrame - RESULT: Frame=%d Group=%d IsLocked=%s\n", fil, grp, lockState ? "YES" : "NO");
    return lockState;
}

- (void)showAppoxee:(id)sender
{
    //Ask the Appoxee to appear (only for modal mode)
//    [[AppoxeeManager sharedManager] show];
}

+ (instancetype)createInstance {
    FrameSelectionController *instance = [[self alloc] init];
    
    if (instance) {
        instance->_curTabSelection = 0;
        
        instance->_appoxeeBadge = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [instance->_appoxeeBadge addTarget:instance action:@selector(showAppoxee:) forControlEvents:UIControlEventTouchDown];
        [instance->_appoxeeBadge setImage:[UIImage imageNamed:@"mail box_c.png"] forState:UIControlStateNormal];
        
        // Custom initialization code
        // [instance registerForNotifications];
    }
    
    return instance;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    UIImageView *img = (UIImageView*)[self.view viewWithTag:TAG_FRAMEGRID_CONTROLLER];
    if(nil != img)
    {
        [img removeFromSuperview];
    }
   // [self unregisterForNotifications];
  //  [super dealloc];
}


//-(void)inAppPurchasePreviewWillExit:(InAppPurchasePreview *)gView
//{
//    self.navigationController.navigationBarHidden = NO;
//}
//
//-(void)restoreDidSelectForInAppPurchasePreview:(InAppPurchasePreview *)gView
//{
//    [[InAppPurchaseManager Instance]restoreProUpgrade];
//}
//
//-(void)inAppPurchasePreview:(InAppPurchasePreview *)gView itemPurchasedAtIndex:(int)index
//{
//
//        [[InAppPurchaseManager Instance]puchaseProductWithId:kInAppPurchaseRemoveWaterMarkPack];
//
//}

-(void)addTabbar
{
    //Bottom1//
    CGRect _fullscreen = [[UIScreen mainScreen]bounds];
    //back view
    _customTabBarback = [[OT_TabBar alloc]initWithFrame:CGRectMake(0,_fullscreen.size.height-35,_fullscreen.size.width,35)];
   
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        _customTabBarback . frame = CGRectMake(0, _fullscreen.size.height-24, _fullscreen.size.width, 24);
    }
    _customTabBarback.delegate = self;
    _customTabBarback.backgroundColor = PHOTO_DEFAULT_COLOR;
   // _customTabBar.backgroundColor = PHOTO_DEFAULT_COLOR;
    _customTabBarback.showOverlayOnSelection = NO;
    
    [self.view addSubview:_customTabBarback];
 //   [_customTabBarback release];
    
   // safe area here//
    if (@available(iOS 11.0, *)) {
        if (SafeAreaBottomPadding > 0) {
            _customTabBar = [[OT_TabBar alloc]initWithFrame:CGRectMake(0,_fullscreen.size.height-70-SafeAreaBottomPadding/2,_fullscreen.size.width,70)];
        }
        else
        {
            _customTabBar = [[OT_TabBar alloc]initWithFrame:CGRectMake(0,_fullscreen.size.height-70,_fullscreen.size.width,70)];
        }
    }
    else
    {
        _customTabBar = [[OT_TabBar alloc]initWithFrame:CGRectMake(0,_fullscreen.size.height-70,_fullscreen.size.width,70)];
    }
   
    _customTabBar.layer.cornerRadius = 20;
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//    {
//        _customTabBar . frame = CGRectMake(0, _fullscreen.size.height-44, _fullscreen.size.width, 44);
//    }
    _customTabBar.delegate = self;
    _customTabBar.backgroundColor = PHOTO_DEFAULT_COLOR;
   // _customTabBar.backgroundColor = PHOTO_DEFAULT_COLOR;
    _customTabBar.showOverlayOnSelection = NO;
    OT_TabBarItem *frames = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"frames2"]
                                                  selectedImage:[UIImage imageNamed:@"frames_active2"]
                                                            tag:0];
        
    OT_TabBarItem *rateUs = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"rate-us2"]
                                                  selectedImage:[UIImage imageNamed:@"rate-us_active2"]
                                                            tag:1];
    
//    OT_TabBarItem *facebook = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"fb2"]
//                                                    selectedImage:[UIImage imageNamed:@"fb_active2"]
//                                                              tag:2];
    OT_TabBarItem *mail = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"mail2"]
                                                selectedImage:[UIImage imageNamed:@"mail_active2"]
                                                          tag:3];
//    OT_TabBarItem *message = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"msg2"]
//                                                   selectedImage:[UIImage imageNamed:@"msg_active2"]
//                                                             tag:4];
   // OT_TabBarItem *more = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:@"more1"]
                                           //     selectedImage:[UIImage imageNamed:@"more"]
                                                         // tag:5];
     _customTabBar.itemTitleArray = [NSArray arrayWithObjects:@"Frames",@"Rate",@"Mail", nil]; //,@"Facebook"
    _customTabBar.items = [NSArray arrayWithObjects:frames,rateUs,mail, nil]; //,facebook

    [self.view addSubview:_customTabBar];

    [_customTabBar setSelectedItem:0];

    /* release the resources */
//    [_customTabBar release];
//    [frames release];
//    [rateUs release];
   // [more release];
//    [facebook release];
 //   [mail release];
   // [message release];
}



//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == tag_frameselection_rateus)
//    {
//        if(buttonIndex == 1)
//        {
//            NSString *reviewURL = [__templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", iosAppId]];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
//
//        }
//      [self changeTabbarSelectionBackToDefault];
//    }
//    else if(alertView.tag == 11)
//    {
//        [self changeTabbarSelectionBackToDefault];
//    }
//}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch(result)
    {
        case MessageComposeResultCancelled:
        {
            break;
        }
        case MessageComposeResultFailed:
        {
            break;
        }
        case MessageComposeResultSent:
        {
            break;
        }
    }
    [self changeTabbarSelectionBackToDefault];
    /* Now dismiss the controller */
 //   [controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:^{
        NSLog(@"frame selection controller dismissed!");
    }];
}

-(void)referToYourFriendBySMS:(id) sender
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];// autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = [NSString stringWithFormat:@"%@ is an amazing iPhone App. Download it for FREE from %@",appname,ituneslinktoApp];
        controller.messageComposeDelegate = self;
//        [self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch(result)
    {
        case MFMailComposeResultCancelled:
        {
            break;
        }
        case MFMailComposeResultFailed:
        {
            break;
        }
        case MFMailComposeResultSaved:
        {
            break;
        }
        case MFMailComposeResultSent:
        {
            break;
        }
    }
    [self changeTabbarSelectionBackToDefault];
//    [controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:^{
        NSLog(@"frame selection controller dismissed!");
    }];
}

-(void)referToYourFacebookFriends:(id)sender
{
//    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init ];
//
//    content.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/in/app/videocollage-pro-photo-video/id722633887?mt=8"]];
//    FBSDKShareDialog* dialog = [[FBSDKShareDialog alloc] init];
//    dialog.mode = FBSDKShareDialogModeAutomatic;
//
//    dialog.shareContent = content;
//    dialog.fromViewController = self;
//    [dialog show];
    
}

-(void)referToYourFriendByEmail:(id)sender
{
   // NSAutoreleasePool *localPool     = [[NSAutoreleasePool alloc] init];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        /* We must always check whether the current device is configured for sending emails */
        if ([mailClass canSendMail])
        {
            //NSString *appUrl = applicationUrl;
          //  NSString *appUrl = ituneslinktoApp;
            
            //NSString *yozioLink = [Yozio getYozioLink:@"Invite Friend by Email" channel:@"email" destinationUrl:appUrl];
            
//            NSString *yoziohyperlink = [NSString stringWithFormat:
//                                        @"<a href=\"https://apps.apple.com/us/app/video-collage-collage-maker/id712175767\">Video Collage!</a>\n"];
            
            NSString *appUrl = ituneslinktoApp;
            NSString *yoziohyperlink = [NSString stringWithFormat:
                                        @"<a href=\"%@\" target=\"itunes_store\">%@</a>",appUrl,appname];
                        
            NSString *emailBody = [NSString stringWithFormat:@"%@ is an amazing iPhone App. Using this app you can combine multiple photos and videos into single layout. Download it for FREE from %@\n",appname,yoziohyperlink];
            
            NSString *emailSubject = [NSString stringWithFormat:@"Check out this Cool App %@",appname];
            
            /* Compose the email */
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate          = self;
            [picker setSubject:emailSubject];
            
            /* Set the model transition style */
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            /* Fill out the email body text */
            [picker setMessageBody:emailBody isHTML:YES];
            
            /* Present the email compose view to the user */
//            [self presentModalViewController:picker animated:YES];
            [self presentViewController:picker animated:YES completion:nil];
            /* Free the resources */
          //  [picker release];
        }
        else
        {
//            UIAlertView *emailAlert;
//
//            emailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EMAIL",@"Email") message:NSLocalizedString(@"NOEMAIL",@"Email is not configured for this device!!!") delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
//
//            emailAlert.tag = 11;
//
//            /* Show the alert */
//            [emailAlert show];
            
            /* Release the alert */
       //     [emailAlert release];
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"EMAIL",@"Email") message:NSLocalizedString(@"NOEMAIL",@"Email is not configured for this device!!!") preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            // Create the second action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Delete selected");
                [self changeTabbarSelectionBackToDefault];
            }];
//            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        
        /* Free the mailclass object */
     //   [mailClass release];
    }
    
   // [localPool release];
    
    return;
}

-(void)continueChangeTabbarSelectionBackToDefault:(id)sender
{
    // [_customTabBar setSelectedItem:0];  // Commented out - no tab bar

    return;
}

-(void)changeTabbarSelectionBackToDefault
{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(continueChangeTabbarSelectionBackToDefault:) userInfo:nil repeats:NO];
}

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 0:
//        {
//
//            break;
//        }
//        case 1:
//        {
//            [self referToYourFriendByEmail:nil];
//            break;
//        }
//        case 2:
//        {
//            [self referToYourFriendBySMS:nil];
//            break;
//        }
//        case 3:
//        {
//            [self referToYourFacebookFriends:nil];
//            break;
//        }
//        default:
//        {
//            break;
//        }
//    }
//
//}
//-(void)showShareOptions
//{
//    UIActionSheet *aSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Email",@"Message",@"Facebook", nil];
//    aSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    //[aSheet showFromTabBar:_tabbar];
//    //[aSheet showFromTabBar:_tabbar];
//    [aSheet showFromRect:_customTabBar.frame inView:self.view animated:YES];
//   // [aSheet release];
//}

-(void)otTabBar:(OT_TabBar*)tbar didSelectItem:(OT_TabBarItem*)tItem
{
//    OT_OfferWallView *o = (OT_OfferWallView*)[self.view viewWithTag:tag_frameselection_otofferwall];
//    if(nil != o)
//    {
//        [o removeFromSuperview];
//    }

    switch (tItem.tag)
    {
        case 0:
        {

            break;
        }
        case 1:
        {
            /*
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Rate Us" message:@"Did you like the app?. Are you willing to spend less than a minute time for us?. Your greate review will encourage us to add much more features!!!" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            av.tag = tag_frameselection_rateus;
            [av show];
            [av release];
            */
//            [SKStoreReviewController requestReview];
            [SKStoreReviewController requestReviewInScene:self.view.window.windowScene];
            break;
        }
        case 2:
        {
            if (NO == nvm.connectedToInternet) {
                [WCAlertView showAlertWithTitle:@"No Internet" message:@"Currently your device is not connected to internet. To refer your friends, please connect to internet ." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                return;
            }else
            {
            [self referToYourFacebookFriends:nil];
            }
            break;
        }
        case 3:
        {
            if (NO == nvm.connectedToInternet) {
                [WCAlertView showAlertWithTitle:@"No Internet" message:@"Currently your device is not connected to internet. To refer your friends, please connect to internet ." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                return;
            }
            else
            {
            [self referToYourFriendByEmail:nil];
            }
            break;
        }
        case 4:
        {
            [self referToYourFriendBySMS:nil];
            break;
        }

        case 5:
        {
            //[[AppoxeeManager sharedManager]showMoreAppsViewController];
            CGRect full = [[UIScreen mainScreen]bounds];
            //CGRect r = CGRectMake(0.0, 50.0, full.size.width, full.size.height-100);
            CGRect r;
            if ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)) {
                r=CGRectMake(0.0, 64.0, full.size.width, full.size.height-130);
            }
            else
                r=CGRectMake(0.0, 44.0, full.size.width, full.size.height-95);
//            OT_OfferWallView *otv = [[OT_OfferWallView alloc]initWithFrame:r style:UITableViewStylePlain];
//            otv.tag = tag_frameselection_otofferwall;
//            [self.view addSubview:otv];
//            [otv release];
            //[self changeTabbarSelectionBackToDefault];
            break;
        }
        default:
        {
            break;
        }
    }
}

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
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eRat],@"aspectratio", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:aspectratiochanged object:nil userInfo:params];
#if 0
    /* No need to proceed further of the user selects the same aspect ratio */
    if(sess.aspectRatio == eRat)
    {
        [LoadingClass removeActivityIndicatorFrom:self.view];
        return;
    }
    
    [sess setAspectRatio:eRat];
#endif
    UIToolbar *toolBar = (UIToolbar*)[self.view viewWithTag:tag_frameselection_toolbar];
    if(nil != toolBar)
    {
        NSLog(@"performAspectRatioChange: %d:%d",(int)nvm.wRatio,(int)nvm.hRatio);
        UIBarButtonItem *itm = [toolBar.items objectAtIndex:2];
        if(nil != itm)
        {
            NSLog(@"Selected Bar: %@",itm.title);
            itm.title = [NSString stringWithFormat:@" %d : %d ",(int)nvm.wRatio,(int)nvm.hRatio];
        }
    }
    
    [LoadingClass removeActivityIndicatorFrom:self.view];
}

-(void)aspectRatioChanged:(id)sender
{
    UIButton *btn     = sender;
    eAspectRatio eRat = (int)btn.tag - TAG_ASPECTRATIO_BUTTON;
    NSNumber *num     = [NSNumber numberWithInt:eRat];
    
    /* First show the activity indicator */
  //  [LoadingClass addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    /* Schdule the timer to process the aspect ratio change */
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(performAspectRatioChange:) userInfo:num repeats:NO];
    
    return;
}

-(void)showAspectRatioMenu:(id)sender
{
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
            aspect.backgroundColor = [UIColor whiteColor];
        }
        
        [aspect setTitle:title forState:UIControlStateNormal];
        aspect.titleLabel.font            = [UIFont boldSystemFontOfSize: 12];
        aspect.titleLabel.lineBreakMode   = UILineBreakModeTailTruncation;
        aspect.titleLabel.textColor       = [UIColor blackColor];
        [aspectRatioMenu addSubview:aspect];
     //   [aspect release];
        aspectRatioMenu.contentSize = CGSizeMake(aspectButtonWidth * index + 70.0, 50.0);
    }
#if CMTIPPOPVIEW_ENABLE
    /* add it on top of tipview */
    CMPopTipView *aspectRatioView = [[CMPopTipView alloc]initWithCustomView:aspectRatioMenu];
    aspectRatioView.backgroundColor = [UIColor blackColor];
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

-(void)performHelp
{
//    HelpScreenViewController  *helpScreen = [[HelpScreenViewController alloc] init];
//
//    [UIView transitionWithView:self.view
//                      duration:1.0
//                       options:UIViewAnimationOptionTransitionCurlDown
//                    animations:^{
//                        [self.view addSubview:helpScreen.view];
//                         [self.view bringSubviewToFront:helpScreen.view];
//                    }
//                    completion:NULL];

}
-(void)ResoreSubscription
{

    //if (NO == bought_allfeaturespack)
    //{
    [[SRSubscriptionModel shareKit]restoreSubscriptions];
    [self showLoadingForRestore];
    //}
//    else
//    {
//
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle : @"Alert"
//                                                                            message : @"Already restored "
//                                                                 preferredStyle : UIAlertControllerStyleAlert];
//
//            UIAlertAction * ok = [UIAlertAction
//                                  actionWithTitle:@"OK"
//                                  style:UIAlertActionStyleDefault
//                                  handler:^(UIAlertAction * action)
//                                  {
//
//
//                NSLog(@"Restore $$$$$$$$$$ ----4");
//            }];
//
//            [alert addAction:ok];
//            [self presentViewController:alert animated:YES completion:nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                NSLog(@"Restore $$$$$$$$$$ ----2");
//            });
//    }
//
}
#pragma mark ActivtyIndicator
-(void)showLoadingForRestore
{
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//
//    // saving an NSString
//    [prefs setObject:@"RestoredPurchase" forKey:@"FramesLoadedFirst"];
    //if (NO == bought_allfeaturespack)
   // {
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [LoadingClass addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Restoring Purchase",@"Restoring Purchase")];
    
    [self performSelector:@selector(startFramesdownloading) withObject:nil afterDelay:3.0 ];
   // }
    

}
-(void)startFramesdownloading
{
    [self performSelector:@selector(CallRecieptValidation) withObject:nil afterDelay:40.0 ];
}

-(void)CallRecieptValidation
{
    [[SRSubscriptionModel shareKit]ValidateReciept];
}

-(void)hideActivityIndicator
{
    [LoadingClass removeActivityIndicatorFrom:self.view];
}


//-(UIView*)addToolbarWithTitle:(NSString*)title tag:(int)toolbarTag
//{
//    //safe area here//
//    NSLog(@"Dding Title----");
////    CGRect fullScreen = [[UIScreen mainScreen]bounds];
//
//
//    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fullScreen.size.width, customBarHeight-20)];
//    //toolbar.image = [UIImage imageNamed:@"top-bar_vpf"];
//    bgview.backgroundColor=PHOTO_DEFAULT_COLOR;
//    bgview.userInteractionEnabled = YES;
//    bgview.tag = TAG_TOOLBAR_EDIT;
//    [self.view addSubview:bgview];
//   // [bgview release];
//    UIView *toolbar;
//    //safe area here //
//    if (@available(iOS 11.0, *)) {
//        if (SafeAreaBottomPadding > 0) {
//               // iPhone with notch
//
//            toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fullScreen.size.width, customBarHeight+customBarHeight/2)];
//        }
//        else
//        {
//            toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fullScreen.size.width, customBarHeight)];
//        }
//    }
//    else
//    {
//        toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fullScreen.size.width, customBarHeight)];
//
//    }
//
//    //toolbar.image = [UIImage imageNamed:@"top-bar_vpf"];
//    toolbar.backgroundColor=PHOTO_DEFAULT_COLOR;
//    toolbar.userInteractionEnabled = YES;
//    toolbar.tag = TAG_TOOLBAR_EDIT;
//    toolbar.layer.cornerRadius = 15;
//    //safe area here //
//    UILabel *label;
//    if (@available(iOS 11.0, *)) {
//        if (SafeAreaTopPadding> 0) {
//
//
//            label = [[UILabel alloc] initWithFrame:CGRectMake(toolbar.frame.size.width*25, SafeAreaTopPadding/2, 200, customBarHeight)];
//        }
//        else
//        {
//            label = [[UILabel alloc] initWithFrame:CGRectMake(toolbar.frame.size.width*22, 0, 200, customBarHeight)];
//            NSLog(@"Here it is >ios11----");
//        }
//    }
//    else
//    {
//        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//        {
//
//        label = [[UILabel alloc] initWithFrame:CGRectMake(toolbar.frame.size.width*45, 0, 200, customBarHeight)];
//        }
//        else
//        {
//        label = [[UILabel alloc] initWithFrame:CGRectMake(toolbar.frame.size.width*22, 0, 200, customBarHeight)];
//        }
//    }
//
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor greenColor];
//    label.shadowOffset = CGSizeMake(0, 1);
//    label.textColor = UIColorFromRGB(0xFFFFFFFF);
//    label.text = title;
//    label.font = [UIFont boldSystemFontOfSize:14.0];
//    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
//    {
//        label.font = [UIFont boldSystemFontOfSize:17.0];
//    }
//    else
//    {
//        label.font = [UIFont boldSystemFontOfSize:15.0];
//
//    }
//    [toolbar addSubview:label];
//
//    //label.center = toolbar.center;
//   // [label release];
//
//    UIButton *help = [UIButton buttonWithType:UIButtonTypeInfoLight];
//   // UIButton *help = [UIButton buttonWithType:UIButtonTypeCustom];
//    help. tintColor = [UIColor whiteColor];
//    //[help addTarget:self action:@selector(performBack) forControlEvents:UIControlEventTouchUpInside];
//    [help setImage:[UIImage imageNamed:@"info2"] forState:UIControlStateNormal];
//    [help addTarget:self action:@selector(performHelp) forControlEvents:UIControlEventTouchUpInside];
//    help.frame = CGRectMake(fullScreen.size.width-customBarHeight, 0, customBarHeight, customBarHeight);
//   // [toolbar addSubview:help];
//    help.showsTouchWhenHighlighted = YES;
//
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    [back addTarget:self action:@selector(performBack) forControlEvents:UIControlEventTouchUpInside];
//    [back setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
//    if (@available(iOS 11.0, *)) {
//        if (SafeAreaTopPadding > 0) {
//            back.frame = CGRectMake(0,SafeAreaTopPadding/2,  customBarHeight, customBarHeight);
//        }
//        else
//        {
//            back.frame = CGRectMake(0, 0,  customBarHeight, customBarHeight);
//        }
//    }
//    else
//    {
//        back.frame = CGRectMake(0, 0,  customBarHeight, customBarHeight);
//    }
//
//    [toolbar addSubview:back];
//    back.showsTouchWhenHighlighted = YES;
//
//    UIButton *proButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [proButton addTarget:self action:@selector(openProVersion) forControlEvents:UIControlEventTouchUpInside];
//    [proButton setBackgroundImage:[UIImage imageNamed:@"pro 1.png"] forState:UIControlStateNormal];
//    proButton.frame = CGRectMake(fullScreen.size.width-pro_x, 0, customBarHeight, customBarHeight);
//#if freeVersion
//    [toolbar addSubview:proButton];
//    proButton.showsTouchWhenHighlighted = YES;
//    [self addAnimationToProButton:proButton];
//    #endif
//
//    _appoxeeBadge.frame = CGRectMake(fullScreen.size.width-appoxee_button_x, 12.5, 25, 25);
////    _appoxeeBadge.showsTouchWhenHighlighted = YES;
//
//    //[toolbar addSubview:_appoxeeBadge];
//
//    [self.view addSubview:toolbar];
//
//    UIButton *restore = [UIButton buttonWithType:UIButtonTypeCustom];
//    //[help addTarget:self action:@selector(performBack) forControlEvents:UIControlEventTouchUpInside];
//  //  [restore setImage:[UIImage imageNamed:@"info1"] forState:UIControlStateNormal];
//
//    [restore setTitle:@"Restore" forState:UIControlStateNormal];
//    restore.titleLabel.font = [UIFont fontWithName:@"Gilroy-Medium" size:17.0f];
//    [restore addTarget:self action:@selector(ResoreSubscription) forControlEvents:UIControlEventTouchUpInside];
//    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
//    {
//        restore.frame = CGRectMake(fullScreen.size.width-customBarHeight-customBarHeight-customBarHeight, 0, customBarHeight+customBarHeight, customBarHeight);
//    }
//   else if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (full_screen . size. height==568))
//      {
//          restore.frame = CGRectMake(fullScreen.size.width-customBarHeight-customBarHeight-35, 0, customBarHeight+customBarHeight, customBarHeight);
//      }
//    else{
//        if (@available(iOS 11.0, *)) {
//            if (SafeAreaTopPadding > 0) {
//                restore.frame = CGRectMake(fullScreen.size.width-customBarHeight-customBarHeight-customBarHeight,SafeAreaTopPadding/2, customBarHeight+customBarHeight, customBarHeight);
//            }
//            else
//            {
//                restore.frame = CGRectMake(fullScreen.size.width-customBarHeight-customBarHeight-customBarHeight, 0, customBarHeight+customBarHeight, customBarHeight);
//            }
//        }
//        else
//
//        {
//            restore.frame = CGRectMake(fullScreen.size.width-customBarHeight-customBarHeight-customBarHeight, 0, customBarHeight+customBarHeight, customBarHeight);
//        }
//
//
//
//
//    }
//
//    [toolbar addSubview:restore];
//    restore.showsTouchWhenHighlighted = YES;
//
//    //[toolbar release];
//
//    return toolbar;
//}


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
-(void)openProVersion
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

    UIButton *bigInstallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bigInstallButton.frame  = proImageView.frame;
    //[bigInstallButton setImage:[UIImage imageNamed:@"install.png"] forState:UIControlStateNormal];
    [bigInstallButton addTarget:self action:@selector(openProApp) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:bigInstallButton];
    
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
//        [[UIApplication sharedApplication] openURL:proUrl];
        [[UIApplication sharedApplication] openURL:proUrl options:@{} completionHandler:nil];
    }
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


}

-(void)performBack
{

    //[self.navigationController popViewControllerAnimated:NO]; //changedToPop
    //[self.navigationController popToRootViewControllerAnimated:NO];----//existing one
    //changes made
    
    NSUserDefaults *user_Defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"ClassDynamic value %ld",(long)[user_Defaults integerForKey:@"ClassDynamic"]);
    if([user_Defaults integerForKey:@"ClassDynamic"] == 1)
    {
        NSLog(@"make root class here---");
        
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
       // UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
   //     StartViewController *startClass = [[StartViewController alloc] init];
//        UINavigationController *controlador = [[UINavigationController alloc]init];
//        controlador = [[UINavigationController alloc] init];
//        self.window.rootViewController =  controlador;
//        [self.window makeKeyAndVisible];
//        [controlador pushViewController:startClass animated:YES];
        
        

    }
   
//    if(self.isDynamically)
//    {
//        NSLog(@"make root class here---");
//    }
    else
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES]; //changedToPopPro
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationdidfinishwithframeview" object:nil];//Existing one
        NSLog(@"going back button-----");
        
    }
  
//   [self dismissViewControllerAnimated:NO completion:^{
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationdidfinishwithframeview" object:nil]; //kasaram
       
   //}];

    
}
-(void)customizeTheLookOfTabbar:(UITabBar*)tbar
{
    if([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad)
    {
        if([tbar respondsToSelector:@selector(setBackgroundImage:)])
        {
            if(tbar.items.count == 5)
            {
                tbar.backgroundImage = [UIImage imageNamed:@"tabbar5.png"];
                tbar.selectionIndicatorImage = [UIImage imageNamed:@"tabselection5.png"];
            }
            else
            {
                tbar.backgroundImage = [UIImage imageNamed:@"tabbar4.png"];
                tbar.selectionIndicatorImage = [UIImage imageNamed:@"tabselection4.png"];
            }
        }
    }
}

-(BOOL)isFrame:(int)frame belongsToCatageory:(int)tag
{
    int mintag = (tag - TAG_BASEFRAME_GRIDVIEW)*1000;
    int maxtag = ((tag - TAG_BASEFRAME_GRIDVIEW)+1)*1000;
    if((frame >= mintag)&&(frame <= maxtag))
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)isFrameInGroup:(int)grp LockedAtIndex:(int)index
{
    if(bought_allpackages)
    {
        return NO;
    }
    
    return frame_mapping[index].lock;
}

-(int)getGroupIdFromTag:(int)tag
{
    if(tag == TAG_UNEVENFRAME_GRIDVIEW)
    {
        return FRAMES_GROUP_UNEVEN;
    }
    
    return FRAMES_GROUP_EVEN;
}

-(int)getTagFromGroup:(int)group
{
    if(group == FRAMES_GROUP_UNEVEN)
    {
        return TAG_UNEVENFRAME_GRIDVIEW;
    }
    
    return TAG_EVENFRAME_GRIDVIEW;
}

- (BOOL)gridView:(FrameGridView*)gView contentLockedAtIndex:(int)index
{
    //NSLog(@"gridView contentLockedAtIndex %d",index);
    if(gView.tag == TAG_UNEVENFRAME_GRIDVIEW)
    {
        return [FrameSelectionController getLockStatusOfFrame:(index-1000) group:[self getGroupIdFromTag:(int)gView.tag]];
        //return [self isFrameLockedAtIndex:(index - 1000)];
    }

    return NO;
}

//- (void) receiveNotification:(NSNotification *) notification
//{
//   // NSLog(@"frame selection view controller received Notification name is %@",notification.name);
//    if([[notification name]isEqualToString:kInAppPurchaseManagerTransactionSucceededNotification])
//    {
//        NSLog(@"Check Date : ------------------ subscribed");
//        frameSelectionView.delegate = nil;
//        [frameSelectionView removeFromSuperview];
//
//        /* add them again to make sure user don't see the lock icons on the images */
//        CGRect rect = [[UIScreen mainScreen]bounds];
//        CGRect fsvRect = CGRectMake(0.0, 50.0, rect.size.width, rect.size.height-100);
//        frameSelectionView = [[FrameSelectionView alloc]initWithFrame:fsvRect];
//        frameSelectionView.delegate = self;
//        frameSelectionView.tag = tag_frameselection_view;
//        frameSelectionView.userInteractionEnabled = YES;
//        self.view.userInteractionEnabled = YES;
//        [self.view addSubview:frameSelectionView];
//        [frameSelectionView loadFrames];
//        [frameSelectionView release];
//    }
//    return;
//}

//-(void)unregisterForNotifications
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:nil
//                                                  object:nil];
//}

//-(void)registerForNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveNotification:)
//                                                 name:nil
//                                               object:nil];
//}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRootviewcontrollerHere) name:@"DynamicallyCalled" object:nil];
    NSLog(@"viewdidapper frameselection class");
    [[SRSubscriptionModel shareKit]loadProducts]; // newly added here
    [[SRSubscriptionModel shareKit]CheckingExpiryHere];
    if (@available(iOS 11.0, *)) {
           [self setNeedsUpdateOfHomeIndicatorAutoHidden];
       }
}

-(void)restoreSuccess
{
    NSLog(@"-------------------- restoreSuccess -------------------");
    [self ShowAlert:@"Restore Successful"  message:@"Restored Successfully"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self];
}
         
-(void)restoreFailed
{
    NSLog(@"-------------------- restore Failed -------------------");
    [self ShowAlert:@"Restore Failed"  message:@"Subscription Expired"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self];
}


-(void)ShowAlert:(NSString*)title message:(NSString*)msg
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"111111111  FrameSelectionView");
    // Hide the default back button
    self.navigationItem.hidesBackButton = YES;

    // Create a custom back button with your image
    UIImage *backButtonImage = [UIImage imageNamed:@"back_svg"]; // Ensure this image exists in your assets
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain
           target:self action:@selector(performBack)];
    NSLog(@"222222222  FrameSelectionView");
    // Set the custom back button as the left bar button item
    self.navigationItem.leftBarButtonItem = backButton;

    // Create custom Done button with gradient support
    _customDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _customDoneButton.frame = CGRectMake(0, 0, 70, 35);
    [_customDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_customDoneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _customDoneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _customDoneButton.layer.cornerRadius = 5.0;
    _customDoneButton.clipsToBounds = YES;

    // Set initial appearance (no frame selected)
    [self updateDoneButtonAppearance];

    // Wrap in bar button item
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:_customDoneButton];
    self.navigationItem.rightBarButtonItem = doneButton;

    // Configure navigation bar to blend with black background
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.backgroundColor = [UIColor blackColor];
        appearance.shadowColor = nil;  // Remove separator line

        // Set title text to white
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };

        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        // iOS 12 and earlier
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

        // Set title text to white for iOS 12
        self.navigationController.navigationBar.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.isDynamically = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(FrameSelected:) name:@"SelectedFrame" object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(reloadViews)
//                                                name:kInAppPurchaseManagerTransactionSucceededNotification
//                                              object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(ShowIndicatorForFetchingLastPurchases)
//                                                name:@"FetchingLastPurchases" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(restoreFailed) name:@"RestoreFailed"  object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(restoreSuccess) name:@"RestoreSuccessful"  object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideActivityIndicator) name:@"HideActivityIndicator" object:nil];
    

    prefsTime = [NSUserDefaults standardUserDefaults];
      prefsDate= [NSUserDefaults standardUserDefaults];
    SuccessStatus = [NSUserDefaults standardUserDefaults];
    NSLog(@"333333  FrameSelectionView");
    nvm = [Settings Instance];
    NSLog(@"44444  FrameSelectionView");
    UIView *imgView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    imgView.backgroundColor = [UIColor blackColor];  // Changed to black background
    imgView.tag = TAG_FRAMEGRID_CONTROLLER;
    [self.view addSubview:imgView];
 //   [imgView release];
    
    self.view.userInteractionEnabled = YES;
    
    /* Add toolbar */
    self.title = @"Frames";
   // [self addToolbarWithTitle:@"Frames" tag:tag_frameselection_toolbar];
    //here it is//
    CGRect rect = [[UIScreen mainScreen]bounds];
    // Increased height by removing 50px tab bar space: was (height-100-20), now (height-50-20)
    CGRect fsvRect = CGRectMake(0.0, 50.0, rect.size.width, rect.size.height-50-20);
    NSLog(@"before  FrameSelectionView");
    frameSelectionView = [[FrameSelectionView alloc]initWithFrame:fsvRect];
    NSLog(@"after  FrameSelectionView");
    frameSelectionView.delegate = self;
    frameSelectionView.tag = tag_frameselection_view;
    frameSelectionView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:frameSelectionView];
    NSLog(@"view did load frame selection controller");
    [frameSelectionView loadFrames];
   // [frameSelectionView release];
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"FRAMES",@"Frames");
    // [self addTabbar];  // Commented out - no tab bar for this screen

}


//-(void)ShowIndicatorForFetchingLastPurchases
//{
////    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
////
////    [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Fetching Purchases",@"Fetching last purchases")];
//    [self performSelector:@selector(startValidation) withObject:nil afterDelay:1.0 ];
//}
//
//-(void)startValidation
//{
//    [self performSelector:@selector(CheckValidation) withObject:nil afterDelay:40.0 ];
//}
//
//-(void)CheckValidation
//{
//    [[SRSubscriptionModel shareKit]Check_Validation];
//}

-(void)reloadViews
{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"Reload views");
    frameSelectionView.delegate = nil;
    [frameSelectionView removeFromSuperview];
    
    /* add them again to make sure user don't see the lock icons on the images */
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGRect fsvRect = CGRectMake(0.0, 50.0, rect.size.width, rect.size.height-100);
    frameSelectionView = [[FrameSelectionView alloc]initWithFrame:fsvRect];
    frameSelectionView.delegate = self;
    frameSelectionView.tag = tag_frameselection_view;
    frameSelectionView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:frameSelectionView];
    NSLog(@"=================== Reloading frames ===================");
    [frameSelectionView loadFrames];
   // [frameSelectionView release];
    });
}

- (void)frameSelectionView:(FrameSelectionView *)gView showInAppForItemIndex:(int)index button:(UIButton*)btn
{

//    InAppPurchasePreview *preview = [[InAppPurchasePreview alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
//    self.navigationController.navigationBarHidden = YES;
//
//    [self.view addSubview:preview];
//    preview.delegate = self;
    

    NSString *watermarkPackPrice = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseRemoveWaterMarkPack];

    NSString *watermarkPackTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseRemoveWaterMarkPack];

    NSString *watermarkPackDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseRemoveWaterMarkPack];

    
    if(nil == watermarkPackPrice)
    {
        watermarkPackPrice = DEFAULT_WATERMARK_PACK_PRICE;
        watermarkPackTitle = DEFAULT_WATERMARK_PACK_TITLE;
        watermarkPackDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
    }
    
//    NSArray *watermarkPackObjs = [NSArray arrayWithObjects:watermarkPackPrice,watermarkPackTitle, watermarkPackDescription,nil];
//    NSArray *watermarkPackKeys = [NSArray arrayWithObjects:key_inapppreview_package_price,key_inapppreview_package_msgheading, key_inapppreview_package_msgbody,nil];
//    NSDictionary *watermarkPack = [NSDictionary dictionaryWithObjects:watermarkPackObjs forKeys:watermarkPackKeys];
//
//    NSArray *packages = [NSArray arrayWithObjects:watermarkPack, nil];
//
//    [preview showInAppPurchaseWithPackages:packages];

    return;
}

-(void)frameSelectionView:(FrameSelectionView *)gView selectedItemIndex:(int)index button:(UIButton *)btn
{
  // if (proVersion)
  // {
    //old code commented
    //changed frame selection//
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    if ([prefs integerForKey:@"Productpurchased"] == 1)
//    {
    Settings *set;
  
        
        _curSelectedGroup = [self frameTypeFromIndex:index];
        
        set = [Settings Instance];
        set.currentSessionIndex = set.nextFreeSessionIndex;
        set.currentFrameNumber = index;

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:set.currentFrameNumber],@"FrameNumber",[NSNumber numberWithInt:set.currentSessionIndex],@"SessionNumber", nil];
        NSLog(@"Sending new frame selected notification with frames index %d",set.currentFrameNumber);
   
    [[NSNotificationCenter defaultCenter] postNotificationName:newframeselected object:nil userInfo:params];
    NSLog(@"selected Item Index----");
    [self.navigationController popViewControllerAnimated:NO];
    
//    NSUserDefaults *prefs1 = [NSUserDefaults standardUserDefaults];
//    if(set.currentFrameNumber<3||[prefs1 integerForKey:@"Productpurchased"] == 1)
//    {
//    if((set.currentFrameNumber<3 || set.currentFrameNumber ==1003 || set.currentFrameNumber ==1007 || set.currentFrameNumber ==1013 || set.currentFrameNumber ==1018 || set.currentFrameNumber ==21 || set.currentFrameNumber ==1033   || set.currentFrameNumber == 37 || set.currentFrameNumber ==43)||[[SRSubscriptionModel shareKit]IsAppSubscribed])
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:newframeselected object:nil userInfo:params];
//        NSLog(@"selected Item Index----");
//    }
//
//   if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
//    {
//        if(set.currentFrameNumber<3 || set.currentFrameNumber ==1003 || set.currentFrameNumber ==1007 || set.currentFrameNumber ==1013 || set.currentFrameNumber ==1018 || set.currentFrameNumber ==21 || set.currentFrameNumber ==1033  || set.currentFrameNumber == 37 || set.currentFrameNumber ==43)
//        {
//            [self.navigationController popViewControllerAnimated:NO]; //Existing one
//           // [frameSelectionView loadFrames];
//         //   [self dismissViewControllerAnimated:NO completion:nil]; //kasaram
//        
//    }
//        
//        else
//        {
//        if(set.currentFrameNumber<10050&& set.currentFrameNumber!=52)
//        {
//            if((set.currentFrameNumber<3||[[SRSubscriptionModel shareKit]IsAppSubscribed]))
//            {
//                [self.navigationController popViewControllerAnimated:NO];
//            }
//            else
//            {
//                [self lockingFrameSelection];
//                //[frameSelectionView loadFrames];
//                NSLog(@"current frame number is greater than 3 so lock here %d",_curSelectedFrame);
//            }
//          
//            
//        }
//        }
//        }
//       else
//       {
//           if([[SRSubscriptionModel shareKit]IsAppSubscribed])
//           {
//               [self.navigationController popViewControllerAnimated:NO];
//           }
//           else
//           {
//               if ([SuccessStatus integerForKey:@"PurchasedYES"] == 1) {
//                   [self.navigationController popViewControllerAnimated:NO];
//               }
//           }
//       }
}

#pragma LockingFrames

-(void)lockingFrameSelection
{
    [self ShowSubscriptionView];

}
-(void)clearingWhiteScreenfirst
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // saving an Integer
   [prefs setInteger:0 forKey:@"whiteScreen"];
   
}
-(void)clearingWhiteScreenSecondTime
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

   // saving an Integer
   [prefs setInteger:1 forKey:@"whiteScreen"];
   
}

//-(void)allocateResourcesForFrames
//{
//
//    FrameSelectionController *sc = [FrameSelectionController alloc];
//
//    if(nil == sc)
//    {
//        return;
//    }
//
//  //  [self.view addSubview:sc.view];
//
//   // [self.navigationController presentViewController:sc animated:NO completion:nil];//kasaram
//     [self.navigationController pushViewController:sc animated:NO]; //working //changedToPushPro //--Existing one
//
//    [sc release];
//
//    return;
//}


-(void)reloadingMainController
{
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
       FrameSelectionController * reloadingVc = [[FrameSelectionController alloc]init];
       [self presentViewController:reloadingVc animated:NO completion:nil];
   }

    NSLog(@"Maincontroller reloading.....");
}
-(void)ShowSubscriptionView
{
    SubscriptionView2 = [[SimpleSubscriptionView alloc] init];
    [self.navigationController pushViewController:SubscriptionView2 animated:YES];
}

- (void)frameSelectionView:(FrameSelectionView *)gView showRateUsForItemIndex:(int)index button:(UIButton*)btn
{
    int rateusFrameCount = [FrameSelectionView rateUsLockedFrameCount];
     NSString *msgBody = [NSString stringWithFormat:@"Rate %@ app to unlock %d frames.",appname,rateusFrameCount];
    [WCAlertView showAlertWithTitle:@"Rate" message:msgBody customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if(buttonIndex == 1)
            {
            NSString *reviewURL = [__templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", iosAppId]];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                reviewURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",iosAppIdString];
            }

            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:reviewURL]]) {
                [[NSUserDefaults standardUserDefaults]setObject:nil
                                                         forKey:key_frame_index_of_follow_inprogress];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:index]
                                                         forKey:key_frame_index_of_follow_inprogress];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES]
                                                         forKey:key_rate_app_inprogress];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL] options:@{} completionHandler:nil];
            }
            }
        
    } cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Rate it!",nil];
}

- (void)frameSelectionView:(FrameSelectionView *)gView showFacebookLikeForItemIndex:(int)index button:(UIButton*)btn
{
    int facebookLockedFrameCount = [FrameSelectionView facebookLockedFrameCount];
    NSString *msgBody = [NSString stringWithFormat:@"Like %@ on Facebook to unlock %d new Frames",appname,facebookLockedFrameCount];
    
    [WCAlertView showAlertWithTitle:@"Like on Facebook" message:msgBody customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if(buttonIndex == 1)
        {
//            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",gView,@"frameSelectionView", nil];
//            FBLikeUsView *fblv = [[FBLikeUsView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
//            fblv.delegate = self;
//            fblv.userInfo = info;
//            [self.view addSubview:fblv];
//            [fblv release];
        }
        
    } cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Like It!",nil];
}

+(void)handleIfAnySocialFollowInProgress
{

    NSNumber  *follow = [[NSUserDefaults standardUserDefaults]objectForKey:key_twitter_follow_inprogress];
    if(nil != follow)
    {
        NSLog(@"------inside twitterfollowInProgress -----------");
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key_twitter_follow_inprogress];
        [[NSNotificationCenter defaultCenter]postNotificationName:notification_twitter_follow_done object:nil];
        return;
    }

    NSNumber *follow_instagram = [[NSUserDefaults standardUserDefaults]objectForKey:key_instagram_follow_inprogress];
    if(nil != follow_instagram)
    {
        NSLog(@"------inside instagramfollowInProgress -----------");
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key_instagram_follow_inprogress];
        [[NSNotificationCenter defaultCenter]postNotificationName:notification_instagram_follow_done object:nil];

        return;
    }
    
    NSNumber *rate_us  = [[NSUserDefaults standardUserDefaults]objectForKey:key_rate_app_inprogress];
    if(nil != rate_us)
        {
        NSLog(@"------inside RateUsInProgress -----------");
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key_rate_app_inprogress];
        [[NSNotificationCenter defaultCenter]postNotificationName:notification_rate_app_done object:nil];
        
        return;
        }
}

- (void)frameSelectionView:(FrameSelectionView *)gView showInstagramFollowForItemIndex:(int)index button:(UIButton*)btn
{
    int instagramLockedFrameCount = [FrameSelectionView instagramLockedFrameCount];
    NSString *msgBody = [NSString stringWithFormat:@"Follow %@ on Instagram to unlock %d new Frames",appname,instagramLockedFrameCount];
    
    [WCAlertView showAlertWithTitle:@"Follow us on Instagram" message:msgBody customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if(buttonIndex == 1)
        {
            NSString *instagramProfileLink = @"http://www.instagram.com/outthinking";
            NSURL *instagramUrls = [NSURL URLWithString:instagramProfileLink];
            
            if([[UIApplication sharedApplication]canOpenURL:instagramUrls])
            {
                [[NSUserDefaults standardUserDefaults]setObject:nil
                                                         forKey:key_frame_index_of_follow_inprogress];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:index]
                                                         forKey:key_frame_index_of_follow_inprogress];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES]
                                                         forKey:key_instagram_follow_inprogress];
                //[[UIApplication sharedApplication]openURL:instagramUrl];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:instagramUrl] options:@{} completionHandler:nil];
            }
        }
        
    } cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Follow Us!",nil];
}

- (void)frameSelectionView:(FrameSelectionView *)gView showTwitterFollowForItemIndex:(int)index button:(UIButton*)btn
{
    int twitterLockedFrameCount = [FrameSelectionView twitterLockedFrameCount];
    NSString *msgBody = [NSString stringWithFormat:@"Follow %@ on Twitter to unlock %d new Frames",appname,twitterLockedFrameCount];
    
    [WCAlertView showAlertWithTitle:@"Follow us on Twitter" message:msgBody customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if(buttonIndex == 1)
        {
            NSString *twitterProfileLink = @"http://www.twitter.com/OutthinkingInd";
            NSURL *twitterUrl = [NSURL URLWithString:twitterProfileLink];
            
            if([[UIApplication sharedApplication]canOpenURL:twitterUrl])
            {
                [[NSUserDefaults standardUserDefaults]setObject:nil
                                                         forKey:key_frame_index_of_follow_inprogress];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:index]
                                                         forKey:key_frame_index_of_follow_inprogress];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES]
                                                         forKey:key_twitter_follow_inprogress];
//                [[UIApplication sharedApplication]openURL:twitterUrl];
                [[UIApplication sharedApplication] openURL:twitterUrl options:@{} completionHandler:nil];
            }
        }
        
    } cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Follow Us!",nil];
}

-(int)convertIndexToPageNumber:(int)index
{
    /* find the page number of the index */
    int rowsPerPage  = 4;
    int colPerPage   = 3;
    int itemsPerPage = rowsPerPage * colPerPage;
    int pageNumber   = index/itemsPerPage;
    
    if(pageNumber > 0)
    {
        if(0 == (index % itemsPerPage))
        {
            pageNumber = pageNumber-1;
        }
    }
    
    return pageNumber;
}

-(int)convertIndexToIndexInsidePage:(int)index
{
    int rowsPerPage  = 4;
    int colPerPage   = 3;
    int itemsPerPage = rowsPerPage * colPerPage;
    int indexInsidePage = index - ([self convertIndexToPageNumber:index]*itemsPerPage);
    
    return indexInsidePage;
}

-(eFrameType)frameTypeFromIndex:(int)index
{
    int indexInsidePage = [self convertIndexToIndexInsidePage:index];
    int colPerPage      = 3;
    int rowsPerPage     = 4;

    printf("[FRAME_DEBUG] frameTypeFromIndex - displayIndex=%d indexInsidePage=%d\n", index, indexInsidePage);

    if(indexInsidePage < ((rowsPerPage/2)*colPerPage)+1)
    {
        printf("[FRAME_DEBUG] frameTypeFromIndex - displayIndex=%d is FREE type\n", index);
        return FRAMES_TYPE_FREE;
    }

    printf("[FRAME_DEBUG] frameTypeFromIndex - displayIndex=%d is PREMIUM type\n", index);
    return FRAMES_TYPE_PREMIUM;
}

-(int)convertIndexToFrameTypeIndex:(int)index
{
    int rowsPerPage  = 4;
    int colPerPage   = 3;
    int itemsPerPage = rowsPerPage * colPerPage;
    int pageNumber      = [self convertIndexToPageNumber:index];
    int indexInsidePage = [self convertIndexToIndexInsidePage:index];
    int items           = pageNumber * (itemsPerPage/2);

    printf("[FRAME_DEBUG] convertIndexToFrameTypeIndex - displayIndex=%d pageNum=%d indexInPage=%d\n", index, pageNumber, indexInsidePage);

    if(indexInsidePage < ((rowsPerPage/2)*colPerPage)+1)
    {
        items = items + indexInsidePage;
        printf("[FRAME_DEBUG] convertIndexToFrameTypeIndex - displayIndex=%d → FREE frame number=%d\n", index, items);
        return items;//+1;
    }

    items = items + (indexInsidePage - ((rowsPerPage/2)*colPerPage));
    int premiumFrameNum = 1000+items;
    printf("[FRAME_DEBUG] convertIndexToFrameTypeIndex - displayIndex=%d → PREMIUM frame number=%d\n", index, premiumFrameNum);
    return premiumFrameNum;//+1;
}

- (BOOL)frameScrollView:(FrameScrollView*)gView contentLockedAtIndex:(int)index
{
    //index = index - 1;
    printf("[FRAME_DEBUG] frameScrollView:contentLockedAtIndex: - displayIndex=%d\n", index);

    if(FRAMES_TYPE_FREE == [self frameTypeFromIndex:index])
    {
        printf("[FRAME_DEBUG] frameScrollView:contentLockedAtIndex: - displayIndex=%d is FREE, not locked\n", index);
        return NO;
    }

    int frameTypeIndex = [self convertIndexToFrameTypeIndex:index];
    printf("[FRAME_DEBUG] frameScrollView:contentLockedAtIndex: - displayIndex=%d frameTypeIndex=%d checking lock\n", index, frameTypeIndex);

    BOOL isLocked = [FrameSelectionController getLockStatusOfFrame:frameTypeIndex-1000 group:FRAMES_TYPE_PREMIUM];
    printf("[FRAME_DEBUG] frameScrollView:contentLockedAtIndex: - displayIndex=%d result: %s\n", index, isLocked ? "LOCKED" : "UNLOCKED");
    return isLocked;
}


- (int)rowCountOfFrameScrollView:(FrameScrollView*)gView
{
    return 4;
}

- (int)colCountOfFrameScrollView:(FrameScrollView*)gView
{
    return 3;
}

- (int)totalItemCountOfFrameScrollView:(FrameScrollView*)gView
{
    return FRAME_COUNT+UNEVEN_FRAME_COUNT;
}

- (int)selectedItemIndexOfFrameScrollView:(FrameScrollView*)gView
{
    return 0;
}

-(void)FrameSelected:(NSNotification *) notification
{
    NSNumber * frameNum = [notification.userInfo objectForKey:@"FrameIndex"];
    int index = (int)frameNum.integerValue;
    NSLog(@"frame selected index is %d",index);
    _curSelectedGroup = [self frameTypeFromIndex:index];
    _curSelectedFrameIndex = [self convertIndexToFrameTypeIndex:index];
    NSLog(@"Selected frame %d to frametype _curSelectedFrame %d   _curSelectedFrameIndex %d",index,_curSelectedFrame,_curSelectedFrameIndex);
    Settings *set = [Settings Instance];
    set.currentSessionIndex = set.nextFreeSessionIndex;
    set.currentFrameNumber = _curSelectedFrameIndex;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:set.currentFrameNumber],@"FrameNumber",[NSNumber numberWithInt:set.currentSessionIndex],@"SessionNumber", nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:newframeselected object:nil userInfo:params];

    // Update Done button appearance when frame is selected
    [self updateDoneButtonAppearance];
}

-(void)frameScrollView:(FrameScrollView *)gView selectedItemIndex:(int)index button:(UIButton*)btn
{
    printf("[FRAME_DEBUG] ========== FRAME SELECTION STARTED ==========\n");
    printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - USER TAPPED displayIndex=%d\n", index);

    _curSelectedGroup = [self frameTypeFromIndex:index];
    _curSelectedFrameIndex = [self convertIndexToFrameTypeIndex:index];
    NSLog(@"Selected frame %d to frametype _curSelectedFrame %d   _curSelectedFrameIndex %d",index,_curSelectedFrame,_curSelectedFrameIndex);
    printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - frameGroup=%d convertedIndex=%d\n", _curSelectedGroup, _curSelectedFrameIndex);

    if(_curSelectedFrame<3 || [[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - Checking if frame is locked...\n");
        if(NO == [self frameScrollView:gView contentLockedAtIndex:index])
        {
            printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - FRAME UNLOCKED! Posting selection notification\n");
            Settings *set = [Settings Instance];
            set.currentSessionIndex = set.nextFreeSessionIndex;
            set.currentFrameNumber = _curSelectedFrameIndex;

            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:set.currentFrameNumber],@"FrameNumber",[NSNumber numberWithInt:set.currentSessionIndex],@"SessionNumber", nil];
            printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - POSTING NOTIFICATION: newframeselected with frameNumber=%d sessionNumber=%d\n", set.currentFrameNumber, set.currentSessionIndex);

            [[NSNotificationCenter defaultCenter] postNotificationName:newframeselected object:nil userInfo:params];

            // Update Done button appearance when frame is selected
            [self updateDoneButtonAppearance];

            printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - Frame selected, waiting for Done button press\n");
        }
        else
        {
            printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - FRAME IS LOCKED, dismissing without selection\n");
        }

        // REMOVED automatic navigation - user must press Done button to proceed
        // if(_curSelectedFrame<3)
        // {
        //     printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - Free frame, dismissing view controller\n");
        //     [self dismissViewControllerAnimated:NO completion:nil];
        // }
        // else
        // {
        //     if([[SRSubscriptionModel shareKit]IsAppSubscribed])
        //     {
        //         printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - Subscription active, popping view controller\n");
        //         [self.navigationController popViewControllerAnimated:NO];
        //     }
        //     else
        //     {
        //         if ([SuccessStatus integerForKey:@"PurchasedYES"] == 1)
        //         {
        //             printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - Purchased status found, popping view controller\n");
        //             [self.navigationController popViewControllerAnimated:NO];
        //         }
        //     }
        // }
    }
    else
    {
        printf("[FRAME_DEBUG] frameScrollView:selectedItemIndex: - FRAME LOCKED, showing subscription view\n");
        // CGRect _fullscreen = [[UIScreen mainScreen]bounds];
        // CGRect tabbarFrame = CGRectMake(0, _fullscreen.size.height-50, _fullscreen.size.width, 50);
        // _customTabBar.frame = tabbarFrame;  // Commented out - no tab bar
    }
    printf("[FRAME_DEBUG] ========== FRAME SELECTION COMPLETED ==========\n");
}

- (UIImage*)frameScrollView:(FrameScrollView*)gView imageForItemAtIndex:(int)index
{
    int convertedIndex = [self convertIndexToFrameTypeIndex:index];
    NSLog(@"imageForItem %d converted index %d",index,convertedIndex);
    NSString *pPath = [Utility frameThumbNailPathForFrameNumber:convertedIndex];
    return [UIImage imageWithContentsOfFile:pPath];
}

- (UIImage*)frameScrollView:(FrameScrollView*)gView coloredImageForItemAtIndex:(int)index
{
    //index = index - 1;
    int convertedIndex = [self convertIndexToFrameTypeIndex:index];
    NSString *pPath = [Utility  coloredFrameThumbNailPathForFrameNumber:convertedIndex];

    return [UIImage imageWithContentsOfFile:pPath];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    UIImageView *img = (UIImageView*)[self.view viewWithTag:TAG_FRAMEGRID_CONTROLLER];
    if(nil != img)
    {
        [img removeFromSuperview];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
//    if (results) {
//        NSLog(@"sucess");
//
//    }
//    else
//        NSLog(@"Failed with error");
//
//
//}
//- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
//    if (error) {
//
//
//    }
//}

//FB Full Screen ADS
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  //  [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

//Home bar hiding//
-(BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
-(void)setRootviewcontrollerHere
{
   // self.isDynamically = YES;
    NSLog(@"Frame selection controller is selcted");
   // [self dynamicValueClass];
 
}
-(void)dynamicValueClass
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // saving an Integer
   [prefs setInteger:1 forKey:@"ClassDynamic"];

    NSLog(@"ClassDynamic value before %ld",(long)[prefs integerForKey:@"ClassDynamic"]);
}

// MARK: Update Done Button Appearance
-(void)updateDoneButtonAppearance
{
    // Check if a frame is selected
    if (_curSelectedFrameIndex > 0) {
        // Frame selected state: gradient background with black text
        // Remove old gradient layer if exists
        for (CALayer *layer in _customDoneButton.layer.sublayers) {
            if ([layer isKindOfClass:[CAGradientLayer class]]) {
                [layer removeFromSuperlayer];
            }
        }

        // Add gradient layer (green to cyan)
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _customDoneButton.bounds;
        UIColor *greenColor = [UIColor colorWithRed:188/255.0 green:234/255.0 blue:109/255.0 alpha:1.0];
        UIColor *cyanColor = [UIColor colorWithRed:20/255.0 green:249/255.0 blue:245/255.0 alpha:1.0];
        gradientLayer.colors = @[(id)greenColor.CGColor, (id)cyanColor.CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        [_customDoneButton.layer insertSublayer:gradientLayer atIndex:0];

        // Set text color to black
        [_customDoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _customDoneButton.enabled = YES;
    } else {
        // No frame selected state: dark grey background with white text
        // Remove gradient layer
        for (CALayer *layer in _customDoneButton.layer.sublayers) {
            if ([layer isKindOfClass:[CAGradientLayer class]]) {
                [layer removeFromSuperlayer];
            }
        }

        // Set dark grey background
        _customDoneButton.backgroundColor = [UIColor colorWithRed:47/255.0 green:53/255.0 blue:64/255.0 alpha:1.0];

        // Set text color to white
        [_customDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _customDoneButton.enabled = NO;
    }
}

// MARK: Done Button Action
-(void)doneButtonPressed
{
    // Only proceed if a frame is selected
    if (_curSelectedFrameIndex > 0) {
        // Pop the frame selection controller and return to main controller (video selection)
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

