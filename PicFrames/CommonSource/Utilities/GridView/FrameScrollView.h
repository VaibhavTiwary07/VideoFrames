//
//  FrameScrollView.h
//  Instapicframes
//
//  Created by Sunitha Gadigota on 6/8/13.
//
//

#import <UIKit/UIKit.h>
#import "Config.h"

#define DEVICE_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define FSV_PAGECONTROL_HEIGHT ((DEVICE_HEIGHT == 480.0)?40:50)
#define FSV_ITEM_WIDTH ((DEVICE_HEIGHT == 480.0)?(60 * DEV_MULTIPLIER):(70 * DEV_MULTIPLIER))
#define FSV_ITEM_HEIGHT ((DEVICE_HEIGHT == 480.0)?(60 * DEV_MULTIPLIER):(70 * DEV_MULTIPLIER))
//#define FSV_ITEM_WIDTH ((DEVICE_HEIGHT == 480.0)?(40 * DEV_MULTIPLIER):(50 * DEV_MULTIPLIER))
//#define FSV_ITEM_HEIGHT ((DEVICE_HEIGHT == 480.0)?(40 * DEV_MULTIPLIER):(50 * DEV_MULTIPLIER))
#define FSV_TAG_SCROLLVIEW       9001
#define FSV_TAG_PAGECONTROLVIEW  9002

typedef enum
{
    FRAMES_LOCK_MIN,
    FRAMES_LOCK_FREE,
    FRAMES_LOCK_FACEBOOK,
    FRAMES_LOCK_INSTAGRAM,
    FRAMES_LOCK_TWITTER,
    FRAMES_LOCK_INAPP,
    FRAMES_LOCK_MAX
}eLockType;

@class FrameScrollView;

@protocol FrameScrollViewDelegate <NSObject>
@optional
- (eLockType)frameScrollView:(FrameScrollView*)gView contentLockTypeAtIndex:(int)index;
- (void)frameScrollView:(FrameScrollView*)gView selectedItemIndex:(int)index button:(UIButton*)btn;
- (int)rowCountOfFrameScrollView:(FrameScrollView*)gView;
- (int)colCountOfFrameScrollView:(FrameScrollView*)gView;
- (int)totalItemCountOfFrameScrollView:(FrameScrollView*)gView;
- (int)selectedItemIndexOfFrameScrollView:(FrameScrollView*)gView;
- (UIImage*)frameScrollView:(FrameScrollView*)gView imageForItemAtIndex:(int)index;
- (UIImage*)frameScrollView:(FrameScrollView*)gView coloredImageForItemAtIndex:(int)index;
@end

@interface FrameScrollView : UIView<UIScrollViewDelegate>


@property(nonatomic,retain)id<FrameScrollViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame indextag:(int)tag;
- (void)loadPages;
@end
