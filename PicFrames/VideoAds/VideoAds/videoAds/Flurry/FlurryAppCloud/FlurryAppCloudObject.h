//
//  FlurryAppCloudObject.h
//  Flurry
//
//  Copyright (c) 2012 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlurryAppCloudCoreObject.h"

@class FlurryAppCloudObject;
@class FlurryAppCloudSearch;

@class FlurryAppCloudACL;

typedef void(^FlurryAppCloudCreateObjectCompletionHandler)(FlurryAppCloudObject *anObject, NSError *anError);
typedef void(^FlurryAppCloudGetObjectCompletionHandler)(FlurryAppCloudObject *anObject, NSError *anError);

/*!
 *  @brief FlurryAppCloudObject should be used to store key-value data.
 *  Object must belong to collection. In current implementation,
 *  collection must be created manually on "Cloud Storage" tab 
 *  of "App Cloud" management page on http://dev.flurry.com site.
 */
@interface FlurryAppCloudObject : NSObject <FlurryAppCloudCoreObject>

/*!
 *  The collection name.
 */
@property (nonatomic, retain, readonly) NSString *collection;

/*!
 *  @brief Creates object with given properties in given collection
 *  with given Access Control Level and returns newly created FlurryAppCloudObject.
 *  You must be logged in to use this method.
 *
 *  @param aCollection The collection.
 *  @param anACL The Access Control Level object, or nil for default public access.
 *  @param aProperties The additional properties.
 *  @return Created and configured FlurryAppCloudObject instance.
 */
+ (FlurryAppCloudObject *)objectWithCollection:(NSString *)aCollectionName ACL:(FlurryAppCloudACL*)anACL;
+ (FlurryAppCloudObject *)objectWithCollection:(NSString *)aCollectionName ACL:(FlurryAppCloudACL*)anACL properties:(NSDictionary *)aProperties;
+ (FlurryAppCloudObject *)objectWithCollection:(NSString *)aCollectionName ACL:(FlurryAppCloudACL*)anACL objectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithCollection:(NSString *)aCollectionName ACL:(FlurryAppCloudACL*)anACL;
- (id)initWithCollection:(NSString *)aCollectionName ACL:(FlurryAppCloudACL*)anACL properties:(NSDictionary *)aProperties;
- (id)initWithCollection:(NSString *)aCollectionName ACL:(FlurryAppCloudACL*)anACL objectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 *  @brief Gets FlurryAppCloudObject with given objectID in given collection
 *  and returns it in completion handler.
 *  If object was cached previously, return the cached one, otherwise fetches it from server and caches.
 *  You must be logged in to use this method.
 *
 *  @param aCollection The collection.
 *  @param anObjectID The object's ID.
 *  @param aHandler The completion handler.
 */
+ (void)fetchObjectWithCollection:(NSString *)aCollection objectID:(FlurryAppCloudID *)anObjectID
                completionHandler:(FlurryAppCloudFetchObjectIDCompletionHandler)aHandler;

/*!
 *  @brief Deletes FlurryAppCloudObject with given objectID from given collection.
 *  You must be logged in to use this method.
 *
 *  @param aCollection The collection.
 *  @param anObjectID The object's ID.
 *  @param aHandler The completion handler.
 */
+ (void)deleteObjectWithCollection:(NSString *)aCollection objectID:(FlurryAppCloudID *)anObjectID
                 completionHandler:(FlurryAppCloudCommonOperationCompletionHandler)aHandler;

/*!
 *  @brief Creates FlurryAppCloudSearch object and configures
 *  it for searching FlurryAppCloudObject instances.
 *
 *  @param aCollection The collection.
 *  @return The configured search object.
 */
+ (FlurryAppCloudSearch *)appCloudSearchWithCollection:(NSString *)aCollectionName;

@end