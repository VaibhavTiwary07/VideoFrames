//
//  onlineDailyNews.h
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/10/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "news.h"
#import "config.h"

#define eCurAppName appname
//#define eCurAppName @"color splash photo"
#define eAllApps    @"all apps"

#define eNews @"news"
#define eAppName @"appname"
#define eDeveloper @"developer"
#define eDescription @"description"
#define eHeading @"heading"
#define ePromotion @"promotion"
#define eImageUrl @"imageurl"
#define eAppstoreUrl @"appstorelink"
#ifndef CROSSPRAMOTION_VER1    
#define eAppId       @"appid"
#endif

#define genericituneslinktoApp @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8"

typedef enum
{
	NEWS_ELEMENT_IGNORE,
	NEWS_ELEMENT_APPNAME,
	NEWS_ELEMENT_NEWS,
	NEWS_ELEMENT_DEVELOPER,
	NEWS_ELEMENT_HEADING,
	NEWS_ELEMENT_DESCRIPTION,
	NEWS_ELEMENT_PROMOTION,
	NEWS_ELEMENT_IMAGEURL,
	NEWS_ELEMENT_APPSTOREURL,
#ifndef CROSSPRAMOTION_VER1    
    NEWS_ELEMENT_APPID
#endif    
}NEWS_ELEMENT_E;

@class onlineDailyNews;

@protocol onlineDailyNewsDelegate 
- (void)doneWithDailyNewsAd;
@end

@interface onlineDailyNews : NSObject <NSXMLParserDelegate>
{
	NSXMLParser    *xmlParser;
	NEWS_ELEMENT_E  eCurElement;
	news           *todayNews;
	BOOL            bIgnoreCurNode;
	
	id <onlineDailyNewsDelegate>  _newsDelegate;
    int iAviableAds;
}

@property(nonatomic,retain)news *todayNews;
@property(nonatomic,retain)NSXMLParser *xmlParser;
@property(nonatomic,retain)id <onlineDailyNewsDelegate> _newsDelegate;

-(BOOL)retriveDailyNews;
-(BOOL)retrieveAndDislayTodaysAdd;
@end
