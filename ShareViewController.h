//
//  ShareViewController.h
//  VideoFrames
//
//  Created by Deepti's Mac on 1/24/14.
//
//
#define back_width     (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 40  : 30)
#define play_image        (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? @"play.png": @"play.png")
#import <UIKit/UIKit.h>
#import "Session.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MBProgressHUD.h"


@interface ShareViewController : UIViewController<GADFullScreenContentDelegate>
{
    Settings *nvm;
    UIView *playerView;
    GADInterstitialAd *interstitialAds;
    UIButton *removeWaterMark;
    NSUserDefaults *SuccessStatus;

}
@property(nonatomic,assign) float frameSize;
@property(nonatomic , retain) NSString *videoPath;
@property (nonatomic, assign) bool isVideo;
@property (nonatomic, retain) Session *sess;

//@property(nonatomic , retain) NSURL *SharingURL;
@property (nonatomic, assign) bool isImageToVideo;
@property (nonatomic, assign) bool isMusicAdded;

@property (nonatomic, retain) AVPlayer *player;
@property(nonatomic, strong) UIButton *play;

@property(nonatomic, strong) GADInterstitialAd *interstitial;
@property (nonatomic,assign) int savingCountNumber;

@property (nonatomic,assign) int interestial_HomeButtonClickCount;

//@property (nonatomic,assign) int rateusCountNumber;

@property (nonatomic,assign) int interestial_ShareCount;
@end
