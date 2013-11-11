//
//  BackgroundManager.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 8/30/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "BackgroundManager.h"
//#import "Color_SplurgeViewController.h"

@implementation BackgroundManager

@synthesize actionDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.contentSizeForViewInPopover = CGSizeMake(IPAD_POPOVER_WIDTH, IPAD_POPOVER_HEIGHT);
        }
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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

#pragma mark background selection optios

-(void)imageSelected:(UIImage *)img result:(NSString*)res
{
    if(nil != img)
    {
        NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:img forKey:@"backgroundImageSelected"];
        [[NSNotificationCenter defaultCenter] postNotificationName:backgroundImageSelected object:nil userInfo:usrInfo];
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
    else
    {
        if(nil != res)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FAILED",@"Failed") message:res delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
}

#pragma mark Background selection delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo
{
    /* Dismiss the controller */
    [picker dismissModalViewControllerAnimated:NO];
    
    /* Image selected */
    [self imageSelected:selectedImage result:nil];
    
	return;
}

-(IBAction)handlePhotoAlbum:(id)sender
{	
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) 
	{ 
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:openIpadPhotoAlbum object:nil userInfo:nil];
            return;
        }
        
		/* Allocate the picker view */
		UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
		
		/* Set the source type */
		imgPicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary; 
		
		/* Do not allow editing */
		imgPicker.allowsEditing = NO; 
		
		/* Set th delegate for the picker view */
		imgPicker.delegate = self;
		
		/* Set the model transition style */
		imgPicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            NSLog(@"iPad Photo Album");           
            if(self.view.window != nil)
            {
                UIPopoverController *pPopOver = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
                
                pPopOver.delegate = self;
                
                UITableView *pbut = (UITableView*)sender;
                
                [pPopOver presentPopoverFromRect:[[UIScreen mainScreen]bounds] inView:pbut permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
                //[pPopOver release];
            }
        }
        else
        {
            [self presentModalViewController:imgPicker animated:YES]; 
        }
        
		/* Release the image picker */
		[imgPicker release];
	}
	else
	{
		UIAlertView *pickerAlert;
		
		pickerAlert = [[UIAlertView alloc] initWithTitle:@"Photo Library" message:@"Photo Library is not available to pick the background!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		
		/* Show the alert */
		[pickerAlert show];
		
		/* Release the alert */
		[pickerAlert release];
	}
	
	[localPool release];
	
	return;
}

-(IBAction)handleCamera:(id)sender
{
	NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{ 
		/* Allocate the picker view */
		UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
		
		/* Set the source type */
		imgPicker.sourceType    = UIImagePickerControllerSourceTypeCamera; 
		
		/* Do not allow editing */
		imgPicker.allowsEditing = NO; 
		
		/* Set th delegate for the picker view */
		imgPicker.delegate = self;
		
		/* Set the model transition style */
		imgPicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        /* present the picker */
		[self presentModalViewController:imgPicker animated:YES]; 
		
		/* Release the image picker */
		[imgPicker release];
	}
    
	[localPool release];
	
	return;
}

-(void)handleFacebookAlbum:(id)sender
{
    if(NO == nvm.connectedToInternet)
    {
        //UIAlertView *alview = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Failed",nil) message:@"No active internet connection to connect to Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FAILED",@"Failed") message:NSLocalizedString(@"NOINTERNET",@"No active internet connection to connect") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
        [alview show];
        [alview release];
        return;
    }
    
    FacebookAlbumList *plist = [[FacebookAlbumList alloc]initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:plist animated:YES];

    [plist release];
}

-(void)handleProfilePhoto:(id)sender
{
    if(NO == nvm.connectedToInternet)
    {
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FAILED",nil) message:NSLocalizedString(@"NOINTERNET",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
        [alview show];
        [alview release];
        return;
    }
    
    return;
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
    UIImage *img = nil;
    NSString *imgName = nil;
    NSString *imgType = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font        = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.font  = [UIFont systemFontOfSize:10.0];
    switch(indexPath.row)
    {
        case 0:
        {
            imgName = @"album";
            imgType = @"png";
            cell.textLabel.text = NSLocalizedString(@"PHOTOALBUM",@"Photo Albums");
            cell.detailTextLabel.text = NSLocalizedString(@"PHOTOALBUMCAP",@"your local photo album");
            break;
        }
        case 1:
        {
            imgName = @"profilephoto";
            imgType = @"png";
            cell.textLabel.text = NSLocalizedString(@"FBPROFILEPHOTO",@"Facebook Profile Photo");
            cell.detailTextLabel.text = NSLocalizedString(@"FBPROFILEPHOTOCAP",@"your Facebook profile photo");
            break;
        }
        case 2:
        {
            imgName = @"facebook";
            imgType = @"png";
            cell.textLabel.text = NSLocalizedString(@"FBALBUM", @"Facebook Albums");
            cell.detailTextLabel.text = NSLocalizedString(@"FBALBUMBG_CAP", @"your Facebook albums");
            break;
        }
        case 3:
        {
            imgName = @"camera";
            imgType = @"png";
            cell.textLabel.text = NSLocalizedString(@"CAMERA",@"Camera");
            cell.detailTextLabel.text = NSLocalizedString(@"CAMERA_CAP",@"Take live photo using Camera");;
            break;
        }
        case 4:
        {
            imgName = @"copytoclipboard";
            imgType = @"png";
            cell.textLabel.text = NSLocalizedString(@"PASTEFROMPB",@"Paste From Pasteboard");
            cell.detailTextLabel.text = NSLocalizedString(@"PASTEFROMPB_CAP",@"Paste your copied image");
            break;
        }
    }
    
    /* Now load the image */
    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:imgType]];
    
    /* Set the image as table row image */
    if(nil != img)
    {
        cell.imageView.image = [img thumbnailImage:60 transparentBorder:2 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"BGHEADER",@"Select Background Image");
}


-(void)exitApplist
{
	[self dismissModalViewControllerAnimated:NO];
    
	return;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	
    self.title = NSLocalizedString(@"IMAGE", @"Image");
    
    nvm = [Settings Instance];
	//UIBarButtonItem *backButton;
	
	//backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(exitApplist)];
	//backButton.style =  UIBarButtonItemStyleBordered;
    //self.navigationItem.leftBarButtonItem = backButton;
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

-(void)handleClipboard:(id)sender
{
    UIImage *img = [UIPasteboard generalPasteboard].image;
    
    if(nil != img)
    {
        [self imageSelected:img result:nil];
    }
    else
    {
        //UIAlertView *alview = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"No image present in the paste board to paste" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FAILED",nil)  message:NSLocalizedString(@"PASTEBOARD_EMPTY",@"No image present in the paste board to paste") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alview show];
        [alview release];
    }
    
    return;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch(indexPath.row)
    {
        case 0:
        {
            [self handlePhotoAlbum:tableView];
            break;
        }
        case 1:
        {
            [self handleProfilePhoto:self];
            break;
        }
        case 2:
        {
            [self handleFacebookAlbum:self];
            break;
        }
        case 3:
        {
            [self handleCamera:self];
            break;
        }
        case 4:
        {
            [self handleClipboard:self];
            break;
        }
    }
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    return;
}

@end
