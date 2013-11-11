//
//  Utility.h
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 9/20/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"

#define TAG_ACTIVITYINDICATOR 5658

@interface Utility : NSObject {
    
}

+(CGPoint)screenCenter;
+(void)removeActivityIndicatorFrom:(UIView*)view;
+(void)addActivityIndicatotTo:(UIView*)view withMessage:(NSString*)msg;
+(void)updateActivityMessageInView:(UIView*)v to:(NSString*)msg;
@end
