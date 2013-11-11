//
//  news.m
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/10/11.
//  Copyright 2011 Out Thinking Private Limited. All rights reserved.
//

#import "OT_Ad.h"


@implementation OT_Ad

@synthesize developer;
@synthesize promotion;
@synthesize heading;
@synthesize description;
@synthesize imageUrl;
@synthesize appstoreUrl;
@synthesize appid;
@synthesize iRefCount;

-(id)init
{
    self.appid = nil;
	self.developer = nil;
	self.promotion = nil;
	self.heading = nil;
	self.description = nil;
	self.imageUrl = nil;
	self.appstoreUrl = nil;
    self.iRefCount = 0;
	
	return self;
}


@end
