//
//  FontPicker.h
//  InstaCaptions
//
//  Created by Sunitha Gadigota on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define smallfontsize   14
#define meadiumfontsize 21
#define largefontsize   28

#define key_default_font      @"key_default_font"
#define key_default_font_size @"key_default_font_size"

@protocol FontPickerDelegate
-(void)fontChangedTo:(UIFont*)fnt;
@end

@interface FontPicker : UIPickerView <UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,retain)id<FontPickerDelegate> pickerDelegate;
-(UIFont*)defaultFontToFitHeight:(float)height;
@end