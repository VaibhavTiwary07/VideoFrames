//
//  FlurryAppCloudSearch.h
//  Flurry
//
//  Copyright (c) 2012 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FlurryAppCloudSearchResultCompletionHandler)(NSArray *anObjects, NSError *anError);

/*!
 *  @brief This callabck is called for each found batch.
 *
 *  @param anObjects The array of FlurryAppCloudObject or FlurryAppCloudUser instances, sorted acccording to given options.
 *  @param aBatchNumber The batch number (page) for returned results.
 *  @param anError The error.
 *  @return Return YES if you want to continue enumeration or NO otherwise. YES will be ignored in case of end of the results.
 */
typedef BOOL (^FlurryAppCloudEnumSearchResultCompletionHandler)(NSArray *anObjects, NSUInteger aBatchNumber, NSError *anError);


/*!
 *  @brief FlurryAppCloudSearch should be used to fetch sorted and filtered FlurryAppCloudObjects,
 *  FlurryAppCloudUsers and FlurryAppCloudCollectionInfo data.
 */
@interface FlurryAppCloudSearch : NSObject

/*!
 *  The array of FlurryAppCloudSearchPredicate instances to filter results before being fetched.
 *  Ignored in case of listing collections.
 *  If wasn't set, results won't be filtered.
 */
@property (nonatomic, copy) NSArray *predicates;

/*!
 *  The sort descriptor to be used for sorting fetched resutls.
 *  Ignored in case of listing collections.
 *
 *  Its Key should be valid key of searched FlurryAppCloudCoreObject instances
 *
 *  Optionally provided selector/NSComparator should operate with
 *  id<FlurryAppCloudCoreObject> instance(s)
 *
 *  If wasn't set or sortDescriptor's key is nil, fetched results will be sorted by creation date.
 *  Default sort order is descending.
 */
@property (nonatomic, retain) NSSortDescriptor *sortDescriptor;

/*!
 *  @brief Sets batch size and batch number properties.
 *  Ignored in case of listing collections.
 *
 *  @param aBatchSize The batch size, number of fetched results per search.
 *  @param aBatchNumber The batch number (page) for returned results in the search
 */
- (void)setBatchSize:(NSUInteger)aBatchSize batchNumber:(NSUInteger)aBatchNumber;

/*!
 *  The amount of objects or users to be fetched.
 *  Ignored in case of listing collections.
 */
@property (nonatomic, assign, readonly) NSUInteger fetchBatchSize;

/*!
 *  The batch number (page) for objects or users that needs to be fetched.
 *  Ignored in case of listing collections.
 */
@property (nonatomic, assign, readonly) NSUInteger fetchBatchNumber;

/*!
 *  The maximum amount of results to be fetched.
 *  Will be ignored, if "fetchBatchSize" parameters has been set.
 *  Max value is 100.
 */
@property (nonatomic, assign) NSUInteger fetchLimit;

/*!
 *  @brief Performs search for objects, users or object collections.
 *  User must be logged in to use this method.
 *
 *  @param aHandler The completion handler
 */
- (void)searchWithCompletionHandler:(FlurryAppCloudSearchResultCompletionHandler)aHandler;

/*!
 *  @brief Performs search for objects or users fetching given amount of items 
 *  starting from given start number.
 *  Can't be used in case of listing collections.
 *  User must be logged in to use this method.
 *
 *  @param aFetchBatchSize The amount of objects or users to be fetched. 
 *                         Amount of returned items can be less in case of end of results.
 *  @param aStartNumber The batch number (page) for objects or users that needs to be fetched.
 *  @param aHandler The completion handler
 */
- (void)searchWithFetchBatchSize:(NSUInteger)aFetchBatchSize startFetchBatchNumber:(NSUInteger)aStartNumber completionHandler:(FlurryAppCloudEnumSearchResultCompletionHandler)aHandler;

/*!
 *  @brief Cancels any search activity.
 */
- (void)cancel;

@end