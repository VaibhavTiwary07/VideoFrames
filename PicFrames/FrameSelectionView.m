//
//  FrameSelectionView.m
//  Instapicframes
//
//  Created by Sunitha Gadigota on 7/16/13.
//
//

#import "FrameSelectionView.h"

#import "FrameScrollView.h"

#import "WCAlertView.h"

#import "Settings.h"

#import "Utility.h"

//#import "SubscriptionPage.h"
//#import "SubscriptionPage.h"
//#import "MainController.h"

@interface FrameSelectionView () <FrameScrollViewDelegate>
{
    int _curSelectedFrame;
    int _curSelectedGroup;
    int _curTabSelection;
    int _curSelectedFrameIndex;
    Settings *nvm;
    FrameScrollView *fsv;
    //ExpiryStatus//
    NSUserDefaults *prefsTime;
    NSUserDefaults *prefsDate;
   // SubscriptionPage *SubscriptionView;
}

@end

//#if defined(VideoCollagePRO)
/* Define the below macro to 1 to see parallel display of both locked and unlocked frames. i.e first
 two rows of each page will have unlocked items, next two rows will be locked items. If the below
 macro is defined as 0 then it will move to serial display, i.e first all unlocked frames will apper
 then all locked frames will appear
 */
#define FRAMES_PARALLEL_DISPLAY_SUPPORT           1

/* Define FRAMES_LOCKED_FRAMES_SUPPORT to 1 to to show the locked frames along with the unlocked frames,
 if it is defined as zero, then only unlocked frames will appear.
 */
#define FRAMES_LOCKED_FRAMES_SUPPORT              1
//#else
/* Define the below macro to 1 to see parallel display of both locked and unlocked frames. i.e first
   two rows of each page will have unlocked items, next two rows will be locked items. If the below
   macro is defined as 0 then it will move to serial display, i.e first all unlocked frames will apper
   then all locked frames will appear
 */
//#define FRAMES_PARALLEL_DISPLAY_SUPPORT           0

/* Define FRAMES_LOCKED_FRAMES_SUPPORT to 1 to to show the locked frames along with the unlocked frames,
 if it is defined as zero, then only unlocked frames will appear.
 */
//#define FRAMES_LOCKED_FRAMES_SUPPORT              0
//#endif


#define FRAMES_INSTAGRAM_LOCK_SUPPORT             1
#define FRAMES_FACEBOOK_LOCK_SUPPORT              1
    //#define FRAMES_INSTAGRAM_LOCK_SUPPORT             1
#define FRAMES_INSTAGRAM_LOCK_INDEX               23
#define FRAMES_FACEBOOK_LOCK_INDEX                31
#define FRAMES_TWITTER_LOCK_INDEX                 40
#define FRAMES_INSTAGRAM_LOCK_FRAMESCOUNT          9
#define FRAMES_FACEBOOK_LOCK_FRAMESCOUNT           9
#define FRAMES_TWITTER_LOCK_FRAMESCOUNT            9

#define FRAMES_RATEUS_LOCK_SUPPORT             0
#define FRAMES_RATEUS_LOCK_INDEX                 18
#define FRAMES_RATEUS_LOCK_FRAMESCOUNT          5

#define FRAMES_MAX_PERGROUP                       FRAME_COUNT
#define FRAMES_ROWS_PERPAGE                       4
#define FRAMES_COLS_PERPAGE                       3
/*
typedef enum
{
    FRAMES_GROUP_EVEN,
    FRAMES_GROUP_UNEVEN,
    FRAMES_GROUP_LAST
}
eFramesGroup;

typedef enum
{
    FRAMES_TYPE_FREE,
    FRAMES_TYPE_PREMIUM,
    FRAMES_TYPE_MAX
}
eFrameType;
*/
typedef struct
{
    int       frameNumber;
    eLockType lockType;
}tFrameMap;

 int lockstatus[FRAMES_GROUP_LAST][FRAMES_MAX_PERGROUP];

 tFrameMap premium_frame_mapping[FRAMES_MAX_PERGROUP] = {
    {1000, FRAMES_LOCK_INAPP}, //dummy entry
    {1001, FRAMES_LOCK_INAPP},
    {1002, FRAMES_LOCK_INAPP},
    {1003, FRAMES_LOCK_INAPP},
    {1004, FRAMES_LOCK_INAPP},
    {1005, FRAMES_LOCK_INAPP},
    {1006, FRAMES_LOCK_INAPP},
    {1007, FRAMES_LOCK_INAPP},
    {1008, FRAMES_LOCK_INAPP},
    {1009, FRAMES_LOCK_INAPP},
    {10010, FRAMES_LOCK_INAPP},
    {10011, FRAMES_LOCK_INAPP},
    {10012, FRAMES_LOCK_INAPP},
    {10013, FRAMES_LOCK_INAPP},
    {10014, FRAMES_LOCK_INAPP},
    {10015, FRAMES_LOCK_INAPP},
    {10016, FRAMES_LOCK_INAPP},
    {10017, FRAMES_LOCK_INAPP},
    {10018, FRAMES_LOCK_INAPP},
    {10019, FRAMES_LOCK_INAPP},
    {10020, FRAMES_LOCK_INAPP},
    {10021, FRAMES_LOCK_INAPP},
    {10022, FRAMES_LOCK_INAPP},
    {10023, FRAMES_LOCK_INAPP},
    {10024, FRAMES_LOCK_INAPP},
    {10025, FRAMES_LOCK_INAPP},
    {10026, FRAMES_LOCK_INAPP},
    {10027, FRAMES_LOCK_INAPP},
    {10028, FRAMES_LOCK_INAPP},
    {10029, FRAMES_LOCK_INAPP},
    {10030, FRAMES_LOCK_INAPP},
    {10031, FRAMES_LOCK_INAPP},
    {10032, FRAMES_LOCK_INAPP},
    {10033, FRAMES_LOCK_INAPP},
    {10034, FRAMES_LOCK_INAPP},
    {10035, FRAMES_LOCK_INAPP},
    {10036, FRAMES_LOCK_INAPP},
    {10037, FRAMES_LOCK_INAPP},
    {10038, FRAMES_LOCK_INAPP},
    {10039, FRAMES_LOCK_INAPP},
    {10040, FRAMES_LOCK_INAPP},
    {10041, FRAMES_LOCK_INAPP},
    {10042, FRAMES_LOCK_INAPP},
    {10043, FRAMES_LOCK_INAPP},
    {10044, FRAMES_LOCK_INAPP},
    {10045, FRAMES_LOCK_INAPP},
    {10046, FRAMES_LOCK_INAPP},
    {10047, FRAMES_LOCK_INAPP},
    {10048, FRAMES_LOCK_INAPP},
    {10049, FRAMES_LOCK_INAPP},
    {10050, FRAMES_LOCK_INAPP},
};

 tFrameMap free_frame_mapping[FRAMES_MAX_PERGROUP];
#if 0
= {
    {0, FRAMES_LOCK_FREE}, //dummy entry
    {1, FRAMES_LOCK_FREE},
    {2, FRAMES_LOCK_FREE},
    {3, FRAMES_LOCK_FREE},
    {4, FRAMES_LOCK_FREE},
    {5, FRAMES_LOCK_FREE},
    {6, FRAMES_LOCK_FREE},
    {7, FRAMES_LOCK_FREE},
    {8, FRAMES_LOCK_FREE},
    {9, FRAMES_LOCK_FREE},
    {10, FRAMES_LOCK_FREE},
    {11, FRAMES_LOCK_FREE},
    {12, FRAMES_LOCK_FREE},
    {13, FRAMES_LOCK_FREE},
    {14, FRAMES_LOCK_FREE},
    {15, FRAMES_LOCK_FREE},
    {16, FRAMES_LOCK_FREE},
    {17, FRAMES_LOCK_FREE},
    {18, FRAMES_LOCK_FREE},
    {19, FRAMES_LOCK_FREE},
    {20, FRAMES_LOCK_FREE},
    {21, FRAMES_LOCK_FREE},
    {22, FRAMES_LOCK_FREE},
    {23, FRAMES_LOCK_FREE},
    {24, FRAMES_LOCK_FREE},
    {25, FRAMES_LOCK_FREE},
    {26, FRAMES_LOCK_FACEBOOK},
    {27, FRAMES_LOCK_FACEBOOK},
    {28, FRAMES_LOCK_FACEBOOK},
    {29, FRAMES_LOCK_FACEBOOK},
    {30, FRAMES_LOCK_FACEBOOK},
    {31, FRAMES_LOCK_FACEBOOK},
    {32, FRAMES_LOCK_FACEBOOK},
    {33, FRAMES_LOCK_FACEBOOK},
    {34, FRAMES_LOCK_FACEBOOK},
    {35, FRAMES_LOCK_FACEBOOK},
    {36, FRAMES_LOCK_FACEBOOK},
    {37, FRAMES_LOCK_FACEBOOK},
    {38, FRAMES_LOCK_FACEBOOK},
    {39, FRAMES_LOCK_FACEBOOK},
    {40, FRAMES_LOCK_FACEBOOK},
    {41, FRAMES_LOCK_FACEBOOK},
    {42, FRAMES_LOCK_FACEBOOK},
    {43, FRAMES_LOCK_FACEBOOK},
    {44, FRAMES_LOCK_FACEBOOK},
    {45, FRAMES_LOCK_FACEBOOK},
    {46, FRAMES_LOCK_FACEBOOK},
    {47, FRAMES_LOCK_FACEBOOK},
    {48, FRAMES_LOCK_FACEBOOK},
    {49, FRAMES_LOCK_FACEBOOK},
    {50, FRAMES_LOCK_FACEBOOK},
    {51, FRAMES_LOCK_FACEBOOK},
    {52, FRAMES_LOCK_FACEBOOK},
};
#endif
//#import "MainController.h"
@implementation FrameSelectionView
@synthesize delegate;


+(void)prefillLockStatusForFreeFrames
{
    for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
    {
        if((FRAMES_FACEBOOK_LOCK_FRAMESCOUNT > 0)&&
           (i >= FRAMES_FACEBOOK_LOCK_INDEX)&&
           (i < FRAMES_FACEBOOK_LOCK_INDEX+FRAMES_FACEBOOK_LOCK_FRAMESCOUNT))
        {
            free_frame_mapping[i].lockType = FRAMES_LOCK_FACEBOOK;
        }
        else if((FRAMES_INSTAGRAM_LOCK_FRAMESCOUNT > 0)&&
                (i >= FRAMES_INSTAGRAM_LOCK_INDEX)&&
                (i < FRAMES_INSTAGRAM_LOCK_INDEX+FRAMES_INSTAGRAM_LOCK_FRAMESCOUNT))
        {
            free_frame_mapping[i].lockType = FRAMES_LOCK_INSTAGRAM;
        }
        else if((FRAMES_TWITTER_LOCK_FRAMESCOUNT > 0)&&
                (i >= FRAMES_TWITTER_LOCK_INDEX)&&
                (i < FRAMES_TWITTER_LOCK_INDEX+FRAMES_TWITTER_LOCK_FRAMESCOUNT))
        {
            free_frame_mapping[i].lockType = FRAMES_LOCK_TWITTER;
        }
#if FRAMES_RATEUS_LOCK_SUPPORT
        else if((FRAMES_RATEUS_LOCK_FRAMESCOUNT > 0)&&
                (i >= FRAMES_RATEUS_LOCK_INDEX)&&
                (i < FRAMES_RATEUS_LOCK_INDEX+FRAMES_RATEUS_LOCK_FRAMESCOUNT))
            {
            free_frame_mapping[i].lockType = FRAMES_LOCK_RATEUS;
            }
#endif
        else
        {
            free_frame_mapping[i].lockType = FRAMES_LOCK_FREE;
        }
       
        NSUserDefaults *SuccessStatus = nil;
        SuccessStatus = [NSUserDefaults standardUserDefaults];
        if([[SRSubscriptionModel shareKit]IsAppSubscribed])
        {
             free_frame_mapping[i].lockType = FRAMES_LOCK_FREE;
        }
        else
        {
            if ([SuccessStatus integerForKey:@"PurchasedYES"] == 1) {
                
                free_frame_mapping[i].lockType = FRAMES_LOCK_FREE;
            }
        }
    }
}

+(int)rateUsLockedFrameCount
{
    int count = 0;
    for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
        {
        if(lockstatus[FRAMES_GROUP_UNEVEN][i] == FRAMES_LOCK_RATEUS)
            {
                count++;
            }
        
        if(lockstatus[FRAMES_GROUP_EVEN][i] == FRAMES_LOCK_RATEUS)
            {
                count++;
            }
        }
    
    return count;
}
+(BOOL)getRateUsStatus
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"ipf_rateUsStatus"];
}
+(void)setRateUsStatus:(BOOL)lockStatus
{
    [[NSUserDefaults standardUserDefaults]setBool:lockStatus forKey:@"ipf_rateUsStatus"];
    
    if(lockStatus == YES)
        {
        for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
            {
            if(lockstatus[FRAMES_GROUP_UNEVEN][i] == FRAMES_LOCK_RATEUS)
                {
                [FrameSelectionView setLockStatusOfFrame:i group:FRAMES_GROUP_UNEVEN to:FRAMES_LOCK_FREE];
                }
            
            if(lockstatus[FRAMES_GROUP_EVEN][i] == FRAMES_LOCK_RATEUS)
                {
                [FrameSelectionView setLockStatusOfFrame:i group:FRAMES_GROUP_EVEN to:FRAMES_LOCK_FREE];
                }
            }
        }
}
+(int)facebookLockedFrameCount
{
    int count = 0;
    for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
    {
        if(lockstatus[FRAMES_GROUP_UNEVEN][i] == FRAMES_LOCK_FACEBOOK)
        {
            count++;
            NSLog(@":::::::::::::::::::::::::::::::::::::");
        }
        
        if(lockstatus[FRAMES_GROUP_EVEN][i] == FRAMES_LOCK_FACEBOOK)
        {
            count++;
        }
    }
    
    return count;
}

+(BOOL)getFacebookLikeStatus
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"ipf_facebookLikeStatus"];
}

+(void)setFacebookLikeStatus:(BOOL)lockStatus
{
    [[NSUserDefaults standardUserDefaults]setBool:lockStatus forKey:@"ipf_facebookLikeStatus"];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"ipf_facebookLikeStatus"]);
    if(lockStatus == YES)
    {
        for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
        {
            if(lockstatus[FRAMES_GROUP_UNEVEN][i] == FRAMES_LOCK_FACEBOOK)
            {
                [FrameSelectionView setLockStatusOfFrame:i group:FRAMES_GROUP_UNEVEN to:FRAMES_LOCK_FREE];
            }
            
            if(lockstatus[FRAMES_GROUP_EVEN][i] == FRAMES_LOCK_FACEBOOK)
            {
                [FrameSelectionView setLockStatusOfFrame:i group:FRAMES_GROUP_EVEN to:FRAMES_LOCK_FREE];
            }
        }
    }
}

+(int)twitterLockedFrameCount
{
    int count = 0;
    for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
    {
        if(lockstatus[FRAMES_GROUP_UNEVEN][i] == FRAMES_LOCK_TWITTER)
        {
            count++;
        }
        
        if(lockstatus[FRAMES_GROUP_EVEN][i] == FRAMES_LOCK_TWITTER)
        {
            count++;
        }
    }
    
    return count;
}

+(BOOL)getTwitterFollowStatus
{

    return [[NSUserDefaults standardUserDefaults]boolForKey:@"ipf_twitterLikeStatus"];
}

+(void)setTwitterFollowStatus:(BOOL)lockStatus
{
    [[NSUserDefaults standardUserDefaults]setBool:lockStatus forKey:@"ipf_twitterLikeStatus"];
    
    if(lockStatus == YES)
    {
        for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
        {
            if(lockstatus[FRAMES_GROUP_UNEVEN][i] == FRAMES_LOCK_TWITTER)
            {
                [FrameSelectionView setLockStatusOfFrame:i group:FRAMES_GROUP_UNEVEN to:FRAMES_LOCK_FREE];
            }
            
            if(lockstatus[FRAMES_GROUP_EVEN][i] == FRAMES_LOCK_TWITTER)
            {
                [FrameSelectionView setLockStatusOfFrame:i group:FRAMES_GROUP_EVEN to:FRAMES_LOCK_FREE];
            }
        }
    }
}

+(int)instagramLockedFrameCount
{
    int count = 0;
    for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
    {
        if(lockstatus[FRAMES_GROUP_UNEVEN][i] == FRAMES_LOCK_INSTAGRAM)
        {
            count++;
        }
        
        if(lockstatus[FRAMES_GROUP_EVEN][i] == FRAMES_LOCK_INSTAGRAM)
        {
            count++;
        }
    }
    
    return count;
}

+(BOOL)getInstagramFollowStatus
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"ipf_instagramFollowStatus"];
}

+(void)setInstagramFollowStatus:(BOOL)lockStatus
{
    [[NSUserDefaults standardUserDefaults]setBool:lockStatus forKey:@"ipf_instagramFollowStatus"];
    NSLog(@" setInstgram follow status : %d",lockStatus);
    if(lockStatus == YES)
    {
        for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
        {
            if(lockstatus[FRAMES_GROUP_UNEVEN][i] == FRAMES_LOCK_INSTAGRAM)
            {

                [FrameSelectionView setLockStatusOfFrame:i group:FRAMES_GROUP_UNEVEN to:FRAMES_LOCK_FREE];
            }
            
            if(lockstatus[FRAMES_GROUP_EVEN][i] == FRAMES_LOCK_INSTAGRAM)
            {
                [FrameSelectionView setLockStatusOfFrame:i group:FRAMES_GROUP_EVEN to:FRAMES_LOCK_FREE];
            }
        }
    }
}

+(void)setLockStatusOfFrame:(int)fil group:(int)grp to:(eLockType)newstatus
{
    if(lockstatus[grp][fil] == newstatus)
    {
        return;
    }
    
    lockstatus[grp][fil] = newstatus;
    NSData *data = [NSData dataWithBytes:&lockstatus[0] length:(sizeof(BOOL) * FRAMES_GROUP_LAST * FRAMES_MAX_PERGROUP)];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"framelockstatus"];
    NSLog(@"%@",data);
    
    return;
}

+(eLockType)getLockStatusOfFrame:(int)fil group:(int)grp
{
    NSUserDefaults *SuccessStatus = nil;
    SuccessStatus = [NSUserDefaults standardUserDefaults];
    if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        NSLog(@"Locked-----2");
        return NO;
    }
    else
    {
        if ([SuccessStatus integerForKey:@"PurchasedYES"] == 1) {
            return NO;
        }
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
        
        /* pre fill lock status for free frames */
        [FrameSelectionView prefillLockStatusForFreeFrames];
        
        /* store the values in lockstatus and upload to defaults */
        for(int i = 0; i < FRAMES_MAX_PERGROUP; i++)
        {
            lockstatus[FRAMES_GROUP_UNEVEN][i] = premium_frame_mapping[i].lockType;
            
            /* By default all even frames are unlocked */
            lockstatus[FRAMES_GROUP_EVEN][i] = free_frame_mapping[i].lockType;
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
    
    //NSLog(@"Lock status of group %d filter %d is %d",grp,fil,lockstatus[grp][fil]);
    if (freeVersion) {
        return lockstatus[grp][fil];
    }else
    {
        return NO;
    }
    
}

-(void)dealloc
{
#if LOCKED_FRAME_SUPPORT
    [self unregisterForNotifications];
#endif
   // [super dealloc];
}

#if LOCKED_FRAMES_SUPPORT

- (int)numberOfItemsInPopupMenu:(PopupMenu*)sender
{
    return 3;
}

- (NSString*)popupMenu:(PopupMenu*)sender titleForItemAtIndex:(int)index
{
    NSString *title = nil;
    switch (index) {
        case 0:
        {
            title = @"All Upgrades - $1.99";
            break;
        }
        case 1:
        {
            title = @"Restore Purchase";
            break;
        }
        case 2:
        {
            title = @"Use it For FREE";
            break;
        }
        default:
        {
            break;
        }
    }
    
    return title;
}

- (UIImage*)popupMenu:(PopupMenu*)sender imageForItemAtIndex:(int)index
{
    if(index == 0)
    {
        return [UIImage imageNamed:@"moneybag.png"];
    }
    
    return [UIImage imageNamed:@"free.png"];
}

- (BOOL)popupMenu:(PopupMenu*)sender enableStatusForItemAtIndex:(int)index
{
    return YES;
}

- (void)popupMenu:(PopupMenu*)sender itemDidSelectAtIndex:(int)index
{
    if(index == 2)
    {
        [[videoAds sharedInstance]showVideoInViewController:self withCompletion:^(eVideoAdStatusCode eStatus){
            if(eStatus == eVideoAdSuccessfullyCompleted)
            {
                [self removeLockedContentMenu];
                
                Settings *set = [Settings Instance];
                set.currentSessionIndex = set.nextFreeSessionIndex;
                set.currentFrameNumber = _curSelectedFrameIndex;
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:set.currentFrameNumber],@"FrameNumber",[NSNumber numberWithInt:set.currentSessionIndex],@"SessionNumber", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:newframeselected object:nil userInfo:params];
                
                [self dismissModalViewControllerAnimated:NO];
            }
            else if(eStatus == eVideoAdUsedCanceledTheAd)
            {
                [WCAlertView showAlertWithTitle:@"Failed" message:[NSString stringWithFormat:@"You need to watch the full video to use this frame"] customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            }
            else
            {
                [WCAlertView showAlertWithTitle:@"Failed" message:[NSString stringWithFormat:@"No Video is availabe try again after sometime"] customizationBlock:NULL completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                } cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            }
        }];
    }
    else if(index == 1)
    {
        NSDictionary *filterParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Pro",@"Product",nil];
        
        [Flurry logEvent:@"InApp Purchase Restore Request" withParameters:filterParams];
        [[InAppPurchaseManager Instance]restoreProUpgrade];
    }
    else if(index == 0)
    {
        NSDictionary *filterParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Pro",@"Product",nil];
        
        [Flurry logEvent:@"InApp Purchase Request" withParameters:filterParams];
        [[InAppPurchaseManager Instance]puchaseProductWithId:kInAppPurchaseProUpgradeProductId];
    }
}

-(void)removeLockedContentMenu
{
    if(nil != _lockedMenu)
    {
        //[_lockedMenu dismissSNPopup];
        _lockedMenu = nil;
    }
}

-(void)continueUnlockingFrame:(NSTimer*)t
{
    /* unlock the content */
    [FrameSelectionController setLockStatusOfFrame:_curSelectedFrame group:_curSelectedGroup to:FRAMES_LOCK_FREE];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[self getTagFromGroup:_curSelectedGroup]],@"Group",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:notification_updateFrameImages object:nil userInfo:param];
    
    NSDictionary *filterParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Uneven", @"Group",
     [NSNumber numberWithInt:_curSelectedFrame], @"Frame",nil];
    
    [Flurry logEvent:@"Successful Filter upgrades using tapjoy" withParameters:filterParams];
    
    [self removeLockedContentMenu];
    
    /* show success alert with remaining points */
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Success" message:[NSString stringWithFormat:@"Congragulations!!, you have successfully unlocked the filter. Your current instapic points count is %d, would you like earn some more FREE points",[tapPoints Instance].curScore] delegate:self cancelButtonTitle: @"No Thanks" otherButtonTitles:@"Earn Free Points", nil];
    al.tag = tag_frameselection_successfullunlock;
    [al show];
    [al release];
}

- (void)popupMenuDidDismiss:(PopupMenu*)sender
{
    
}

- (void) receiveNotification:(NSNotification *) notification
{
    if([[notification name]isEqualToString:kInAppPurchaseManagerTransactionSucceededNotification])
    {
        //[self addunevenFrames];
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
#endif

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

-(int)convertIndexToPageNumber:(int)index
{
    /* find the page number of the index */
    int rowsPerPage  = FRAMES_ROWS_PERPAGE;
    int colPerPage   = FRAMES_COLS_PERPAGE;
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
    int rowsPerPage  = FRAMES_ROWS_PERPAGE;
    int colPerPage   = FRAMES_COLS_PERPAGE;
    int itemsPerPage = rowsPerPage * colPerPage;
    int indexInsidePage = index - ([self convertIndexToPageNumber:index]*itemsPerPage);
    
    return indexInsidePage;
}

#if FRAMES_PARALLEL_DISPLAY_SUPPORT
-(eFrameType)frameTypeFromIndex:(int)index
{
    int indexInsidePage = [self convertIndexToIndexInsidePage:index];
    int colPerPage      = FRAMES_COLS_PERPAGE;
    int rowsPerPage     = FRAMES_ROWS_PERPAGE;
    
    if(indexInsidePage < ((rowsPerPage/2)*colPerPage)+1)
    {
        return FRAMES_TYPE_FREE;
    }

    NSUserDefaults *SuccessStatus = nil;
    SuccessStatus = [NSUserDefaults standardUserDefaults];
    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        return FRAMES_TYPE_PREMIUM;
    }
    else if ([SuccessStatus integerForKey:@"PurchasedYES"] == 1)
        
    {
        return FRAMES_TYPE_PREMIUM;
    }
    else
    {
       
        return FRAMES_TYPE_FREE;
    }
}

-(int)convertIndexToFrameTypeIndex:(int)index
{
    int rowsPerPage  = FRAMES_ROWS_PERPAGE;
    int colPerPage   = FRAMES_COLS_PERPAGE;
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
#else
-(eFrameType)frameTypeFromIndex:(int)index
{
    if(index < FRAME_COUNT)
    {
        return FRAMES_TYPE_FREE;
    }
    
    return FRAMES_TYPE_PREMIUM;
}

-(int)convertIndexToFrameTypeIndex:(int)index
{
    if(index < FRAME_COUNT)
    {
        return index;
    }
    
    int newIndex = index - FRAME_COUNT;
    newIndex     = newIndex + 1;
    
    return 1000+newIndex;
    
}
#endif


-(eLockType)getContentLockTypeForFrameAtIndex:(int)index

{
    //changed frame selection
    eFrameType frmType = FRAMES_TYPE_FREE;
   // eFrameType frmType = FRAMES_LOCK_INAPP;
    //if(FRAMES_TYPE_FREE == [self frameTypeFromIndex:index])
    //{
    //    return FRAMES_LOCK_FREE;
    //}
    
    int frameTypeIndex = [self convertIndexToFrameTypeIndex:index];
    
    if(frameTypeIndex > 1000)
    {   //changed frame selection
       
//        if ([prefs integerForKey:@"Productpurchased"] == 1)
        NSUserDefaults *SuccessStatus = nil;
        prefsTime = [NSUserDefaults standardUserDefaults];
          prefsDate= [NSUserDefaults standardUserDefaults];
       
        SuccessStatus = [NSUserDefaults standardUserDefaults];
//        {
        if(![[SRSubscriptionModel shareKit]IsAppSubscribed])
        {
        frmType = FRAMES_TYPE_PREMIUM;
        frameTypeIndex = frameTypeIndex - 1000;
        }
        else
        {
            if ([SuccessStatus integerForKey:@"PurchasedYES"] == 1)
            {
                frmType = FRAMES_TYPE_PREMIUM;
                frameTypeIndex = frameTypeIndex - 1000;
            }
        }
    }
    
    return [FrameSelectionView getLockStatusOfFrame:frameTypeIndex group:frmType];
}

- (eLockType)frameScrollView:(FrameScrollView*)gView contentLockTypeAtIndex:(int)index
{
    return [self getContentLockTypeForFrameAtIndex:index];
}


- (int)rowCountOfFrameScrollView:(FrameScrollView*)gView
{
    return FRAMES_ROWS_PERPAGE;
}

- (int)colCountOfFrameScrollView:(FrameScrollView*)gView
{
    return FRAMES_COLS_PERPAGE;
}

- (int)totalItemCountOfFrameScrollView:(FrameScrollView*)gView
{
    int count = 0;
#if FRAMES_LOCKED_FRAMES_SUPPORT
    count = FRAME_COUNT+UNEVEN_FRAME_COUNT;
#else
    count = FRAME_COUNT-1;
#endif
    
    return count;
}

- (int)selectedItemIndexOfFrameScrollView:(FrameScrollView*)gView
{
    _curSelectedFrameIndex = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"curSelectedFrameIndex"];
    return _curSelectedFrameIndex;
}

#if LOCKED_FRAME_SUPPORT
-(void)frameScrollView:(FrameScrollView *)gView selectedItemIndex:(int)index button:(UIButton*)btn
{
    printf("\n");
    printf("╔════════════════════════════════════════════════════════════════╗\n");
    printf("║       FrameSelectionView DELEGATE CALLED (INTERMEDIATE)       ║\n");
    printf("╚════════════════════════════════════════════════════════════════╝\n");
    printf("[FRAME_VIEW] Received from FrameScrollView: index=%d\n", index);

    _curSelectedGroup = [self frameTypeFromIndex:index];
    _curSelectedFrameIndex = [self convertIndexToFrameTypeIndex:index];

    printf("[FRAME_VIEW] Converted: group=%d, frameIndex=%d\n", _curSelectedGroup, _curSelectedFrameIndex);

    if(YES == [self frameScrollView:gView contentLockTypeAtIndex:index])
    {
        printf("[FRAME_VIEW] Frame IS LOCKED - showing menu\n");
        if(nil != _lockedMenu)
        {
            _lockedMenu = nil;
        }

        CGPoint p = CGPointMake(gView.frame.origin.x+btn.frame.origin.x+btn.frame.size.width/2.0, gView.frame.origin.y+btn.frame.origin.y);
        _lockedMenu = [[PopupMenu alloc]initWithFrame:CGRectMake(0, 0, 150, 150) style:UITableViewStylePlain delegate:self];
        _lockedMenu.tag = gView.tag;
        [_lockedMenu reloadData];
        _lockedMenu.userInteractionEnabled = YES;
        [_lockedMenu showPopupIn:self.view at:p];
        [_lockedMenu release];
    }
    else
    {
        printf("[FRAME_VIEW] Frame NOT locked\n");

        // REMOVED: Direct notification posting that bypassed FrameSelectionController!
        // This was causing immediate navigation without Done button
        // [[NSNotificationCenter defaultCenter] postNotificationName:createNewSession object:nil];

        printf("[FRAME_VIEW] ✗✗✗ REMOVED AUTOMATIC createNewSession NOTIFICATION ✗✗✗\n");
        printf("[FRAME_VIEW] Calling parent delegate instead (FrameSelectionController)\n");

        // Forward to FrameSelectionController delegate
        if([self.delegate respondsToSelector:@selector(frameSelectionView:selectedItemIndex:button:)])
        {
            printf("[FRAME_VIEW] → Forwarding to FrameSelectionController delegate\n");
            [self.delegate frameSelectionView:self selectedItemIndex:_curSelectedFrameIndex button:btn];
        }
        else
        {
            printf("[FRAME_VIEW] ✗ WARNING: Delegate doesn't respond to selector!\n");
        }
    }

    printf("╔════════════════════════════════════════════════════════════════╗\n");
    printf("║       FrameSelectionView DELEGATE COMPLETED                   ║\n");
    printf("╚════════════════════════════════════════════════════════════════╝\n\n");
    return;
}

#else

-(void)updateFacebookLikeStatus:(BOOL)liked ForItemAtIndex:(int)index
{
    if(liked)
    {
        [FrameSelectionView setFacebookLikeStatus:liked];
        
        if([self.delegate respondsToSelector:@selector(frameSelectionView:selectedItemIndex:button:)])
        {
            _curSelectedFrameIndex = [self convertIndexToFrameTypeIndex:index];
            [self.delegate frameSelectionView:self selectedItemIndex:_curSelectedFrameIndex button:nil];
            [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"_curSelectedFrameIndex"];
        }
    }
}

-(void)updateTwitterFollowStatus:(BOOL)followed ForItemAtIndex:(int)index
{
    if(followed)
    {
        [FrameSelectionView setTwitterFollowStatus:followed];
        
        if([self.delegate respondsToSelector:@selector(frameSelectionView:selectedItemIndex:button:)])
        {
            //_curSelectedFrameIndex = [self convertIndexToFrameTypeIndex:index];
            NSLog(@"Called frameselectionVide:selectedItemAtIndex %d   %d",index,_curSelectedFrame);
           // [self.delegate frameSelectionView:self selectedItemIndex:_curSelectedFrameIndex button:nil];
            
            [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"_curSelectedFrameIndex"];
        }
    }
}

-(void)updateInstagramFollowStatus:(BOOL)followed ForItemAtIndex:(int)index
{
    if(followed)
    {
        NSLog(@"FOLLOW STATUS : %d", followed);
        [FrameSelectionView setInstagramFollowStatus:followed];
        
        if([self.delegate respondsToSelector:@selector(frameSelectionView:selectedItemIndex:button:)])
        {
            NSLog(@" unlock instagram buttons");
           // _curSelectedFrameIndex = [self convertIndexToFrameTypeIndex:index];
         //   [self.delegate frameSelectionView:self selectedItemIndex:_curSelectedFrameIndex button:nil];
            [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"_curSelectedFrameIndex"];
        }
    }
}
-(void)updateRateUsStatus:(BOOL)rated ForItemAtIndex:(int)index
{
    if(rated)
        {
        NSLog(@"rate status : %d", rated);
        [FrameSelectionView setRateUsStatus:rated];
        
        if([self.delegate respondsToSelector:@selector(frameSelectionView:selectedItemIndex:button:)])
            {
            NSLog(@" unlock instagram buttons");
                // _curSelectedFrameIndex = [self convertIndexToFrameTypeIndex:index];
                //   [self.delegate frameSelectionView:self selectedItemIndex:_curSelectedFrameIndex button:nil];
            [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"_curSelectedFrameIndex"];
            }
        }
}
-(void)frameScrollView:(FrameScrollView *)gView selectedItemIndex:(int)index button:(UIButton*)btn
{
    NSLog(@"index is %d",index);
    _curSelectedGroup = [self frameTypeFromIndex:index];
    _curSelectedFrameIndex = [self convertIndexToFrameTypeIndex:index];
    NSLog(@"selected framenumber is----***  %d",_curSelectedGroup);
    NSLog(@"selected framenumber is----*** %d %d",index,_curSelectedFrameIndex);
    if(FRAMES_LOCK_FACEBOOK == [self getContentLockTypeForFrameAtIndex:index])
    {
        if([self.delegate respondsToSelector:@selector(frameSelectionView:showFacebookLikeForItemIndex:button:)])
        {
            [self.delegate frameSelectionView:self showFacebookLikeForItemIndex:index button:btn];
        }
        NSLog(@"FRAMES_LOCK_FACEBOOK locked");
        return;
    }
    else if(FRAMES_LOCK_INSTAGRAM == [self getContentLockTypeForFrameAtIndex:index])
    {
        if([self.delegate respondsToSelector:@selector(frameSelectionView:showInstagramFollowForItemIndex:button:)])
        {
            [self.delegate frameSelectionView:self showInstagramFollowForItemIndex:index button:btn];
        }
        NSLog(@"FRAMES_LOCK_INSTAGRAM locked");
        return;
    }
    else if(FRAMES_LOCK_INAPP == [self getContentLockTypeForFrameAtIndex:index])
    {
        NSLog(@"FRAMES_LOCK_INAPP locked");
        if([self.delegate respondsToSelector:@selector(frameSelectionView:showInAppForItemIndex:button:)])
        {
            
            [self.delegate frameSelectionView:self showInAppForItemIndex:index button:btn];
        }
    }
    else if(FRAMES_LOCK_TWITTER == [self getContentLockTypeForFrameAtIndex:index])
    {
        NSLog(@"FRAMES_LOCK_TWITTER locked");
        if([self.delegate respondsToSelector:@selector(frameSelectionView:showTwitterFollowForItemIndex:button:)])
        {
            
            [self.delegate frameSelectionView:self showTwitterFollowForItemIndex:index button:btn];
        }
    }
    else if (FRAMES_LOCK_RATEUS == [self getContentLockTypeForFrameAtIndex:index])
    {
    NSLog(@"RateUs locked");
    if([self.delegate respondsToSelector:@selector(frameSelectionView:showRateUsForItemIndex:button:)])
        {
        
        [self.delegate frameSelectionView:self showRateUsForItemIndex:index button:btn];
        }
    }
    else if([self.delegate respondsToSelector:@selector(frameSelectionView:selectedItemIndex:button:)])
    {
        NSLog(@"FRAMES_LOCK_FREE not locked _cur Selected Frame Index %d",_curSelectedFrameIndex);
       //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
       // if(_curSelectedFrameIndex <3 ||[prefs integerForKey:@"Productpurchased"] == 1)
        //{
            [self.delegate frameSelectionView:self selectedItemIndex:_curSelectedFrameIndex button:btn];
       // }
       // else{
           
          //[self lockingFrameSelectionView];
            
        //}
    }
  
    NSUserDefaults *SuccessStatus = nil;
    prefsTime = [NSUserDefaults standardUserDefaults];
      prefsDate= [NSUserDefaults standardUserDefaults];
   
    SuccessStatus = [NSUserDefaults standardUserDefaults];
    //change here code//
    if(_curSelectedFrameIndex <3 ||[[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"_curSelectedFrameIndex"];
    }
    
    else if ([SuccessStatus integerForKey:@"PurchasedYES"] == 1)
    {
        [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"_curSelectedFrameIndex"];
    }
    else
    {
        NSLog(@"index is not necessary---");
    }
    return;
}

#endif

- (UIImage*)frameScrollView:(FrameScrollView*)gView imageForItemAtIndex:(int)index
{
    int convertedIndex = [self convertIndexToFrameTypeIndex:index];

    NSString *pPath = [Utility frameThumbNailPathForFrameNumber:convertedIndex];
   // NSLog(@"image shape file path %@",pPath);
    return [UIImage imageWithContentsOfFile:pPath];
}

- (UIImage*)frameScrollView:(FrameScrollView*)gView coloredImageForItemAtIndex:(int)index
{
    //index = index - 1;
    int convertedIndex = [self convertIndexToFrameTypeIndex:index];
    NSString *pPath = [Utility  coloredFrameThumbNailPathForFrameNumber:convertedIndex];
    
    return [UIImage imageWithContentsOfFile:pPath];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect fsvRect = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        
        // Initialization code
        nvm = [Settings Instance];
        self.userInteractionEnabled = YES;
        NSLog(@"before FrameScrollView");
        fsv = [[FrameScrollView alloc]initWithFrame:fsvRect indextag:TAG_EVENFRAME_GRIDVIEW];
        NSLog(@"after FrameScrollView");
        fsv.delegate = self;
        [self addSubview:fsv];
        
    //    [fsv release];
        
#if LOCKED_FRAME_SUPPORT
        [self registerForNotifications];
#endif
    }
    
    return self;
}

-(void)loadFrames
{
    fsv = (FrameScrollView*)[self viewWithTag:TAG_EVENFRAME_GRIDVIEW];
    [fsv loadPages];
}

-(void)lockingFrameSelectionView
{
    [WCAlertView showAlertWithTitle:@"Upgrade To Pro" message:@"This item is locked. Upgrade free version to pro to avail this item." customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
    {
        if (buttonIndex == 0)
        {
            _curSelectedFrameIndex = 2;
            return ;
        }
        else
        {
            //[self openProApp];
            
           //[self ShowSubscriptionViews];
           // [self removeFromSuperview];
            
            
            
        }
    } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade", nil];
   
    
}

-(void)ShowSubscriptionViews
{
    /*//uncomment again
    if (@available(iOS 11.2, *)) {
        SubscriptionPage *subscriptionView = [[SubscriptionPage alloc] init];
        subscriptionView .frameSize = frame_size;
        
        [self addSubview:subscriptionView.view];
    } else {
        // Fallback on earlier versions
        SubscriptionPage *subscriptionView = [[SubscriptionPage alloc] init];
        subscriptionView .frameSize = frame_size;
        
        [self addSubview:subscriptionView.view];
    }
    */
    
    if (@available(iOS 11.2, *)) {
        SimpleSubscriptionView *subscriptionView2 = [[SimpleSubscriptionView alloc] init];
      //  subscriptionView2 .frameSize = frame_size;
        
        [self addSubview:subscriptionView2.view];
    } else {
        // Fallback on earlier versions
        SimpleSubscriptionView *subscriptionView2 = [[SimpleSubscriptionView alloc] init];
        //subscriptionView2 .frameSize = frame_size;
        
        [self addSubview:subscriptionView2.view];
    }
  //  [self presentViewController:subscriptionView animated:NO completion:nil];
   // [subscriptionView presentViewController:subscriptionView animated :NO completion:nil];
}

@end

