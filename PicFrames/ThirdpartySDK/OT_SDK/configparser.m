//
//  configparser.m
//  PhotoToSketch
//
//  Created by Vijaya kumar reddy Doddavala on 12/27/12.
//  Copyright (c) 2012 Vijaya kumar reddy Doddavala. All rights reserved.
//

#import "configparser.h"

@interface configparser()
{
    NSXMLParser *xmlParser;
    CONFIG_ELEMENT_E eCurElement;
    BOOL bSyncedWithServer;
    UIView *viewShowingAdView;
    UIButton *adView;
    NSTimer *_shakeTimer;
}
@property(nonatomic,retain)NSData *_data;
@property(nonatomic,retain)NSString *_appid;
@end

@implementation configparser
@synthesize _data;
@synthesize _appid;
@synthesize fullscreenAd;
@synthesize bannerAd;
@synthesize advertisements;
@synthesize imageForAd;
@synthesize urlToOpenOnClickingAd;

static configparser *SettingsSingleton = nil;


-(id)init
{
    self = [super init];
    if(self)
    {
        bSyncedWithServer = NO;
        _shakeTimer = nil;
        return self;
    }
    
    return self;
}

+(configparser*)Instance
{
    @synchronized([configparser class])
	{
        if (SettingsSingleton == nil)
		{
            SettingsSingleton = [[self alloc] init]; // assignment not done here
        }
    }
	
    return SettingsSingleton;
}


+(id)allocWithZone:(NSZone *)zone
{
    @synchronized([configparser class])
	{
        if (SettingsSingleton == nil)
		{
            SettingsSingleton = [super allocWithZone:zone];
            return SettingsSingleton;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}



-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)startSessionWithId:(NSString*)appid
{
    /*
    if(bought_allpackages)
    {
        return;
    }*/

    self._appid = appid;
    
    /* launch a thread to get the data from server */
    [NSThread detachNewThreadSelector:@selector(getConfigurationFromServer)
                             toTarget:self
                           withObject:nil];

    _shakeTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(shakeTheAdView:) userInfo:nil repeats:YES];
    NSLog(@"Scheduled timer !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
}

-(id)initWithData:(NSData*)data
{
    self = [super init];
    if(nil != self)
    {
        self._data = data;
    }
    
    return self;
}

-(id)initWithAppId:(NSString *)appid
{
    self = [super init];
    if(nil != self)
    {
        self._appid = appid;
        
        /* alunch a thread to get the data from server */
        [NSThread detachNewThreadSelector:@selector(getConfigurationFromServer)
                                 toTarget:self
                               withObject:nil];
    }
    
    return self;
}

-(void)getConfigurationFromServer
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.photoandvideoapps.com/phpformgen/use/Configuration/getconfiguration.php?id=%@",self._appid];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [req setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response = nil;
    NSError *err = nil;
    NSData *responsedata = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
    if(nil == responsedata)
    {
        return;
    }
    
    if([response statusCode] != 200)
    {
        return;
    }
    
    /* allocate the parser */
	xmlParser = [[NSXMLParser alloc] initWithData:responsedata];
	
	/* set the delegate and configure the parser */
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
    
    NSLog(@"Exiting getConfigurationFromServer");
}

-(void)handleAdClicked:(id)sender
{
    [[UIApplication sharedApplication]openURL:self.urlToOpenOnClickingAd];
}

- (void)earthquake:(UIView*)itemView
{
    CGFloat t = 2.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:(__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:10];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue])
    {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

-(void)shakeTheAdView:(id)sender
{
    if(nil != adView)
    {
        [self earthquake:adView];
    }
}

-(void)showAdInView:(UIView*)v atPoint:(CGPoint)point
{
    /* first make sure that ad view not yet added, if added delete it */
    UIButton *b = (UIButton*)[v viewWithTag:tag_adview];
    if(nil != b)
    {
        NSLog(@"unscheduled timer !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        //[_shakeTimer invalidate];
        //_shakeTimer = nil;
        [b removeFromSuperview];
    }
    
    viewShowingAdView = v;
    adView = [UIButton buttonWithType:UIButtonTypeCustom];
    adView.tag = tag_adview;
    adView.frame = CGRectMake(point.x, point.y, adviewsize, adviewsize);
    //_shakeTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(shakeTheAdView:) userInfo:nil repeats:YES];
    
    
    /* set the image */
    [adView setBackgroundImage:self.imageForAd forState:UIControlStateNormal];
    
    /* add handler */
    [adView addTarget:self action:@selector(handleAdClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewShowingAdView addSubview:adView];
    
    NSLog(@"Added the adview");
}

-(void)showAdInView:(UIView*)v
{
    /* first make sure that ad view not yet added, if added delete it */
    UIButton *b = (UIButton*)[v viewWithTag:tag_adview];
    if(nil != b)
    {
        NSLog(@"unscheduled timer !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        //[_shakeTimer invalidate];
        //_shakeTimer = nil;
        [b removeFromSuperview];
    }
    
    viewShowingAdView = v;
    adView = [UIButton buttonWithType:UIButtonTypeCustom];
    adView.tag = tag_adview;
    adView.frame = CGRectMake(v.frame.size.width-adviewsize-adviewdistancefromwall, adviewdistancefromwall, adviewsize, adviewsize);
    //_shakeTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(shakeTheAdView:) userInfo:nil repeats:YES];
    
    
    /* set the image */
    [adView setBackgroundImage:self.imageForAd forState:UIControlStateNormal];
    
    /* add handler */
    [adView addTarget:self action:@selector(handleAdClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewShowingAdView addSubview:adView];
    
    NSLog(@"Added the adview");
}

-(void)removeAd
{
    if(nil == viewShowingAdView)
    {
        return;
    }
    
    UIButton *b = (UIButton*)[viewShowingAdView viewWithTag:tag_adview];
    if(nil == b)
    {
        return;
    }
    
    if(nil != _shakeTimer)
    {
        //NSLog(@"unscheduled timer !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        [_shakeTimer invalidate];
    }
    
    [b removeFromSuperview];
}

-(void)bringAdToTheTop
{
    if(nil == viewShowingAdView)
    {
        return;
    }
    
    UIButton *b = (UIButton*)[viewShowingAdView viewWithTag:tag_adview];
    if(nil == b)
    {
        return;
    }
    
    [viewShowingAdView bringSubviewToFront:b];
}

-(void)parseData
{
    /* allocate the parser */
	xmlParser = [[NSXMLParser alloc] initWithData:self._data];
	
	/* set the delegate and configure the parser */
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
    
    NSLog(@"Done With parsing");
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
	eCurElement = CONFIG_ELEMENT_LAST;
	
	if([elementName isEqualToString:@"success"])
	{
		eCurElement = CONFIG_ELEMENT_SUCCESS;
	}
    else if([elementName isEqualToString:@"fullScreenAd"])
	{
		eCurElement = CONFIG_ELEMENT_FULLSCREENAD;
	}
    else if([elementName isEqualToString:@"bannerAd"])
	{
		eCurElement = CONFIG_ELEMENT_BANNERAD;
	}
    else if([elementName isEqualToString:@"enableAdvertisements"])
	{
		eCurElement = CONFIG_ELEMENT_ADVERTISEMENTS;
	}
    else if([elementName isEqualToString:@"linkToImage"])
	{
		eCurElement = CONFIG_ELEMENT_LINKTOIMAGE;
	}
    else if([elementName isEqualToString:@"linkToOpen"])
	{
		eCurElement = CONFIG_ELEMENT_LINKTOOPEN;
	}
	
	return;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	eCurElement = CONFIG_ELEMENT_LAST;
}

-(CONFIG_FULLSCREENAD_E)strToFullscreenAd:(NSString*)str
{
    if([str isEqualToString:@"Chartboost"])
    {
        return CONFIG_FULLSCREENAD_CHARTBOOST;
    }
    else if([str isEqualToString:@"Revmob"])
    {
        return CONFIG_FULLSCREENAD_REVMOB;
    }
    
    return CONFIG_FULLSCREENAD_CHARTBOOST;
}

-(CONFIG_BANNERAD_E)strToBannerAd:(NSString*)str
{
    if([str isEqualToString:@"Mobclix"])
    {
        return CONFIG_BANNERAD_MOBCLIX;
    }
    else if([str isEqualToString:@"Mopub"])
    {
        return CONFIG_BANNERAD_MOPUB;
    }
    
    return CONFIG_BANNERAD_MOBCLIX;
}

-(CONFIG_ADVERTISEMENTS_E)strToAdvertisements:(NSString*)str
{
    if([str isEqualToString:@"Enable"])
    {
        NSLog(@"Advertisements enabled");
        return CONFIG_ADVERTISEMENTS_ENABLE;
    }
    else if([str isEqualToString:@"Disable"])
    {
        NSLog(@"Advertisements disabled");
        return CONFIG_ADVERTISEMENTS_DISABLE;
    }
    
    return CONFIG_ADVERTISEMENTS_ENABLE;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(eCurElement == CONFIG_ELEMENT_SUCCESS)
	{
		if(nil != string)
		{
            bSyncedWithServer = YES;
            NSLog(@"CONFIG_ELEMENT_SUCCESS: %@",string);
        }
	}
    else if(eCurElement == CONFIG_ELEMENT_FULLSCREENAD)
    {
        if(nil != string)
		{
            self.fullscreenAd = [self strToFullscreenAd:string];
            NSLog(@"CONFIG_ELEMENT_FULLSCREENAD: %@",string);
        }
    }
    else if(eCurElement == CONFIG_ELEMENT_BANNERAD)
    {
        if(nil != string)
		{
            self.bannerAd = [self strToBannerAd:string];
            //NSLog(@"CONFIG_ELEMENT_BANNERAD: %@",string);
        }
    }
    else if(eCurElement == CONFIG_ELEMENT_ADVERTISEMENTS)
    {
        if(nil != string)
		{
            self.advertisements = [self strToAdvertisements:string];
            NSLog(@"CONFIG_ELEMENT_ADVERTISEMENTS: %@",string);
        }
    }
    else if(eCurElement == CONFIG_ELEMENT_LINKTOIMAGE)
    {
        if(nil != string)
		{
            NSError* error = nil;
            NSHTTPURLResponse* response = nil;
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:string] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
            
            NSData *imgData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            /* get the image */
            //NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:string]];
            if(nil != imgData)
            {
                NSLog(@"successfully downloaded the image");
                self.imageForAd = [UIImage imageWithData:imgData];
                //[imgData release];
            }
            else
            {
                NSLog(@"FailedTo get the image from server");
            }
            
            NSLog(@"CONFIG_ELEMENT_LINKTOIMAGE: %@",string);
        }
    }
    else if(eCurElement == CONFIG_ELEMENT_LINKTOOPEN)
    {
        if(nil != string)
		{
            #define linktoApp @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8"
            NSString *str = [NSString stringWithFormat:linktoApp,string];
            self.urlToOpenOnClickingAd = [NSURL URLWithString:str];
            NSLog(@"CONFIG_ELEMENT_LINKTOOPEN: %@",string);
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // NSLog(@"parserDidEndDocument");
    /* Now release the parser */
    //[xmlParser release];
    
    /* send notification, so that view can start showing the ad */
    [[NSNotificationCenter defaultCenter]postNotificationName:notification_syncedwithconfigserver object:nil];
}

@end
