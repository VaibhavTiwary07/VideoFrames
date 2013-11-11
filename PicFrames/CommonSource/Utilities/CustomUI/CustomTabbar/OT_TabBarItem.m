//
//  OT_TabBarItem.m
//  FlattabTestIos6
//
//  Created by Sunitha Gadigota on 8/3/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import "OT_TabBarItem.h"
#import "QuartzCore/CALayer.h"

@interface OT_TabBarItem()
{
    BOOL _isSelected;
}
@property(nonatomic,strong)UIImage *selectedImage;
@property(nonatomic,strong)UIImage *assignedImage;
@end

@implementation OT_TabBarItem
@synthesize selectedImage;
@synthesize nestedSelectionEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithImage:(UIImage*)image selectedImage:(UIImage *)selImage tag:(int)tag
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        // Initialization code
        self.selectedImage = selImage;
        self.assignedImage = image;
        self.isSelected    = NO;
        self.tag           = tag;
        self.nestedSelectionEnabled = YES;
        /* set the image */
        [self setImage:self.assignedImage forState:UIControlStateNormal];
    }
    
    return self;
}

-(BOOL)isSelected
{
    return _isSelected;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if(_isSelected == NO)
    {
        [self setImage:self.assignedImage forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:self.selectedImage forState:UIControlStateNormal];
    }
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
