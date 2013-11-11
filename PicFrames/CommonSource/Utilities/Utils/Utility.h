//
//  Utility.h
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 9/20/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Resize.h"
#import "MBProgressHUD.h"
#import "Frame.h"

#define TAG_ACTIVITYINDICATOR 1099
@interface Utility : NSObject{
    
}

+(CGPoint)screenCenter;
+(void)removeActivityIndicatorFrom:(UIView*)view;
+(void)updateActivityMessageInView:(UIView*)v to:(NSString*)msg;
+(void)addActivityIndicatotTo:(UIView*)view withMessage:(NSString*)msg;
+(UIImage*)createPatternImageOfSize:(CGRect)rect withImage:(UIImage*)ptrn;
+(NSString*)frameThumbNailPathForFrameNumber:(int)framenum;
+(void)generateThumnailsForFrames;
+(NSString*)coloredFrameThumbNailPathForFrameNumber:(int)framenum;
+(UIImage *)optimizedImage:(UIImage *)image;
+(UIImage *)optimizedImage:(UIImage *)image withMaxResolution:(int)maxRes;
+(NSString*)documentDirectoryPathForFile:(NSString*)fileName;
+(NSString*)helpImagePathForNumber:(int)framenum;
+(void)generateImagesForHelp;
@end
