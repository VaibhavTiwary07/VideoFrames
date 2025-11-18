//
//  FrameGridController.m
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 3/18/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "FrameGridController.h"

@implementation FrameGridController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *v = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    v.userInteractionEnabled = YES;
    [self.view addSubview:v];
    [v release];
    
    FrameGridView *grd = [[FrameGridView alloc]initWithFrame:CGRectMake(0, 100, 300, 300)];
    grd.filePrefix = FILENAME_PATTERN_PREFIX;
    grd.userInteractionEnabled = YES;
    grd.totalItemsCount = 40;
    [grd setRowCount:2 colCount:3];
    grd.tag = TAG_PATTERNPICKER;
    grd.delegate = self;
    self.view.userInteractionEnabled = YES;
    
    [self.view addSubview:grd];
    
    [grd release];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan in FrameGridController");
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
