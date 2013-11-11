//
//  LabelsView.m
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 7/28/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "LabelsView.h"

#define tag_lblkeyboardtoolbar 6000
#define tag_lblfonttollbar     6001
#define tag_lblcolortollbar    6002
#define tag_lblfontpicker      6003
#define tag_lblcolorpicker     6004
#define tag_lblstylepicker     6005
#define tag_lblstyletoolbar    6006

@interface LabelsView()
{
    CGPoint touchPointbegin;
    CGPoint touchPointend;
    GlowLabel *pLable;
    NSMutableArray *labels;
    UIToolbar *toolbar;
    BOOL bReportKeyboardExit;
    
    eColorPickerMode pickerMode;
    
    float _backgroundOpacity;
    float _cornerRadius;
    BOOL  _background;
    UITextBorderStyle _borderStyle;
    UIColor *_bgndColor;
    BOOL _bAllowNewLables;
}
@end

@implementation LabelsView
@synthesize fLabelBackgroundOpacity;
@synthesize bLabelBackground;
@synthesize mainview;
@synthesize selectedBgndColor;
@synthesize selectedFont;
@synthesize selectedFontColor;
@synthesize fLabelCornerRadius;
@synthesize eLabelBorder;

-(void)initializeDefaults
{
    pLable                 = nil;
    bReportKeyboardExit    = YES;
    pickerMode             = COLOR_MODE_TEXT;
    self.backgroundColor   = [UIColor clearColor];
    //self.selectedFont      = [UIFont boldSystemFontOfSize:17];
    self.selectedFont      = [FontPicker currentFont];
    self.selectedFontColor = [UIColor blackColor];
    self.selectedBgndColor = [UIColor whiteColor];
    self.fLabelBackgroundOpacity = 1.0f;
    self.bLabelBackground  = YES;
    self.fLabelCornerRadius = minlabelcornerradius;
    self.eLabelBorder       = UITextBorderStyleRoundedRect;
    _bAllowNewLables = YES;
    
    return;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initializeDefaults];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder 
{
    [super encodeWithCoder:coder];
    
    return;
}

- (id)initWithCoder:(NSCoder *)coder 
{
    self = [super initWithCoder:coder];
    if (self) 
    {
        for(int i = 0; i < [self.subviews count]; i++)
        {
            GlowLabel *lbl = [self.subviews objectAtIndex:i];
            CGAffineTransform trans = lbl.transform;
            lbl.transform = CGAffineTransformIdentity;
            lbl.layer.anchorPoint = CGPointMake(0.0, 0.5);
            lbl.transform = trans;
        }
        
        [self initializeDefaults];
    }
    
    return self;
}

-(void)doneWithFontSubtoolbar
{
    /* Remove font picker */
    FontPicker *fp = (FontPicker*)[self.mainview viewWithTag:tag_lblfontpicker];
    if(nil != fp)
    {
        
        [fp removeFromSuperview];
        fp = nil;
    }
    
    /* Update the selected font */
    self.selectedFont = pLable.font;
    
    /* Hide the toolbar */
    [self hideAnyToolbar];
    
    /* Show key board and its toolbar again */
    [pLable becomeFirstResponder];
    
    return;
}

-(void)cancelFontSubtoolbar
{
    /* Remove font picker */
    FontPicker *fp = (FontPicker*)[self.mainview viewWithTag:tag_lblfontpicker];
    if(nil != fp)
    {
        
        [fp removeFromSuperview];
        fp = nil;
    }
    
    /* Revertback to old font */
    pLable.font = self.selectedFont;
    
    /* Hide the toolbar */
    [self hideAnyToolbar];
    
    /* Show key board and its toolbar again */
    [pLable becomeFirstResponder];
    
    return;
}

-(void)showFontToolbar
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *color = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelFontSubtoolbar)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithFontSubtoolbar)];
    NSArray *itms = [[NSArray alloc]initWithObjects:color,space,done,nil];
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    
    /* Now allocate the toolbar */
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, fullScreen.size.height - keyboardheight - 44, fullScreen.size.width, 50.0)];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.tag = tag_lblfonttollbar;
    
    [toolbar sizeToFit];
    
    /* set the toolbar items */
    [toolbar setItems:itms];
    
    [self.mainview addSubview:toolbar];
    
    [itms release];
    [done release];
    [space release];
    [color release];
    [toolbar release];
}

-(void)suspendLabels
{
    /* Remove font picker */
    UIImageView *cp = (UIImageView*)[self.mainview viewWithTag:tag_lblcolorpicker];
    if(nil != cp)
    {
        
        [cp removeFromSuperview];
        cp = nil;
    }
    
    /* Remove font picker */
    FontPicker *fp = (FontPicker*)[self.mainview viewWithTag:tag_lblfontpicker];
    if(nil != fp)
    {
        
        [fp removeFromSuperview];
        fp = nil;
    }
    
    /* Hide the toolbar */
    [self hideAnyToolbar];
}

-(void)cancelColorSubtoolbar
{
    /* Remove font picker */
    UIImageView *cp = (UIImageView*)[self.mainview viewWithTag:tag_lblcolorpicker];
    if(nil != cp)
    {
        
        [cp removeFromSuperview];
        cp = nil;
    }
    
    pLable.textColor = self.selectedFontColor;
    pLable.backgroundColor = self.selectedBgndColor;
    
    /* Hide the toolbar */
    [self hideAnyToolbar];
    
    /* Show key board and its toolbar again */
    [pLable becomeFirstResponder];
}

-(void)doneWithColorSubtoolbar
{
    /* Remove font picker */
    UIImageView *cp = (UIImageView*)[self.mainview viewWithTag:tag_lblcolorpicker];
    if(nil != cp)
    {
        
        [cp removeFromSuperview];
        cp = nil;
    }
    
    self.selectedBgndColor = _bgndColor;
    self.selectedFontColor = pLable.textColor;
    
    /* Hide the toolbar */
    [self hideAnyToolbar];
    
    /* Show key board and its toolbar again */
    [pLable becomeFirstResponder];
}

-(void)colorPickerViewDidChangeSelection:(UIColor *)clr
{
    if(pickerMode == COLOR_MODE_TEXT)
    {
        pLable.textColor = clr;
    }
    else if(pickerMode == COLOR_MODE_LABEL) 
    {
        _bgndColor = [[clr colorWithAlphaComponent:self.fLabelBackgroundOpacity] retain];
        if(self.bLabelBackground)
        {
            pLable.backgroundColor = [clr colorWithAlphaComponent:self.fLabelBackgroundOpacity];
        }
    }
    
    UIImageView *p = (UIImageView*)[self.mainview viewWithTag:tag_lblcolorpicker];
    if(nil != p)
    {
        UIImageView *sc = (UIImageView *)[p viewWithTag:colorpreviewtag];
        
        if(nil != sc)
        {
            sc.backgroundColor = clr;
        }
    }
    
    return;
}

-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp 
{
#if 0    
    if(pickerMode == COLOR_MODE_TEXT)
    {
        pLable.textColor = cp.selectionColor;
    }
    else if(pickerMode == COLOR_MODE_LABEL) 
    {
        _bgndColor = [[cp.selectionColor colorWithAlphaComponent:self.fLabelBackgroundOpacity] retain];
        if(self.bLabelBackground)
        {
            pLable.backgroundColor = [cp.selectionColor colorWithAlphaComponent:self.fLabelBackgroundOpacity];
        }
    }
    
    UIImageView *p = (UIImageView*)[self.mainview viewWithTag:tag_lblcolorpicker];
    if(nil != p)
    {
        UIImageView *sc = (UIImageView *)[p viewWithTag:colorpreviewtag];
        
        if(nil != sc)
        {
            sc.backgroundColor = cp.selectionColor;
        }
    }
#else
    [self colorPickerViewDidChangeSelection:cp.selectionColor];
#endif
    return;
}

-(RSColorPickerView*)allocateRSColorPickerWithRect:(CGRect)r WithTag:(int)index forModule:(NSString*)modName
{
    RSColorPickerView *colorPicker = [[RSColorPickerView alloc] initWithFrame:r forModule:modName];
	[colorPicker setDelegate:self];
	[colorPicker setBrightness:1.0];
	[colorPicker setCropToCircle:NO]; // Defaults to YES (and you can set BG color)
	[colorPicker setBackgroundColor:[UIColor clearColor]];
    colorPicker.tag = index;
    
    return colorPicker;
}

-(UIImageView*)allocateColorPicker
{
    CGRect fullscreen = [[UIScreen mainScreen]bounds];
    /* make sure that we ignore colo */
    UIImageView *pickerBg = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, fullscreen.size.height - keyboardheight, fullscreen.size.width, keyboardheight)];
    pickerBg.backgroundColor = [UIColor blackColor];
    //pickerBg.image = [UIImage imageNamed:@"ColorPallet.png"];
    pickerBg.userInteractionEnabled = YES;
    
    CGRect r = CGRectMake(21.0, 7.0, fullscreen.size.width-(21.0*2.0)-80.0, keyboardheight-14.0);
    //CGRect r = CGRectMake(21.0, 7.0, 400, keyboardheight-64.0);
    /* RS color picker */
    //RSColorPickerView *colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(21.0, 7.0, 200.0, 200.0)];
    RSColorPickerView *colorPicker = [self allocateRSColorPickerWithRect:r WithTag:textrscolorpickertag forModule:labelstextmodule];
#if 0    
    RSColorPickerView *colorPicker = [[RSColorPickerView alloc] initWithFrame:r forModule:labelsmodule];
	[colorPicker setDelegate:self];
	[colorPicker setBrightness:1.0];
	[colorPicker setCropToCircle:NO]; // Defaults to YES (and you can set BG color)
	[colorPicker setBackgroundColor:[UIColor clearColor]];
    colorPicker.tag = textrscolorpickertag;
#endif  
    /* Selected color view */
    UIImageView *selectedColor = [[UIImageView alloc]initWithFrame:CGRectMake((colorPicker.frame.origin.x*2)+colorPicker.frame.size.width+25.0,colorPicker.frame.origin.y,30.0,colorPicker.frame.size.height)];
    selectedColor.backgroundColor = [RSColorPickerView getCurrentColorForModule:labelstextmodule];
    //selectedColor.layer.cornerRadius = 9.0;
    //selectedColor.layer.masksToBounds = YES;
    selectedColor.tag = colorpreviewtag;
    
#if 0    
    ColorPickerView *cpv = [[ColorPickerView alloc]initWithFrame:CGRectMake(selectedColor.frame.origin.x+selectedColor.frame.size.width + 40, colorPicker.frame.origin.y+20.0, fullscreen.size.width-(selectedColor.frame.origin.x+selectedColor.frame.size.width+40), keyboardheight)];
    cpv.del = self;
    
    cpv.transform = CGAffineTransformMakeScale(1.0, 1.2);
//#else
    ColorSlidersView *cpv = [[ColorSlidersView alloc]initWithFrame:CGRectMake(selectedColor.frame.origin.x+selectedColor.frame.size.width + 40, colorPicker.frame.origin.y, fullscreen.size.width-(selectedColor.frame.origin.x+selectedColor.frame.size.width+40), keyboardheight)];
    
#endif
    /* Add color picker */
    [pickerBg addSubview:colorPicker];
    [pickerBg addSubview:selectedColor];
#if 0    
    [pickerBg addSubview:cpv];
    [cpv release];
#endif    
    [selectedColor release];
    
    
    /* Release memory for color pickers */
    [colorPicker release];
    
    pickerBg.tag = tag_lblcolorpicker;
    
    return pickerBg;
}

-(void)colorPickerModeChanged:(UISegmentedControl*)sender
{
    /* No need to create the picker if the selection is not changed */
    if(pickerMode == sender.selectedSegmentIndex)
    {
        return;
    }
    
    CGRect rec;
    RSColorPickerView *curPicker = nil;
    
    
    UIImageView *p = (UIImageView*)[self.mainview viewWithTag:tag_lblcolorpicker];
    if(nil != p)
    {
        /* First get the current rs color picker */
        if(pickerMode == COLOR_MODE_TEXT)
        {
            curPicker = (RSColorPickerView*)[p viewWithTag:textrscolorpickertag];
        }
        else 
        {
            curPicker = (RSColorPickerView*)[p viewWithTag:bgndrscolorpickertag];
        }
        
        /* If there is any color picker then remove it from view */
        if(nil != curPicker)
        {
            /* Get its co-ordinates */
            rec = curPicker.frame;

            /* Now remove it from its superview */
            [curPicker removeFromSuperview];
            
            curPicker = nil;
        }
        
        /* Selection is changed, so create the new color picker */
        pickerMode = sender.selectedSegmentIndex;
        
        UIImageView *sc = (UIImageView *)[p viewWithTag:colorpreviewtag];
        if(nil != sc)
        {
            if(pickerMode == COLOR_MODE_TEXT)
            {
                curPicker = [self allocateRSColorPickerWithRect:rec WithTag:textrscolorpickertag forModule:labelstextmodule];
                sc.backgroundColor = [RSColorPickerView getCurrentColorForModule:labelstextmodule];
                //sc.backgroundColor = pLable.textColor;
            }
            else 
            {
                curPicker = [self allocateRSColorPickerWithRect:rec WithTag:bgndrscolorpickertag forModule:labelsbgndmodule];
                //sc.backgroundColor = pLable.backgroundColor;
                sc.backgroundColor = [RSColorPickerView getCurrentColorForModule:labelsbgndmodule];
            }
            
            if(nil != curPicker)
            {
                [p addSubview:curPicker];
                [curPicker release];
            }
        }
    }
}

-(void)dealloc
{
    self.selectedFont = nil;
    self.selectedBgndColor = nil;
    self.selectedFont = nil;
    self.mainview = nil;
    [super dealloc];
}

-(void)showColorToolbar
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *color = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelColorSubtoolbar)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithColorSubtoolbar)];
    NSArray *sgmnts = [NSArray arrayWithObjects:@"Text",@"Label", nil];
    UISegmentedControl *sgctrl = [[UISegmentedControl alloc]initWithItems:sgmnts];
    sgctrl.frame = CGRectMake(0, 7, 150, 30);
    sgctrl.selectedSegmentIndex = 0;
    sgctrl.segmentedControlStyle = UISegmentedControlStyleBar;
    sgctrl.tintColor = [UIColor grayColor];
    [sgctrl addTarget:self
               action:@selector(colorPickerModeChanged:)
     forControlEvents:UIControlEventValueChanged];
    sgctrl.tag = segmentcontroltag;
    
    NSArray *itms = [[NSArray alloc]initWithObjects:color,space,/*sgctrl,*/space1,done,nil];
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    
    /* Now allocate the toolbar */
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, fullScreen.size.height - keyboardheight - 44, fullScreen.size.width, 50.0)];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.tag = tag_lblcolortollbar;
    
    [toolbar sizeToFit];
    
    /* set the toolbar items */
    [toolbar setItems:itms];
    
    sgctrl.center = toolbar.center;
    
    
    
    [self.mainview addSubview:toolbar];
    
    [self.mainview addSubview:sgctrl];
    
    [itms release];
    [done release];
    [space release];
    [space1 release];
    [sgctrl release];
    [color release];
    [toolbar release];
}

-(void)fontChangedTo:(UIFont *)fnt
{
    pLable.font = fnt;
}

-(void)showFontPicker
{
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    bReportKeyboardExit = NO;
    
    [pLable resignFirstResponder];
    [pLable putInSuspendedState];
    
    FontPicker *fp = [[FontPicker alloc]initWithFrame:CGRectMake(0, fullScreen.size.height - keyboardheight, fullScreen.size.width, keyboardheight)];
    fp.fontpickerDelegate = self;
    fp.tag = tag_lblfontpicker;
    
    [self.mainview addSubview:fp];
    
    [fp release];
    
    [self showFontToolbar];
}

-(void)showColorPicker
{
    NSLog(@"Show Color Picker is Called---------------------");
    bReportKeyboardExit = NO;
    pickerMode = COLOR_MODE_TEXT;
    
    _bgndColor = self.selectedBgndColor;
    
    [pLable resignFirstResponder];
    
    [pLable putInSuspendedState];
    
    UIImageView *cp = [self allocateColorPicker];
    cp.tag = tag_lblcolorpicker;
    
    [self.mainview addSubview:cp];
    
    [cp release];
    
    
    [self showColorToolbar];
    
    [self.mainview bringSubviewToFront:cp];
}

-(void)cancelStyleSubtoolbar
{
    /* Remove font picker */
    UIImageView *cp = (UIImageView*)[self.mainview viewWithTag:tag_lblstylepicker];
    if(nil != cp)
    {
        [cp removeFromSuperview];
        cp = nil;
    }
    
    /* Label background setting */
    if(self.bLabelBackground)
    {
        pLable.backgroundColor = self.selectedBgndColor;
    }
    else 
    {
        pLable.backgroundColor = [UIColor clearColor];
    }
    
    //[pLable.backgroundColor colorWithAlphaComponent:self.fLabelBackgroundOpacity];
    pLable.layer.cornerRadius = self.fLabelCornerRadius;
    pLable.borderStyle        = self.eLabelBorder;

    /* Hide the toolbar */
    [self hideAnyToolbar];
    
    /* Show key board and its toolbar again */
    [pLable becomeFirstResponder];
}

-(void)doneWithStyleSubtoolbar
{
    /* Remove font picker */
    UIImageView *cp = (UIImageView*)[self.mainview viewWithTag:tag_lblstylepicker];
    if(nil != cp)
    {
        
        [cp removeFromSuperview];
        cp = nil;
    }
    
    /* Save lable background */
    self.bLabelBackground        = _background;
    self.fLabelBackgroundOpacity = _backgroundOpacity;
    
    /* We need to update the background color only if the background
       is enabled */
    //if(self.bLabelBackground)
    {
        self.selectedBgndColor       = [self.selectedBgndColor colorWithAlphaComponent:self.fLabelBackgroundOpacity];
    }
    self.fLabelCornerRadius      = _cornerRadius;
    self.eLabelBorder            = _borderStyle;

    /* Hide the toolbar */
    [self hideAnyToolbar];
    
    /* Show key board and its toolbar again */
    [pLable becomeFirstResponder];
}

-(void)lableBackgroundToggle:(UISwitch*)sw
{
    if(sw.on)
    {
        pLable.backgroundColor = [self.selectedBgndColor colorWithAlphaComponent:_backgroundOpacity];
        //pLable.borderStyle = UITextBorderStyleRoundedRect;
        //_borderStyle       = UITextBorderStyleRoundedRect;
        pLable.borderStyle   = _borderStyle;
        
    }
    else 
    {
        pLable.backgroundColor = [UIColor clearColor];
        pLable.borderStyle = UITextBorderStyleNone;
        //_borderStyle       = UITextBorderStyleNone;
    }
    
    _background = sw.on;
    
    return;
}

-(void)lableBoderToggle:(UISwitch*)sw
{
    
//#ifdef BORDER       
    if(sw.on)
    {
        if(_background)
        {
            pLable.borderStyle = UITextBorderStyleRoundedRect;
        }
        _borderStyle       = UITextBorderStyleRoundedRect;
    }
    else 
    {
        if(_background)
        {
            pLable.borderStyle = UITextBorderStyleNone;
        }
        _borderStyle       = UITextBorderStyleNone;
    }
//#endif    
    
    return;
}

- (UIImage*)renderToImageOfSize:(CGSize)sze
{
    float scale = 0.0;
    int   num1  = sze.width;
    int   num2  = self.frame.size.width; 
    
    NSLog(@"renderToImageOfSize frame size %f,%f",self.frame.size.width,self.frame.size.height);
    
    if(0 == (num1 % num2))
    {
        scale = num1/num2;
    }
    else 
    {
        scale = (float)num1/(float)num2;
    }
    
    num1 = sze.height;
    num2 = self.frame.size.height;
    
    if(0 == (num1 % num2))
    {
        scale = num1/num2;
    }
    else 
    {
        scale = (float)num1/(float)num2;
    }
    
    // IMPORTANT: using weak link on UIKit
    //if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    }
    //else 
    //{
    //    NSLog(@"UIGraphicsBeginImageContextWithOptions is NULL");
    //    UIGraphicsBeginImageContext(sze);
    //}
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    UIImage *image = [UIImage imageWithCGImage:image1.CGImage];
    NSLog(@"renderToImageOfSize: %f,%f, scale %f to %f,%f",self.frame.size.width,self.frame.size.height,scale,image.size.width,image.size.height);
    return image;
}

-(void)lableBackgroundOpacity:(UISlider*)sldr
{
    if(_background)
    {
        UIColor *clr = [pLable.backgroundColor colorWithAlphaComponent:sldr.value];
        pLable.backgroundColor = clr;
    }
    
    _backgroundOpacity = sldr.value;
    
    return;
}

-(void)lableCornerRadius:(UISlider*)sldr
{
    pLable.layer.cornerRadius = sldr.value;
    pLable.layer.masksToBounds = YES;
    _cornerRadius = sldr.value;
}

-(UIImageView*)allocateStylePicker
{
    CGRect fullscreen = [[UIScreen mainScreen]bounds];
    UIImageView *bgnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, fullscreen.size.height-keyboardheight, fullscreen.size.width, keyboardheight)];
    //bgnd.image = [UIImage imageNamed:@"stylebg.jpg"];
    bgnd.backgroundColor = [UIColor blackColor];
    
    float fGap = (keyboardheight/4.0) - 5.0;
    bgnd.backgroundColor = [UIColor blackColor];
    bgnd.userInteractionEnabled = YES;
    
    UIColor *textClr = [UIColor whiteColor];
    UIFont  *fnt = nil;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        fnt = [UIFont boldSystemFontOfSize:12];
    }
    else 
    {
        fnt = [UIFont boldSystemFontOfSize:12];
    }
    float lblWidth  = 150.0;
    float lblHeight = 30.0;
    //float sliderWidth = 180.0;
    float sliderHeight = 30.0;
    float fLable_X = 20.0;
    float sliderWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?360:140;
    
    //UIImageView *gray = [[UIImageView alloc]initWithFrame:CGRectMake(10, fullscreen.size.height-keyboardheight-10, fullscreen.size.width-20, keyboardheight-20)];
    UIImageView *gray = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,fullscreen.size.width-20,keyboardheight-20)];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        gray.image = [UIImage imageNamed:@"stylebg.png"]; 
    }
    else 
    {
        gray.image = [UIImage imageNamed:@"stylebg_iphone.png"]; 
    }
    //gray.backgroundColor = [UIColor redColor];
    [bgnd addSubview:gray];
    [gray release];

    /* Add switch to enable or disable the background */
    UILabel *lblBackground = [[UILabel alloc]initWithFrame:CGRectMake(fLable_X,fGap*0.5, lblWidth, lblHeight)];
    lblBackground.text = @"LABEL BACKGROUND";
    lblBackground.textColor = textClr;
    lblBackground.font = fnt;
    lblBackground.backgroundColor = [UIColor clearColor];
    [bgnd addSubview:lblBackground];
    [lblBackground release];
    UISwitch *lblBackgroundSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(fullscreen.size.width - 100.0, fGap*0.5, 50.0, 30.0)];
    if(self.bLabelBackground)
    {
        lblBackgroundSwitch.on = YES;
    }
    else 
    {
        lblBackgroundSwitch.on = NO;
    }
    
    [lblBackgroundSwitch addTarget:self action:@selector(lableBackgroundToggle:) forControlEvents:UIControlEventValueChanged];
    [bgnd addSubview:lblBackgroundSwitch];
    [lblBackgroundSwitch release];
    
    /* Add slider to increase the Font Size */
    UILabel *lblBorder = [[UILabel alloc]initWithFrame:CGRectMake(fLable_X, fGap*1.5, lblWidth, lblHeight)];
    lblBorder.textColor = textClr;
    lblBorder.font = fnt;
    lblBorder.backgroundColor = [UIColor clearColor];
    lblBorder.text = @"LABEL BORDER";
    [bgnd addSubview:lblBorder];
    [lblBorder release];
    
    UISwitch *lblBorderSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(fullscreen.size.width - 100.0, fGap*1.5, 50.0, 30.0)];
    if(self.eLabelBorder == UITextBorderStyleRoundedRect)
    {
        lblBorderSwitch.on = YES;
    }
    else 
    {
        lblBorderSwitch.on = NO;
    }
    
    [lblBorderSwitch addTarget:self action:@selector(lableBoderToggle:) forControlEvents:UIControlEventValueChanged];
    [bgnd addSubview:lblBorderSwitch];
    [lblBorderSwitch release];
    
    /* Add slider to change the opacity of background */
    UILabel *lblBackgroundOpacity = [[UILabel alloc]initWithFrame:CGRectMake(fLable_X, fGap*2.5, lblWidth, lblHeight)];
    lblBackgroundOpacity.textColor = textClr;
    lblBackgroundOpacity.font = fnt;
    //lblBackgroundOpacity.text = @"BACKGROUND OPACITY";
    lblBackgroundOpacity.text = @"LABEL OPACITY";
    lblBackgroundOpacity.backgroundColor = [UIColor clearColor];
    [bgnd addSubview:lblBackgroundOpacity];
    [lblBackgroundOpacity release];
    UISlider *lblBackgroundOpacitySlider = [CustomUI allocateCustomSlider:CGRectMake(fullscreen.size.width-sliderWidth-fLable_X, fGap*2.5, sliderWidth, sliderHeight)];
    [lblBackgroundOpacitySlider addTarget:self action:@selector(lableBackgroundOpacity:) forControlEvents:UIControlEventValueChanged];
    lblBackgroundOpacitySlider.minimumValue = 0.0;
    lblBackgroundOpacitySlider.maximumValue = 1.0;
    lblBackgroundOpacitySlider.value = self.fLabelBackgroundOpacity;
    NSLog(@"Brightness slider %f",lblBackgroundOpacitySlider.value);
    [bgnd addSubview:lblBackgroundOpacitySlider];
    [lblBackgroundOpacitySlider release];
    
    /* Add Slider For changing the corner radius */
    UILabel *lblCornerRadius = [[UILabel alloc]initWithFrame:CGRectMake(fLable_X, fGap*3.5, lblWidth, lblHeight)];
    lblCornerRadius.textColor = textClr;
    lblCornerRadius.font = fnt;
    lblCornerRadius.backgroundColor = [UIColor clearColor];
    lblCornerRadius.text = @"CORNER RADIUS";
    [bgnd addSubview:lblCornerRadius];
    [lblCornerRadius release];
    
    UISlider *lblCornerRadiusSlider = [CustomUI allocateCustomSlider:CGRectMake(fullscreen.size.width-sliderWidth-fLable_X, fGap*3.5, sliderWidth, sliderHeight)];
    //NSLog(@"Current Corner Radius %f",self.fLabelCornerRadius);
    /*lblCornerRadiusSlider.value = self.fLabelCornerRadius;
    NSLog(@"Current Corner Radius %f",lblCornerRadiusSlider.value);
    lblCornerRadiusSlider.minimumValue = minlabelcornerradius;
    lblCornerRadiusSlider.maximumValue = maxlabelcornerradius;*/
    
    //NSLog(@"Current Corner Radius %f",lblCornerRadiusSlider.value);
    lblCornerRadiusSlider.minimumValue = minlabelcornerradius;
    lblCornerRadiusSlider.maximumValue = maxlabelcornerradius;
    lblCornerRadiusSlider.value = self.fLabelCornerRadius;
    [lblCornerRadiusSlider addTarget:self action:@selector(lableCornerRadius:) forControlEvents:UIControlEventValueChanged];
    [bgnd addSubview:lblCornerRadiusSlider];
    [lblCornerRadiusSlider release];

#if 0    
    /* Add slider to increase the Font Size */
    UILabel *lblSize = [[UILabel alloc]initWithFrame:CGRectMake(0.0, fGap*3.5, lblWidth, lblHeight)];
    lblSize.textColor = textClr;
    lblSize.font = fnt;
    lblSize.backgroundColor = [UIColor clearColor];
    lblSize.text = @"Label Size";
    [bgnd addSubview:lblSize];
    [lblSize release];
    
    UISlider *lblSizeSlider = [CustomUI allocateCustomSlider:CGRectMake(fullscreen.size.width-sliderWidth, fGap*3.5, sliderWidth, sliderHeight)];
    [bgnd addSubview:lblSizeSlider];
    lblSizeSlider.minimumValue = 17.0;
    lblSizeSlider.maximumValue = 25.0;
    lblSizeSlider.value = 20.0;
    [lblSizeSlider release];
#endif    
    
    return bgnd;
}

-(void)showStyleToolbar
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *color = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelStyleSubtoolbar)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithStyleSubtoolbar)];
    NSArray *itms = [[NSArray alloc]initWithObjects:color,space,done,nil];
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    
    /* Now allocate the toolbar */
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, fullScreen.size.height - keyboardheight - 44, fullScreen.size.width, 50.0)];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.tag = tag_lblstyletoolbar;
    
    [toolbar sizeToFit];
    
    /* set the toolbar items */
    [toolbar setItems:itms];
    
    [self.mainview addSubview:toolbar];
    
    [itms release];
    [done release];
    [space release];
    [color release];
    [toolbar release];
}

-(void)showStylePicker
{    
    bReportKeyboardExit = NO;
    
    [pLable resignFirstResponder];
    [pLable putInSuspendedState];
    
    _backgroundOpacity = self.fLabelBackgroundOpacity;
    _background        = self.bLabelBackground;
    _cornerRadius      = self.fLabelCornerRadius;
    _borderStyle       = self.eLabelBorder;
  
    UIImageView *style = [self allocateStylePicker];
    style.tag = tag_lblstylepicker;
    
    [self.mainview addSubview:style];
    [style release];
    
    [self showStyleToolbar];
}

-(void)clearAllLabels
{
    NSArray *views = self.subviews;
    
    if(nil == views)
    {
        NSLog(@"clearAllLabels: No labels are added to clear");
        return;
    }
    
    NSLog(@"clearAllLabels: Clearing %d labels",views.count);
    
    /* Get one by one and remove from labels view */
    for(int index = 0; index < views.count; index++)
    {
        GlowLabel *gl = [views objectAtIndex:index];
        if(nil != gl)
        {
            [gl removeFromSuperview];
        }
    }
}

-(int)labelCount
{
    NSArray *lbels = self.subviews;
    
    if(nil == lbels)
    {
        return 0;
    }
    
    return lbels.count;
}

-(void)showKeyboardToolBar
{
    UIBarButtonItem *fonts = [[UIBarButtonItem alloc]initWithTitle:@"FONTS" style:UIBarButtonItemStyleBordered target:self action:@selector(showFontPicker)];
    UIBarButtonItem *color = [[UIBarButtonItem alloc]initWithTitle:@"COLORS" style:UIBarButtonItemStyleBordered target:self action:@selector(showColorPicker)];
    UIBarButtonItem *style = [[UIBarButtonItem alloc]initWithTitle:@"STYLE" style:UIBarButtonItemStyleBordered target:self action:@selector(showStylePicker)];
    
    NSArray *itms = [[NSArray alloc]initWithObjects:fonts,color,style,nil];
    
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    /* Now allocate the toolbar */
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, fullScreen.size.height - keyboardheight - 44, fullScreen.size.width, 50.0)];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.tag = tag_lblkeyboardtoolbar;
    
    [toolbar sizeToFit];
    
    /* set the toolbar items */
    [toolbar setItems:itms];
    
    [self.mainview addSubview:toolbar];
    
    [itms release];
    [fonts release];
    [color release];
    [style release];
    [toolbar release];
    
    bReportKeyboardExit = YES;
}

-(void)hideAnyToolbar
{
    [toolbar removeFromSuperview];
    
    UISegmentedControl *sc = (UISegmentedControl*)[self.mainview viewWithTag:segmentcontroltag];
    if(nil != sc)
    {
        [sc removeFromSuperview];
    }
    
    [pLable putInReadystate];
}

#pragma mark touch handling
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(NO == _bAllowNewLables)
    {
        return;
    }
       
    touchPointbegin = [[touches anyObject] locationInView:self];
    
    /* create the text field and add it to the view */
    GlowLabel *txtFld = [[GlowLabel alloc] initWithFrame:CGRectMake(touchPointbegin.x, touchPointbegin.y - (25.0), 0.0, 30.0)];
    
    UIFont *pFont               = self.selectedFont;
    UIColor *pColor             = self.selectedFontColor;
    txtFld.borderStyle          = self.eLabelBorder;
    txtFld.delegate             = self;
    txtFld.font                 = pFont;
    txtFld.textAlignment        = UITextAlignmentCenter;
	txtFld.placeholder          = @"<Enter Text>";
    txtFld.textColor            = pColor;
    pLable                      = txtFld;
    if(self.bLabelBackground)
    {
        txtFld.backgroundColor       = self.selectedBgndColor;
    }
    else
    {
        txtFld.backgroundColor       = [UIColor clearColor];
    }
    
    txtFld.textColor             = pColor;
    //txtFld.layer.position        = txtFld.frame.origin;
    //txtFld.borderStyle               = UITextBorderStyleRoundedRect;
    //txtFld.backgroundColor      = [UIColor whiteColor];
    [txtFld.layer  setAnchorPoint:CGPointMake(0.0, 0.5)]; 
    txtFld.layer.cornerRadius = self.fLabelCornerRadius;
    txtFld.layer.masksToBounds = YES;
    //txtFld.adjustsFontSizeToFitWidth = YES;
    [txtFld initializeWithdefaults];
    txtFld.tag = labeltag;

    [self addSubview:txtFld];

    [txtFld release];
    
    return;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(NO == _bAllowNewLables)
    {
        return;
    }
    
    touchPointend = [[touches anyObject] locationInView:self];
    
    float distance = sqrtf((touchPointend.x - touchPointbegin.x)*(touchPointend.x - touchPointbegin.x) + (touchPointend.y - touchPointbegin.y) * (touchPointend.y - touchPointbegin.y));
    
    pLable.transform = CGAffineTransformIdentity;
    pLable.frame     = CGRectMake(touchPointbegin.x, touchPointbegin.y - (25.0), distance, 30.0);
    
    float xpoint = ((((atan2((touchPointbegin.x - touchPointend.x) , 
                             (touchPointbegin.y - touchPointend.y)))*180.0)/M_PI));
    xpoint = xpoint * -1;
	if (signbit(xpoint)) 
    {
		xpoint = xpoint + 270.0;
	}
	else if (xpoint < 90.0)
	{
		xpoint = xpoint + 270.0;
	}
	else if (xpoint >= 90.0)
	{
        xpoint = xpoint - 90.0;
	}
    
    pLable.transform = CGAffineTransformMakeRotation((M_PI * (xpoint))/180.0);
    
    return;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(NO == _bAllowNewLables)
    {
        return;
    }
    
    [pLable removeFromSuperview];
    pLable = nil;
    
    return;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(NO == _bAllowNewLables)
    {
        return;
    }
    
    if(pLable.bounds.size.width < minlabelwidth)
    {
        [pLable removeFromSuperview];
        pLable = nil;
        return;
    }
    
    [pLable becomeFirstResponder];
    
    return;
}

#pragma mark UITextFieldDelegate implementation
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int yourMaxWidth = self.frame.size.width;
    

    NSString *str = textField.text;
    NSString *str1 = [NSString stringWithFormat:@"   %@   ",str];
    float width = [str1 sizeWithFont:
                   textField.font  
                             constrainedToSize:
                   CGSizeMake(yourMaxWidth, textField.bounds.size.height)].width;

    if(width > textField.bounds.size.width)
    {
        CGPoint curcenter = textField.center;
        CGRect rec = CGRectMake(textField.bounds.origin.x, textField.bounds.origin.y, width, textField.bounds.size.height);
        
        textField.bounds = rec;
        textField.center = curcenter;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:textField forKey:textfield];
    [[NSNotificationCenter defaultCenter] postNotificationName:begineditinglabel object:self userInfo:dict];  
    
    [self showKeyboardToolBar];
    
    _bAllowNewLables = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hideAnyToolbar];
    
    if(bReportKeyboardExit)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:endeditinglabel object:textField userInfo:nil];
        
        [pLable     doneWithEditing];
        
        _bAllowNewLables = YES;
    }
    
    
    return;
}

@end
