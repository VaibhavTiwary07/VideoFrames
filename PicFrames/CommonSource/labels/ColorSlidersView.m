//
//  ColorSlidersView.m
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 8/29/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "ColorSlidersView.h"
#import "CustomUI.h"

@implementation ColorSlidersView


-(void)redSliderChanged:(UISlider*)sldr
{
    
    return;
}

-(void)greenSliderChanged:(UISlider*)sldr
{
    
    return;
}

-(void)blueSliderChanged:(UISlider*)sldr
{
    
    return;
}

-(void)alphaSliderChanged:(UISlider*)sldr
{
    
    return;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        NSLog(@"ColorSliderView: Adding Sliders");
        float headerFooterGap = 1.0;
        float yIncrement = (frame.size.height/4.0)-headerFooterGap;
        float y = headerFooterGap/2.0;
        
        // Initialization code
        UISlider *redSlider = [CustomUI allocateCustomSlider:CGRectMake(0, y, frame.size.width-20, 50)];
        [redSlider addTarget:self action:@selector(redSliderChanged:) forControlEvents:UIControlEventValueChanged];
        redSlider.minimumValue = 0.0;
        redSlider.maximumValue = 1.0;
        [self addSubview:redSlider];
        [redSlider release];
        
        y = y + yIncrement;
        UISlider *greenSlider = [CustomUI allocateCustomSlider:CGRectMake(0.0f, y, frame.size.width-20, 50)];
        [greenSlider addTarget:self action:@selector(greenSliderChanged:) forControlEvents:UIControlEventValueChanged];
        greenSlider.minimumValue = 0.0;
        greenSlider.maximumValue = 1.0;
        [self addSubview:greenSlider];
        [greenSlider release];
        
        y = y + yIncrement;
        UISlider *blueSlider = [CustomUI allocateCustomSlider:CGRectMake(0.0f, y, frame.size.width-20, 50)];
        [blueSlider addTarget:self action:@selector(blueSliderChanged:) forControlEvents:UIControlEventValueChanged];
        blueSlider.minimumValue = 0.0;
        blueSlider.maximumValue = 1.0;
        [self addSubview:blueSlider];
        [blueSlider release];
        
        y = y + yIncrement;
        UISlider *alphaSlider = [CustomUI allocateCustomSlider:CGRectMake(0.0, y, frame.size.width-20, 50)];
        [alphaSlider addTarget:self action:@selector(alphaSliderChanged:) forControlEvents:UIControlEventValueChanged];
        alphaSlider.minimumValue = 0.0;
        alphaSlider.maximumValue = 1.0;
        [self addSubview:alphaSlider];
        [alphaSlider release];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
