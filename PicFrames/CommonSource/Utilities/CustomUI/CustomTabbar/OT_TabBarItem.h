//
//  OT_TabBarItem.h
//  FlattabTestIos6
//
//  Created by Sunitha Gadigota on 8/3/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OT_notification_tabbaritem_selected @"OT_notification_tabbaritem_selected"
#define OT_key_tabbaritem_selected_tag      @"OT_key_tabbaritem_selected_tag"

@interface OT_TabBarItem : UIButton

-(id)initWithImage:(UIImage*)image selectedImage:(UIImage *)selImage tag:(int)tag;

@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,assign)BOOL nestedSelectionEnabled;

@end
