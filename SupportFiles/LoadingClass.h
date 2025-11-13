//
//  LoadingClass.h
//  Vid Compressor
//
//  Created by PAVANIOS on 30/07/21.
//  Copyright © 2021 outthinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#define TAG_ACTIVITYINDICATOR 1099

@interface LoadingClass : NSObject
{
    
}
+(CGPoint)screenCenter;
+(void)removeActivityIndicatorFrom:(UIView*)view;
+(void)addActivityIndicatotTo:(UIView*)view withMessage:(NSString*)msg;
@end


