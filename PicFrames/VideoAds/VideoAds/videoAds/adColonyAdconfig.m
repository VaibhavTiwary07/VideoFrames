//
//  adColonyAdconfig.m
//  videoAds
//
//  Created by Vijaya kumar reddy Doddavala on 3/29/13.
//  Copyright (c) 2013 Vijaya kumar reddy Doddavala. All rights reserved.
//

#import "adColonyAdconfig.h"
#import"AdColonyPublic.h"
#import <objc/runtime.h>
#import "videoAds.h"

@interface adColonyAdconfig() <AdColonyDelegate,AdColonyTakeoverAdDelegate>
{
    BOOL _isVideoWatched;
}

@property(nonatomic,retain)NSString *appSdkId;
@property(nonatomic,retain)NSString *zone1Id;
@property(nonatomic,retain)NSString *zone2Id;
@end

@implementation adColonyAdconfig
@synthesize appSdkId;
static adColonyAdconfig *singletonDelegate = nil;

- ( void ) adColonyTakeoverEndedForZone:( NSString * )zone withVC:( BOOL )withVirtualCurrencyAward
{
    void (^completion)(BOOL filled,BOOL watched) = objc_getAssociatedObject(self, "playVideoCallback");
    if(nil != completion)
    {
        _isVideoWatched = withVirtualCurrencyAward;
        if(withVirtualCurrencyAward)
        {
            /* add reuqest is filled */
            completion(YES,_isVideoWatched);
            NSLog(@"Virtual Currency is awarded !!!!!!!!!!!!!!!!!!!!!!");
        }
        else
        {
            /* add reuqest is filled */
            completion(NO,_isVideoWatched);
            NSLog(@"Virtual Currency is not awarded !!!!!!!!!!!!!!!!!!!!!");
        }
        
        objc_setAssociatedObject(self, "playVideoCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        
    }
}

//Should implement any app-specific code that should be run when AdColony is unable to play a video ad
//or virtual currency video ad
- ( void ) adColonyVideoAdNotServedForZone:( NSString * )zone;
{
    void (^completion)(BOOL filled,BOOL watched) = objc_getAssociatedObject(self, "playVideoCallback");
    if(nil != completion)
    {
        objc_setAssociatedObject(self, "playVideoCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        completion(NO,_isVideoWatched);
    }
}

-(void)playVideoAtSpot:(int)spot inController:(UIViewController*)vc withCompletion:(void (^)(BOOL filled,BOOL watched))completion
{
    objc_setAssociatedObject(self, "playVideoCallback", [completion copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //NSLog(@"playVideoAtSpot called");
    _isVideoWatched = NO;
    [AdColony playVideoAdForSlot:spot withDelegate:self withV4VCPrePopup:NO andV4VCPostPopup:NO];
}

-(void)initAdNetworkWithKeys:(NSMutableDictionary*)keys
{
    NSAssert((nil == self.appSdkId), @"AdcolonyAdConfig: initAdNetworkWithId called multiple times");

    self.appSdkId = [keys objectForKey:videoads_adcolony_sdkkey];
    self.zone1Id  = [keys objectForKey:videoads_adcolony_zone1key];
    self.zone2Id  = [keys objectForKey:videoads_adcolony_zone2key];
    
    NSLog(@"AdColony:initAdNetworkWithKeys:calling initAdColonyWithDelegate");
    
    /* Now let the Adcolony know that we are the delegate */
    [AdColony initAdColonyWithDelegate:self];
}

-(NSDictionary*)adColonyAdZoneNumberAssociation
{
    NSLog(@"adColonyAdZoneNumberAssociation called");
    return[NSDictionary dictionaryWithObjectsAndKeys:self.zone1Id,[NSNumber numberWithInt:1],
           self.zone2Id,[NSNumber numberWithInt:2], nil];
}

-(NSString*)adColonyApplicationID
{
    NSAssert((nil != self.appSdkId), @"AdcolonyAdConfig:Adcolony Called Delegate Method before initializing SDK Id");

    NSLog(@"adColonyApplicationID called");
    return self.appSdkId;
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

+ (adColonyAdconfig *)sharedInstance {
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
