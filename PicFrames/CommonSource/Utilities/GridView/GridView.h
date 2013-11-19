//
//  GridView.h
//  GridView
//
//  Created by Vijaya kumar reddy Doddavala on 3/15/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

#define PAGECONTROL_HEIGHT 38
//#define ITEM_WIDTH (38 * DEV_MULTIPLIER)
//#define ITEM_HEIGHT (38 * DEV_MULTIPLIER)
#define ITEM_WIDTH (38)
#define ITEM_HEIGHT (38)

@protocol GridViewDelegate;

@interface GridView : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrlView;
    UIPageControl *pgControl;
    id<GridViewDelegate>	delegate;
}

@property(nonatomic,readwrite)int totalItemsCount;
@property(nonatomic,retain)NSString *filePrefix;
@property(nonatomic,assign)id<GridViewDelegate>	delegate;

-(void)setRowCount:(int)rows colCount:(int)cols;
- (id)initWithFrame:(CGRect)frame option:(int)colorOrPattern;
+(UIColor *)getColorAtIndex:(int)index;
+(UIColor *)getPatternAtIndex:(int)index;
@end

@protocol GridViewDelegate 
- (void)itemSelectedAtIndex:(int)index ofGridView:(GridView*)gView;
-(void)colorItemSelected:(UIColor *)selectedColor;

@end
