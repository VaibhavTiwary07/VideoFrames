//
//  LoadingClass.m
//  Vid Compressor
//
//  Created by PAVANIOS on 30/07/21.
//  Copyright © 2021 outthinking. All rights reserved.
//

#import "LoadingClass.h"

@implementation LoadingClass
/*
+(void)removeActivityIndicatorFrom:(UIView*)view
{
    MBProgressHUD *activity = (MBProgressHUD*)[view viewWithTag:TAG_ACTIVITYINDICATOR];
    if(nil != activity)
    {
        [activity removeFromSuperview];
       
        activity = nil;
    }
    
    return;
}
+(void)addActivityIndicatotTo:(UIView*)view withMessage:(NSString*)msg;
{
    [LoadingClass removeActivityIndicatorFrom:view];
#if 1
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    //HUD.delegate = self;
    HUD.labelText = msg;
   // HUD.label.text =msg;
    HUD.tag       = TAG_ACTIVITYINDICATOR;
   // [HUD showAnimated:NO];
     [HUD show:NO];  //new commented
#endif
}

+(void)updateActivityMessageInView:(UIView*)v to:(NSString*)msg
{
    MBProgressHUD *activity = (MBProgressHUD*)[v viewWithTag:TAG_ACTIVITYINDICATOR];
    if(nil != activity)
    {
       // activity.labelText = msg;
    }
    
    return;
}
*/
+(void)removeActivityIndicatorFrom:(UIView*)view
{
    NSLog(@"It is removing Activity Indicator..");
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    MBProgressHUD *activity = (MBProgressHUD*)[view viewWithTag:TAG_ACTIVITYINDICATOR];
    if(nil != activity)
        {
        [activity removeFromSuperview];
       
        activity = nil;
        }
    
    return;
    
    return;
}

+(CGPoint)screenCenter
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    
    return center;
}

+(void)addActivityIndicatotTo:(UIView*)view withMessage:(NSString*)msg;
{
    [self removeActivityIndicatorFrom:view];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    [view bringSubviewToFront:HUD];
    
        //HUD.delegate = self;
    
  //  HUD.label.text = msg;
    HUD.labelText = msg;
    HUD.tag       = TAG_ACTIVITYINDICATOR;
    [HUD show:NO];
  //  [HUD showAnimated:NO];
   // [HUD show:NO];
}

@end
