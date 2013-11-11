//
//  FacebookAlbum.m
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 7/24/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "FacebookAlbum.h"
//#import "Color_SplurgeViewController.h"
#import "ViewController.h"

@implementation FacebookAlbum

@synthesize pAlbumId;
//@synthesize imgDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.contentSizeForViewInPopover = CGSizeMake(IPAD_POPOVER_WIDTH, IPAD_POPOVER_HEIGHT);
        }
    }
    return self;
}

-(void)releaseResources
{
    /* First cancel the thread */
    if(nil != photoRetrieveThread)
    {
        [photoRetrieveThread cancel];
        [photoRetrieveThread release];
        photoRetrieveThread = nil;
    }
    
    if(nil != photos)
    {
        [photos release];
        photos = nil;
    }

    if(nil != pAlbum)
    {
        NSArray *pSubViews = pAlbum.subviews;
        int      count = 0;
        
        for(count = 0; count < [pSubViews count]; count++)
        {
            UIButton *obj = [pSubViews objectAtIndex:count];
            [obj removeFromSuperview];
        }
        
        [pAlbum removeFromSuperview];
        pAlbum = nil;
    }

    self.pAlbumId = nil;

    return;
}

- (void)dealloc
{
    NSLog(@"FacebookAlbum dealloc");
    
    exiting = YES;
    
    /* Release resources */
    [self releaseResources];
    
    /* release dealloc */
    [super dealloc];
    
    return;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [self releaseResources];
    
    return;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self releaseResources];
    
    return;
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    CGRect fullscreen = [[UIScreen mainScreen]bounds];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.contentSizeForViewInPopover = CGSizeMake(IPAD_POPOVER_WIDTH, IPAD_POPOVER_HEIGHT);
        //fullscreen.size.width = IPAD_POPOVER_WIDTH;
        //fullscreen.size.height = IPAD_POPOVER_HEIGHT;
    }
    
    if(nil == pAlbum)
    {
        pAlbum = [[UIScrollView alloc]initWithFrame:fullscreen];
        [pAlbum setBackgroundColor:[UIColor whiteColor]];
        [pAlbum setCanCancelContentTouches:NO];
        pAlbum.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        pAlbum.clipsToBounds  = YES;// default is NO, we want to restrict drawing within our scrollview
        pAlbum.scrollEnabled  = YES;
        
        [self.view addSubview:pAlbum];
        
        [pAlbum release];
    }
    
    
    
    return;
}

-(void)requestForPhotos
{
    [_fb._facebook requestWithGraphPath:[NSString stringWithFormat:@"%s/photos",[pAlbumId UTF8String]]
                            andDelegate:self];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
}

-(void)imageSelected:(id)sender
{
   
    UIButton *pButton = sender;
    
    /* Allocate the image */
    NSDictionary *photo = [photos objectAtIndex:pButton.tag];
    NSArray *imgs       = [photo objectForKey:@"images"];     
    
    NSDictionary *img = [imgs objectAtIndex:0];
    NSString *MyURL   = [img objectForKey:@"source"];
      
    UIImage *image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
#if 0    
    NSArray *viewControllers = self.navigationController.viewControllers;
 
    ViewController *controller = (ViewController*)[viewControllers objectAtIndex:0];
 
    [controller imageSelected:image];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
#else
    NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:image forKey:@"backgroundImageSelected"];
    [[NSNotificationCenter defaultCenter] postNotificationName:backgroundImageSelected object:nil userInfo:usrInfo];
    //if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
#endif
}

-(void)addPhotoToAlbumView:(id)image
{
    CGRect fullscreen = [[UIScreen mainScreen]bounds];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        fullscreen.size.width = IPAD_POPOVER_WIDTH;
        fullscreen.size.height = IPAD_POPOVER_HEIGHT;
    }
    
    float width = (fullscreen.size.width - ((FB_ALBUM_IMAGES_PER_ROW + 1)*FB_ALBUM_GAP_BETWEEN_IMAGES))/FB_ALBUM_IMAGES_PER_ROW;
    float height = width;
    float x = ((photoIndex % FB_ALBUM_IMAGES_PER_ROW) * width) + (((photoIndex % FB_ALBUM_IMAGES_PER_ROW) + 1)*FB_ALBUM_GAP_BETWEEN_IMAGES);
    float y = ((photoIndex/FB_ALBUM_IMAGES_PER_ROW) * height) + (((photoIndex/FB_ALBUM_IMAGES_PER_ROW) + 1) *FB_ALBUM_GAP_BETWEEN_IMAGES);
    float contentHeigth = ((photoIndex/FB_ALBUM_IMAGES_PER_ROW) + 1) * height + 
                         (((photoIndex/FB_ALBUM_IMAGES_PER_ROW) + 1) * FB_ALBUM_GAP_BETWEEN_IMAGES) + 50.0;
    CGRect rect = CGRectMake(x, y, width, height);
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self 
               action:@selector(imageSelected:) 
     forControlEvents:UIControlEventTouchUpInside];
    //[button setImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.tag = photoIndex;
    [pAlbum addSubview:button];
    
#if 0    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:rect];
    imgView.image        = image;
    [pAlbum addSubview:imgView];
    [imgView release];
#endif
    
    if(contentHeigth > fullscreen.size.height)
    {
        [pAlbum setContentSize:CGSizeMake(fullscreen.size.width, contentHeigth)];
    }
    
    photoIndex++;
}

-(void)retrieveAlbumPhotosThread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    for(int index = 0; index < [photos count];index++)
    {
        if(exiting)
        {
            [pool release];
            return;
        }
        NSDictionary *photo = [photos objectAtIndex:index];
        NSArray *imgs       = [photo objectForKey:@"images"]; 
        int      cnt        = [imgs count];
        cnt                -= 1;
     
        /* Yes photos are available, lets download one by one */
        if(index >= 0)
        {
            NSDictionary *img = [imgs objectAtIndex:cnt];
            NSString *MyURL   = [img objectForKey:@"source"];
            UIImage *image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
            if(nil != image)
            {
                [self performSelectorOnMainThread:@selector(addPhotoToAlbumView:) 
                                       withObject:image 
                                    waitUntilDone:false];
            }
        }
    }
	
	[pool release];
}

- (void)request:(FBRequest *)request didLoad:(id)result 
{
    NSString *requestType =[request.url stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""];
    
    NSDictionary *dict = result; 
    photos             = [[dict objectForKey:@"data"] retain];
    
    /* Now Start a thread to process the photos and add them to scroll view */
    if([requestType isEqualToString:[NSString stringWithFormat:@"%s/photos",[pAlbumId UTF8String]]])
    {
        if(0 < [photos count])
        {
            photoIndex = 0;
            photoRetrieveThread = [[NSThread alloc] initWithTarget:self 
                                                          selector:@selector(retrieveAlbumPhotosThread) 
                                                            object:nil];
            [photoRetrieveThread start];
        }
        else
        {
            /* Throw an error to the user */
        }
        
    }    
};

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{
    NSLog(@"FaceBookAlbumList:%@",[error localizedDescription]);
    
    return;
};

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _fb            = [fbmgr Instance];
    _fb.fbDelegate = self;
    photoRetrieveThread = nil;
    exiting = NO;
    
    [self requestForPhotos];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loginStatus:(BOOL)isSuccess
{
    
}

@end
