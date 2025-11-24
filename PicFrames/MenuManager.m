//
//  SessionManager.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 8/20/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "MenuManager.h"


@implementation MenuManager
//@synthesize snaphotDelegate;


-(void)doneWithMenuManager:(id)sender
{
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"menu manager View controller dismissed!");
    }];
    return;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        // Custom initialization
        
        //self.title = @"Menu";
        self.title = NSLocalizedString(@"MENU", @"Menu");
        self.navigationController.toolbarHidden = NO;
        
        nvm = [Settings Instance];
        
        UIBarButtonItem *itm = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                             target:self
                                                                             action:@selector(doneWithMenuManager:)];
        self.navigationItem.leftBarButtonItem = itm;
       // [itm release];
    }
    
    return self;
}

- (void)dealloc
{
  //  [super dealloc];
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
    printf("--- MenuManager.m: viewDidLoad ---\n");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self checkAndCreateDatabase];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark Snapshot
//-(void)sessionSelected:(Session *)sess
//{
//    [snaphotDelegate sessionSelected:sess];
//    
//    return;
//}

//-(UIImage*)getTheSnapshot
//{
//    return [snaphotDelegate getTheSnapshot];
//}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
#if SESSIONSUPPORT_ENABLE
    section = section;
#else
    section = section+1;
#endif
    switch(section)
    {
#if SESSIONSUPPORT_ENABLE
            /* This section is used to add the logout button for facebook */
        case 0:
        {
            //return @"Projects";
            return NSLocalizedString(@"PROJECTS", @"Projects");
        }
#endif
        case 1:
        {
            //return @"Like our Application";
            return NSLocalizedString(@"LIKEOURAPP", @"Like our Application");
        }
        case 2:
        {
            //return @"Login/Logout";
            return NSLocalizedString(@"LOGINOUT", @"Login/Logout");
        }
        default:
        {
            break;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //return 4;
#if SESSIONSUPPORT_ENABLE
    return 4;
#else
    return 3;
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#if SESSIONSUPPORT_ENABLE
    section = section;
#else
    section = section+1;
#endif
    
    NSInteger iRows = 0;
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch(section)
    {
#if SESSIONSUPPORT_ENABLE
        case 0:
        {
            iRows = 2;
            break;
        }
#endif
        case 1:
        {
            iRows = 2;
            break;
        }
        case 2:
        {
            iRows = 1;
            break;
        }    
        default:
        {
            iRows = 0;
            break;
        }
    }
    return iRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UIImage  *img = nil;
    NSString *imgName = nil;
    NSString *imgType = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];// autorelease];
    }
 
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.font          = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.font    = [UIFont systemFontOfSize:10.0];
    cell.accessoryType           = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    int section = (int)indexPath.section;
#if SESSIONSUPPORT_ENABLE
    section = section;
#else
    section = section+1;
#endif
    switch(section)
    {
#if SESSIONSUPPORT_ENABLE
        case 0:
        {
            switch(indexPath.row)
            {
                case 0:
                {
                    imgName = @"newsession";
                    imgType = @"png";
                    //cell.textLabel.text = @"Create New Project";
                    //cell.detailTextLabel.text = @"Creates new Project";
                    cell.textLabel.text = NSLocalizedString(@"NEWPROJECT", @"Create New Project");
                    cell.detailTextLabel.text = NSLocalizedString(@"NEWPROJECT_CAP", @"Creates new Project");
                    break;
                }
                case 1:
                {
                    imgName = @"savedsessions";
                    imgType = @"png";
                    //cell.textLabel.text = @"Saved Projects";
                    //cell.detailTextLabel.text = @"Load/Edit your saved Projects";
                    cell.textLabel.text = NSLocalizedString(@"SAVEDPROJECT",@"Saved Projects");
                    cell.detailTextLabel.text = NSLocalizedString(@"SAVEDPROJECT_CAP",@"Load/Edit your saved Projects");
                    break;
                }
                
                default:
                {
                    break;
                }
            }
            
            break;
        }
#endif
        case 1:
        {
            switch(indexPath.row)
            {
                case 0:
                {
                    imgName = @"rateus";
                    imgType = @"png";
                    //cell.textLabel.text = @"Rate Us";
                    //cell.detailTextLabel.text = @"Rate us in Appstore";
                    cell.textLabel.text = NSLocalizedString(@"RATEUS",@"Rate Us");
                    cell.detailTextLabel.text = NSLocalizedString(@"RATEUS_CAP",@"Rate us in Appstore");
                    break;
                }
                case 1:
                {
                    imgName = @"face_book";
                    imgType = @"png";
                    //cell.textLabel.text = @"Like Us";
                    //cell.detailTextLabel.text = @"Like our App's Facebook page";
                    cell.textLabel.text = NSLocalizedString(@"LIKEUS",@"Like Us");
                    cell.detailTextLabel.text = NSLocalizedString(@"LIKEUS_CAP",@"Like our App's Facebook page");
                    break;
                }
                case 2:
                {
                    break;
                }
            }
            break;
        }
        case 2:
        {
            if(nvm.facebookLogin)
            {
                //cell.textLabel.text = @"Log Out From Facebook";
                //cell.detailTextLabel.text = @"Logs out you from your facebook account";
                cell.textLabel.text = NSLocalizedString(@"FBLOGOUT",@"Log Out From Facebook");
                cell.detailTextLabel.text = NSLocalizedString(@"FBLOGOUT_CAP",@"Logs out you from your facebook account");
            }
            else
            {
                //cell.textLabel.text = @"Login to facebook";
                //cell.detailTextLabel.text = @"Login to your facebook account";
                cell.textLabel.text = NSLocalizedString(@"FBLOGIN",@"Login to facebook");
                cell.detailTextLabel.text = NSLocalizedString(@"FBLOGIN_CAP",@"Login to your facebook account");
            }
            
            imgName = @"fblogout";
            imgType = @"png";
            break;
        }
        default:
        {
            break;
        }
    }
    
    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:imgType]];
    if(nil != img)
    {
        cell.imageView.image = [img thumbnailImage:60 transparentBorder:2 cornerRadius:9 interpolationQuality:kCGInterpolationHigh];
        
        cell.imageView.clipsToBounds = NO;
        cell.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.imageView.layer.shadowOffset = CGSizeMake(1, 1);
        cell.imageView.layer.shadowOpacity = 1;
        cell.imageView.layer.shadowRadius = 1.0;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section = (int)indexPath.section;
    
#if SESSIONSUPPORT_ENABLE
    section = section;
#else
    section = section + 1;
#endif
    
    switch(section)
    {
#if SESSIONSUPPORT_ENABLE
        case 0:
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    /* this piece of code was creating empty sessions on opening frame
                     viewcontroller though user didn't select any session */
                    //Settings *set = [Settings Instance];
                    //set.currentSessionIndex = set.nextFreeSessionIndex;
#if defined(APP_INSTAPICFRAMES)
                    FrameViewController *fvc = [FrameViewController alloc];
#elif defined(APP_PICCELLS)
                    FrameSelectionController *fvc = [FrameSelectionController alloc];
#endif
                    [self.navigationController pushViewController:fvc animated:YES];
                    
                    [fvc release];
                    break;
                }
                case 1:
                {
                    SessionManager *sm = [[SessionManager alloc]initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:sm animated:YES];
                    [sm release];
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                    
                    break;
                }
                default:
                {
                    break;
                }
            }
            
            break;
        }
#endif
        case 1:
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    [Appirater rateApp];
                    break;
                }
                case 1:
                {
                    if(NO == nvm.connectedToInternet)
                    {
                        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"FAILED", nil) message:NSLocalizedString(@"NOINTERNET",nil) preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:cancelAction];
                      
                        [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                        return;
                    }
                    else
                    {
                        //FBLikeUsController *likeus = [FBLikeUsController alloc];
                        //[self.navigationController pushViewController:likeus animated:YES];
                        //[likeus release];
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            
            break;
        }
        case 2:
        {
            /*
            fbmgr *mg = [fbmgr Instance];
            mg.fbDelegate = self;
            if(nvm.facebookLogin)
            {
                [mg logout];
            }
            else
            {
                [mg login];
            }
             */
        }
        default:
        {
            break;
        }
    }
}

-(void)loginStatus:(BOOL)isSuccess
{
    [self.tableView reloadData];
}

@end
