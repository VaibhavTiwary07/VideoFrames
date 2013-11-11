//
//  OT_FlurryBannerAd.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 1/12/13.
//
//

#import <UIKit/UIKit.h>
#import "FlurryAds.h"
#import "FlurryAdDelegate.h"
#import "OT_Config.h"
#import "Flurry.h"

#define OT_FLURRY_BANNERADS  1
#define tag_flurrybannerad 98780

#define ot_flurrybannerad_name flurry_bannerad_name

#define ot_flurryfullscreenad_name flurry_fullscreenad_name

@interface OT_FlurryAd : UIView <FlurryAdDelegate>

+(OT_FlurryAd*)sharedInstance;
-(void)showFullscreenAd;
-(void)show;
-(void)hide;

@property(nonatomic,retain)UIView *fullscreenAdView;
@end
