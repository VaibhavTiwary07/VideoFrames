//
//  customtab.m
//  customtabbar
//
//  Created by Vijaya kumar reddy Doddavala on 8/16/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "UITabBar+CustomBackground.h"

@implementation UITabBar (CustomBackground)

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [super drawRect:rect];
        
        return;
    }
    
    if([self respondsToSelector:@selector(setBackgroundImage:)])
    {
#if 0        
        if(self.items.count == 5)
        {
            self.backgroundImage = [UIImage imageNamed:@"tabbar5.png"];
            self.selectionIndicatorImage = [UIImage imageNamed:@"tabButtonDown.png"];
        }
        else
        {
            self.backgroundImage = [UIImage imageNamed:@"tabbar4.png"];
            self.selectionIndicatorImage = [UIImage imageNamed:@"tabButtonDown.png"];
        }
#endif        
        [super drawRect:rect];
    }
    else 
    {
        CGContextRef ref = UIGraphicsGetCurrentContext();
        if(self.items.count == 5)
        {
            CGContextDrawImage(ref, [self bounds], [UIImage imageNamed:@"tabbar5.png"].CGImage);
        }
        else
        {
            CGContextDrawImage(ref, [self bounds], [UIImage imageNamed:@"tabbar4.png"].CGImage);
        }
        int tag = self.selectedItem.tag;
        //NSLog(@"selected item tag %d",tag);
        float x = (320.0f/(self.items.count))*tag;
        CGRect rect = CGRectMake(x, self.bounds.origin.y, (320.0f/self.items.count), self.bounds.size.height);
        
        if(self.items.count == 5)
        {
            NSLog(@"Tab selection 5");
            CGContextDrawImage(ref, rect, [UIImage imageNamed:@"tabselection5.png"].CGImage);
        }
        else
        {
            NSLog(@"Tab selection 4");
            CGContextDrawImage(ref, rect, [UIImage imageNamed:@"tabselection4.png"].CGImage);
        }
        
        
    }
    
    return;
}


@end
