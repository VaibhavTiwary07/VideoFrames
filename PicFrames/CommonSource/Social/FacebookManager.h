//
//  FacebookManager.h
//  SimpleTextInput
//
//  Created by Vijaya kumar reddy Doddavala on 7/9/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
#import "FBConnect.h"

@protocol FacebookManagerDelegate 
- (void)photoUploadStatus:(BOOL)isUploaded;
@end

@interface FacebookManager : NSObject <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>
{
    Facebook *_facebook;
	NSArray  *_permissions;
	NSString *_caption;
	BOOL      _isLoggedIn;
    BOOL      _isPhotoUploadPending;
    NSString *photoId;
    NSString *photoSrc;
    UIImage  *uploadImage;
    
    id <FacebookManagerDelegate> fbManagerDelegate;
}

@property(nonatomic,retain)Facebook *_facebook;
@property(nonatomic,retain)id <FacebookManagerDelegate> fbManagerDelegate;

- (void) publishToFacebook:(UIImage *)pImg;
- (void)getFriendsList;
- (void)login;
- (void)getMyAlbums;

@end
