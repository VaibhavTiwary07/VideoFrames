//
//  OT_OfferWall.h
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 7/25/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#ifndef Instacolor_Splash_OT_OfferWall_h
#define Instacolor_Splash_OT_OfferWall_h

#define eDeveloper @"developer"
#define eDescription @"description"
#define eApplication @"application"
#define eName @"name"
#define eElementType @"type"
#define eImageUrl @"imageurl"
#define eAppstoreUrl @"appstorelink"
#define eAppid @"appid"
#define eVersion @"version"

#define linktoapplist @"http://photoandvideoapps.com/Offers/vjapplist5.xml"
#define genericituneslinktoApp @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8"
#define urlforicon @"http://photoandvideoapps.com/Offers/Icons/"


typedef enum
{
	ELEMENT_APPLICATION,
	ELEMENT_DEVELOPER,
	ELEMENT_DESCRIPTION,
	ELEMENT_NAME,
	ELEMENT_TYPE,
	ELEMENT_IMAGEURL,
	ELEMENT_APPSTOREURL,
    ELEMENT_APPID,
    ELEMENT_VERSION,
	ELEMENT_IGNORE
}ELEMENT_E;

#endif
