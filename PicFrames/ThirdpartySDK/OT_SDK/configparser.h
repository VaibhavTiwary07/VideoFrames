//
//  configparser.h
//  PhotoToSketch
//
//  Created by Vijaya kumar reddy Doddavala on 12/27/12.
//  Copyright (c) 2012 Vijaya kumar reddy Doddavala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"

typedef enum
{
	CONFIG_ELEMENT_SUCCESS,
	CONFIG_ELEMENT_FULLSCREENAD,
    CONFIG_ELEMENT_BANNERAD,
    CONFIG_ELEMENT_ADVERTISEMENTS,
    CONFIG_ELEMENT_LINKTOIMAGE,
    CONFIG_ELEMENT_LINKTOOPEN,
    CONFIG_ELEMENT_LAST
}CONFIG_ELEMENT_E;

typedef enum
{
    CONFIG_FULLSCREENAD_CHARTBOOST,
    CONFIG_FULLSCREENAD_REVMOB,
    CONFIG_FULLSCREENAD_TAPJOY,
    CONFIG_FULLSCREENAD_PLAYHAVEN,
    CONFIG_FULLSCREENAD_LAST
}CONFIG_FULLSCREENAD_E;

typedef enum
{
    CONFIG_BANNERAD_MOBCLIX,
    CONFIG_BANNERAD_MOPUB,
    CONFIG_BANNERAD_TAPJOY,
    CONFIG_BANNERAD_LAST
}CONFIG_BANNERAD_E;

typedef enum
{
    CONFIG_ADVERTISEMENTS_ENABLE,
    CONFIG_ADVERTISEMENTS_DISABLE,
    CONFIG_ADVERTISEMENTS_LAST
}CONFIG_ADVERTISEMENTS_E;

#define notification_syncedwithconfigserver @"notification_syncedwithconfigserver"
#define tag_adview 7389
#define adviewsize  40
#define adviewdistancefromwall 10

@interface configparser : NSObject <NSXMLParserDelegate>

@property(nonatomic,readwrite)CONFIG_FULLSCREENAD_E fullscreenAd;
@property(nonatomic,readwrite)CONFIG_BANNERAD_E bannerAd;
@property(nonatomic,readwrite)CONFIG_ADVERTISEMENTS_E advertisements;
@property(nonatomic,retain)UIImage *imageForAd;
@property(nonatomic,retain)NSURL *urlToOpenOnClickingAd;

-(id)initWithData:(NSData*)data;
-(void)parseData;
-(id)initWithAppId:(NSString*)appid;
+(configparser*)Instance;
-(void)bringAdToTheTop;
-(void)showAdInView:(UIView*)v atPoint:(CGPoint)point;
-(void)showAdInView:(UIView*)v;
-(void)startSessionWithId:(NSString*)appid;
-(void)removeAd;
@end
