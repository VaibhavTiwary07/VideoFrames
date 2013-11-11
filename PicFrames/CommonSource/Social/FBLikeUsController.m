//
//  FBLikeUsController.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 10/16/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "FBLikeUsController.h"


@implementation FBLikeUsController

@synthesize myWebView;

#define kLeftMargin             20.0
#define kTopMargin              20.0
#define kRightMargin            20.0
#define kTweenMargin            6.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    myWebView.delegate = nil;
    [myWebView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)loginStatus:(BOOL)isSuccess
{
    if(NO == isSuccess)
    {
        
        return;
    }
    
    NSString *likeButtonIframe = applicationlikebuttonurlFull;
    NSString *likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIframe];
    UIWebView *_webview;
    
    self.title = NSLocalizedString(@"LIKEUS", @"Like Us");
    
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    _webview = [[UIWebView alloc]initWithFrame:/*CGRectMake(0.0, 0.0, 320.0, 440.0)*/rect];
    [_webview loadHTMLString:likeButtonHtml baseURL:[NSURL URLWithString:@""]];
    _webview.backgroundColor = [UIColor blackColor];
    _webview.delegate = self;
    _webview.tag = TAG_WEBVIEW;
    
    self.myWebView = _webview;
    self.myWebView.scalesPageToFit = NO;
    [_webview release];

    [self.view addSubview:self.myWebView];
    
    return;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fbmgr *mg = [fbmgr Instance];
    if(mg._isLoggedIn == NO)
    {
        mg.fbDelegate = self;
        [mg login];
        return;
    }
    
    NSString *likeButtonIframe = applicationlikebuttonurlFull;
    NSString *likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIframe];
    UIWebView *_webview;
    
    self.title = NSLocalizedString(@"LIKEUS", @"Like Us");
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    _webview = [[UIWebView alloc]initWithFrame:/*CGRectMake(0.0, 0.0, 320.0, 440.0)*/rect];
    [_webview loadHTMLString:likeButtonHtml baseURL:[NSURL URLWithString:@""]];
    _webview.backgroundColor = [UIColor blackColor];
    _webview.delegate = self;
    _webview.tag = TAG_WEBVIEW;
    
    self.myWebView = _webview;
    self.myWebView.scalesPageToFit = NO;
    [_webview release];

    [self.view addSubview:self.myWebView];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // release and set to nil
    self.myWebView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.myWebView.delegate = self; // setup the delegate as the web view is shown
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.myWebView stopLoading];   // in case the web view is still loading its content
    self.myWebView.delegate = nil;  // disconnect the delegate as the webview is hidden
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [Utility addActivityIndicatotTo:webView withMessage:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [Utility removeActivityIndicatorFrom:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [self.myWebView loadHTMLString:errorString baseURL:nil];
}

@end
