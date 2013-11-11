//
//  flurryAdconfig.m
//  videoAds
//
//  Created by Vijaya kumar reddy Doddavala on 3/30/13.
//  Copyright (c) 2013 Vijaya kumar reddy Doddavala. All rights reserved.
//
#import "videoAds.h"
#if FLURRY_SUPPORT
#import "flurryAdconfig.h"
#import "Flurry.h"
#import "FlurryAds.h"
#import "FlurryAdDelegate.h"
#import "FlurryAppCloudCollectionInfo.h"
#import "FlurryWallet.h"
#import "FlurryAppCloudUser.h"
#import <objc/runtime.h>

@interface flurryAdconfig() <FlurryAdDelegate>
{
    FlurryAppCloudUser *_walletUser;
    BOOL                _isVideoWatched;
}

@property(nonatomic,retain)NSString *appSdkId;
@property(nonatomic,retain)NSString *appAdspace;
@property(nonatomic,retain)UIView   *fullscreenAdView;
@end

@implementation flurryAdconfig
@synthesize appSdkId;
@synthesize fullscreenAdView;
static flurryAdconfig *singletonDelegate = nil;

- (void)spaceDidReceiveAd:(NSString*)adSpace
{
    NSLog(@"Flurry <%@> did receive ad",adSpace);
    if([adSpace isEqualToString:self.appAdspace])
    {
        [FlurryAds displayAdForSpace:self.appAdspace onView:self.fullscreenAdView];
    }
}

- (void) spaceDidFailToReceiveAd:(NSString*)adSpace error:(NSError *)error
{
    void (^completion)(BOOL filled,BOOL watched) = objc_getAssociatedObject(self, "playVideoCallback");
    if(nil != completion)
    {
        objc_setAssociatedObject(self, "playVideoCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        completion(NO,_isVideoWatched);
    }
}

- (void) spaceDidReceiveClick:		(NSString *) 	adSpace
{
    //[FlurryAds removeAdFromSpace:adSpace];
    NSLog(@"Flurry: Click received !!!!!!");
}

- (void) spaceDidFailToRender:(NSString *)space error:(NSError *)error
{
    void (^completion)(BOOL filled,BOOL watched) = objc_getAssociatedObject(self, "playVideoCallback");
    if(nil != completion)
    {
        objc_setAssociatedObject(self, "playVideoCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        completion(NO,_isVideoWatched);
    }
}

- (void)spaceDidDismiss:(NSString *)adSpace interstitial:(BOOL)interstitial;
{
    if(YES != interstitial)
    {
        return;
    }
    
    void (^completion)(BOOL filled,BOOL watched) = objc_getAssociatedObject(self, "playVideoCallback");
    if(nil != completion)
    {
        objc_setAssociatedObject(self, "playVideoCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        completion(YES,_isVideoWatched);
    }
}

-(void)videoDidFinish:(NSString*)adspace
{
    _isVideoWatched = YES;
}

-(void)playVideoAtSpot:(int)spot inController:(UIViewController*)vc withCompletion:(void (^)(BOOL filled,BOOL watched))completion
{
    self.fullscreenAdView = vc.view;
    _isVideoWatched = NO;
    objc_setAssociatedObject(self, "playVideoCallback", [completion copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([FlurryAds adReadyForSpace:self.appAdspace])
    {
        [FlurryAds displayAdForSpace:self.appAdspace onView:vc.view];
    }
    else
    {
        [FlurryAds fetchAdForSpace:self.appAdspace frame:vc.view.frame size:FULLSCREEN];
    }
}

-(void)coinsUpdated:(FlurryWalletInfo *)aWalletInfo error:(NSError*)anError
{
    //NSNumber *currency = [aWalletInfo currencyAmount];
    //FlurryAppCloudUser * walletUser = [FlurryAppCloudUser lastLoggedUser];
    //NSLog(@"User's Currency is %d",[walletUser integerForKey:@"Coins"]);
}

-(void)initAdNetworkWithKeys:(NSMutableDictionary*)keys
{
    NSAssert((nil == self.appSdkId), @"AdcolonyAdConfig: initAdNetworkWithId called multiple times");
    
    self.appSdkId   = [keys objectForKey:videoads_flurry_sdkkey];
    self.appAdspace = [keys objectForKey:videoads_flurry_appspotkey];
    UIViewController *root = [keys objectForKey:videoads_flurry_rootviewcontroller];
    NSLog(@"AdColony:initAdNetworkWithKeys:calling initAdColonyWithDelegate");
    
    /* Now let the Adcolony know that we are the delegate */
    [Flurry startSession:self.appSdkId];
    [FlurryAds initialize:root];
    [FlurryAds setAdDelegate:self];
    [Flurry setDebugLogEnabled:NO];
    [Flurry setShowErrorInLogEnabled:NO];
    
    [FlurryWallet addObserver:self forCurrencyKey:@"Coins" selector:@selector(coinsUpdated:error:)];
    return;
}

/* Singleton implementation */
- (id)init
{
    self = [super init];
    if(nil != self)
    {
        /* For now we don't have anything to initialize here. */
        self.appSdkId = nil;
    }
    return self;
}

+ (flurryAdconfig *)sharedInstance {
	@synchronized(self) {
		if (singletonDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return singletonDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (singletonDelegate == nil) {
			singletonDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return singletonDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}
@end
#endif