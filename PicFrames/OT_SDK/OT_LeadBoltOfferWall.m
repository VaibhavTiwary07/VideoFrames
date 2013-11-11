//
//  OT_LeadBoltOfferWall.m
//  animal_sounds
//
//  Created by Sunitha Gadigota on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OT_LeadBoltOfferWall.h"

@interface OT_LeadBoltOfferWall ()

@end

@implementation OT_LeadBoltOfferWall

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)removeActivityIndicatorFrom:(UIView*)view
{
    MBProgressHUD *activity = (MBProgressHUD*)[view viewWithTag:1001];
    if(nil != activity)
    {
        [activity removeFromSuperview];
        [activity release];
        activity = nil;
    }
    
    return;
}

-(void)addActivityIndicatotTo:(UIView*)view withMessage:(NSString*)msg;
{
    [self removeActivityIndicatorFrom:view];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
	
    //HUD.delegate = self;
    HUD.labelText = msg;
    HUD.tag       = 1001;
    
    [HUD show:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self addActivityIndicatotTo:self.view withMessage:@"Loading"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeActivityIndicatorFrom:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeActivityIndicatorFrom:self.view];
}

-(void)closeTheOfferWall
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    CGRect fullscreen = [[UIScreen mainScreen]bounds];
    
    UIWebView *pBgnd = [[UIWebView alloc]initWithFrame:CGRectMake(fullscreen.origin.x, fullscreen.origin.y, fullscreen.size.width, fullscreen.size.height)];
    pBgnd.tag = 1000;
    pBgnd.delegate = self;

    [self.view addSubview:pBgnd];
    NSURL *appwallUrl = [NSURL URLWithString:ot_lb_offerwall];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:appwallUrl];
    [pBgnd loadRequest:requestObj];
    [pBgnd release];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeTheOfferWall)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
