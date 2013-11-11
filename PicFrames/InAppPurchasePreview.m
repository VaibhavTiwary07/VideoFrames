//
//  InAppPurchasePreview.m
//  Instapicframes
//
//  Created by Sunitha Gadigota on 8/10/13.
//
//

#import "InAppPurchasePreview.h"
#import <QuartzCore/CALayer.h>
#import "FTWButton.h"

#define TAG_INAPPPREVIEW_TOOLBAR        6789
#define INAPPPREVIEW_ANIMATION_DURATION 1.0
#define TAG_PURCHASE_BUTTON             1000

@interface InAppPurchasePreview()
{
}

@end

@implementation InAppPurchasePreview
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)exitInAppPurchasePreviewWithAnimation:(BOOL)animate
{
    if(animate)
    {
        CGPoint postAnimationCenter = CGPointMake(self.center.x, self.center.y-self.frame.size.height);
        [UIView animateWithDuration:INAPPPREVIEW_ANIMATION_DURATION
                         animations:^{
                             self.center = postAnimationCenter;
                         }
                         completion:^(BOOL finished){
                             if([self.delegate respondsToSelector:@selector(inAppPurchasePreviewWillExit:)])
                             {
                                 [self.delegate inAppPurchasePreviewWillExit:self];
                             }
                             [self removeFromSuperview];
                         }];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(inAppPurchasePreviewWillExit:)])
        {
            [self.delegate inAppPurchasePreviewWillExit:self];
        }
        [self removeFromSuperview];
    }
    
    return;
}

-(void)handleCancelButton:(id)sender
{
    if([self.delegate respondsToSelector:@selector(cacelDidSelectForInAppPurchasePreview:)])
    {
        [self.delegate cacelDidSelectForInAppPurchasePreview:self];
    }
    
    [self exitInAppPurchasePreviewWithAnimation:YES];
    
    return;
}

-(void)handleRestoreButton:(id)sender
{
    if([self.delegate respondsToSelector:@selector(restoreDidSelectForInAppPurchasePreview:)])
    {
        [self.delegate restoreDidSelectForInAppPurchasePreview:self];
    }
    
    [self exitInAppPurchasePreviewWithAnimation:YES];
}

-(void)showInAppPurchaseWithPackages:(NSArray*)packages
{
    if(nil == packages)
    {
        return;
    }
    
    CGRect full = [[UIScreen mainScreen]bounds];
    
    /* Allocate toolbar */
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, full.size.width, 44.0)];
    
    /* customize the look of the toolbar */
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.tag      = TAG_INAPPPREVIEW_TOOLBAR;
    [toolBar sizeToFit];
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_ipad.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    [self addSubview:toolBar];
    
    /* Add cancel and restore buttons to the toolbar */
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(handleCancelButton:)];
    UIBarButtonItem *restore = [[UIBarButtonItem alloc]initWithTitle:@"Restore" style:UIBarButtonItemStyleBordered target:self action:@selector(handleRestoreButton:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = [NSArray arrayWithObjects:cancel,space,restore,nil];
    
    float fontSize = 12;
    float x = 5.0;
    float y = 5.0;
    CGRect messageBaseRect = CGRectMake(0, toolBar.frame.size.height, toolBar.frame.size.width, 270);
    UIImageView *baseView = [[UIImageView alloc]initWithFrame:messageBaseRect];
    baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:baseView];
    baseView.userInteractionEnabled = YES;
    
    /* Allocate product ids */
    for(int index = 0; index < [packages count];index++)
    {
        NSDictionary *package = [packages objectAtIndex:index];
        UIImage *img         = [package objectForKey:key_inapppreview_package_image];
        NSString *price      = [package objectForKey:key_inapppreview_package_price];
        NSString *msgheading = [package objectForKey:key_inapppreview_package_msgheading];
        NSString *msgbody    = [package objectForKey:key_inapppreview_package_msgbody];
        
        /* Add image view to add the image */
        CGRect imgRect = CGRectMake(x, y, img.size.width, img.size.height);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:imgRect];
        imageView.image = img;
        imageView.center = CGPointMake(full.size.width/2.0, imageView.center.y);
        [baseView addSubview:imageView];
        
        y = y + imageView.frame.size.height;
        /* Add Meesage heading and body */
        CGRect messageHeadingRect = CGRectMake(x, y, full.size.width-90, 20);
        UILabel *messageHeading = [[UILabel alloc]initWithFrame:messageHeadingRect];
        messageHeading.backgroundColor = [UIColor clearColor];
        messageHeading.textColor = [UIColor blackColor];
        messageHeading.font = [UIFont boldSystemFontOfSize:fontSize];
        messageHeading.text = msgheading;
        [baseView addSubview:messageHeading];
        
        y = y + messageHeadingRect.size.height;
        
        
        CGRect messageBodyRect = CGRectMake(x, y, messageHeadingRect.size.width, 80);
        UILabel *messageBody = [[UILabel alloc]initWithFrame:messageBodyRect];
        messageBody.backgroundColor = [UIColor clearColor];
        messageBody.textColor = [UIColor blackColor];
        messageBody.font = [UIFont systemFontOfSize:fontSize];
        messageBody.text = msgbody;
        messageBody.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        /* Calculate the size of message body label */
        CGSize labelSize = [messageBody.text sizeWithFont:messageBody.font
                                    constrainedToSize:messageBody.frame.size
                                        lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat labelHeight = labelSize.height;
        int lines = [messageBody.text sizeWithFont:messageBody.font
                             constrainedToSize:messageBody.frame.size
                                 lineBreakMode:NSLineBreakByWordWrapping].height /8;
        messageBody.numberOfLines = lines;
        messageBody.frame = CGRectMake(x, y, messageHeadingRect.size.width, labelHeight);
        [baseView addSubview:messageBody];
        
        FTWButton *purchase = [[FTWButton alloc] init];
        purchase.frame = CGRectMake(x+messageBodyRect.size.width, messageBodyRect.origin.y, 80, 30);
        [purchase addBlueStyleForState:UIControlStateNormal];
        [purchase setInnerShadowColor:[UIColor colorWithRed:200.0f/255 green:250.0f/255 blue:253.0f/255 alpha:1.0f] forControlState:UIControlStateNormal];
        [purchase setInnerShadowRadius:2.0f forControlState:UIControlStateNormal];
        [purchase setText:price forControlState:UIControlStateNormal];
        [purchase setText:price forControlState:UIControlStateSelected];
        purchase.textAlignment = NSTextAlignmentCenter;
        purchase.center = CGPointMake(purchase.center.x, messageBody.center.y);
        [baseView addSubview:purchase];
        purchase.tag = TAG_PURCHASE_BUTTON + index;
        [purchase addTarget:self action:@selector(handlePurchase:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"Messagebody.frame.size.height %f lines %d labelheight %f",messageBody.frame.size.height,lines,labelHeight);
        y = y + messageBody.frame.size.height;
    }
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        y = y + 20;
    }
    baseView.frame = CGRectMake(baseView.frame.origin.x, baseView.frame.origin.y, baseView.frame.size.width, y);
    CGPoint postAnimationCenter = self.center;
    CGPoint preAnimationCenter  = CGPointMake(self.center.x, self.center.y-self.frame.size.height);
    self.center = preAnimationCenter;
    [UIView animateWithDuration:INAPPPREVIEW_ANIMATION_DURATION
                     animations:^{
                         self.center = postAnimationCenter;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)handlePurchase:(FTWButton*)purchase
{
    if(nil == purchase)
    {
        return;
    }
    
    int index = purchase.tag - TAG_PURCHASE_BUTTON;
    if([self.delegate respondsToSelector:@selector(inAppPurchasePreview:itemPurchasedAtIndex:)])
    {
        [self.delegate inAppPurchasePreview:self itemPurchasedAtIndex:index];
    }
    
    [self exitInAppPurchasePreviewWithAnimation:YES];
}

- (void)showInAppPreviewWithimage:(UIImage*)img
                            price:(NSString*)price
                          heading:(NSString*)heading
                      description:(NSString*)description
{
    CGRect full = [[UIScreen mainScreen]bounds];
    
    /* Allocate toolbar */
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, full.size.width, 44.0)];
    
    /* customize the look of the toolbar */
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.tag      = TAG_INAPPPREVIEW_TOOLBAR;
    [toolBar sizeToFit];
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_ipad.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    [self addSubview:toolBar];
    
    /* Add cancel and restore buttons to the toolbar */
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(handleCancelButton:)];
    UIBarButtonItem *restore = [[UIBarButtonItem alloc]initWithTitle:@"Restore" style:UIBarButtonItemStyleBordered target:self action:@selector(handleRestoreButton:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = [NSArray arrayWithObjects:cancel,space,restore,nil];
    
    /* Now add preview body, body will have below format
       Image
       Message Header
       Message Body     Buy button
       Message Body 
     
     Views
     Baseview to hold the body
     Image view to add the image to the baseview
     UILabel to add the message header
     UILabel to add message body
     UIButton to add purchase button
     
     */
    CGRect messageBaseRect = CGRectMake(0, toolBar.frame.size.height, toolBar.frame.size.width, 270);
    UIImageView *baseView = [[UIImageView alloc]initWithFrame:messageBaseRect];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.userInteractionEnabled = YES;
    
    /* Add image view to add the image */
    UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
    imageView.center = CGPointMake(full.size.width/2.0, imageView.center.y);
    [baseView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    /* Add Meesage heading and body */
    float fontSize = 12;
    CGRect messageHeadingRect = CGRectMake(5, imageView.frame.size.height, full.size.width-90, 20);
    UILabel *messageHeading = [[UILabel alloc]initWithFrame:messageHeadingRect];
    messageHeading.backgroundColor = [UIColor clearColor];
    messageHeading.textColor = [UIColor blackColor];
    messageHeading.font = [UIFont boldSystemFontOfSize:fontSize];
    messageHeading.text = heading;
    [baseView addSubview:messageHeading];
    
    CGRect messageBodyRect = CGRectMake(5, messageHeadingRect.origin.y+messageHeadingRect.size.height, messageHeadingRect.size.width, 60);
    UILabel *messageBody = [[UILabel alloc]initWithFrame:messageBodyRect];
    messageBody.backgroundColor = [UIColor clearColor];
    messageBody.textColor = [UIColor blackColor];
    messageBody.font = [UIFont systemFontOfSize:fontSize];
    messageBody.text = description;
    messageBody.numberOfLines = 4;
    messageBody.lineBreakMode = NSLineBreakByWordWrapping;
    [baseView addSubview:messageBody];
    [self addSubview:baseView];
    
    FTWButton *purchase = [[FTWButton alloc] init];
    purchase.frame = CGRectMake(messageBodyRect.origin.x+messageBodyRect.size.width, messageBodyRect.origin.y, 80, 30);
    [purchase addBlueStyleForState:UIControlStateNormal];
    [purchase setInnerShadowColor:[UIColor colorWithRed:200.0f/255 green:250.0f/255 blue:253.0f/255 alpha:1.0f] forControlState:UIControlStateNormal];
    [purchase setInnerShadowRadius:2.0f forControlState:UIControlStateNormal];
    [purchase setText:price forControlState:UIControlStateNormal];
    [purchase setText:price forControlState:UIControlStateSelected];
    purchase.textAlignment = NSTextAlignmentCenter;
    purchase.center = CGPointMake(purchase.center.x, messageBody.center.y);
    [baseView addSubview:purchase];
    
    CGPoint postAnimationCenter = self.center;
    CGPoint preAnimationCenter  = CGPointMake(self.center.x, self.center.y-self.frame.size.height);
    self.center = preAnimationCenter;
    [UIView animateWithDuration:INAPPPREVIEW_ANIMATION_DURATION
                     animations:^{
                         self.center = postAnimationCenter;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    return;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
