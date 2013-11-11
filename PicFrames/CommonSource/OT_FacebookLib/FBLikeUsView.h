//
//  FBLikeUsView.h
//  Instapicframes
//
//  Created by Sunitha Gadigota on 7/28/13.
//
//

#import <UIKit/UIKit.h>

@class FBLikeUsView;
@protocol FBLikeUsViewDelegate <NSObject>
@optional
- (void)fbLikeUsView:(FBLikeUsView*)gView willExitWithLikeStatus:(BOOL)liked;
@end


@interface FBLikeUsView : UIView

@property (nonatomic,assign)id <FBLikeUsViewDelegate> delegate;
@property (nonatomic,retain)id userInfo;
@end
