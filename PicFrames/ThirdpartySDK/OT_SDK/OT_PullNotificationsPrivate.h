//
//  private.h
//  pullalerts
//
//  Created by Vijay kumar reddy Doddavala on 5/24/12.
//  Copyright (c) 2012 Out Thinking Private Limited. All rights reserved.
//

#ifndef ot_pullnotifications_private_h
#define ot_pullnotifications_private_h

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


#endif
