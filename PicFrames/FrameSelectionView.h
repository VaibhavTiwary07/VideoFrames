//
//  FrameSelectionView.h
//  Instapicframes
//
//  Created by Sunitha Gadigota on 7/16/13.
//
//

#import <UIKit/UIKit.h>

//#import "SubscriptionPage.h"
//#import "SubscriptionPage.h"

//#import "UniversalLayout.h"
#import "SimpleSubscriptionView.h"

@class FrameSelectionView;


@protocol FrameSelectionViewDelegate <NSObject>
@optional
- (void)frameSelectionView:(FrameSelectionView*)gView selectedItemIndex:(int)index button:(UIButton*)btn;
- (void)frameSelectionView:(FrameSelectionView *)gView showFacebookLikeForItemIndex:(int)index button:(UIButton*)btn;
- (void)frameSelectionView:(FrameSelectionView *)gView showInstagramFollowForItemIndex:(int)index button:(UIButton*)btn;
- (void)frameSelectionView:(FrameSelectionView *)gView showInAppForItemIndex:(int)index button:(UIButton*)btn;
- (void)frameSelectionView:(FrameSelectionView *)gView showTwitterFollowForItemIndex:(int)index button:(UIButton*)btn;
- (void)frameSelectionView:(FrameSelectionView *)gView showRateUsForItemIndex:(int)index button:(UIButton*)btn;
@end
//#import "MainController.h"
@interface FrameSelectionView : UIView

+(int)facebookLockedFrameCount;
+(int)twitterLockedFrameCount;
+(int)instagramLockedFrameCount;
+(int)rateUsLockedFrameCount;
-(void)loadFrames;
-(void)updateFacebookLikeStatus:(BOOL)liked ForItemAtIndex:(int)index;
-(void)updateInstagramFollowStatus:(BOOL)followed ForItemAtIndex:(int)index;
-(void)updateTwitterFollowStatus:(BOOL)followed ForItemAtIndex:(int)index;
-(void)updateRateUsStatus:(BOOL)rated ForItemAtIndex:(int)index;
@property(nonatomic,assign)id<FrameSelectionViewDelegate> delegate;
@end
