//
//  Resolution.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 10/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "Resolution.h"
//#import "ViewController.h"

@implementation Resolution
@synthesize size;
@synthesize delegateController;
//@synthesize resolutionMode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = NSLocalizedString(@"Resolution",@"Resolution");
        
        nvm = [Settings Instance];
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            //self.contentSizeForViewInPopover
            self.preferredContentSize = CGSizeMake(IPAD_POPOVER_WIDTH, IPAD_POPOVER_HEIGHT);
        }
    }
    
    return self;
}

- (void)dealloc
{
 //   [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section)
    {
        case RESOLUTION_SECTION_HIGH:
        {
            rows = 2;
            break;
        }
        case RESOLUTION_SECTION_MEADIUM:
        {
            rows = 3;
            break;
        }
        case RESOLUTION_SECTION_LOW:
        {
            rows = 3;
            break;
        }
        default:
        {
            break;
        }
    }
    
    // Return the number of rows in the section.
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case RESOLUTION_SECTION_HIGH:
        {
            return NSLocalizedString(@"HQUALITY",@"High Quality");
        }
        case RESOLUTION_SECTION_MEADIUM:
        {
            return NSLocalizedString(@"MQUALITY",@"Meadium Quality");
        }
        case RESOLUTION_SECTION_LOW:
        {
            return NSLocalizedString(@"LQUALITY",@"Low Quality");
        }
        default:
        {
            break;
        }
    }

    return nil;
}

-(eResolutionType)indexPathToResolutionType:(NSIndexPath*)indexPath
{
    switch(indexPath.section)
    {
        case RESOLUTION_SECTION_HIGH:
        {
            if(indexPath.row == 0)
            {
                return RESOLUTION_PIXCOUNT_HIGH0;
            }
            else
            {
                return RESOLUTION_PIXCOUNT_HIGH1;
            }
            break;
        }
        case RESOLUTION_SECTION_MEADIUM:
        {
            if(indexPath.row == 0)
            {
                return RESOLUTION_PIXCOUNT_MED0;
            }
            else if(indexPath.row == 1)
            {
                return RESOLUTION_PIXCOUNT_MED1;
            }
            else
            {
                return RESOLUTION_PIXCOUNT_MED2;
            }
            
            break;
        }
        case RESOLUTION_SECTION_LOW:
        {
            if(indexPath.row == 0)
            {
                return RESOLUTION_PIXCOUNT_LOW0;
            }
            else if(indexPath.row == 1)
            {
                return RESOLUTION_PIXCOUNT_LOW1;
            }
            else
            {
                return RESOLUTION_PIXCOUNT_LOW2;
            }
            
            break;
        }
    }
    
    return RESOLUTION_PIXCOUNT_MAX;
}

-(CGSize)indexPathToSize:(NSIndexPath*)indexPath
{
    eResolutionType eType = [self indexPathToResolutionType:indexPath];
    
    NSLog(@"indexPathToSize: %d",eType);
    
    return [nvm getTheSizeForResolution:eType];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CGSize sze = [self indexPathToSize:indexPath];
    int width  = sze.width;
    int height = sze.height;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];// autorelease];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //UITextAlignmentCenter;
    
    switch(indexPath.section)
    {
        case RESOLUTION_SECTION_HIGH:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d X %d",NSLocalizedString(@"HIGH",@"High"),width,height];
            break;
        }
        case RESOLUTION_SECTION_MEADIUM:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d X %d",NSLocalizedString(@"MEDIUM",@"Medium"),width,height];
            break;
        }
        case RESOLUTION_SECTION_LOW:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d X %d",NSLocalizedString(@"LOW",@"Low"),width,height];
            break;
        }
    }
  
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    nvm.uploadResolution = [self indexPathToResolutionType:indexPath];
//    ViewController *controller = nil;
//    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//    {
//        controller = (ViewController*)delegateController;
//    }
//    else
//    {
//        NSArray *viewControllers = self.navigationController.viewControllers;
//        controller = (ViewController*)[viewControllers objectAtIndex:0];
//    }
    
//    [controller uploadSelected];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

    return;
}

@end
