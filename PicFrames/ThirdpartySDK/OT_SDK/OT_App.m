//
//  application.m
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "OT_App.h"

static NSMutableDictionary *applications;

@implementation OT_App

@synthesize appName;
@synthesize appstoreUrl;
@synthesize price;
@synthesize icon;
@synthesize index;
@synthesize developer;
@synthesize description;
@synthesize iconUrl;
@synthesize appid;

+(void)initialize
{
	//NSLog(@"application initialize");
	
	applications = [[NSMutableDictionary alloc] init];	
	
	return;
}

+ (OT_App *)applicationWithIndex:(int)iIndex 
{
	/* initialize the number */
	NSNumber *pIndex = [NSNumber numberWithInt:iIndex];
	
	/* get the application with index */
	return [applications objectForKey:pIndex];
}


+ (OT_App *)newApplicationWithIndex:(int)iIndex 
{
	NSNumber *pIndex = [NSNumber numberWithInt:iIndex];

    // Create a new application with a given index; add it to the regions dictionary.
	OT_App *newApp = [[OT_App alloc] init];
	newApp.index        = iIndex;

	/* store the application information */
	[applications setObject:newApp forKey:pIndex];
	
	return newApp;
}

+(void)deleteObjectWithIndex:(int)iIndex
{
    NSNumber *pIndex = [NSNumber numberWithInt:iIndex];

    [applications removeObjectForKey:pIndex];
    
    return;
}


-(void)display
{	
	return;
}

@end
