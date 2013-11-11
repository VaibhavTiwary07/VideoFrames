//
//  UIImageView+Shapes.m
//  ViewMasking
//
//  Created by Vijaya kumar reddy Doddavala on 11/4/12.
//  Copyright (c) 2012 Vijaya kumar reddy Doddavala. All rights reserved.
//

#import "UIImageView+Shapes.h"

@implementation UIImageView (Shapes)
typedef struct
{
    eShape type;
    BOOL  bLocked;
    char imageName[64];
}tShapeMap;

static tShapeMap shape_imagenamemaping[SHAPE_LAST] = {
    {SHAPE_NOSHAPE,NO,"circle"},
    {SHAPE_HEART,NO,"circle"},
    {SHAPE_CIRCLE,NO,"circle"},
    {SHAPE_TRIANGLE,NO,"circle"},
    {SHAPE_FLOWER,NO,"circle"},
};

-(void)setShape:(eShape)shape
{
    if((shape > SHAPE_LAST)||(shape < SHAPE_NOSHAPE))
    {
        NSLog(@"setShape:Invalid Shape");
        return;
    }
    
    UIImage *shapeImage = nil;
    if(shape == SHAPE_NOSHAPE)
    {
        self.layer.mask = nil;
        return;
    }
    
    NSString *imgName = [NSString stringWithFormat:@"%s",shape_imagenamemaping[shape].imageName];
    shapeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
    
    CGImageRef imgAlpha = shapeImage.CGImage;
    CALayer *alphaLayer = [CALayer layer];
    alphaLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    alphaLayer.position = self.center;
    alphaLayer.contents = (id)imgAlpha;
    self.layer.mask = alphaLayer;
    
    return;
}

@end
