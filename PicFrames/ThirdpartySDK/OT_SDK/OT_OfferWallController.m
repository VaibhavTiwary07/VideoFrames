
/*
     File: RootViewController.m
 Abstract: View controller that sets up the table view and the time zone data.
 
  Version: 2.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "OT_OfferWallController.h"
//#import "appCell.h"

#define ROW_HEIGHT 70

@implementation OT_OfferWallController

@synthesize displayList;
@synthesize iAppCount;
@synthesize pIndicatorView;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style 
{
	if (self = [super initWithStyle:style]) 
	{
		self.title = NSLocalizedString(@"Free Apps", @"Leader Board title title");
		
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
		//self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		self.tableView.rowHeight = ROW_HEIGHT;
		self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white.png"]];
		self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"mainbackground" ofType:@"jpg"]]];
        
        
		
		//self.view.backgroundColor = [UIColor blueColor];
	}
	return self;
}

-(void)exitApplist
{
	[self dismissModalViewControllerAnimated:NO];

	return;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	UIBarButtonItem *backButton;
	
	backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(exitApplist)];
	backButton.style =  UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem = backButton;
}

#pragma mark -
#pragma mark View lifecycle

-(void)stopTheActivity
{
	[pIndicatorView stopAnimating];
	
	return;
}

-(void)applicationListRetrieved
{
	//[pIndicatorView stopAnimating];
	
	[self.tableView reloadData];
}

-(void)reloadTheTableData
{
	[self.tableView reloadData];
}

-(void)loadedAllImages
{
	[pIndicatorView stopAnimating];
}

-(NSURL*)iconUrlForApp:(NSString*)appid
{
    NSString *iconName = [NSString stringWithFormat:@"%@.png",appid];
    NSString *url  = [NSString stringWithFormat:@"%@%@",urlforicon,iconName];
    
    return [NSURL URLWithString:url];
}

-(BOOL)isIconAvailableForApp:(NSString*)appid
{
    NSError* error = nil;
    NSHTTPURLResponse* response = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:[self iconUrlForApp:appid] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 404)
    {
        NSLog(@"Icon File %@ doesn't exist",[self iconUrlForApp:appid]);
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)retrieveImageThread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	for(int i = 0; i < iAppCount;i++)
	{
		OT_App *pTmp = [OT_App applicationWithIndex:i];
		if(nil == pTmp.icon)
		{
            pTmp.icon = [OT_Utils getIconForApp:pTmp.appid];
            if(nil != pTmp.icon)
            {
                NSLog(@"retrieveImageThread:Found in NVM for %d !!!!!",i);
                [self performSelectorOnMainThread:@selector(reloadTheTableData) 
                                       withObject:nil 
                                    waitUntilDone:false];
                continue;
            }
            
            NSURL *iconUrl = [NSURL URLWithString:pTmp.iconUrl];
            
            if((nil != pTmp.appid)&&(YES == [self isIconAvailableForApp:pTmp.appid]))
            {
                iconUrl = [self iconUrlForApp:pTmp.appid];
            }
            
			NSData *pData = [[NSData alloc] initWithContentsOfURL:iconUrl];
			pTmp.icon = [UIImage imageWithData:pData];
			//[NSTimer scheduledTimerWithTimeInterval:0.00001 target:self selector:@selector(retrieveImage) userInfo:nil repeats:NO];
            [OT_Utils saveIcon:pTmp.icon ForApp:pTmp.appid];
			NSLog(@"retrieveImageThread:retrieved image %d",i);
			
			[pData release];
			//[self.tableView reloadData];
			//break;
			[self performSelectorOnMainThread:@selector(reloadTheTableData) 
								   withObject:nil 
								waitUntilDone:false];
		}
	}
	
	[self performSelectorOnMainThread:@selector(loadedAllImages) 
						   withObject:nil 
						waitUntilDone:false];
	
	//NSLog(@"retrieveImageThread:Done with image retrievel");
	
	[pool release];
}

-(void)applicationList
{	
	int iCount = 0;
	
	/* retrieve the application data */
	OT_AppList *tmp = [OT_AppList alloc];
	
	if(NO == [tmp retriveAppList:&iCount])
	{
		//NSLog(@"Failed to retrieve app list");
		[pIndicatorView stopAnimating];
	}
	
	self.iAppCount = iCount;
	[tmp release];

	[self applicationListRetrieved];
	//[NSTimer scheduledTimerWithTimeInterval:0.00001 target:self selector:@selector(applicationListRetrieved) userInfo:nil repeats:NO];
	
	/* create the thread to retrieve the images */
	[NSThread detachNewThreadSelector:@selector(retrieveImageThread) 
							 toTarget:self 
						   withObject:nil];
	return;
}

-(void)retrieveApplicationList
{
	[self applicationList];
}

- (void)viewWillAppear:(BOOL)animated 
{
	id tmp1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	self.pIndicatorView = tmp1;
	pIndicatorView.center = [self view].center;
	[tmp1 release];
	
	[self.view addSubview:pIndicatorView];
	[pIndicatorView startAnimating];
	
	[NSTimer scheduledTimerWithTimeInterval:0.00001 target:self selector:@selector(retrieveApplicationList) userInfo:nil repeats:NO];
	
}


- (void)viewWillDisappear:(BOOL)animated 
{
	[pIndicatorView stopAnimating];
	
	self.pIndicatorView = nil;
}


#pragma mark -
#pragma mark Table view datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	return iAppCount;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section 
{
	return nil;
}

#if 0
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
		
	static NSString *CellIdentifier = @"appCell";
		
	appCell *applicationCell = (appCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (applicationCell == nil) {
		applicationCell = [[[appCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		applicationCell.frame = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
	}
	
	NSUInteger pInt;
	pInt = [indexPath indexAtPosition:1];
	
	application *pTmp = [application applicationWithIndex:pInt];
	
	[applicationCell setApplication:pTmp];
	return applicationCell;
}
#else
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    
	static NSString *CellIdentifier = @"appCell";
    
	UITableViewCell *applicationCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (applicationCell == nil) {
		applicationCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		applicationCell.frame = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
	}
	
	NSUInteger pInt;
	pInt = [indexPath indexAtPosition:1];
	
	OT_App *pApp = [OT_App applicationWithIndex:pInt];
	
    applicationCell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
	applicationCell.textLabel.text = pApp.appName;
    applicationCell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
    applicationCell.detailTextLabel.text = pApp.description;
    applicationCell.imageView.image = pApp.icon;
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0,0,50,ROW_HEIGHT-20.0)];
    lbl.font = [UIFont boldSystemFontOfSize:11.0];
    lbl.text = pApp.price;
    lbl.textAlignment = UITextAlignmentCenter;
    applicationCell.accessoryView = (UIView*)lbl;
    [lbl release];
    
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:applicationCell.frame];
    [selectedBackgroundView setBackgroundColor:[UIColor redColor]]; // set color here
    
    
    if(indexPath.row % 2)
    {
        selectedBackgroundView.backgroundColor = [UIColor colorWithRed:(173.0f/255.0f) green:(173.0f/255.0f) blue:(176.0f/255.0f) alpha:1.0];
        lbl.backgroundColor = [UIColor colorWithRed:(173.0f/255.0f) green:(173.0f/255.0f) blue:(176.0f/255.0f) alpha:1.0];
        //selectedBackgroundView.backgroundColor = [UIColor redColor];
    }
    else 
    {
        
        selectedBackgroundView.backgroundColor = [UIColor colorWithRed:(152.0f/255.0f) green:(152.0f/255.0f) blue:(156.0f/255.0f) alpha:1.0];
        lbl.backgroundColor = [UIColor colorWithRed:(152.0f/255.0f) green:(152.0f/255.0f) blue:(156.0f/255.0f) alpha:1.0];
        //selectedBackgroundView.backgroundColor = [UIColor greenColor];
    }
    
    [applicationCell setBackgroundView:selectedBackgroundView];
    [selectedBackgroundView release];
    
    //applicationCell.backgroundColor = [UIColor grayColor];
    
	return applicationCell;
}
#endif


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UIApplication *app = [UIApplication sharedApplication];
	NSUInteger     pInt;
	
	/*
	 To conform to the Human Interface Guidelines, selections should not be persistent --
	 deselect the row after it has been selected.
	 */
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	/* get the application index */
	pInt = [indexPath indexAtPosition:1];
	
	/* retrieve the application information */
	OT_App *pApp = [OT_App applicationWithIndex:pInt];
	if(nil != pApp)
	{
        if(nil != pApp.appid)
        {
            NSString *appstorestr = [NSString stringWithFormat:genericituneslinktoApp,pApp.appid];
            [app openURL:[NSURL URLWithString:appstorestr]];
        }
        else 
        {
            /* Set the URL information */
            [app openURL:[NSURL URLWithString:pApp.appstoreUrl]];
        }
	}
	
	//NSLog(@"selected Index %d",pInt);
	
	return;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


- (void)dealloc {
	[displayList release];
	[super dealloc];
}


@end
