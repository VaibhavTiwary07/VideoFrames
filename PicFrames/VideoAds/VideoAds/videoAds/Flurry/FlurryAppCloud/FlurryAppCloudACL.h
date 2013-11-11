//
//  FlurryAppCloudACL.h
//  Flurry
//
//  Copyright (c) 2013 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlurryAppCloudACL : NSObject <NSCoding>

/*!
 *  @brief Creates FlurryAppCloudACL object and configures
 *  it as user-private.
 *
 *  @return The configured ACL object.
 */
+ (FlurryAppCloudACL *)userPrivateACL;

@end
