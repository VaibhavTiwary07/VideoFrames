//
//  FrameSelectionController.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 2/3/13.
//
//

#import <UIKit/UIKit.h>
#import "FrameGridView.h"
#import "Config.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PopupMenu.h"
#import "UITabBar+CustomBackground.h"
#import "Settings.h"
#import "SNPopupView.h"
#import "Settings.h"
#import "InAppPurchaseManager.h"
#import "HelpGridView.h"
#import "OT_OfferWallView.h"
#import "FrameScrollView.h"

#define tag_frameselection_rateus                 1000
#define tag_frameselection_toolbar                1001
#define tag_frameselection_earnpointsalert        1002
#define tag_frameselection_successfullunlock      1003
#define tag_frameselection_otofferwall            1004
#define tag_frameselection_view                   1166
#define TAPPOINTS_TOUNLOCK_FRAME                  5
#define FRAMES_MAX_PERGROUP                       FRAME_COUNT
#define notification_instagram_follow_done        @"notification_instagram_follow_done"
#define notification_twitter_follow_done          @"notification_twitter_follow_done"
#define notification_rate_app_done                 @"notification_rate_app_done"
#define key_rate_app_inprogress                     @"key_rate_app_inprogress"
#define key_twitter_follow_inprogress             @"key_twitter_follow_inprogress"
#define key_instagram_follow_inprogress           @"key_instagram_follow_inprogress"
#define key_frame_index_of_follow_inprogress      @"key_frame_index_of_follow_inprogress"

typedef enum
{
    FRAMES_GROUP_EVEN,
    FRAMES_GROUP_UNEVEN,
    FRAMES_GROUP_LAST
}eFramesGroup;

typedef enum
{
    FRAMES_TYPE_FREE,
    FRAMES_TYPE_PREMIUM,
    FRAMES_TYPE_MAX
}eFrameType;

@interface FrameSelectionController : UIViewController <UITabBarDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,FrameScrollViewDelegate>
{
    Settings *nvm;
}

+(void)handleIfAnySocialFollowInProgress;

@end
