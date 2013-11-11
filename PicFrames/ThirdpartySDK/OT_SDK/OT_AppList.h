//
//  onlineapplist.h
//  photoToSketch
//
//  Created by Vijaya kumar reddy Doddavala on 1/5/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OT_App.h"
#import "OT_Utils.h"

@interface OT_AppList : NSObject <NSXMLParserDelegate>
{
	NSXMLParser *xmlParser;
	ELEMENT_E eCurElement;
	OT_App *app;
    NSString *listVersion;
	int iCurIndex;
}

@property(nonatomic,retain)OT_App *app;

-(BOOL)retriveAppList:(int*)pAppCount;

@end
