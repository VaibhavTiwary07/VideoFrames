//
//  OT_AdContorl.m
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 8/11/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "OT_AdContorl.h"

@interface OT_AdControl()
{
    eAdcontrol_Element eCurElement;
    eOT_InterstitialAd _eInterstitial;
    eOT_BannerAd       _eBanner;
    BOOL               _synchedWithServer;
    BOOL               _chartboostReady;
    BOOL               _tapjoyReady;
#if OT_SDK_BANNERADS    
#if OT_SDK_MOPUB        
    MPAdView          *_MopubAdView;
#endif    
    MobclixAdView     *_MobclixAdView;
    ADBannerView      *_IAdView;
#endif    
    BOOL              _gameBreakEnabled;
    int               _gameBreakFrequency;
    BOOL              _gameBreakInitialized;
}
@end
@implementation OT_AdControl
@synthesize eInterstitial;
@synthesize eBanner;
@synthesize synchedWithServer;
@synthesize viewcontroller;

static OT_AdControl *adControlSingleton = nil;

-(eOT_InterstitialAd)eInterstitial
{
    return _eInterstitial;
}

-(void)setEInterstitial:(eOT_InterstitialAd)Interstitial
{
    _eInterstitial = Interstitial;
    
    return;
}

-(eOT_BannerAd)eBanner
{
    return _eBanner;
}

-(void)setEBanner:(eOT_BannerAd)Banner
{
    _eBanner = Banner;
    
    return;
}

-(BOOL)synchedWithServer
{
    return _synchedWithServer;
}

-(void)setSynchedWithServer:(BOOL)bsynchedWithServer
{
    _synchedWithServer = bsynchedWithServer;
    
    return;
}

-(BOOL)isValidUrl:(NSURL*)url
{
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if ([response statusCode] == 404)
    {
        NSLog(@"Adv Xml File %@ doesn't exist",url);
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)isValidLink:(NSString*)link
{
    return [self isValidUrl:[NSURL URLWithString:link]];
}

#pragma mark xml parsing

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
    //NSLog(@"Document started", nil);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
    //NSLog(@"Error: %@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict
{
	eCurElement = ADCONTROL_ELEMENT_IGNORE;
	
	if([elementName isEqualToString:element_Interstitial])
	{
		eCurElement = ADCONTROL_ELEMENT_INTERSTITIAL;
	}
	else if([elementName isEqualToString:element_Banner])
	{
		eCurElement = ADCONTROL_ELEMENT_BANNER;
	}
    else if([elementName isEqualToString:element_Gamebreak])
    {
        eCurElement = ADCONTROL_ELEMENT_GAMEBREAK;
    }
    else if([elementName isEqualToString:element_GamebreakFrequency])
    {
        eCurElement = ADCONTROL_ELEMENT_GAMEBREAK_FREQUENCY;
    }
	
	return;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	eCurElement = ADCONTROL_ELEMENT_IGNORE;
}        

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(eCurElement == ADCONTROL_ELEMENT_INTERSTITIAL)
	{
        _eInterstitial = [string integerValue];
        NSLog(@"AdControl: Interstitial is %d---------------------------------",_eInterstitial);
	}
	else if(eCurElement == ADCONTROL_ELEMENT_BANNER)
    {
		_eBanner = [string integerValue];
        NSLog(@"AdControl: Banner is %d---------------------------------",_eBanner);
    }
    else if(eCurElement == ADCONTROL_ELEMENT_GAMEBREAK)
    {
        _gameBreakEnabled = [string integerValue];
    }
    else if(eCurElement == ADCONTROL_ELEMENT_GAMEBREAK_FREQUENCY)
    {
        _gameBreakFrequency = [string integerValue];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
    // NSLog(@"parserDidEndDocument");
}

-(NSData*)readControlFileFromServer
{
    NSString *url = [[NSString stringWithFormat:ot_control_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSData *pData = nil;
    NSError *err = nil;
    
    if(NO == [self isValidLink:ot_control_url])
    {
        NSLog(@"readControlFileFromServer: Failed to find the file in server");
        return nil;
    }
	
	/* retrieve data */
	pData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:&err];
	if(nil == pData)
	{
        NSLog(@"readControlFileFromServer: Failed to read the file from server");
		return nil;
	}
    
    return pData;
}

-(BOOL)parseData:(NSData*)pData
{
    if(nil == pData)
    {
        return NO;
    }
    
    /* allocate the parser */
	NSXMLParser *pTmp = [[NSXMLParser alloc] initWithData:pData];
    
    /* set the delegate and configure the parser */
    [pTmp setDelegate:self];
    [pTmp setShouldProcessNamespaces:NO];
    [pTmp setShouldReportNamespacePrefixes:NO];
    [pTmp setShouldResolveExternalEntities:NO];
    [pTmp parse];
	
	/* release the resources */
	[pData release];
	[pTmp  release];
    
    return YES;
}

-(void)synchWithServerThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    /* read control file from server */
    NSData *pData = [self readControlFileFromServer];
    if(nil != pData)
    {
        if([self parseData:pData])
        {
            self.synchedWithServer = YES;
        }
        else 
        {
            self.synchedWithServer = NO;
        }
    }
    else 
    {
        self.synchedWithServer = NO;
    }
    
    [pool release];
}

-(eOT_BannerAd)getBannerAdSettingFromServer
{
    if(self.synchedWithServer)
    {
        //NSLog(@"Already synched with server");
        return _eBanner;
    }
    
    //NSLog(@"Not synced with server, so synching it now");
    NSData *pData = [self readControlFileFromServer];
    if(nil != pData)
    {
        if([self parseData:pData])
        {
            self.synchedWithServer = YES;
        }
        else 
        {
            self.synchedWithServer = NO;
        }
    }
    
    return _eBanner;
}

-(BOOL)isGameBreakEnabled
{
    if(upgradedToPro)
    {
        NSLog(@"isGameBreakEnabled - pro version, so don't show ads");
        return NO;
    }
    
    if(self.synchedWithServer)
    {
        //NSLog(@"Already synched with server");
        return _gameBreakEnabled;
    }
    
    //NSLog(@"Not synced with server, so synching it now");
    NSData *pData = [self readControlFileFromServer];
    if(nil != pData)
    {
        if([self parseData:pData])
        {
            self.synchedWithServer = YES;
        }
        else 
        {
            self.synchedWithServer = NO;
        }
    }
    
    return _gameBreakEnabled;
}

-(void)initializeInterstitials
{
    if(upgradedToPro)
    {
        NSLog(@"initializeInterstitials - pro version, so don't show ads");
        
        /* initiaize tapjoy in pro version as well */
        [TapjoyConnect requestTapjoyConnect:ot_tapjoy_appid secretKey:ot_tapjoy_secretkey];
        
        return;
    }
    
#if OT_SDK_INTERSTITIALADS
    if(_eInterstitial != DISABLE_INTERSTITIAL)
    {
#if OT_SDK_CHARTBOOST
        /* Initialize Chartboost */
        Chartboost *cb = [Chartboost sharedChartboost];
        cb.delegate = self;
        cb.appId = ot_chartboost_appid;
        cb.appSignature = ot_chartboost_appsignature;
        
        /* Notify the beginning of a user session */
        [cb startSession];
#endif
        /* Initialize Tapjoy */
        [TapjoyConnect requestTapjoyConnect:ot_tapjoy_appid secretKey:ot_tapjoy_secretkey];
#if OT_SDK_TAPJOYADS
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTapjoyFeaturedApp:) name:TJC_FEATURED_APP_RESPONSE_NOTIFICATION object:nil];
        
        [TapjoyConnect setFeaturedAppDisplayCount:1];
#endif
#if OT_SDK_REVMOBADS
        [RevMobAds startSessionWithAppID:ot_revmob_appid];
#endif
    }
#endif    
}

- (void)didCacheInterstitial:(NSString *)location
{
    _chartboostReady = YES;
}

#if OT_SDK_INTERSTITIALADS
#if OT_SDK_TAPJOYADS
- (void)getTapjoyFeaturedApp:(NSNotification*)notifyObj
{
    //NSLog(@"Tapjoy: getFeaturedApp");
    // notifyObj will be returned as Nil in case of internet error or unavailibity of featured App 
    // or its Max Number of count has exceeded its limit
    TJCFeaturedAppModel *featuredApp = notifyObj.object;
    
    // Show the custom Tapjoy full screen featured app ad view.
    if (featuredApp)
    {
        // Display the featured app here. More details below...
        _tapjoyReady = YES;
    }
}
#endif
#endif

-(void)cacheInterstitials
{
    if(upgradedToPro)
    {
        NSLog(@"cacheInterstitials - pro version, so don't show ads");
        return;
    }
#if OT_SDK_INTERSTITIALADS    
    if(_eInterstitial != DISABLE_INTERSTITIAL)
    {
#if OT_SDK_CHARTBOOST
        Chartboost *cb = [Chartboost sharedChartboost];
        
        [cb cacheInterstitial];
#endif
#if OT_SDK_TAPJOYADS
        [TapjoyConnect getFeaturedApp];
#endif
    }
#endif    
}

#if OT_SDK_INTERSTITIALADS
- (void)didFailToLoadInterstitial:(NSString *)location
{
#if 0
#if OT_SDK_REVMOBADS
    [RevMobAds showFullscreenAd];
#else
    [[OT_PullNotifications sharedInstance]showAsynchPullNotification];
#endif
#endif
    NSLog(@"Chartboost Failed to load interstitials-------------------------%@",location);
}
#endif

-(void)showInterstitialIn:(id)viewcontroller
{
    if(upgradedToPro)
    {
        NSLog(@"showInterstitialIn - pro version, so don't show ads");
        return;
    }
    
    NSLog(@"showInterstitialIn: is called-------------------");
    
#if OT_SDK_INTERSTITIALADS    
    //NSLog(@"showInterstitialIn");
#if OT_SDK_TAPJOYADS
    if((_eInterstitial == TAPJOY_INTERSTITIAL)&&(_tapjoyReady == YES))
    {
        [TapjoyConnect showFeaturedAppFullScreenAd];
        
        return;
    }
    else if(_eInterstitial == SELF_INTERSTITIAL)
#else
    if(_eInterstitial == SELF_INTERSTITIAL)
#endif
    {
        [[OT_PullNotifications sharedInstance]showAsynchPullNotification];
    }
#if OT_SDK_REVMOBADS
    else if(_eInterstitial == REVMOB_INTERSTITIAL)
    {
        [RevMobAds showFullscreenAd];
    }
#endif
    else if(_eInterstitial == DISABLE_INTERSTITIAL)
    {
        return;
    }
#if OT_SDK_CHARTBOOST
    else 
    {
        [[Chartboost sharedChartboost]showInterstitial];
    }
#endif
#endif    
}


#if OT_SDK_BANNERADS  
#pragma mark mobclix delegate
- (BOOL)adView:(MobclixAdView*)adView shouldHandleSuballocationRequest:(MCAdsSuballocationType)suballocationType
{

	if((suballocationType == kMCAdsSuballocationAdMob)||(suballocationType == kMCAdsSuballocationGoogle))
	{
        //NSLog(@"Mobclix: shouldHandleSuballocationRequest Admob YES");
		return YES;
	}
	else if(suballocationType == kMCAdsSuballocationIAd)
	{
        //NSLog(@"Mobclix: shouldHandleSuballocationRequest iAd YES");
		return YES;
	}

	return NO;
}

- (void)adViewDidFinishLoad:(MobclixAdView*)adView
{
    //NSLog(@"Mobclix: adViewDidFinishLoad ");
}

- (NSString*)adView:(MobclixAdView*)adView publisherKeyForSuballocationRequest:(MCAdsSuballocationType)suballocationType
{
	if((suballocationType == kMCAdsSuballocationAdMob)||(suballocationType == kMCAdsSuballocationGoogle))
	{
        //NSLog(@"Mobclix: Returning publisher id for admob");
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            return admobId_ipad;
        }
        else 
        {
            return admobId_iphone;
        }
	}
	else 
	{
		return nil;
	}
}

- (void)adView:(MobclixAdView*)adView didReceiveSuballocationRequest:(MCAdsSuballocationType)suballocationType
{
}

- (void)adView:(MobclixAdView*)adView didFailLoadWithError:(NSError*)error
{
	NSLog(@"MobClix: didFailLoadWithError has received %@",[error localizedRecoveryOptions]);
}

#pragma mark iAd delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"bannerViewDidLoadAd---------------------------------------");
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(_MobclixAdView)
        {
            [_MobclixAdView pauseAdAutoRefresh];
            _MobclixAdView.hidden = YES;
        }
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"didFailToReceiveAdWithError---------------------------------------");
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(_MobclixAdView)
        {
            _MobclixAdView.hidden = NO;
            [_MobclixAdView resumeAdAutoRefresh];
        }
    }
}

#pragma mark mopub delegate
- (UIViewController *)viewControllerForPresentingModalView
{
    if(nil == self.viewcontroller)
    {
        NSLog(@"AdControl:Viewcontroller is not set to display ads");
    }
    
    return self.viewcontroller;
}

#endif

-(void)initializeBannerAds
{
    if(upgradedToPro)
    {
        NSLog(@"initializeBannerAds:Proversion, So don't initialize");
        return;
    }
    
#if OT_SDK_BANNERADS
    if(_eInterstitial != DISABLE_BANNERAD)
    {
        NSLog(@"Initialize Mobclix ads000000000000000000000000000000000");
        [Mobclix startWithApplicationId:ot_mobclix_appid]; 
    }
#endif    
}

-(void)bringBannerAdToFrontInSuperView:(UIView*)view
{
#if OT_SDK_BANNERADS        
    if(nil != _MobclixAdView)
    {
        [view bringSubviewToFront:_MobclixAdView];
    }
#if OT_SDK_MOPUB        
    if(nil != _MopubAdView)
    {
        [view bringSubviewToFront:_MopubAdView];
    }
#endif    
    if(nil != _IAdView)
    {
        [view bringSubviewToFront:_IAdView];
    }
#endif    
}

-(void)removeBannerAds
{
#if OT_SDK_BANNERADS        
    if(nil != _MobclixAdView)
    {
        [_MobclixAdView cancelAd];
        _MobclixAdView.delegate = nil;
        [_MobclixAdView removeFromSuperview];
        _MobclixAdView = nil;
    }
#if OT_SDK_MOPUB        
    if(nil != _MopubAdView)
    {
        _MopubAdView.delegate = nil;
        [_MopubAdView removeFromSuperview];
        _MopubAdView = nil;
    }
#endif    
    if(nil != _IAdView)
    {
        _IAdView.delegate = nil;
        [_IAdView removeFromSuperview];
        _IAdView = nil;
    }
#endif    
}

-(void)pauseBannerAds
{
#if OT_SDK_BANNERADS        
    if(nil != _MobclixAdView)
    {
        [_MobclixAdView pauseAdAutoRefresh];
    }
#endif    
}

-(void)resumeBannerAds
{
#if OT_SDK_BANNERADS        
    if(nil != _MobclixAdView)
    {
        [_MobclixAdView resumeAdAutoRefresh];
    }
#endif    
}

-(void)hideBannerAds
{
#if OT_SDK_BANNERADS        
    if(nil != _MobclixAdView)
    {
        _MobclixAdView.hidden = YES;
    }
#if OT_SDK_MOPUB        
    if(nil != _MopubAdView)
    {
        _MopubAdView.hidden = YES;
    }
#endif    
#endif    
    return;
}

-(void)unhideBannerAds
{
#if OT_SDK_BANNERADS    
#if OT_SDK_MOPUB        
    if(nil != _MopubAdView)
    {
        _MopubAdView.hidden = NO;
    }
#endif    
    if(nil != _MobclixAdView)
    {
        _MobclixAdView.hidden = NO;
    }
#endif    
    return;
}

-(void)addBannerAdToViewController:(UIViewController*)viewCtrl
{
    /* check if ads are enabled */
    if(upgradedToPro)
     {
         NSLog(@"Proversion, So don't ad adds");
         return;
     }
    
#if OT_SDK_BANNERADS        
    eOT_BannerAd eAd = [[OT_AdControl sharedInstance] getBannerAdSettingFromServer];
    self.viewcontroller = viewCtrl;
    //NSLog(@"eAd is %d---------------------------------------------------",eAd);
#if OT_SDK_MOPUB    
    if(eAd == MOPUB_BANNERAD)
    {
        NSLog(@"Adding Mopub Banner Ad--------------------------------------------");
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            _MopubAdView = [[MPAdView alloc] initWithAdUnitId:@"agltb3B1Yi1pbmNyDQsSBFNpdGUYuobyFAw" size:MOPUB_LEADERBOARD_SIZE];
        }
        else 
        {
            _MopubAdView = [[MPAdView alloc] initWithAdUnitId:@"agltb3B1Yi1pbmNyDQsSBFNpdGUYkrToFAw" size:MOPUB_BANNER_SIZE];
        }
        _MopubAdView.delegate = self;
        _MopubAdView.frame = CGRectMake(0,45,_MopubAdView.frame.size.width,_MopubAdView.frame.size.height);
        [_MopubAdView loadAd];
        
        [viewCtrl.view addSubview:_MopubAdView];
        
        _MobclixAdView = nil;
        _IAdView = nil;
    }
    else if(eAd == MOBCLIX_IAD_IPAD_BANNERAD)
#else
    if(eAd == MOBCLIX_IAD_IPAD_BANNERAD)
#endif
    {
        NSLog(@"Adding Mobclix and iAd Banner Ad-------------------------------------");
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            _MobclixAdView = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 728.0f, 90.0f)] autorelease]; 
            _IAdView = [[ADBannerView alloc]initWithFrame:CGRectMake(0.0, 40.0, 728.0, 90.0)];
        }
        else 
        {
            _MobclixAdView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, 50.0f)] autorelease];
            _IAdView = nil;
        }
        
        _MobclixAdView.delegate = self;
        [viewCtrl.view addSubview:_MobclixAdView];
#if OT_SDK_MOPUB            
        _MopubAdView = nil;
#endif        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if(nil != _IAdView)
            {
                _IAdView.delegate = self;
                [viewCtrl.view addSubview:_IAdView];
            }
        }
    }
    else if(eAd == DISABLE_BANNERAD)
    {
        return;
    }
    else 
    {
        NSLog(@"Adding Mobclix Banner Ad-------------------------------------");
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            _MobclixAdView = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 728.0f, 90.0f)] autorelease]; 
        }
        else 
        {
            _MobclixAdView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, 50.0f)] autorelease];
            _IAdView = nil;
        }
        
        _MobclixAdView.delegate = self;
        [viewCtrl.view addSubview:_MobclixAdView];
#if OT_SDK_MOPUB            
        _MopubAdView = nil;
#endif        
        _IAdView = nil;
    }
#endif    
    return;
}

-(void)enablePeriodicAds
{
#if OT_SDK_PERIODICADS    
    if([self isGameBreakEnabled])
    {
        if(_gameBreakInitialized == NO)
        {
            NSLog(@"Initializing GameBrea&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
            [CHADManager init];
            [CHADManager setMinimumAppearanceFrequency:_gameBreakFrequency];
        }
    }
    else 
    {
        [CHADManager setMinimumAppearanceFrequency:0];
    }
#endif    
}

#pragma mark singleton implementation
-(id)init
{
    self = [super init];
    if(self)
    {
        /* Initialize Adcontrol settings with default values
         or read them from nvm memory */
        _eInterstitial = SELF_INTERSTITIAL;
        _eBanner       = MOBCLIX_BANNERAD;
        _synchedWithServer = NO;
        _gameBreakEnabled = NO;
        _gameBreakFrequency = 60;
        _gameBreakInitialized = NO;
        
        /* Start the task to read the upadted settings from server */
        [NSThread detachNewThreadSelector:@selector(synchWithServerThread)
                                 toTarget:self
                               withObject:nil];
        
        return self;
    }
    
    return self;
}

+(OT_AdControl*)sharedInstance 
{
    @synchronized([OT_AdControl class]) 
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
    @synchronized([OT_AdControl class]) 
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
