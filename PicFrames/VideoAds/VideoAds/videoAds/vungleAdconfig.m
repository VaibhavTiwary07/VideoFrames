//
//  vungleAdconfig.m
//  videoAds
//
//  Created by Vijaya kumar reddy Doddavala on 3/31/13.
//  Copyright (c) 2013 Vijaya kumar reddy Doddavala. All rights reserved.
//

#import "vungleAdconfig.h"
#import "videoAds.h"
#import <objc/runtime.h>
@interface vungleAdconfig() <VGVunglePubDelegate>
{
    BOOL _isVideoWatched;
}

@property(nonatomic,retain)NSString *appSdkId;
@end

@implementation vungleAdconfig
@synthesize appSdkId;
static vungleAdconfig *singletonDelegate = nil;

-(void)vungleViewDidDisappear:(UIViewController*)viewController
{
    void (^completion)(BOOL filled,BOOL watched) = objc_getAssociatedObject(self, "playVideoCallback");
    if(nil != completion)
    {
        objc_setAssociatedObject(self, "playVideoCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        completion(YES,_isVideoWatched);
    }
}

-(void)vungleMoviePlayed:(VGPlayData*)playData
{
    if([playData playedFull])
    {
        _isVideoWatched = YES;
        NSLog(@"Vungle:Movie is played Successfully");
    }
}

-(void)vungleStatusUpdate:(VGStatusData *)statusData
{
    NSLog(@"Description: %@",[statusData description]);
    NSLog(@"Status : %@",[statusData statusString]);
    
}

-(void)playVideoAtSpot:(int)spot inController:(UIViewController*)vc withCompletion:(void (^)(BOOL filled,BOOL watched))completion
{
    objc_setAssociatedObject(self, "playVideoCallback", [completion copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    _isVideoWatched = NO;
    if([VGVunglePub adIsAvailable])
    {
        [VGVunglePub playIncentivizedAd:vc animated:YES showClose:NO userTag:nil];
    }
    else
    {
        //NSLog(@"Vungle: Ad is not available");
        objc_setAssociatedObject(self, "playVideoCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        completion(NO,_isVideoWatched);
    }
}

-(void)initAdNetworkWithKeys:(NSMutableDictionary*)keys
{
    NSAssert((nil == self.appSdkId), @"AdcolonyAdConfig: initAdNetworkWithId called multiple times");
    VGUserData*  data  = [VGUserData defaultUserData];
    
    self.appSdkId  = [keys objectForKey:videoads_vungle_sdkkey];    
    id orientation = [keys objectForKey:videoads_common_orientationkey];
    id location    = [keys objectForKey:videoads_common_locationkey];
    
    data.adOrientation   = VGAdOrientationPortrait;
    data.locationEnabled = NO;
    
    if(nil != orientation)
    {
        if([orientation integerValue] == UIDeviceOrientationPortrait)
        {
            data.adOrientation   = VGAdOrientationPortrait;
        }
        else
        {
            data.adOrientation   = VGAdOrientationLandscape;
        }
    }
    
    if(nil != location)
    {
        data.locationEnabled = [location boolValue];
    }
    
    [VGVunglePub logToStdout:NO];
    
    /* Now let the Adcolony know that we are the delegate */
    [VGVunglePub startWithPubAppID:self.appSdkId userData:data];
    
    [VGVunglePub setDelegate:self];
    
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

+ (vungleAdconfig *)sharedInstance {
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
