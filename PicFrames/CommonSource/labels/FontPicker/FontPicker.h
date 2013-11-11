//
//  FontPicker.h
//  InstaCaptions
//
//  Created by Sunitha Gadigota on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#define outputfontsize  30.0
#define displayfontsize 30.0


#define smallfontsize   14
#define meadiumfontsize 21
#define largefontsize   28

#define defaultfontname        @"CrashLandingBB"
#define key_default_font       @"key_default_font"
#define key_default_font_size  @"key_default_font_size"
#define key_font_count         @"key_font_count"
#define key_current_font_Index @"key_current_font_Index"

@protocol FontPickerDelegate
-(void)fontChangedTo:(UIFont*)fnt;
@end

@interface FontPicker : UIPickerView <UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,retain)id<FontPickerDelegate> fontpickerDelegate;
@property(nonatomic,readwrite)float outputFontSize;
//-(UIFont*)defaultFontToFitHeight:(float)height;
+(void)initDatabase;
+(UIFont*)currentFont;

@end