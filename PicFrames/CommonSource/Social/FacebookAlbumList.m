//
//  FacebookAlbumList.m
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 7/21/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "FacebookAlbumList.h"


@implementation FacebookAlbumList

//@synthesize imgDelegate;

//-(void)imageSelected:(UIImage *)img result:(NSString*)res;
//{
//    [imgDelegate imageSelected:img result:res];
    
    //[self.navigationController popViewControllerAnimated:NO];
    //[self dismissModalViewControllerAnimated:YES];
    
//    return;
//}

-(void)cancelAlbums:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
    
    return;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        _fb = [fbmgr Instance];
        _fb.fbDelegate = self;
        // Custom initialization
        
        self.title = NSLocalizedString(@"FB",@"Facebook");
        self.navigationController.toolbarHidden = NO;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.contentSizeForViewInPopover = CGSizeMake(IPAD_POPOVER_WIDTH, IPAD_POPOVER_HEIGHT);
        }
        
        //self.navigationItem.leftBarButtonItem = 
        //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
        //                                              target:self
        //                                              action:@selector(cancelAlbums:)];
        albums = nil;
    }
    return self;
}
 
- (void)dealloc
{
    if(nil != coverphotos)
    {
        [coverphotos release];
        coverphotos = nil;
    }
    
    if(nil != albums)
    {
        [albums release];
        albums = nil;
    }
    
    [Utility removeActivityIndicatorFrom:self.view];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)requestForAlbums
{
    [_fb._facebook requestWithGraphPath:@"me/albums"
                            andDelegate:[self retain]];
}
#pragma mark - View lifecycle

- (void)loginStatus:(BOOL)isSuccess
{
    if(isSuccess)
    {
        if(bWaitingForLogin)
        {
            [self requestForAlbums];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bWaitingForLogin = NO;

    if(_fb._isLoggedIn)
    {
        [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"RETRIVING", @"Retriving")];
        [self requestForAlbums];
    }
    else
    {
        [_fb login];
        bWaitingForLogin = YES;
    }
    
    //[self requestForAlbums];
    //[_fb login];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)info_clicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
    return;
}

- (void)viewWillAppear:(BOOL)animated
{
    /* load the view */
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {           
        case 0:
        {
            if(nil != albums)
            {
                return [albums count];
            }
            break;
        }
        default:
        {
            break;
        }
    }

    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {           
        case 0:
        {
            return NSLocalizedString(@"FBYOURALBUMS",@"Your Albums");
        }
        default:
        {
            break;
        }
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch(section)
    {           
        case 0:
        {
            return NSLocalizedString(@"FBALBUMLISTTITLE",@"\nSelect the album to view and select the photos from the album");
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
    switch(indexPath.section)
    {           
        case 0:
        {
            return 70.0;
        }
        default:
        {
            break;
        }
    }
    
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier        = @"Cell";
    //static NSString *CellIdentifierDefault = @"Celllogout";
    UITableViewCell *cell                  = nil;
    NSDictionary *dict                     = nil;

    // Configure the cell...
    switch (indexPath.section)
    {           
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            }
            
            dict = [albums objectAtIndex:indexPath.row];
            if(nil != dict)
            {
                cell.textLabel.font       = [UIFont boldSystemFontOfSize:15.0];
                cell.textLabel.text       = [dict objectForKey:@"name"];
                cell.detailTextLabel.font       = [UIFont systemFontOfSize:10.0];
                NSString *scount = [dict objectForKey:@"count"];
                int icount = [scount intValue];
                
                if(icount > 1)
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"YOUHAVE", @"You have"),
                                                 [dict objectForKey:@"count"],NSLocalizedString(@"PHOTOSINALBUM", @"photos in this album")];
                }
                else if(icount == 1)
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"YOUHAVE", @"You have"),
                                                 [dict objectForKey:@"count"],NSLocalizedString(@"PHOTOSINALBUM", @"photos in this album")];
                }
                else
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FBEMPTYALBUM", @"Empty Album,No photo in this album")];
                }
                cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
                
                if(nil != [dict objectForKey:@"cover_photo"])
                {            
                    cell.imageView.image = [[coverphotos objectForKey:[dict objectForKey:@"cover_photo"]] thumbnailImage:60 transparentBorder:2 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];
                }
                else
                {
                    cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"icon" ofType:@"png"]];
                }
                
                /* Add the shadow for the imageview */
                cell.imageView.clipsToBounds = NO;
                cell.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
                cell.imageView.layer.shadowOffset = CGSizeMake(1, 1);
                cell.imageView.layer.shadowOpacity = 1;
                cell.imageView.layer.shadowRadius = 1.0;
            }
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
    if(indexPath.section == 0)
    {
        FacebookAlbum *album = [FacebookAlbum alloc];
        NSDictionary  *dict  = [albums objectAtIndex:indexPath.row];
        
        //album.imgDelegate = imgDelegate;
        album.pAlbumId = [dict objectForKey:@"id"];
        
        [self.navigationController pushViewController:album animated:YES];
        
        [album release];
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
}

- (void)request:(FBRequest *)request didLoad:(id)result 
{
    NSString *requestType =[request.url stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""];
    
    NSDictionary *dict = result;      
    if([requestType isEqualToString:@"me/albums"])
    {
        albums = [[dict objectForKey:@"data"] retain];
        
        if([albums count] > 0)
        {
            if(nil == coverphotos)
            {
                coverphotos = [[NSMutableDictionary alloc]initWithCapacity:[albums count]];
            }
            else
            {
                [coverphotos release];
                coverphotos = [[NSMutableDictionary alloc]initWithCapacity:[albums count]];
            }
            
            /* Now request for the cover photos of the album */
            for(int index = 0; index < [albums count]; index++)
            {
                NSDictionary *album = [albums objectAtIndex:index];
                
                if(nil != [album objectForKey:@"cover_photo"])
                {
                    [_fb._facebook requestWithGraphPath:[album objectForKey:@"cover_photo"]
                                            andDelegate:[self retain]];
                }
            }
        }
        
        [self.tableView reloadData];
    }
    else
    {
        NSArray *imgs   = [dict objectForKey:@"images"]; 
        int      index  = [imgs count];
        index          -= 1;
        if(index >= 0)
        {
            NSDictionary *img = [imgs objectAtIndex:index];
            NSString *MyURL = [img objectForKey:@"source"];
            UIImage *image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
            if(nil != image)
            {
                [coverphotos setValue:image forKey:requestType];
                [self.tableView reloadData];
            }
        }
    }
    
    [Utility removeActivityIndicatorFrom:self.view];
    
    [self release];
};

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{
    NSLog(@"FaceBookAlbumList:failure %@",[error localizedDescription]);
    
    [self release];
    
    return;
};


@end
