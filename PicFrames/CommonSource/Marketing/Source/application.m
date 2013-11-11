//
//  application.m
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "application.h"

//static NSMutableDictionary *applications;
//static int iAppCount;

@implementation application

@synthesize appName;
@synthesize appstoreUrl;
@synthesize price;
@synthesize icon;
@synthesize index;
@synthesize developer;
@synthesize description;
@synthesize iconUrl;

+(void)initialize
{
#if 0    
	
	applications = [[NSMutableDictionary alloc] init];	
#endif	
	return;
}

+ (application *)applicationWithIndex:(int)iIndex 
{
#if 0    
	/* initialize the number */
	NSNumber *pIndex = [NSNumber numberWithInt:iIndex];
	
	/* get the application with index */
	return [applications objectForKey:pIndex];
#endif
    
    return nil;
}


+ (application *)newApplicationWithIndex:(int)iIndex 
{
#if 0    
	NSNumber *pIndex = [NSNumber numberWithInt:iIndex];

    // Create a new application with a given index; add it to the regions dictionary.
	application *newApp = [[application alloc] init];
	newApp.index        = iIndex;

	/* store the application information */
	[applications setObject:newApp forKey:pIndex];
	
	return newApp;
#endif 
    return nil;
}

-(void)dealloc
{
    self.icon        = nil;
    self.developer   = nil;
    self.description = nil;
    self.appstoreUrl = nil;
    self.appName     = nil;
    self.iconUrl     = nil;
    self.price       = nil;
    
    [super dealloc];
}

-(void)display
{
	
	return;
}

@end
