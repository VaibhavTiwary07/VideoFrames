//
//  onlineDailyNews.m
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/10/11.
//  Copyright 2011 Out Thinking Private Limited. All rights reserved.
//

#import "OT_Ad.h"
#import "OT_PullNotifications.h"
#import "OT_PullNotificationsPrivate.h"

@interface OT_PullNotifications()
{
    NSXMLParser    *xmlParser;
	NEWS_ELEMENT_E  eCurElement;
	BOOL            bIgnoreCurNode;
    NSMutableArray  *_cache;
    OT_Ad           *_Ad;
	
    BOOL _notifictionsLoaded;
    int iAviableAds;
    int _cacheSize;
}

@property(nonatomic,retain)NSXMLParser *xmlParser;

@end

@implementation OT_PullNotifications

//@synthesize todayNews;
@synthesize xmlParser;


-(int)cacheSize
{
    return _cacheSize;
}

-(void)setCacheSize:(int)cacheSize
{
    if(_cacheSize == cacheSize)
    {
        return;
    }
    
    /* set the cache size */
    _cacheSize = cacheSize;
    
    /* Free the cache and allocate it again */
    NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:_cacheSize];
    [temp addObjectsFromArray:_cache];
    
    /* Free the current cache */
    [_cache release];
    
    /* Initialize the cache */
    _cache = temp;
    
    return;
}

-(id)init
{
    /* set the cache size to default size */
    _cacheSize = ot_default_ad_cache_size;
    
    /* By default set the status to NO */
    _notifictionsLoaded = NO;
    
    /* allocate the cache */
    _cache = [[NSMutableArray alloc]initWithCapacity:ot_default_ad_cache_size];
    
    
    return self;
}

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
	eCurElement = NEWS_ELEMENT_IGNORE;
	
	if([elementName isEqualToString:eNews])
	{
		eCurElement = NEWS_ELEMENT_NEWS;
	}
	else if([elementName isEqualToString:eAppName])
	{
		eCurElement = NEWS_ELEMENT_APPNAME;
	}
	else if([elementName isEqualToString:eDeveloper])
	{
		eCurElement = NEWS_ELEMENT_DEVELOPER;
	}
	else if([elementName isEqualToString:eDescription])
	{
		eCurElement = NEWS_ELEMENT_DESCRIPTION;
	}
	else if ([elementName isEqualToString:eHeading])
    {
		eCurElement = NEWS_ELEMENT_HEADING;
    }
	else if([elementName isEqualToString:ePromotion])
	{
		eCurElement = NEWS_ELEMENT_PROMOTION;
	}
	else if([elementName isEqualToString:eImageUrl])
	{
		eCurElement = NEWS_ELEMENT_IMAGEURL;
	}
	else if([elementName isEqualToString:eAppstoreUrl])
	{
		eCurElement = NEWS_ELEMENT_APPSTOREURL;
	}
    else if([elementName isEqualToString:eAppId])
    {
        eCurElement = NEWS_ELEMENT_APPID;
    }
	
	if(eCurElement != NEWS_ELEMENT_IGNORE)
	{
		//NSLog(@"%@:",elementName);
	}
	
	return;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	eCurElement = NEWS_ELEMENT_IGNORE;
}        

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(eCurElement != NEWS_ELEMENT_IGNORE)
	{
		//NSLog(@"	%@",string);
		//NSString *pStr = [NSString stringWithFormat:@"%s",[string UTF8String]];
	}
    
    if(eCurElement == NEWS_ELEMENT_HEADING)
    {
        //NSLog(@"Heading:%@",string);
    }

    if(eCurElement == NEWS_ELEMENT_APPID)
	{
		if(nil != string)
		{
            NSString *appleid = [NSString stringWithFormat:@"%d",iosAppId];
            NSString *appRegUrl = [NSString stringWithFormat:@"%@://",string];
            NSURL    *appurl  = [NSURL URLWithString:appRegUrl];
			if(NSOrderedSame == [string compare:appleid])
			{
                //NSLog(@"%@ is %@, so no need to install",string,appleid);
				//NSLog(@"eCurAppName appname:%@ - storing",string);
				bIgnoreCurNode = YES;
				//NSLog(@"application name matches, ignore current node");
			}
            else if([[UIApplication sharedApplication]canOpenURL:appurl])
            {
                NSLog(@"%@ already installed %@",string,appurl);
                /* App is already installed, so don't show the alert again */
                bIgnoreCurNode = YES;
            }
			else 
			{
                if(_cacheSize > [_cache count])
                {
                    /* Allocate the new ad */
                    _Ad = [[OT_Ad alloc]init];
                    
                    /* Add the ad to the cache */
                    [_cache addObject:_Ad];
                    
                    /* Release the instance */
                    [_Ad release];
                    
                    /* Icrese the available ad count */
                    iAviableAds++;
                    
                    /* Set the flag so that we don't ignore the ad */
                    bIgnoreCurNode = NO;
                    
                    /* Fill the app id */
                    _Ad.appid = [NSString stringWithString:string];
                }
                else
                {
                    bIgnoreCurNode = YES;
                }
			}
            
            //NSLog(@"Appid in xml:%@ Appid Of App:%@ Don'tDisplay:%d",string,appleid,bIgnoreCurNode);
		}
		else 
		{
			bIgnoreCurNode = YES;
		}
	}
	else if ((eCurElement == NEWS_ELEMENT_PROMOTION) && (bIgnoreCurNode == NO) && (iAviableAds <= _cacheSize))
    {
		_Ad.promotion = [NSString stringWithString:string];
    }
	else if ((eCurElement == NEWS_ELEMENT_DEVELOPER) && (bIgnoreCurNode == NO)&& (iAviableAds <= _cacheSize))
	{
		//NSLog(@"recording developer");
		_Ad.developer = [NSString stringWithString:string];
	}
	else if ((eCurElement == NEWS_ELEMENT_DESCRIPTION) && (bIgnoreCurNode == NO)&& (iAviableAds <= _cacheSize))
	{
        //NSLog(@"description: %@",string);
		_Ad.description = [NSString stringWithFormat:@"%s",[string UTF8String]];
	}
	else if ((eCurElement == NEWS_ELEMENT_HEADING) && (bIgnoreCurNode == NO)&& (iAviableAds <= _cacheSize))
	{
		_Ad.heading = [NSString stringWithFormat:@"%s",[string UTF8String]];
	}
	else if ((eCurElement == NEWS_ELEMENT_IMAGEURL) && (bIgnoreCurNode == NO)&& (iAviableAds <= _cacheSize))
	{
		//NSLog(@"recording image url:%@",string);
		_Ad.imageUrl = [NSString stringWithString:string];
	}
	else if ((eCurElement == NEWS_ELEMENT_APPSTOREURL) && (bIgnoreCurNode == NO)&& (iAviableAds <= _cacheSize))
	{
		//NSLog(@"recording appstore url:%@",string);
		_Ad.appstoreUrl = [NSString stringWithString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
   // NSLog(@"parserDidEndDocument");
}

-(BOOL)parseDailyNews
{
	NSString *url = [[NSString stringWithFormat:ot_config_url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSData *pData = nil;
    NSError *err = nil;
    iAviableAds = 0;
	
	/* retrieve data */
	pData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:&err];
	if(nil == pData)
	{
		return NO;
	}
	
	/* allocate the parser */
	NSXMLParser *pTmp = [[NSXMLParser alloc] initWithData:pData];
	self.xmlParser    = pTmp;
	
	/* set the delegate and configure the parser */
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
	
	/* release the resources */
	[pData release];
	[pTmp  release];
	
	return YES;
}

-(BOOL)loadNotifications
{
	eCurElement = NEWS_ELEMENT_IGNORE;
	
    if(NO == [self webFileExists])
    {
        return NO;
    }
    
    bIgnoreCurNode = YES;
    
	/* parse application list */
	if(NO == [self parseDailyNews])
	{
		return NO;
	}
	
    _notifictionsLoaded = YES;
    
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 0) 
	{
		//[self._newsDelegate doneWithDailyNewsAd];
	}
	else 
	{		        
		UIApplication *app = [UIApplication sharedApplication];
		
		/* retrieve the application information */
		if(nil != _Ad.appstoreUrl)
		{
			/* Set the URL information */
			//if(YES == [app openURL:[NSURL URLWithString:todayNews.appstoreUrl]])
            NSString *appstorestr = [NSString stringWithFormat:genericituneslinktoApp,_Ad.appid];
            if(NO == [app openURL:[NSURL URLWithString:appstorestr]])
            {
                NSLog(@"failed to open the url %@",_Ad.appstoreUrl);
            }
		}
        
		return;
		
	}
}

-(BOOL) webFileExists 
{
    NSString *url  = ot_config_url;
    NSError* error = nil;
    NSHTTPURLResponse* response = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 404)
    {
        NSLog(@"Adv Xml File %@ doesn't exist",ot_config_url);
        return NO;
    }
    else
    {
        return YES;
    }
}

-(int)getAdIndex
{
    int index = 0;
    int mostProbableAdIndex = 0;
    OT_Ad *current = nil;
    OT_Ad *previous = nil;
    
    /* get the first ad with least ref count */
    for(index = [_cache count]-1; index >= 0; index--)
    {
        current = [_cache objectAtIndex:index];
        if(nil == current)
        {
            continue;
        }
        
        if(nil == previous)
        {
            mostProbableAdIndex = index;
            previous = current;
            continue;
        }
        
        if(current.iRefCount <= previous.iRefCount)
        {
            mostProbableAdIndex = index;
        }
        
        previous = current;
    }
    
    return mostProbableAdIndex;
}

-(void)showNewsAlert
{
    NSLog(@"showNewsAlert!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    _Ad = [_cache objectAtIndex:[self getAdIndex]];
    _Ad.iRefCount = _Ad.iRefCount + 1;
    
    NSString *pStr = [NSString stringWithFormat:@"\n%s\n\n %s\n\n",[_Ad.description UTF8String],[_Ad.promotion UTF8String]];
    
    /* show the alert now */
    UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:_Ad.heading message:pStr delegate:self cancelButtonTitle:NSLocalizedString(@"NO",@"NO") otherButtonTitles:NSLocalizedString(@"YES",@"YES"),nil];
    [pAlert show];
    [pAlert release];
    
    return;
}

+(void)createNotification
{
    NSDate *currentDate = [NSDate date];
    NSDate *notificationDate = [currentDate addTimeInterval:(24*60*60)]; 
    //NSDate *notificationDate = [currentDate addTimeInterval:(40)]; 

    // get an instance of our UIApplication
	UIApplication* app = [UIApplication sharedApplication];
    
    // create the notification and then set it's parameters
	UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    if (notification)
    {
        notification.fireDate = notificationDate;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = 0;
		notification.alertBody = @"You have a New Message";
        notification.alertAction = @"Show";
        notification.soundName = UILocalNotificationDefaultSoundName;
		
		// this will schedule the notification to fire at the fire date
		[app scheduleLocalNotification:notification];
		
		// this will fire the notification right away, it will still also fire at the date we set
		//[app presentLocalNotificationNow:notification];
    }
}

-(void)showPullNotification
{
    if(_notifictionsLoaded)
    {
        [self showNewsAlert];
    }
    else 
    {
        if(YES == [self loadNotifications])
        {
            [self showNewsAlert];
        }
    }
}

-(void)showPullNotiticationThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    [self showPullNotification];

    [pool release];
}

-(void)showAsynchPullNotification
{
    [NSThread detachNewThreadSelector:@selector(showPullNotiticationThread)
     						 toTarget:self
     					   withObject:nil];
	return;
}

+(void)scheduleNotification
{
    NSLog(@"Scheduling the Notification");
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if(nil != notifications)
    {
        if(notifications.count > 0)
        {
            NSLog(@"We Already have a scheduled notification");
            return;
        }
    }
    
    NSLog(@"Successfully Scheduled the notification");
    [OT_PullNotifications createNotification];

}

-(void)dealloc
{
    /* Set the properties to nil */
	self.xmlParser = nil;
    
    /* Free the cache */
    [_cache release];
    
    /* call super dealloc */
	[super dealloc];
    
    return;
}

@end
