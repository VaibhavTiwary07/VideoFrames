//
//  SimpleSubscriptionView.m
//  VideoEditor
//
//  Created by PAVANIOS on 16/06/21.
//  Copyright © 2021 D.Yoganjulu  Reddy. All rights reserved.
//

#import "SimpleSubscriptionView.h"
#import "Config.h"
#import "LoadingClass.h"
#import "Reachability.h"
#import "UIButton+Animation.h"
//#define topBarHeight    ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?44.0:44.0)
//#define customBarHeight ((UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)?44.0:49.0)
#define back_image          (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? @"back": @"back")
@interface SimpleSubscriptionView()


{
    NSString *firstsubscriptionPrice,*firstsubscriptionPriceYearly,*firstsubscriptionPriceWeekly;
    long TrailPeriodDays;
    long TrailPeriodDaysYearly;
    long TrailPeriodDaysWeekly;
    CGRect features_frame;
    UIImageView * features;
    NSString *TrailPeriodDaysConv;
    float centerX;
    float textviewWidth;
    float buttonViewWidth;
    float buttonViewHeight;
    float heightOffset;
    UIScrollView *scrollview;
    float dividing_Factor;
    UIImageView *subscriptionView;
    float buttonLableFontSize;
    NSUserDefaults *SuccessStatus;

    BOOL purchasedHere;
    UIView *loadingBg;
    UIButton *closeLoading;

    Reachability *internetReach;

    RadioButton *yearlySelection,*monthlySelection,*weeklySelection;
    UIButton *continueButton,*freeTrialButton,*starButtonView;
    NSInteger subscriptionTag;


    UIView *yearlyViewBg;
    UILabel * freetrialTextLabel,*billingTextLabel,*cancelTextLabel;
    UIPageControl *pageControlView;
    NSMutableArray *pageViewContent;
    UIImageView *spinImageView;
    bool rotateSpin;
    UILabel *discountLabel;

    UIView *gradienViewContinue;

    //Collapsing ToolBar Here//

    UIView *toolbarView;
    CGFloat initialToolbarHeight;
    CGFloat  minimumToolbarHeight;
    CGFloat initialYPosition;
    CGFloat minimumYPosition;

    CGFloat parallaxFactor;

    UILabel *subscriptionTitleSmall;
    UILabel *subscriptionTitle;
    
    UIView *topStrip1;
    
    UIButton *backButton,*collapseBack;
}
@property(nonatomic, strong) UILabel *shrinkLabel;
@property(nonatomic, strong) UIView *hiddenView;
// Declare a property for the background task identifier
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;
@end

@implementation SimpleSubscriptionView

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self SubscriptionDetailsYearly];
    [self SubscriptionDetailsWeekly];
    [self SubscriptionDetails];

    //[self loadAnimation];
   // [self lottieAnimationView];
    NSLog(@"View did Appear---");
}



- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    

//    self.exampleDatas = [NSMutableArray new];
//
//
//    GSKExampleData *firstExample = [GSKExampleData dataWithTitle:@"First example (classical Frame Layout)"
//                                                 headerViewClass:[GSKTestStretchyHeaderView class]];
//    firstExample.headerViewInitialHeight = 200;
//
//    self.exampleDatas = @[firstExample];
//
//
//    NSLog(@"Array description is %@",self.exampleDatas.description);

    pageViewContent = [NSMutableArray new];
    pageViewContent = [NSMutableArray arrayWithObjects:@"Extract audio from videos to capture hidden melodies.", @"Craft your ideal sound with the audio cutter feature.",@"Perfectly shape your audio with ease using audio trimmer.",@"Combine audio tracks smoothly with the help of audio merger.", nil];

    [self gettingPurchasedOrNot];
    [self gettingSubscriptionModeCount];

    internetReach = [Reachability reachabilityForInternetConnection];

    purchasedHere = NO;
    SuccessStatus = [NSUserDefaults standardUserDefaults];
    [self AddingScrollview];
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        buttonLableFontSize = 22;
    else if(fullScreen.size.height == 568.0)
        buttonLableFontSize = 13;
    else buttonLableFontSize = 15;

    NSLog(@"width %f, height %f",fullScreen.size.width,fullScreen.size.height);
    centerX = fullScreen.size.width/2;
   // buttonViewWidth = fullScreen.size.width-fullScreen.size.width/12;
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        buttonViewWidth = fullScreen.size.width-fullScreen.size.width/4-fullScreen.size.width/6;
       // buttonViewWidth = fullScreen.size.width-fullScreen.size.width/4;
        buttonViewHeight = fullScreen.size.height/12;
    }
    else
    {
        buttonViewWidth = fullScreen.size.width-fullScreen.size.width/4-fullScreen.size.width/6;
        buttonViewHeight = fullScreen.size.height/10;
    }


    heightOffset = fullScreen.size.height/32;

    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        dividing_Factor = 1.75f;
    else dividing_Factor = 1.15f;
    textviewWidth = fullScreen.size.width/dividing_Factor;
    //------------In App Details------//
    [self SubscriptionDetailsYearly];
    [self SubscriptionDetailsWeekly];
    [self SubscriptionDetails];
    [self allocateResourcesForTopToolBar];

    [self placingTextViewforDescription];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideActivityIndicatorPurchase) name:@"closeIndicator" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideActivityIndicatorForRestore) name:@"closeRestore" object:nil];
  //  [self PlacingSubscriptionValues];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkingInternetConnection) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closingSubscriptionPage) name:@"removeSubscriptionPage" object:nil];
   
    backgroundview.userInteractionEnabled = YES;
    scrollview.userInteractionEnabled = YES;
    
    scrollview.exclusiveTouch = YES;
    scrollview.delaysContentTouches = true;
    
 //  scrollview.panGestureRecognizer.delaysTouchesBegan = scrollview.delaysContentTouches;



}

#pragma mark scrollviewTouches

//- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
//    NSLog(@"calling this method----");
//    if ([view isKindOfClass:[UIControl class]]) return YES;
//    return NO;
//}

-(void)AddingScrollview
{
    if (@available(iOS 11.0, *))
    {
        if (SafeAreaTopPadding > 0)
        {
            
            scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,backgroundview.frame.origin.y-(SafeAreaTopPadding*1.5), self.view.frame.size.width, self.view.frame.size.height)];
        }
        else
        {
            scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
        }
    }
    else
    {
            scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    }
    scrollview.delegate = self; // added newly //
       float viewcount= 2;
       for(int i = 0; i< viewcount; i++) {
          CGFloat y = i * self.view.frame.size.height;
           backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, y-self.view.frame.size.height,self.view.frame.size.width, self .view.frame.size.height*2.5)];
           backgroundview.backgroundColor = [UIColor whiteColor];
           backgroundview.userInteractionEnabled = YES;
          [scrollview addSubview:backgroundview];
       }
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *viewcount);
   scrollview.userInteractionEnabled = YES;
   scrollview.canCancelContentTouches = YES;
    scrollview.delaysContentTouches = NO;
   scrollview.clipsToBounds = YES;
    [self.view addSubview:scrollview];

    // RadioButtinView //

   // [self createRadioButtonUI];

}

- (void)allocateResourcesForTopToolBar
{
    UIView *topToolBar = [[UIView alloc] init];
    topToolBar.backgroundColor=PHOTO_DEFAULT_COLOR;
    topToolBar . frame = CGRectMake(0, 0, fullScreen.size.width, topBarHeight);


    topToolBar . userInteractionEnabled = YES;
    subscriptionView = [[UIImageView alloc] init];
    subscriptionView . userInteractionEnabled = YES;
    subscriptionView . backgroundColor = [UIColor clearColor];
    subscriptionView.layer.shadowColor=[UIColor blueColor].CGColor;
    subscriptionView.layer.shadowColor   = [UIColor blackColor].CGColor;
    subscriptionView.layer.shadowOffset  = CGSizeMake(2.0, 2.0);
//    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
//    {
//        subscriptionView . frame = CGRectMake(0.0,0.0, fullScreen.size.width,fullScreen.size.height);
//    }
//    else
//    {
//        subscriptionView. frame = CGRectMake(0.0,0.0, fullScreen.size.width,fullScreen.size.height);
//    }
    subscriptionView.frame = CGRectMake(0.0,0.0, fullScreen.size.width,fullScreen.size.height*1.75);
  //  subscriptionView.contentMode = UIViewContentModeScaleAspectFill;
    subscriptionView.userInteractionEnabled= YES;
    subscriptionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    [backgroundview addSubview:subscriptionView];

   // subscriptionView.image = [UIImage imageNamed:@"doublesize_bg"]; //@"ipad_bg.jpg"] doublesize_bg.jpg



    backButton = [[UIButton alloc]init];
    backButton.frame = CGRectMake(0, 0, backButtonWidthHeight,backButtonWidthHeight);
    backButton.center = CGPointMake(backButton.bounds.size.width/2+(1*buttonPlacementOffset),backButton.bounds.size.height/2+(1*toolBarOffset)+SafeAreaTopPadding);

//    [backButton setImage:[UIImage imageNamed:@"Back_image.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"close_watermark"] forState:UIControlStateNormal];
//    backButton.showsTouchWhenHighlighted = true;
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
   // [bannerImageview addSubview:backButton];
}


- (void)goBack
{
    NSLog(@"Going Back");
    
    NSInteger dismissValue = [[NSUserDefaults standardUserDefaults]integerForKey:@"DismissSubscription"];

    NSLog(@"dismissValue is %ld",(long)dismissValue);
    
    
    
  //  [[SRSubscriptionModelNew shareKit]loadProducts]; // newly added here //
   
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"DismissSubscription"];
    if(dismissValue<1)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        
        [self dismissCurrentpage];
    }
   
}

-(void)dismissCurrentpage
{
    NSLog(@"closed subscription---");
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)ResoreSubscription
{
    [[SRSubscriptionModel shareKit]restoreSubscriptions];
    [self showLoadingForRestore];
}

-(void)Privacypolicy:(UIButton*)button
{
    NSURL *URL = [NSURL URLWithString: @"https://www.outthinkingindia.com/privacy-policy/"];
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
}


-(void)TermsofCondition
{
    NSURL *URL = [NSURL URLWithString: @"https://www.outthinkingindia.com/terms-of-use/"];
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
}

-(void)buyWeeklySubscription
{
    if([internetReach currentReachabilityStatus] == NotReachable)
    {
        [self showAlertForInternetConnection];
    }
    else
    {
    NSLog(@"Purchase Subscription for montly ---------");
    [[SRSubscriptionModel shareKit]makePurchase:kInAppPurchaseSubScriptionPackWeekly];
    NSLog(@"subscription---------");
    NSLog(@"Details of subscrption Product---------%@",[SRSubscriptionModel shareKit].currentProduct);
    NSLog(@"Details of subscrption---------%hhd",[SRSubscriptionModel shareKit].currentIsActive);

    NSLog(@"Product details %@",[SRSubscriptionModel shareKit].availableProducts);

    NSLog(@"Product details**** %@",[SRSubscriptionModel shareKit].currentProduct.allValues);

    NSLog(@"Product details***$$$$%@",[SRSubscriptionModel shareKit].availableProducts.description.propertyList);
    [self showLoadingForPurchase];
    }
}


-(void)buyMonthlySubscription
{
    if([internetReach currentReachabilityStatus] == NotReachable)
    {
        [self showAlertForInternetConnection];
    }
    else
    {
    NSLog(@"Purchase Subscription for montly ---------");
    [[SRSubscriptionModel shareKit]makePurchase:kInAppPurchaseSubScriptionPack];
    NSLog(@"subscription---------");
    NSLog(@"Details of subscrption Product---------%@",[SRSubscriptionModel shareKit].currentProduct);
    NSLog(@"Details of subscrption---------%hhd",[SRSubscriptionModel shareKit].currentIsActive);

    NSLog(@"Product details %@",[SRSubscriptionModel shareKit].availableProducts);

    NSLog(@"Product details**** %@",[SRSubscriptionModel shareKit].currentProduct.allValues);

    NSLog(@"Product details***$$$$%@",[SRSubscriptionModel shareKit].availableProducts.description.propertyList);
    [self showLoadingForPurchase];
    }
}

-(void)PurchaseSubscriptionYearly
{
    if([internetReach currentReachabilityStatus] == NotReachable)
    {
        [self showAlertForInternetConnection];
    }
    else
    {
    NSLog(@"Purchase Subscription Yearly ---------");
    [[SRSubscriptionModel shareKit]makePurchase:kInAppPurchaseSubScriptionPackYearly];
    NSLog(@"subscription---------");
    NSLog(@"Details of subscrption Product---------%@",[SRSubscriptionModel shareKit].currentProduct);
    NSLog(@"Details of subscrption---------%hhd",[SRSubscriptionModel shareKit].currentIsActive);

    NSLog(@"Product details %@",[SRSubscriptionModel shareKit].availableProducts);

    NSLog(@"Product details**** %@",[SRSubscriptionModel shareKit].currentProduct.allValues);

    NSLog(@"Product details***$$$$%@",[SRSubscriptionModel shareKit].availableProducts.description.propertyList);
    [self showLoadingForPurchase];
    }
}

- (void)performRotationAnimated
{
    rotateSpin = true;
    [UIView animateWithDuration:3.5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{

        self->spinImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
                     completion:^(BOOL finished){

        [UIView animateWithDuration:3.5
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{

            self->spinImageView.transform = CGAffineTransformMakeRotation(0);
        }
                         completion:^(BOOL finished){

            if (self->rotateSpin) {

                [self performRotationAnimated];
            }
        }];
    }];
}

-(void)placingTextViewforDescription
{
    NSArray *stringArray = @[@"Ad-free experience",
                             @"Access to premium features",
                             @"Access to all content"
    ];

    NSString *freeText = @"Free ";
    NSString *trailPeriodDaysText = [NSString stringWithFormat:@"%ld", TrailPeriodDays];
    NSString *day_Trial_Then = @"day trial,Then";
    NSString *weekText = @"/week";
    NSString *monthText = @"/month";
    NSString *yearText = @"/year";
    NSLog(@"Subscription-----$$$$$ %@",firstsubscriptionPrice);
    NSLog(@"Subscription-----$$$$$ %@",firstsubscriptionPriceWeekly);
    NSLog(@"Subscription-----$$$$$ %@",firstsubscriptionPriceYearly);

    //collapsingView

    toolbarView = [[UIView alloc]init];
    toolbarView.frame = CGRectMake(0,0, fullScreen.size.width, fullScreen.size.height/4);
    //  bannerImageview.frame = CGRectMake(0,0, textviewWidth+20, fullScreen.size.height/4);

    toolbarView.center = CGPointMake(centerX, fullScreen.size.height/6); //fullScreen.size.height/6
    //    bannerImageview.backgroundColor = [UIColor lightGrayColor];

    toolbarView.contentMode = UIViewContentModeScaleAspectFill;
   // [self.view addSubview:toolbarView];


   //CollapsingView//

   // [self collapsingView]; //newly added here//



    bannerImageview = [[UIImageView alloc]init];
    bannerImageview.frame = CGRectMake(0,0, fullScreen.size.width, fullScreen.size.height/4);
    //  bannerImageview.frame = CGRectMake(0,0, textviewWidth+20, fullScreen.size.height/4);

    bannerImageview.center = CGPointMake(centerX, fullScreen.size.height/6); //fullScreen.size.height/6
    //    bannerImageview.backgroundColor = [UIColor lightGrayColor];
    bannerImageview.image = [UIImage imageNamed:@"banner_Image2"];
    bannerImageview.contentMode = UIViewContentModeScaleAspectFill;
    //[toolbarView addSubview:bannerImageview];
    [backgroundview addSubview:bannerImageview];
    //[self.view addSubview:bannerImageview];


    initialToolbarHeight = bannerImageview.frame.size.height;
    initialYPosition =  bannerImageview.frame.origin.y;
    minimumYPosition = 50;
    minimumToolbarHeight = 100;


    CAGradientLayer *gradient = [CAGradientLayer layer];

    gradient.frame = CGRectMake(0, fullScreen.size.height/6, fullScreen.size.width, fullScreen.size.height/4);

    gradient.colors = @[(id)[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.0f].CGColor, (id)[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.6f].CGColor,(id)[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5f].CGColor,(id)[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor];

   // [bannerImageview.layer insertSublayer:gradient atIndex:0];


    subscriptionTitle = [[UILabel alloc] init];
    subscriptionTitle.frame = CGRectMake(0,0, textviewWidth+20, 80);
    
    if (@available(iOS 11.0, *))
    {
        if (SafeAreaTopPadding > 0)
        {
            subscriptionTitle.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.bounds.size.height/4+bannerImageview.bounds.size.height/10);
        }
        else
        {
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                subscriptionTitle.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.bounds.size.height/2+bannerImageview.bounds.size.height/6);
            }
            else
            {
                subscriptionTitle.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.bounds.size.height/2-bannerImageview.bounds.size.height/8);
            }
            
        }
    }
        else
        {
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                subscriptionTitle.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.bounds.size.height/2+bannerImageview.bounds.size.height/6);
            }
            else
            {
                subscriptionTitle.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.bounds.size.height/2-bannerImageview.bounds.size.height/8);
            }
        }

    subscriptionTitle.textAlignment = NSTextAlignmentCenter;
    subscriptionTitle.backgroundColor = [UIColor clearColor];
    subscriptionTitle.shadowOffset = CGSizeMake(0, 1);
    subscriptionTitle.textColor = [UIColor blackColor];
    subscriptionTitle.text = @"Subscription";
    
   // subscriptionTitle.strokeColor = kStrokeColor;
   // subscriptionTitle.strokeSize = kStrokeSize;
   // subscriptionTitle.shadowColor = [UIColor blackColor];
    
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        [subscriptionTitle setFont:[UIFont fontWithName:@"Lora-Italic" size:35.0]];
    else
        [subscriptionTitle setFont:[UIFont fontWithName:@"Lora-Italic" size:30.0]];
    [bannerImageview addSubview:subscriptionTitle];
    //[self.view addSubview:subscriptionTitle];



    [self continuePurchaseUI];


    // banner_Image //

    UITextView *subcriptionContent;
    UILabel *subscriptionTitleLable;

    NSString *startString;

    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        startString = @"Start Now , ";
    }
    else
    {
        startString = @"    Start Now ";
       // startString = @"Start Now \n";
    }

    if (TrailPeriodDaysYearly>=0) {
        
        if(self.subCountIs == 3)
        {
//        if(self.purchasedCountIs<=0 || self.subCountIs == 1)
//        {

            //Yearly subscription
            purchaseYearButton = [[RadioButton alloc]init];
          //  purchaseYearButton.showsTouchWhenHighlighted = true;
            if(self.purchasedCountIs<1)
            {
                purchaseYearButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4 ,buttonViewHeight);
            }
            else
            {
               // purchaseYearButton.frame = CGRectMake(0, 0, buttonViewWidth,buttonViewHeight);
                purchaseYearButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4,buttonViewHeight);
               // purchaseYearButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4,50);
            }
          //
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
//                purchaseYearButton.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.frame.size.height*2-bannerImageview.frame.size.height/4);
                purchaseYearButton.center = CGPointMake(centerX, _pagerView.center.y+_pagerView.frame.size.height/2+buttonViewHeight/2);
                purchaseYearButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                purchaseYearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;

            }

            else
            {
//                purchaseYearButton.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.frame.size.height*2);

                purchaseYearButton.center = CGPointMake(centerX, _pagerView.center.y+_pagerView.frame.size.height/2+buttonViewHeight/2);


            }
            purchaseYearButton.layer.cornerRadius =25;
            [purchaseYearButton setBackgroundColor:[UIColor clearColor]];
            [purchaseYearButton addTarget:self action:@selector(onRadioButtonValueWithUIButton:) forControlEvents:UIControlEventTouchUpInside];
            [purchaseYearButton setImage:[UIImage imageNamed:@"subscription_Selected_Bg"] forState:UIControlStateNormal];
//            purchaseYearButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 30, 30);


//            purchaseYearButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
           // [purchaseYearButton setBackgroundColor:[UIColor linkColor]];
            //PurchaseSubscriptionYearly - method //
            [backgroundview addSubview:purchaseYearButton];
            purchaseYearButton.tag = 500;
            //[purchaseYearButton bringSubviewToFront:backgroundview];


            UILabel *purchaseyearLable = [[UILabel alloc] init];
            purchaseyearLable.frame = purchaseYearButton.bounds;
            purchaseyearLable.backgroundColor = [UIColor clearColor];
            purchaseyearLable.shadowOffset = CGSizeMake(0, 1);
            purchaseyearLable.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
            purchaseyearLable.textAlignment = NSTextAlignmentCenter;
            purchaseyearLable.numberOfLines = 0;
            purchaseyearLable.font = [UIFont fontWithName:@"Lora-Regular" size:12.0];

            NSString *trailPeriodDaysYearlyText = [NSString stringWithFormat:@"%ld", TrailPeriodDaysYearly];
            if (TrailPeriodDaysYearly>0) {

                if(self.purchasedCountIs>0)
                {
                   purchaseyearLable.text = [NSString stringWithFormat: @"%@%@%@",startString, firstsubscriptionPriceYearly,yearText];
                }
                else
                {
                     purchaseyearLable.text = [NSString stringWithFormat: @"%@ %@ %@ \n %@%@", freeText,trailPeriodDaysYearlyText,day_Trial_Then, firstsubscriptionPriceYearly,yearText];
                }
            }
            else
            {
                purchaseyearLable.text = [NSString stringWithFormat: @"%@%@%@",startString, firstsubscriptionPriceYearly,yearText];
            }
            //  purchaseyearLable.font = [UIFont boldSystemFontOfSize:buttonLableFontSize];
            purchaseyearLable.font = [UIFont fontWithName:@"Lora-Regular" size:buttonLableFontSize];
           
            purchaseyearLable.numberOfLines = 0;
            [purchaseYearButton addSubview:purchaseyearLable];


            // add radio button here //
            CGRect yearlySelectFrame;
            if(self.purchasedCountIs<1)
            {
                if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                {
//                    yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-25, purchaseYearButton.bounds.size.height/4-purchaseYearButton.bounds.size.height/8,50, 50);
                    yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-50, purchaseYearButton.frame.size.height/4,50, 50);
                }
                else
                {
                    if (@available(iOS 17.0, *)) {
                        yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-30, purchaseYearButton.bounds.size.height/6,50, 50);
                    }
                    else
                    {
                        if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
                        {
                            yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28,1,50, 50);
                        }
                        else
                        {
                            yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28,purchaseYearButton.bounds.size.height/6,50, 50);
                        }

                    }
                }
            }

            else
            {
               // yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-12, 1,50, 50);
                if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                {
                    yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-50, purchaseYearButton.frame.size.height/4,50, 50);

                }
                else
                {
                    if (@available(iOS 17.0, *)) {
                        yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28, purchaseYearButton.bounds.size.height/6,50, 50);
                    }
                    else
                    {
                        if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
                        {
                            yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28, 1,50, 50);

                        }
                        else
                        {
                            yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28, purchaseYearButton.bounds.size.height/6,50, 50);
                        }


                    }
                }

            }

            yearlySelection = [[RadioButton alloc] initWithFrame:yearlySelectFrame];
            [yearlySelection addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchUpInside];
            yearlySelection.backgroundColor = [UIColor clearColor];
            yearlySelection.tag = 500;
            // [yearlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
          //  [yearlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
             [yearlySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
            yearlySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            yearlySelection.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //yearlySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            yearlySelection.titleEdgeInsets = UIEdgeInsetsMake(-50, 6, 0, 0);
            yearlySelection.userInteractionEnabled = NO;
            [purchaseYearButton addSubview:yearlySelection];


            spinImageView = [[UIImageView alloc]init];
            spinImageView.frame = CGRectMake(0, 0, 50, 50);
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                spinImageView.center = CGPointMake(purchaseYearButton.frame.size.width*0.98, purchaseYearButton.frame.size.height*0.09);
            }
            else
            {
                spinImageView.center = CGPointMake(purchaseYearButton.frame.size.width*0.98, purchaseYearButton.frame.size.height*0.09);
            }

            spinImageView.layer.masksToBounds = true;
            // spinImageView.backgroundColor =  [UIColor colorWithRed:103.0/255.0 green:80.0/255.0 blue:164.0/255.0 alpha:1.0];
            //spinImageView.backgroundColor =  [UIColor purpleColor];
            spinImageView.image = [UIImage imageNamed:@"offer_Image"];
            spinImageView.contentMode = UIViewContentModeScaleAspectFit;
            [purchaseYearButton addSubview:spinImageView];
            [self performRotationAnimated];

            discountLabel = [[UILabel alloc]init];
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                discountLabel.frame = CGRectMake(purchaseYearButton.frame.size.width*0.96, spinImageView.center.y-25, 50, 50);
            }
            else
            {
//                discountLabel.frame = CGRectMake(purchaseYearButton.frame.size.width*0.94, -purchaseYearButton.frame.size.height*0.40, 50, 50);
                discountLabel.frame = CGRectMake(purchaseYearButton.frame.size.width*0.94,spinImageView.center.y-25, 50, 50);
            }

            discountLabel.text = @"80% OFF";
            discountLabel.numberOfLines = 0;
            discountLabel.font = [UIFont fontWithName:@"Lora-SemiBold" size:12.0];
            discountLabel.textColor = [UIColor whiteColor];
            [purchaseYearButton addSubview:discountLabel];

//
//            purchaseMonthButton = [[RadioButton alloc]init];
//            purchaseMonthButton.showsTouchWhenHighlighted = true;
//            purchaseMonthButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4,buttonViewHeight);
//            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
//            {
//                purchaseMonthButton.center = CGPointMake(centerX, purchaseYearButton.center.y+purchaseYearButton.bounds.size.height/2+75);
//                purchaseMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//                purchaseMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//            }
//            else
//            {
//                purchaseMonthButton.center = CGPointMake(centerX, purchaseYearButton.center.y+purchaseYearButton.bounds.size.height/2+45);
//            }
//
//            purchaseMonthButton.layer.cornerRadius =25;
//            [purchaseMonthButton setBackgroundColor:[UIColor clearColor]];
//            //onRadioButtonValueChanged:
//            //buyMonthlySubscription
//            [purchaseMonthButton addTarget:self action:@selector(onRadioButtonValueWithUIButton:) forControlEvents:UIControlEventTouchUpInside];
//
//            [backgroundview addSubview:purchaseMonthButton];
//            purchaseMonthButton.tag = 501;
//            [purchaseMonthButton bringSubviewToFront:backgroundview];
//
//            UILabel *purchaseMonthLable = [[UILabel alloc] init];
//            purchaseMonthLable.frame = purchaseMonthButton.bounds;
//            purchaseMonthLable.backgroundColor = [UIColor clearColor];
//            purchaseMonthLable.shadowOffset = CGSizeMake(0, 1);
//            purchaseMonthLable.textColor = [UIColor blackColor];
//            purchaseMonthLable.textAlignment = NSTextAlignmentCenter;
//            purchaseMonthLable.numberOfLines = 0;
//            purchaseMonthLable.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
//
//
//            if (TrailPeriodDays>0) {
//
//                if(self.purchasedCountIs>0)
//                {
//
//                    purchaseMonthLable.text = [NSString stringWithFormat: @"  %@%@%@",startString,firstsubscriptionPrice,monthText];
//                }
//                else
//                {
//                  //  purchaseMonthLable.text = [NSString stringWithFormat: @"%@%@", firstsubscriptionPrice,monthText];
//                    purchaseMonthLable.text = [NSString stringWithFormat: @"%@ %@ %@ \n %@%@", freeText,trailPeriodDaysText,day_Trial_Then, firstsubscriptionPrice,monthText];
//
//                }
//
//            }
//            else
//            {
//                purchaseMonthLable.text = [NSString stringWithFormat: @"  %@%@%@",startString, firstsubscriptionPrice,monthText];
//
//
//                //
//                //purchaseMonthLable.font = [UIFont fontWithName:@"HelveticaNeue" size:25.0];
//            }
//            if(TrailPeriodDays<1)
//            {
//                purchaseMonthLable.text = [NSString stringWithFormat: @"  %@%@%@",startString,firstsubscriptionPrice,monthText];
//
//                NSLog(@"this is the problem");
//            }
//
//            purchaseMonthLable.font = [UIFont fontWithName:@"Lora-Regular" size:buttonLableFontSize];
//            [purchaseMonthButton addSubview:purchaseMonthLable];
//
//
//            // add radio button here //
//            CGRect monthlySelectFrame;
//            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
//            {
//                monthlySelectFrame = CGRectMake(purchaseMonthButton.frame.origin.x-50, purchaseMonthButton.bounds.size.height/4,50, 50);
//            }
//
//            else
//            {
//                if (@available(iOS 17.0, *)) {
//                    monthlySelectFrame = CGRectMake(purchaseMonthButton.frame.origin.x-28,purchaseMonthButton.bounds.size.height/6,50, 50);
//                }
//
//                else
//                {
//                    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
//                    {
//                        monthlySelectFrame = CGRectMake(purchaseMonthButton.frame.origin.x-28,1,50, 50);
//                    }
//                    else
//                    {
//                        monthlySelectFrame = CGRectMake(purchaseMonthButton.frame.origin.x-28,purchaseMonthButton.bounds.size.height/6,50, 50);
//                    }
//
//                }
//            }
//
//
//            monthlySelection = [[RadioButton alloc] initWithFrame:monthlySelectFrame];
//            [monthlySelection addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchUpInside];
//            monthlySelection.backgroundColor = [UIColor clearColor];
//            monthlySelection.tag = 501;
//            [monthlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
//           // [monthlySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
//             //monthlySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//            monthlySelection.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            monthlySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//            monthlySelection.titleEdgeInsets = UIEdgeInsetsMake(-50, 6, 0, 0);
//            monthlySelection.userInteractionEnabled = NO;
//            [purchaseMonthButton addSubview:monthlySelection];


            //Weekly Purchase //
            purchaseWeekButton = [[RadioButton alloc]init];
        //    purchaseWeekButton.showsTouchWhenHighlighted = true;
            purchaseWeekButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4,buttonViewHeight);
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                purchaseWeekButton.center = CGPointMake(centerX, purchaseYearButton.center.y+purchaseYearButton.bounds.size.height/2+75);
                purchaseWeekButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                purchaseWeekButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            }
            else
            {
                purchaseWeekButton.center = CGPointMake(centerX, purchaseYearButton.center.y+purchaseYearButton.bounds.size.height/2+45);
            }

            purchaseWeekButton.layer.cornerRadius =25;
            [purchaseWeekButton setBackgroundColor:[UIColor clearColor]];
            [purchaseWeekButton addTarget:self action:@selector(onRadioButtonValueWithUIButton:) forControlEvents:UIControlEventTouchUpInside];
            //onRadioButtonValueChanged:
            //buyWeeklySubscription
            [backgroundview addSubview:purchaseWeekButton];
            purchaseWeekButton.tag = 502;
            [purchaseWeekButton bringSubviewToFront:backgroundview];

            UILabel *purchaseWeekLable = [[UILabel alloc] init];
            purchaseWeekLable.frame = purchaseWeekButton.bounds;
            purchaseWeekLable.backgroundColor = [UIColor clearColor];
            purchaseWeekLable.shadowOffset = CGSizeMake(0, 1);
            purchaseWeekLable.textColor = [UIColor blackColor];
            purchaseWeekLable.textAlignment = NSTextAlignmentCenter;
            purchaseWeekLable.numberOfLines = 0;
            purchaseWeekLable.font = [UIFont fontWithName:@"Lora-Regular" size:12.0];
            NSString *trailPeriodDaysWeeklyText = [NSString stringWithFormat:@"%ld", TrailPeriodDaysWeekly];

            if (TrailPeriodDaysWeekly>0) {

                purchaseWeekLable.text = [NSString stringWithFormat: @"%@ %@ %@ %@%@", freeText,trailPeriodDaysWeeklyText,day_Trial_Then, firstsubscriptionPriceWeekly,weekText];

            }
            else
            {
                purchaseWeekLable.text = [NSString stringWithFormat: @"  %@%@%@",startString, firstsubscriptionPriceWeekly,weekText];


            }
            if(TrailPeriodDaysWeekly<1)
            {
                purchaseWeekLable.text = [NSString stringWithFormat: @" %@%@%@", startString,firstsubscriptionPriceWeekly,weekText];
                NSLog(@"here it is ---");

            }

            purchaseWeekLable.font = [UIFont fontWithName:@"Lora-Regular" size:buttonLableFontSize];
            [purchaseWeekButton addSubview:purchaseWeekLable];

            CGRect weeklySelectFrame;
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                weeklySelectFrame = CGRectMake(purchaseWeekButton.frame.origin.x-50, purchaseWeekButton.bounds.size.height/4,50, 50);
            }
            else
            {
                if (@available(iOS 17.0, *)) {
                    weeklySelectFrame = CGRectMake(purchaseWeekButton.frame.origin.x-28, purchaseWeekButton.bounds.size.height/6,50, 50);
                }
                else
                {
                    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
                    {
                        weeklySelectFrame = CGRectMake(purchaseWeekButton.frame.origin.x-28,1,50, 50);
                    }
                    else{
                        weeklySelectFrame = CGRectMake(purchaseWeekButton.frame.origin.x-28,purchaseWeekButton.bounds.size.height/6,50, 50);
                    }

                }
            }


            weeklySelection = [[RadioButton alloc] initWithFrame:weeklySelectFrame];
            [weeklySelection addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchUpInside];
            weeklySelection.backgroundColor = [UIColor clearColor];
            weeklySelection.tag = 502;
            [weeklySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            // [weeklySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
           // weeklySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            weeklySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            weeklySelection.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

            weeklySelection.titleEdgeInsets = UIEdgeInsetsMake(-50, 6, 0, 0);
            weeklySelection.userInteractionEnabled = NO;
            [purchaseWeekButton addSubview:weeklySelection];


   subscriptionTitleLable = [[UILabel alloc] init];
    subscriptionTitleLable.frame = CGRectMake(0,0, textviewWidth+20, 80);
            
    CGFloat extraPadding = 20; // Adjust this value as needed to move it lower
            subscriptionTitleLable.center = CGPointMake(centerX, purchaseWeekButton.center.y + purchaseWeekButton.bounds.size.height / 2 + buttonViewHeight / 2 + extraPadding);


   // subscriptionTitleLable.center = CGPointMake(centerX, purchaseWeekButton.center.y+purchaseWeekButton.bounds.size.height/2+buttonViewHeight/2); // change y position after auto-renewable //
    subscriptionTitleLable.textAlignment = NSTextAlignmentCenter;
    subscriptionTitleLable.backgroundColor = [UIColor whiteColor];
    subscriptionTitleLable.shadowOffset = CGSizeMake(0, 1);
    subscriptionTitleLable.textColor = [UIColor blackColor] ;
    subscriptionTitleLable.text = @"Unlock all features";
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        [subscriptionTitleLable setFont:[UIFont fontWithName:@"Lora-SemiBold" size:28.0]];
    else
        [subscriptionTitleLable setFont:[UIFont fontWithName:@"Lora-SemiBold" size:22.0]];
    [backgroundview addSubview:subscriptionTitleLable];

    float fontsize,indentation,lineSpacing,paragraphSpacing,offsetFromTitle,divider;
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        NSLog(@"Ipad");
        fontsize = 20.0;
        indentation= 20.0;
        lineSpacing= 10.0;
        paragraphSpacing=12.0;
        offsetFromTitle = 20;
        divider = 100;
    }
    else if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen . size. height==568))
    {
        NSLog(@"Ipod");
        fontsize = 15.0;
        indentation= 1.0;
        lineSpacing= 2.0;
        paragraphSpacing=1.0;
        offsetFromTitle = 10;
        divider = 15;
    }
    else {
        NSLog(@"Iphone");
        fontsize = 16.0;
        indentation= 1.0;
        lineSpacing= 2.0;
        paragraphSpacing=1.0;
        offsetFromTitle = 10;
        divider = 50;
    }

    subcriptionContent = [[UITextView alloc]init];
    subcriptionContent.frame = CGRectMake(0,0, textviewWidth, fullScreen.size.height/6);
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            {
//                subcriptionContent.center = CGPointMake(centerX, purchaseWeekButton.center.y+purchaseWeekButton.bounds.size.height*4);
                subcriptionContent.center = CGPointMake(centerX, subscriptionTitleLable.center.y+subscriptionTitleLable.bounds.size.height*2);
            }
            else
            {
//                subcriptionContent.center = CGPointMake(centerX, purchaseWeekButton.center.y+purchaseWeekButton.bounds.size.height/2+120);
                subcriptionContent.center = CGPointMake(centerX, subscriptionTitleLable.center.y+subscriptionTitleLable.bounds.size.height);
            }

    subcriptionContent.text = subscription_Details;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:subscription_Details];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
    [attributedString addAttributes:dict range:NSMakeRange(0, subscription_Details.length)];
    subcriptionContent.attributedText = attributedString;
    subcriptionContent.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontsize];
    subcriptionContent.layer.cornerRadius = 25;
    subcriptionContent.clipsToBounds = NO;
    subcriptionContent.backgroundColor = [UIColor clearColor];
    subcriptionContent.editable = NO;
    subcriptionContent.clipsToBounds = NO;
    subcriptionContent.userInteractionEnabled = NO;
    subcriptionContent.textColor  = [UIColor colorWithRed:177.0f/255.0f green:177.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
    subcriptionContent.delegate = self;
//             @try {
                
            
    subcriptionContent.attributedText = [self attributedStringForBulletTexts:stringArray
                                                       withFont:[UIFont fontWithName:@"Lora-Regular" size:fontsize]
                                                   bulletString:@" ● "
                                                    indentation:indentation
                                                    lineSpacing:lineSpacing
                                               paragraphSpacing:paragraphSpacing
                                                      textColor:[UIColor colorWithRed:155.0f/255.0f green:155.0f/255.0f blue:155.0f/255.0f alpha:1.0f]
                                                                 bulletColor:[UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];


//             }
//             @catch (NSException *exception) {
//                 // do nothing
//                 NSLog(@"exception reason is %@",exception.description);
//             }
    subcriptionContent.layer.cornerRadius = 25;
    [backgroundview addSubview:subcriptionContent];
    NSLog(@"Content height %f bounds height %f ",subcriptionContent.contentSize.height,subcriptionContent.bounds.size.height);
            
            UILabel *renewableLable = [[UILabel alloc] init];
            renewableLable.frame = CGRectMake(0, 0, fullScreen.size.width, customBarHeight);

            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                if (@available(iOS 14.2, *))
                {

        //                renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4-subcriptionContent.contentSize.height/2);
                    renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height/2+buttonViewHeight/2);
                }
                else
                {
        //                renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4-subcriptionContent.contentSize.height/5);
                    renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height/2+buttonViewHeight/2);
                }

            }
            else
            {
        //        renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4-subcriptionContent.contentSize.height/5);
                renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height/2+buttonViewHeight/2+buttonViewHeight/4);
            }

        //    renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4-subcriptionContent.contentSize.height/5);
            renewableLable.backgroundColor = [UIColor clearColor];
            renewableLable.shadowOffset = CGSizeMake(0, 1);
            renewableLable.textColor = [UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f]; // change here color //
            renewableLable.textAlignment=NSTextAlignmentCenter;
            renewableLable.text = @"Auto-renewable,Cancel anytime.";
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                renewableLable.font  = [UIFont fontWithName:@"Lora-Regular" size:18.0];
            else
                renewableLable.font  = [UIFont fontWithName:@"Lora-Regular" size:14.0];
            [backgroundview addSubview:renewableLable];


            UIButton *purchaseRestoreButton = [[UIButton alloc]init];
            purchaseRestoreButton.frame = CGRectMake(0, 0, fullScreen.size.width/2+20, 50);
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                if (@available(iOS 14.2, *))
                {

        //            purchaseRestoreButton.center = CGPointMake(centerX, renewableLable.center.y+renewableLable.frame.size.height+renewableLable.frame.size.height/4);

                    purchaseRestoreButton.center = CGPointMake(centerX, renewableLable.center.y+renewableLable.frame.size.height/2);

                }
                else
                {
        //            purchaseRestoreButton.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4);
                    purchaseRestoreButton.center = CGPointMake(centerX, renewableLable.center.y+renewableLable.frame.size.height/2);

                }
            }
            else
            {
        //        purchaseRestoreButton.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4);

                purchaseRestoreButton.center = CGPointMake(centerX, renewableLable.center.y+renewableLable.frame.size.height/2);

            }

            [purchaseRestoreButton addTarget:self action:@selector(ResoreSubscription) forControlEvents:UIControlEventTouchUpInside];
           [purchaseRestoreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
          //  purchaseRestoreButton.showsTouchWhenHighlighted = true;
            purchaseRestoreButton.userInteractionEnabled = YES;
           [backgroundview addSubview:purchaseRestoreButton];

            NSMutableAttributedString *Undtextline = [[NSMutableAttributedString alloc] initWithString:@"Restore Purchase"];
            [Undtextline addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, Undtextline.length)];

            UILabel *restoreLabel = [[UILabel alloc] init];
            restoreLabel.frame = purchaseRestoreButton.bounds;
            restoreLabel.center = purchaseRestoreButton.center;
            restoreLabel.textAlignment = NSTextAlignmentCenter;
            restoreLabel.backgroundColor = [UIColor clearColor];
            restoreLabel.shadowOffset = CGSizeMake(0, 1);
            restoreLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
            [restoreLabel setAttributedText:Undtextline];
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                restoreLabel.font  = [UIFont fontWithName:@"Lora-Regular" size:18.0];
            else restoreLabel.font  = [UIFont fontWithName:@"Lora-Regular" size:15.0];
            [backgroundview addSubview:restoreLabel];



            UILabel *subTermsLable = [[UILabel alloc] init];
            subTermsLable.frame = CGRectMake(0,0, fullScreen.size.width, 25);
            subTermsLable.center = CGPointMake(centerX, purchaseRestoreButton.center.y+purchaseRestoreButton.bounds.size.height/2+heightOffset);
            subTermsLable.backgroundColor = [UIColor clearColor];
            subTermsLable.shadowOffset = CGSizeMake(0, 1);
            subTermsLable.textColor = [UIColor blackColor];
            subTermsLable.textAlignment = NSTextAlignmentCenter;
            subTermsLable.text = @"Subscription Terms";
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                subTermsLable.font  = [UIFont fontWithName:@"Lora-SemiBold" size:18.0];
            else
                subTermsLable.font  = [UIFont fontWithName:@"Lora-SemiBold" size:15.0];
            [backgroundview addSubview:subTermsLable];


            UITextView *termsnConditionTextview = [[UITextView alloc]init];
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            termsnConditionTextview.frame = CGRectMake(0, 0, fullScreen.size.width - fullScreen.size.width/8, fullScreen.size.height/6);
            else
                termsnConditionTextview.frame = CGRectMake(0, 0, fullScreen.size.width, fullScreen.size.height/4);
            termsnConditionTextview.center = CGPointMake(centerX, subTermsLable.center.y+subTermsLable.bounds.size.height/2+(3*heightOffset));
            termsnConditionTextview.text = terms_n_conditions_text;
            NSMutableAttributedString *termsnConditionAttributedString = [[NSMutableAttributedString alloc] initWithString:terms_n_conditions_text];
                NSMutableParagraphStyle *tcParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            tcParagraphStyle.lineSpacing = 5;
                NSDictionary *tcDict = @{NSParagraphStyleAttributeName : tcParagraphStyle };
                [termsnConditionAttributedString addAttributes:tcDict range:NSMakeRange(0, terms_n_conditions_text.length)];
          //  termsnConditionTextview.attributedText = termsnConditionAttributedString;
            termsnConditionTextview.font  = [UIFont fontWithName:@"Lora-Regular" size:12.0];
           // termsnConditionTextview.font = [UIFont systemFontOfSize:14.0];
        //    termsnConditionTextview.textColor  = [UIColor colorWithRed:177.0f/255.0f green:177.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
            termsnConditionTextview.textColor  = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
            termsnConditionTextview.clipsToBounds = NO;
            termsnConditionTextview.backgroundColor = [UIColor clearColor];
            termsnConditionTextview.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
            [backgroundview addSubview:termsnConditionTextview];
            termsnConditionTextview.editable = NO;
            termsnConditionTextview.clipsToBounds = NO;
            termsnConditionTextview.userInteractionEnabled = NO;

            NSLog(@"bounds height %f,content height %f",termsnConditionTextview.bounds.size.height,termsnConditionTextview.contentSize.height);
            UILabel *accepting = [[UILabel alloc] init];
            accepting.frame = CGRectMake(0, 0,fullScreen.size.width, 25);
            NSLog(@"bounds height termsn Condition Textview content height %f, cente y %f",termsnConditionTextview.contentSize.height,termsnConditionTextview.center.y);
        //    if (@available(iOS 17.0, *)) {
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                accepting.center =CGPointMake(centerX, termsnConditionTextview.center.y+termsnConditionTextview.contentSize.height+heightOffset/2); //2+heightOffset
            }
            else
            {
                if (@available(iOS 17.0, *)) {
                    accepting.center =CGPointMake(centerX, termsnConditionTextview.center.y+termsnConditionTextview.contentSize.height+heightOffset/2); //2+heightOffset
                }
                else
                {
        //            accepting.center =CGPointMake(centerX, termsnConditionTextview.center.y+termsnConditionTextview.contentSize.height-heightOffset);
        //            //2+heightOffset
                    accepting.center =CGPointMake(centerX, termsnConditionTextview.center.y+termsnConditionTextview.contentSize.height-heightOffset/2);
                }
            }

            accepting.textAlignment = NSTextAlignmentCenter;
            accepting.backgroundColor = [UIColor clearColor];
            accepting.shadowOffset = CGSizeMake(0, 1);
            accepting.textColor = [UIColor blackColor];
            accepting.text = @"By continuing you accept our ";


            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                accepting.font = [UIFont fontWithName:@"Lora-Regular" size:16.0];
            else accepting.font = [UIFont fontWithName:@"Lora-Regular" size:14.0];
           // lora_medium.ttf
            [backgroundview addSubview:accepting];


            UILabel *andLabel = [[UILabel alloc] init];
            andLabel.frame = CGRectMake(0, 0, 50, customBarHeight);
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                andLabel.center = CGPointMake(centerX+centerX/20, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);

            }
            else
            {
                andLabel.center = CGPointMake(centerX+centerX/10, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);

            }
            andLabel.backgroundColor = [UIColor clearColor];
            andLabel.shadowOffset = CGSizeMake(0, 1);
            andLabel.textColor = [UIColor blackColor] ;
            andLabel.text = @"and";

            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                andLabel.font = [UIFont fontWithName:@"Lora-Regular" size:15.0];
            else
                andLabel.font = [UIFont fontWithName:@"Lora-Regular" size:14.0];
            [backgroundview addSubview:andLabel];



            UIButton *privacybutton = [[UIButton alloc]init];
            privacybutton.frame = CGRectMake(0, 0,110, 50);
           // privacybutton.frame = CGRectMake((andLabel.center.x-andLabel.bounds.size.width/2-110), andLabel.center.y-andLabel.bounds.size.height/2, 100, 50);
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                privacybutton.center = CGPointMake(andLabel.center.x-andLabel.bounds.size.width/2-privacybutton.bounds.size.width/2, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);
            }
            else
            {
                privacybutton.center = CGPointMake(andLabel.center.x-andLabel.bounds.size.width/2-privacybutton.bounds.size.width/2, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);

            }

            [privacybutton addTarget:self action:@selector(Privacypolicy:) forControlEvents:UIControlEventTouchUpInside];
            [privacybutton setBackgroundColor:[UIColor clearColor]];
            privacybutton.userInteractionEnabled = YES;
            [backgroundview addSubview:privacybutton];

            //-------------UnderlineText-------------------//

            NSMutableAttributedString *Undtext = [[NSMutableAttributedString alloc] initWithString:@"Privacy Policy" ];
            [Undtext addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, Undtext.length)];


            UILabel *privacyLabel = [[UILabel alloc] init];
            privacyLabel.frame = privacybutton.frame;
            privacyLabel.center = privacybutton.center;
            privacyLabel.backgroundColor = [UIColor clearColor];
            privacyLabel.shadowOffset = CGSizeMake(0, 1);
            privacyLabel.textAlignment = NSTextAlignmentCenter;
            privacyLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
            [privacyLabel setAttributedText:Undtext];
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                privacyLabel.font = [UIFont fontWithName:@"Lora-Regular" size:16.0];
            else privacyLabel.font = [UIFont fontWithName:@"Lora-Regular" size:14.0];
            [backgroundview addSubview:privacyLabel];

            NSMutableAttributedString *Undtext2 = [[NSMutableAttributedString alloc] initWithString:@"Terms of use"];
            [Undtext2 addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, Undtext2.length)];



            UIButton *termsButton = [[UIButton alloc]init];
            termsButton.frame = CGRectMake(0, 0, 100, 50);
            //termsButton.frame = CGRectMake((andLabel.bounds.size.width+10), andLabel.center.y-andLabel.bounds.size.height/2, 100, 50);
            termsButton.center = CGPointMake(andLabel.center.x+andLabel.bounds.size.width+10, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);
            [termsButton addTarget:self action:@selector(TermsofCondition) forControlEvents:UIControlEventTouchUpInside];
            [termsButton setBackgroundColor:[UIColor clearColor]];
            termsButton.userInteractionEnabled = YES;
            [backgroundview addSubview:termsButton];


            UILabel *termsLabel = [[UILabel alloc] init];
            termsLabel.frame = termsButton.bounds;
            termsLabel.center = termsButton.center;
            termsLabel.backgroundColor = [UIColor clearColor];
            termsLabel.shadowOffset = CGSizeMake(0, 1);
            termsLabel.textAlignment = NSTextAlignmentLeft;
            termsLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
            [termsLabel setAttributedText:Undtext2];
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                termsLabel.font = [UIFont fontWithName:@"Lora-Regular" size:16.0];
            else
                termsLabel.font = [UIFont fontWithName:@"Lora-Regular" size:14.0];
            [backgroundview addSubview:termsLabel];


            if (TrailPeriodDaysYearly>=0) {

                if(self.purchasedCountIs>0)
                {

                    float ratio = (termsLabel.center.y+termsLabel.bounds.size.height*3)/fullScreen.size.height;
                    NSLog(@" page content height %f, ratio  %f",termsLabel.center.y+termsLabel.bounds.size.height,ratio);
                    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *ratio);
                }

                else
                {
                    if(self.subCountIs >1)
                    {
                        float ratio = (termsLabel.center.y+termsLabel.bounds.size.height*7)/fullScreen.size.height;
                        NSLog(@" page content height firstmode %f, ratio  %f",termsLabel.center.y+termsLabel.bounds.size.height,ratio);
                        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *ratio);
                    }
                    else
                    {
                        float ratio = (termsLabel.center.y+termsLabel.bounds.size.height*3)/fullScreen.size.height;
                        NSLog(@" page content height else %f, ratio  %f",termsLabel.center.y+termsLabel.bounds.size.height,ratio);
                        scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *ratio);
                    }



                }
            }
            
            

            return;
        }

        
        
        else if(self.purchasedCountIs>0 || self.subCountIs == 1 || self.subCountIs == 0)
        {
//        if(self.purchasedCountIs<=0 || self.subCountIs == 1)
//        {

            //Yearly subscription
            purchaseYearButton = [[RadioButton alloc]init];
         //   purchaseYearButton.showsTouchWhenHighlighted = true;
            if(self.purchasedCountIs<1)
            {
                purchaseYearButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4 ,buttonViewHeight);
            }
            else
            {
               // purchaseYearButton.frame = CGRectMake(0, 0, buttonViewWidth,buttonViewHeight);
                purchaseYearButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4,buttonViewHeight);
               // purchaseYearButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4,50);
            }
          //
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
//                purchaseYearButton.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.frame.size.height*2-bannerImageview.frame.size.height/4);
                purchaseYearButton.center = CGPointMake(centerX, _pagerView.center.y+_pagerView.frame.size.height/2+buttonViewHeight/2);
                purchaseYearButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                purchaseYearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;

            }

            else
            {
//                purchaseYearButton.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.frame.size.height*2);

                purchaseYearButton.center = CGPointMake(centerX, _pagerView.center.y+_pagerView.frame.size.height/2+buttonViewHeight/2);


            }
            purchaseYearButton.layer.cornerRadius =25;
            [purchaseYearButton setBackgroundColor:[UIColor clearColor]];
            [purchaseYearButton addTarget:self action:@selector(onRadioButtonValueWithUIButton:) forControlEvents:UIControlEventTouchUpInside];
            [purchaseYearButton setImage:[UIImage imageNamed:@"subscription_Selected_Bg"] forState:UIControlStateNormal];
//            purchaseYearButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 30, 30);


//            purchaseYearButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
           // [purchaseYearButton setBackgroundColor:[UIColor linkColor]];
            //PurchaseSubscriptionYearly - method //
            [backgroundview addSubview:purchaseYearButton];
            purchaseYearButton.tag = 500;
            //[purchaseYearButton bringSubviewToFront:backgroundview];


            UILabel *purchaseyearLable = [[UILabel alloc] init];
            purchaseyearLable.frame = purchaseYearButton.bounds;
            purchaseyearLable.backgroundColor = [UIColor clearColor];
            purchaseyearLable.shadowOffset = CGSizeMake(0, 1);
            purchaseyearLable.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
            purchaseyearLable.textAlignment = NSTextAlignmentCenter;
            purchaseyearLable.numberOfLines = 0;
            purchaseyearLable.font = [UIFont fontWithName:@"Lora-Regular" size:12.0];

            NSString *trailPeriodDaysYearlyText = [NSString stringWithFormat:@"%ld", TrailPeriodDaysYearly];
            if (TrailPeriodDaysYearly>0) {

                if(self.purchasedCountIs>0)
                {
                   purchaseyearLable.text = [NSString stringWithFormat: @"%@%@%@",startString, firstsubscriptionPriceYearly,yearText];
                }
                else
                {
                     purchaseyearLable.text = [NSString stringWithFormat: @"%@ %@ %@ \n %@%@", freeText,trailPeriodDaysYearlyText,day_Trial_Then, firstsubscriptionPriceYearly,yearText];
                }

                //        purchaseyearLable.text = [NSString stringWithFormat: @"%@ %@ %@ %@%@", freeText,trailPeriodDaysYearlyText,day_Trial_Then, firstsubscriptionPriceYearly,yearText];
                //        if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                //            purchaseyearLable.font = [UIFont boldSystemFontOfSize:22.0];
                //        else
                //           purchaseyearLable.font = [UIFont boldSystemFontOfSize:18.0];
            }
            else
            {
                purchaseyearLable.text = [NSString stringWithFormat: @"%@%@%@",startString, firstsubscriptionPriceYearly,yearText];
                //        if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                //            purchaseyearLable.font = [UIFont boldSystemFontOfSize:22.0];
                //        else
                //            purchaseyearLable.font = [UIFont boldSystemFontOfSize:18.0];
                //purchaseyearLable.font = [UIFont fontWithName:@"HelveticaNeue" size:25.0];
            }
            //  purchaseyearLable.font = [UIFont boldSystemFontOfSize:buttonLableFontSize];
            purchaseyearLable.font = [UIFont fontWithName:@"Lora-Regular" size:buttonLableFontSize];
           
            purchaseyearLable.numberOfLines = 0;
            [purchaseYearButton addSubview:purchaseyearLable];


            // add radio button here //
            CGRect yearlySelectFrame;
            if(self.purchasedCountIs<1)
            {
                if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                {
//                    yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-25, purchaseYearButton.bounds.size.height/4-purchaseYearButton.bounds.size.height/8,50, 50);
                    yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-50, purchaseYearButton.frame.size.height/4,50, 50);
                }
                else
                {
                    if (@available(iOS 17.0, *)) {
                        yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-30, purchaseYearButton.bounds.size.height/6,50, 50);
                    }
                    else
                    {
                        if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
                        {
                            yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28,1,50, 50);
                        }
                        else
                        {
                            yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28,purchaseYearButton.bounds.size.height/6,50, 50);
                        }

                    }
                }
            }

            else
            {
               // yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-12, 1,50, 50);
                if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                {
                    yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-50, purchaseYearButton.frame.size.height/4,50, 50);

                }
                else
                {
                    if (@available(iOS 17.0, *)) {
                        yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28, purchaseYearButton.bounds.size.height/6,50, 50);
                    }
                    else
                    {
                        if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
                        {
                            yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28, 1,50, 50);

                        }
                        else
                        {
                            yearlySelectFrame  = CGRectMake(purchaseYearButton.frame.origin.x-28, purchaseYearButton.bounds.size.height/6,50, 50);
                        }


                    }
                }

            }

            yearlySelection = [[RadioButton alloc] initWithFrame:yearlySelectFrame];
            [yearlySelection addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchUpInside];
            yearlySelection.backgroundColor = [UIColor clearColor];
            yearlySelection.tag = 500;
            // [yearlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
          //  [yearlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
             [yearlySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
            yearlySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            yearlySelection.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //yearlySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            yearlySelection.titleEdgeInsets = UIEdgeInsetsMake(-50, 6, 0, 0);
            yearlySelection.userInteractionEnabled = NO;
            [purchaseYearButton addSubview:yearlySelection];


            spinImageView = [[UIImageView alloc]init];
            spinImageView.frame = CGRectMake(0, 0, 50, 50);
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                spinImageView.center = CGPointMake(purchaseYearButton.frame.size.width*0.98, purchaseYearButton.frame.size.height*0.09);
            }
            else
            {
                spinImageView.center = CGPointMake(purchaseYearButton.frame.size.width*0.98, purchaseYearButton.frame.size.height*0.09);
            }

            spinImageView.layer.masksToBounds = true;
            // spinImageView.backgroundColor =  [UIColor colorWithRed:103.0/255.0 green:80.0/255.0 blue:164.0/255.0 alpha:1.0];
            //spinImageView.backgroundColor =  [UIColor purpleColor];
            spinImageView.image = [UIImage imageNamed:@"offer_Image"];
            spinImageView.contentMode = UIViewContentModeScaleAspectFit;
            [purchaseYearButton addSubview:spinImageView];
            [self performRotationAnimated];

            discountLabel = [[UILabel alloc]init];
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                discountLabel.frame = CGRectMake(purchaseYearButton.frame.size.width*0.96, spinImageView.center.y-25, 50, 50);
            }
            else
            {
//                discountLabel.frame = CGRectMake(purchaseYearButton.frame.size.width*0.94, -purchaseYearButton.frame.size.height*0.40, 50, 50);
                discountLabel.frame = CGRectMake(purchaseYearButton.frame.size.width*0.94,spinImageView.center.y-25, 50, 50);
            }

            discountLabel.text = @"80% OFF";
            discountLabel.numberOfLines = 0;
            discountLabel.font = [UIFont fontWithName:@"Lora-SemiBold" size:12.0];
            discountLabel.textColor = [UIColor whiteColor];
            [purchaseYearButton addSubview:discountLabel];


            purchaseMonthButton = [[RadioButton alloc]init];
         //   purchaseMonthButton.showsTouchWhenHighlighted = true;
            purchaseMonthButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4,buttonViewHeight);
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                purchaseMonthButton.center = CGPointMake(centerX, purchaseYearButton.center.y+purchaseYearButton.bounds.size.height/2+75);
                purchaseMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                purchaseMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            }
            else
            {
                purchaseMonthButton.center = CGPointMake(centerX, purchaseYearButton.center.y+purchaseYearButton.bounds.size.height/2+45);
            }

            purchaseMonthButton.layer.cornerRadius =25;
            [purchaseMonthButton setBackgroundColor:[UIColor clearColor]];
            //onRadioButtonValueChanged:
            //buyMonthlySubscription
            [purchaseMonthButton addTarget:self action:@selector(onRadioButtonValueWithUIButton:) forControlEvents:UIControlEventTouchUpInside];

            [backgroundview addSubview:purchaseMonthButton];
            purchaseMonthButton.tag = 501;
            [purchaseMonthButton bringSubviewToFront:backgroundview];

            UILabel *purchaseMonthLable = [[UILabel alloc] init];
            purchaseMonthLable.frame = purchaseMonthButton.bounds;
            purchaseMonthLable.backgroundColor = [UIColor clearColor];
            purchaseMonthLable.shadowOffset = CGSizeMake(0, 1);
            purchaseMonthLable.textColor = [UIColor blackColor];
            purchaseMonthLable.textAlignment = NSTextAlignmentCenter;
            purchaseMonthLable.numberOfLines = 0;
            purchaseMonthLable.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];


            if (TrailPeriodDays>0) {

                if(self.purchasedCountIs>0)
                {

                    purchaseMonthLable.text = [NSString stringWithFormat: @"  %@%@%@",startString,firstsubscriptionPrice,monthText];
                }
                else
                {
                  //  purchaseMonthLable.text = [NSString stringWithFormat: @"%@%@", firstsubscriptionPrice,monthText];
                    purchaseMonthLable.text = [NSString stringWithFormat: @"%@ %@ %@ \n %@%@", freeText,trailPeriodDaysText,day_Trial_Then, firstsubscriptionPrice,monthText];

                }

            }
            else
            {
                purchaseMonthLable.text = [NSString stringWithFormat: @"  %@%@%@",startString, firstsubscriptionPrice,monthText];


                //
                //purchaseMonthLable.font = [UIFont fontWithName:@"HelveticaNeue" size:25.0];
            }
            if(TrailPeriodDays<1)
            {
                purchaseMonthLable.text = [NSString stringWithFormat: @"  %@%@%@",startString,firstsubscriptionPrice,monthText];

                NSLog(@"this is the problem");
            }

            purchaseMonthLable.font = [UIFont fontWithName:@"Lora-Regular" size:buttonLableFontSize];
            [purchaseMonthButton addSubview:purchaseMonthLable];


            // add radio button here //
            CGRect monthlySelectFrame;
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                monthlySelectFrame = CGRectMake(purchaseMonthButton.frame.origin.x-50, purchaseMonthButton.bounds.size.height/4,50, 50);
            }

            else
            {
                if (@available(iOS 17.0, *)) {
                    monthlySelectFrame = CGRectMake(purchaseMonthButton.frame.origin.x-28,purchaseMonthButton.bounds.size.height/6,50, 50);
                }

                else
                {
                    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
                    {
                        monthlySelectFrame = CGRectMake(purchaseMonthButton.frame.origin.x-28,1,50, 50);
                    }
                    else
                    {
                        monthlySelectFrame = CGRectMake(purchaseMonthButton.frame.origin.x-28,purchaseMonthButton.bounds.size.height/6,50, 50);
                    }

                }
            }


            monthlySelection = [[RadioButton alloc] initWithFrame:monthlySelectFrame];
            [monthlySelection addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchUpInside];
            monthlySelection.backgroundColor = [UIColor clearColor];
            monthlySelection.tag = 501;
            [monthlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
           // [monthlySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
             //monthlySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            monthlySelection.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            monthlySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

            monthlySelection.titleEdgeInsets = UIEdgeInsetsMake(-50, 6, 0, 0);
            monthlySelection.userInteractionEnabled = NO;
            [purchaseMonthButton addSubview:monthlySelection];


            //Weekly Purchase //
            purchaseWeekButton = [[RadioButton alloc]init];
            //purchaseWeekButton.showsTouchWhenHighlighted = true;
            purchaseWeekButton.frame = CGRectMake(0, 0, buttonViewWidth+buttonViewWidth/4,buttonViewHeight);
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                purchaseWeekButton.center = CGPointMake(centerX, purchaseMonthButton.center.y+purchaseMonthButton.bounds.size.height/2+75);
                purchaseWeekButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                purchaseWeekButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            }
            else
            {
                purchaseWeekButton.center = CGPointMake(centerX, purchaseMonthButton.center.y+purchaseMonthButton.bounds.size.height/2+45);
            }

            purchaseWeekButton.layer.cornerRadius =25;
            [purchaseWeekButton setBackgroundColor:[UIColor clearColor]];
            [purchaseWeekButton addTarget:self action:@selector(onRadioButtonValueWithUIButton:) forControlEvents:UIControlEventTouchUpInside];
            //onRadioButtonValueChanged:
            //buyWeeklySubscription
            [backgroundview addSubview:purchaseWeekButton];
            purchaseWeekButton.tag = 502;
            [purchaseWeekButton bringSubviewToFront:backgroundview];

            UILabel *purchaseWeekLable = [[UILabel alloc] init];
            purchaseWeekLable.frame = purchaseWeekButton.bounds;
            purchaseWeekLable.backgroundColor = [UIColor clearColor];
            purchaseWeekLable.shadowOffset = CGSizeMake(0, 1);
            purchaseWeekLable.textColor = [UIColor blackColor];
            purchaseWeekLable.textAlignment = NSTextAlignmentCenter;
            purchaseWeekLable.numberOfLines = 0;
            purchaseWeekLable.font = [UIFont fontWithName:@"Lora-Regular" size:12.0];
            NSString *trailPeriodDaysWeeklyText = [NSString stringWithFormat:@"%ld", TrailPeriodDaysWeekly];

            if (TrailPeriodDaysWeekly>0) {

                purchaseWeekLable.text = [NSString stringWithFormat: @"%@ %@ %@ %@%@", freeText,trailPeriodDaysWeeklyText,day_Trial_Then, firstsubscriptionPriceWeekly,weekText];

            }
            else
            {
                purchaseWeekLable.text = [NSString stringWithFormat: @"  %@%@%@",startString, firstsubscriptionPriceWeekly,weekText];


            }
            if(TrailPeriodDaysWeekly<1)
            {
                purchaseWeekLable.text = [NSString stringWithFormat: @" %@%@%@", startString,firstsubscriptionPriceWeekly,weekText];
                NSLog(@"here it is ---");

            }

            purchaseWeekLable.font = [UIFont fontWithName:@"Lora-Regular" size:buttonLableFontSize];
            [purchaseWeekButton addSubview:purchaseWeekLable];

            CGRect weeklySelectFrame;
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                weeklySelectFrame = CGRectMake(purchaseWeekButton.frame.origin.x-50, purchaseWeekButton.bounds.size.height/4,50, 50);
            }
            else
            {
                if (@available(iOS 17.0, *)) {
                    weeklySelectFrame = CGRectMake(purchaseWeekButton.frame.origin.x-28, purchaseWeekButton.bounds.size.height/6,50, 50);
                }
                else
                {
                    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
                    {
                        weeklySelectFrame = CGRectMake(purchaseWeekButton.frame.origin.x-28,1,50, 50);
                    }
                    else{
                        weeklySelectFrame = CGRectMake(purchaseWeekButton.frame.origin.x-28,purchaseWeekButton.bounds.size.height/6,50, 50);
                    }

                }
            }


            weeklySelection = [[RadioButton alloc] initWithFrame:weeklySelectFrame];
            [weeklySelection addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchUpInside];
            weeklySelection.backgroundColor = [UIColor clearColor];
            weeklySelection.tag = 502;
            [weeklySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            // [weeklySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
           // weeklySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            weeklySelection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            weeklySelection.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

            weeklySelection.titleEdgeInsets = UIEdgeInsetsMake(-50, 6, 0, 0);
            weeklySelection.userInteractionEnabled = NO;
            [purchaseWeekButton addSubview:weeklySelection];


   subscriptionTitleLable = [[UILabel alloc] init];
    subscriptionTitleLable.frame = CGRectMake(0,0, textviewWidth+20, 80);

    subscriptionTitleLable.center = CGPointMake(centerX, purchaseWeekButton.center.y+purchaseWeekButton.bounds.size.height/2+buttonViewHeight/2); // change y position after auto-renewable //
    subscriptionTitleLable.textAlignment = NSTextAlignmentCenter;
    subscriptionTitleLable.backgroundColor = [UIColor clearColor];
    subscriptionTitleLable.shadowOffset = CGSizeMake(0, 1);
    subscriptionTitleLable.textColor = [UIColor blackColor] ;
    subscriptionTitleLable.text = @"Unlock all features";
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        [subscriptionTitleLable setFont:[UIFont fontWithName:@"Lora-SemiBold" size:28.0]];
    else
        [subscriptionTitleLable setFont:[UIFont fontWithName:@"Lora-SemiBold" size:22.0]];
    [backgroundview addSubview:subscriptionTitleLable];

    float fontsize,indentation,lineSpacing,paragraphSpacing,offsetFromTitle,divider;
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        NSLog(@"Ipad");
        fontsize = 20.0;
        indentation= 20.0;
        lineSpacing= 10.0;
        paragraphSpacing=12.0;
        offsetFromTitle = 20;
        divider = 100;
    }
    else if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen . size. height==568))
    {
        NSLog(@"Ipod");
        fontsize = 15.0;
        indentation= 1.0;
        lineSpacing= 2.0;
        paragraphSpacing=1.0;
        offsetFromTitle = 10;
        divider = 15;
    }
    else {
        NSLog(@"Iphone");
        fontsize = 16.0;
        indentation= 1.0;
        lineSpacing= 2.0;
        paragraphSpacing=1.0;
        offsetFromTitle = 10;
        divider = 50;
    }

    subcriptionContent = [[UITextView alloc]init];
    subcriptionContent.frame = CGRectMake(0,0, textviewWidth, fullScreen.size.height/6);
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            {
//                subcriptionContent.center = CGPointMake(centerX, purchaseWeekButton.center.y+purchaseWeekButton.bounds.size.height*4);
                subcriptionContent.center = CGPointMake(centerX, subscriptionTitleLable.center.y+subscriptionTitleLable.bounds.size.height*2);
            }
            else
            {
//                subcriptionContent.center = CGPointMake(centerX, purchaseWeekButton.center.y+purchaseWeekButton.bounds.size.height/2+120);
                subcriptionContent.center = CGPointMake(centerX, subscriptionTitleLable.center.y+subscriptionTitleLable.bounds.size.height);
            }

    subcriptionContent.text = subscription_Details;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:subscription_Details];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
    [attributedString addAttributes:dict range:NSMakeRange(0, subscription_Details.length)];
    subcriptionContent.attributedText = attributedString;
    subcriptionContent.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontsize];
    subcriptionContent.layer.cornerRadius = 25;
    subcriptionContent.clipsToBounds = NO;
    subcriptionContent.backgroundColor = [UIColor clearColor];
    subcriptionContent.editable = NO;
    subcriptionContent.clipsToBounds = NO;
    subcriptionContent.userInteractionEnabled = NO;
    subcriptionContent.textColor  = [UIColor colorWithRed:177.0f/255.0f green:177.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
    subcriptionContent.delegate = self;
//             @try {
                
            
    subcriptionContent.attributedText = [self attributedStringForBulletTexts:stringArray
                                                       withFont:[UIFont fontWithName:@"Lora-Regular" size:fontsize]
                                                   bulletString:@" ● "
                                                    indentation:indentation
                                                    lineSpacing:lineSpacing
                                               paragraphSpacing:paragraphSpacing
                                                      textColor:[UIColor colorWithRed:155.0f/255.0f green:155.0f/255.0f blue:155.0f/255.0f alpha:1.0f]
                                                                 bulletColor:[UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];


//             }
//             @catch (NSException *exception) {
//                 // do nothing
//                 NSLog(@"exception reason is %@",exception.description);
//             }
    subcriptionContent.layer.cornerRadius = 25;
    [backgroundview addSubview:subcriptionContent];
    NSLog(@"Content height %f bounds height %f ",subcriptionContent.contentSize.height,subcriptionContent.bounds.size.height);


        } //else if (self.subCountIs == 3)
        
        else
        {

            // make single button UI for Yearly Subscription //


            subscriptionTitleLable = [[UILabel alloc] init];
             subscriptionTitleLable.frame = CGRectMake(0,0, textviewWidth+20, 80);
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                subscriptionTitleLable.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.bounds.size.height*2-bannerImageview.bounds.size.height/3); //
            }
            else
            {
                subscriptionTitleLable.center = CGPointMake(centerX, bannerImageview.center.y+bannerImageview.bounds.size.height*2-bannerImageview.bounds.size.height/3+20); //
            }

           // subscriptionTitleLable.center = CGPointMake(centerX, _pagerView.center.y+_pagerView.bounds.size.height/2+70); //
             subscriptionTitleLable.textAlignment = NSTextAlignmentCenter;
             subscriptionTitleLable.backgroundColor = [UIColor clearColor];
             subscriptionTitleLable.shadowOffset = CGSizeMake(0, 1);
             subscriptionTitleLable.textColor = [UIColor blackColor] ;
             subscriptionTitleLable.text = @"Unlock all features";
             if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                 [subscriptionTitleLable setFont:[UIFont fontWithName:@"Lora-SemiBold" size:28.0]];
             else
                 [subscriptionTitleLable setFont:[UIFont fontWithName:@"Lora-SemiBold" size:22.0]];
             [backgroundview addSubview:subscriptionTitleLable];

             float fontsize,indentation,lineSpacing,paragraphSpacing,offsetFromTitle,divider;
             if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
             {
                 NSLog(@"Ipad");
                 fontsize = 20.0;
                 indentation= 20.0;
                 lineSpacing= 10.0;
                 paragraphSpacing=12.0;
                 offsetFromTitle = 20;
                 divider = 100;
             }
             else if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen . size. height==568))
             {
                 NSLog(@"Ipod");
                 fontsize = 16.0;
                 indentation= 1.0;
                 lineSpacing= 2.0;
                 paragraphSpacing=1.0;
                 offsetFromTitle = 10;
                 divider = 15;
             }
             else {
                 NSLog(@"Iphone");
                 fontsize = 18.0;
                 indentation= 1.0;
                 lineSpacing= 2.0;
                 paragraphSpacing=1.0;
                 offsetFromTitle = 10;
                 divider = 50;
             }

             subcriptionContent = [[UITextView alloc]init];
             subcriptionContent.frame = CGRectMake(0,0, textviewWidth, fullScreen.size.height/6);

            subcriptionContent.center =CGPointMake(centerX, bannerImageview.center.y+bannerImageview.bounds.size.height*2+40);
             subcriptionContent.text = subscription_Details;

             NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:subscription_Details];
             NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
             paragraphStyle.lineSpacing = 10;
             NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
             [attributedString addAttributes:dict range:NSMakeRange(0, subscription_Details.length)];
             subcriptionContent.attributedText = attributedString;
             subcriptionContent.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontsize];
             subcriptionContent.layer.cornerRadius = 25;
             subcriptionContent.clipsToBounds = NO;
             subcriptionContent.backgroundColor = [UIColor clearColor];
             subcriptionContent.editable = NO;
             subcriptionContent.clipsToBounds = NO;
             subcriptionContent.userInteractionEnabled = NO;
             subcriptionContent.textColor  = [UIColor colorWithRed:177.0f/255.0f green:177.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
             subcriptionContent.delegate = self;
             subcriptionContent.attributedText = [self attributedStringForBulletTexts:stringArray
                                                                withFont:[UIFont fontWithName:@"Lora-Regular" size:fontsize]
                                                            bulletString:@" ● "
                                                             indentation:indentation
                                                             lineSpacing:lineSpacing
                                                        paragraphSpacing:paragraphSpacing
                                                               textColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f]
                                                                          bulletColor:[UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];



             subcriptionContent.layer.cornerRadius = 25;
           // subcriptionContent.text.le
             [backgroundview addSubview:subcriptionContent];
             NSLog(@"Content height %f bounds height %f ",subcriptionContent.contentSize.height,subcriptionContent.bounds.size.height);



            NSLog(@"not purchased new user-----");

        }

    }


    UILabel *renewableLable = [[UILabel alloc] init];
    renewableLable.frame = CGRectMake(0, 0, fullScreen.size.width, customBarHeight);

    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        if (@available(iOS 14.2, *))
        {

//                renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4-subcriptionContent.contentSize.height/2);
            renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height/2+buttonViewHeight/2);
        }
        else
        {
//                renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4-subcriptionContent.contentSize.height/5);
            renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height/2+buttonViewHeight/2);
        }

    }
    else
    {
//        renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4-subcriptionContent.contentSize.height/5);
        renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height/2+buttonViewHeight/2+buttonViewHeight/4);
    }

//    renewableLable.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4-subcriptionContent.contentSize.height/5);
    renewableLable.backgroundColor = [UIColor clearColor];
    renewableLable.shadowOffset = CGSizeMake(0, 1);
    renewableLable.textColor = [UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f]; // change here color //
    renewableLable.textAlignment=NSTextAlignmentCenter;
    renewableLable.text = @"Auto-renewable,Cancel anytime.";
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        renewableLable.font  = [UIFont fontWithName:@"Lora-Regular" size:18.0];
    else
        renewableLable.font  = [UIFont fontWithName:@"Lora-Regular" size:14.0];
    [backgroundview addSubview:renewableLable];


    UIButton *purchaseRestoreButton = [[UIButton alloc]init];
    purchaseRestoreButton.frame = CGRectMake(0, 0, fullScreen.size.width/2+20, 50);
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        if (@available(iOS 14.2, *))
        {

//            purchaseRestoreButton.center = CGPointMake(centerX, renewableLable.center.y+renewableLable.frame.size.height+renewableLable.frame.size.height/4);

            purchaseRestoreButton.center = CGPointMake(centerX, renewableLable.center.y+renewableLable.frame.size.height/2);

        }
        else
        {
//            purchaseRestoreButton.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4);
            purchaseRestoreButton.center = CGPointMake(centerX, renewableLable.center.y+renewableLable.frame.size.height/2);

        }
    }
    else
    {
//        purchaseRestoreButton.center = CGPointMake(centerX, subcriptionContent.center.y+subcriptionContent.contentSize.height+subcriptionContent.contentSize.height/4);

        purchaseRestoreButton.center = CGPointMake(centerX, renewableLable.center.y+renewableLable.frame.size.height/2);

    }

    [purchaseRestoreButton addTarget:self action:@selector(ResoreSubscription) forControlEvents:UIControlEventTouchUpInside];
   [purchaseRestoreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
   // purchaseRestoreButton.showsTouchWhenHighlighted = true;
    purchaseRestoreButton.userInteractionEnabled = YES;
   [backgroundview addSubview:purchaseRestoreButton];

    NSMutableAttributedString *Undtextline = [[NSMutableAttributedString alloc] initWithString:@"Restore Purchase"];
    [Undtextline addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, Undtextline.length)];

    UILabel *restoreLabel = [[UILabel alloc] init];
    restoreLabel.frame = purchaseRestoreButton.bounds;
    restoreLabel.center = purchaseRestoreButton.center;
    restoreLabel.textAlignment = NSTextAlignmentCenter;
    restoreLabel.backgroundColor = [UIColor clearColor];
    restoreLabel.shadowOffset = CGSizeMake(0, 1);
    restoreLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
    [restoreLabel setAttributedText:Undtextline];
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        restoreLabel.font  = [UIFont fontWithName:@"Lora-Regular" size:18.0];
    else restoreLabel.font  = [UIFont fontWithName:@"Lora-Regular" size:15.0];
    [backgroundview addSubview:restoreLabel];



    UILabel *subTermsLable = [[UILabel alloc] init];
    subTermsLable.frame = CGRectMake(0,0, fullScreen.size.width, 25);
    subTermsLable.center = CGPointMake(centerX, purchaseRestoreButton.center.y+purchaseRestoreButton.bounds.size.height/2+heightOffset);
    subTermsLable.backgroundColor = [UIColor clearColor];
    subTermsLable.shadowOffset = CGSizeMake(0, 1);
    subTermsLable.textColor = [UIColor blackColor];
    subTermsLable.textAlignment = NSTextAlignmentCenter;
    subTermsLable.text = @"Subscription Terms";
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        subTermsLable.font  = [UIFont fontWithName:@"Lora-SemiBold" size:18.0];
    else
        subTermsLable.font  = [UIFont fontWithName:@"Lora-SemiBold" size:15.0];
    [backgroundview addSubview:subTermsLable];


    UITextView *termsnConditionTextview = [[UITextView alloc]init];
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    termsnConditionTextview.frame = CGRectMake(0, 0, fullScreen.size.width - fullScreen.size.width/8, fullScreen.size.height/6);
    else
        termsnConditionTextview.frame = CGRectMake(0, 0, fullScreen.size.width, fullScreen.size.height/4);
    termsnConditionTextview.center = CGPointMake(centerX, subTermsLable.center.y+subTermsLable.bounds.size.height/2+(3*heightOffset));
    termsnConditionTextview.text = terms_n_conditions_text;
    NSMutableAttributedString *termsnConditionAttributedString = [[NSMutableAttributedString alloc] initWithString:terms_n_conditions_text];
        NSMutableParagraphStyle *tcParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    tcParagraphStyle.lineSpacing = 5;
        NSDictionary *tcDict = @{NSParagraphStyleAttributeName : tcParagraphStyle };
        [termsnConditionAttributedString addAttributes:tcDict range:NSMakeRange(0, terms_n_conditions_text.length)];
  //  termsnConditionTextview.attributedText = termsnConditionAttributedString;
    termsnConditionTextview.font  = [UIFont fontWithName:@"Lora-Regular" size:12.0];
   // termsnConditionTextview.font = [UIFont systemFontOfSize:14.0];
//    termsnConditionTextview.textColor  = [UIColor colorWithRed:177.0f/255.0f green:177.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
    termsnConditionTextview.textColor  = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    termsnConditionTextview.clipsToBounds = NO;
    termsnConditionTextview.backgroundColor = [UIColor clearColor];
    termsnConditionTextview.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    [backgroundview addSubview:termsnConditionTextview];
    termsnConditionTextview.editable = NO;
    termsnConditionTextview.clipsToBounds = NO;
    termsnConditionTextview.userInteractionEnabled = NO;

    NSLog(@"bounds height %f,content height %f",termsnConditionTextview.bounds.size.height,termsnConditionTextview.contentSize.height);
    UILabel *accepting = [[UILabel alloc] init];
    accepting.frame = CGRectMake(0, 0,fullScreen.size.width, 25);
    NSLog(@"bounds height termsn Condition Textview content height %f, cente y %f",termsnConditionTextview.contentSize.height,termsnConditionTextview.center.y);
//    if (@available(iOS 17.0, *)) {
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        accepting.center =CGPointMake(centerX, termsnConditionTextview.center.y+termsnConditionTextview.contentSize.height+heightOffset/2); //2+heightOffset
    }
    else
    {
        if (@available(iOS 17.0, *)) {
            accepting.center =CGPointMake(centerX, termsnConditionTextview.center.y+termsnConditionTextview.contentSize.height+heightOffset/2); //2+heightOffset
        }
        else
        {
//            accepting.center =CGPointMake(centerX, termsnConditionTextview.center.y+termsnConditionTextview.contentSize.height-heightOffset);
//            //2+heightOffset
            accepting.center =CGPointMake(centerX, termsnConditionTextview.center.y+termsnConditionTextview.contentSize.height-heightOffset/2);
        }
    }

    accepting.textAlignment = NSTextAlignmentCenter;
    accepting.backgroundColor = [UIColor clearColor];
    accepting.shadowOffset = CGSizeMake(0, 1);
    accepting.textColor = [UIColor blackColor];
    accepting.text = @"By continuing you accept our ";


    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        accepting.font = [UIFont fontWithName:@"Lora-Regular" size:16.0];
    else accepting.font = [UIFont fontWithName:@"Lora-Regular" size:14.0];
   // lora_medium.ttf
    [backgroundview addSubview:accepting];


    UILabel *andLabel = [[UILabel alloc] init];
    andLabel.frame = CGRectMake(0, 0, 50, customBarHeight);
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        andLabel.center = CGPointMake(centerX+centerX/20, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);

    }
    else
    {
        andLabel.center = CGPointMake(centerX+centerX/10, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);

    }
    andLabel.backgroundColor = [UIColor clearColor];
    andLabel.shadowOffset = CGSizeMake(0, 1);
    andLabel.textColor = [UIColor blackColor] ;
    andLabel.text = @"and";

    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        andLabel.font = [UIFont fontWithName:@"Lora-Regular" size:15.0];
    else
        andLabel.font = [UIFont fontWithName:@"Lora-Regular" size:14.0];
    [backgroundview addSubview:andLabel];



    UIButton *privacybutton = [[UIButton alloc]init];
    privacybutton.frame = CGRectMake(0, 0,110, 50);
   // privacybutton.frame = CGRectMake((andLabel.center.x-andLabel.bounds.size.width/2-110), andLabel.center.y-andLabel.bounds.size.height/2, 100, 50);
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        privacybutton.center = CGPointMake(andLabel.center.x-andLabel.bounds.size.width/2-privacybutton.bounds.size.width/2, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);
    }
    else
    {
        privacybutton.center = CGPointMake(andLabel.center.x-andLabel.bounds.size.width/2-privacybutton.bounds.size.width/2, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);

    }

    [privacybutton addTarget:self action:@selector(Privacypolicy:) forControlEvents:UIControlEventTouchUpInside];
    [privacybutton setBackgroundColor:[UIColor clearColor]];
    privacybutton.userInteractionEnabled = YES;
    [backgroundview addSubview:privacybutton];

    //-------------UnderlineText-------------------//

    NSMutableAttributedString *Undtext = [[NSMutableAttributedString alloc] initWithString:@"Privacy Policy" ];
    [Undtext addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, Undtext.length)];


    UILabel *privacyLabel = [[UILabel alloc] init];
    privacyLabel.frame = privacybutton.frame;
    privacyLabel.center = privacybutton.center;
    privacyLabel.backgroundColor = [UIColor clearColor];
    privacyLabel.shadowOffset = CGSizeMake(0, 1);
    privacyLabel.textAlignment = NSTextAlignmentCenter;
    privacyLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
    [privacyLabel setAttributedText:Undtext];
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        privacyLabel.font = [UIFont fontWithName:@"Lora-Regular" size:16.0];
    else privacyLabel.font = [UIFont fontWithName:@"Lora-Regular" size:14.0];
    [backgroundview addSubview:privacyLabel];

    NSMutableAttributedString *Undtext2 = [[NSMutableAttributedString alloc] initWithString:@"Terms of use"];
    [Undtext2 addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, Undtext2.length)];



    UIButton *termsButton = [[UIButton alloc]init];
    termsButton.frame = CGRectMake(0, 0, 100, 50);
    //termsButton.frame = CGRectMake((andLabel.bounds.size.width+10), andLabel.center.y-andLabel.bounds.size.height/2, 100, 50);
    termsButton.center = CGPointMake(andLabel.center.x+andLabel.bounds.size.width+10, accepting.center.y+accepting.bounds.size.height/2+heightOffset/2);
    [termsButton addTarget:self action:@selector(TermsofCondition) forControlEvents:UIControlEventTouchUpInside];
    [termsButton setBackgroundColor:[UIColor clearColor]];
    termsButton.userInteractionEnabled = YES;
    [backgroundview addSubview:termsButton];


    UILabel *termsLabel = [[UILabel alloc] init];
    termsLabel.frame = termsButton.bounds;
    termsLabel.center = termsButton.center;
    termsLabel.backgroundColor = [UIColor clearColor];
    termsLabel.shadowOffset = CGSizeMake(0, 1);
    termsLabel.textAlignment = NSTextAlignmentLeft;
    termsLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:86.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
    [termsLabel setAttributedText:Undtext2];
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
        termsLabel.font = [UIFont fontWithName:@"Lora-Regular" size:16.0];
    else
        termsLabel.font = [UIFont fontWithName:@"Lora-Regular" size:14.0];
    [backgroundview addSubview:termsLabel];


    if (TrailPeriodDaysYearly>=0) {

        if(self.purchasedCountIs>0)
        {

            float ratio = (termsLabel.center.y+termsLabel.bounds.size.height*3)/fullScreen.size.height;
            NSLog(@" page content height %f, ratio  %f",termsLabel.center.y+termsLabel.bounds.size.height,ratio);
            scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *ratio);
        }

        else
        {
            if(self.subCountIs >1)
            {
                float ratio = (termsLabel.center.y+termsLabel.bounds.size.height*7)/fullScreen.size.height;
                NSLog(@" page content height firstmode %f, ratio  %f",termsLabel.center.y+termsLabel.bounds.size.height,ratio);
                scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *ratio);
            }
            else
            {
                float ratio = (termsLabel.center.y+termsLabel.bounds.size.height*3)/fullScreen.size.height;
                NSLog(@" page content height else %f, ratio  %f",termsLabel.center.y+termsLabel.bounds.size.height,ratio);
                scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *ratio);
            }



        }
    }
    //subscriptionView.frame = CGRectMake(0.0,0.0, fullScreen.size.width,subscriptionView);
   // subscriptionView.contentMode = UIViewContentModeScaleAspectFill;
}

#pragma SubscriptionDetails
-(void)SubscriptionDetailsWeekly
{
    if (@available(iOS 11.2, *)) {
        firstsubscriptionPriceWeekly = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPackWeekly];
    NSLog(@"Subscription price----- %@",firstsubscriptionPriceWeekly);
    NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPackWeekly];
    NSLog(@"Subscription Title----- %@",firstsubscriptionTitle);

    NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPackWeekly];
        TrailPeriodDaysWeekly = [[InAppPurchaseManager Instance]getTrailPeriodofProductForWeek:kInAppPurchaseSubScriptionPackWeekly];
        NSLog(@"Subscription Trail period----- %ld",TrailPeriodDaysWeekly);

        if(nil == firstsubscriptionPriceWeekly)
        {
            firstsubscriptionPriceWeekly = DEFAULT_Weekly_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;

        }

    }
    else
    {
        firstsubscriptionPriceWeekly = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPackWeekly];
        NSLog(@"Subscription price----- %@",firstsubscriptionPriceWeekly);
        NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPackWeekly];
        NSLog(@"Subscription Title----- %@",firstsubscriptionTitle);

        NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPackWeekly];
        NSLog(@"Subscription Description----- %@",firstsubscriptionDescription);
        if(nil == firstsubscriptionPriceWeekly)
        {
            firstsubscriptionPriceWeekly = DEFAULT_Weekly_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
        }
    }
}

-(void)SubscriptionDetails
{
    if (@available(iOS 11.2, *)) {
    firstsubscriptionPrice = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPack];
    NSLog(@"Subscription price----- %@",firstsubscriptionPrice);
    NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPack];
    NSLog(@"Subscription Title----- %@",firstsubscriptionTitle);

    NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPack];
        TrailPeriodDays = [[InAppPurchaseManager Instance]getTrailPeriodofProductForMonth:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription Trail period----- %ld",TrailPeriodDays);

        if(nil == firstsubscriptionPrice)
        {
            firstsubscriptionPrice = DEFAULT_WATERMARK_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;

        }

    }
    else
    {
        firstsubscriptionPrice = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription price----- %@",firstsubscriptionPrice);
        NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription Title----- %@",firstsubscriptionTitle);

        NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPack];
        NSLog(@"Subscription Description----- %@",firstsubscriptionDescription);
        if(nil == firstsubscriptionPrice)
        {
            firstsubscriptionPrice = DEFAULT_WATERMARK_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
        }
    }


}

-(void)SubscriptionDetailsYearly
{
    if (@available(iOS 11.2, *)) {
    firstsubscriptionPriceYearly = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPackYearly];
    NSLog(@"Subscription price -----yearly %@",firstsubscriptionPriceYearly);
    NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPackYearly];
    NSLog(@"Subscription Title-----yearly %@",firstsubscriptionTitle);

    NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPackYearly];
        TrailPeriodDaysYearly = [[InAppPurchaseManager Instance]getTrailPeriodofProductForYear:kInAppPurchaseSubScriptionPackYearly];
       // TrailPeriodDaysConv = [[InAppPurchaseManager Instance]peroidUnitToString:<#(SKProduct *)#>]
        NSLog(@"Subscription Trail period-----yearly %ld",TrailPeriodDaysYearly);
//        if(TrailPeriodDaysYearly==nil)
//        {
//           // TrailPeriodDaysYearly = DEFAULT_Trail_Period;
//
//            NSLog(@"Default Trail Period");
//        }
        if(nil == firstsubscriptionPriceYearly)
        {
            firstsubscriptionPriceYearly = DEFAULT_YEARLY_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;

        }

    }
    else
    {
        firstsubscriptionPriceYearly = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseSubScriptionPackYearly];
        NSLog(@"Subscription price-----yearly %@",firstsubscriptionPriceYearly);
        NSString *firstsubscriptionTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseSubScriptionPackYearly];
        NSLog(@"Subscription Title-----yearly %@",firstsubscriptionTitle);

        NSString *firstsubscriptionDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseSubScriptionPackYearly];
        NSLog(@"Subscription Description-----yearly %@",firstsubscriptionDescription);
        if(nil == firstsubscriptionPriceYearly)
        {
            firstsubscriptionPriceYearly = DEFAULT_YEARLY_PACK_PRICE;
            firstsubscriptionTitle = DEFAULT_WATERMARK_PACK_TITLE;
            firstsubscriptionDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
        }
    }


   // [preview showInAppPurchaseWithPackages:packages];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"simple subscription will appear hides navigation bar");
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)closeIfNotLoaded
{
    [LoadingClass removeActivityIndicatorFrom:self.view];
    [loadingBg removeFromSuperview];
    NSLog(@"close immmediately----");
}

-(void)closingSubscriptionPage
{
    purchasedHere = YES;
    [self hideActivityIndicator];
    [closeLoading removeFromSuperview];
    
     NSLog(@"Closing subscription Page");
     NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
     [prefs setInteger:1 forKey:@"SubscriptionExpired"];
     purchasedHere = YES;
     NSLog(@"Removing Subscription view");
     [self.navigationController popViewControllerAnimated:NO];
     [LoadingClass removeActivityIndicatorFrom:loadingBg];
     [loadingBg removeFromSuperview];


    if([[SRSubscriptionModel shareKit]IsAppSubscribed])
     {
         NSLog(@"Product purchased*****");
         
         [[SRSubscriptionModel shareKit]CheckingExpiryHere];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"HideNativeAdd" object:nil];
         [self hideActivityIndicator];
         [self goBack];
    }
    NSLog(@"view came back---");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideNativeAdd" object:nil];

}


-(void)UnLockingAllFeaturesDate
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // saving an Integer
   [prefs setInteger:1 forKey:@"SubscriptionExpiredDate"];
}
-(void)UnLockingAllFeaturesTime
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // saving an Integer
   [prefs setInteger:1 forKey:@"SubscriptionExpiredTime"];
}

#pragma ActivtyIndicator
-(void)showLoadingForRestore
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [LoadingClass addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"Restoring Purchase",@"Restoring Purchase")];
    [self performSelector:@selector(startFramesdownloading) withObject:nil afterDelay:3.0 ];
}

-(void)startFramesdownloading
{
    [self performSelector:@selector(hideActivityIndicatorForRestore) withObject:nil afterDelay:40.0 ];
}

-(void)hideActivityIndicatorForRestore
{
    [LoadingClass removeActivityIndicatorFrom:self.view];
}

-(void)hideActivityIndicator
{
    [LoadingClass removeActivityIndicatorFrom:self.view];
    [self goBack];
}

-(void)hideActivityIndicatorPurchase
{
    NSLog(@"closing page-----");
    dispatch_async(dispatch_get_main_queue(), ^{
    [loadingBg removeFromSuperview];
    [LoadingClass removeActivityIndicatorFrom:loadingBg];
        if (purchasedHere) {
            purchasedHere = NO;
            [self goBack];
        }
    });
}

-(void)hideActivityIndicatorHere
{
    purchasedHere = NO;
    [self hideActivityIndicatorPurchase];
}


-(void)showLoadingForPurchase
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    loadingBg = [[UIView alloc]init];
    loadingBg.frame = CGRectMake(0, 0, 200, 200);

    loadingBg.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    loadingBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loadingBg];

    [LoadingClass addActivityIndicatotTo:loadingBg withMessage:NSLocalizedString(@"Processing",@"Processing")];
    closeLoading = [UIButton buttonWithType:UIButtonTypeCustom];
    closeLoading.frame = CGRectMake(30,50, toolbarHeight-20, toolbarHeight-20);
    [closeLoading setImage:[UIImage imageNamed:@"closeLoading"] forState:UIControlStateNormal];
    [closeLoading addTarget:self action:@selector(hideActivityIndicatorHere) forControlEvents:UIControlEventTouchUpInside];
    [loadingBg addSubview:closeLoading];
    [self.view bringSubviewToFront:loadingBg];
}


//- (void)dealloc
//{
//    [_hiddenView release];
//    [_shrinkLabel release];
//    [super dealloc];
//
//}
#pragma mark Trail period

-(int)numberOfDaysForUnit:(SKProductPeriodUnit)unit API_AVAILABLE(ios(11.2)){
    if (@available(iOS 11.2, *)) {
        if(SKProductPeriodUnitDay == unit)
        {
            return 1;
        }
        else if(SKProductPeriodUnitWeek == unit)
        {
            return 7;
            NSLog(@"week section----2");
        }
        else if(SKProductPeriodUnitYear == unit)
        {
            return 365;
        }
        else if(SKProductPeriodUnitMonth == unit)
        {
            return 30;

        }
    } else {
        // Fallback on earlier versions
    }
    return 0;
}
-(long)getNumberOfDaysFreeTrailforProduct:(SKProduct*)prd
{
    long numberOfDays = 0;
    long numberOfPeroids = 0;
    if(nil == prd){
        return numberOfDays;
    }
    if (@available(iOS 11.2, *)) {
        if(nil == prd.introductoryPrice){
            return numberOfDays;
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 11.2, *)) {
        numberOfPeroids = [prd.introductoryPrice numberOfPeriods];
        numberOfDays = [self numberOfDaysForUnit:[[prd.introductoryPrice subscriptionPeriod]unit]];
        long numOfUnits = [[prd.introductoryPrice subscriptionPeriod]numberOfUnits];
        numberOfDays = numberOfPeroids * numOfUnits;
        return numberOfDays;
    } else {
        // Fallback on earlier versions
    }


    return numberOfDays;
}
#pragma mark SubscriptionNewImage
-(void)SubscriptionNewImage
{

    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {

        features_frame = CGRectMake(0,50, fullScreen.size.width, fullScreen.size.height/2);

    }

    else
    {

        if (fullScreen.size.height > 600)
        {


//            features_frame = CGRectMake(0,35, fullScreen.size.width, fullScreen.size.height/2);
//
            features_frame = CGRectMake(0,50, fullScreen.size.width, 300);
            NSLog(@"Ipone 6 and above------");
        }


        else if (fullScreen.size.height > 480.0)
        {

          //  features_frame = CGRectMake(0,32, fullScreen.size.width, fullScreen.size.height/2);
            features_frame = CGRectMake(0,40, fullScreen.size.width, 260);
        }

        else
        {

            features_frame = CGRectMake(0,50, fullScreen.size.width, fullScreen.size.height/2);
        }

    }

    features =[[UIImageView alloc]initWithFrame:features_frame];
    features.image=[UIImage imageNamed:@"subcription_details.jpg"];

//    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
//    {
//        features.image=[UIImage imageNamed:@"subcription_details.jpg"];
//    }
//    else
//    {
//        features.image=[UIImage imageNamed:@"for-iphone.jpg"];
//    }

   // for-iphone.jpg
    [_mytextView addSubview:features];

}
-(NSString*)peroidUnitToString:(SKProduct*)product
{
    NSString *data = nil;

    if (@available(iOS 11.2, *)) {
        if(SKProductPeriodUnitDay == product.subscriptionPeriod.unit)
        {
            if(product.subscriptionPeriod.numberOfUnits > 0)
            {
                data = [NSString stringWithFormat:@"per %lu days",(unsigned long)product.subscriptionPeriod.numberOfUnits];
            }
            else{
                data = [NSString stringWithFormat:@"per day"];
            }
        }
        else if(SKProductPeriodUnitWeek == product.subscriptionPeriod.unit)
        {
            if(product.subscriptionPeriod.numberOfUnits > 0)
            {
                data = [NSString stringWithFormat:@"per %lu weeks",(unsigned long)product.subscriptionPeriod.numberOfUnits];
            }
            else{
                data = [NSString stringWithFormat:@"per week"];
            }
        }
        else if(SKProductPeriodUnitYear == product.subscriptionPeriod.unit)
        {
            if(product.subscriptionPeriod.numberOfUnits > 0)
            {
                data = [NSString stringWithFormat:@"per %lu years",(unsigned long)product.subscriptionPeriod.numberOfUnits];
            }
            else{
                data = [NSString stringWithFormat:@"per year"];
            }
        }
        else if(SKProductPeriodUnitMonth == product.subscriptionPeriod.unit)
        {
            if(product.subscriptionPeriod.numberOfUnits > 0)
            {
                if(product.subscriptionPeriod.numberOfUnits == 1)
                {
                    data = [NSString stringWithFormat:@"per %lu month",(unsigned long)product.subscriptionPeriod.numberOfUnits];
                }
                else{
                    data = [NSString stringWithFormat:@"per %lu months",(unsigned long)product.subscriptionPeriod.numberOfUnits];
                }
            }
            else{
                data = [NSString stringWithFormat:@"per month"];
            }
        }
    } else {
        // Fallback on earlier versions
    }if (@available(iOS 11.2, *)) {
        if(SKProductPeriodUnitWeek == product.subscriptionPeriod.unit)
        {
            if(product.subscriptionPeriod.numberOfUnits > 0)
            {
                data = [NSString stringWithFormat:@"per %lu weeks",(unsigned long)product.subscriptionPeriod.numberOfUnits];
            }
            else{
                data = [NSString stringWithFormat:@"per week"];
            }
        }
        else if(SKProductPeriodUnitYear == product.subscriptionPeriod.unit)
        {
            if(product.subscriptionPeriod.numberOfUnits > 0)
            {
                data = [NSString stringWithFormat:@"per %lu years",(unsigned long)product.subscriptionPeriod.numberOfUnits];
            }
            else{
                data = [NSString stringWithFormat:@"per year"];
            }
        }
        else if(SKProductPeriodUnitMonth == product.subscriptionPeriod.unit)
        {
            if(product.subscriptionPeriod.numberOfUnits > 0)
            {
                if(product.subscriptionPeriod.numberOfUnits == 1)
                {
                    data = [NSString stringWithFormat:@"per %lu month",(unsigned long)product.subscriptionPeriod.numberOfUnits];
                }
                else{
                    data = [NSString stringWithFormat:@"per %lu months",(unsigned long)product.subscriptionPeriod.numberOfUnits];
                }
            }
            else{
                data = [NSString stringWithFormat:@"per month"];
            }
        }
    } else {
        // Fallback on earlier versions
    }

    return data;
}
-(void)purchaseMonthButtonWithFreeTrailMonth
{

}




-(void)purchaseMonthButtonWithFreeTrailYear
{


}

- (void)startBackgroundTask {
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        // Handle expiration of the background task
        [self endBackgroundTask];
    }];
}
- (void)endBackgroundTask {
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
}


//Checking Expiry//
// Reciept Valiadation //

-(void)CheckingExpiryHere
{
    //Loading the appstore receipt from apps main bundle.
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *receiptURL = [mainBundle appStoreReceiptURL];
    NSError *receiptError;
    BOOL isPresent = [receiptURL checkResourceIsReachableAndReturnError:&receiptError];

    if (!isPresent) {
        [self startBackgroundTask];
        //Refresh the receipt if its not found.
        SKReceiptRefreshRequest *request = [[SKReceiptRefreshRequest alloc] init];
        request.delegate = self;
        [request start];
        // Set a timeout for the request
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endBackgroundTask];
            });
        return;
    }

    //Loading the receipt data from the URL
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    //Base 64 encoding the receipt data
    NSString *encodedReceiptData = [receiptData base64EncodedStringWithOptions:0];
    // Create the POST request with payload to be sent to AppStore.
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\", \"password\" : \"%@\"}",
                    encodedReceiptData, secreteSharedKeyForSubcription];

    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];

    //Sending the data to appropreat store URL based on the kind of build.
    NSURL *storeURL;
#ifdef DEBUG
    storeURL= [[NSURL alloc] initWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
NSLog(@"Debugging mode---");
#else


    BOOL sandbox = [[receiptURL lastPathComponent] isEqualToString:@"sandboxReceipt"];

    storeURL = [[NSURL alloc] initWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
if (sandbox)
{
    storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    //[self showingAlertViewSandBox];
}
#endif

    /*
    #ifdef DEBUG
    NSURL *storeURL = [[NSURL alloc] initWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSLog(@"Debugging mode---");
   // [self showingAlertView];
    #else
    BOOL sandbox = [[receiptURL lastPathComponent] isEqualToString:@"sandboxReceipt"];
    if (sandbox) {
        storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
        //[self showingAlertViewSandBox];
    }
    else
    {
     storeURL = [[NSURL alloc] initWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
        //[self showingAlertViewAppstore];
    }

    #endif
    */
    //Sending the POST request.
    NSMutableURLRequest *storeRequest = [[NSMutableURLRequest alloc] initWithURL:storeURL ];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:payloadData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
    __auto_type task = [session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"We got the error while validating the receipt: %s", [[error description] UTF8String]);
            return;
        }
        NSError *localError = nil;
        //Parsing the response as JSON.
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&localError];

        //Getting the latest_receipt_info field value.
        NSArray *receiptInfo = jsonResponse[@"latest_receipt_info"];
        if(!receiptInfo || [receiptInfo count] == 0) {
            NSLog(@"%s", "Looks like this customer has no purchases!");
            return;
        }

        //This means this customer is not a free customer, lets verify whether their subscription is valid or not.
        for (NSDictionary *lastReceipt in receiptInfo) {
            //The purchased product id
            NSString *productID = lastReceipt[@"product_id"];
            NSLog(@"Product ID---%@",productID);
            //Boolean indicating whether the subscription is in trial period or not.
            NSString *isTrialPeriod = lastReceipt[@"is_trial_period"];
            NSLog(@"Trail Period---%@",isTrialPeriod);
            //The expires_date for the purchase.
            NSString *expiresDate = lastReceipt[@"expires_date"];
            NSLog(@"Expiry Date---%@",expiresDate);

            //storing Expire date Here newly//
            /*
            NSUserDefaults *userDefaultsStore = [NSUserDefaults standardUserDefaults];
            NSArray *customerNames = [userDefaultsStore objectForKey:@"SubscriptionStatusHere"];
            NSMutableArray *mCustomerNames = [customerNames mutableCopy];
            mCustomerNames[0] = expiresDate;
            [userDefaultsStore setObject:mCustomerNames forKey:@"SubscriptionStatusHere"];
            [userDefaultsStore synchronize];
            */
            //storing Expire Date Here //

            NSUserDefaults *userNamePrefs = [NSUserDefaults standardUserDefaults];
           // [userNamePrefs removeObjectForKey:@"SubscriptionStatusHere"];

            [userNamePrefs setObject:expiresDate forKey:@"SubscriptionStatusHere"];
//            [[NSUserDefaults standardUserDefaults] setObject:expiresDate forKey:@"SubscriptionStatusHere"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSLog(@"Expiry Date After saving---%@",expiresDate);

            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss VV"];
            //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormatter dateFromString:expiresDate];

            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian ];
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                fromDate:[NSDate date]
                                                                  toDate:date
                                                                 options:0];
            //Checking the subscription is still active and is not expired.
            //if([components day] > -1)
            if([components day] > -1) {
                //This means customer is on an active paid subscription.
              //  NSLog(@"currenttly Active Subscription Here---");
//                NSLog(@"Product: %s, %s", productId.c_str(), "Customer is a subscribed user!");
                return;
            }
            else
            {
                NSLog(@"Subscription Expired----");
            }

            //This means customers subscription has expired and we want to know why it expired
            NSString *expirationIntent = lastReceipt[@"expiration_intent"];
            NSLog(@"Expiration period-----%@",expirationIntent);
        }
        return;
    }];

    [task resume];
}
- (NSAttributedString *)attributedStringForBulletTexts:(NSArray *)stringList
                                              withFont:(UIFont *)font
                                          bulletString:(NSString *)bullet
                                           indentation:(CGFloat)indentation
                                           lineSpacing:(CGFloat)lineSpacing
                                      paragraphSpacing:(CGFloat)paragraphSpacing
                                             textColor:(UIColor *)textColor
                                           bulletColor:(UIColor *)bulletColor {

    NSDictionary *textAttributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: textColor};

    NSDictionary *bulletAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lora-Regular" size:30], NSForegroundColorAttributeName: bulletColor};

    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment: NSTextAlignmentLeft location:indentation options:@{}]];
    paragraphStyle.defaultTabInterval = indentation;
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.paragraphSpacing = paragraphSpacing;
    paragraphStyle.headIndent = indentation;

    NSMutableAttributedString *bulletList = [NSMutableAttributedString new];

    for (NSString *string in stringList) {
        NSString *formattedString = [NSString stringWithFormat:@"%@\t%@\n", bullet, string];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:formattedString];
        if ([string isEqualToString: stringList.lastObject]) {
            paragraphStyle = [paragraphStyle mutableCopy];
            paragraphStyle.paragraphSpacing = 0;
        }
        [attributedString addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttributes:textAttributes range:NSMakeRange(0, attributedString.length)];

        NSRange rangeForBullet = [formattedString rangeOfString:bullet];
        [attributedString addAttributes:bulletAttributes range:rangeForBullet];
        [bulletList appendAttributedString:attributedString];
    }

    return bulletList;
}

-(void)showAlertForInternetConnection
{
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"No Internet"message:@"Check your internet connection!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {[self dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:action];
    [self dismissViewControllerAnimated:YES completion:nil];
    [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    return;
}
-(void)checkingInternetConnection
{
    NSLog(@"background here---");
}


-(void)gettingPurchasedOrNot
{
    NSInteger purchasedCountHere = [Purchased_Number_defaults integerForKey:@"PurchasedCountIs"];

    self.purchasedCountIs = (int)purchasedCountHere;

    NSLog(@"Existing User Here---%d",self.purchasedCountIs);
}
-(void)gettingSubscriptionModeCount
{
    NSInteger sub_Count = [[NSUserDefaults standardUserDefaults] integerForKey:@"SubCountValue"];//[Subscription_Number_defaults integerForKey:@"subscription_mode"];

    self.subCountIs = (int)sub_Count;

    NSLog(@"sub_Count---%d",self.subCountIs);
}

#pragma mark RadioButtonsView

//RadioButton UI
-(void)createRadioButtonUI
{
    NSLog(@"radio Buttons---");

    radioBG = [[UIView alloc]init];
    radioBG.frame = CGRectMake(0, 0, fullScreen.size.width, fullScreen.size.height);
    radioBG.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
   // radioBG.hidden = YES;
    [self.view addSubview:radioBG];

    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, fullScreen.size.width, 200);
    if(([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad))
        title.center = CGPointMake(fullScreen.size.width/2,fullScreen.size.height*0.35);
    else
        title.center = CGPointMake(fullScreen.size.width/2,fullScreen.size.height*0.25);
    title.text = @"Choose your subscription";
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 2;
    title.textAlignment = NSTextAlignmentCenter;
    title.font =  [UIFont fontWithName:@"Gilroy-Medium" size:30];
    [radioBG addSubview:title];




    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, secondScreenbuttonWidth, secondScreenbuttonWidth);
    closeButton.center = CGPointMake(radioBG.frame.size.width-secondScreenbuttonWidth/2,secondScreenbuttonWidth/2);
    closeButton.userInteractionEnabled = YES;
    [closeButton setImage:[UIImage imageNamed:@"info_close.png"] forState:UIControlStateNormal];
  //  closeButton.showsTouchWhenHighlighted = YES;
    [closeButton addTarget:self action:@selector(CloseProcessView) forControlEvents:UIControlEventTouchUpInside];
    [radioBG addSubview:closeButton];

    NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:3];
    CGRect btnRect;
    if(([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad))
        btnRect = CGRectMake(fullScreen.size.width*0.4, fullScreen.size.height*0.4, fullScreen.size.width*0.7, 100);
    else
        btnRect = CGRectMake(fullScreen.size.width*0.2, fullScreen.size.height*0.35, fullScreen.size.width*0.8, 80);
    //CGRect btnRect = CGRectMake(25, 200, 120, 50);
    for (NSString* optionTitle in @[@"Yearly", @"Monthly", @"Weekly"]) {
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.y += 50;
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:activeTextColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:@"Gilroy-Medium" size:22];
        btn.tag += btnRect.origin.y;
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [radioBG addSubview:btn];
        [buttons addObject:btn];
    }

    if([[NSUserDefaults standardUserDefaults]integerForKey:@"SetProcessingSpeed"] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ProcessingSpeed"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SetProcessingSpeed"];
    }
    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    NSInteger speed = [[NSUserDefaults standardUserDefaults]integerForKey:@"ProcessingSpeed"];
//    speed = 1;
    if(speed == 0)
        [buttons[0] setSelected:YES]; // Making the first button initially selected
    else if(speed == 1)
        [buttons[1] setSelected:YES];
    else [buttons[2] setSelected:YES];


    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, fullScreen.size.width*0.45, 50);
    if(([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad))
        doneButton.center = CGPointMake(fullScreen.size.width/2,fullScreen.size.height *0.65);
    else
        doneButton.center = CGPointMake(fullScreen.size.width/2,fullScreen.size.height *0.8);
    doneButton.layer.cornerRadius = doneButton.bounds.size.height/2;
    doneButton.userInteractionEnabled = YES;
    doneButton.backgroundColor = activeTextColor;
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Gilroy-Medium" size:25];
  //  doneButton.showsTouchWhenHighlighted = YES;
    [radioBG addSubview:doneButton];
    [doneButton addTarget:self action:@selector(CloseProcessView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onRadioButtonValueWithUIButton:(RadioButton*)sender
{


//    [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
//

//        Accurate
        if(sender.tag == 500)
        {
            [monthlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            [weeklySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];


            [yearlySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];

            [purchaseMonthButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [purchaseWeekButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [purchaseYearButton setImage:[UIImage imageNamed:@"subscription_Selected_Bg"] forState:UIControlStateNormal];

        }
        else if(sender.tag == 501)
        {
            [yearlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
             [weeklySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];

             [monthlySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];

            [purchaseMonthButton setImage:[UIImage imageNamed:@"subscription_Selected_Bg"] forState:UIControlStateNormal];
            [purchaseWeekButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [purchaseYearButton setImage:[UIImage imageNamed:@"subscription_UnSelected_Bg"] forState:UIControlStateNormal];

        }
        else
        {
            [yearlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
             [monthlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];

             [weeklySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];

            [purchaseWeekButton setImage:[UIImage imageNamed:@"subscription_Selected_Bg"] forState:UIControlStateNormal];

            [purchaseMonthButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

            [purchaseYearButton setImage:[UIImage imageNamed:@"subscription_UnSelected_Bg"] forState:UIControlStateNormal];

            NSLog(@"tag 502 condition----");
        }

    subscriptionTag = sender.tag;

        [[NSUserDefaults standardUserDefaults]setInteger:subscriptionTag forKey:@"SubscriptionValue"];

        NSLog(@"subscriptionTag is %ld",(long)subscriptionTag);

}
-(void)onRadioButtonValueChanged:(RadioButton*)sender
{

    /*

    NSLog(@"radio button  tag is %ld",(long)sender.tag);

//    [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
//

//        Accurate
        if(sender.tag == 500)
        {
               [monthlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];
                [weeklySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];


                [yearlySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];

            NSLog(@"tag 500 condition----");
        }
        else if(sender.tag == 501)
        {
            [yearlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];
             [weeklySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];

             [monthlySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];

            NSLog(@"tag 501 condition----");
        }
        else
        {
            [yearlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];
             [monthlySelection setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];

             [weeklySelection setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];

            NSLog(@"tag 502 condition----");
        }

    subscriptionTag = sender.tag;

        [[NSUserDefaults standardUserDefaults]setInteger:subscriptionTag forKey:@"SubscriptionValue"];

        NSLog(@"subscriptionTag is %ld",(long)subscriptionTag);

    */

}
-(void)CloseProcessView
{
    radioBG.hidden = YES;
}
-(void)showRadioButtonUI
{
    radioBG.hidden = NO;
}

-(void)continuePurchaseUI
{
    float fontSize = 25;
    float ratio = 0.75f;
    float divideRatio = 10;
    float radius = 28;
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        NSLog(@"Title for ipad");
        fontSize = 30;
        ratio = 0.5f;
        divideRatio = 14;
        radius = 45;
    }
    else  if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height==568))
    {
        NSLog(@"Title for ipod");
        fontSize = 26;
        ratio = 0.6f;
        divideRatio = 12;
        radius = 28;
    }
    else
    {
        NSLog(@"Title for iphone");
        fontSize = 28;
        ratio = 0.6f;
        divideRatio = 12;
        radius = 30;
    }

    // add here separate UI //



    if (TrailPeriodDaysYearly>=0) {

        if(self.purchasedCountIs>0 || self.subCountIs == 1 || self.subCountIs == 0 || self.subCountIs == 3) //2
        {

            NSLog(@"continue Button clicking-----");


            //Gradient For Continue Button //

            gradienViewContinue = [[UIView alloc]init];
            gradienViewContinue.frame = CGRectMake(0, 0, fullScreen.size.width*2, fullScreen.size.height/4);
            gradienViewContinue.center = CGPointMake(0, fullScreen.size.height-fullScreen.size.height/8);
            gradienViewContinue.backgroundColor = [UIColor yellowColor];
          //  [self.view addSubview:gradienViewContinue];

            CAGradientLayer *gradient = [CAGradientLayer layer];

            gradient.frame = CGRectMake(0, fullScreen.size.height-fullScreen.size.height/4, fullScreen.size.width, fullScreen.size.height/4);

//            gradient.colors = @[(id)[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.0f].CGColor, (id)[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.0f].CGColor,(id)[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.8f].CGColor,(id)[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.8f].CGColor];
            
            gradient.colors = @[
                (id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f].CGColor,
                (id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f].CGColor,
                (id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f].CGColor,
                (id)[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f].CGColor
            ];


            [self.view.layer insertSublayer:gradient atIndex:2];


            
            continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            continueButton.frame = CGRectMake(0, 0,fullScreen.size.width*ratio,fullScreen.size.height/divideRatio);
            continueButton.frame = CGRectMake(0, 0,fullScreen.size.width*ratio+fullScreen.size.width/6,fullScreen.size.height/divideRatio);
            continueButton.center = CGPointMake(fullScreen.size.width/2, fullScreen.size.height- ((fullScreen.size.height/divideRatio)*1.2));

            continueButton.layer.cornerRadius = continueButton.bounds.size.height/2;
            continueButton.titleLabel.textColor = [UIColor blackColor];
            //continueButton.tag = subscriptionTag;
            continueButton.titleLabel.font = [UIFont fontWithName:@"Lora-SemiBold" size:fontSize];
            //    startButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            [continueButton setImage:[UIImage imageNamed:@"continue_Button1"] forState:UIControlStateNormal];
            //  [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
            [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            // [continueButton setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:98.0f/255.0f blue:16.0f/255.0f alpha:1.0f]];
            // continueButton.layer.borderColor = [UIColor whiteColor].CGColor;
            // continueButton.layer.borderWidth = 3;
            //    [startButton setTitleColor:[UIColor colorWithRed:25.0f/255.0f green:184.0f/255.0f blue:250.0f/255.0 alpha:1.0f] forState:UIControlStateNormal];
            continueButton.userInteractionEnabled = true;
            [continueButton addTarget:self action:@selector(continuePurchaseHere) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:continueButton];

            

            /*
            
            continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            continueButton.frame = CGRectMake(0, 0,fullScreen.size.width*ratio,fullScreen.size.height/divideRatio);
            continueButton.frame = CGRectMake(0, 0,fullScreen.size.width*ratio+fullScreen.size.width/6,fullScreen.size.height/divideRatio);
            continueButton.center = CGPointMake(fullScreen.size.width/2, fullScreen.size.height- ((fullScreen.size.height/divideRatio)*1.2));


            continueButton.layer.cornerRadius = continueButton.bounds.size.height/2;
            continueButton.titleLabel.textColor = [UIColor blackColor];
            //continueButton.tag = subscriptionTag;
            continueButton.titleLabel.font = [UIFont fontWithName:@"Lora SemiBold" size:fontSize];
            //    startButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];

            //  [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
            [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

             [continueButton setBackgroundColor:[UIColor clearColor]];
            // continueButton.layer.borderColor = [UIColor whiteColor].CGColor;
            // continueButton.layer.borderWidth = 3;
            //    [startButton setTitleColor:[UIColor colorWithRed:25.0f/255.0f green:184.0f/255.0f blue:250.0f/255.0 alpha:1.0f] forState:UIControlStateNormal];
            continueButton.userInteractionEnabled = true;
            [continueButton addTarget:self action:@selector(continuePurchaseHere) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:continueButton];

            [self lottieAnimationView];

            [self.view bringSubviewToFront:continueButton];

            */

            // Arrow Button //
            //rightArrow
            //right_svg
            UIImage *arrowimg = [UIImage imageNamed:@"rightArrow"];

            UIImage *tintedImageHome = [arrowimg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

            if (@available(iOS 13.0, *)) {
                tintedImageHome = [arrowimg imageWithTintColor:[UIColor whiteColor]];
            } else {
                // Fallback on earlier versions
            }

            UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
            {
                arrowButton.frame = CGRectMake(0, 0, 50,50);
                NSLog(@"Ipad Condition---");
            }
            else
            {
                arrowButton.frame = CGRectMake(0, 0, 20, 20);
            }

            arrowButton.center = CGPointMake(continueButton.frame.size.width-continueButton.frame.size.width/6, continueButton.bounds.size.height/2);
            [arrowButton setImage:tintedImageHome forState:UIControlStateNormal];
         //   [arrowButton setShowsTouchWhenHighlighted:YES];
            [arrowButton setTintColor:[UIColor whiteColor]];
            [arrowButton addTarget:self action:@selector(continuePurchaseHere) forControlEvents:UIControlEventTouchUpInside];
            [continueButton addSubview:arrowButton];


            BAShimmerButton *shimmerbutton = [[BAShimmerButton alloc] initWithFrame:continueButton.frame];
            [shimmerbutton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [shimmerbutton addTarget:self action:@selector(continuePurchaseHere) forControlEvents:UIControlEventTouchUpInside];
            shimmerbutton.shimmerColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
            shimmerbutton.layer.cornerRadius = shimmerbutton.bounds.size.height/2;
           // shimmerbutton.iconOffImageColor = [UIColor clearColor];
            [shimmerbutton setTintColor:[UIColor greenColor]];
            shimmerbutton.opaque = YES;
            [shimmerbutton showButtonWithAnimation:@NO];
            // Get the Layer of any view
            CALayer * layer = [shimmerbutton layer];
            [layer setMasksToBounds:YES];
            [layer setCornerRadius:shimmerbutton.bounds.size.height/2];

            // You can even add a border
            [layer setBorderWidth:0.0];
            [layer setBackgroundColor:[[UIColor clearColor] CGColor]];
            [layer setBorderColor:[[UIColor clearColor] CGColor]];
           [self.view addSubview:shimmerbutton];

            //Lottie Animation Playing//

            [self playAnimationForContinueButton];


            CGFloat StartLabelwidth = 130;
            UILabel *label = [[UILabel alloc]init];
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                StartLabelwidth = 180;
                label.frame = CGRectMake(continueButton.frame.size.width*0.42, 15,StartLabelwidth, customBarHeight);
            }
            else{

                label.frame = CGRectMake(continueButton.frame.size.width*0.25,2,StartLabelwidth, customBarHeight);
            }
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.shadowOffset = CGSizeMake(0, 1);
            label.textColor = [UIColor whiteColor];
            //    label.textColor = [UIColor colorWithRed:232.0f/255.0f green:0.0f/255.0f blue:40.0f/255.0 alpha:1.0f];
            label.text = @"CONTINUE";
            //label.text = [label.text uppercaseString];
            if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                label.font = [UIFont fontWithName:@"Lora-SemiBold" size:30];

            }
            else
            {
                label.font = [UIFont fontWithName:@"Lora-SemiBold" size:20];

            }
            label.center = continueButton.center;
            [self.view addSubview:label];

        }

        else
        {
            NSLog(@"separate Yearly Purchase Button----");
            if(self.subCountIs == 2)
            {
//            if(self.subCountIs ==2)
//            {

                yearlyViewBg = [[UIView alloc]init];
                if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                {
                    yearlyViewBg.frame = CGRectMake(centerX/10, fullScreen.size.height-fullScreen.size.height/5, fullScreen.size.width-fullScreen.size.width/11, fullScreen.size.width/4);
                }
                else
                {
                    yearlyViewBg.frame = CGRectMake(centerX/10, fullScreen.size.height-fullScreen.size.height/4-fullScreen.size.height/12, fullScreen.size.width-fullScreen.size.width/11, fullScreen.size.width/2);
                }
                yearlyViewBg.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:33.0/255.0 blue:78.0/255.0 alpha:1.0];
                yearlyViewBg.layer.cornerRadius = 20;
                yearlyViewBg.layer.borderWidth = 1;
                yearlyViewBg.layer.borderColor  = [UIColor colorWithRed:29.0/255.0 green:33.0/255.0 blue:78.0/255.0 alpha:1.0].CGColor;
                [self.view addSubview:yearlyViewBg];


                NSString *trailPeriodDaysYearlyText = [NSString stringWithFormat:@"%ld", TrailPeriodDaysYearly];



                freetrialTextLabel = [[UILabel alloc] init];
                freetrialTextLabel.frame = CGRectMake(0,0, textviewWidth+20, 80);
                freetrialTextLabel.center = CGPointMake(centerX, yearlyViewBg.frame.origin.y+20); //
                freetrialTextLabel.textAlignment = NSTextAlignmentCenter;
                freetrialTextLabel.backgroundColor = [UIColor clearColor];
                freetrialTextLabel.shadowOffset = CGSizeMake(0, 1);
                freetrialTextLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:224.0/255.0 blue:105.0/255.0 alpha:1.0];
                NSString *freeText = @"Start ";
                NSString *day_Trial_Then = @"- days trial today.";
                NSString *yearText = @"/year";

                // freetrialTextLabel.text = day_Trial_Then;

                //            freetrialTextLabel.text = [NSString stringWithFormat: @"%@ %@ %@ %@%@", freeText,trailPeriodDaysYearlyText,day_Trial_Then, firstsubscriptionPriceYearly,yearText];
                freetrialTextLabel.text = [NSString stringWithFormat: @"%@ %@ %@", freeText,trailPeriodDaysYearlyText,day_Trial_Then];
                if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                    [freetrialTextLabel setFont:[UIFont fontWithName:@"Lora-SemiBold" size:28.0]];
                else
                    [freetrialTextLabel setFont:[UIFont fontWithName:@"Lora-SemiBold" size:18.0]];
                [self.view addSubview:freetrialTextLabel];


                freeTrialButton = [UIButton buttonWithType:UIButtonTypeCustom];

                freeTrialButton = [UIButton buttonWithType:UIButtonTypeCustom];
                freeTrialButton.frame = CGRectMake(0, 0,fullScreen.size.width*ratio+fullScreen.size.width/6,fullScreen.size.height/divideRatio);
                freeTrialButton.center = CGPointMake(fullScreen.size.width/2-fullScreen.size.width/20, yearlyViewBg.frame.size.height- yearlyViewBg.frame.size.height/2- yearlyViewBg.frame.size.height/20);
                freeTrialButton.layer.cornerRadius = continueButton.bounds.size.height/2;
                freeTrialButton.titleLabel.textColor = [UIColor blackColor];
                //continueButton.tag = subscriptionTag;
                freeTrialButton.titleLabel.font = [UIFont fontWithName:@"Gilroy-Medium" size:fontSize];
                //            freeTrialButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
                //  [freeTrialButton setImage:[UIImage imageNamed:@"continue_Button"] forState:UIControlStateNormal];
                [freeTrialButton setTitle:@"Try Free & Subscribe" forState:UIControlStateNormal];


                [freeTrialButton setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
                freeTrialButton.layer.cornerRadius = 15;
                freeTrialButton.layer.borderColor = [UIColor whiteColor].CGColor;
                freeTrialButton.layer.borderWidth = 1;
                [freeTrialButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0 alpha:1.0f] forState:UIControlStateNormal];
                freeTrialButton.userInteractionEnabled = true;
                [freeTrialButton addTarget:self action:@selector(PurchaseSubscriptionYearly) forControlEvents:UIControlEventTouchUpInside];
                [yearlyViewBg addSubview:freeTrialButton];

                //continuePurchaseHere
                billingTextLabel = [[UILabel alloc] init];
                billingTextLabel.frame = CGRectMake(0, 0, fullScreen.size.width, customBarHeight);
                billingTextLabel.center = CGPointMake(freeTrialButton.frame.origin.x+freeTrialButton.frame.size.width/2, freeTrialButton.center.y+freeTrialButton.frame.size.height-freeTrialButton.frame.size.height/4);
                billingTextLabel.backgroundColor = [UIColor clearColor];
                billingTextLabel.shadowOffset = CGSizeMake(0, 1);
                billingTextLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]; // change here color //
                billingTextLabel.textAlignment=NSTextAlignmentCenter;
                billingTextLabel.text = [NSString stringWithFormat:@"Billed annually at, %@ %@." ,firstsubscriptionPriceYearly,yearText];
                if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                    billingTextLabel.font  = [UIFont fontWithName:@"Lora-Regular" size:18.0];
                else
                    billingTextLabel.font  = [UIFont fontWithName:@"Lora-Regular" size:12.0];
                [yearlyViewBg addSubview:billingTextLabel];

                cancelTextLabel = [[UILabel alloc] init];
                cancelTextLabel.frame = CGRectMake(0, 0, fullScreen.size.width, customBarHeight);
                if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                {
                    cancelTextLabel.center = CGPointMake(freeTrialButton.frame.origin.x+freeTrialButton.frame.size.width/2, billingTextLabel.center.y+billingTextLabel.frame.size.height/2);
                }
                else
                {
                    cancelTextLabel.center = CGPointMake(freeTrialButton.frame.origin.x+freeTrialButton.frame.size.width/2, billingTextLabel.center.y+billingTextLabel.frame.size.height/2);
                }

                cancelTextLabel.backgroundColor = [UIColor clearColor];
                cancelTextLabel.shadowOffset = CGSizeMake(0, 1);
                cancelTextLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]; // change here color //
                cancelTextLabel.textAlignment=NSTextAlignmentCenter;
                cancelTextLabel.text = @"Cancel anytime";
                if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                    cancelTextLabel.font  = [UIFont fontWithName:@"Lora-Regular" size:18.0];
                else
                    cancelTextLabel.font  = [UIFont fontWithName:@"Lora-Regular" size:14.0];
                [yearlyViewBg addSubview:cancelTextLabel];

            }
         //  [self pagecontrollView];





        }

    }


    [self addPagerView];
    [self addPageControl];

    [self loadData];

    starButtonView = [UIButton buttonWithType:UIButtonTypeCustom];

    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
//        starButtonView.frame = CGRectMake(centerX/2+centerX/3, bannerImageview.frame.size.height*2-bannerImageview.frame.size.height/4,90, 20);
//
        starButtonView.frame = CGRectMake(centerX-centerX/10,subscriptionTitle.center.y+subscriptionTitle.frame.size.height+subscriptionTitle.frame.size.height/4, 90, 20);


    }
    else
    {
        starButtonView.frame = CGRectMake(centerX/2+centerX/4, subscriptionTitle.center.y+subscriptionTitle.frame.size.height-subscriptionTitle.frame.size.height/6,90, 20);

    }

    starButtonView.titleLabel.textColor = [UIColor clearColor];
    starButtonView.backgroundColor = [UIColor clearColor];
    //continueButton.tag = subscriptionTag;

//            freeTrialButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [starButtonView setImage:[UIImage imageNamed:@"star_Image"] forState:UIControlStateNormal];

    [backgroundview addSubview:starButtonView];

}
-(void)starImageView
{



     [freeTrialButton setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    freeTrialButton.layer.cornerRadius = 15;
    freeTrialButton.layer.borderColor = [UIColor whiteColor].CGColor;
    freeTrialButton.layer.borderWidth = 1;
        [freeTrialButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0 alpha:1.0f] forState:UIControlStateNormal];
    freeTrialButton.userInteractionEnabled = true;
    [freeTrialButton addTarget:self action:@selector(PurchaseSubscriptionYearly) forControlEvents:UIControlEventTouchUpInside];
    [yearlyViewBg addSubview:freeTrialButton];
}

-(void)continuePurchaseHere
{
    NSInteger subValue = [[NSUserDefaults standardUserDefaults]integerForKey:@"SubscriptionValue"];

    NSLog(@"continuePurchaseHere is %ld",(long)subValue);

    if(subValue ==0)
    {
        subValue = 500;
    }
    

    if(subValue == 500)
    {
        [self PurchaseSubscriptionYearly];

        NSLog(@"yearly is coming---");

    }
    else if(subValue == 501)
    {
        [self buyMonthlySubscription];
        NSLog(@"monthly is coming---");
    }
    else
    {

        [self buyWeeklySubscription];

        NSLog(@"weekly is coming---");

    }
}

#pragma mark PageControllerView

-(void)pagecontrollView
{
    pageControlView = [[UIPageControl alloc]init];
    pageControlView.frame = CGRectMake(centerX/20, centerX, centerX*2-centerX/16, 70);
    pageControlView.backgroundColor = [UIColor lightGrayColor];
    pageControlView.currentPage = 0;

    //pageControlView.
    //pageControlView.pa
    pageControlView.numberOfPages = 3;
    [self.view addSubview:pageControlView];

}
- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
    {
        pagerView.frame = CGRectMake(0, centerX+centerX/8, fullScreen.size.width, 200);
    }
    else
    {
        pagerView.frame = CGRectMake(0, centerX, fullScreen.size.width, 200);
    }
    pagerView.frame = CGRectMake(0, centerX, fullScreen.size.width+fullScreen.size.width/4, 200);
    pagerView.backgroundColor = [UIColor clearColor];
    pagerView.layer.borderWidth = 0;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 3.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    //[self.view addSubview:pagerView];
    [backgroundview addSubview:pagerView];
    _pagerView = pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:109.0/255.0 green:119.0/255.0 blue:236.0/255.0 alpha:1.0];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
//    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
//    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
//    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
}
- (void)viewWillLayoutSubviews {
   [super viewWillLayoutSubviews];

   
   if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
   {

       _pagerView.frame = CGRectMake(0, starButtonView.center.y+starButtonView.frame.size.height, fullScreen.size.width, 60);
       _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame), CGRectGetWidth(_pagerView.frame), 26);
   }
   else
       
   {
       _pagerView.frame = CGRectMake(0, starButtonView.center.y+starButtonView.frame.size.height, fullScreen.size.width, 60);
       _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame), CGRectGetWidth(_pagerView.frame), 26);
   }

}
- (void)loadData {
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
        if (i == 0) {
            [datas addObject:[UIColor clearColor]];
            continue;
        }
       // [datas addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0]];
    }
    _datas = [datas copy];
    _pageControl.numberOfPages = pageViewContent.count;
    [_pagerView reloadData];
    //[_pagerView scrollToItemAtIndex:3 animate:YES];
}
#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return pageViewContent.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
   // cell.backgroundColor = _datas[index];
    cell.backgroundColor = [UIColor clearColor];
//    cell.label.text = [NSString stringWithFormat:@"index->%ld",index];
    cell.label.textColor = [UIColor blackColor];
    cell.label.numberOfLines = 0;

    cell.label.text = [pageViewContent objectAtIndex:index];
    // add font size here //
//    if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
//    {
//
//    }
//    else
//    {
//
//    }
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame)*0.8, CGRectGetHeight(pageView.frame)*0.8);
    layout.itemSpacing = 15;
    //layout.minimumAlpha = 0.3;
  //  layout.itemHorizontalCenter = _horCenterSwitch.isOn;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
   // NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}

#pragma mark ScrollviewDelegateMethods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
    
  // NSLog(@"scrollview contentoffset y %f",scrollView.contentOffset.y);
    
   
        if(scrollView.contentOffset.y >=15)
        {
            
            if(scrollView.contentOffset.y >=90)
            {
               
                if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
                {
                    //ipad condition//
                    if(scrollView.contentOffset.y >=230)
                    {
                        bannerImageview.alpha = 0.0;
                    }
                    else
                    {
                        bannerImageview.alpha = 0.3;
                    }
                   
                  
                }
                else
                {
                    bannerImageview.alpha = 0.0;
                 
                }
               
                
                
            }
            else
            {
                
                if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
                {
                    if(scrollView.contentOffset.y >=180)
                    {
                        bannerImageview.alpha = 0.0;
                    }
                    else
                    {
                        [UIView animateWithDuration:0.2 animations:^(void) {
                            bannerImageview.alpha = 0.3;
                            [self topBarAfterCollapse];
                           // bannerImageview.alpha = 0.0;
                           // NSLog(@"bannerimage value decreasing %f",bannerImageview.alpha);
                        }];
                    }
                }
                else
                {
                  
                    [UIView animateWithDuration:0.2 animations:^(void) {
                        bannerImageview.alpha = 0.3;
                        [self topBarAfterCollapse];
                       // bannerImageview.alpha = 0.0;
                       // NSLog(@"bannerimage value decreasing %f",bannerImageview.alpha);
                    }];
                }
                
            }
            
           }
        else
        {
           
            if(scrollView.contentOffset.y <=0)
            {
                [UIView animateWithDuration:0.2 animations:^(void) {
                    [self settingSubscriptionTitleoffsetNormal];
                    bannerImageview.alpha = 1.0;
                    //NSLog(@"bannerimage value increasig %f",bannerImageview.alpha);
                }];
            }
           

        }
       
  

}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollview is scrolling Ended here---");


}

#pragma mark Lottie_Animation
-(void) loadAnimation {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"continue_btn1" ofType:@"json"];
    NSData *myData = [NSData dataWithContentsOfFile:path];

    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:myData
                                                            options:kNilOptions
                                                              error:nil];

    self.animationView = [LOTAnimationView animationFromJSON:jsonDict];

}
-(void)playAnimationForContinueButton {

//    if ([self.animationView isAnimationPlaying]) {
//        [self.animationView stop];
//    }
//    [continueButton addSubview:self.animationView];
   // [self.view addSubview:self.animationView];
  //  [self.animationView play];
}

-(void)lottieAnimationView

{
    // Create the animation view
      // self.animationView = [LOTAnimationView animationNamed:@"continue - btn"]; // replace with your animation file name
    self.animationView = [LOTAnimationView animationNamed:@"mARkfHIUnp2"];
    //Animation - 1701411653726

       // Adjust the animation view's properties (if needed)
       self.animationView.loopAnimation = YES;
      // self.animationView.contentMode = UIViewContentModeScaleAspectFit;
        self.animationView.contentMode = UIViewContentModeScaleAspectFill;
       // self.animationView.layer.cornerRadius = 50;

       // Add the animation view to your view hierarchy
      // [self.view addSubview:self.animationView];

        [self.view addSubview:self.animationView];

       // Set the frame or constraints for the animation view
//       self.animationView.frame = CGRectMake(fullScreen.size.width/14, fullScreen.size.height/9, fullScreen.size.width-fullScreen.size.width/10, fullScreen.size.height/6); // adjust the frame as needed

      //  self.animationView.frame = CGRectMake(0, fullScreen.size.height/9, 343, 80);

    self.animationView.frame = continueButton.frame;
    self.animationView.center = continueButton.center;

       // Play the animation
       [self.animationView play];
}

#pragma mark collapsingView

-(void)settingSubscriptionTitleoffsetNormal
{
       [topStrip1 removeFromSuperview];
       [collapseBack removeFromSuperview];
        
       topStrip1 = nil;
       collapseBack = nil;
       
}
-(void)settingSubscriptionTitleoffsetCollapse
{

   
 
   subscriptionTitleSmall = [[UILabel alloc] init];
   subscriptionTitleSmall.frame = CGRectMake(0,0, textviewWidth+20, 80);
   if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
   {
       subscriptionTitleSmall.center = CGPointMake(fullScreen.size.width/2, topStrip1.bounds.size.height/2);
   }
   else
   {
       subscriptionTitleSmall.center = CGPointMake(fullScreen.size.width/2, topStrip1.bounds.size.height/2);
   }

   subscriptionTitleSmall.textAlignment = NSTextAlignmentCenter;
   subscriptionTitleSmall.backgroundColor = [UIColor clearColor];
   subscriptionTitleSmall.shadowOffset = CGSizeMake(0, 1);
   subscriptionTitleSmall.textColor = [UIColor blackColor] ;
   subscriptionTitleSmall.text = @"Subscription";
   if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
       [subscriptionTitleSmall setFont:[UIFont fontWithName:@"Lora-Italic" size:25.0]];
   else
       [subscriptionTitleSmall setFont:[UIFont fontWithName:@"Lora-Italic" size:23.0]];
   [topStrip1 addSubview:subscriptionTitleSmall];
   
   
   [self.view bringSubviewToFront:backButton];
   
//   collapseBack = [UIButton buttonWithType:UIButtonTypeCustom];
//   collapseBack.frame = CGRectMake(10, 10, backButtonWidthHeight-5, backButtonWidthHeight-5);
//   [collapseBack setImage:[UIImage imageNamed:@"close_watermark"] forState:UIControlStateNormal];
//    collapseBack.backgroundColor = UIColor.redColor;
//   [collapseBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
 //  collapseBack.showsTouchWhenHighlighted = true;

}

-(void)topBarAfterCollapse
{
   if(topStrip1 !=nil)
       
   {
       [topStrip1 removeFromSuperview];
       topStrip1 = nil;
   }
   
   topStrip1 = [[UIView alloc] init];
   if (UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
       [topStrip1 setFrame:CGRectMake(0,0, fullScreen.size.width,lowerstripheight+25)];
   else if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen . size. height==568))
       [topStrip1 setFrame:CGRectMake(0,0, fullScreen.size.width,lowerstripheight)];
   else
       [topStrip1 setFrame:CGRectMake(0,0, fullScreen.size.width,lowerstripheight+20)];
   
   topStrip1.backgroundColor = [UIColor whiteColor];
   [self.view addSubview:topStrip1];
  
   
   UIView *topBgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, fullScreen.size.width, backStripHeight)];
   topBgview.backgroundColor= [UIColor whiteColor];
   
   topBgview.userInteractionEnabled = YES;

   
   [self settingSubscriptionTitleoffsetCollapse];
   
   
}

-(void)swipeGesturesRecognising
{
   UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
       swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
      // [backgroundview addGestureRecognizer:swipeUp];

   UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
       swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
      // [backgroundview addGestureRecognizer:swipeDown];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{

if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
       NSLog(@"Swipe Up direction");
   // scrollview.contentOffset.y = scrollview.contentOffset.y+20;
   } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
       NSLog(@"Swipe Down direction");
   }
}
@end

