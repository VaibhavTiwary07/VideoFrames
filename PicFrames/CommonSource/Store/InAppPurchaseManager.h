//
//  InAppPurchaseManager.h
//  InstaSplash
//
//  Created by Vijaya kumar reddy Doddavala on 9/27/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "config.h"
#import "SKProduct+LocalizedPrice.h"
#if INAPP_VERIFICATION_SUPPORT
#import "VerificationController.h"
#endif
#if FLURRY_ANALYTICS_SUPPORT
#import "FlurryAnalytics.h"
#endif

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

#define key_inappproducts @"key_inappproducts"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    //SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

- (void)requestProUpgradeProductData;
// public methods
- (void)loadStore;
- (BOOL)canMakePurchases;
//- (void)purchaseProUpgrade;
-(void)puchaseProductWithId:(NSString*)prdId;
-(void)restoreProUpgrade;
+(InAppPurchaseManager*)Instance;
-(BOOL)anyPurchasesMadeSoFar;
-(NSString*)getPriceOfProduct:(NSString*)productId;
-(NSString*)getTitleOfProduct:(NSString*)productId;
-(NSString*)getDescriptionOfProduct:(NSString*)productId;
@end