//
//  OT_FlurryBannerAd.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 1/12/13.
//
//

#import "OT_FlurryBannerAd.h"

@implementation OT_FlurryBannerAd

static OT_FlurryBannerAd *adControlSingleton = nil;

-(void)show
{
    if(upgradedToPro)
    {
        NSLog(@"Pro version, so don't show flurry banner ads");
        return;
    }
    
    [FlurryAds fetchAndDisplayAdForSpace:ot_flurrybannerad_name
                                    view:self size:BANNER_TOP];
}

-(void)hide
{
    [FlurryAds removeAdFromSpace:ot_flurrybannerad_name];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (NSString *)appSpotAdMobPublisherID
{
    //NSLog(@"appSpotAdMobPublisherID - called !!!!!!!!!!!!!!!!!!!!!!!!!000000000099999999888888");
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        return admobId_ipad;
    }
    
    return admobId_iphone;
}

-(NSString *)appSpotMobclixApplicationID
{
    return ot_mobclix_appid;
}

- (NSString *)appSpotMillennialAppKey
{
    //NSLog(@"appSpotMillennialAppKey - called !!!!!!!!!!!!!!!!!!!!!!!!!000000000099999999888888");
    return ot_mmedia_bannerad;
}

-(NSString*)appSpotInMobiAppKey
{
    //NSLog(@"appSpotInMobiAppKey - called !!!!!!!!!!!!!!!!!!!!!!!!!000000000099999999888888");
    return ot_inmobi_appid;
}

-(NSString*)appSpotMillennialInterstitalAppKey
{
    //NSLog(@"appSpotMillennialInterstitalAppKey - called !!!!!!!!!!!!!!!!!!!!!!!!!000000000099999999888888");
    return ot_mmedia_fullscreen;
}

- (void) spaceDidReceiveAd:(NSString*)adSpace
{
    if(upgradedToPro)
    {
        NSLog(@"Pro version, so don't show %@ ads",adSpace);
        return;
    }
    
    NSLog(@"Flurry <%@> did receive ad",adSpace);
    if([adSpace isEqualToString:ot_flurryfullscreenad_name])
    {
        [FlurryAds displayAdForSpace:ot_flurryfullscreenad_name onView:self.fullscreenAdView];
    }
}

#pragma mark singleton implementation
-(id)init
{
    CGRect full    = [[UIScreen mainScreen]bounds];
    CGRect adFrame = CGRectMake(0.0, 44.0, full.size.width, 50.0);
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        adFrame = CGRectMake(0.0, 44.0, full.size.width, 90.0);
    }
    
    self = [super initWithFrame:adFrame];
    if(self)
    {
        [FlurryAds setAdDelegate:self];
    }
    
    return self;
}

+(OT_FlurryBannerAd*)sharedInstance
{
    @synchronized([OT_FlurryBannerAd class])
	{
        if (adControlSingleton == nil)
		{
            [[self alloc] init]; // assignment not done here
        }
    }
	
    return adControlSingleton;
}


+(id)allocWithZone:(NSZone *)zone
{
    @synchronized([OT_FlurryBannerAd class])
	{
        if (adControlSingleton == nil)
		{
            adControlSingleton = [super allocWithZone:zone];
            return adControlSingleton;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


-(void)dealloc
{
    [super dealloc];
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}


-(id)retain
{
    return self;
}


-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be release
}


-(oneway void)release
{
    //do nothing
}

-(id)autorelease
{
    return self;
}

@end
