//
//  FlurryAppCloudUser.h
//  Flurry
//
//  Copyright (c) 2012 Flurry Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlurryAppCloudCoreObject.h"

@class FlurryAppCloudUser;
@class FlurryAppCloudSearch;

typedef void(^FlurryAppCloudLoginAccountCompletionHandler)(FlurryAppCloudUser *aUser, NSError *anError, BOOL aNewUser);
typedef void(^FlurryAppCloudCreateAccountCompletionHandler)(FlurryAppCloudUser *aUser, NSError *anError);
typedef void(^FlurryAppCloudGetAccountCompletionHandler)(FlurryAppCloudUser *aUser, NSError *anError);

/*!
 *  @param aUsers The array of FlurryAppCloudUser objects
 *  @param anError The error
 */
typedef void(^FlurryAppCloudSearchAccountsCompletionHandler)(NSArray *aUsers, NSError *anError);


extern NSString * const FlurryAppCloudUserEmailKey;
extern NSString * const FlurryAppCloudUserUsernameKey;

/*!
 *  @brief FlurryAppCloudUser is used to represent
 *  registered user entity with some email and username and optional key-value data.
 */
@interface FlurryAppCloudUser : NSObject <FlurryAppCloudCoreObject>

/*!
 *  @brief Returns FlurryAppCloudUser instance that
 *  has been used for login last time.
 *
 *  @return The user.
 */
+ (FlurryAppCloudUser *)lastLoggedUser;

/*!
 *  @brief Creates user with given username, password and email
 *  and returns newly created FlurryAppCloudUser.
 *
 *  @param anUsername The username.
 *  @param aPassword The password.
 *  @param anEmail The email.
 *  @return Created and configured FlurryAppCloudUser instance.
 */
- (id)initWithUsername:(NSString *)anUsername password:(NSString *)aPassword email:(NSString *)anEmail;

/*!
 *  The email.
 */
@property (nonatomic, retain) NSString *email;

/*!
 *  The username.
 */
@property (nonatomic, retain) NSString *username;

/*!
 *  The password.
 */
@property (nonatomic, retain) NSString *password;

/*!
 *  @brief Reverts all local credential changes (username, password and email) to last retrieved from server.
 */
- (void)revertCredentials;

/*!
 *  @brief Shows if user is authenticated on sever.
 *  @return The authentication status.
 */
- (BOOL)isAuthenticated;

#pragma mark -

/*!
 *  @brief Gets FlurryAppCloudUser with given userID and returns it in completion handler.
 *  If user was cached previously, return the cached one, otherwise fetches it from server and caches.
 *  You must be logged in to use this method.
 *
 *  @param aUserID The user's ID.
 *  @param aHandler The completion handler.
 */
+ (void)fetchUserWithID:(FlurryAppCloudID *)aUserID completionHandler:(FlurryAppCloudGetAccountCompletionHandler)aHandler;

/*!
 *  @brief Tries to log in to user account with given username, password and email and 
 *  creates it if user with given credentials wasn't found.
 *
 *  @param aUsername The username
 *  @param aPassword The password
 *  @param anEmail The email
 *  @param aCreate The flag, that indicates if user should be created if login was unsuccessful 
 *                  because user with given credentials wasn't found.
 *  @param aHandler The completion handler
 */
+ (void)loginUserWithName:(NSString *)aUsername password:(NSString *)aPassword email:(NSString *)anEmail createIfNew:(BOOL)aCreate completionHandler:(FlurryAppCloudLoginAccountCompletionHandler)aHandler;

/*!
 *  @brief Tries to log in to current user account and
 *  creates it if user with given credentials wasn't found.
 *
 *  @param aHandler The completion handler
 */
- (void)loginCreatingIfNewWithCompletionHandler:(FlurryAppCloudLoginAccountCompletionHandler)aHandler;

/*!
 *  @brief Logs out from current user account 
 *
 *  @param aHandler The completion handler
 */
- (void)logoutWithCompletionHandler:(FlurryAppCloudCommonOperationCompletionHandler)aHandler;

/*!
 *  @brief Resets password out for user account with given username and email
 *
 *  @param aUsername The username
 *  @param anEmail The email
 *  @param aHandler The completion handler
 */
+ (void)resetPasswordForUser:(NSString *)aUsername email:(NSString *)anEmail completionHandler:(FlurryAppCloudCommonOperationCompletionHandler)aHandler;

/*!
 *  @brief Resets password out for current user account
 *
 *  @param aHandler The completion handler
 */
- (void)resetPasswordWithCompletionHandler:(FlurryAppCloudCommonOperationCompletionHandler)aHandler;

/*!
 *  @brief Resends signup validation email (if it's configured on server) for current user account
 *
 *  @param aHandler The completion handler
 */
- (void)resendSignupValidationEmailWithCompletionHandler:(FlurryAppCloudCommonOperationCompletionHandler)aHandler;

/*!
 *  @brief Creates FlurryAppCloudSearch object and configures
 *  it for searching FlurryAppCloudUser instances.
 *
 *  @return The configured search object.
 */
+ (FlurryAppCloudSearch *)appCloudUsersSearch;

@end
