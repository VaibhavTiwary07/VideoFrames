//
//  onlineapplist.m
//  photoToSketch
//
//  Created by Vijaya kumar reddy Doddavala on 1/5/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "onlineapplist.h"


//static NSMutableDictionary *applications;

@implementation onlineapplist

@synthesize app;

#if 0
//initialize the application list
+(void)initialize
{
    NSLog(@"onlineapplist:initialize");
	applications = [[NSMutableDictionary alloc] init];
}
#else
-(void)initApplist
{
    applications = [[NSMutableDictionary alloc] init];
}
#endif
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
	eCurElement = ELEMENT_IGNORE;
	
	if([elementName isEqualToString:eApplication])
	{
		eCurElement = ELEMENT_APPLICATION;
		
		/* Allocate the application */
        application *tmp = [application alloc];
		self.app         = tmp;
		self.app.index   = iCurIndex;
        self.app.icon    = nil;
        
        /* add it to the dictionary */
        [applications setObject:tmp forKey:[NSNumber numberWithInt:iCurIndex]];
        
        [tmp release];
		
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
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
    //NSLog(@"Document finished", nil);
}


-(BOOL)parseAppList
{
	NSString *url = [[NSString stringWithFormat:@"http://vijay658.110mb.com/data/applist.txt"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSData *pData = nil;
	
	/* retrieve data */
	pData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	if(nil == pData)
	{
		return NO;
	}
	

#if 0	
	//NSString *url = [[NSString stringWithFormat:@"http://feeds.feedburner.com/TheAppleBlog"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
	
	/* Display the downloaded xml file */
	//NSLog(@"%@",myTxtFile);
#endif
	
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

-(NSMutableDictionary*)getApplist
{
    return applications;
}

-(void)dealloc
{
    //NSLog(@"onlineapplist: dealloc");
    [applications release];
    applications = nil;
    [super dealloc];
}
@end
