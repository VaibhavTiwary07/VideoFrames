//
//  FrameViewController.m
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 3/30/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "FrameViewController.h"

@implementation FrameViewController

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)dealloc
{
    UIImageView *img = (UIImageView*)[self.view viewWithTag:TAG_FRAMEGRID_CONTROLLER];
    if(nil != img)
    {
        [img removeFromSuperview];
    }
    
 //   [super dealloc];
}

-(void)frameSelectedAtIndex:(int)index ofGridView:(FrameGridView *)gView
{
    Settings *set = [Settings Instance];
    set.currentSessionIndex = set.nextFreeSessionIndex;
    set.currentFrameNumber = index;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:createNewSession object:nil];
    
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"frame view controller dismissed!");
    }];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[Utility generateThumnailsForFrames];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    imgView.image        = [UIImage imageWithContentsOfFile:[Utility documentDirectoryPathForFile:@"mainbackground.jpg"]];
    imgView.tag = TAG_FRAMEGRID_CONTROLLER;
    [self.view addSubview:imgView];
  //  [imgView release];
    
    self.view.userInteractionEnabled = YES;
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    float defWidth = rect.size.width - 20.0;
    float defHeight = rect.size.height - 100.0;
    float x = (rect.size.width - defWidth)/2.0;
    float y = (rect.size.height - defHeight)/2.0;
    FrameGridView *grd = [[FrameGridView alloc]initWithFrame:CGRectMake(x, y, defWidth, defHeight) indextag:TAG_EVENFRAME_GRIDVIEW];
    //grd.selectedItemIndex = 1;
    grd.filePrefix = FILENAME_FRAME_REGULAR_PREFIX;
    grd.userInteractionEnabled = YES;
    grd.totalItemsCount = FRAME_COUNT;
    [grd setRowCount:3 colCount:3];
    grd.tag = TAG_EVENFRAME_GRIDVIEW;
    grd.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:grd];
    //[grd release];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"Frames",@"Frames");

    // Navigation bar styling - matching FrameSelectionController
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.backgroundColor = [UIColor blackColor];
        appearance.shadowColor = nil;
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.compactAppearance = appearance;
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        self.navigationController.navigationBar.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    UIImageView *img = (UIImageView*)[self.view viewWithTag:TAG_FRAMEGRID_CONTROLLER];
    if(nil != img)
    {
        [img removeFromSuperview];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
