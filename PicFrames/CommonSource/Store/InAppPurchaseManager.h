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
#import "SKProduct+LocalizedTrial.h"
#import "Utility.h"


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

#define key_inappproducts @"key_inappproducts"


API_AVAILABLE(ios(11.2))
API_AVAILABLE(ios(11.2))
API_AVAILABLE(ios(11.2))
API_AVAILABLE(ios(11.2))
@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver,SKPaymentQueueDelegate>
{
    //SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    BOOL HideTransaction;
//    BOOL purchaseClicked;
}
@property(nonatomic, readonly, nonnull)SKProductDiscount *introductoryPrice;
@property(nonatomic, readonly, nullable)SKProductSubscriptionPeriod *periodofsub;
@property(nonatomic,readonly) int transactionCount;

- (void)requestProUpgradeProductData;
// public methods
- (void)loadStore;
- (BOOL)canMakePurchases;
//- (void)purchaseProUpgrade;
-(void)puchaseProductWithId:(NSString*_Nullable)prdId;
-(void)restoreProUpgrade;
+(InAppPurchaseManager*_Nullable)Instance;
-(BOOL)anyPurchasesMadeSoFar;
-(NSString*_Nullable)getPriceOfProduct:(NSString*_Nullable)productId;
-(NSString*_Nullable)getTitleOfProduct:(NSString*_Nullable)productId;
-(NSString*_Nullable)gettrailPeriod:(NSString*_Nullable)productId;
-(NSString*_Nullable)getDescriptionOfProduct:(NSString*_Nullable)productId;
//-(long)getTrailPeriodofProduct:(NSString*_Nullable)productId;
-(long)getTrailPeriodofProductForYear:(NSString*_Nullable)productId;
-(long)getTrailPeriodofProductForMonth:(NSString*_Nullable)productId;
-(long)getTrailPeriodofProductForWeek:(NSString *_Nullable)productId;
//-(NSString*_Nullable)localizedTrialDuraion:(NSString*_Nullable)productID;
-(NSString*_Nullable)localizedTrialDuraion;
-(NSString*)getCurrencyCode:(NSString*)productId;
@end
