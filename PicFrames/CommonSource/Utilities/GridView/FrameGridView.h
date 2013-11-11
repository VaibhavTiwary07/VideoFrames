//
//  FrameGridView.h
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 3/18/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameButton.h"

//#define FGV_PAGECONTROL_HEIGHT 50
//#define FGV_ITEM_WIDTH (70 * DEV_MULTIPLIER)
//#define FGV_ITEM_HEIGHT (70 * DEV_MULTIPLIER)
#define DEVICE_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define FGV_PAGECONTROL_HEIGHT ((DEVICE_HEIGHT == 480.0)?40:50)
#define FGV_ITEM_WIDTH ((DEVICE_HEIGHT == 480.0)?(60 * DEV_MULTIPLIER):(70 * DEV_MULTIPLIER))
#define FGV_ITEM_HEIGHT ((DEVICE_HEIGHT == 480.0)?(60 * DEV_MULTIPLIER):(70 * DEV_MULTIPLIER))

@protocol FrameGridViewDelegate;

@interface FrameGridView : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrlView;
    UIPageControl *pgControl;
    id<FrameGridViewDelegate>	delegate;
}

@property(nonatomic,readwrite)int totalItemsCount;
@property(nonatomic,retain)NSString *filePrefix;
@property(nonatomic,assign)id<FrameGridViewDelegate>	delegate;
@property(nonatomic,readwrite)int selectedItemIndex;

-(void)setRowCount:(int)rows colCount:(int)cols;
- (id)initWithFrame:(CGRect)frame indextag:(int)tag;
@end

@protocol FrameGridViewDelegate <NSObject>
- (void)frameSelectedAtIndex:(int)index ofGridView:(FrameGridView*)gView;
@optional
- (BOOL)gridView:(FrameGridView*)gView contentLockedAtIndex:(int)index;
- (void)gridView:(FrameGridView*)gView selectedFrameButton:(UIButton*)btn;
@end