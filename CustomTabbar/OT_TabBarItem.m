//
//  OT_TabBarItem.m
//  FlattabTestIos6
//
//  Created by Sunitha Gadigota on 8/3/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import "OT_TabBarItem.h"
#import "QuartzCore/CALayer.h"
#import "OT_TabBar.h"

@interface OT_TabBarItem()<OT_TabBarDelegate>
{
    BOOL _isSelected;
    OT_TabBar *_customTabBar;
}
@property(nonatomic,strong)UIImage *selectedImage;
@property(nonatomic,strong)UIImage *assignedImage;
@property(nonatomic,strong)UILabel *assigntext;
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

-(id)initWithImage:(UIImage*)image  selectedImage:(UIImage *)selImage tag:(int)tag;{
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
        self.tintColor = [UIColor whiteColor];
    }
    
    return self;
}

-(BOOL)isSelected
{
    return _isSelected;
}

-(void)setIsSelected:(BOOL)isSelected
{
    float x = 0.0;
    float y = 0.0;
    float    buttonWidth  = self.frame.size.width;
    float  buttonHeight = self.frame.size.height;
    _assigntext = [[UILabel alloc] initWithFrame:CGRectMake(x, y+buttonHeight-20, buttonWidth, 20)];
    _assigntext = [[UILabel alloc] initWithFrame:CGRectMake(x, y+buttonHeight-20, buttonWidth, 20)];
   
    _assigntext.textColor=[UIColor colorWithRed:25/255 green:184/255 blue:250/255 alpha:1.0];
    _assigntext.textAlignment=NSTextAlignmentCenter;
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        _assigntext.font = [UIFont systemFontOfSize:10.0f];
    }
    else
        
    {
        _assigntext.font = [UIFont systemFontOfSize:8.0f];
   
  
    }
   
    [self addSubview:_assigntext];
    _isSelected = isSelected;
    
    if(_isSelected == NO)
    {
      
        [self setImage:self.assignedImage forState:UIControlStateNormal];
        self.tintColor = [UIColor whiteColor];
       // _customTabBar.itemslabel.textColor = [UIColor whiteColor];
       // NSLog(@"Normal image----");

    }
    else
    {
       
        [self setImage:self.selectedImage forState:UIControlStateNormal];
        self.tintColor = [UIColor whiteColor];
        _customTabBar.delegate = self;
        _customTabBar.itemslabel.textColor = _assigntext.textColor;
        NSLog(@"selected image----");
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
//- (void)dealloc
//{
//    [_assignedImage release];
//    [selectedImage release];
//    [super dealloc];
//    
//}
@end
