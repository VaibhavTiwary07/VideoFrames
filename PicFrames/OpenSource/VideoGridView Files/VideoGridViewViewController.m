//
//  VideoGridViewViewController.m
//  AlterButton
//
//  Created by Deepti's Mac on 1/8/14.
//  Copyright (c) 2014 D.Yoganjulu  Reddy. All rights reserved.
//

#import "VideoGridViewViewController.h"
#import "GMGridView.h"
#import "OptionsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Config.h"

#define NUMBER_ITEMS_ON_LOAD 16
#define NUMBER_ITEMS_ON_LOAD2 30
#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#pragma mark -
#pragma mark ViewController (privates methods)
@interface VideoGridViewViewController () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSMutableArray *_data;
    NSMutableArray *_data2;
    __gm_weak NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
    UIInterfaceOrientation orientation;
}

//- (void)addMoreItem;
//- (void)removeItem;
//- (void)refreshItem;
//- (void)presentInfo;
- (void)presentOptions:(UIBarButtonItem *)barButton;
- (void)optionsDoneAction;
- (void)dataSetChange:(UISegmentedControl *)control;

@end

@implementation VideoGridViewViewController
@synthesize imageArray;
@synthesize frameOfView;
@synthesize totalNumberOfItems;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}
- (void)loadView
{
    
    _data = [[NSMutableArray alloc] init];
    

    for (int index = 0; index < [imageArray count]; index ++)
    {
        UIImage *image = [imageArray objectAtIndex:index ];
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:image,@"imageForItem",[NSNumber numberWithInt:index],@"index", nil];
        
        //  [_data addObject:[NSString stringWithFormat:@"%d", i]];
        [_data addObject:dataDictionary];
    }
    
    _currentData = _data;

    [super loadView];
  
    self . view .frame = frameOfView;
    self. view .userInteractionEnabled = YES;
    self.view.backgroundColor = DARK_GRAY_BG;
    NSInteger spacing = INTERFACE_IS_PHONE ? 20 : 15;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0, frameOfView.size.width, frameOfView.size.height)];
    gmGridView .layer . masksToBounds = YES;
    //gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(self.view.bounds.size.width - 40,
                                  self.view.bounds.size.height - 40,
                                  40,
                                  40);
    infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
    // [self.view addSubview:infoButton];
    
    UISegmentedControl *dataSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"DataSet 1", @"DataSet 2", nil]];
    [dataSegmentedControl sizeToFit];
    dataSegmentedControl.frame = CGRectMake(5,
                                            self.view.bounds.size.height - dataSegmentedControl.bounds.size.height - 5,
                                            dataSegmentedControl.bounds.size.width,
                                            dataSegmentedControl.bounds.size.height);
    dataSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    dataSegmentedControl.tintColor = [UIColor greenColor];
    dataSegmentedControl.selectedSegmentIndex = 0;
    [dataSegmentedControl addTarget:self action:@selector(dataSetChange:) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:dataSegmentedControl];
    
    
    OptionsViewController *optionsController = [[OptionsViewController alloc] init];
    optionsController.gridView = gmGridView;
    optionsController.preferredContentSize = CGSizeMake(400, 500);//contentSizeForViewInPopover
    
    _optionsNav = [[UINavigationController alloc] initWithRootViewController:optionsController];
    
    if (INTERFACE_IS_PHONE)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(optionsDoneAction)];
        optionsController.navigationItem.rightBarButtonItem = doneButton;
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    printf("--- VideoGridViewViewController.m: viewDidLoad ---\n");
    UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.anyObject;
     orientation = windowScene.interfaceOrientation;
     _gmGridView.mainSuperView = self.navigationController.view;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE)
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(70, 70);
        }
        else
        {
            return CGSizeMake(70, 70);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(285, 205);
        }
        else
        {
            return CGSizeMake(120, 120);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    NSLog(@"Creating view indx %ld", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:orientation];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    cell.contentView . tag = index;
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.tag = index;
        //view.backgroundColor = [UIColor redColor];
        view.layer.masksToBounds = YES;
       // view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableDictionary *dictionary = [_currentData objectAtIndex:index];
    UIImage *imageForItem = [dictionary objectForKey:@"imageForItem"];
    NSNumber *indexNumber = [dictionary objectForKey:@"index"];
    NSString *str = [NSString stringWithFormat:@"%d",[indexNumber intValue]+1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView . autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView . image = imageForItem;
    imageView . layer . borderColor = [UIColor whiteColor].CGColor;
    imageView . layer . borderWidth = 4.0;
    [cell.contentView addSubview:imageView];
    [cell.contentView bringSubviewToFront:imageView];
   
    UIImageView *numberimageView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width- gridCornerSticker_size, size.width- gridCornerSticker_size, gridCornerSticker_size, gridCornerSticker_size)];
    numberimageView. image = [UIImage imageNamed:@"cornerSticker.png"];
    [imageView addSubview:numberimageView ];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(size.width-gridCornerSticker_label_size, size.width-gridCornerSticker_label_size,gridCornerSticker_label_size, gridCornerSticker_label_size)];
    label . text = str;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
   // label . layer . cornerRadius = 15.0;
    label.textColor = [UIColor blackColor];
  //  label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:gridCornerSticker_font];
    [imageView addSubview:label];

    // Add Pro Badge image from assets in top-right corner
    CGFloat proBadgeWidth = 55;
    CGFloat proBadgeHeight = 32;
    UIImageView *proBadgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width - proBadgeWidth - 5, 5, proBadgeWidth, proBadgeHeight)];
    proBadgeImageView.image = [UIImage imageNamed:@"ProBadge"];
    proBadgeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView addSubview:proBadgeImageView];
    [imageView bringSubviewToFront:proBadgeImageView];

    [cell.contentView setNeedsDisplay];

    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %ld", position);
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
//    
//    [alert show];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    // Create the second action
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Delete selected");
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    _lastDeleteItemIndexAsked = index;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
//        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
//    }
//}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                         [self getOrderOfItem];
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    if (newIndex >= 0 && newIndex <= _currentData.count) {
        NSObject *object = [_currentData objectAtIndex:oldIndex];
        [_currentData removeObject:object];
        [_currentData insertObject:object atIndex:newIndex];    } else {
        NSLog(@"❌ Invalid index %ld for array with count %lu", (long)index, (unsigned long)_currentData.count);
    }
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    NSLog(@"exchange Item At Index video grid view controller");
    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE)
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(320, 210);
        }
        else
        {
            return CGSizeMake(300, 310);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(700, 530);
        }
        else
        {
            return CGSizeMake(600, 500);
        }
    }
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:orientation];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %ld", index];
    label.textAlignment = NSTextAlignmentCenter; //UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (INTERFACE_IS_PHONE)
    {
        label.font = [UIFont boldSystemFontOfSize:15];
    }
    else
    {
        label.font = [UIFont boldSystemFontOfSize:20];
    }
    
    [fullView addSubview:label];
    
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor greenColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}

//////////////////////////////////////////////////////////////
#pragma mark private methods
//////////////////////////////////////////////////////////////



- (void)dataSetChange:(UISegmentedControl *)control
{
    _currentData = ([control selectedSegmentIndex] == 0) ? _data : _data2;
    
    [_gmGridView reloadData];
}

- (void)presentOptions:(UIBarButtonItem *)barButton
{
    if (INTERFACE_IS_PHONE)
    {
//        [self presentModalViewController:_optionsNav animated:YES];
        [self presentViewController:_optionsNav animated:YES completion:nil];
    }
    else
    {
        if(![_optionsPopOver isPopoverVisible])
        {
            if (!_optionsPopOver)
            {
                _optionsPopOver = [[UIPopoverController alloc] initWithContentViewController:_optionsNav];
            }
            
            [_optionsPopOver presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self optionsDoneAction];
        }
    }
}

- (void)optionsDoneAction
{
    if (INTERFACE_IS_PHONE)
    {
        //[self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"View controller dismissed!");
        }];

    }
    else
    {
        [_optionsPopOver dismissPopoverAnimated:YES];
    }
}
-(NSMutableArray *)getOrderOfItem
{
    NSMutableArray *orderArray = [[NSMutableArray alloc] init];
    
    for (int index = 0; index<[_currentData count]; index++)
    {
        NSDictionary *dict = [_currentData objectAtIndex:index];
        NSNumber *indexNumber = [dict objectForKey:@"index"];
        [orderArray addObject:indexNumber];
    }
    return orderArray;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
