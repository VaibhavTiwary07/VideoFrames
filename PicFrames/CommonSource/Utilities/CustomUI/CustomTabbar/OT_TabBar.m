//
//  OT_TabBar.m
//  FlattabTestIos6
//
//  Created by Sunitha Gadigota on 8/3/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import "OT_TabBar.h"
#import "QuartzCore/CALayer.h"

#define TAG_OT_TABBAR_ITEM 658

@interface OT_TabBar()
{
    float buttonWidth;
    float buttonHeight;
    OT_TabBarItem *curSelectedItem;
    BOOL isItemClickInProgress;
    int tabItemCount;
}
@end

@implementation OT_TabBar
@synthesize delegate;
@synthesize selectedTabOverlayImage;
@synthesize selectedTabOverlayColor;
@synthesize showOverlayOnSelection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.userInteractionEnabled = YES;
        curSelectedItem = nil;
        isItemClickInProgress = NO;
        self.showOverlayOnSelection = YES;
        self.selectedTabOverlayImage = nil;
        self.selectedTabOverlayColor = OT_tabbar_default_selected_overlay_color;
        tabItemCount = 0;
    }
    return self;
}

-(UIImage *)backgroundImage
{
    return self.image;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.image = backgroundImage;
    
    return;
}

-(void)setItems:(NSArray *)items
{
    int index = 0;
    float x = 0.0;
    float y = 0.0;
    
    if(nil)
    {
        return;
    }
    
    /* remove existing tab bar items */
    for(index = 0; index < [self.subviews count];index++)
    {
        if(nil != [self.subviews objectAtIndex:index])
        {
            [[self.subviews objectAtIndex:index]removeFromSuperview];
        }
    }
    
    /* calculate width and height of each button */
    buttonWidth  = self.frame.size.width/[items count];
    buttonHeight = self.frame.size.height;
    

    for(index = 0; index < [items count];index++)
    {
        OT_TabBarItem *btn = (OT_TabBarItem*)[items objectAtIndex:index];
        if(btn == nil)
        {
            continue;
        }
        
        //btn.tag = TAG_OT_TABBAR_ITEM + index;
        
        //NSLog(@"Adding button at %f,%f,%f,%f",x,y,buttonWidth,buttonHeight);
        /* Position the bar button */
        btn.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        
        /* Register method to get the button clicks */
        [btn addTarget:self action:@selector(tabBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        /* add it to tabbar */
        [self addSubview:btn];
        
        /* Increment x for next button */
        x = x + buttonWidth;
    }
    
    tabItemCount = [items count];
    
    return;
}

-(void)continueHandlingTabBarItemClick:(id)sender
{
    /* Now call the delegate method to notify about selection */
    [self.delegate otTabBar:self didSelectItem:curSelectedItem];
    
    isItemClickInProgress = NO;
}

-(UIImage*)getOverLayImage
{
    int border = OT_tabbar_default_selected_overlay_border_size;
    
    if(nil != self.selectedTabOverlayImage)
    {
        return self.selectedTabOverlayImage;
    }
    
    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(border, border, self.frame.size.width-(2*border), self.frame.size.height-(2*border))];
    [borderView addSubview:contentView];
    borderView.backgroundColor = [UIColor clearColor];
    contentView.backgroundColor = self.selectedTabOverlayColor;
    contentView.alpha = OT_tabbar_default_selected_overlay_alpha;
    
    UIGraphicsBeginImageContext(borderView.bounds.size);
    [borderView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *overLayImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return overLayImage;
}

-(void)unselectCurrentSelectedTab
{
    
    id item = nil;
    int index = 0;
    
    for(index = 0; index < [self.subviews count]; index++)
    {
        item = [self.subviews objectAtIndex:index];
        
        if((item != nil)&&([item isKindOfClass:[OT_TabBarItem class]]))
        {
            
            OT_TabBarItem *bItem = item;
            [bItem setBackgroundImage:nil forState:UIControlStateNormal];
            bItem.isSelected = NO;
            curSelectedItem = nil;
        }
    }
}

-(OT_TabBarItem*)getTabbarItemWithTag:(int)tag
{
    OT_TabBarItem *item = nil;
    
    for(int index = 0; index < self.subviews.count; index++)
    {
        item = [self.subviews objectAtIndex:index];
        if(item.tag == tag)
        {
            break;
        }
    }
    
    //item = (OT_TabBarItem*)[self viewWithTag:tag];
    
    return item;
}

-(void)setSelectedItem:(int)tag
{
    OT_TabBarItem *item = nil;
    
    for(int index = 0; index < self.subviews.count; index++)
    {
        item = [self.subviews objectAtIndex:index];
        if(item.tag == tag)
        {
            break;
        }
    }
    
    //item = (OT_TabBarItem*)[self viewWithTag:tag];
    
    if(nil == item)
    {
        NSLog(@"setSelectedItem: Coulnd't find any tabbar item with tag %d",tag);
        return;
    }
    
    [self tabBarItemClicked:item];
}

-(BOOL)isTabbarBusy
{
    return isItemClickInProgress;
}

-(void)tabBarItemClicked:(OT_TabBarItem*)clickedItem
{
    if(isItemClickInProgress == YES)
    {
        NSLog(@"Tabbar busy, so Not handling current click");
        return;
    }
    
    isItemClickInProgress = YES;
    
    if(curSelectedItem != clickedItem)
    {
        if(nil != curSelectedItem)
        {
            NSLog(@"tabBarItemClicked:setting %@(curSelectedItem) selected to NO",curSelectedItem);
            /* Set the selected state to No */
            curSelectedItem.isSelected = NO;
        
            /* reset the background image */
            [curSelectedItem setBackgroundImage:nil forState:UIControlStateNormal];
        }
        
        /* Make clickedItem as current selected item */
        clickedItem.isSelected = YES;
        
        curSelectedItem = clickedItem;
        
        if(showOverlayOnSelection)
        {
            /* upgrade the background */
            [curSelectedItem setBackgroundImage:[self getOverLayImage] forState:UIControlStateNormal];
        }
    }
    
    /* make sure that UI is updated before we call delegate method. */
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(continueHandlingTabBarItemClick:) userInfo:nil repeats:NO];
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
