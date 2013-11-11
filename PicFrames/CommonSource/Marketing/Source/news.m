//
//  news.m
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/10/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "news.h"


@implementation news

@synthesize developer;
@synthesize promotion;
@synthesize heading;
@synthesize description;
@synthesize imageUrl;
@synthesize appstoreUrl;
@synthesize appid;

-(id)init
{
    self.appid = nil;
	self.developer = nil;
	self.promotion = nil;
	self.heading = nil;
	self.description = nil;
	self.imageUrl = nil;
	self.appstoreUrl = nil;
	
	return self;
}


@end
