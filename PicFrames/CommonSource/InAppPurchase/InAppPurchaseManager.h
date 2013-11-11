//
//  InAppPurchaseManager.h
//  InstaSplash
//
//  Created by Vijaya kumar reddy Doddavala on 9/27/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "config.h"
#import "FlurryAnalytics.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

- (void)requestProUpgradeProductData;
// public methods
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;
-(void)restoreProUpgrade;
@end