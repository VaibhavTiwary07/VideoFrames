//
//  FlurryAppCloudID.h
//  Flurry
//
//  Created by Nikita Ivaniushchenko on 1/28/13.
//  Copyright (c) 2013 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief FlurryAppCloudID is used to represent unique ID of object.
 */
@interface FlurryAppCloudID : NSObject <NSCoding>

/*!
 *  The cloudID. Is nil if object wasn't synchronized 
 *  with server or if it's already deleted.
 */
@property (nonatomic, retain, readonly) NSString *cloudID;

/*!
 *  The localID. 
 */

@property (nonatomic, retain, readonly) NSString *localID;

/*!
 *  @brief Creates FlurryAppCloudID instance with given cloud ID.
 *
 *  @param aCloudID The cloud ID.
 *  @return Created and configured FlurryAppCloudID instance.
 */
+ (FlurryAppCloudID *)objectWithCloudID:(NSString *)aCloudID;

/*!
 *  @brief Creates FlurryAppCloudID instance with given local ID.
 *
 *  @param aLocalID The local ID.
 *  @return Created and configured FlurryAppCloudID instance.
 */
+ (FlurryAppCloudID *)objectWithLocalID:(NSString *)aLocalID;

@end
