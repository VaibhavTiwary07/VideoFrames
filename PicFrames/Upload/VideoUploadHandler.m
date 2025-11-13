//
//  UploadHandler.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 10/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "VideoUploadHandler.h"
#import "WCAlertView.h"
#import <Social/Social.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <WebKit/WebKit.h>
//#import "GDataServiceGoogleYouTube.h"
//#import "GDataEntryYouTubeUpload.h"
#import "Config.h"
//#import "YouTubeView.h"
#import "Appirater.h"

#define DEVELOPER_KEY @"AIzaSyAFBrDkouL2GW17jC5OOhhb5MJ87SltZ-4"
#define CLIENT_ID @"88460119518-9jbitk596pevm1ahuaof45039b33k57h.apps.googleusercontent.com"
#define fullscreen ([[UIScreen mainScreen]bounds])


@implementation VideoUploadHandler

@synthesize viewController;
@synthesize _view;

#pragma mark misc

-(void)dealloc
{
//    [_applicationName release];
//    [_downloadUrl release];
//    [_filePath release];
//    [_shareImage release];
//    [_view release];
//    [_website release];
    
//    [super dealloc];
    //[youtube release];
}
-(NSString *)nvmFilePathFor:(NSString *)pFile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];

	/* Return the path to the puzzle status information */
	return [docDirectory stringByAppendingPathComponent:pFile];
}
#pragma mark custom initializations
-(void)updateAlreadyLiked
{
	NSFileHandle *fd;
	NSData       *data;

	if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[self nvmFilePathFor:@"AlreadyLiked.txt"]])
	{
		/* Open the File */
		fd = [NSFileHandle fileHandleForWritingAtPath:[self nvmFilePathFor:@"AlreadyLiked.txt"]];

		/* write the default status information to the file */
		data = [[NSData alloc] initWithBytes:&bAlreadyLiked length:sizeof(BOOL)];

		/* Write the data to the file */
		[fd writeData:data];

		/* Release the data */
	//	[data release];

		/* Close the file */
		[fd closeFile];
	}

	return;
}

-(void)initAlreadyLiked
{
	NSData *data;
	NSFileHandle *fd;

	/* Initialize puzzle status with zero */
	memset(&bAlreadyLiked,0,sizeof(BOOL));

	if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[self nvmFilePathFor:@"AlreadyLiked.txt"]])
	{
		/* File exist so read the saved status from the file  */
		fd = [NSFileHandle fileHandleForReadingAtPath:[self nvmFilePathFor:@"AlreadyLiked.txt"]];

		/* Read the data from the file */
		if([(data = [fd readDataOfLength:sizeof(BOOL)]) length]>0)
		{
			memcpy(&bAlreadyLiked, [data bytes], sizeof(BOOL));
		}

		[fd closeFile];
	}
	else
	{
		/* File doesn't exist so create one for future usage */
		if(NO == [[NSFileManager defaultManager] createFileAtPath:[self nvmFilePathFor:@"AlreadyLiked.txt" ] contents:nil attributes:nil])
		{
			return;
		}

		/* set the default font index */
		bAlreadyLiked = NO;

		/* update fonts nvm */
		[self updateAlreadyLiked];
	}

	return;
}


#pragma mark - status update
-(void)updateCommand:(eUPLOAD_CMD)eCmd status:(BOOL)status msg:(NSString*)mg
{
    NSString *title   = nil;
    NSString *message = nil;

    [[NSNotificationCenter defaultCenter]postNotificationName:uploaddone object:nil];

    /* Generate the index path */
    if(status == YES)
    {
        [Appirater userDidSignificantEvent:YES];
    }

    switch (eCmd)
    {
        case UPLOAD_FACEBOOK_ALBUM:
        {
            title = NSLocalizedString(@"FBUPLOAD",@"Facebook Upload");

            if(YES == status)
            {
                message = NSLocalizedString(@"FBUPLOADSUCCESS",nil);
            }
            else
            {
                message = mg;
            }

            break;
        }
        case UPLOAD_CLIPBOARD:
        {
            title = NSLocalizedString(@"COPYTOCB", @"Copy To Clipboard");

            if(YES == status)
            {
                message = NSLocalizedString(@"CBSUCCESS",@"Successfully copied to Clipboard!!!");
            }
            else
            {
                message = mg;
            }

            break;
        }
        case UPLOAD_EMAIL:
        {
            title = NSLocalizedString(@"EMAIL",@"Email");

            if(YES == status)
            {
                message = NSLocalizedString(@"EMAILSUCCESS",@"Successfully Sent the email!!!");
            }
            else
            {
                message = mg;
            }

            break;
        }
        case UPLOAD_PHOTO_ALBUM:
        {
//            title = NSLocalizedString(@"SAVETOALBUM",@"Save To Photo Album");
           

            if(YES == status)
            {
                title = @"Save To Photo Album";
//                message = NSLocalizedString(@"SAVETOALBUMSUCCESS",@"Successfully saved to Photo Album!!!");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageSavedOnce" object:nil];
                message = @"Successfully saved to Photo Album!!!";
            }
            else
            {
               // message = mg;
                title = @"Failed to Save";
//                message = NSLocalizedString(@"SAVETOALBUMSUCCESS",@"Successfully saved to Photo Album!!!");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageSavedOnce" object:nil];
                message = mg;
            }

            break;
        }


        default:
        {
            break;
        }
    }
    if([userDefaultForLimitSave integerForKey:@"CalledShareOptions"] == 1)
    {
        // Dont show popup when called by share options
        [userDefaultForLimitSave setInteger:0 forKey:@"CalledShareOptions"];
    }
    else{
        [WCAlertView showAlertWithTitle:title
                                message:message
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView){
            [Appirater userDidSignificantEvent:YES];
        }cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil];
    }

    return;
}
#pragma mark facebook like


//-(void)closeLikeButton
//{
//    UIWebView *_webview = (UIWebView*)[_view viewWithTag:TAG_WEBVIEW];
//    UIButton  *_closewebview = (UIButton*)[_view viewWithTag:TAG_CLOSEBUTTON];
//
//    if(nil != _closewebview)
//    {
//        [_closewebview removeFromSuperview];
//    }
//
//    if(nil != _webview)
//    {
//        [_webview removeFromSuperview];
//    }
//
//    _closewebview = nil;
//    _webview     = nil;
//
//  //  [self release];
//
//    return;
//}

//-(void)showLikeButton
//{
//    NSString *likeButtonIframe = applicationlikebuttonurl;
//    NSString *likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIframe];
//    UIActivityIndicatorView *pActivity;
//    UIWebView *_webview = nil;
//    UIButton *_closewebview = nil;
//
//    /* Allocate the webview */
//    _webview = [[UIWebView alloc]initWithFrame:CGRectMake(5.0, 200.0, 310.0, 100.0)];
//    [_webview loadHTMLString:likeButtonHtml baseURL:[NSURL URLWithString:@""]];
//    _webview.backgroundColor = [UIColor blackColor];
//    _webview.delegate = self;
//    _webview.tag = TAG_WEBVIEW;
//
//    _webview.layer.cornerRadius = 9.0;
//    _webview.layer.masksToBounds = YES;
//    _webview.layer.borderColor = [UIColor redColor].CGColor;
//    _webview.layer.borderWidth = 3.0;
//
//    /* its time to add the close button */
//    _closewebview = [UIButton buttonWithType:UIButtonTypeCustom];// retain];
//    _closewebview.frame = CGRectMake(295.0, 185.0, 30.0, 30.0);
//    _closewebview.tag = TAG_CLOSEBUTTON;
//
//    /* Configure the close button */
//    [_closewebview setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"close-button" ofType:@"png"]] forState:UIControlStateNormal];
//    [_closewebview setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    [_closewebview setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [_closewebview addTarget:self action:@selector(closeLikeButton)
//            forControlEvents:UIControlEventTouchUpInside];
//
//    /* Now add them to the view */
//    [_view addSubview:_webview];
//    [_view addSubview:_closewebview];
//
//  //  [_webview release];
//  //  [_closewebview release];
//    /* Hide the views until the URL is loaded */
//    _webview.hidden     = YES;
//    _closewebview.hidden = YES;
//
//    /* Add the activity indicator view to show the progress t user */
//    pActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    pActivity.tag = TAG_ACTIVITYINDICATOR;
//	pActivity.center = _webview.center;
//
//    /* Start the activity animation */
//	[_view addSubview:pActivity];
//	[pActivity startAnimating];
//   // [pActivity release];
//
//    return;
//}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    UIActivityIndicatorView *pActivity = (UIActivityIndicatorView*)[_view viewWithTag:TAG_ACTIVITYINDICATOR];
//    UIWebView *_webview = (UIWebView*)[_view viewWithTag:TAG_WEBVIEW];
//    UIButton  *_closewebview = (UIButton*)[_view viewWithTag:TAG_CLOSEBUTTON];
//
//    /* Stop animting and release */
//    [pActivity stopAnimating];
//    [pActivity removeFromSuperview];
//	pActivity = nil;
//
//    /* Now unhide webview */
//    _webview.hidden = NO;
//    _closewebview.hidden = NO;
//
//    return;
//}
- (void)photoUploadStatus:(BOOL)isUploaded result:(NSString*)res
{
    [Utility removeActivityIndicatorFrom:_view];

    if((NO == bAlreadyLiked)&&(isUploaded == YES))
    {
        /* Show the Alert */
        [WCAlertView showAlertWithTitle:NSLocalizedString(@"FBUPLOAD",@"Facebook Upload")
                                message:NSLocalizedString(@"FBUPLOADSUCCESS",@"Successfully posted to Facebook album!!!")
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex,WCAlertView *alertView)
         {
             if(NO == bAlreadyLiked)
             {
                 if(buttonIndex == 1)
                 {
                //     [self showLikeButton];

                     bAlreadyLiked = YES;
                     [self updateAlreadyLiked];
                     return;
                 }
             }

//             [self release];
         }
                      cancelButtonTitle:nil
                      otherButtonTitles:NSLocalizedString(@"NOTHANKS",@"No Thanks"),NSLocalizedString(@"LIKEUS",@"Like Us"), nil];

    }
    else
    {

        [self updateCommand:UPLOAD_FACEBOOK_ALBUM status:isUploaded msg:res];
    }
}


//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    UIActivityIndicatorView *pActivity = (UIActivityIndicatorView*)[_view viewWithTag:TAG_ACTIVITYINDICATOR];
//
//    [pActivity stopAnimating];
//    [pActivity removeFromSuperview];
//	pActivity = nil;
//
//    /* Failed to Load, so better remove the webview */
//    [self closeLikeButton];
//
//    return;
//}

#pragma mark email upload
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	/* Dismiss the modelview controller */
    NSLog(@"dissmissed***************");
	[controller dismissViewControllerAnimated:YES completion:nil];
    
	switch(result)
	{
//		case MFMailComposeResultSent:
//		{
//            /* Update the status */
//            [self updateCommand:UPLOAD_EMAIL status:YES msg:nil];
//
//			break;
//		}
//		case MFMailComposeResultFailed:
//		{
//            [self updateCommand:UPLOAD_EMAIL status:NO msg:[error localizedDescription]];
//
//			break;
//		}
//		default:
//		{
//			break;
//		}
        case MFMailComposeResultCancelled:
                    NSLog(@"User cancelled email composition.");
                    break;
                case MFMailComposeResultSaved:
                    NSLog(@"User saved email draft.");
                    break;
                case MFMailComposeResultSent:
                    [self updateCommand:UPLOAD_EMAIL status:YES msg:nil];
                    break;
                case MFMailComposeResultFailed:
                    [self updateCommand:UPLOAD_EMAIL status:NO msg:[error localizedDescription]];
                    break;
	}

	return;
}

-(void)uploadVideoToEmail:(NSString*)videoPath
{
    NSAssert(nil != self.viewController, @"uploadVideoToEmail: viewController property is not initialized");
    if (NO == nvm.connectedToInternet) {
        [WCAlertView showAlertWithTitle:@"Failed" message:@"Currently your device is not connected to internet. To send video by email , first you need to connect to internet." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        return;
    }
    else{
        
        
        if ([MFMailComposeViewController canSendMail])
        {
            NSURL  *exportUrl = [NSURL fileURLWithPath:videoPath];
            NSData   *videoDatas = [[NSData alloc] initWithContentsOfURL:exportUrl];
            if (videoDatas.length > 25000000)
            {
              //  [videoDatas release];
                [WCAlertView showAlertWithTitle:@"Alert" message:@"Can't upload more than 25MB video to Email." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            }
            else
            {
                if ([MFMailComposeViewController canSendMail])
                {
                    NSURL  *exportUrl = [NSURL fileURLWithPath:videoPath];
                    videoDatas = [[NSData alloc] initWithContentsOfURL:exportUrl];
                    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                    mailViewController.mailComposeDelegate = self;
                    [mailViewController setSubject:[self composeAdvertisingHeading]];
                    [mailViewController setMessageBody:[self composeAdvertisingMessage] isHTML:YES];
                    [mailViewController addAttachmentData:videoDatas mimeType:@"video/MOV" fileName:@"Video.MOV"];
                    mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                    [self.viewController presentViewController:mailViewController animated:YES completion:nil];
                //    [mailViewController release];
                    NSLog(@"sucess");
                }
                else
                {
                    [WCAlertView showAlertWithTitle:@"Alert" message:@"Device is unable to send email in its current state." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                }
            }
        }
        
        
    }
}

#pragma mark photo album upload
- (void) video: (NSString *) videoPath
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo
{
    if (!error)
    {
        /* update the status */
        [self updateCommand:UPLOAD_PHOTO_ALBUM status:YES msg:nil];
    }
    else
    {
        NSLog(@"failed to save localizedDescription  %@ user info %@ debug description %@",[error localizedDescription],error.userInfo,error.debugDescription,contextInfo);
        /* update the status */
        [self updateCommand:UPLOAD_PHOTO_ALBUM status:NO msg:[error localizedDescription]];
       
    }
}

-(void)uploadVideoToPhotoAlbum:(NSString*)videoPath
{
    [self checkPhotoLibraryPermissionAndSaveVideo:videoPath];
}


- (void)checkPhotoLibraryPermissionAndSaveVideo:(NSString *)videoPath {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PhotoLibraryPermission"] == 1)
    {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath,self,@selector(video:didFinishSavingWithError:contextInfo:),nil);
    }
    else
    {
        [self showAccessDeniedAlert];
//        if (@available(iOS 14, *)) {.
//            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
//            if (status == PHAuthorizationStatusNotDetermined) {
//                [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus newStatus) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self handleAuthorizationStatus:newStatus forVideoPath:videoPath];
//                    });
//                }];
//            } else {
//                [self handleAuthorizationStatus:status forVideoPath:videoPath];
//            }
//        } else {
//            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//            if (status == PHAuthorizationStatusNotDetermined) {
//                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus newStatus) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self handleAuthorizationStatus:newStatus forVideoPath:videoPath];
//                    });
//                }];
//            } else {
//                [self handleAuthorizationStatus:status forVideoPath:videoPath];
//            }
//        }
    }
}

- (void)handleAuthorizationStatus:(PHAuthorizationStatus)status forVideoPath:(NSString *)videoPath {
    switch (status) {
        case PHAuthorizationStatusAuthorized:
        case PHAuthorizationStatusLimited:
            /* Lets Upload the video to Photo Album */
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"PhotoLibraryPermission"];
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath,self,@selector(video:didFinishSavingWithError:contextInfo:),nil);
            break;
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            [self showAccessDeniedAlert];
            break;
        case PHAuthorizationStatusNotDetermined:
            // No action needed here; handled during request
            break;
    }
}


- (void)showAccessDeniedAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Access Denied"
                                                                   message:@"To save videos, please enable access in Settings."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Go to Settings"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
            [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:settingsAction];
    [alert addAction:cancelAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}



-(void)uploadVideoToFacebook:(NSString *)videoPath
{
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    if (NO == nvm.connectedToInternet) {
        [WCAlertView showAlertWithTitle:@"No Internet" message:@"Currently your device is not connected to internet. To upload video to Facebook , first you need to connect to internet." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        return;
    }
    else if(!isInstalled)
    {
        [WCAlertView showAlertWithTitle:@"Install Facebook App" message:@"Facebook App is Not installed . To upload video to Facebook , first you need to install Facebook." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        return;
        
    }
    else
    {
        //[self saveToCameraRoll:[NSURL fileURLWithPath:videoPath]];
      //  [self saveVideoToCameraRoll:[NSURL fileURLWithPath:videoPath]];
    }

}




//#pragma uploadVideoToTwitter
/* Created By Rajesh Kumar*/
//- (void)saveToCameraRoll:(NSURL *)srcURL
//{
//    NSLog(@"srcURL: %@", srcURL);
//    
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
//    ^(NSURL *newURL, NSError *error) {
//        if (error) {
//            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
//        } else {
////            NSLog( @"Wrote image with metadata to Photo Library %@", newURL.absoluteString);
////           NSURL* url_new  = newURL;
////            FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
////            NSURL *videoURL = url_new;
////            FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init ];
////            video.videoURL = videoURL;
////            FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init ];
////            content.video = video;
////            shareDialog.shareContent = content;
////            shareDialog.delegate = self;
////            [shareDialog show];
//        }
//    };
//    
//    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:srcURL])
//    {
//        [library writeVideoAtPathToSavedPhotosAlbum:srcURL
//                                    completionBlock:videoWriteCompletionBlock];
//    }
//}

#pragma mark youtube upload
-(void)uploadVideoToYoutube:(NSString*)videoPath
{
    if (NO == nvm.connectedToInternet) {
        [WCAlertView showAlertWithTitle:@"Failed" message:@"Currently your device is not connected to internet. To upload video to Youtube , first you need to connect to internet." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        return;
    }else
    {
        //commented//
        
//        [youtubeUploader uploadPrivateVideoWithTitle:@"Video Made with Video Collage"
//                                             description:@"Video Made with Video Collage"
//                                     commaSeperatedTags:@"4 VideoTag1, 4 VideoTag2"
//                                                andPath:videoPath];
//    youtube = [[YouTubeView alloc] initWithFrame:CGRectMake(0, 0, fullscreen.size.width , fullscreen.size.height)];
//    youtube . filePath = videoPath;
//    [self._view addSubview:youtube];
  
        // kpk //
    }

}


#pragma mark viddy upload
-(void)uploadVideoToViddy:(NSString*)videoPath
{

    NSURL *viddyUrl = [NSURL URLWithString:@"viddy://user/profile/VideoCollage"];
    if([[UIApplication sharedApplication]canOpenURL:viddyUrl])
    {
        UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:videoPath]];
        docController.UTI = @"com.viddy.media";
        NSString *captionString = [NSString stringWithFormat:@"This Video is created by @%@ app #%@",appname,appname];
        docController.annotation = [NSDictionary dictionaryWithObjectsAndKeys:@"VideoCollage://localhost/exportData", @"return_uri", @"VideoCollage", @"application_name",captionString,@"caption", nil];
        docController.delegate = self;
      //  [docController retain];


        [docController presentOpenInMenuFromRect:CGRectZero inView:_view animated:YES];

    }else
    {
        [WCAlertView showAlertWithTitle:@"Install Viddy"
                                message:@"Please install Viddy . Currently Viddy is not installed in your device. "
                     customizationBlock:nil
                        completionBlock:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil, nil];
    }
    

}
#pragma mark instagram upload

-(void)uploadVideoToInstagram:(NSString*)videoPath
{
    [self uploadVideoToPhotoAlbum:videoPath];
    [WCAlertView showAlertWithTitle:@"Video Saved To PhotoAlbum"
                            message:@"Your Video has been successfully saved to PhotoAlbum. You can upload it to Instagram!!!"
                 customizationBlock:nil
                    completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView){
                        [self openInstagarm];
                    }cancelButtonTitle:NSLocalizedString(@"OK", @"")
                  otherButtonTitles:nil];

}

-(void)openInstagarm
{
    NSURL *instagramUrl = [NSURL URLWithString:@"instagram://VideoCollage"];
    if([[UIApplication sharedApplication]canOpenURL:instagramUrl])
    {
       // [[UIApplication sharedApplication] openURL:instagramUrl];
        [[UIApplication sharedApplication] openURL:instagramUrl options:@{} completionHandler:nil];
    }else
    {
        [WCAlertView showAlertWithTitle:@"Install Instagram"
                                message:@"Please install Instagram . Currently  instagram is not installed in your device. "
                     customizationBlock:nil
                        completionBlock:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil, nil];
    }

}

#pragma mark marketing message composing
-(NSString*)composeAdvertisingHeading
{
    NSString *message = nil;

    if(nil == self.applicationNames)
    {
        return message;
    }

    message = [NSString stringWithFormat:@"Checkout What i made with %@ iphone application",self.applicationNames];

    return message;
}

//-(NSString*)composeAdvertisingMessage
//{
//    NSString *message = nil;
//
//    if(nil == self.applicationNames)
//    {
//        return message;
//    }
//
//    message = [NSString stringWithFormat:@"I created this Video using %@ iphone application. ",self.applicationNames];
//
//    if(nil == self.downloadUrl)
//    {
//        return message;
//    }
//
//    message = [message stringByAppendingFormat:@"You can download the application from %@. ",ituneslinktoApp];
//    
//    NSLog(@"message is %@",message);
//    if(nil == self.website)
//    {
//        return message;
//    }
//
//    message = [message stringByAppendingFormat:@"Checkout %@ for more details",websiteOfApp];
//
//    return message;
//}

- (NSString *)composeAdvertisingMessage {
    NSString *message = nil;
    
    if (nil == self.applicationNames) {
        return nil;
    }
    
    // Start with HTML wrapper
    NSMutableString *htmlMessage = [NSMutableString stringWithFormat:@"<html><body>I created this Video using %@ iPhone application. ", self.applicationNames];
    
    if (ituneslinktoApp) {
        // Add clickable App Store link
        [htmlMessage appendFormat:@"<br><br>You can download the application from <a href='%@'>%@</a>. ",
         ituneslinktoApp,
         ituneslinktoApp];
    }
    
//    if (websiteOfApp) {
//        // Add clickable website link
//        [htmlMessage appendFormat:@"<br><br>Checkout <a href='%@'>%@</a> for more details",
//         websiteOfApp,
//         websiteOfApp];
//    }
    
    [htmlMessage appendString:@"</body></html>"];
    
    NSLog(@"HTML message is %@", htmlMessage);
    return htmlMessage;
}

-(void)uploadVideoAtPath:(NSString*)videoPath to:(eUPLOAD_CMD)eUploadOption
{
    nvm = [Settings Instance];

    [self initAlreadyLiked];
  
    switch(eUploadOption)
    {
        case UPLOAD_FACEBOOK_ALBUM:
        {
            [self uploadVideoToFacebook:videoPath];
            break;
        }
        case UPLOAD_TWITTER:
        {
            NSLog(@"uploadVideoAtPath: Option UPLOAD_TWITTER is Not Supported for video");
            break;
        }
        case UPLOAD_EMAIL:
        {
            [self uploadVideoToEmail:videoPath];
            break;
        }
        case UPLOAD_PHOTO_ALBUM:
        {
            [self uploadVideoToPhotoAlbum:videoPath];
            break;
        }
        case UPLOAD_CLIPBOARD:
        {
            NSLog(@"uploadVideoAtPath: Option UPLOAD_CLIPBOARD is Not Supported for video");
            break;
        }
        case UPLOAD_INSTAGRAM:
        {
            [self uploadVideoToInstagram:videoPath];
            break;
        }
        case UPLOAD_VIDDY:
        {
            [self uploadVideoToViddy:videoPath];
            break;
        }
        case UPLOAD_YOUTUBE:
        {
            [self uploadVideoToYoutube:videoPath];
            //kpk//
            break;
        }
        default:
        {
            break;
        }
    }
}

/* Deligates methods Created by Rajesh Kumar*/
//- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
//{
//    NSLog(@"completed share:%@", results);
//}
//
//- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
//{
//    NSLog(@"sharing error:%@", error);
//
//}
//
//- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
//{
//    NSLog(@"share cancelled");
//}


//////-----------------YoutubeMethods------------//
//
//-(NSString *)youtubeAPIClientID
//{
//    return@"304715988357-8vuq0b89imqh0474ri4ceigpn7m145h6.apps.googleusercontent.com";
//}
//
//- (NSString *)youtubeAPIClientSecret
//{
//    return @"rCcqhEdkZsOkQ4bEEqfM6i47";
//}
//
//- (void)showAuthenticationViewController:(UIViewController *)authView;
//
//{
//    [self.navigationController pushViewController:authView animated:YES];
//}
//
//- (void)authenticationEndedWithError:(NSError *)error;
//{
//    NSLog(@"Error   vvvvvv    %@", error.description);
//    if (error==nil) {
//        [youtubeUploader uploadPrivateVideoWithTitle:@"Video Made with Video Collage"
//                                         description:@"Video Made with Video Collage"
//                                  commaSeperatedTags:@"4 VideoTag1, 4 VideoTag2"
//                                             andPath:_exportPath];
//
//
//    }
//    else{
//        NSLog(@"authentication failed");
//    }
//
//
//}
//
//
//- (void)uploadProgressPercentage:(int)percentage;
//{
//
//    if ((percentage==100)||(percentage>=1))
//    {
//
//        NSLog(@"hundred");
//        [HUD hide:YES];
//    }
//    else{
//        HUD.labelText = @"Uploading";
//        [HUD show:YES];
//        NSLog(@"less than 100");
//        NSLog(@"uploaded %d",percentage);
//    }
//
//
//}
//
//-(void)youtubedone
//{
//
//   // HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    //HUD.mode = MBProgressHUDModeIndeterminate;
//
//    [youtubeUploader uploadPrivateVideoWithTitle:@"Video Made with Video Collage"
//                                     description:@"Video Made with Video Collage"
//                              commaSeperatedTags:@"4 VideoTag1, 4 VideoTag2"
//                                         andPath:self._exportPath];
//
//}

@end
