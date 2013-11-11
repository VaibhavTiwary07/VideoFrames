//
//  FlurryAppCloudSearchPredicate.h
//  Flurry
//
//  Copyright (c) 2012 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief FlurryAppCloudSearchPredicate should be used to 
 *  filter search results when searching for FlurryAppCloudObject and FlurryAppCloudUser
 *  instances.
 */
@interface FlurryAppCloudSearchPredicate : NSObject

/*!
 *  @brief Creates search predicate for given parameter and value.
 *
 *  @param aParameter The parameter to use in predicate.
 *  @param aValue The value to use in predicate. 
 *  For non-NSString values passed, result of - (NSString *)description will be used.
 *  @return Created and configured FlurryAppCloudSearchPredicate instance.
 */
+ (id)predicateWithKey:(NSString *)aParameter equalTo:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter notEqualTo:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter greaterThan:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter lessThan:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter greaterThanOrEquals:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter lessThanOrEquals:(id)aValue;

+ (id)predicateWithKey:(NSString *)aParameter contains:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter notContains:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter beginsWith:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter notBeginsWith:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter endsWith:(id)aValue;
+ (id)predicateWithKey:(NSString *)aParameter notEndsWith:(id)aValue;

/*!
 *  @brief Creates search predicate for given parameter and value.
 *
 *  @param aParameter The parameter to use in predicate.
 *  @param aRange The array of values to use in "predicateWithKey:inRange:" predicate.
 *  For non-NSString values passed inside array, result of - (NSString *)description will be used.
 *  @return Created and configured FlurryAppCloudSearchPredicate instance.
 */
+ (id)predicateWithKey:(NSString *)aParameter inRange:(NSArray *)aRange;

@end