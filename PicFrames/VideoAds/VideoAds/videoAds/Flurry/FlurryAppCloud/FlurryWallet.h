//
//  FlurryWallet.h
//  Flurry
//
//  Copyright (c) 2013 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

/*!
 *  @brief An interface that represents Wallet state information
 */

@interface FlurryWalletInfo : NSObject

/*!
 *  @brief The "currency" key to track Wallet updates, exactly as configured on Flurry AppSpot account
 */
@property (nonatomic, copy, readonly) NSString *currencyKey;

/*!
 *  @brief The latest amount of currency 
 */
@property (nonatomic, copy, readonly) NSNumber *currencyAmount;

@end

#pragma mark -

/*!
 *  @brief Signature of block that is called when Wallet state changes
 *
 *  @param aWalletInfo information about Wallet change and state
 *  @param anError non nil if error with Wallet account is detected
 */
typedef void(^FlurryWalletUpdateHandler)(FlurryWalletInfo *aWalletInfo, NSError *anError);


@interface FlurryWallet : NSObject

/*!
 *  @brief Registers observer to get notifications about Wallet updates for specified currency key as configured on Flurry AppSpot
 *
 *  @param anObserver an object that will receive notifications about Wallet updates
 *  @param aKey The "currency" key to track Wallet updates, exactly as configured on Flurry AppSpot account
 *  @param aSelector selector with signature -[flurryWalletUpdated:(FlurryWalletInfo *)aWalletInfo error:(NSError *)anError] that sent to anObserver when currency represented by aKey is updated.
 */
+ (void)addObserver:(id)anObserver forCurrencyKey:(NSString *)aKey selector:(SEL)aSelector;

/*!
 *  @brief Unregisters observer from notifications about Wallet updates for specified currency key
 *
 *  @param anObserver an object that was registered to receive notifications about Wallet updates
 *  @param aKey The currency key to track Wallet updates
 */
+ (void)removeObserver:(id)anObserver forCurrencyKey:(NSString *)aKey;

/*!
 *  @brief Unregisters observer from notifications about Wallet updates for all currency keys
 *
 *  @param anObserver an object that was registered to receive notifications about Wallet updates
 */
+ (void)removeObserver:(id)anObserver;


/*!
 *  @brief Registers block to be called on Wallet updates for specified currency key as configured on Flurry AppSpot
 *
 *  @param aKey The "currency" key to track Wallet updates, exactly as configured on Flurry AppSpot account
 *  @param aHandler block that is called when currency represented by aKey is updated.
 *  @result id of registered observer block that can be used for unregistration
 */
+ (NSUInteger)addObserverForCurrencyKey:(NSString *)aKey withHandler:(FlurryWalletUpdateHandler)aHandler;

/*!
 *  @brief Unregisters block from notifications about Wallet updates for specified currency key
 *
 *  @param anID an id of previously registered block
 */
+ (void)removeObserverHandlerWithID:(NSUInteger)anID;

/*!
 *  @brief Unregisters all blocks from notifications about Wallet updates for any currency keys
 */
+ (void)removeAllObserverHandlers;


@end
