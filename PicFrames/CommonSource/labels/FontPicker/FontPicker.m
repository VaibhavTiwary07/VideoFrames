//
//  FontPicker.m
//  InstaCaptions
//
//  Created by Sunitha Gadigota on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FontPicker.h"

float fsizes[3] = {smallfontsize,meadiumfontsize,largefontsize};
#define fontformat @"Font_%d"
@interface FontPicker()
{
}
@end

@implementation FontPicker

@synthesize fontpickerDelegate,outputFontSize;

#define key_bundleversion @"key_bundleversion"

+(int)getSizeOfFontName:(NSString*)fntName toFitHeight:(float)height
{
    NSString *str = @"vijay";
    UIFont *f     = [UIFont fontWithName:fntName size:1.0];
    CGSize sze    = [str sizeWithFont:f];
    int fs = 2;
    while (sze.height < height) 
    {
        f = [UIFont fontWithName:fntName size:fs];
        sze = [str sizeWithFont:f];
        fs = fs + 1;
    }
    
    return (fs-1);
}

+(void)initDatabase
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    /* First get the saved bundle version and current bundle version */
    NSString *savedVersion = [def objectForKey:key_bundleversion];
    NSString *curver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if(nil == savedVersion)
    {
        /* save it to user defaults */
        [def setObject:curver forKey:key_bundleversion];
    }
    else 
    {
        /* if the bundle versions are same then we don't need to worry */
        if([savedVersion isEqualToString:curver])
        {
            return;
        }
        
        /* Updated the defaults with current vesion  */
        [def setObject:curver forKey:key_bundleversion];
    }
    
    /* needs to create the databse */
    NSArray *familyNames = [UIFont familyNames];
    NSInteger indFamily;
    NSInteger indFont;
    NSArray *fontNames;
    int      count = 0;
    
    /* get the fonts from each and every family */
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        fontNames = [UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSString *fntName = [fontNames objectAtIndex:indFont];
            if([fntName isEqualToString:defaultfontname])
            {
                NSLog(@"Found Current Font++++++++++++++++++++++++++++++++++++ %d",count);
                [def setInteger:count forKey:key_current_font_Index];
            }
            int fntSize = [FontPicker getSizeOfFontName:fntName toFitHeight:displayfontsize];
            
            /* Add the font to defaults */
            [def setObject:fntName forKey:[NSString stringWithFormat:fontformat,count]];
            
            /* calculate display font size and add it to defaults */
            [def setInteger:fntSize forKey:fntName];
            
            count++;
        }
    }
    
    /* update total number of fonts */
    [def setInteger:count forKey:key_font_count];
    
    [def synchronize];
    
    return;
}

-(void)dealloc
{
    [super dealloc];
}

+(UIFont*)currentFont
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    int index = [def integerForKey:key_current_font_Index];
    NSString *fntName = [def objectForKey:[NSString stringWithFormat:fontformat,index]];
    if(nil == fntName)
    {
        return nil;
    }
    
    NSInteger fntSize = [def integerForKey:fntName];
    
    if(fntSize == 0)
    {
        NSLog(@"[Error]FontPicker: Database is not initialized to get current font");
        return nil;
    }
    
    return [UIFont fontWithName:fntName size:fntSize];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        self.showsSelectionIndicator = YES;
        self.outputFontSize = outputfontsize;
        int index = [[NSUserDefaults standardUserDefaults] integerForKey:key_current_font_Index];
        
        /* set the selected index */
        [self selectRow:index inComponent:0 animated:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"Vijay";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        int count = [[NSUserDefaults standardUserDefaults]integerForKey:key_font_count];
        if(count == 0)
        {
            [FontPicker initDatabase];
            count = [[NSUserDefaults standardUserDefaults]integerForKey:key_font_count];
        }
        
        return count;
    }
    
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(component == 0)
    {
        //return (self.frame.size.width * 0.57f);
        return self.frame.size.width;
    }
    
    return (self.frame.size.width * 0.3f);
}

-(NSString*)fontNameAtIndex:(NSInteger)row
{
    NSString *key = [NSString stringWithFormat:fontformat,row];
    NSString *fntName = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    return fntName;
}

-(int)displayFontSizeAtIndex:(NSInteger)row
{
    NSString *fntName = [self fontNameAtIndex:row];
    NSInteger fntSize = [[NSUserDefaults standardUserDefaults]integerForKey:fntName];
    
    return fntSize;
}

-(UIFont*)fontAtIndex:(NSInteger)row ofSize:(float)sze
{
    NSString *fntName = [self fontNameAtIndex:row];
    UIFont *font = [UIFont fontWithName:fntName size:sze];

    return font;
}

#if 0
-(UIFont*)fontAtIndex:(NSInteger)row
{
    NSInteger fntSize = [self displayFontSizeAtIndex:row];
    float adjSize = fntSize * (float)(outputfontsize/self.outputFontSize);
    
    return [self fontAtIndex:row ofSize:adjSize];
}
#endif

-(UIFont *)displayFontAtIndex:(NSInteger)row
{
    NSInteger fntSize = [self displayFontSizeAtIndex:row];
    
    return [self fontAtIndex:row ofSize:fntSize];
}

-(UIFont*)outputFontAtIndex:(NSInteger)row
{
    NSInteger fntSize = [self displayFontSizeAtIndex:row];
    float adjSize = fntSize * (float)(self.outputFontSize/displayfontsize);
    
    return [self fontAtIndex:row ofSize:adjSize];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIFont *fnt = [self outputFontAtIndex:row];
    
    [[NSUserDefaults standardUserDefaults]setInteger:row forKey:key_current_font_Index];
    
    [fontpickerDelegate fontChangedTo:fnt];

    return;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = nil;
    
    if(component == 0)
    {
        NSLog(@"Forming Row %d+++++++++++++++++++++++%d",row,row);
        float fntSize = [self displayFontSizeAtIndex:row] * (20.0f/displayfontsize);
        if(nil == view)
        {
            lbl = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 30.0)];
            lbl.text = [self fontNameAtIndex:row];
            lbl.font = [self fontAtIndex:row ofSize:fntSize];
            lbl.backgroundColor = [UIColor clearColor];
            //lbl.textColor = [UIColor greenColor];
            lbl.textAlignment = UITextAlignmentCenter;
        }
        else 
        {
            lbl = (UILabel*)view;
            lbl.text = [self fontNameAtIndex:row];
            lbl.font = [self fontAtIndex:row ofSize:fntSize];
        }
    }
    else 
    {
        if(nil == view)
        {
            lbl = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 30.0)];
            lbl.backgroundColor = [UIColor clearColor];
            //lbl.textColor = [UIColor greenColor];
            lbl.textAlignment = UITextAlignmentCenter;
        }
        else 
        {
            lbl = (UILabel*)view;
        }

        lbl.font = [UIFont boldSystemFontOfSize:12];
        //lbl.font = [self fontAtIndex:[pickerView selectedRowInComponent:0]];
        if(row == 0)
        {
            lbl.text = @"Small";
        }
        else if(row == 1)
        {
            lbl.text = @"Meadium";
        }
        else 
        {
            lbl.text = @"Large";
        }
        
    }
    
    return lbl;
}

@end
