//
//  FontPicker.m
//  InstaCaptions
//
//  Created by Sunitha Gadigota on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FontPicker.h"

typedef struct 
{
    char fontname[50];
    int size;
}font;
#define FONT_COUNT 23
#define AUTOFONT 1
//font fonts[30] = {{"Abscissa",20},{"Appetite",25},{}};
#if 0
char fontnames[30][50] = {"Abscissa","alphabetized cassette tapes","Appetite","attack of the cucumbers","BoyzRGrossNF","DirtyDarren","HeroOfFools","Otto","Quickhand","absci___", "abscib", "abscibi", "abscii", "amazingspider", "BADABB", "CandyTime", "CHLORINR", "CrashLandingBB_ital","CrashLandingBB", "digistrip_b", "digistrip_i", "digistrip", "Super Webcomic Bros. Bold Italic", "Super Webcomic Bros. Bold","Super Webcomic Bros.", "UNDERGRO"};
#else
char fontnames[FONT_COUNT][50] = {"Abscissa","Appetite","BoyzRGrossNF","HeroOfFools","Otto", "amazingspider", "CrashLandingBB","Super Webcomic Bros.","color basic", "Ethopool","FLATPACK", "holy smokes", "instant tunes", "JandaAsLongAsYouLoveMe", "JandaHappyDay", "JandaPolkadotParty", "JandaPolkadotPunch", "KR Tigrrr", "ManlyMenBB", "Sharp", "StraightToHellBB", "StraightToHellSinnerBB", "welfare brat"};
#endif
int *adjustedSize;
int *displaySize;
float fontsizes[3] = {smallfontsize,meadiumfontsize,largefontsize};

@interface FontPicker()
{
    NSMutableArray *_sysFonts;
}
@end

@implementation FontPicker

@synthesize pickerDelegate;

-(void)dealloc
{
    if(nil != _sysFonts)
    {
        [_sysFonts release];
    }
    
    if(NULL != adjustedSize)
    {
        free(adjustedSize);
    }
    
    if(NULL != displaySize)
    {
        free(displaySize);
    }
    
    [super dealloc];
}

-(void)printAllSystemFonts
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    
    if(nil != _sysFonts)
    {
        [_sysFonts release];
        _sysFonts = nil;
    }
    _sysFonts = [[NSMutableArray alloc]init];
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        //NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            [_sysFonts addObject:[fontNames objectAtIndex:indFont]];
            //NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
        [fontNames release];
    }
    [familyNames release];
}

#if 0
-(UIFont*)defaultFontToFitHeight:(float)height
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSString *defFontName = [d objectForKey:key_default_font];
    float defFontSize = 
    
    if()
    UIFont *f = [UIFont fontWithName:@"CrashLandingBB" size:1.0];
    
    CGSize sze = [@"vijay" sizeWithFont:f];
    int fs = 2;
    while (sze.height < height) 
    {
        f = [UIFont fontWithName:@"CrashLandingBB" size:fs];
        sze = [@"vijay" sizeWithFont:f];
        fs = fs + 1;
    }
    
    return f;
}
#endif

-(void)calcFontSizesToHeight:(float)height into:(int**)adj
{
    NSString *str = @"vijay";
    int iFntIndex = 0;
    int *tmp = malloc(sizeof(int)*(FONT_COUNT+_sysFonts.count));
    for(iFntIndex = 0; iFntIndex < FONT_COUNT; iFntIndex++)
    {
        NSString *fntName = [NSString stringWithFormat:@"%s",fontnames[iFntIndex]];
        UIFont *f = [UIFont fontWithName:fntName size:1.0];
        CGSize sze = [str sizeWithFont:f];
        int fs = 2;
        while (sze.height < height) 
        {
            f = [UIFont fontWithName:fntName size:fs];
            sze = [str sizeWithFont:f];
            fs = fs + 1;
        }
        tmp[iFntIndex] = fs;
        //NSLog(@"Calculated Font At Index %d Size As %d",iFntIndex,fs);
    }
    
    for(iFntIndex = 0; iFntIndex < _sysFonts.count; iFntIndex++)
    {
        NSString *fntName = [NSString stringWithFormat:@"%@",[_sysFonts objectAtIndex:iFntIndex]];
        UIFont *f = [UIFont fontWithName:fntName size:1.0];
        CGSize sze = [str sizeWithFont:f];
        int fs = 2;
        while (sze.height < height) 
        {
            f = [UIFont fontWithName:fntName size:fs];
            sze = [str sizeWithFont:f];
            fs = fs + 1;
        }
        tmp[iFntIndex+FONT_COUNT] = fs;
        //NSLog(@"Calculated Font At Index %d Size As %d",iFntIndex,fs);
    }
    
    *adj = tmp;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        self.showsSelectionIndicator = YES;
#ifdef AUTOFONT        
        _sysFonts = nil;
        displaySize = NULL;
        adjustedSize = NULL;
        [self printAllSystemFonts];
        [self calcFontSizesToHeight:30.0 into:&adjustedSize];
        //[self calcFontSizesToHeight:20.0 into:&displaySize];
#endif      
        
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
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return (FONT_COUNT + _sysFonts.count);
    }
    
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(component == 0)
    {
        return (self.frame.size.width * 0.57f);
    }
    
    return (self.frame.size.width * 0.3f);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *fntName = [self fontNameAtIndex:[pickerView selectedRowInComponent:0]];
    NSLog(@"Adjusted Size %d",adjustedSize[row]);
#ifdef AUTOFONT    
    
    UIFont *f = [UIFont fontWithName:fntName size:adjustedSize[[pickerView selectedRowInComponent:0]]];
    
    [pickerDelegate fontChangedTo:f];
#else
    float fntSize = fontsizes[[pickerView selectedRowInComponent:1]];
    UIFont *fnt = [UIFont fontWithName:fntName size:fntSize];
    
    [pickerDelegate fontChangedTo:fnt];
#endif
    return;
}

-(NSString*)fontNameAtIndex:(NSInteger)row
{
    if(row < FONT_COUNT)
    {
        return [NSString stringWithFormat:@"%s",fontnames[row]];
    }

    int index = row - FONT_COUNT;
    
    return [NSString stringWithFormat:@"%@",[_sysFonts objectAtIndex:index]];
}

-(UIFont*)fontAtIndex:(NSInteger)row
{
    //
#ifdef AUTOFONT     
    UIFont *font = [UIFont fontWithName:[self fontNameAtIndex:row] size:adjustedSize[row]];
#else
    UIFont *font = [UIFont fontWithName:[self fontNameAtIndex:row] size:15.0];
#endif
    return font;
}

-(UIFont*)fontAtIndex:(NSInteger)row ofSize:(float)sze
{
    //
#ifdef AUTOFONT    
    UIFont *font = [UIFont fontWithName:[self fontNameAtIndex:row] size:sze];
#else
    UIFont *font = [UIFont fontWithName:[self fontNameAtIndex:row] size:15.0];
#endif
    return font;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = nil;
    
    if(component == 0)
    {
        float fntSize = adjustedSize[row] * (2.0f/3.0f);
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
