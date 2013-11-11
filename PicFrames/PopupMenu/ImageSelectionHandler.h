//
//  ImageSelectionHandler.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/18/12.
//
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "FacebookAlbumList.h"
#import "Settings.h"
#import "OT_Facebook.h"

@interface ImageSelectionHandler : NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    Settings *nvm;
}

-(id)initWithViewController:(id)controller;
-(void)handleCamera;
-(void)handlePhotoAlbum;
-(void)handleVideoAlbum;
-(void)handleFacebookAlbum;
-(void)handleProfilePhoto;
-(void)pickVideo;
@end
