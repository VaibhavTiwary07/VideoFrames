//
//  FacebookAlbums.m
//  FacebookIntegration
//
//  Created by Sunitha Gadigota on 5/27/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import "FacebookAlbums.h"
#import "OT_Facebook.h"
#import "IIIFlowView.h"
#import "AsynchImageDownload.h"

@interface FacebookAlbums ()

@property(nonatomic,retain)NSArray *photos;
@property (nonatomic, nonatomic)NSMutableArray *dataSource;

@end

@implementation FacebookAlbums
@synthesize photos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didSelectCellAtIndex:(int)index
{
    //Get the photo object based on the selected index
    NSDictionary *photo = [photos objectAtIndex:index];
    if(nil == photo)
    {
        NSLog(@"Selected Photo Object is nil");
        return;
    }
    
    //Get the highest size image of the selected photo
    NSArray *imgs     = [photo objectForKey:@"images"];
    NSDictionary *img = [imgs objectAtIndex:0];
    if(nil == img)
    {
        NSLog(@"Selected Photo doesn't have any image");
        return;
    }
    
    //Get the Url of the highest image
    NSString *MyURL = [img objectForKey:@"source"];
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [aiv startAnimating];
    
    //Download the image
    [AsynchImageDownload processImageDataWithURLString:MyURL andBlock:^(NSData *imageData)
    {
        UIImage *image  = [UIImage imageWithData:imageData];
        
        //Send the notification about selected Image
        NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:image forKey:OT_FBBackgroundImageKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:OT_FBBackgroundImageSelected object:nil userInfo:usrInfo];
        
        //Exit to the top view controller
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        //stop animation
        [aiv stopAnimating];
        [aiv release];
    }];
    
    return;
}
- (NSInteger)numberOfColumns {
    return 3;
}


- (NSInteger)numberOfCells {
    return self.photos.count;
}


- (CGFloat)rateOfCache {
    return 10.0f;
}


- (IIIFlowCell *)flowView:(IIIFlowView *)flow cellAtIndex:(int)index {
    NSString *reuseId = @"CommonCell";
    IIIFlowCell *cell = [flow dequeueReusableCellWithId:reuseId];
    if (!cell) {
        cell = [[IIIFlowCell alloc] initWithReuseId:reuseId];
    }
    return cell;
}

- (IIIBaseData *)dataSourceAtIndex:(int)index {
    NSDictionary *photo = [self.photos objectAtIndex:index];
    if(nil == photo)
    {
        return nil;
    }
    
    NSArray *images = [photo objectForKey:@"images"];
    if(nil == images)
    {
        return nil;
    }
    
    NSDictionary *img = [images objectAtIndex:[images count]-1];
    
    //N
    IIIBaseData *data = [[IIIBaseData alloc]init];
    data.web_url = [img objectForKey:@"source"];

    return data;
}

- (void)downloadImageSucceed:(UIImage *)image atIndex:(int)index
{
    IIIFlowView *fv = (IIIFlowView *)self.view;
    [fv reloadData];
}

-(void)requestPhotosFromAlbum:(NSString*)albumId
{
    // Custom initialization
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%s/photos",[albumId UTF8String]] completionHandler:^(FBRequestConnection *connection, NSDictionary *user, NSError *error)
     {
         self.photos = [user objectForKey:@"data"];
         if(nil != self.photos)
         {
             IIIFlowView *fv = [[IIIFlowView alloc]initWithFrame:self.view.frame];
             fv.flowDelegate = self;
             fv.userInteractionEnabled = YES;
             self.view = fv;
             [fv release];
             [fv reloadData];
         }
     }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(id)initWithAlbumId:(NSString*)albumId
{
    self = [super init];
    if (self)
    {

        [[OT_Facebook SharedInstance]loginToFacebook:NO onCompletion:^(BOOL loginStatus)
         {
             if(YES == loginStatus)
             {
                 [self requestPhotosFromAlbum:albumId];
             }
         }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
