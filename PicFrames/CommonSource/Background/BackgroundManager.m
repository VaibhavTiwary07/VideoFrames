//
//  BackgroundManager.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 8/30/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "BackgroundManager.h"
#import "Color_SplurgeViewController.h"

@implementation BackgroundManager

//@synthesize actionDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

//- (void)viewDidLoad
//{
//    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark background selection optios
- (void)photoUploadStatus:(BOOL)isUploaded result:(NSString*)res
{
    
}

-(Session*)addSessionToDatabase:(CGSize)imageSize
{
    NSString *databaseName = COLOR_SPLURGE_DATABASE;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    Session  *sess = nil;
    FMResultSet *rs = nil;
    NSNumber *height = [NSNumber numberWithInt:(int)imageSize.height];
    NSNumber *width = [NSNumber numberWithInt:(int)imageSize.width];
	
	/* open the database */
	FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
	if (![db open]) 
	{
		NSLog(@"addSessionToDatabaseAtIndex:Could not open db.");
		return sess;
	}
    
    rs = [db executeQuery:@"select * from currentIndex"];
    if(nil == rs)
    {
        NSLog(@"addSessionToDatabaseAtIndex:Could not get current index");
        [db close];
        return sess;
    }
    
    while([rs next])
    {
        iCurrentSessionIndex = [rs intForColumn:@"currentIndex"];
    }
    
    [rs close];
    
    [db beginTransaction];
#if DB_TRACE_EXECUTION    
    [db setTraceExecution:YES];
#endif
    
    NSNumber *undoindex = [NSNumber numberWithInt:0];
    
    /* Now insert the session into the database */
    [db executeUpdate:@"insert into sessions (id, name, time, undoindex, imageWidth, imageHeight) values (?, ?, ?, ?, ?, ?)" ,
     [NSNumber numberWithInt:iCurrentSessionIndex],
     [[NSDate date] description],
     [[NSDate date] description],undoindex,width,height];
    
    /* update the index */
    iCurrentSessionIndex = iCurrentSessionIndex + 1;
    
    /* update the index and insert into database */
    [db executeUpdate:@"update currentIndex set currentIndex = ? where currentIndex = ?",
     [NSNumber numberWithInt:iCurrentSessionIndex],[NSNumber numberWithInt:(iCurrentSessionIndex-1)]];
    
    [db commit];
    
    /* close the database */
    [db close];
    
    /* Allocate the session */
    sess = [Session alloc];
    [sess setSessionIndex:(iCurrentSessionIndex-1)];
    [sess setName:[[NSDate date] description]];
    [sess setDate:[[NSDate date] description]];
    sess.bIsNewSession = YES;
    
    return sess;
}

-(void)imageSelected:(UIImage *)img result:(NSString*)res
{
    if(nil != img)
    {
        NSArray *viewControllers = self.navigationController.viewControllers;
        Color_SplurgeViewController *controller = (Color_SplurgeViewController*)[viewControllers objectAtIndex:0];
        
        //Session *sess = [self addSessionToDatabase:img.size];
        Session *sess = [Session allocSessionAndAddToDatabase:img.size];
        sess.image    = img;
        
        [controller sessionSelected:sess];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        if(nil != res)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
            if(self.view.window != nil)
            {
                UIPopoverController *pPopOver = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
                
                pPopOver.delegate = self;
                
                UIButton *pbut = (UIButton*)sender;
                
                [pPopOver presentPopoverFromRect:[[UIScreen mainScreen]bounds] inView:pbut permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
                [pPopOver release];
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
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"No active internet connection to connect to Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alview show];
        [alview release];
        return;
    }
    
    FacebookAlbumList *plist = [[FacebookAlbumList alloc]initWithStyle:UITableViewStyleGrouped];
    
    mg = [fbmgr Instance];
    
    [self.navigationController pushViewController:plist animated:YES];

    [plist release];
}

-(void)handleProfilePhoto:(id)sender
{
    if(NO == nvm.connectedToInternet)
    {
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"No active internet connection to connect to Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alview show];
        [alview release];
        return;
    }
    
    fbUser = [[FacebookUser alloc]init];
    fbUser.imgDelegate = self;
    
    mg = [fbmgr Instance];
    
    [fbUser getProfilePhoto];
    
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
            cell.textLabel.text = @"Photo Albums";
            cell.detailTextLabel.text = @"your local photo album";
            break;
        }
        case 1:
        {
            imgName = @"profilephoto";
            imgType = @"png";
            cell.textLabel.text = @"Facebook Profile Photo";
            cell.detailTextLabel.text = @"your Facebook profile photo";
            break;
        }
        case 2:
        {
            imgName = @"facebook";
            imgType = @"png";
            cell.textLabel.text = @"Facebook Albums";
            cell.detailTextLabel.text = @"your Facebook albums";
            break;
        }
        case 3:
        {
            imgName = @"camera";
            imgType = @"png";
            cell.textLabel.text = @"Camera";
            cell.detailTextLabel.text = @"Take live photo using Camera";
            break;
        }
        case 4:
        {
            imgName = @"copytoclipboard";
            imgType = @"png";
            cell.textLabel.text = @"Paste From Pasteboard";
            cell.detailTextLabel.text = @"Paste your copied image";
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
    return @"Select Background Image";
}


-(void)exitApplist
{
	[self dismissModalViewControllerAnimated:NO];
    
	return;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
    
    fbUser = nil;
	
    self.title = @"Background";
    
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
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"No image present in the paste board to paste" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alview show];
        [alview release];
    }
    
    return;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case 0:
        {
            [self handlePhotoAlbum:self];
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    return;
}

@end
