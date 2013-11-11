//
//  ColorPickerView.m
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 8/29/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "ColorPickerView.h"

@interface ColorPickerView()
{
    NSMutableArray *colors;
}
@end

@implementation ColorPickerView

@synthesize del;

-(NSArray*)colors
{
    if(nil == colors)
    {
        colors = [[NSMutableArray alloc]initWithObjects:[UIColor blackColor], [UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor whiteColor],[UIColor grayColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor],nil];
        NSLog(@"ColorPickerView: initWithFrame color count %d",[colors count]);
    }
    
    return colors;
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
        
        /* set the selected index */
        [self selectRow:0 inComponent:0 animated:YES];
    }
    return self;
}

-(void)dealloc
{
    [colors release];
    colors = nil;
    
    [super dealloc];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"Colors";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"ColorPickerView: Color Count %d",[colors count]);
    return [[self colors] count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [del colorPickerViewDidChangeSelection:[[self colors]objectAtIndex:row]];
    
    return;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *lbl = nil;
    
    UIColor *clr = (UIColor*)[[self colors] objectAtIndex:row];
    NSLog(@"Forming Row %d+++++++++++++++++++++++%d",row,row);
    if(nil == view)
    {
        lbl = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 36.0, 30.0)];
    }
    else 
    {
        lbl = view;
    }
    
    lbl.backgroundColor = clr;

    
    return lbl;
}

@end
