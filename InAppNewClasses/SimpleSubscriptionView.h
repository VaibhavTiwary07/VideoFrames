//
//  SimpleSubscriptionView.h
//  VideoEditor
//
//  Created by PAVANIOS on 16/06/21.
//  Copyright © 2021 D.Yoganjulu  Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InAppPurchaseManager.h"
#import "AppConfig.h"
#import "SRSubscriptionModel.h"
#import "Utility.h"

#import "RadioButton.h"
#import "BAShimmerButton.h"
#import "TYCyclePagerView.h"
#import "TYCyclePagerTransformLayout.h"
#import "TYCyclePagerViewCell.h"
#import "TYPageControl.h"
#import <Lottie/Lottie.h>
#import <THLabel/THLabel.h>

#define kStrokeColor        [UIColor whiteColor]
#define kStrokeSize            ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 6.0 : 3.0)

@interface SimpleSubscriptionView : UIViewController<UITextViewDelegate,SKRequestDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
{
    //SimpleSubscriptionView *SubController;
    //UIImageView *SubscriptionView;
    
    UIView* backgroundview;
    RadioButton *purchaseMonthButton,*purchaseYearButton,*purchaseWeekButton;
    
    UIView *radioBG;
    UIImageView *bannerImageview;
}
@property (weak, nonatomic) UITextView * _Nullable mytextView,* _Nullable termsTextview;

@property(nonatomic, readonly, nullable)SKProductDiscount *introductoryPrice;

@property (nonatomic,assign) int purchasedCountIs;
@property (nonatomic,assign) int subCountIs;

@property (nonatomic, strong) TYCyclePagerView * _Nullable pagerView;
@property (nonatomic, strong) TYPageControl * _Nullable pageControl;
@property (nonatomic, strong) NSArray * _Nonnull datas;

@property (nonatomic, strong) LOTAnimationView * _Nullable animationView;

-(void)ResoreSubscription;

@end




