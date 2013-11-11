//
//  FBLikeUsView.m
//  Instapicframes
//
//  Created by Sunitha Gadigota on 7/28/13.
//
//

#import "FBLikeUsView.h"
#import "config.h"
#import "QuartzCore/CALayer.h"
#import "Utility.h"
#import "OT_Facebook.h"

@interface FBLikeUsView ()<UIWebViewDelegate>
{
    UIWebView *myWebView;
}

@end

@implementation FBLikeUsView
@synthesize delegate;
@synthesize userInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loginStatus:YES];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)handleDone
{
    if([self.delegate respondsToSelector:@selector(fbLikeUsView:willExitWithLikeStatus:)])
    {
        [self.delegate fbLikeUsView:self willExitWithLikeStatus:YES];
    }
    
    [self removeFromSuperview];
}


- (void)loginStatus:(BOOL)isSuccess
{
    if(NO == isSuccess)
    {
        return;
    }
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    /* Add toolbar */
    UIToolbar *tbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 50.0)];
    tbar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(handleDone)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    tbar.items = [NSArray arrayWithObjects:flexSpace,done, nil];
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        [tbar setBackgroundImage:[UIImage imageNamed:@"toolbar_ipad.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [tbar setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    [self addSubview:tbar];
    [tbar release];
    

    NSString *urlAddress = @"https://www.facebook.com/outthinking.india.7";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    rect = CGRectMake(rect.origin.x, rect.origin.y+tbar.frame.size.height, rect.size.width, rect.size.height-tbar.frame.size.height);
    myWebView = [[UIWebView alloc]initWithFrame:rect];
    myWebView.backgroundColor = [UIColor blackColor];
    myWebView.delegate = self;
    myWebView.tag = TAG_WEBVIEW;
    myWebView.scalesPageToFit = NO;
    
    [self addSubview:myWebView];
    
    [myWebView loadRequest:requestObj];
    [myWebView release];
    
    return;
}

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
    
    if (error.code == NSURLErrorCancelled)
    {
        return;
    }
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [myWebView loadHTMLString:errorString baseURL:nil];
}


@end
