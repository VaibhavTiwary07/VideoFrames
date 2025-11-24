//
//  InitSessionManager.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 12/21/11.
//  Copyright (c) 2011 motorola. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

//@synthesize sessionDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBarHidden = NO;
//        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        //self.title = @"Projects";
        self.title = NSLocalizedString(@"PROJECTS", @"Projects");
        nvm = [Settings Instance];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    return self;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return FALSE;
        
    }
    
    return TRUE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray         *rows = [NSArray arrayWithObjects:indexPath, nil];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        /* Create the session using cell tag */
        [Session deleteSessionWithId:(int)cell.tag];
        
        /* delete the row at index */
        [tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)dealloc
{
    //[super dealloc];
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
    printf("--- SessionManager.m: viewDidLoad ---\n");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark private functions
-(void)dumpAllSessions
{
    NSString *databaseName = PICFARME_DATABASE;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    FMResultSet *rs;
	
	/* open the database */
	FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
	if (![db open]) 
	{
       // [db release];
		NSLog(@"dumpAllSessions:Could not open db.");
		return;
	}
    
    rs = [db executeQuery:@"select * from sessions"];
    if(nil == rs)
    {
        NSLog(@"dumpAllSessions:Could not get sessions");
        [db close];
        return;
    }
    
    /* start dumping the database contents */
    NSLog(@"index         name          time");
    while ([rs next])
    {
        NSLog(@"%d         %s          %s",[rs intForColumn:@"id"],[[rs stringForColumn:@"name"] UTF8String],[[rs stringForColumn:@"time"] UTF8String]);
    }
    
    [rs close];
    
    
    /* close the database */
    [db close];
    
    return;
}

-(int)getSessionCount
{
    NSString *databaseName = PICFARME_DATABASE;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    FMResultSet *rs;
    int iRowCount = 0;
	
	/* open the database */
	FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
	if (![db open]) 
	{
       // [db release];
		NSLog(@"getSessionCount:Could not open db.");
		return 0;
	}
    
    rs = [db executeQuery:@"select COUNT(*) as rowcount from sessions"];
    if(nil == rs)
    {
        NSLog(@"getSessionCount:Could not get session count");
        [db close];
        return 0;
    }
    
    while([rs next])
    {
        iRowCount = [rs intForColumn:@"rowcount"];
    }
    
    [rs close];
    
    
    /* close the database */
    [db close];
    
    return iRowCount;
}

-(void)fillTheCell:(UITableViewCell*)cell ForIndexPath:(NSIndexPath*)iIndex 
{
    NSString *databaseName = PICFARME_DATABASE;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    int iRow = 0;
    FMResultSet *sessions  = nil;
	
	/* open the database */
	FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
	if (![db open]) 
	{
      //  [db release];
		NSLog(@"fillTheCell:Could not open db.");
		return;
	}
    
    //sessions = [db executeQuery:@"select * from sessions"];
    sessions = [db executeQuery:@"select * from sessions order by iSessionId desc"];
    if(nil == sessions)
    {
        NSLog(@"dumpAllSessions:Could not get sessions");
        [db close];
        return;
    }
    
    if(iIndex.section == 0)
    {
        while([sessions next])
        {
            if([sessions intForColumn:@"iSessionId"] == nvm.currentSessionIndex)
            {
                cell.tag            = [sessions intForColumn:@"iSessionId"];

                /* create the image out of the context */
                UIImageView *icon = (UIImageView*)[cell.contentView viewWithTag:TAG_SESSION_ICON];
                icon.image = [Session iconImageFromSession:nvm.currentSessionIndex];
                
                UILabel *lbl1 = (UILabel*)[cell.contentView viewWithTag:TAG_SESSION_LBL1];
                //lbl1.text = [NSString stringWithFormat:@"Resume Project"];
                lbl1.text = NSLocalizedString(@"RESPROJECT", @"Resume Project");
                
                UILabel *lbl2 = (UILabel*)[cell.contentView viewWithTag:TAG_SESSION_LBL2];
                //lbl2.text = [NSString stringWithFormat:@"Created on %@",[[Session createdDateForSession:nvm.currentSessionIndex]description]];
                lbl2.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"CREATEDON", @"Created on"),[[Session createdDateForSession:nvm.currentSessionIndex]description]];
                
                eAspectRatio eRatio = [sessions intForColumn:@"iAspectRatio"]; 
                CGSize aspectRatio = [Settings aspectRatioToValues:eRatio];
                NSString *str = [NSString stringWithFormat:@"%@ %d:%d %@ %d/%d %@ %d",NSLocalizedString(@"ARATIO", @"Aspect Ratio"),(int)aspectRatio.width,(int)aspectRatio.height,NSLocalizedString(@"RADIUS", @"Radius"),(int)[sessions doubleForColumn:@"fInnerRadius"],(int)[sessions doubleForColumn:@"fOuterRadius"],NSLocalizedString(@"WIDTH", @"Width"),(int)[sessions doubleForColumn:@"fFrameWidth"]];
                UILabel *lbl3 = (UILabel*)[cell.contentView viewWithTag:TAG_SESSION_LBL3];
                lbl3.text = str;
                
                /* Add the shadow for the imageview */
                icon.clipsToBounds = NO;
                icon.layer.shadowColor = [UIColor blackColor].CGColor;
                icon.layer.shadowOffset = CGSizeMake(0, 0);
                icon.layer.shadowOpacity = 1;
                icon.layer.shadowRadius = 2.0;
                break;
            }
        }
    }
    else if(iIndex.section == 1)
    {
        int tableRow = (int)iIndex.row;
        
        /* browse to the row based on index */
        while([sessions next])
        {
            /* We need to skip the current Session, so increment the tablerow to next */
            if(nvm.currentSessionIndex == [sessions intForColumn:@"iSessionId"])
            {
                tableRow = tableRow+1;
            }
            
            if(iRow == tableRow)
            {
                cell.tag            = [sessions intForColumn:@"iSessionId"];
                
                UIImageView *icon = (UIImageView*)[cell.contentView viewWithTag:TAG_SESSION_ICON];
                icon.image = [Session iconImageFromSession:(int)cell.tag];
                
                UILabel *lbl1 = (UILabel*)[cell.contentView viewWithTag:TAG_SESSION_LBL1];
                //lbl1.text = [NSString stringWithFormat:@"Load Project"];
                lbl1.text = NSLocalizedString(@"LOADPROJECT", @"Load Project");
                
                UILabel *lbl2 = (UILabel*)[cell.contentView viewWithTag:TAG_SESSION_LBL2];
                lbl2.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"CREATEDON", nil),[[Session createdDateForSession:(int)cell.tag]description]];
                
                eAspectRatio eRatio = [sessions intForColumn:@"iAspectRatio"]; 
                CGSize aspectRatio = [Settings aspectRatioToValues:eRatio];
                NSString *str = [NSString stringWithFormat:@"%@ %d:%d %@ %d/%d %@ %d",NSLocalizedString(@"ARATIO", nil),(int)aspectRatio.width,(int)aspectRatio.height,NSLocalizedString(@"RADIUS", nil),(int)[sessions doubleForColumn:@"fInnerRadius"],(int)[sessions doubleForColumn:@"fOuterRadius"],NSLocalizedString(@"WIDTH", nil),(int)[sessions doubleForColumn:@"fFrameWidth"]];
                UILabel *lbl3 = (UILabel*)[cell.contentView viewWithTag:TAG_SESSION_LBL3];
                lbl3.text = str;
                
                /* Add the shadow for the imageview */
                icon.clipsToBounds = NO;
                icon.layer.shadowColor = [UIColor blackColor].CGColor;
                icon.layer.shadowOffset = CGSizeMake(0, 0);
                icon.layer.shadowOpacity = 1;
                icon.layer.shadowRadius = 2.0;
                
                break;
            }
            
            /* increment the count */
            iRow++;
        }
    }
    
    [sessions close];
    [db close];
    
    return;
}

-(Session*)sessionWithIndex:(int)index
{
    NSString *databaseName = PICFARME_DATABASE;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *dbPath       = [documentsDir stringByAppendingPathComponent:databaseName];
    Session  *sess         = nil;
    FMResultSet *sessions  = nil;
	
	/* open the database */
	FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
	if (![db open]) 
	{
       // [db release];
		NSLog(@"dumpAllSessions:Could not open db.");
		return sess;
	}
    
    sessions = [db executeQuery:@"select * from sessions where iSessionId = ?",[NSNumber numberWithInt:index]];
    if(nil == sessions)
    {
        NSLog(@"dumpAllSessions:Could not get sessions");
        [db close];
        return sess;
    }
    
    /* browse to the row based on index */
    while([sessions next])
    {
        /* check if the session really exist */
        if([sessions intForColumn:@"iSessionId"] == index)
        {
            sess = [Session alloc];
            break;
        }
    }
    
    [sessions close];
    [db close];
    
    return sess;
}

#pragma mark - Table view data source

//- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
            /* This section is used to add the logout button for facebook */
        case 0:
        {
            //return @"Current Project";
            return NSLocalizedString(@"CURPROJECT",@"Current Project");
        }
        case 1:
        {
            //return @"Saved Projects";
            return NSLocalizedString(@"SAVEDPROJECT", @"Saved Projects");
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
    return 100.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger iRows = 0;
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch(section)
    {
        case 0:
        {
            if([self getSessionCount] > 0)
            {
                iRows = 1;
            }
            else
            {
                iRows = 0;
            }
            
            break;
        }
        case 1:
        {
            iRows = [self getSessionCount];
            if(iRows > 0)
            {
                iRows = iRows - 1;
            }
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

-(void)startNewSession
{
    return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];// autorelease];
        
        /* Now allocate and add the items to content view */
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 10.0, 80.0, 80.0)];
        icon.tag = TAG_SESSION_ICON;
        [cell.contentView addSubview:icon];
     //   [icon release];
        
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(100.0, 20.0, 200.0, 20.0)];
        lable1.font = [UIFont boldSystemFontOfSize:15.0];
        lable1.backgroundColor = [UIColor clearColor];
        lable1.tag = TAG_SESSION_LBL1;
        [cell.contentView addSubview:lable1];
     //   [lable1 release];
        
        UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(100.0, 40.0, 200.0, 20.0)];
        lable2.font = [UIFont systemFontOfSize:10.0];
        lable2.backgroundColor = [UIColor clearColor];
        lable2.tag = TAG_SESSION_LBL2;
        [cell.contentView addSubview:lable2];
     //   [lable2 release];
        
        UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(100.0, 60.0, 200.0, 20.0)];
        lable3.font = [UIFont systemFontOfSize:10.0];
        lable3.backgroundColor = [UIColor clearColor];
        lable3.tag = TAG_SESSION_LBL3;
        [cell.contentView addSubview:lable3];
      //  [lable3 release];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter; //UITextAlignmentCenter;
    cell.textLabel.font          = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.font    = [UIFont systemFontOfSize:10.0];
    cell.accessoryType           = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text          = nil;
    //cell.backgroundColor = [UIColor whiteColor];
    
    //cell.imageView.image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"photography.bundle/Icons/album" ofType:@"png"]] thumbnailImage:60 transparentBorder:2 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];
    
    // Configure the cell...
    switch(indexPath.section)
    {
        case 0:
        {
            [self fillTheCell:cell ForIndexPath:indexPath];
            
            break;
        }
        case 1:
        {
            [self fillTheCell:cell ForIndexPath:indexPath];
            
            break;
        }
        default:
        {
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.section) 
    {
        case 0:
        {
            NSLog(@"load the session case 1");
            [[NSNotificationCenter defaultCenter] postNotificationName:loadSession
                                                                object:nil];
           // [self dismissModalViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"session manager dismissed!");
            }];
            break;
        }
        case 1:
        {
            
            nvm.currentSessionIndex = (int)cell.tag;
            NSLog(@"load the session currentSessionIndex %d",nvm.currentSessionIndex);
            [[NSNotificationCenter defaultCenter] postNotificationName:loadSession
                                                                object:nil];
//            [self dismissModalViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"session manager controller dismissed!");
            }];
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
