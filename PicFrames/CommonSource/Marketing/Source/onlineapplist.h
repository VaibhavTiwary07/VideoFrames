//
//  onlineapplist.h
//  photoToSketch
//
//  Created by Vijaya kumar reddy Doddavala on 1/5/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "application.h"

#define eDeveloper @"developer"
#define eDescription @"description"
#define eApplication @"application"
#define eName @"name"
#define eElementType @"type"
#define eImageUrl @"imageurl"
#define eAppstoreUrl @"appstorelink"

typedef enum
{
	ELEMENT_APPLICATION,
	ELEMENT_DEVELOPER,
	ELEMENT_DESCRIPTION,
	ELEMENT_NAME,
	ELEMENT_TYPE,
	ELEMENT_IMAGEURL,
	ELEMENT_APPSTOREURL,
	ELEMENT_IGNORE
}ELEMENT_E;

@interface onlineapplist : NSObject <NSXMLParserDelegate>
{
	NSXMLParser *xmlParser;
	ELEMENT_E eCurElement;
	application *app;
	int iCurIndex;
    NSMutableDictionary *applications;
}

@property(assign)application *app;

-(void)initApplist;
-(BOOL)retriveAppList:(int*)pAppCount;
-(NSMutableDictionary*)getApplist;

@end
