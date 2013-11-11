//
//  application.h
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OT_OfferWall.h"


@interface OT_App : NSObject {
	NSString *developer;
	NSString *description;
	NSString *appName;
	NSString *appstoreUrl;
	NSString *price;
	NSString *iconUrl;
	UIImage  *icon;
    NSString *appid;
	
	int index;
}

@property(nonatomic,retain)NSString *iconUrl;
@property(nonatomic,retain)NSString *developer;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *appName;
@property(nonatomic,retain)NSString *appstoreUrl;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)UIImage  *icon;
@property(nonatomic,retain)NSString *appid;
@property(nonatomic,readwrite)int  index;

-(void)display;
+ (OT_App *)applicationWithIndex:(int)iIndex;
+ (OT_App *)newApplicationWithIndex:(int)iIndex;
+(void)deleteObjectWithIndex:(int)iIndex;
@end
