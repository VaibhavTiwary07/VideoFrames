//
//  news.h
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/10/11.
//  Copyright 2011 Out Thinking Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OT_Ad : NSObject 
{
	NSString *developer;
	NSString *promotion;
	NSString *heading;
	NSString *description;
	NSString *imageUrl;
	NSString *appstoreUrl;
    NSString *appid;
    int       iRefCount;
}


@property(nonatomic,retain)NSString *developer;
@property(nonatomic,retain)NSString *promotion;
@property(nonatomic,retain)NSString *heading;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *imageUrl;
@property(nonatomic,retain)NSString *appstoreUrl;
@property(nonatomic,retain)NSString *appid;
@property(nonatomic,readwrite)int iRefCount;

@end
