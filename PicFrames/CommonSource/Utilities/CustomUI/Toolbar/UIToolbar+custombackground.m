//
//  UIToolbar+custombackground.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 9/3/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "UIToolbar+custombackground.h"

@implementation UIToolbar (custombackground)

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(nil != self)
    {
        if([self respondsToSelector:@selector(setBackgroundImage:)])
        {
            [self setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        }
    }
    
    return self;
}
@end
