//
//  OT_TabBar.h
//  FlattabTestIos6
//
//  Created by Sunitha Gadigota on 8/3/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OT_TabBarItem.h"

#define OT_tabbar_default_selected_overlay_color ([UIColor blackColor])
#define OT_tabbar_default_selected_overlay_border_size (0.0)
#define OT_tabbar_default_selected_overlay_alpha (0.2)
@class OT_TabBar;

@protocol OT_TabBarDelegate <NSObject>

@required

/** @name Managing Modal Content Presentation */

/**
 * Asks the delegate for a view controller to use for presenting modal content, such as the in-app
 * browser that can appear when an ad is tapped.
 *
 * @return A view controller that should be used for presenting modal content.
 */
-(void)otTabBar:(OT_TabBar*)tbar didSelectItem:(OT_TabBarItem*)tItem;
@end

@interface OT_TabBar : UIImageView;
@property(nonatomic,strong)UILabel *itemslabel;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)NSArray *itemTitleArray;
@property(nonatomic,strong)UIImage *backgroundImage;
@property(nonatomic,strong)id<OT_TabBarDelegate>delegate;
@property(nonatomic,strong)UIImage *selectedTabOverlayImage;
@property(nonatomic,strong)UIColor *selectedTabOverlayColor;
@property(nonatomic,readwrite)BOOL showOverlayOnSelection;
-(void)unselectCurrentSelectedTab;
-(void)setSelectedItem:(int)tag;
-(OT_TabBarItem*)getTabbarItemWithTag:(int)tag;
-(BOOL)isTabbarBusy;
@end
