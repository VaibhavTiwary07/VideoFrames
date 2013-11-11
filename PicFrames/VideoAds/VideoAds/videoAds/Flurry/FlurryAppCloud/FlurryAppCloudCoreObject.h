//
//  FlurryAppCloudCoreObject.h
//  Flurry
//
//  Copyright (c) 2013 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlurryAppCloudID;
@class FlurryAppCloudACL;
@protocol FlurryAppCloudCoreObject;

typedef void(^FlurryAppCloudCommonOperationCompletionHandler)(NSError *anError);
typedef void(^FlurryAppCloudApplyObjectChangesCompletionHandler)(NSError *anError, BOOL aNewObject);
typedef void(^FlurryAppCloudFetchObjectIDCompletionHandler)(id<FlurryAppCloudCoreObject> anObject, NSError *anError);

typedef void(^FlurryAppCloudKeyObserverHandler)(NSString *aKey);

/*!
 *  @param anObjects The array of FlurryAppCloudObject objects
 *  @param anError The error
 */
typedef void(^FlurryAppCloudSearchObjectsCompletionHandler)(NSArray *anObjects, NSError *anError);

/*!
 *  @param aCollections The array of FlurryAppCloudObjectCollection objects
 *  @param anError The error
 */
typedef void(^FlurryAppCloudListCollectionsCompletionHandler)(NSArray *aCollections, NSError *anError);

/*!
 *  @brief FlurryAppCloudCoreObject is the protocol for classes storing key-value data.
 */
@protocol FlurryAppCloudCoreObject <NSObject, NSCoding>

/*!
 *  The objectID
 */
@property (nonatomic, retain, readonly) FlurryAppCloudID *objectID;

/*!
 *  The access control level.
 */
@property (nonatomic, retain, readonly) FlurryAppCloudACL *ACL;

#pragma mark -

/*!
 *  @brief Sets new object for given key.
 *  If the object is nil, object for given key will be removed.
 *
 *  @param anObject The new object to be set.
 *  @param aKey The key to set object for.
 */
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

/*!
 *  @brief Sets new objects for given keys.
 *
 *  @param firstObject The first object to be set.
 *  @param aKey The key to set object for.
 */
- (void)setObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 *  @brief Sets new objects for keys from given dictionary.
 *
 *  @param aProperties The dictionary to set new objects and keys from.
 */
- (void)addEntriesFromDictionary:(NSDictionary *)aProperties;

/*!
 *  @brief Gets object for given key.
 *
 *  @param aKey The key to get object for.
 *  @return The stored object.
 */
- (NSString *)objectForKey:(NSString *)aKey;

/*!
 *  @brief Gets value for given key converting it to given class.
 *  This method raises an NSInvalidArchiveOperationException if data is not a valid archive.
 *
 *  @param aKey The key to get value for.
 *  @param aClass The class to be used for converted result.
 *  @return The stored value.
 */
- (id)objectForKey:(NSString *)aKey ofClass:(Class)aClass;

/*!
 *  @brief Gets all present keys.
 *
 *  @return The keys.
 */
- (NSArray *)allKeys;

/*!
 *  @brief Reverts all local changes to last retrieved from server.
 */
- (void)revertData;

/*!
 *  @brief Gets integer value for given key.
 *  If you want perform search by this key, you must use "int_" prefix for key name.
 *
 *  @param aKey The key to get object for.
 *  @return The stored integer value. Returns 0 if value for given key was not found.
 */
- (NSInteger)integerForKey:(NSString *)aKey;

/*!
 *  @brief Sets given integer value for given key.
 *  If you want perform search by this key, you must use "int_" prefix for key name.
 *
 *  @param aValue The integer value to set.
 *  @param aKey The key to set value for.
 */
- (void)setInteger:(NSInteger)aValue forKey:(NSString *)aKey;

/*!
 *  @brief Gets float value for given key.
 *  If you want perform search by this key, you must use "float_" prefix for key name.
 *
 *  @param aKey The key to get object for.
 *  @return The stored float value. Returns 0 if value for given key was not found.
 */
- (float)floatForKey:(NSString *)aKey;

/*!
 *  @brief Sets given float value for given key.
 *  If you want perform search by this key, you must use "float_" prefix for key name.
 *
 *  @param aValue The float value to set.
 *  @param aKey The key to set value for.
 */
- (void)setFloat:(float)aValue forKey:(NSString *)aKey;

#pragma mark -

/*!
 *  @brief Increments given field by given value for current object
 *
 *  @param aKey The key to be decremented.
 *  @param aValue The decrement, must be greater than zero.
 *  @param aHandler The completion handler
 */
- (void)incrementNumberWithKey:(NSString *)aKey byAmount:(NSNumber *)anAmount completionHandler:(FlurryAppCloudCommonOperationCompletionHandler)aHandler;

/*!
 *  @brief Decrements given field by given value for current object
 *
 *  @param aKey The key to be decremented.
 *  @param aValue The decrement, must be greater than zero.
 *  @param aHandler The completion handler
 */
- (void)decrementNumberWithKey:(NSString *)aKey byAmount:(NSNumber *)anAmount completionHandler:(FlurryAppCloudCommonOperationCompletionHandler)aHandler;

#pragma mark -

/*!
 *  Standard KVO is working for all keys returned by method -[allKeys]
 *  +
 *  KVO based convinience methods below
 */

/*!
 *  @brief Registers observer to get notifications about value updates for specified key
 *
 *  @param anObserver an object that will receive notifications about value updates
 *  @param aKey The key to track value updates
 *  @param aSelector selector with signature -[appCloudCoreObjectDidChangeValueForKey:(NSString *)aKey] that sent to anObserver object when value of aKey is updated.
 */
- (void)addObserver:(id)anObserver forKey:(NSString *)aKeyToObserve selector:(SEL)aSelector;

/*!
 *  @brief Unregisters observer from notifications about value updates for specified key
 *
 *  @param anObserver an object that was registered to receive notifications about value updates
 *  @param aKey The key to track value updates
 */
- (void)removeObserver:(id)anObserver forKey:(NSString *)aKey;

/*!
 *  @brief Unregisters observer from notifications about value updates for all keys
 *
 *  @param anObserver an object that was registered to receive notifications about value updates
 */
- (void)removeObserver:(id)anObserver;

/*!
 *  @brief Registers block to be called on value updates for specified key
 *
 *  @param aKey The key to track value updates
 *  @param aHandler block with signature  (void (^)(NSString *aKey) that is called when value of the aKey is updated.
 *  @result id of registered observer block that can be used for unregistration
 */
- (NSUInteger)addObserverForKey:(NSString *)aKeyToObserve withHandler:(FlurryAppCloudKeyObserverHandler)aHandler;

/*!
 *  @brief Unregisters block from notifications about value updates for specified key
 *
 *  @param anID an id of previously registered block
 */
- (void)removeObserverHandlerWithID:(NSUInteger)anID;

/*!
 *  @brief Unregisters all blocks from notifications about value updates for any keys
 */
- (void)removeAllObserverHandlers;

/*!
 *  @brief Enables automatic sync of object with server AppCloud counterpart that makes triggering of KVO and KVO based methods occur without direct interaction with object by means of other API. Current implementation uses polling as mechanism for changes detection, so usage of this feature can lead to increase of network traffic usage and should be used only when needed.
 *  NO by default.
 */
@property (nonatomic, assign, getter=isAutoSyncEnabled) BOOL autoSyncEnabled;

#pragma mark -

/*!
 *  @brief Creates new object or sends modified data to server for existent object.
 *
 *  @param aHandler The completion handler
 */
- (void)applyChangesWithCompletionHandler:(FlurryAppCloudApplyObjectChangesCompletionHandler)aHandler;

/*!
 *  @brief Fetches data for current object from server and reverts all local changes.
 *  Always ignores cache and completes with error in case of bad or lost connection.
 *
 *  @param aHandler The completion handler
 */
- (void)fetchWithCompletionHandler:(FlurryAppCloudCommonOperationCompletionHandler)aHandler;

/*!
 *  @brief Deletes current object from server.
 *
 *  @param aHandler The completion handler
 */
- (void)deleteWithCompletionHandler:(FlurryAppCloudCommonOperationCompletionHandler)aHandler;

@end
