//
//  UIImageView+Shapes.h
//  ViewMasking
//
//  Created by Vijaya kumar reddy Doddavala on 11/4/12.
//  Copyright (c) 2012 Vijaya kumar reddy Doddavala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"

typedef enum
{
    SHAPE_NOSHAPE,
    SHAPE_HEART,
    SHAPE_CIRCLE,
    SHAPE_TRIANGLE,
    SHAPE_FLOWER,
    SHAPE_LAST
}eShape;

@interface UIImageView (Shapes)

-(void)setShape:(eShape)shape;
@end
