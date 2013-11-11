//
//  FreeAppsList.m
//  vj
//
//  Created by Vijaya kumar reddy Doddavala on 8/12/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "FreeAppsList.h"

@implementation FreeAppsList

-(void)loadedAllImages
{
    UIActivityIndicatorView *tmp = (UIActivityIndicatorView*)[self viewWithTag:TAG_ACTIVITYINDICATOR];
    [tmp stopAnimating];
    [tmp removeFromSuperview];
}

-(void)dealloc
{
    
    exiting = YES;
    
    /* First Cancel the thread */
    [imgRetriveThread cancel];
    
    /* Get the list */
    NSMutableDictionary *list = [applist getApplist];
    
    /* First remote all the objects */
    [list removeAllObjects];
    
    /* Now remove the list */
    //[list release];
    [applist release];
    
    /* free the super */
    [super dealloc];
    
    return;
}

-(void)retrieveImageThread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	for(int i = 0; i < iAppCount;i++)
	{
        /* Check if the thread is cancelled */
        //if([imgRetriveThread isCancelled])
        if(exiting)
        {
            [pool release];
            return;
        }
           
        /* Get the app and load  */
		application *pTmp = [[applist getApplist] objectForKey:[NSNumber numberWithInt:i]];
		if(nil == pTmp.icon)
		{
			NSData *pData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pTmp.iconUrl]];
            
            /* Check if the thread is cancelled */
            //if([imgRetriveThread isCancelled])
            if(exiting)
            {
                [pData release];
                [pool  release];
                return;
            }
            
            /* Assign the image */
			pTmp.icon = [UIImage imageWithData:pData];

			
			[pData release];

			[self performSelectorOnMainThread:@selector(reloadData) 
								   withObject:nil 
								waitUntilDone:false];
		}
	}
	
	[pool release];
}

-(void)applicationList
{	    
	int iCount = 0;
	
	/* retrieve the application data */
	applist = [onlineapplist alloc];
    [applist initApplist];
	
    /* retrieve the applist */
	[applist retriveAppList:&iCount];
    
    /* stop the activity indicator */
    UIActivityIndicatorView *tmp1 = (UIActivityIndicatorView*)[self viewWithTag:TAG_ACTIVITYINDICATOR];
    [tmp1 stopAnimating];
    [tmp1 removeFromSuperview];
	//[applist release];
    
    /* initislize the count */
	iAppCount = iCount;
    
    [self reloadData];
	
    imgRetriveThread = [[NSThread alloc] initWithTarget:self selector:@selector(retrieveImageThread) object:nil];
    [imgRetriveThread start];
	/* create the thread to retrieve the images */
	//imgRetriveThread = [NSThread detachNewThreadSelector:@selector(retrieveImageThread) 
	//						 toTarget:self 
	//					   withObject:nil];
	return;
}

-(void)initTheList
{
    iAppCount = 0;
    exiting   = NO;
    
    /* Now request for the list */
    UIActivityIndicatorView *tmp = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	tmp.tag = TAG_ACTIVITYINDICATOR;
	tmp.center = self.center;
	
	
	[self addSubview:tmp];
	[tmp startAnimating];
    [tmp release];
	
	[NSTimer scheduledTimerWithTimeInterval:0.00001 target:self selector:@selector(applicationList) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [self initTheList];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIApplication *app = [UIApplication sharedApplication];
	
	/*
	 To conform to the Human Interface Guidelines, selections should not be persistent --
	 deselect the row after it has been selected.
	 */
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	/* retrieve the application information */
	application *pApp = [[applist getApplist] objectForKey:[NSNumber numberWithInt:indexPath.row]];
	if(nil != pApp)
	{
		/* Set the URL information */
		[app openURL:[NSURL URLWithString:pApp.appstoreUrl]];
	}
	
    return;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    application     *app            = nil;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell           = nil;
    
    if(nil == [applist getApplist])
    {
        return nil;
    }
    
    app = [[applist getApplist] objectForKey:[NSNumber numberWithInt:indexPath.row]];
    if(nil == app)
    {
        return nil;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font        = [UIFont boldSystemFontOfSize:15.0];
    cell.detailTextLabel.font  = [UIFont systemFontOfSize:10.0];
    cell.textLabel.text        = app.appName;
    cell.detailTextLabel.text  = app.description;
    cell.accessoryView         = nil;
    cell.accessoryType         = UITableViewCellAccessoryDisclosureIndicator;

    if(nil != app.icon)
    {   
        cell.imageView.image = [app.icon thumbnailImage:60 transparentBorder:2 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];
        /* Add the shadow for the imageview */
        cell.imageView.clipsToBounds = NO;
        cell.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.imageView.layer.shadowOffset = CGSizeMake(1, 1);
        cell.imageView.layer.shadowOpacity = 1;
        cell.imageView.layer.shadowRadius = 1.0;
    }
    else
    {
        UIActivityIndicatorView *pActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        pActivity.tag = TAG_ACTIVITYINDICATOR;
        cell.accessoryView = pActivity;
        
        [pActivity startAnimating];
        [pActivity release];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(iAppCount == 0)
    {
        [self initTheList];
    }
    
    return iAppCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Our other Free Apps";
}

@end
