//
//  application.h
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface application : NSObject {
	NSString *developer;
	NSString *description;
	NSString *appName;
	NSString *appstoreUrl;
	NSString *price;
	NSString *iconUrl;
	UIImage  *icon;
	
	int index;
}

@property(nonatomic,retain)NSString *iconUrl;
@property(nonatomic,retain)NSString *developer;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *appName;
@property(nonatomic,retain)NSString *appstoreUrl;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)UIImage  *icon;
@property(nonatomic,readwrite)int  index;

-(void)display;
+ (application *)applicationWithIndex:(int)iIndex;
+ (application *)newApplicationWithIndex:(int)iIndex;
@end
