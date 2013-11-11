//
//  onlineDailyNews.m
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/10/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "onlineDailyNews.h"


@implementation onlineDailyNews

@synthesize todayNews;
@synthesize xmlParser;
@synthesize _newsDelegate;


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
	//NSLog(@"	%@",string);
#ifdef CROSSPRAMOTION_VER1        
	if(eCurElement == NEWS_ELEMENT_APPNAME)
	{
        //NSLog(@"Appname:%@",string);
		if(nil != string)
		{
			if(NSOrderedSame == [string compare:eCurAppName])
			{
				//NSLog(@"eCurAppName appname:%@ - storing",string);
				bIgnoreCurNode = NO;
				//NSLog(@"application name matches, ignore current node");
			}
			else if(NSOrderedSame == [string compare:eAllApps])
			{
				//NSLog(@"appname:%@ - storing",string);
				bIgnoreCurNode = NO;
			}
			else 
			{
				//NSLog(@"appname:%@ - ignoring",string);
				//NSLog(@"application name doesn't matches, so recording the node");
				bIgnoreCurNode = YES;
			}

		}
		else 
		{
			bIgnoreCurNode = NO;
		}

	}
#else
    if(eCurElement == NEWS_ELEMENT_APPID)
	{
        //NSLog(@"Appname:%@",string);
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
                iAviableAds++;
				bIgnoreCurNode = NO;
                self.todayNews.appid = [NSString stringWithString:string];
			}
            
            //NSLog(@"Appid in xml:%@ Appid Of App:%@ Don'tDisplay:%d",string,appleid,bIgnoreCurNode);
		}
		else 
		{
			bIgnoreCurNode = YES;
		}
	}
#endif
	else if ((eCurElement == NEWS_ELEMENT_PROMOTION) && (bIgnoreCurNode == NO) && (iAviableAds <= 1))
    {
		//NSLog(@"promotion: %@",string);
		self.todayNews.promotion = [NSString stringWithString:string];
    }
	else if ((eCurElement == NEWS_ELEMENT_DEVELOPER) && (bIgnoreCurNode == NO)&& (iAviableAds <= 1))
	{
		//NSLog(@"recording developer");
		self.todayNews.developer = [NSString stringWithString:string];
	}
	else if ((eCurElement == NEWS_ELEMENT_DESCRIPTION) && (bIgnoreCurNode == NO)&& (iAviableAds <= 1))
	{
        //NSLog(@"description: %@",string);
		self.todayNews.description = [NSString stringWithFormat:@"%s",[string UTF8String]];
	}
	else if ((eCurElement == NEWS_ELEMENT_HEADING) && (bIgnoreCurNode == NO)&& (iAviableAds <= 1))
	{
		self.todayNews.heading = [NSString stringWithFormat:@"%s",[string UTF8String]];
	}
	else if ((eCurElement == NEWS_ELEMENT_IMAGEURL) && (bIgnoreCurNode == NO)&& (iAviableAds <= 1))
	{
		//NSLog(@"recording image url:%@",string);
		self.todayNews.imageUrl = [NSString stringWithString:string];
	}
	else if ((eCurElement == NEWS_ELEMENT_APPSTOREURL) && (bIgnoreCurNode == NO)&& (iAviableAds <= 1))
	{
		//NSLog(@"recording appstore url:%@",string);
		self.todayNews.appstoreUrl = [NSString stringWithString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
   // NSLog(@"parserDidEndDocument");
}

-(BOOL)parseDailyNews
{
	NSString *url = [[NSString stringWithFormat:linktoAdvXml] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

-(BOOL)retriveDailyNews
{
	eCurElement = NEWS_ELEMENT_IGNORE;
	
	/* Allocate the application */
	news *tmp        = [[news alloc]init];
	self.todayNews   = tmp;
	[tmp release];
	
	/* parse application list */
	if(NO == [self parseDailyNews])
	{
		return NO;
	}
	
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 0) 
	{
		[self._newsDelegate doneWithDailyNewsAd];
	}
	else 
	{		        
		UIApplication *app = [UIApplication sharedApplication];
		
		/* retrieve the application information */
		if(nil != todayNews.appstoreUrl)
		{
			/* Set the URL information */
			//if(YES == [app openURL:[NSURL URLWithString:todayNews.appstoreUrl]])
            NSString *appstorestr = [NSString stringWithFormat:genericituneslinktoApp,self.todayNews.appid];
            if(NO == [app openURL:[NSURL URLWithString:appstorestr]])
            {
                NSLog(@"failed to open the url %@",todayNews.appstoreUrl);
            }
		}
        
		return;
		
	}
}

-(BOOL) webFileExists 
{
    NSString *url  = linktoAdvXml;
    NSError* error = nil;
    NSHTTPURLResponse* response = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 404)
    {
        NSLog(@"Adv Xml File %@ doesn't exist",linktoAdvXml);
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)showNewsAlert
{
    NSString *pStr = [NSString stringWithFormat:@"\n%s\n\n %s\n\n",[todayNews.description UTF8String],[todayNews.promotion UTF8String]];
    
    /* show the alert now */
    UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:todayNews.heading message:pStr delegate:self cancelButtonTitle:NSLocalizedString(@"NO",@"NO") otherButtonTitles:NSLocalizedString(@"YES",@"YES"),nil];
    [pAlert show];
    [pAlert release];
    
    return;
}

-(BOOL)retrieveAndDislayTodaysAdd
{
    if(NO == [self webFileExists])
    {
        return FALSE;
    }
    
    bIgnoreCurNode = YES;
	
	/* first retrieve todays news */
	if(YES == [self retriveDailyNews])
	{
		if((nil != self.todayNews.description)&&(nil != self.todayNews.promotion))
		{
            [self showNewsAlert];
		}
	}
	else 
	{
		[self._newsDelegate doneWithDailyNewsAd];
	}
	
	return YES;
}

-(void)dealloc
{
	self.todayNews = nil;
	self.xmlParser = nil;
	[super dealloc];
}

@end
