//
//  FrameSelectionController.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 2/3/13.
//
//

#import "FrameSelectionController.h"
#import "OT_Facebook.h"
#import "WCAlertView.h"
#import "OT_TabBar.h"
#import "Config.h"
#import "InAppPurchasePreview.h"
#import "FrameSelectionView.h"
#import "FBLikeUsView.h"
#import "InstagramFollowView.h"
#import "HelpScreenViewController.h"

@interface FrameSelectionController ()<OT_TabBarDelegate,InAppPurchasePreviewViewDelegate,FrameSelectionViewDelegate,FBLikeUsViewDelegate,InstagramFollowViewDelegate>
{
    //UITabBar *_tabbar;
    OT_TabBar *_customTabBar;
    SNPopupView *aspectRatioView;
    
    PopupMenu *_lockedMenu;
    int _curSelectedFrame;
    int _curSelectedGroup;
    int _curTabSelection;
    int _curSelectedFrameIndex;
    UIButton *_appoxeeBadge;
    
    FrameSelectionView *frameSelectionView;
}

@end

typedef struct
{
    int frameNumber;
    BOOL lock;
}tFrameMap;

static BOOL lockstatus[FRAMES_GROUP_LAST][FRAMES_MAX_PERGROUP];

static tFrameMap frame_mapping[FRAMES_MAX_PERGROUP] = {
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

NSString *__templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";

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
    if(bought_allpackages)
    {
        return NO;
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
        memcpy(&lockstatus[0], data.bytes, data.length);
    }
    
    return lockstatus[grp][fil];
}

- (void)showAppoxee:(id)sender
{
    //Ask the Appoxee to appear (only for modal mode)
//    [[AppoxeeManager sharedManager] show];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        _curTabSelection = 0;
        
        _appoxeeBadge = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_appoxeeBadge addTarget:self action:@selector(showAppoxee:) forControlEvents:UIControlEventTouchDown];
        [_appoxeeBadge setImage:[UIImage imageNamed:@"mail box_c.png"] forState:UIControlStateNormal];
        
        // Custom initialization
        [self registerForNotifications];
    }
    return self;
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
    [self unregisterForNotifications];
    [super dealloc];
}


-(void)inAppPurchasePreviewWillExit:(InAppPurchasePreview *)gView
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)restoreDidSelectForInAppPurchasePreview:(InAppPurchasePreview *)gView
{
    [[InAppPurchaseManager Instance]restoreProUpgrade];
}

-(void)inAppPurchasePreview:(InAppPurchasePreview *)gView itemPurchasedAtIndex:(int)index
{

        [[InAppPurchaseManager Instance]puchaseProductWithId:kInAppPurchaseRemoveWaterMarkPack];

}

-(void)addTabbar
{
    CGRect _fullscreen = [[UIScreen mainScreen]bounds];
    _customTabBar = [[OT_TabBar alloc]initWithFrame:CGRectMake(0,_fullscreen.size.height-50,_fullscreen.size.width,50)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _customTabBar . frame = CGRectMake(0, _fullscreen.size.height-70, _fullscreen.size.width, 70);
    }
    _customTabBar.delegate = self;
    _customTabBar.backgroundImage = [UIImage imageNamed:@"bottom bar"];
    _customTabBar.showOverlayOnSelection = NO;

    OT_TabBarItem *frames = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:frame_frame_imageName]
                                                  selectedImage:[UIImage imageNamed:frame_frame_active_imageName]
                                                            tag:0];
    OT_TabBarItem *rateUs = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:rateus_imageName]
                                                  selectedImage:[UIImage imageNamed:rateus_active_imageName]
                                                            tag:1];
    OT_TabBarItem *facebook = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_facebook_imageName]
                                                    selectedImage:[UIImage imageNamed:share_facebook_active_imageName]
                                                              tag:2];
    OT_TabBarItem *mail = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_email_imageName]
                                                selectedImage:[UIImage imageNamed:share_email_active_imageName]
                                                          tag:3];
    OT_TabBarItem *message = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_message_imageName]
                                                   selectedImage:[UIImage imageNamed:share_message_active_imageName]
                                                             tag:4];
    OT_TabBarItem *more = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:more_imageName]
                                                selectedImage:[UIImage imageNamed:more_active_imageName]
                                                          tag:5];

    _customTabBar.items = [NSArray arrayWithObjects:frames,rateUs,facebook,mail,message,more, nil];

    [self.view addSubview:_customTabBar];

    [_customTabBar setSelectedItem:0];

    /* release the resources */
    [_customTabBar release];
    [frames release];
    [rateUs release];
    [more release];
    [facebook release];
    [mail release];
    [message release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == tag_frameselection_rateus)
    {
        if(buttonIndex == 1)
        {
            NSString *reviewURL = [__templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%d", iosAppId]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
        }
        
        [self changeTabbarSelectionBackToDefault];
    }
}

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
    
    /* Now dismiss the controller */
    [controller dismissModalViewControllerAnimated:YES];
}

-(void)referToYourFriendBySMS:(id) sender
{
	MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = [NSString stringWithFormat:@"%@ is an amazing iPhone App. Download it for FREE from %@",appname,ituneslinktoApp];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
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
    
    [controller dismissModalViewControllerAnimated:YES];
}

-(void)referToYourFacebookFriends:(id)sender
{
    [[OT_Facebook SharedInstance] postOnWallWithImageUrl:@"http://photoandvideoapps.com/VideoCollage/icons/Icon-72@2x.png"
                                                 message:@"Check out this App"
                                                 website:@"http://www.videocollageapp.com"
                                                    name:@"VideoCollage"
                                             description:@"VideoCollage allows you to create awesome collage and frames of your photos and videos for FREE. Download it from http://www.videocollageapp.com"
                                                 caption:@"Free iPhone Application"
                                            onCompletion:^(BOOL uploadStatus)
    {
        if(uploadStatus)
        {
            [WCAlertView showAlertWithTitle:@"Thank You" message:[NSString stringWithFormat:@"Thank you very much. You have successfully recommended to your friends"] customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
            } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        else
        {
            [WCAlertView showAlertWithTitle:@"Failed" message:[NSString stringWithFormat:@"Failed to recommend it to your friends"] customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
            } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
    }];
}

-(void)referToYourFriendByEmail:(id)sender
{
    NSAutoreleasePool *localPool     = [[NSAutoreleasePool alloc] init];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        /* We must always check whether the current device is configured for sending emails */
        if ([mailClass canSendMail])
        {
            //NSString *appUrl = applicationUrl;
            NSString *appUrl = ituneslinktoApp;
            
            //NSString *yozioLink = [Yozio getYozioLink:@"Invite Friend by Email" channel:@"email" destinationUrl:appUrl];
            
            NSString *yoziohyperlink = [NSString stringWithFormat:
                                        @"<a href=\"%@\" target=\"itunes_store\">%@</a>",appUrl,appname];
            NSString *emailBody = [NSString stringWithFormat:@"%@ is an amazing iPhone App. Using this app you can combine multiple photos and videos into single layout. Download it for FREE from %@",appname,yoziohyperlink];
            
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
            [self presentModalViewController:picker animated:YES];
            
            /* Free the resources */
            [picker release];
        }
        else
        {
            UIAlertView *emailAlert;
            
            emailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EMAIL",@"Email") message:NSLocalizedString(@"NOEMAIL",@"Email is not configured for this device!!!") delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            
            emailAlert.tag = 11;
            
            /* Show the alert */
            [emailAlert show];
            
            /* Release the alert */
            [emailAlert release];
        }
        
        /* Free the mailclass object */
        [mailClass release];
    }
    
    [localPool release];
    
    return;
}

-(void)continueChangeTabbarSelectionBackToDefault:(id)sender
{
    [_customTabBar setSelectedItem:0];

    return;
}

-(void)changeTabbarSelectionBackToDefault
{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(continueChangeTabbarSelectionBackToDefault:) userInfo:nil repeats:NO];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            
            break;
        }
        case 1:
        {
            [self referToYourFriendByEmail:nil];
            break;
        }
        case 2:
        {
            [self referToYourFriendBySMS:nil];
            break;
        }
        case 3:
        {
            [self referToYourFacebookFriends:nil];
            break;
        }
        default:
        {
            break;
        }
    }

}
-(void)showShareOptions
{
    UIActionSheet *aSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Email",@"Message",@"Facebook", nil];
    aSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //[aSheet showFromTabBar:_tabbar];
    //[aSheet showFromTabBar:_tabbar];
    [aSheet showFromRect:_customTabBar.frame inView:self.view animated:YES];
    [aSheet release];
}

-(void)otTabBar:(OT_TabBar*)tbar didSelectItem:(OT_TabBarItem*)tItem
{
    OT_OfferWallView *o = (OT_OfferWallView*)[self.view viewWithTag:tag_frameselection_otofferwall];
    if(nil != o)
    {
        [o removeFromSuperview];
    }

    switch (tItem.tag)
    {
        case 0:
        {

            break;
        }
        case 1:
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Rate Us" message:@"Did you like the app?. Are you willing to spend less than a minute time for us?. Your greate review will encourage us to add much more features!!!" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            av.tag = tag_frameselection_rateus;
            [av show];
            [av release];
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
            CGRect r = CGRectMake(0.0, 50.0, full.size.width, full.size.height-100);
            OT_OfferWallView *otv = [[OT_OfferWallView alloc]initWithFrame:r style:UITableViewStylePlain];
            otv.tag = tag_frameselection_otofferwall;
            [self.view addSubview:otv];
            [otv release];
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
        [Utility removeActivityIndicatorFrom:self.view];
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
    
    [Utility removeActivityIndicatorFrom:self.view];
}

-(void)aspectRatioChanged:(id)sender
{
    UIButton *btn     = sender;
    eAspectRatio eRat = btn.tag - TAG_ASPECTRATIO_BUTTON;
    NSNumber *num     = [NSNumber numberWithInt:eRat];
    
    /* First show the activity indicator */
    [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
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
        [aspect release];
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
    HelpScreenViewController  *helpScreen = [[HelpScreenViewController alloc] init];
    
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        [self.view addSubview:helpScreen.view];
                         [self.view bringSubviewToFront:helpScreen.view];
                    }
                    completion:NULL];

}

-(UIImageView*)addToolbarWithTitle:(NSString*)title tag:(int)toolbarTag
{
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, customBarHeight)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = UIColorFromRGB(0xFFFFFFFF);
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:20.0];

    UIImageView *toolbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, fullScreen.size.width, customBarHeight)];
    //toolbar.image = [UIImage imageNamed:@"top-bar_vpf"];
    toolbar.userInteractionEnabled = YES;
    toolbar.tag = TAG_TOOLBAR_EDIT;

    [toolbar addSubview:label];
    label.center = toolbar.center;
    [label release];

    UIButton *help = [UIButton buttonWithType:UIButtonTypeInfoLight];
    help. tintColor = [UIColor whiteColor];
    [help addTarget:self action:@selector(performHelp) forControlEvents:UIControlEventTouchUpInside];
    help.frame = CGRectMake(fullScreen.size.width-customBarHeight, 0, customBarHeight, customBarHeight);
    [toolbar addSubview:help];
    help.showsTouchWhenHighlighted = YES;

    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back addTarget:self action:@selector(performBack) forControlEvents:UIControlEventTouchUpInside];
    [back setImage:[UIImage imageNamed:@"back_vpf.png"] forState:UIControlStateNormal];
    back.frame = CGRectMake(0, 0,  customBarHeight, customBarHeight);
    [toolbar addSubview:back];
    back.showsTouchWhenHighlighted = YES;

    UIButton *proButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [proButton addTarget:self action:@selector(openProVersion) forControlEvents:UIControlEventTouchUpInside];
    [proButton setBackgroundImage:[UIImage imageNamed:@"pro 1.png"] forState:UIControlStateNormal];
    proButton.frame = CGRectMake(fullScreen.size.width-pro_x, 0, customBarHeight, customBarHeight);
#if freeVersion
    [toolbar addSubview:proButton];
    proButton.showsTouchWhenHighlighted = YES;
    [self addAnimationToProButton:proButton];
    #endif

    _appoxeeBadge.frame = CGRectMake(fullScreen.size.width-appoxee_button_x, 12.5, 25, 25);
    _appoxeeBadge.showsTouchWhenHighlighted = YES;

    //[toolbar addSubview:_appoxeeBadge];

    [self.view addSubview:toolbar];

    [toolbar release];

    return toolbar;
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
-(void)openProVersion
{
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
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

    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone && fullScreen.size.height>480)
    {
        [proImageView setImage:[UIImage imageNamed:@"ProAd1136.png"] ];
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [proImageView setImage:[UIImage imageNamed:@"ProAd~ipad.png"]];
    }
    [backgroundView addSubview:proImageView];

    UIButton *bigInstallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bigInstallButton.frame     = proImageView.frame;
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
        [[UIApplication sharedApplication] openURL:proUrl];
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

    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationdidfinishwithframeview" object:nil];
    }];

    
}
-(void)customizeTheLookOfTabbar:(UITabBar*)tbar
{
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
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
        return [FrameSelectionController getLockStatusOfFrame:(index-1000) group:[self getGroupIdFromTag:gView.tag]];
        //return [self isFrameLockedAtIndex:(index - 1000)];
    }

    return NO;
}

- (void) receiveNotification:(NSNotification *) notification
{
    if([[notification name]isEqualToString:kInAppPurchaseManagerTransactionSucceededNotification])
    {
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
        [frameSelectionView loadFrames];
        [frameSelectionView release];
    }
    else if([[notification name]isEqualToString:notification_instagram_follow_done])
    {
        NSLog(@" inside instagram notification");
        FrameSelectionView *fsv = (FrameSelectionView*)[self.view viewWithTag:tag_frameselection_view];

        if(nil != fsv)
        {
            int ind = [[[NSUserDefaults standardUserDefaults]objectForKey:key_frame_index_of_follow_inprogress]integerValue];
            NSLog(@"Frame selected is %d",ind);
            [fsv updateInstagramFollowStatus:YES ForItemAtIndex:ind];

            [WCAlertView showAlertWithTitle:@"Thank you!!!" message:[NSString stringWithFormat:@"New frames have been unlocked successfully"] customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
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
                [frameSelectionView loadFrames];
                [frameSelectionView release];
                
            } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
    }
    else if([[notification name]isEqualToString:notification_twitter_follow_done])
    {
        
        FrameSelectionView *fsv = (FrameSelectionView*)[self.view viewWithTag:tag_frameselection_view];

        if(nil != fsv)
        {
            int ind = [[[NSUserDefaults standardUserDefaults]objectForKey:key_frame_index_of_follow_inprogress]integerValue];
            NSLog(@"Frame selected is %d",ind);
            [fsv updateTwitterFollowStatus:YES ForItemAtIndex:ind];
            
            [WCAlertView showAlertWithTitle:@"Thank you!!!" message:[NSString stringWithFormat:@"New frames have been unlocked successfully"] customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
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
                [frameSelectionView loadFrames];
                [frameSelectionView release];
                
            } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
    }
    
    return;
}

-(void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:nil
                                                  object:nil];
}

-(void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    nvm = [Settings Instance];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    //imgView.image        = [UIImage imageWithContentsOfFile:[Utility documentDirectoryPathForFile:@"mainbackground.jpg"]];
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"background_ipad" ofType:@"png"]];
    }
    else
    {
        imgView.image = [UIImage imageNamed:@"background"];
       if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && full_screen.size.height>480) {
        imgView.image = [UIImage imageNamed:@"background_1136.png"] ;
    }

    }

    imgView.tag = TAG_FRAMEGRID_CONTROLLER;
    [self.view addSubview:imgView];
    [imgView release];
    
    self.view.userInteractionEnabled = YES;
    
    /* Add toolbar */
    [self addToolbarWithTitle:@"Frames" tag:tag_frameselection_toolbar];
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGRect fsvRect = CGRectMake(0.0, 50.0, rect.size.width, rect.size.height-100-20);
    frameSelectionView = [[FrameSelectionView alloc]initWithFrame:fsvRect];
    frameSelectionView.delegate = self;
    frameSelectionView.tag = tag_frameselection_view;
    frameSelectionView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:frameSelectionView];
    [frameSelectionView loadFrames];
    [frameSelectionView release];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"FRAMES",@"Frames");
    
    [self addTabbar];
}

- (void)frameSelectionView:(FrameSelectionView *)gView showInAppForItemIndex:(int)index button:(UIButton*)btn
{

    InAppPurchasePreview *preview = [[InAppPurchasePreview alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:preview];
    preview.delegate = self;
    

    NSString *watermarkPackPrice = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseRemoveWaterMarkPack];

    NSString *watermarkPackTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseRemoveWaterMarkPack];

    NSString *watermarkPackDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseRemoveWaterMarkPack];

    
    if(nil == watermarkPackPrice)
    {
        watermarkPackPrice = DEFAULT_WATERMARK_PACK_PRICE;
        watermarkPackTitle = DEFAULT_WATERMARK_PACK_TITLE;
        watermarkPackDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
    }
    
    NSArray *watermarkPackObjs = [NSArray arrayWithObjects:watermarkPackPrice,watermarkPackTitle, watermarkPackDescription,nil];
    NSArray *watermarkPackKeys = [NSArray arrayWithObjects:key_inapppreview_package_price,key_inapppreview_package_msgheading, key_inapppreview_package_msgbody,nil];
    NSDictionary *watermarkPack = [NSDictionary dictionaryWithObjects:watermarkPackObjs forKeys:watermarkPackKeys];
    
    NSArray *packages = [NSArray arrayWithObjects:watermarkPack, nil];
    
    [preview showInAppPurchaseWithPackages:packages];

    return;
}

-(void)frameSelectionView:(FrameSelectionView *)gView selectedItemIndex:(int)index button:(UIButton *)btn
{
    if (proVersion) {
        _curSelectedGroup = [self frameTypeFromIndex:index];

        Settings *set = [Settings Instance];
        set.currentSessionIndex = set.nextFreeSessionIndex;
        set.currentFrameNumber = index;

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:set.currentFrameNumber],@"FrameNumber",[NSNumber numberWithInt:set.currentSessionIndex],@"SessionNumber", nil];
        NSLog(@"Sending new frame selected notification with frames index %d",set.currentFrameNumber);
        [[NSNotificationCenter defaultCenter] postNotificationName:newframeselected object:nil userInfo:params];

        [self dismissModalViewControllerAnimated:NO];
    }else
    {
        if (index == 52) {
            
            NSURL *proversionUrl = [NSURL URLWithString:ituneslinktoProVersion];
            if ([[UIApplication sharedApplication] canOpenURL:proversionUrl]) {
                [[UIApplication sharedApplication] openURL:proversionUrl];

            }
        }else
        {
            _curSelectedGroup = [self frameTypeFromIndex:index];

            Settings *set = [Settings Instance];
            set.currentSessionIndex = set.nextFreeSessionIndex;
            set.currentFrameNumber = index;

            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:set.currentFrameNumber],@"FrameNumber",[NSNumber numberWithInt:set.currentSessionIndex],@"SessionNumber", nil];
            NSLog(@"Sending new frame selected notification with frames index %d",set.currentFrameNumber);
            [[NSNotificationCenter defaultCenter] postNotificationName:newframeselected object:nil userInfo:params];
            
            [self dismissModalViewControllerAnimated:NO];
        }
    }

    
    return;
}

-(void)fbLikeUsView:(FBLikeUsView *)gView willExitWithLikeStatus:(BOOL)liked
{
    if(nil == gView)
    {
        return;
    }
    
    int index = [[gView.userInfo objectForKey:@"index"]integerValue];
    FrameSelectionView *selectionView = [gView.userInfo objectForKey:@"frameSelectionView"];
    
    [selectionView updateFacebookLikeStatus:liked ForItemAtIndex:index];
    
    if(liked)
    {
        [WCAlertView showAlertWithTitle:@"Thank you!!!" message:[NSString stringWithFormat:@"New frames have been unlocked successfully"] customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else
    {
        [WCAlertView showAlertWithTitle:@"Failed!!!" message:[NSString stringWithFormat:@"Failed to like the page"] customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    
    
    return;
}

- (void)frameSelectionView:(FrameSelectionView *)gView showFacebookLikeForItemIndex:(int)index button:(UIButton*)btn
{
    int facebookLockedFrameCount = [FrameSelectionView facebookLockedFrameCount];
    NSString *msgBody = [NSString stringWithFormat:@"Like %@ on Facebook to unlock %d new Frames",appname,facebookLockedFrameCount];
    
    [WCAlertView showAlertWithTitle:@"Like on Facebook" message:msgBody customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if(buttonIndex == 1)
        {
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",gView,@"frameSelectionView", nil];
            FBLikeUsView *fblv = [[FBLikeUsView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
            fblv.delegate = self;
            fblv.userInfo = info;
            [self.view addSubview:fblv];
            [fblv release];
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
}

- (void)frameSelectionView:(FrameSelectionView *)gView showInstagramFollowForItemIndex:(int)index button:(UIButton*)btn
{
    int instagramLockedFrameCount = [FrameSelectionView instagramLockedFrameCount];
    NSString *msgBody = [NSString stringWithFormat:@"Follow %@ on Instagram to unlock %d new Frames",appname,instagramLockedFrameCount];
    
    [WCAlertView showAlertWithTitle:@"Follow us on Instagram" message:msgBody customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if(buttonIndex == 1)
        {
            NSString *instagramProfileLink = @"http://www.instagram.com/outthinking";
            NSURL *instagramUrl = [NSURL URLWithString:instagramProfileLink];
            
            if([[UIApplication sharedApplication]canOpenURL:instagramUrl])
            {
                [[NSUserDefaults standardUserDefaults]setObject:nil
                                                         forKey:key_frame_index_of_follow_inprogress];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:index]
                                                         forKey:key_frame_index_of_follow_inprogress];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES]
                                                         forKey:key_instagram_follow_inprogress];
                [[UIApplication sharedApplication]openURL:instagramUrl];
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
                [[UIApplication sharedApplication]openURL:twitterUrl];
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
    
    if(indexInsidePage < ((rowsPerPage/2)*colPerPage)+1)
    {
        return FRAMES_TYPE_FREE;
    }
    
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
    
    if(indexInsidePage < ((rowsPerPage/2)*colPerPage)+1)
    {
        items = items + indexInsidePage;
        
        return items;//+1;
    }
    
    items = items + (indexInsidePage - ((rowsPerPage/2)*colPerPage));
    
    return 1000+items;//+1;
}

- (BOOL)frameScrollView:(FrameScrollView*)gView contentLockedAtIndex:(int)index
{
    //index = index - 1;
    if(FRAMES_TYPE_FREE == [self frameTypeFromIndex:index])
    {
        return NO;
    }
    
    int frameTypeIndex = [self convertIndexToFrameTypeIndex:index];
    

    return [FrameSelectionController getLockStatusOfFrame:frameTypeIndex-1000 group:FRAMES_TYPE_PREMIUM];
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

-(void)frameScrollView:(FrameScrollView *)gView selectedItemIndex:(int)index button:(UIButton*)btn
{
    _curSelectedGroup = [self frameTypeFromIndex:index];
    _curSelectedFrameIndex = [self convertIndexToFrameTypeIndex:index]; 
    
    NSLog(@"Selected frame %d to frametype _curSelectedFrame %d   _curSelectedFrameIndex %d",index,_curSelectedFrame,_curSelectedFrameIndex);
    
    if(NO == [self frameScrollView:gView contentLockedAtIndex:index])
    {
        Settings *set = [Settings Instance];
        set.currentSessionIndex = set.nextFreeSessionIndex;
        set.currentFrameNumber = _curSelectedFrameIndex;
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:set.currentFrameNumber],@"FrameNumber",[NSNumber numberWithInt:set.currentSessionIndex],@"SessionNumber", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:newframeselected object:nil userInfo:params];
        
        [self dismissModalViewControllerAnimated:NO];
    }
    else
    {
        InAppPurchasePreview *preview = [[InAppPurchasePreview alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        CGRect _fullscreen = [[UIScreen mainScreen]bounds];
        CGRect tabbarFrame = CGRectMake(0, _fullscreen.size.height-50, _fullscreen.size.width, 50);
        _customTabBar.frame = tabbarFrame;
        self.navigationController.navigationBarHidden = YES;
        
        [self.view addSubview:preview];
        preview.delegate = self;
        
        NSArray *framesPackObjs = [NSArray arrayWithObjects:[UIImage imageNamed:@"framesinapp.jpg"],@"1.99",@"Frames Pack", @"Purchasing this pack will get you access to all the frames and also all future frames upgrades for FREE,Also ads will be removed forever",nil];
        NSArray *framesPackKeys = [NSArray arrayWithObjects:key_inapppreview_package_image,key_inapppreview_package_price,key_inapppreview_package_msgheading, key_inapppreview_package_msgbody,nil];
        NSDictionary *framesPack = [NSDictionary dictionaryWithObjects:framesPackObjs forKeys:framesPackKeys];
        NSArray *packages = [NSArray arrayWithObjects:framesPack, nil];
        
        NSLog(@"Calling showInAppPurchaseWithPackages");
        [preview showInAppPurchaseWithPackages:packages];
    }
}

- (UIImage*)frameScrollView:(FrameScrollView*)gView imageForItemAtIndex:(int)index
{
    int convertedIndex = [self convertIndexToFrameTypeIndex:index];
    //NSLog(@"imageForItem %d converted index %d",index,convertedIndex);
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

@end
