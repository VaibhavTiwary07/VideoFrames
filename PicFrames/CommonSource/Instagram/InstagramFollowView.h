//
//  FBLikeUsView.h
//  Instapicframes
//
//  Created by Sunitha Gadigota on 7/28/13.
//
//

#import <UIKit/UIKit.h>

@class InstagramFollowView;
@protocol InstagramFollowViewDelegate <NSObject>
@optional
- (void)instagramFollowView:(InstagramFollowView*)gView willExitWithFollowStatus:(BOOL)followed;
@end


@interface InstagramFollowView : UIView

@property (nonatomic,assign)id <InstagramFollowViewDelegate> delegate;
@property (nonatomic,retain)id userInfo;
@end
