//
//  Applist.m
//  SimpleTextInput
//
//  Created by Vijaya kumar reddy Doddavala on 9/28/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "Applist.h"


@implementation Applist

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
    {
        return 8;
    }
    else
    {
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UIImage *img = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font        = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.font  = [UIFont systemFontOfSize:10.0];
    cell.accessoryType           = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    switch(indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ColorSplurge" ofType:@"png"]];
                    cell.textLabel.text = @"Color Splurge";
                    cell.detailTextLabel.text = @"Free Forever";
                    break;
                }
                case 1:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"GlowMail" ofType:@"png"]];
                    cell.textLabel.text = @"Glow Mail";
                    cell.detailTextLabel.text = @"Free Forever";
                    break;
                }
                case 2:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Clearme" ofType:@"png"]];
                    cell.textLabel.text = @"Clear Me Free";
                    cell.detailTextLabel.text = @"Free Forever";
                    break;
                }
                case 3:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"PhotoSplash" ofType:@"png"]];
                    cell.textLabel.text = @"Photo Splash Free";
                    cell.detailTextLabel.text = @"Free Forever";
                    break;
                }
                case 4:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"PhotoToSketch" ofType:@"png"]];
                    cell.textLabel.text = @"Photo To Sketch";
                    cell.detailTextLabel.text = @"Free Forever";
                    break;
                }
                case 5:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"SteamDoodle" ofType:@"png"]];
                    cell.textLabel.text = @"Steam Doodle Free";
                    cell.detailTextLabel.text = @"Free Forever";
                    break;
                }
                case 6:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"AnimatedGlowDoodle" ofType:@"png"]];
                    cell.textLabel.text = @"Animated Glow Doodle Lite";
                    cell.detailTextLabel.text = @"Free Forever";
                    break;
                }
                case 7:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"FlamesDoodle" ofType:@"png"]];
                    cell.textLabel.text = @"Flames Doodle";
                    cell.detailTextLabel.text = @"Free Forever";
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"AnimatedGlowDoodle" ofType:@"png"]];
                    cell.textLabel.text = @"Animated Glow Doodle";
                    cell.detailTextLabel.text = @"0.99";
                    break;
                }
                case 1:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Clearme" ofType:@"png"]];
                    cell.textLabel.text = @"Clear Me";
                    cell.detailTextLabel.text = @"0.99";
                    break;
                }
                case 2:
                {
                    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"SteamDoodle" ofType:@"png"]];
                    cell.textLabel.text = @"Steam Doodle";
                    cell.detailTextLabel.text = @"0.99";
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        }
    }
    
    if(nil != img)
    {
        cell.imageView.image = [img thumbnailImage:60 transparentBorder:2 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Free Apps";
    }
    else
    {
        return @"Paid Apps";
    }
    
    return @"Select Background Image";
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
    UIApplication *app = [UIApplication sharedApplication];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/color-splurge/id473535285?mt=8"]];
                    break;
                }
                case 1:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/glow-mail/id441869107?mt=8"]];
                    break;
                }
                case 2:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/clear-me-blast-it/id424524559?mt=8"]];
                    break;
                }
                case 3:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/photo-splash-for-free/id417582128?mt=8"]];
                    break;
                }
                case 4:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/photo-to-sketch/id421785759?mt=8"]];
                    break;
                }
                case 5:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/steam-doodle-free/id414331761?mt=8"]];
                    break;
                }
                case 6:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/animated-glow-doodle-lite/id371248474?mt=8"]];
                    break;
                }
                case 7:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/flamesdoodle/id342117430?mt=8"]];
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    [app openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/animated-glow-doodle/id369629775?mt=8"]];
                    break;
                }
                case 1:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/clear-me/id398936347?mt=8"]];
                    break;
                }
                case 2:
                {
                    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/steam-doodle/id378708287?mt=8"]];
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        }
    }
}

@end
