//
//  onlineapplist.m
//  photoToSketch
//
//  Created by Vijaya kumar reddy Doddavala on 1/5/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "OT_AppList.h"


static NSMutableDictionary *applications;

@implementation OT_AppList

@synthesize app;

//initialize the application list
+(void)initialize
{
	applications = [[NSMutableDictionary alloc] init];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
    //NSLog(@"Document started", nil);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
    //NSLog(@"Error: %@", [parseError localizedDescription]);
}

-(BOOL)isAppAlreadyInstalled:(OT_App*)app
{
    if((nil != self.app) && (nil != self.app.appid))
    {
        NSString *appRegUrl = [NSString stringWithFormat:@"%@://",self.app.appid];
        NSURL    *appurl  = [NSURL URLWithString:appRegUrl];
        NSString *appidVj = [NSString stringWithFormat:@"vj%@",self.app.appid];
        NSString *appRegUrlvj = [NSString stringWithFormat:@"%@://",appidVj];
        NSURL    *appurlvj  = [NSURL URLWithString:appRegUrlvj];
        if([[UIApplication sharedApplication]canOpenURL:appurl])
        {
            NSLog(@"App with Appid(%@) already installed",self.app.appid);
            return YES;
        }
        else if([[UIApplication sharedApplication]canOpenURL:appurlvj])
        {
            NSLog(@"App with Appid(%@) already installed",appidVj);
            return YES;
        }
    }
    
    return NO;
}

-(void)deleteTheLastParsedAppIfAlreadyInstalled
{
    if([self isAppAlreadyInstalled:self.app])
    {
        [OT_App deleteObjectWithIndex:self.app.index];
        if(iCurIndex > 0)
        {
            iCurIndex--;
        }
        self.app = nil;
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict
{
	eCurElement = ELEMENT_IGNORE;
	
	if([elementName isEqualToString:eApplication])
	{
		eCurElement = ELEMENT_APPLICATION;
		
        [self deleteTheLastParsedAppIfAlreadyInstalled];
        
		/* Allocate the application */
		OT_App *tmp = [OT_App newApplicationWithIndex:iCurIndex];
		self.app         = tmp;
		self.app.index   = iCurIndex;
        self.app.appid   = nil;
		
		/* increment current index */
		iCurIndex++;
	}
	else if([elementName isEqualToString:eDeveloper])
	{
		eCurElement = ELEMENT_DEVELOPER;
	}
	else if([elementName isEqualToString:eDescription])
	{
		eCurElement = ELEMENT_DESCRIPTION;
	}
	else if ([elementName isEqualToString:eName])
    {
		eCurElement = ELEMENT_NAME;
    }
	else if([elementName isEqualToString:eElementType])
	{
		eCurElement = ELEMENT_TYPE;
	}
	else if([elementName isEqualToString:eImageUrl])
	{
		eCurElement = ELEMENT_IMAGEURL;
	}
	else if([elementName isEqualToString:eAppstoreUrl])
	{
		eCurElement = ELEMENT_APPSTOREURL;
	}
    else if([elementName isEqualToString:eAppid])
    {
        NSLog(@"Found App id element!!!!!!!!!");
        eCurElement = ELEMENT_APPID;
    }
    else if([elementName isEqualToString:eVersion])
    {
        NSLog(@"Found Version element!!!!!!!!!");
        eCurElement = ELEMENT_VERSION;
    }
	
	if(eCurElement != ELEMENT_IGNORE)
	{
		//NSLog(@"%@:",elementName);
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	//NSLog(@"element <%@> ended",elementName);
	eCurElement = ELEMENT_IGNORE;
}        

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(eCurElement != ELEMENT_IGNORE)
	{
		//NSLog(@"	%@",string);
	}
	
	if (eCurElement == ELEMENT_NAME)
    {
		self.app.appName = [NSString stringWithString:string];
    }
	else if(eCurElement == ELEMENT_DEVELOPER)
	{
		self.app.developer = [NSString stringWithString:string];
	}
	else if(eCurElement == ELEMENT_DESCRIPTION)
	{
		self.app.description = [NSString stringWithString:string];
	}
	else if(eCurElement == ELEMENT_TYPE)
	{
		self.app.price = [NSString stringWithString:string];
	}
	else if(eCurElement == ELEMENT_IMAGEURL)
	{
		self.app.iconUrl = [NSString stringWithString:string];
		self.app.icon    = nil;
	}
	else if(eCurElement == ELEMENT_APPSTOREURL)
	{
		self.app.appstoreUrl = [NSString stringWithString:string];
	}
    else if(eCurElement == ELEMENT_APPID)
    {
        NSLog(@"appid is found!!!");
        self.app.appid = [NSString stringWithString:string];
    }
    else if(eCurElement == ELEMENT_VERSION)
    {
        listVersion = [NSString stringWithString:string];
        if(NO == [OT_Utils isOTApplistVersionIsSameAs:listVersion])
        {
            NSLog(@"New version of the Applist is found!!!!!!!");
            /* first delete all of the existing resources */
            [OT_Utils deleteAllIcons];
            [OT_Utils setCurrentOTApplistVersion:listVersion];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
    //NSLog(@"Document finished", nil);
}

-(BOOL)isItValidUrl:(NSURL*)url
{
    
    NSError* error = nil;
    NSHTTPURLResponse* response = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 404)
    {
        NSLog(@"File %@ doesn't exist",url);
        return NO;
    }
    else
    {
        return YES;
    }
    
}

-(BOOL)parseAppList
{
	//NSString *url = [[NSString stringWithFormat:@"http://vijay658.110mb.com/data/applist.txt"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [[NSString stringWithFormat:linktoapplist] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSData *pData = nil;
    
    /* Set the current app to nil */
    self.app = nil;
	
    NSURL*rl = [NSURL URLWithString:url];
    if([self isItValidUrl:rl] == NO)
    {
        NSLog(@"Applist file %@ doesn't exist",rl);
        return NO;
    }
    
	/* retrieve data */
	pData = [[NSData alloc] initWithContentsOfURL:rl];
	if(nil == pData)
	{
		return NO;
	}
	
	/* initialize index */
	iCurIndex = 0;

	/* allocate the parser */
	xmlParser = [[NSXMLParser alloc] initWithData:pData];
	
	/* set the delegate and configure the parser */
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
	
	[pData release];
    
    /* Make sure that We don't have already installed apps in the list */
    [self deleteTheLastParsedAppIfAlreadyInstalled];

	return YES;
}

-(BOOL)retriveAppList:(int*)pAppCount;
{
	eCurElement = ELEMENT_IGNORE;

	/* parse application list */
	if(NO == [self parseAppList])
	{
		return NO;
	}
	
	/* fill the app count */
	if(nil != pAppCount)
	{
		*pAppCount = iCurIndex;
	}
	
	return YES;
}

@end
