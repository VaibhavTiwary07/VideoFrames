//
//  UpgradeOptions.m
//  MirroFx
//
//  Created by Vijaya kumar reddy Doddavala on 10/19/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "UpgradeOptions.h"
#import "InAppPurchaseManager.h"

@interface UpgradeOptions()
{
#if OLD_INAPP
    InAppPurchaseManager *_App;
#endif
    NSArray *_prdIds;
    PopoverView *_popover;
}

@property(nonatomic,retain)NSArray *_products;
@end

@implementation UpgradeOptions
@synthesize _products;

#define EDITOR_DEFAULT_COLOR ([UIColor colorWithRed:(44.0f/256.0f) green:(44.0f/256.0f) blue:(44.0f/256.0f) alpha:1.0])

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(receiveProducts:)
                                                    name:kInAppPurchaseManagerProductsFetchedNotification
                                                  object:nil];
#if OLD_INAPP
        _App = [[InAppPurchaseManager alloc]init];
        [_App loadStore];
#else
        [[InAppPurchaseManager Instance]loadStore];
#endif
        [Utility addActivityIndicatotTo:self withMessage:@"Loading"];
        //_prdIds = [[NSArray alloc]initWithObjects:kLi, nil
        //self.backgroundColor = EDITOR_DEFAULT_COLOR;
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(purhcaseSuccess:)
                                                    name:kInAppPurchaseManagerTransactionSucceededNotification
                                                  object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(purhcaseFailed:)
                                                    name:kInAppPurchaseManagerTransactionFailedNotification
                                                  object:nil];
        _popover = nil;
    }
    return self;
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"popoverView: didSelectItemAtIndex %ld",index);
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    NSLog(@"popoverViewDidDismiss");
    //[self release];
}

-(void)showPopupIn:(UIView*)v at:(CGPoint)point
{
    _popover = [[PopoverView alloc]init];
    
    //[_popover showAtPoint:point inView:v withContentView:self delegate:self];
    
    _popover.delegate = self;
    [_popover showAtPoint:point inView:v withContentView:self];
   // [_popover release];
}

-(void)dealloc
{
#if OLD_INAPP
    [_App release];
#endif
    self._products = nil;
    _popover = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    //[super dealloc];
}

-(void)buyProduct:(id)sender
{
    UIButton *btn = sender;
    SKProduct *prd = [self._products objectAtIndex:btn.tag];
#if OLD_INAPP
    [_App puchaseProductWithId:prd.productIdentifier];
#else
    [[InAppPurchaseManager Instance]puchaseProductWithId:prd.productIdentifier];
#endif
}

-(void)purhcaseFailed:(NSNotification*)notif
{
    
}

-(void)purhcaseSuccess:(NSNotification*)notif
{
    [self reloadProducts];
}

-(void)restorePurchase:(id)sender
{
#if OLD_INAPP
    [_App restoreProUpgrade];
#else
    [[InAppPurchaseManager Instance]restoreProUpgrade];
#endif
}

-(void)reloadProducts
{
    NSArray *sViews = self.subviews;
    
    [Utility addActivityIndicatotTo:self withMessage:@"Reloading"];
    
    for(int index = 0; index < sViews.count; index++)
    {
        UIView *v = [sViews objectAtIndex:index];
        [v removeFromSuperview];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadProducts:) userInfo:nil repeats:NO];
}

-(void)loadProducts:(NSTimer*)timer
{
    float x = 10.0;
    float y = 10.0;
    float height = 40.0;
    UIFont *fnt = [UIFont boldSystemFontOfSize:15.0];
    UIColor *btnColor = [UIColor colorWithRed:0.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    for(int index = 0; index < self._products.count; index++)
    {
        SKProduct *prd = [self._products objectAtIndex:index];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 200.0, height)];
        lbl.backgroundColor = [UIColor clearColor];
        
        lbl.text = [NSString stringWithFormat:@"%@ (%@)",prd.localizedTitle,prd.localizedPrice];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = fnt;
        [self addSubview:lbl];
      //  [lbl release];
        
        /* Show Buy button if the user didn't buy the product yet */
        if(bought_fullversion)
        {
            /* Add tick mark */
            UIImageView *tick = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-62, y, 32, 32)];
            tick.image = [UIImage imageNamed:@"tick.png"];
            [self addSubview:tick];
          //  [tick release];
            y = y + height;
            continue;
        }
        
        
        UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
        buy.frame = CGRectMake(self.frame.size.width-70, y+5, 50, height-10);
        [buy setTitle:@"Buy" forState:UIControlStateNormal];
        buy.backgroundColor = btnColor;
        buy.layer.cornerRadius = 15.0f;
        buy.layer.borderColor = [UIColor whiteColor].CGColor;
        buy.layer.borderWidth = 1.0;
        buy.tag = index;
        [buy addTarget:self action:@selector(buyProduct:) forControlEvents:UIControlEventTouchDown];
        
        [buy.titleLabel setFont:fnt];
        [buy.titleLabel setTextColor:[UIColor whiteColor]];
        
        [self addSubview:buy];
        
        y = y + height;
    }
    
    if(self._products.count == 0)
    {
        /* Add products by our self */
        
    }
    
    UILabel *restoreLbl = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 220.0, height)];
    restoreLbl.text = @"Restore the purchases";
    restoreLbl.font = fnt;
    restoreLbl.backgroundColor = [UIColor clearColor];
    restoreLbl.textColor = [UIColor whiteColor];
    
    UIButton *restore = [UIButton buttonWithType:UIButtonTypeCustom];
    restore.frame = CGRectMake(self.frame.size.width-70, y+5, 70, height-10);
    [restore setTitle:@"Restore" forState:UIControlStateNormal];
    restore.backgroundColor = btnColor;
    restore.layer.cornerRadius = 15.0f;
    restore.layer.borderColor = [UIColor whiteColor].CGColor;
    restore.layer.borderWidth = 1.0;
    
    [restore.titleLabel setFont:fnt];
    [restore.titleLabel setTextColor:[UIColor whiteColor]];
    restore.center = CGPointMake(self.frame.size.width-70+25,restore.center.y);
    [self addSubview:restoreLbl];
  //  [restoreLbl release];
    [self addSubview:restore];
    
    [restore addTarget:self action:@selector(restorePurchase:) forControlEvents:UIControlEventTouchDown];
    
    [Utility removeActivityIndicatorFrom:self];
}

-(void)receiveProducts:(NSNotification*)notif
{
    if([notif.name isEqualToString:kInAppPurchaseManagerProductsFetchedNotification])
    {
        self._products = [notif.userInfo objectForKey:key_inappproducts];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadProducts:) userInfo:nil repeats:NO];
    }
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
