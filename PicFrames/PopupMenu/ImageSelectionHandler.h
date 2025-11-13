//
//  ImageSelectionHandler.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/18/12.
//
//

#import <Foundation/Foundation.h>
#import "Config.h"

#import "Settings.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "MainController.h"
#import "ShareViewController.h"
#import "Session.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>

//@class NewPickerViewController;

@interface ImageSelectionHandler : NSObject <UINavigationControllerDelegate,GADFullScreenContentDelegate,PHPickerViewControllerDelegate>//CTAssetsPickerControllerDelegate
{
    Settings *nvm;
    BOOL Imageselection;
    BOOL Videoselection;
    NSURL *phvideoURL;
    NSData*videodata;
    ShareViewController *shareView;
    Session *sess;
    NSURL *finalURL,*mp4URL,*pickerURL;
    NSString *localFilePath,*mp4PATH,*pickerPATH;
    NSMutableArray *savedArrayOfimages;
    
//    UIPopoverController *uploadPopover;
//    UIPopoverController *backgroundPopover;
//    UIPopoverController *photoAlbumPopover;
}
@property(nonatomic, strong) GADInterstitialAd *interstitial;
-(id)initWithViewController:(id)controller;
-(void)handleCamera;
//-(void)handlePhotoAlbum;
-(void)handleVideoAlbum;
//-(void)handleFacebookAlbum;
//-(void)handleProfilePhoto;
-(void)pickVideo;
//-(void)pickVideo2;
-(void)pickImage:(int)maximumNumberOfImage;
@end
