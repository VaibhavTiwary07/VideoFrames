//
//  SRSubscriptionModel.m
//
//  Created by Saheb Roy on 24/09/15.
//  Copyright (c) 2015 OrderOfTheLight. All rights reserved.
//


#define userDef(parameter) [[NSUserDefaults standardUserDefaults]objectForKey:parameter]


#import "SRSubscriptionModel.h"
#import <StoreKit/StoreKit.h>
#import "Config.h"


NSString *const kSandboxServer = @"https://sandbox.itunes.apple.com/verifyReceipt";
NSString *const kStoreKitSecret = @"5fc96744668a430fbe7d7d4efeb010c6";
NSString *const kItunesLiveServer = @"https://buy.itunes.apple.com/verifyReceipt";
NSString *const kSubscriptionActive = @"com.SahebRoy92.SM.existing_subscription_isactive";
NSString *const kAppReceipt = @"com.SahebRoy92.SM.existing_app_reciept";
NSString *const kSubscriptionProduct = @"com.SahebRoy92.SM.existing_subscription_product";



 NSString *const kSRProductPurchasedNotification = @"com.SahebRoy92.SRSubscriptionModel.PurchaseNotification";
 NSString *const kSRProductUpdatedNotification = @"com.SahebRoy92.SRSubscriptionModel.UpdatedNotification";
 NSString *const kSRProductRestoredNotification = @"com.SahebRoy92.SRSubscriptionModel.RestoredNotification";
 NSString *const kSRProductFailedNotification = @"com.SahebRoy92.SRSubscriptionModel.FailedNotification";
 NSString *const kSRProductLoadedNotification = @"com.SahebRoy92.SRSubscriptionModel.LoadedNotification";
 NSString *const kSRSubscriptionResultNotification = @"com.SahebRoy92.SRSubscriptionModel.ResultNotification";

//com.outthinking.videocollage.effects2
//-----------add here your Id's-------------------//

@interface SRSubscriptionModel()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic,strong) NSString *latestReceipt;
// Declare a property for the background task identifier
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation SRSubscriptionModel{
    NSMutableDictionary *payLoad;
    id _controller;
    NSString *firstsubscriptionPrice,*firstsubscriptionPriceYearly;
    long TrailPeriodDays;
    long TrailPeriodDaysYearly;
    BOOL restoreExpired;
}

+(instancetype)shareKit{
    static SRSubscriptionModel *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SRSubscriptionModel alloc]init];
        manager.currentProduct = [[NSMutableDictionary alloc]init];
        manager.subscriptionPlans = [NSSet setWithObjects:kInAppPurchaseSubScriptionPack,kInAppPurchaseSubScriptionPackYearly,kInAppPurchaseSubScriptionPackWeekly, nil];
        [[SKPaymentQueue defaultQueue]addTransactionObserver:manager];
        [manager startProductRequest];
        NSLog(@"Checking ExpiryHere manager  SRSubcription view-------");
        [manager CheckingExpiryHere];
        NSLog(@"Produts requested-------");
    });
    return manager;
}
/**
- It will send 'YES' if all features are subscribed otherwise 'NO'
 – */
-(BOOL)IsAppSubscribed
{
    NSUserDefaults *user_Defaults = [NSUserDefaults standardUserDefaults];
  //  NSLog(@"SubscriptionExpired %ld",(long)[user_Defaults integerForKey:@"SubscriptionExpired"]);
    if([user_Defaults integerForKey:@"SubscriptionExpired"] == 0)
    {
        //NSLog(@"Pro Version is not purchased");
        return NO;
    }
    else
    {
       // NSLog(@"Pro Version is purchased");
        return YES;
    }
}


-(BOOL)IsSessionExpired
{
    NSUserDefaults *user_Defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"SessionExpired %ld",(long)[user_Defaults integerForKey:@"SubscriptionSessionExpired"]);
    if([user_Defaults integerForKey:@"SubscriptionSessionExpired"] == 0)
    {
        NSLog(@"Session is not expired");
        return NO;
    }
    else
    {
        NSLog(@"Session is expired");
        return YES;
    }

}
#pragma mark - Restore

-(void)restoreSubscriptions{
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    //Fail restoring!
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseSubscriptionView" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HideActivityIndicator" object:nil];
    [self ShowAlert:@"Error!" message:error.localizedDescription];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    //restored!
    NSLog(@"Subscriptions restored");
    [self CheckingExpiryHere];
}

#pragma mark - Transaction Observers

-(void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads{
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchasing:
                break;
                
            case SKPaymentTransactionStateDeferred:{
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:{
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"PURCHASED!");
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored: {
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                NSLog(@"RESTORED$$$");
//                [self postRestoredNotification:transaction];
                break;
            }
        }
    }
    SKPaymentTransaction *lastTransaction = transactions.lastObject;
    switch(lastTransaction.transactionState)
    {
        case SKPaymentTransactionStatePurchasing: {
            break;
        }
        case SKPaymentTransactionStatePurchased:{
            NSLog(@"last transaction PURCHASED! transactionDate == %@",lastTransaction.transactionDate);
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchingLastPurchases" object:self];
            NSLog(@"last transaction description %@",lastTransaction.description);
            [self saveProductPurchaseWithProduct:lastTransaction];
            [self CheckingExpiryHere];
            [self SubscriptionPurchasedSuccessfully];
            [self LogPurchaseEvent:lastTransaction.payment.productIdentifier];
            break;
        }
        case SKPaymentTransactionStateFailed: {
            break;
        }
        case SKPaymentTransactionStateRestored: {
            NSLog(@"last transaction RESTORED$$$ transactionDate == %@",lastTransaction.transactionDate);
            [self postRestoredNotification:lastTransaction];
            break;
        }
        case SKPaymentTransactionStateDeferred: {
            break;
        }
    }
}

// To log event on purchase success
-(void)LogPurchaseEvent:(NSString *)productID
{
    NSString *Price = [[InAppPurchaseManager Instance]getPriceOfProduct:productID];
    NSString *currencyCode = [[InAppPurchaseManager Instance]getCurrencyCode:productID];
    NSString* eventName = @"";
    NSString *estimatedYearlyTrialValue = @"1";
    NSString *planType = @"";
    NSLog(@"price - %@ , cureency code - %@",Price,currencyCode);
    // These values below won’t be used in ROAS recipe.
    // But log for purposes of debugging and future reference.
    if([productID isEqual:kInAppPurchaseSubScriptionPackYearly])
    {
        NSLog(@"Purchased yearly subscription");
        // To check whether subscription in the trail period or NO
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];

        if (receiptData) {
            NSError *error;
            NSDictionary *receiptDict = [NSJSONSerialization JSONObjectWithData:receiptData options:0 error:&error];
            
            if (!error && receiptDict) {
                // For auto-renewable subscriptions, check the latest_receipt_info
                NSArray *latestReceipts = receiptDict[@"latest_receipt_info"];
                if (latestReceipts.count > 0) {
                    NSDictionary *firstTransaction = latestReceipts.firstObject;
                    BOOL isTrialPeriod = [firstTransaction[@"is_trial_period"] boolValue];
                    BOOL isInIntroOfferPeriod = [firstTransaction[@"is_in_intro_offer_period"] boolValue];
                    NSLog(@"is_trial_period: %@ , is_in_intro_offer_period %@", isTrialPeriod ? @"YES" : @"NO",isInIntroOfferPeriod?@"YES":@"NO");
                    if(isTrialPeriod && isInIntroOfferPeriod)
                    {
                        //Free trail
                        eventName = @"yearly_trial_activated";
                        Price = @"1"; // Hardcoded value
                    }
                    else
                    {
                        //Actual
                        eventName = @"purchase_yearly_subscription";
                    }
                    planType = @"Yearly";
                }
            }
        }
    }
    else if([productID isEqual:kInAppPurchaseSubScriptionPackWeekly])
    {
        eventName = @"purchase_weekly_subscription";
        planType = @"Weekly";
    }
    else if([productID isEqual:kInAppPurchaseSubScriptionPack])
    {
        eventName = @"purchase_monthly_subscription";
        planType = @"Monthly";
    }
    // Example: Price = @"₹ 269.00" (note: the space may be a non-breaking space \u00A0)

    // 1. Keep only digits and decimal point
    NSString *cleanPrice = [[Price componentsSeparatedByCharactersInSet:
                             [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.,"] invertedSet]]
                            componentsJoinedByString:@""];

//    // 2. Replace comma with dot if needed (e.g., "269,50" → "269.50")
//    cleanPrice = [cleanPrice stringByReplacingOccurrencesOfString:@"," withString:@"."];

    // 3. Convert to NSNumber
    NSNumber *priceValue = @([cleanPrice doubleValue]);

    NSLog(@"priceValue: %@", priceValue);
    NSLog(@"after fectching values price - %@ , currency code - %@ , price value %@",Price,currencyCode, priceValue);
//    //To log event
//    [FIRAnalytics logEventWithName:eventName
//                        parameters:@{
//        @"AnalyticsParameterValue": Price,
//        @"AnalyticsParameterCurrency": currencyCode,
//
//    }];
    
    [FIRAnalytics logEventWithName:eventName
                        parameters:@{
                            kFIRParameterValue: priceValue,
                            kFIRParameterCurrency: currencyCode,
                            @"plan_type": planType
                        }];
}



-(void)ValidatePurchaseReciept
{
    [self receiptValidation:^(BOOL subscriptionStatus,NSString *subscriptionExpired, NSError *error) {
            NSLog(@"Got callback response expired");
            dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseSubscriptionView" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HideActivityIndicator" object:nil];
            if(error == nil)
            {
                if(subscriptionExpired != nil)
                {
                    if([subscriptionExpired  isEqual: @"Expired"])
                    {
                        NSLog(@"*************** Purchase Failed ***************");
                    }
                    else if([subscriptionExpired  isEqual: @"Active"])
                    {
                        NSLog(@"************** purchase Successful **************");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PurchaseSuccessful" object:nil];
                    }
                }
            }
            else
            {
                [self ShowAlert:@"Error!" message:error.localizedDescription];
            }
            });
        }];
}


-(void)ValidateReciept
{
    [self receiptValidation:^(BOOL subscriptionStatus,NSString *subscriptionExpired, NSError *error) {
        
            NSLog(@"Got callback response expired");
            dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseSubscriptionView" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HideActivityIndicator" object:nil];
            if(error == nil)
            {
                if(subscriptionExpired != nil)
                {
                    if([subscriptionExpired  isEqual: @"Expired"])
                    {
                        NSLog(@"try to restore transactions restore Expired %@",restoreExpired?@"YES":@"NO");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreFailed" object:nil];
                    }
                    else if([subscriptionExpired  isEqual: @"Active"])
                    {
                        NSLog(@"*******************************RestoreSuccessful************************");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreSuccessful" object:nil];
                    }
                }
            }
            else
            {
                [self ShowAlert:@"Error!" message:error.localizedDescription];
            }
            });
        }];
}

-(void)Check_Validation
{
    [self receiptValidation:^(BOOL subscriptionStatus,NSString *subscriptionExpired, NSError *error) {
            NSLog(@"Got callback response expired");
            dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseSubscriptionView" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HideActivityIndicator" object:nil];
            if(error == nil)
            {
                if(subscriptionExpired != nil)
                {
                    if([subscriptionExpired  isEqual: @"Expired"])
                    {
                        [self ShowAlert:@"Not purchased!" message:@"Product Not purchased"];
                        NSLog(@"try to restore transactions restore Expired");
                    }
                    else if([subscriptionExpired  isEqual: @"Active"])
                    {
                        NSLog(@"*******************************RestoreSuccessful************************");
                        [self LockAllFeatures];
                    }
                }
            }
            else
            {
                [self ShowAlert:@"Error!" message:error.localizedDescription];
            }
            });
        }];
}





-(void) receiptValidation:(void (^)(BOOL activeSubscriptionFound, NSString *subscriptionExpired, NSError *error)) validationCompletion
{
    [self startBackgroundTaskWithName:@"ReceiptValidationTask"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // @autoreleasepool {
            NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
            NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
            NSError *error;
            if (!receipt) {
                error = [NSError errorWithDomain:@"Blur Background" code:1111111 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"AppStore receipt not found", NSLocalizedDescriptionKey, nil]];
                validationCompletion(NO,nil, error);
                return;
            }
            NSDictionary *requestContents = @{
                @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                @"password":secreteSharedKeyForSubcription
            };
            
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
            
            if (!requestData) {
                /* ... Handle error ... */
                NSLog(@"Error occurred while request Data");
                validationCompletion(NO,nil, error);
                return;
            }
            
            // Create a POST request with the receipt data.
#if DEBUG
            NSURL *storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
#else
            NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
#endif
            NSMutableURLRequest *storeRequest = [[NSMutableURLRequest alloc] initWithURL:storeURL ];
            [storeRequest setHTTPMethod:@"POST"];
            [storeRequest setHTTPBody:requestData];
            NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            __auto_type task = [session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error) {
                    NSLog(@"We got the error while validating the receipt: %s", [[error description] UTF8String]);
                    validationCompletion(NO,nil, error);
                    return;
                }
                NSError *localError = nil;
                //Parsing the response as JSON.
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&localError];
                
                //Getting the latest_receipt_info field value.
                NSArray *receiptInfo = jsonResponse[@"latest_receipt_info"];
                if(!receiptInfo || [receiptInfo count] == 0) {
                    NSLog(@"%s", "Looks like this customer has no purchases!");
                    validationCompletion(NO,nil, error);
                    return;
                }
                NSArray *pending_renewal_info = jsonResponse[@"pending_renewal_info"];
                NSDictionary *firstobject =pending_renewal_info.firstObject;
                NSString *expirationIntent = firstobject[@"expiration_intent"];
                NSLog(@"_Data_ expirationIntent---%@ ",expirationIntent);
                NSLog(@"is_in_billing_retry_period %@",firstobject[@"is_in_billing_retry_period"]);
                if(firstobject[@"is_in_billing_retry_period"] != nil)
                {
                    NSString *isinbillingTrailPeriod = firstobject[@"is_in_billing_retry_period"];
                    NSLog(@"_Data_ isinbillingTrailPeriod---%@ ",isinbillingTrailPeriod);
                    if([isinbillingTrailPeriod  isEqual: @"1"])
                    {
                        restoreExpired = NO;
                    }
                    else
                    {
                        restoreExpired = YES;
                    }
                }
                else
                {
                    restoreExpired = NO;
                }
                // End task when complete
                [self endBackgroundTask];
                if(restoreExpired)
                    validationCompletion(YES,@"Expired", nil);
                else
                    validationCompletion(YES,@"Active", nil);
                return;
            }];
            
            NSLog(@"validation Task completed");
            [task resume];
       // }
    });
}

-(void)beforePurchasingProduct
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // saving an Integer
   [prefs setInteger:0 forKey:@"Productpurchased"];
}

-(void)afterPurchasingProduct
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   [prefs setInteger:1 forKey:@"Productpurchased"];
}

/************ CALL THIS TO FETCH ALL OBJECTS IN THE IN APP ****************/

-(void)startProductRequest{
    SKProductsRequest *productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:_subscriptionPlans];
    productRequest.delegate = self;
    [productRequest start];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"Products Response is*****%@",response.products);
    _availableProducts = response.products;
    [[NSNotificationCenter defaultCenter]postNotificationName:kSRProductLoadedNotification object:nil];
    NSLog(@"Products Response2 is######%@",response.products);
    [self endBackgroundTask];
}


-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
//    dispatch_async(dispatch_get_main_queue(), ^{
//    [self ShowAlert:@"Product Request Error!" message:error.localizedDescription];
//    });
    [self endBackgroundTask];
}

-(void)ShowAlert:(NSString*)title message:(NSString*)msg
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
  
    [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(void)requestDidFinish:(SKRequest *)request{
    NSLog(@"REQUEST DID FINISH");
    [self endBackgroundTask];
}

/************ BUY SUBSCRIPTION ****************/

-(void)makePurchase:(NSString *)productIdentifier{
    
    if(_availableProducts.count == 0){
        NSLog(@"Products are ----0");
        [self startProductRequest];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseIfNotLoaded" object:nil];
        NSLog(@"Products are not available---");
//        NSTimer *playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
//                              target: self
//                              selector:@selector(requestedProductsAgain)
//                              userInfo: nil repeats:NO];

//        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeIndicator" object:nil];
//        [self ShowAlert:@"Store" message:@"Store is not loaded"];
        return;
    }
    [_availableProducts enumerateObjectsUsingBlock:^(SKProduct *thisProduct, NSUInteger idx, BOOL *stop) {
        if ([thisProduct.productIdentifier isEqualToString:productIdentifier]) {
            *stop = YES;
            SKPayment *payment = [SKPayment paymentWithProduct:thisProduct];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
//            if (@available(iOS 11.2, *)) {
//                [[InAppPurchaseManager Instance]HasPurchaseClicked:YES];
//            } else {
//                // Fallback on earlier versions
//                [[InAppPurchaseManager Instance]HasPurchaseClicked:YES];
//            }
        }
    }];
}


-(void)requestedProductsAgain
{
    [self startProductRequest];
//    NSTimer *playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
//                          target: self
//                          selector:@selector(startProductRequest)
//                          userInfo: nil repeats:NO];
    NSLog(@"Products requested");
}
/************ SAVE PRODUCT INFO WHEN SUBSCRIPTION IS OVER AND AGAIN USER BOUGHT ****************/

-(void)saveProductPurchaseWithProduct:(SKPaymentTransaction *)transaction{
        [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
        [self postNotificationPurchased:transaction.payment.productIdentifier];
}

-(void)postNotificationPurchased:(NSString *)identifier{
    NSDictionary *obj = @{@"product":identifier};
    self.currentIsActive = YES;
    self.currentProduct = [obj mutableCopy];
    [[NSNotificationCenter defaultCenter]postNotificationName:kSRProductPurchasedNotification object:obj];
}
-(void)postRestoredNotification:(SKPaymentTransaction *)transaction{
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    [[NSNotificationCenter defaultCenter]postNotificationName:kSRProductRestoredNotification object:nil];
}



// Reciept Valiadation //
-(void)CheckingExpiryHere
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // @autoreleasepool {
            NSLog(@"_Data_ ---------------------- Checking Expiry Here----------------------");
            //    bool writeDatatoTextfile = true;
            //Loading the appstore receipt from apps main bundle.
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSURL *receiptURL = [mainBundle appStoreReceiptURL];
            NSError *receiptError;
            BOOL isPresent = [receiptURL checkResourceIsReachableAndReturnError:&receiptError];
            
            NSLog(@"_Data_ receipt is Present %@",isPresent?@"YES":@"NO");
       
            if (!isPresent) {
                //[self startBackgroundTask];
                [self startBackgroundTaskWithName:@"CheckingExpiryTask"];
                //Refresh the receipt if its not found.
                SKReceiptRefreshRequest *request = [[SKReceiptRefreshRequest alloc] init];
                request.delegate = self;
                [request start];
                return;
                [self endBackgroundTask];
            }
            
            NSLog(@"_Data_---------------------- Checking Expiry Here isPresent ----------------------");
            //Loading the receipt data from the URL
            NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
            //NSLog(@"_Data_ receiptData---%@",receiptData);
            //Base 64 encoding the receipt data
            NSString *encodedReceiptData = [receiptData base64EncodedStringWithOptions:0];
            // Create the POST request with payload to be sent to AppStore.
            NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\", \"password\" : \"%@\"}",
                                 encodedReceiptData, secreteSharedKeyForSubcription];
            
            NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
            // NSLog(@"_Data_ payloadData---%@",payloadData);
            //Sending the data to appropreat store URL based on the kind of build.
            
            NSURL *storeURL;
#ifdef DEBUG
            storeURL= [[NSURL alloc] initWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
            NSLog(@"_Data_ Debugging mode---");
            //[self showingAlertView];
#else
            
            BOOL sandbox = [[receiptURL lastPathComponent] isEqualToString:@"sandboxReceipt"];
            
            storeURL = [[NSURL alloc] initWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
            if (sandbox)
            {
                storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
            }
#endif
            //Sending the POST request.
            NSMutableURLRequest *storeRequest = [[NSMutableURLRequest alloc] initWithURL:storeURL ];
            [storeRequest setHTTPMethod:@"POST"];
            [storeRequest setHTTPBody:payloadData];
            NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
            __auto_type task = [session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error) {
                    NSLog(@"We got the error while validating the receipt checking expiry time : %s", [[error description] UTF8String]);
                    return;
                }
                NSError *localError = nil;
                //Parsing the response as JSON.
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&localError];
                
                //        if(writeDatatoTextfile){
                //            //get the documents directory:
                //            NSArray *paths = NSSearchPathForDirectoriesInDomains
                //                (NSDocumentDirectory, NSUserDomainMask, YES);
                //            NSString *documentsDirectory = [paths objectAtIndex:0];
                //            //make a file name to write the data to using the documents directory:
                //            NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt",documentsDirectory];
                //            NSString * myString = [[NSString alloc] initWithData:data   encoding:NSUTF8StringEncoding];
                //            //save content to the documents directory
                //            [myString writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
                //        }
                
                //Getting the latest_receipt_info field value.
                NSArray *receiptInfo = jsonResponse[@"latest_receipt_info"];
                if(!receiptInfo || [receiptInfo count] == 0) {
                    NSLog(@"%s", "Looks like this customer has no purchases!");
                    return;
                }
                
                NSNumber *purchasedCount = [NSNumber numberWithInt:1];
                
                [Purchased_Number_defaults setObject: purchasedCount forKey:@"PurchasedCountIs"];
                
                
                NSDictionary *firstReceipt = receiptInfo.firstObject;
                //The purchased product id
                NSString *productID = firstReceipt[@"product_id"];
                NSLog(@"Product ID---%@",productID);
                //Boolean indicating whether the subscription is in trial period or not.
                NSString *isTrialPeriod = firstReceipt[@"is_trial_period"];
                NSLog(@"Trail Period---%@",isTrialPeriod);
                
                //The expires_date for the purchase.
                NSString *firstExpiresDate = firstReceipt[@"expires_date"];
                NSLog(@"_Data_ first Receipt Expiry Date---%@",firstExpiresDate);
                
                NSString * firstTransactionid = firstReceipt[@"transaction_id"];
                NSLog(@"_Data_ first Receipt transactionid ---%@",firstTransactionid);
                
                
                //storing Expire Date Here //
                NSUserDefaults *user_Defaults = [NSUserDefaults standardUserDefaults];
                [user_Defaults setObject:firstExpiresDate forKey:@"SubscriptionStatusHere"];
                [user_Defaults setObject:firstTransactionid forKey:@"transactionid"];
                NSLog(@"Expiry Date After saving---%@ saved date ---  %@",firstExpiresDate,[[NSUserDefaults standardUserDefaults]stringForKey:@"SubscriptionStatusHere"]);
                //This means customers subscription has expired and we want to know why it expired
                
                NSArray *pending_renewal_info = jsonResponse[@"pending_renewal_info"];
                NSDictionary *firstobject =pending_renewal_info.firstObject;
                NSString *expirationIntent = firstobject[@"expiration_intent"];
                NSLog(@"_Data_ expirationIntent---%@ ",expirationIntent);
                NSLog(@"is_in_billing_retry_period %@",firstobject[@"is_in_billing_retry_period"]);
                if(firstobject[@"is_in_billing_retry_period"] != nil)
                {
                    NSString *isinbillingTrailPeriod = firstobject[@"is_in_billing_retry_period"];
                    NSLog(@"_Data_ isinbillingTrailPeriod---%@ ",isinbillingTrailPeriod);
                    if([isinbillingTrailPeriod  isEqual: @"1"])
                    {
                        restoreExpired = NO;
                        [self UnlockAllFeatures];
                    }
                    else
                    {
                        restoreExpired = YES;
                        [self LockAllFeatures];
                    }
                }
                else
                {
                    restoreExpired = NO;
                    [self UnlockAllFeatures];
                }
                // End task when complete
                [self endBackgroundTask];
                return;
            }];
            NSLog(@"checking expiry Task completed");
        
            [task resume];
    //    }
    });
}

-(void)LockAllFeatures
{
    NSLog(@"Expired Lock All Features");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:0 forKey:@"SubscriptionExpired"];
    [prefs setInteger:1 forKey:@"SubscriptionSessionExpired"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubscriptionSessionExpired" object:self];
}

-(void)UnlockAllFeatures
{
    NSLog(@"Not Expired --- Unlock All Features");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeIndicator" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearAllLocksHere" object:nil];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:0 forKey:@"SubscriptionSessionExpired"];
    [prefs setInteger:1 forKey:@"SubscriptionExpired"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self];
}

-(void)GetExpiryWithDictionary:(NSDictionary*)lastReceipt
{
    //The purchased product id
    NSString *productID = lastReceipt[@"product_id"];
    NSLog(@"Product ID---%@",productID);
    //Boolean indicating whether the subscription is in trial period or not.
    NSString *isTrialPeriod = lastReceipt[@"is_trial_period"];
    NSLog(@"Trail Period---%@",isTrialPeriod);
    //The expires_date for the purchase.
    NSString *expiresDate = lastReceipt[@"expires_date"];
    NSLog(@"Check Date : Check Date : Expiry Date---%@",expiresDate);
    
    NSUserDefaults *userNamePrefs = [NSUserDefaults standardUserDefaults];
    //[userNamePrefs removeObjectForKey:@"SubscriptionStatusHere"];
    [userNamePrefs setObject:expiresDate forKey:@"SubscriptionStatusHere"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Expiry Date After saving---%@, Subscription Status Here %@",expiresDate,[[NSUserDefaults standardUserDefaults]stringForKey:@"SubscriptionStatusHere"]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss VV"];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:expiresDate];

    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian ];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:[NSDate date]
                                                          toDate:date
                                                         options:0];
//    [self ComparingTwoDatesAndTimes];
    //Checking the subscription is still active and is not expired.
    if([components day] > -1) {
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

-(void)LockingAllFeaturesDate
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // saving an Integer
   [prefs setInteger:0 forKey:@"SubscriptionExpiredDate"];
    NSLog(@"Check Date : LockingAllFeaturesDate %ld",(long)[prefs integerForKey:@"SubscriptionExpiredDate"]);
    
}

-(void)SubscriptionPurchasedFailed
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   // saving an Integer
   [prefs setInteger:0 forKey:@"PurchasedYES"];
}
-(void)SubscriptionPurchasedSuccessfully
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   [prefs setInteger:1 forKey:@"PurchasedYES"];
}


#pragma SubscriptionDetails
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
}

- (void)startBackgroundTaskWithName:(NSString *)taskName {
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        return;
    }
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithName:taskName expirationHandler:^{
        [self endBackgroundTask];
    }];
    
    // Add timeout
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.backgroundTask != UIBackgroundTaskInvalid) {
            NSLog(@"Background task timed out: %@", taskName);
            [self endBackgroundTask];
        }
    });
}


-(void)loadProducts{
 NSError *error;
    _currentIsActive = NO;
    NSLog(@"loading products-----");
    if(!userDef(kAppReceipt)){
        NSLog(@"loading products-----2");
        NSURL *recieptURL  = [[NSBundle mainBundle]appStoreReceiptURL];
        NSError *recieptError ;
        BOOL isPresent = [recieptURL checkResourceIsReachableAndReturnError:&recieptError];

        if(!isPresent){
            // Start a background task
            //[self startBackgroundTask];
            [self startBackgroundTaskWithName:@"LoadProductsTask"];
            NSLog(@"loading products-----3");
            SKReceiptRefreshRequest *ref = [[SKReceiptRefreshRequest alloc]init];
            ref.delegate = self;
            [ref start];
            // Set a timeout for the request
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self endBackgroundTask];
                });
            return;
        }
        //adding newly//
        if(isPresent){
            [self startBackgroundTask];
            NSLog(@"Refresshing Reciept----");
            SKReceiptRefreshRequest *ref = [[SKReceiptRefreshRequest alloc]init];
            ref.delegate = self;
            [ref start];
            // Set a timeout for the request
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self endBackgroundTask];
                });
        }
        
        NSData *recieptData = [NSData dataWithContentsOfURL:recieptURL];
        if(!recieptData){
            NSLog(@"loading products-----4");
            return;
        }
       
        payLoad = [NSMutableDictionary dictionaryWithObject:[recieptData base64EncodedStringWithOptions:0] forKey:@"receipt-data"];
        NSLog(@"loading products-----5");
    }
    else {
        [payLoad setObject:userDef(kAppReceipt) forKey:@"receipt-data"];
        NSLog(@"loading products-----6");
    }
    
    NSLog(@"loading products-----7");
    [payLoad setObject:secreteSharedKeyForSubcription forKey:@"password"];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:payLoad options:0 error:&error];
    
    NSMutableURLRequest *sandBoxReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kSandboxServer]];
    [sandBoxReq setHTTPMethod:@"POST"];
    [sandBoxReq setHTTPBody:requestData];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:sandBoxReq completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"loading products-----8");
        if(!error){
            NSLog(@"loading products-----9");
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            _latestReceipt = [jsonResponse objectForKey:@"latest_receipt"];
        
            NSLog(@"loading products-----10,jsonResponse - %@",jsonResponse);
            if([jsonResponse objectForKey:@"latest_receipt_info"]){
                NSArray *array = [jsonResponse objectForKey:@"latest_receipt_info"];
                NSDictionary *latestDetails = [array firstObject];
                NSLog(@"loading products-----11");
                if([latestDetails objectForKey:@"cancellation_date_ms"]){
                    _currentIsActive = NO;
                    NSLog(@"loading products-----12");
                }
                @try {
                    //Here it is crashing//
                    [_currentProduct setObject:[latestDetails objectForKey:@"product_id"] forKey:@"product"];
                    [_currentProduct setObject:[latestDetails objectForKey:@"expires_date_ms"] forKey:@"expiry_time"];
                    _currentIsActive = [self calculateCurrentSubscriptionActive];
                    [_currentProduct setObject:[NSNumber numberWithBool:_currentIsActive] forKey:@"active"];
                    [userDefaultss setObject:_currentProduct forKey:kSubscriptionProduct];
                    [userDefaultss setBool:_currentIsActive forKey:kSubscriptionActive];
                    NSLog(@"Product active -- %hhd",_currentIsActive);
                    NSLog(@"Latest Details***----*** %@",latestDetails);
                } @catch (NSException *exception) {
                   
                }
                
                
               

            }
            else {
                
                // no purchase done, first time user!
                NSLog(@"First time user******");
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:kSRSubscriptionResultNotification object:nil];
        }
        [self endBackgroundTask];
    }] resume];
    
    
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

-(BOOL)calculateCurrentSubscriptionActive{
    NSString *str = [_currentProduct objectForKey:@"expiry_time"];
    long long currentExpTime = [str longLongValue]/1000;
    long currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%ld",currentTimeStamp);
    
    return (currentExpTime > currentTimeStamp) ? YES : NO;
    
}
@end


