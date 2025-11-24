//
//  UploadManager.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 8/31/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "UploadManager.h"
//#import "ViewController.h"

@implementation UploadManager

@synthesize delegateController;

#pragma mark standard initialization
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        //self.title = @"Share";
        self.title = NSLocalizedString(@"SHARE",@"Share");
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack; //UIBarStyleBlackOpaque;
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
   // [super dealloc];
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
    printf("--- UploadManager.m: viewDidLoad ---\n");
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
    
    self.navigationController.navigationBarHidden = NO;
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

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell           = nil;
    NSString        *imgName        = nil;
    NSString        *imgType        = nil;
    UIImage         *img            = nil;
    NSInteger        section        = indexPath.section;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];// autorelease];
    }
    
    cell.textLabel.font        = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.font  = [UIFont systemFontOfSize:10.0];
    cell.accessoryType         = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (section)
    {
        case UPLOAD_SECTION_INSTAGRAM:
        {
            switch(indexPath.row)
            {
                case UPLOAD_PRODUCT_INSTAGRAM:
                {
                    imgName = @"Instagram-icon";
                    imgType = @"png";
                    //cell.textLabel.text = @"Personalized Items";
                    //cell.detailTextLabel.text = @"T-shirts, Phone Case, Key chains, Tea mugs";
                    cell.textLabel.text = @"Instagram";
                    cell.detailTextLabel.text = @"Share To Instagram";
                    cell.tag = RESOLUTION_PIXCOUNT_HIGH0;
                    break;
                }
                case UPLOAD_PRODUCT_MAX:
                default:
                {
                    break;
                }
            }
            break;
        }
        case UPLOAD_SECTION_ACTIONS:
        {
            switch(indexPath.row)
            {
                case UPLOAD_ACTION_SAVE:
                {
                    imgName = @"album";
                    imgType = @"png";
                    //cell.textLabel.text = @"Save To Photo Album";
                    //cell.detailTextLabel.text = @"Save to local photo album";
                    cell.textLabel.text = NSLocalizedString(@"SAVETOALBUM", @"Save To Photo Album");
                    cell.detailTextLabel.text = NSLocalizedString(@"SAVETOALBUM_CAP", @"Save to local photo album");
                    cell.tag = RESOLUTION_PIXCOUNT_HIGH0;
                    break;
                }
                case UPLOAD_ACTION_EMAIL:
                {
                    imgName = @"mailicon";
                    imgType = @"png";
                    //cell.textLabel.text = @"Email";
                    //cell.detailTextLabel.text = @"Email to your loved ones";
                    cell.textLabel.text = NSLocalizedString(@"EMAIL",@"Email");
                    cell.detailTextLabel.text = NSLocalizedString(@"EMAIL_CAP",@"Email to your loved ones");
                    cell.tag = RESOLUTION_PIXCOUNT_HIGH0;
                    break;
                }
                case UPLOAD_ACTION_COPY:
                {
                    imgName = @"copytoclipboard";
                    imgType = @"png";
                    //cell.textLabel.text = @"Copy To Clipboard";
                    //cell.detailTextLabel.text = @"Copies the current session to Clipboard";
                    cell.textLabel.text = NSLocalizedString(@"COPYTOCB", @"Copy To Clipboard");
                    cell.detailTextLabel.text = NSLocalizedString(@"COPYTOCB_CAP", @"Copies the current session to Clipboard");;
                    cell.tag = RESOLUTION_PIXCOUNT_HIGH1;
                    break;
                }
                case UPLOAD_ACTION_MAX:
                default:
                {
                    break;
                }
            }
            break;
        }
        case UPLOAD_SECTION_SERVICES:
        {
            switch (indexPath.row) 
            {
                case UPLOAD_SERVICE_FACEBOOKWALL:
                {
                    imgName = @"fbglobalwall";
                    imgType = @"png";
                    //cell.textLabel.text = @"Facebook Wall";
                    //cell.detailTextLabel.text = @"Post on to your facebook wall";
                    cell.textLabel.text = NSLocalizedString(@"FBWALL", @"Facebook Wall");
                    cell.detailTextLabel.text = NSLocalizedString(@"FBWALL_CAP", @"Post on to your facebook wall");
                    cell.tag = RESOLUTION_PIXCOUNT_LOW2;
                    break;
                }
                case UPLOAD_SERVICE_FACEBOOK:
                {
                    imgName = @"facebook";
                    imgType = @"png";
                    //cell.textLabel.text = @"Facebook Albums";
                    //cell.detailTextLabel.text = @"Upload to Facebook albums";
                    cell.textLabel.text = NSLocalizedString(@"FBALBUM", @"Facebook Albums");
                    cell.detailTextLabel.text = NSLocalizedString(@"FBALBUM_CAP", @"Upload to Facebook albums");
                    cell.tag = RESOLUTION_PIXCOUNT_LOW0;
                    break;
                }
#if 0                    
                case UPLOAD_SERVICE_TWITTER:
                {
                    imgName = @"twitpic";
                    imgType = @"png";
                    cell.textLabel.text = @"Twitpic";
                    cell.detailTextLabel.text = @"Tweet to your followers";
                    cell.tag = RESOLUTION_PIXCOUNT_LOW0;
                    break;
                }
#endif                    
                case UPLOAD_SERVICE_MAX:
                default:
                    break;
            }
        }
        case UPLOAD_SECTION_MAX:
        default:
        {
            break;
        }
    }

    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:imgType]];
    if(nil != img)
    {
        cell.imageView.image = [img thumbnailImage:60 transparentBorder:2 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /* Don't show when we can't ship */
    return UPLOAD_SECTION_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;
    
    switch (section) 
    {
        case UPLOAD_SECTION_INSTAGRAM:
        {
            rowCount = 1;
            break;
        }
        case UPLOAD_SECTION_ACTIONS:
        {
            rowCount = 3;
            break;
        }
        case UPLOAD_SECTION_SERVICES:
        {
            rowCount = 1;
            break;
        }
        case UPLOAD_SECTION_MAX:
        default:
            break;
    }
    
    return rowCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) 
    {
        case UPLOAD_SECTION_INSTAGRAM:
        {
            //return @"Products";
            return @"Instagram";//NSLocalizedString(@"PRODUCTS", @"Products");
        }
        case UPLOAD_SECTION_ACTIONS:
        {
            //return @"Actions";
            return NSLocalizedString(@"ACTIONS", @"Actions");
        }
        case UPLOAD_SECTION_SERVICES:
        {
            //return @"Social Networks";
            NSLocalizedString(@"SOCIALNET", @"Social Networks");
        }
        case UPLOAD_SECTION_MAX:
        default:
        {
            break;
        }
    }
    
    return nil;
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

-(eUPLOAD_CMD)indexPathToUploadCommand:(NSIndexPath*)indexPath
{
    eUPLOAD_CMD uploadCommand = SEND_TO_INSTAGRAM;
    NSInteger   section = indexPath.section;
    
    if(section == UPLOAD_SECTION_SERVICES)
    {
        if(indexPath.row == UPLOAD_SERVICE_FACEBOOK)
        {
            uploadCommand = UPLOAD_FACEBOOK_ALBUM;
        }
        //else if(indexPath.row == UPLOAD_SERVICE_FACEBOOKWALL)
        //{
        //    uploadCommand = UPLOAD_FACEBOOK_GLOBAL;
        //}
#if 0        
        else if(indexPath.row == UPLOAD_SERVICE_TWITTER)
        {
            uploadCommand = UPLOAD_TWITTER;
        }
#endif        
    }
    else if(section == UPLOAD_SECTION_ACTIONS)
    {
        if(indexPath.row == UPLOAD_ACTION_COPY)
        {
            uploadCommand = UPLOAD_CLIPBOARD;
        }
        else if(indexPath.row == UPLOAD_ACTION_EMAIL)
        {
            uploadCommand = UPLOAD_EMAIL;
        }
        else if(indexPath.row == UPLOAD_ACTION_SAVE)
        {
            uploadCommand = UPLOAD_PHOTO_ALBUM;
        }
    }
    else if(section == UPLOAD_SECTION_INSTAGRAM)
    {
        if(indexPath.row == UPLOAD_PRODUCT_INSTAGRAM)
        {
            uploadCommand = SEND_TO_INSTAGRAM;
        }
    }
    
    return uploadCommand;
}
#if 0
-(void)logUploadForCommand:(eUPLOAD_CMD)eCmd
{
    [Flurry logEvent:@"Uploads"];
    switch(eCmd)
    {
        case UPLOAD_CLIPBOARD:
        {
            [Flurry logEvent:@"Upload To Clipboard"];
            break;
        }
        case UPLOAD_EMAIL:
        {
            [Flurry logEvent:@"Upload To Email"];
            break;
        }
        case UPLOAD_FACEBOOK_ALBUM:
        {
            [Flurry logEvent:@"Upload To Facebook album"];
            break;
        }
        case UPLOAD_PHOTO_ALBUM:
        {
            [Flurry logEvent:@"Upload To Photo album"];
            break;
        }
        //case UPLOAD_FACEBOOK_GLOBAL:
        //{
        //    [Flurry logEvent:@"Upload To Facebook wall"];
        //    break;
        //}
        case UPLOAD_TWITTER:
        {
            [Flurry logEvent:@"Upload To Twitter"];
            break;
        }
        case SEND_TO_INSTAGRAM:
        {
            [Flurry logEvent:@"Upload To Instagram"];
            break;
        }
        case UPLOAD_MAX:
        default:
        {
            break;
        }
    }
}
#endif
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    /* first deselect the row */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(NO == nvm.connectedToInternet)
    {
        if(section == UPLOAD_SECTION_SERVICES)
        {
//            UIAlertView *alview = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FAILED",@"Failed") message:NSLocalizedString(@"NOINTERNET",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
//            [alview show];
          //  [alview release];
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"FAILED",@"Failed") message:NSLocalizedString(@"NOINTERNET",nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"OK") style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
          
            [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }

    nvm.uploadCommand = [self indexPathToUploadCommand:indexPath];
  //  [self logUploadForCommand:nvm.uploadCommand];
    
        //ViewController *controller = nil;
    if((section == UPLOAD_SECTION_ACTIONS)||((section == UPLOAD_SECTION_SERVICES)&&(indexPath.row != UPLOAD_SERVICE_FACEBOOKWALL)))
    {
        Resolution *res = [[Resolution alloc]initWithStyle:UITableViewStyleGrouped];
        res.delegateController = delegateController;
        [self.navigationController pushViewController:res animated:YES];
        
     //   [res release];
    }
    else
    {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        nvm.uploadResolution = cell.tag;
//        
//        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//        {
//            controller = (ViewController*)delegateController;
//        }
//        else
//        {
//            NSArray *viewControllers = self.navigationController.viewControllers;
//            controller = (ViewController*)[viewControllers objectAtIndex:0];
//        }
//        
//        [controller uploadSelected];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    return;
}

@end
