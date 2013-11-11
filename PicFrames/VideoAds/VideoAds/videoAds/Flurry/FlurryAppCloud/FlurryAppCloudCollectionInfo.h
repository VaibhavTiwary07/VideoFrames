//
//  FlurryAppCloudCollectionInfo.h
//  Flurry
//
//  Copyright (c) 2012 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlurryAppCloudSearch;

/*!
 *  @brief FlurryAppCloudCollectionInfo is presentation for collection 
 *  of FlurryAppCloudObjects stored on server.
 */
@interface FlurryAppCloudCollectionInfo : NSObject <NSCoding>

/*!
 *  The collection name.
 */
@property (nonatomic, retain, readonly) NSString *name;

/*!
 *  The amount of objects stored in current collection.
 */
@property (nonatomic, assign, readonly) NSUInteger objectsCount;

/*!
 *  @brief Creates FlurryAppCloudSearch object and configures
 *  it for listing collections.
 *
 *  @return The configured search object.
 */
+ (FlurryAppCloudSearch *)appCloudCollectionsSearch;

@end
