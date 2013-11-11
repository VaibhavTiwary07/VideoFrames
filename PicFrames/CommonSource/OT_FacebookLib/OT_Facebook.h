//
//  OT_Facebook.h
//  FacebookIntegration
//
//  Created by Sunitha Gadigota on 5/26/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define OT_FBSessionStateChangedNotification @"com.dsrtech.Login:OT_FBSessionStateChangedNotification"
#define OT_FBBackgroundImageSelected         @"OT_FBBackgroundImageSelected"
#define OT_FBBackgroundImageKey              @"OT_FBBackgroundImageKey"
@interface OT_Facebook : NSObject
{
    NSArray *albums;
    NSMutableDictionary *coverphotos;
}

-(void)closeSession;
-(void)handleApplicationWillTerminate;
-(void)handleApplicationDidBecomeActive;
-(BOOL)handleOpenUrl:(NSURL *)url;
+(OT_Facebook*)SharedInstance;
-(void)loginToFacebook:(BOOL)allowLoginUI onCompletion:(void(^)(BOOL loginStatus))completion;
-(void)getMyInfo;

-(void)postOnWallWithImageUrl:(NSString *)linkToImage
                      message:(NSString *)msg
                      website:(NSString *)website
                         name:(NSString *)name
                  description:(NSString *)description
                      caption:(NSString *)caption
                 onCompletion:(void (^)(BOOL uploadStatus))completion;

-(void)postOnWallWithImage:(UIImage *)image
                   message:(NSString *)msg
                   website:(NSString*)website
              onCompletion:(void (^)(BOOL uploadStatus))completion;

-(void)uploadImage:(UIImage*)image withMessage:(NSString*)msg onCompletion:(void (^)(BOOL uploadStatus))completion;
-(void)uploadVideo:(NSString *)videoFile withMessage:(NSString*)msg onCompletion:(void (^)(BOOL uploadStatus))completion;
-(void)selectImageUsing:(id)viewController onCompletion:(void (^)(UIImage *selectedImage))completion;
-(void)profilePhoto:(void(^)(UIImage *profilePhoto))completion;
@end
