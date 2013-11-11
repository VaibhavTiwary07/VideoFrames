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
@interface InAppPurchaseManager()
{
    NSMutableDictionary *_products;
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
        [request release];
        NSLog(@"Invalid product id: %@" , invalidProductId);
        return;
    }
    
    NSArray *products = response.products;
    if(nil != _products)
    {
        NSLog(@"Trying to Free products!!!");
        [_products release];
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
    [request release];
    
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
    @synchronized([InAppPurchaseManager class])
	{
        if (SettingsSingleton == nil)
		{
            [[self alloc] init]; // assignment not done here
        }
    }
	
    return SettingsSingleton;
}


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
    [super dealloc];
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}


-(id)retain
{
    return self;
}


-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be release
}


-(oneway void)release
{
    //do nothing
}

-(id)autorelease
{
    return self;
}

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
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
        
        
        SKProduct *prd = [_products objectForKey:transaction.payment.productIdentifier];
        if(nil != prd)
        {
            NSString *successMsg = [NSString stringWithFormat:@"You have successfully Purchased/Restored %@",prd.localizedTitle];
            [WCAlertView showAlertWithTitle:@"Success"
                                    message:successMsg
                         customizationBlock:nil
                            completionBlock:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
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
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
#if FLURRY_ANALYTICS_SUPPORT
    [FlurryAnalytics logEvent:@"RemoveAds Purchased"];
#endif
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Restore Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
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
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
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
	
	[[SKPaymentQueue defaultQueue] finishTransaction:paymentTransaction];
}

@end
