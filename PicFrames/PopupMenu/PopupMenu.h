//
//  PopupMenu.h
//  ViewMasking
//
//  Created by Vijaya kumar reddy Doddavala on 11/4/12.
//  Copyright (c) 2012 Vijaya kumar reddy Doddavala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"
#import "PopoverView.h"
#import "SNPopupView.h"

@class PopupMenu;

@protocol PopupMenuDelegate <NSObject>
- (int)numberOfItemsInPopupMenu:(PopupMenu*)sender;
- (NSString*)popupMenu:(PopupMenu*)sender titleForItemAtIndex:(int)index;
- (UIImage*)popupMenu:(PopupMenu*)sender imageForItemAtIndex:(int)index;
- (BOOL)popupMenu:(PopupMenu*)sender enableStatusForItemAtIndex:(int)index;
- (void)popupMenu:(PopupMenu*)sender itemDidSelectAtIndex:(int)index;
- (void)popupMenuDidDismiss:(PopupMenu*)sender;
@optional
- (BOOL)popupMenu:(PopupMenu *)sender isNewBadgeRequiredForItemAtIndex:(int)index;
@end

//#define POPUPMENU_CELL_HEIGHT 25.0
#define POPUPMENU_CELL_HEIGHT 35.0
#define POPUPMENU_CELL_WIDTH  195.0
//#define POPUPMENU_CELL_WIDTH  240.0
#define POPUPMENU_FONT ([UIFont boldSystemFontOfSize:13.0])

@interface PopupMenu : UITableView <UITableViewDataSource,UITableViewDelegate,PopoverViewDelegate>

//@property(nonatomic,retain)UIButton *_touchButton;
@property(nonatomic,retain)id <PopupMenuDelegate> menudelegate;
-(void)showSNPopupIn:(UIView*)v at:(CGPoint)point;
-(void)dismissSNPopup;
-(void)showPopupIn:(UIView*)v at:(CGPoint)point;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id)del;
@end
