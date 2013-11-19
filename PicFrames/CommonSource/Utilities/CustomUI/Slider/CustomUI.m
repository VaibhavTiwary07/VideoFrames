//
//  CustomUI.m
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 8/5/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "CustomUI.h"

@implementation CustomUI

+(UISlider*)allocateCustomSlider:(CGRect)rect
{
    UISlider *lblBackgroundOpacitySlider = [[UISlider alloc]initWithFrame:rect];
    UIImage *stretchableFillImage        = nil;
    UIImage *stretchableTrackImage       = nil;
    UIImage *img = [UIImage imageNamed:@"slider-fill"];
    
    if([img respondsToSelector:@selector(resizableImageWithCapInsets)])
    {
        stretchableFillImage = [[UIImage imageNamed:@"fill@2x"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
        stretchableTrackImage = [[UIImage imageNamed:@"track@2x"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
    }
    else
    {
        //NSLog(@"Using our method for streach filling");
        stretchableFillImage = [[UIImage imageNamed:@"fill@2x.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        stretchableTrackImage = [[UIImage imageNamed:@"track@2x.png"]stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    }
    
    [lblBackgroundOpacitySlider setMinimumTrackImage:stretchableFillImage forState:UIControlStateNormal];
    
    [lblBackgroundOpacitySlider setMaximumTrackImage:stretchableTrackImage forState:UIControlStateNormal];
    
    UIImage *initialImage = [DAAnisotropicImage imageFromAccelerometerData:nil];
    [lblBackgroundOpacitySlider setThumbImage:initialImage forState:UIControlStateNormal];
    [lblBackgroundOpacitySlider setThumbImage:initialImage forState:UIControlStateHighlighted];
    
    return lblBackgroundOpacitySlider;
}

@end
