//
//  InAppPurchaseManager.m
//  InstaSplash
//
//  Created by Vijaya kumar reddy Doddavala on 9/27/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

// InAppPurchaseManager.m
#import "InAppPurchaseManager.h"
#import "WCAlertView.h"
#import "Config.h"
@interface InAppPurchaseManager()
{
    NSMutableDictionary *_products;
    id _controller;
}
@end

@implementation InAppPurchaseManager

static InAppPurchaseManager *SettingsSingleton = nil;

- (void)requestProUpgradeProductData
{
    NSSet *productIdentifiers = [NSSet setWithArray:kInAppPurchasePacks];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

-(NSString*)getPriceOfProduct:(NSString*)productId
{
    NSString *price = nil;
    if(nil == _products)
    {
        NSLog(@"getPriceOfProduct: Store is not loaded");
        return price;
    }
    
    SKProduct *prd = [_products objectForKey:productId];
    if(nil == prd)
    {
        NSLog(@"getPriceOfProduct: Couldn'g find product %@ in store",productId);
        return price;
    }
    
    price = [NSString stringWithFormat:@"%@",prd.localizedPrice];
    NSLog(@"Price of product id %@ is %@",productId,price);
    return price;
}

-(NSString*)getCurrencyCode:(NSString*)productId
{
    NSString *currencyCode = @"INR";
    if(nil == _products)
    {
        NSLog(@"getPriceOfProduct: Store is not loaded");
        return currencyCode;
    }
    
    SKProduct *prd = [_products objectForKey:productId];
    if(nil == prd)
    {
        NSLog(@"getPriceOfProduct: Couldn'g find product %@ in store",productId);
        return currencyCode;
    }
    currencyCode = [prd.priceLocale objectForKey:NSLocaleCurrencyCode];
    NSString * price = [NSString stringWithFormat:@"%@",prd.localizedPrice];
    NSLog(@"Price of product id %@ is %@ and currency code is %@",productId,price,currencyCode);
    return currencyCode;
}



-(NSString*)gettrailPeriod:(NSString*)productId
{
    NSString *TrailPeriod = nil;
    NSString *SubPeriod = nil;

    if(nil == _products)
    {
        NSLog(@"getPriceOfProduct: Store is not loaded");
        return TrailPeriod;
    }
    //_introductoryPrice =
    
    SKProduct *prd = [_products objectForKey:productId];
    
//    SKProductSubscriptionPeriod*periodoftime = [_products objectForKey:productId];
   
    NSLog(@"Period is****** %@",prd.introductoryPrice.subscriptionPeriod);
    
    SubPeriod = [NSString stringWithFormat:@"%lu",(unsigned long)prd.introductoryPrice.paymentMode];
    
    NSLog(@"Payment mode is****** %lu",(unsigned long)prd.introductoryPrice.paymentMode);
    
   // NSLog(@"Payment mode is****** %lu",prd.introductoryPrice.subscriptionPeriod.);
    
  
    if(nil == prd)
    {
        NSLog(@"getPriceOfProduct: Couldn'g find product %@ in store",productId);
        NSLog(@"Period is******2 %@",prd.introductoryPrice.subscriptionPeriod);
        NSLog(@"Period is******3 %lu",(unsigned long)prd.subscriptionPeriod.numberOfUnits);
        NSLog(@"Period is******4 %lu",(unsigned long)prd.subscriptionPeriod);
        //TrailPeriod = [NSString stringWithFormat:@"%@",prd.introductoryPrice.subscriptionPeriod];
        TrailPeriod = [NSString stringWithFormat:@"%@",prd.LocalizedTrial];
        NSLog(@"Trial period %@ is %@",productId,TrailPeriod);
        //TrailPeriod = [self localizedTrialDuraion];
        return TrailPeriod;
    }
    
    
   // TrailPeriod = [NSString stringWithFormat:@"%@",prd.subscriptionPeriod];
    NSLog(@"Trail of product id %@ is %@",productId,TrailPeriod);
 

   // TrailPeriod = [NSString stringWithFormat:@"%@",prd.introductoryPrice.subscriptionPeriod];
    TrailPeriod = [NSString stringWithFormat:@"%@",prd.introductoryPrice.subscriptionPeriod];
    NSLog(@"Trial period %@ is %@",productId,TrailPeriod);
    TrailPeriod = [self localizedTrialDuraion];
    
    NSLog(@"Trial *********** %@ is %@",productId,TrailPeriod);
    
    return TrailPeriod;
}
//-(NSString*_Nullable)localizedTrialDuraion:(NSString*_Nullable)productID{
-(NSString*_Nullable)localizedTrialDuraion{

if (@available(iOS 11.2, *)) {
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    [formatter setUnitsStyle:NSDateComponentsFormatterUnitsStyleFull]; //e.g 1 month
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDropAll;
    NSDateComponents * dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setCalendar:[NSCalendar currentCalendar]];
    
    switch (self.introductoryPrice.subscriptionPeriod.unit) {
        case SKProductPeriodUnitDay:{
            formatter.allowedUnits = NSCalendarUnitDay;
            [dateComponents setDay:self.introductoryPrice.subscriptionPeriod.numberOfUnits];
            break;
        }
        case SKProductPeriodUnitWeek:{
            formatter.allowedUnits = NSCalendarUnitWeekOfMonth;
            [dateComponents setWeekOfMonth:self.introductoryPrice.subscriptionPeriod.numberOfUnits];
            break;
        }
        case SKProductPeriodUnitMonth:{
            formatter.allowedUnits = NSCalendarUnitMonth;
            [dateComponents setMonth:self.introductoryPrice.subscriptionPeriod.numberOfUnits];
            break;
        }
        case SKProductPeriodUnitYear:{
            formatter.allowedUnits = NSCalendarUnitYear;
            [dateComponents setYear:self.introductoryPrice.subscriptionPeriod.numberOfUnits];
            break;
        }
        default:{
            return nil;
            break;
        }
            break;
    }
    [dateComponents setValue:self.introductoryPrice.subscriptionPeriod.numberOfUnits forComponent:formatter.allowedUnits];
    return [formatter stringFromDateComponents:dateComponents];
    
} else {
    // Fallback on earlier versions
}

return nil;
}
-(NSString*)getTitleOfProduct:(NSString*)productId
{
    NSString *title = nil;
    if(nil == _products)
    {
        NSLog(@"getPriceOfProduct: Store is not loaded");
        return title;
    }
    
    SKProduct *prd = [_products objectForKey:productId];
    if(nil == prd)
    {
        NSLog(@"getPriceOfProduct: Couldn'g find product %@ in store",productId);
        return title;
    }
    
    //title = [NSString stringWithFormat:@"$%@",prd.localizedTitle];
    NSLog(@"Title of product id %@ is %@",productId,prd.localizedTitle);

    return prd.localizedTitle;
}

-(NSString*)getDescriptionOfProduct:(NSString*)productId
{
    NSString *desc = nil;
    if(nil == _products)
    {
        NSLog(@"getDescriptionOfProduct: Store is not loaded");
        return desc;
    }
    
    SKProduct *prd = [_products objectForKey:productId];
    if(nil == prd)
    {
        NSLog(@"getDescriptionOfProduct: Couldn'g find product %@ in store",productId);
        return desc;
    }
    
    //title = [NSString stringWithFormat:@"$%@",prd.localizedTitle];
    NSLog(@"description of product id %@ is %@",productId,prd.localizedDescription);
    
    return prd.localizedDescription;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    /* validate the response */
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        //[request release];
        NSLog(@"Invalid product id: %@" , invalidProductId);
        return;
    }
    
    NSArray *products = response.products;
    if(nil != _products)
    {
        NSLog(@"Trying to Free products!!!");
    //    [_products release];
        _products = nil;
    }

    _products = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    for(int index = 0; index < [response.products count]; index++)
    {
        SKProduct *prd = [response.products objectAtIndex:index];
        [_products setObject:prd forKey:prd.productIdentifier];
        NSLog(@"Product %d: %@",index,prd.productIdentifier);

    }
    

    
    NSLog(@"Freeing product request");
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    //[request release];
    
    NSDictionary *prds = [NSDictionary dictionaryWithObject:products forKey:key_inappproducts];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:prds];
}

//
// call this method once on startup
//
- (void)loadStore
{
    if(nil != _products)
    {
        NSLog(@"Store is already loaded");
        return;
    }
    
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _products = nil;
        return self;
    }
    
    return self;
}

+(InAppPurchaseManager*)Instance
{
    //@autoreleasepool {
        @synchronized([InAppPurchaseManager class])
        {
            if (SettingsSingleton == nil)
            {
                SettingsSingleton = [[self alloc] init]; // assignment not done here
            }
        }
        
        return SettingsSingleton;
    }
    
//}


+(id)allocWithZone:(NSZone *)zone
{
    @synchronized([InAppPurchaseManager class])
    {
        if (SettingsSingleton == nil)
        {
            SettingsSingleton = [super allocWithZone:zone];
            return SettingsSingleton;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


-(void)dealloc
{
   // [super dealloc];
}

//-(id)copyWithZone:(NSZone *)zone
//{
//    return self;
//}
//
//
//-(id)retain
//{
//    return self;
//}
//
//
//-(unsigned)retainCount
//{
//    return UINT_MAX;  //denotes an object that cannot be release
//}
//
//
//-(oneway void)release
//{
//    //do nothing
//}
//
//-(id)autorelease
//{
//    return self;
//}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

-(void)puchaseProductWithId:(NSString*)prdId
{
    if(_products == nil)
    {
        [self loadStore];
        NSLog(@"Store is not loaded");
        return;
    }
    
    NSLog(@"Products %@",_products);
    SKProduct *prd = [_products objectForKey:prdId];
    if(nil == prd)
    {
        NSLog(@"Product is not found");
        return;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:prd];
    /*SKPayment *payment = nil;
    if(nil != proUpgradeProduct)
    {
        payment = [SKPayment paymentWithProduct:proUpgradeProduct];
    }
    else
    {
        //[self loadStore];
        NSLog(@"Product is not found");
        return;
    }*/
    
    // = [SKPayment paymentWithProductIdentifier:prdId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
#if FLURRY_ANALYTICS_SUPPORT
    [FlurryAnalytics logEvent:@"RemoveAds Request"];
#endif
}

-(void)restoreProUpgrade
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
#if FLURRY_ANALYTICS_SUPPORT
    [FlurryAnalytics logEvent:@"Restore RemoveAds Request"];
#endif
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
#if 0
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
#else
    
#endif
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    //if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // enable the pro features
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
        _transactionCount =1;
      
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productId];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key_boughtAnyProduct];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"provideContent: Product id %@ is successfully purchased",productId);
        
    }
    return;
}

-(BOOL)anyPurchasesMadeSoFar
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key_boughtAnyProduct];
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    
    _transactionCount =2;
    //Close WCAlertView Here//
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"removeSubscriptionPage" object: Nil];

        
        SKProduct *prd = [_products objectForKey:transaction.payment.productIdentifier];
        if(nil != prd)
        {
            NSString *successMsg = [NSString stringWithFormat:@"You have successfully Purchased/Restored %@",prd.localizedTitle];
            if(HideTransaction)
            {
            [WCAlertView showAlertWithTitle:@"Success"
                                    message:successMsg
                         customizationBlock:nil
                            completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView){
                if (buttonIndex == 0) {
                    
                    HideTransaction = NO;
                    return ;
                }
                else
                {
                    //[self openProApp];
                }
                
            }
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
            }
            
        }
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}



//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
   // productPurchased = YES; //newlyadded
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
#if FLURRY_ANALYTICS_SUPPORT
    [FlurryAnalytics logEvent:@"RemoveAds Purchased"];
#endif
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//newly added
    //Close WCAlertView Here//
#if FLURRY_ANALYTICS_SUPPORT
    [FlurryAnalytics logEvent:@"Restore RemoveAds Completed"];
#endif
#if 0
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Restore Success" message:@"Successfully restored your purchase!!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
#endif
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self]; //newly added
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Restore Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//    [alert show];
 //   [alert release];
    [self ShowAlert:@"Restore Failed" message:[error localizedDescription]];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction restored");
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
    //[Utility removeActivityIndicatorFrom:_controller];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
        [self ShowAlert:@"Error" message:transaction.error.description];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeIndicator" object:nil];
   // [self ShowAlert:@"Error" message:@"SomeThing went wrong,Try again..."];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
#if 0
    for (SKPaymentTransaction *transaction in transactions) {
        [iAPVerification verifyPurchase:transaction isSandbox:YES delegate:self];
        NSLog(@"Requesting for iAPVerification");
    }
#else
    for (SKPaymentTransaction *transaction in transactions)
    {
        
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
               
                [[NSNotificationCenter defaultCenter] postNotificationName: @"removeSubscriptionPage" object: Nil];

                [self completeTransaction:transaction];
                
                    
                break;
            case SKPaymentTransactionStateFailed:
                
                [self failedTransaction:transaction];
               
                break;
            case SKPaymentTransactionStateRestored:
               
                [self restoreTransaction:transaction];
              
                break;
            default:
                break;
        }
    }
#endif
}

- (void)purchaseVerified:(NSDictionary *)dictionary paymentTransaction:(SKPaymentTransaction *)paymentTransaction {
    NSLog(@"purchaseVerified: %@", dictionary);
    
    //NSString *productId = [dictionary objectForKey:@"product_id"];
    
    switch (paymentTransaction.transactionState)
    {
        case SKPaymentTransactionStatePurchased:
            [self completeTransaction:paymentTransaction];
            break;
        case SKPaymentTransactionStateFailed:
            [self failedTransaction:paymentTransaction];
            break;
        case SKPaymentTransactionStateRestored:
            [self restoreTransaction:paymentTransaction];
            break;
        default:
            break;
    }
    
    //[[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
    [SKPaymentQueue.defaultQueue finishTransaction:paymentTransaction];
}
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

//getting here//
-(long)getTrailPeriodofProductForYear:(NSString*)productId
{

    if(nil == _products)
    {
        NSLog(@"getPriceOfProduct: Store is not loaded");
       // return *TrailPeriod;
    }
   
    SKProduct *prd = [_products objectForKey:productId];
  

    NSLog(@"AllProducts---%@",_products);
    return [self getNumberOfDaysFreeTrailforProductYear:prd];
}
//getting here for month//
-(long)getTrailPeriodofProductForMonth:(NSString *)productId
{
    if(nil == _products)
    {
        NSLog(@"getPriceOfProduct: Store is not loaded");
       // return *TrailPeriod;
    }
    
    
    SKProduct *prd = [_products objectForKey:productId];
 
   
    return [self getNumberOfDaysFreeTrailforProductMonth:prd];
}
//getting here for Week//
-(long)getTrailPeriodofProductForWeek:(NSString *)productId
{
    if(nil == _products)
    {
        NSLog(@"getPriceOfProduct: Store is not loaded");
       // return *TrailPeriod;
    }
    
    
    SKProduct *prd = [_products objectForKey:productId];
 
   
    return [self getNumberOfDaysFreeTrailforProductWeek:prd];
}

-(long)getNumberOfDaysFreeTrailforProductYear:(SKProduct*)prd
{
    long numberOfDays = 0;
    long numberOfPeroids = 0;
    if(nil == prd){
        return numberOfDays;
    }
    if(nil == prd.introductoryPrice){
        return numberOfDays;
    }
    numberOfPeroids = [prd.introductoryPrice numberOfPeriods];
    numberOfDays = [self numberOfDaysForUnitForYearSub:[[prd.introductoryPrice subscriptionPeriod]unit]];
    long numOfUnits = [[prd.introductoryPrice subscriptionPeriod]numberOfUnits];
    numberOfDays = numberOfDays * numOfUnits;
    NSLog(@"MMM - year getNumberOfDaysFreeTrailforProduct - number of peroids - %ld, number of units - %ld",numberOfPeroids,numOfUnits);
    return numberOfDays;
}
-(long)getNumberOfDaysFreeTrailforProductMonth:(SKProduct*)prd
{
    long numberOfDays = 0;
    long numberOfPeroids = 0;
    if(nil == prd){
        return numberOfDays;
    }
    if(nil == prd.introductoryPrice){
        return numberOfDays;
    }
    numberOfPeroids = [prd.introductoryPrice numberOfPeriods];
    numberOfDays = [self numberOfDaysForUnitForMonthSub:[[prd.introductoryPrice subscriptionPeriod]unit]];
    long numOfUnits = [[prd.introductoryPrice subscriptionPeriod]numberOfUnits];
    numberOfDays = numberOfDays * numOfUnits;
    NSLog(@"MMM - Month getNumberOfDaysFreeTrailforProduct - number of peroids - %ld, number of units - %ld",numberOfPeroids,numOfUnits);
    return numberOfDays;
}
-(long)getNumberOfDaysFreeTrailforProductWeek:(SKProduct*)prd
{
    long numberOfDays = 0;
    long numberOfPeroids = 0;
    if(nil == prd){
        return numberOfDays;
    }
    if(nil == prd.introductoryPrice){
        return numberOfDays;
    }
    numberOfPeroids = [prd.introductoryPrice numberOfPeriods];
    numberOfDays = [self numberOfDaysForUnitForWeekSub:[[prd.introductoryPrice subscriptionPeriod]unit]];
    long numOfUnits = [[prd.introductoryPrice subscriptionPeriod]numberOfUnits];
    numberOfDays = numberOfDays * numOfUnits;
    NSLog(@"MMM - Week getNumberOfDaysFreeTrailforProduct - number of peroids - %ld, number of units - %ld",numberOfPeroids,numOfUnits);
    return numberOfDays;
}
-(int)numberOfDaysForUnitForWeekSub:(SKProductPeriodUnit)unit API_AVAILABLE(ios(11.2)){
    if (@available(iOS 11.2, *)) {
        if(SKProductPeriodUnitDay == unit)
        {
         
            NSLog(@"Month Day section----");
            return 1;
        }
        else if(SKProductPeriodUnitWeek == unit)
        {
            NSLog(@"Month week section----");
           
          
            return 7;

        }
        else if(SKProductPeriodUnitYear == unit)
        {
            return 365;
            NSLog(@"Month year section----");
        }
        else if(SKProductPeriodUnitMonth == unit)
        {
            return 30;
            NSLog(@"Month  section----for month");
        }
    } else {
        // Fallback on earlier versions
    }
    return 0;
}
-(int)numberOfDaysForUnitForMonthSub:(SKProductPeriodUnit)unit API_AVAILABLE(ios(11.2)){
    if (@available(iOS 11.2, *)) {
        if(SKProductPeriodUnitDay == unit)
        {
         
            NSLog(@"Month Day section----");
            return 1;
        }
        else if(SKProductPeriodUnitWeek == unit)
        {
            NSLog(@"Month week section----");
           
          
            return 7;

        }
        else if(SKProductPeriodUnitYear == unit)
        {
            return 365;
            NSLog(@"Month year section----");
        }
        else if(SKProductPeriodUnitMonth == unit)
        {
            return 30;
            NSLog(@"Month  section----for month");
        }
    } else {
        // Fallback on earlier versions
    }
    return 0;
}
-(int)numberOfDaysForUnitForYearSub:(SKProductPeriodUnit)unit API_AVAILABLE(ios(11.2)){
    if (@available(iOS 11.2, *)) {
        if(SKProductPeriodUnitDay == unit)
        {
            NSLog(@"Year day section----");
    
        
            return 1;
        }
        else if(SKProductPeriodUnitWeek == unit)
        {
            NSLog(@"year week section----");
 
         
            return 7;

        }
        else if(SKProductPeriodUnitYear == unit)
        {
            return 365;
            NSLog(@"year  section----for year");
        }
        else if(SKProductPeriodUnitMonth == unit)
        {
            return 30;
            NSLog(@"Month  section---- for year");
        }
    } else {
        // Fallback on earlier versions
    }
    return 0;
}

-(void)ShowAlert:(NSString*)title message:(NSString*)msg
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
