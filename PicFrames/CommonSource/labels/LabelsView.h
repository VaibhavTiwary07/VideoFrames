//
//  LabelsView.h
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 7/28/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlowLabel.h"
#import "FontPicker.h"
#import "RSColorPickerView.h"
#import "RSBrightnessSlider.h"
#import "UIImage+utils.h"
#import "CustomUI.h"
#import "ColorPickerView.h"
#import "ColorSlidersView.h"


#define begineditinglabel @"begineditinglabel"
#define endeditinglabel   @"endeditinglabel"
#define textfield         @"textfield"
#define keyboardheight    ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?264.0:216.0)
#define toolbartag        5000
#define colorpickertag    5001
#define segmentcontroltag 5002
#define colorpreviewtag   5003
#define textrscolorpickertag 5004
#define bgndrscolorpickertag 5005

#define minlabelwidth 30

#define minlabelcornerradius 10.0f
#define maxlabelcornerradius 19.0f
//#define labelsmodule @"labels"
#define labelstextmodule @"labelstext"
#define labelsbgndmodule @"labelsbgnd"

typedef enum
{
    COLOR_MODE_TEXT,
    COLOR_MODE_LABEL,
}eColorPickerMode;

@interface LabelsView : UIView <UITextFieldDelegate,FontPickerDelegate,RSColorPickerViewDelegate,ColorPickerViewDelegate>

@property(nonatomic,assign)UIView *mainview;
@property(nonatomic,retain)UIFont *selectedFont;
@property(nonatomic,retain)UIColor *selectedFontColor;
@property(nonatomic,retain)UIColor *selectedBgndColor;
@property(nonatomic,readwrite)BOOL bLabelBackground;
@property(nonatomic,readwrite)float fLabelBackgroundOpacity;
@property(nonatomic,readwrite)float fLabelCornerRadius;
@property(nonatomic,readwrite)UITextBorderStyle eLabelBorder;

- (UIImage*)renderToImageOfSize:(CGSize)sze;
-(void)clearAllLabels;
-(int)labelCount;
-(void)suspendLabels;

@end
