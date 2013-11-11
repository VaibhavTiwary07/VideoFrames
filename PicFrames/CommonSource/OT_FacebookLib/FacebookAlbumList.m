//
//  FacebookAlbumList.m
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 7/21/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "FacebookAlbumList.h"
#import "QuartzCore/CALayer.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "FacebookAlbums.h"
#import "OT_Facebook.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImage+Resize.h"

@interface FacebookAlbumList()
{
    NSArray *albums;
    NSMutableDictionary *coverphotos;
}
@end

@implementation FacebookAlbumList


-(void)cancelAlbums:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    return;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        self.title = NSLocalizedString(@"FB",@"Facebook");
        self.navigationController.toolbarHidden = NO;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
        //    self.contentSizeForViewInPopover = CGSizeMake(IPAD_POPOVER_WIDTH, IPAD_POPOVER_HEIGHT);
        }
        
        //self.navigationItem.leftBarButtonItem = 
        //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
        //                                              target:self
        //                                              action:@selector(cancelAlbums:)];
        [SDWebImageManager.sharedManager.imageDownloader setValue:@"SDWebImage Demo" forHTTPHeaderField:@"AppName"];
        SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
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
    
    //[Utility removeActivityIndicatorFrom:self.view];
    
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
    [FBRequestConnection startWithGraphPath:@"me/albums" completionHandler:^(FBRequestConnection *connection, NSDictionary *user, NSError *error)
     {
         NSDictionary *dict = user;
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
                     [FBRequestConnection startWithGraphPath:[album objectForKey:@"cover_photo"] completionHandler:^(FBRequestConnection *connection, NSDictionary *user, NSError *error){
                         
                         NSDictionary *dict = user;
                         NSArray *imgs   = [dict objectForKey:@"images"];
                         int      ind  = [imgs count];
                         ind          -= 1;
                         if(ind >= 0)
                         {
                             NSDictionary *img = [imgs objectAtIndex:ind];
                             NSString *MyURL = [img objectForKey:@"source"];
                             [coverphotos setValue:[NSURL URLWithString:MyURL] forKey:[album objectForKey:@"cover_photo"]];
                         }
                         
                         
                         if(index == [albums count]-1)
                         {
                             [self.tableView reloadData];
                         }
                     }];
                 }
             }
         }
     }];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[OT_Facebook SharedInstance]loginToFacebook:YES onCompletion:^(BOOL loginStatus)
    {
        if(YES == loginStatus)
        {
            [self requestForAlbums];
        }
    }];
    
    return;
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
                    cell.imageView.contentMode = UIViewContentModeScaleToFill;
                    [cell.imageView setImageWithURL:[coverphotos objectForKey:[dict objectForKey:@"cover_photo"]] placeholderImage:[UIImage imageNamed:@"placeholderSquare"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0 size:60 progress:nil completed:nil];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSDictionary *dict = [albums objectAtIndex:indexPath.row];
        if(nil != dict)
        {
            FacebookAlbums *album = [[FacebookAlbums alloc]initWithAlbumId:[dict objectForKey:@"id"]];
            [self.navigationController pushViewController:album animated:YES];
        }
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

@end
