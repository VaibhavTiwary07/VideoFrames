//
//  VideoSettingsController.m
//  VideoFrames
//
//  Created by Sunitha Gadigota on 10/15/13.
//
//

#import "VideoSettingsController.h"

#define VIDEO_SETTINGS_MAX_STRLEN 128
#define TAG_VIDEO_SETTINGS_SWITCH 568
typedef enum
{
    VIDEO_SETTINGS_TYPE_MUSIC,
    VIDEO_SETTINGS_TYPE_VIDEO_ORDER,
    VIDEO_SETTINGS_TYPE_MISC,
    VIDEO_SETTINGS_TYPE_MAX
}eSettingType;

typedef struct
{
    eSettingType eType;
    char heading[VIDEO_SETTINGS_MAX_STRLEN];
    int numberOfRows;
    BOOL variableRows;
}tSettingInfo;

tSettingInfo settingInfo[VIDEO_SETTINGS_TYPE_MAX] = {
    {VIDEO_SETTINGS_TYPE_MUSIC,"Music",1,YES},
    {VIDEO_SETTINGS_TYPE_VIDEO_ORDER,"Change video play setting and order",3,NO},
    {VIDEO_SETTINGS_TYPE_MISC,"Other Video Settings",3,NO}};

@interface VideoSettingsController ()

@end

@implementation VideoSettingsController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    /* we support 4 types of settings
       1. Selecting background music
       2. Video playback order setup & loop setting
       3. Video loop configuration
       4. Maximum Video length, parallel or sequential play
     */
    return VIDEO_SETTINGS_TYPE_MAX;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = settingInfo[section].numberOfRows;
    
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [NSString stringWithFormat:@"%s",settingInfo[section].heading];

    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    // Configure the cell...
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.font          = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.font    = [UIFont systemFontOfSize:10.0];
    
    
    switch (indexPath.section)
    {
        case VIDEO_SETTINGS_TYPE_MUSIC:
        {
            cell.textLabel.text          = @"VijayText";
            break;
        }
        case VIDEO_SETTINGS_TYPE_VIDEO_ORDER:
        {
            cell.imageView.image = [UIImage imageNamed:@"Icon-50.png"];
            
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(80, 0, 200, 50)];
            slider.alpha = 1;
            slider.maximumValue = 30;
            
            slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            [cell.contentView addSubview:slider];
            [slider release];
            NSLog(@"VIDEO_SETTINGS_TYPE_VIDEO_ORDER: index %d",indexPath.row);
            break;
        }
        case VIDEO_SETTINGS_TYPE_MISC:
        {
            cell.textLabel.text          = @"VijayText";
            if(indexPath.row == 0)
            {
                cell.textLabel.textAlignment = UITextAlignmentLeft;
                cell.textLabel.text = @"Play Videos Sequentially";
                
                if(nil == cell.accessoryView)
                {
                    UISwitch *Enable = [[UISwitch alloc]initWithFrame:CGRectZero];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.accessoryView = Enable;
                    Enable.on = NO;
                    [Enable release];
                }
            }
            else if(indexPath.row == 1)
            {
                cell.textLabel.textAlignment = UITextAlignmentLeft;
                cell.textLabel.text = @"Loop smaller videos";
                
                if(nil == cell.accessoryView)
                {
                    UISwitch *Enable = [[UISwitch alloc]initWithFrame:CGRectZero];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.accessoryView = Enable;
                    Enable.on = NO;
                    [Enable release];
                }
            }
            
            break;
        }
        default:
            break;
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != VIDEO_SETTINGS_TYPE_VIDEO_ORDER)
    {
        return NO;
    }
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
