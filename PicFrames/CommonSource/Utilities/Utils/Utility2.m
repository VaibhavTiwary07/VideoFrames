//
//  Utility.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 9/20/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "Utility.h"
#import "MBProgressHUD.h"

@interface touchView:UIView
{
    
}
@end

@implementation touchView

@end


@implementation Utility

#if 0
+(void)removeActivityIndicatorFrom:(UIView*)view
{
    /* Now destroy the activity indicator */
    UIImageView *activityBgnd =  (UIImageView*)[view viewWithTag:TAG_ACTIVITYINDICATOR_BGND];
    if(nil != activityBgnd)
    {
        [activityBgnd removeFromSuperview];
    }
    
    UIActivityIndicatorView *activity =  (UIActivityIndicatorView*)[view viewWithTag:TAG_ACTIVITYINDICATOR];
    if(nil != activity)
    {
        [activity stopAnimating];
        [activity removeFromSuperview];  
    }
    
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
    [Utility removeActivityIndicatorFrom:view];
    
    UIImageView *pActivityBgnd = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"board" ofType:@"png"]];
    pActivityBgnd.image = [img thumbnailImage:60 transparentBorder:2 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];
    //pActivityBgnd.backgroundColor = [UIColor blackColor];
    pActivityBgnd.alpha = 0.8;
    pActivityBgnd.center = [Utility screenCenter];
    pActivityBgnd.tag    = TAG_ACTIVITYINDICATOR_BGND;
    [view addSubview:pActivityBgnd];
    [pActivityBgnd release];
    
    /* Now Start the activity indicator */
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = [Utility screenCenter];
    activity.tag    = TAG_ACTIVITYINDICATOR;
    [activity startAnimating];
    
    [view addSubview:activity];
    [activity release];
}
#else
+(void)removeActivityIndicatorFrom:(UIView*)view
{
    MBProgressHUD *activity = (MBProgressHUD*)[view viewWithTag:TAG_ACTIVITYINDICATOR];
    if(nil != activity)
    {
        [activity removeFromSuperview];
        [activity release];
        activity = nil;
    }
        
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
    [Utility removeActivityIndicatorFrom:view];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
	
    //HUD.delegate = self;
    HUD.labelText = msg;
    HUD.tag       = TAG_ACTIVITYINDICATOR;
    
    [HUD show:NO];
    
}

+(void)updateActivityMessageInView:(UIView*)v to:(NSString*)msg
{
    MBProgressHUD *activity = (MBProgressHUD*)[v viewWithTag:TAG_ACTIVITYINDICATOR];
    if(nil != activity)
    {
        activity.labelText = msg;
    }
    
    return;
}
#endif

@end
