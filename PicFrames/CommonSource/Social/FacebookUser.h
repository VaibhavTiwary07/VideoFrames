//
//  FacebookUser.h
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 8/1/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fbmgr.h"
#import "Yozio.h"

typedef enum
{
    FBUSRCMD_GETPROFILEPHOTO,
    FBUSRCMD_UPLOADPHOTO,
    FBUSRCMD_SETPROFILEPHOTO,
    FBUSRCMD_UPLOADPHOTO_GLOBAL,
    FBUSRCMD_UPLOADPHOTO_USERWALL,
    FBUSRCMD_MAX
}eFBUSRCMD;

@protocol FacebookUserDelegate 
@optional
-(void)imageSelected:(UIImage *)img result:(NSString*)res;
- (void)photoUploadStatus:(BOOL)isUploaded result:(NSString*)res;
@end

@interface FacebookUser : NSObject <FBRequestDelegate,fbmgrDelegate,FBDialogDelegate>
{
    fbmgr    *_fb;
    BOOL      bWaitingForLogin;
    //NSTimer  *loginTimer;
    NSString *linkToImage;
    NSString *caption;
    UIImage *image;
    eFBUSRCMD eCurCommand; 
    id <FacebookUserDelegate> imgDelegate;
}

@property(assign)id <FacebookUserDelegate> imgDelegate;

-(void)uploadPhotoAsProfilePhoto:(UIImage *)photo;
-(void)uploadPhotoToAlbum:(UIImage *)photo;
-(void)getProfilePhoto;
-(void)postOnAppsWallUsingImage:(NSString*)url messag:(NSString*)msg;
-(void)postOnUserWallUsingImage:(NSString*)url messag:(NSString*)msg;
@end
