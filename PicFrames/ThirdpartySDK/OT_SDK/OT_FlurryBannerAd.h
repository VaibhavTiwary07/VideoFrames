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

#define tag_flurrybannerad 98780

#define ot_flurrybannerad_name ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"InstapiciPadBannerAd":@"Top Banner Ads")

#define ot_flurryfullscreenad_name ((UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())?@"InstapicIpadFullscreenAd":@"FullscreenInstapicframes")

@interface OT_FlurryBannerAd : UIView <FlurryAdDelegate>

+(OT_FlurryBannerAd*)sharedInstance;
-(void)show;
-(void)hide;

@property(nonatomic,retain)UIView *fullscreenAdView;
@end
