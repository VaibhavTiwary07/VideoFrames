//
//  UploadHandler.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 10/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "UploadHandler.h"
//#import "Color_SplurgeViewController.h"
#import "WCAlertView.h"
@implementation UploadHandler
@synthesize viewController;
@synthesize view;
@synthesize cursess;

#pragma mark misc

-(void)dealloc
{
    if(nil != twitUser)
    {
       // [twitUser release];
        twitUser = nil;
    }
    
    if(nil != twitPassword)
    {
     //   [twitPassword release];
        twitPassword = nil;
    }
   // [viewController release];
   // [super dealloc];
}

-(UIImage*)getTheSnapshot
{
    nvm = [Settings Instance];
    return [self.cursess.frame renderToImageOfSize:nvm.uploadSize];
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

-(void)updateTwitterCredentials
{
	NSFileHandle *fd;
	NSData       *data;
	
    /* Set the memory to zero */
    memset(&tCredentials,0,sizeof(t_TwitterCredentials));
    
    /* copy the current credentials */
    strncpy(tCredentials.user, [twitUser UTF8String], 64);
    strncpy(tCredentials.password, [twitPassword UTF8String], 64);
    
	if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[self nvmFilePathFor:@"twitpic.txt"]])
	{
		/* Open the File */
		fd = [NSFileHandle fileHandleForWritingAtPath:[self nvmFilePathFor:@"twitpic.txt"]];
		
		/* write the default status information to the file */
		data = [[NSData alloc] initWithBytes:&tCredentials length:sizeof(t_TwitterCredentials)];
		
		/* Write the data to the file */
		[fd writeData:data];
		
		/* Release the data */
		//[data release];
		
		/* Close the file */
		[fd closeFile];
	}
	
	return;
}

-(void)initTwitterCredentials
{
	NSData *data;
	NSFileHandle *fd;
	
	/* Initialize puzzle status with zero */
	memset(&tCredentials,0,sizeof(t_TwitterCredentials));
	
	if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[self nvmFilePathFor:@"twitpic.txt"]])
	{
		/* File exist so read the saved status from the file  */
		fd = [NSFileHandle fileHandleForReadingAtPath:[self nvmFilePathFor:@"twitpic.txt"]];
		
		/* Read the data from the file */
		if([(data = [fd readDataOfLength:sizeof(t_TwitterCredentials)]) length]>0)
		{			
			memcpy(&tCredentials, [data bytes], sizeof(t_TwitterCredentials));
		}
		
		[fd closeFile];
        
        twitUser = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%s",tCredentials.user]];
        twitPassword = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%s",tCredentials.password]];
	}
	else
	{
		/* File doesn't exist so create one for future usage */
		if(NO == [[NSFileManager defaultManager] createFileAtPath:[self nvmFilePathFor:@"twitpic.txt" ] contents:nil attributes:nil])
		{
			return;
		}
		
        twitUser     = nil;
        twitPassword = nil;
		
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
           // title = NSLocalizedString(@"Save to album",@"Save To Photo Album");
            title = NSLocalizedString(@"Save To Photo Album",@"Save To Photo Album");
            if(YES == status)
            {
         
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageSavedOnce" object:nil];
                   // message = NSLocalizedString(@"Successfully saved",@"Successfully saved to Photo Album!!!");
                message = NSLocalizedString(@"Successfully saved",@"Successfully saved");
               
              //  sending notification from here//
            }
            else
            {
               // message = mg;
            }
            
            break;
        }
#if TW
        case UPLOAD_TWITTER:
        {
            title = NSLocalizedString(@"TWITPICUPLOAD",@"Twitter Upload");
            
            if(YES == status)
            {
                message = NSLocalizedString(@"TWITPICUPLOADSUCCESS",@"Successfully posted to twitpic!!!");
            }
            else
            {
                [self setTwitterUser:nil password:nil];
                
                message = mg;
            }
            
            break;
        }
#endif
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
        }cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil];
    }
    
    return;
}

#pragma mark facebook like


//-(void)closeLikeButton
//{
//    UIWebView *_webview = (UIWebView*)[self.view viewWithTag:TAG_WEBVIEW];
//    UIButton  *_closewebview = (UIButton*)[self.view viewWithTag:TAG_CLOSEBUTTON];
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
   // [self release];
    
 //   return;
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
//    [self.view addSubview:_webview];
//    [self.view addSubview:_closewebview];
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
//	[self.view addSubview:pActivity];
//	[pActivity startAnimating];
//  //  [pActivity release];
//    
//    return;
//}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    UIActivityIndicatorView *pActivity = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_ACTIVITYINDICATOR];
//    UIWebView *_webview = (UIWebView*)[self.view viewWithTag:TAG_WEBVIEW];
//    UIButton  *_closewebview = (UIButton*)[self.view viewWithTag:TAG_CLOSEBUTTON];
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

//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    UIActivityIndicatorView *pActivity = (UIActivityIndicatorView*)[self.view viewWithTag:TAG_ACTIVITYINDICATOR];
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

#pragma mark facebook upoad
-(void)imageSelected:(UIImage*)img result:(NSString *)res
{
    
}

- (void)photoUploadStatus:(BOOL)isUploaded result:(NSString*)res
{
    [Utility removeActivityIndicatorFrom:view];
    
    if((NO == bAlreadyLiked)&&(isUploaded == YES))
    {
        /* Show the Alert */
        /*UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Facebook Upload" 
                                                      message:@"Successfully posted to Facebook album!!!"
                                                     delegate:nil 
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"Like Us",@"No Thanks",nil] autorelease];
        
        UIAlertView *av = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FBUPLOAD",@"Facebook Upload") 
                                                      message:NSLocalizedString(@"FBUPLOADSUCCESS",@"Successfully posted to Facebook album!!!")
                                                     delegate:nil 
                                            cancelButtonTitle:nil
                                            otherButtonTitles:NSLocalizedString(@"NOTHANKS",@"No Thanks"),NSLocalizedString(@"LIKEUS",@"Like Us"),nil] autorelease];
        av.delegate = self;
        [av show];*/
        
        [WCAlertView showAlertWithTitle:NSLocalizedString(@"FBUPLOAD",@"Facebook Upload")
                                message:NSLocalizedString(@"FBUPLOADSUCCESS",@"Successfully posted to Facebook album!!!")
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex,WCAlertView *alertView)
                        {
                            if(NO == bAlreadyLiked)
                            {
                                if(buttonIndex == 1)
                                {
                                  //  [self showLikeButton];
                                    
                                    bAlreadyLiked = YES;
                                    [self updateAlreadyLiked];
                                    return;
                                }
                            }
                            
                            //[self release];
                        }
                      cancelButtonTitle:nil
                      otherButtonTitles:NSLocalizedString(@"NOTHANKS",@"No Thanks"),NSLocalizedString(@"LIKEUS",@"Like Us"), nil];
        //[av release];
        
    }
    else
    {
        
        [self updateCommand:UPLOAD_FACEBOOK_ALBUM status:isUploaded msg:res];
    } 
}

#if 0
-(void)uploadToFacebook
{
    //[self showLikeButton];
    
    //return;
    /* Allocate facebook user */
    FacebookUser *puserlocal = [[FacebookUser alloc]init];
    
    /* Set the delegate */
    puserlocal.imgDelegate = self;
    
    /* Not sure whether this step is required or not */
    //[fbmgr Instance];
    [Utility addActivityIndicatotTo:view withMessage:NSLocalizedString(@"UPLOADING",@"Uploading")];
    
    /* Upload the photo to photo album */
    [puserlocal uploadPhotoToAlbum:[self getTheSnapshot]];
    
    return;
}
#else

/* Created By Rajesh Kumar*/
-(void)uploadToFacebook
{
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    if (NO == nvm.connectedToInternet) {
        [WCAlertView showAlertWithTitle:@"Failed!!" message:@"Currently your device is not connected to internet. To upload image to Facebook , first you need to connect to intenet" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        return;
    }
    else if(!isInstalled)
    {
        [WCAlertView showAlertWithTitle:@"Install Facebook App" message:@" To upload image to Facebook , first you need Facebook App Install It" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    }
    else{
//        FBSDKSharePhoto *photo = [[[FBSDKSharePhoto alloc] init] autorelease];
//        photo.image =[self getTheSnapshot];
//        photo.userGenerated = YES;
//        FBSDKSharePhotoContent * photoContent = [[[FBSDKSharePhotoContent alloc] init] autorelease];
//        photoContent.photos = @[photo];
//        FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
//        shareDialog.shareContent = photoContent;
//        shareDialog.delegate = (id)self;
//        NSError * error = nil;
//        BOOL validation = [shareDialog validateWithError:&error];
//        if (validation) {
//            [shareDialog show];
//        }
    }

    }
#endif
#pragma mark text message upload

#pragma mark email upload
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{	
	/* Dismiss the modelview controller */
	//[controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:^{
        NSLog(@"upload handler View controller dismissed!");
    }];
	switch(result)
	{
		case MFMailComposeResultSent:
		{ 
            /* Update the status */
            [self updateCommand:UPLOAD_EMAIL status:YES msg:nil];
  
			break;
		}
		case MFMailComposeResultFailed:
		{
            [self updateCommand:UPLOAD_EMAIL status:NO msg:[error localizedDescription]];
 
			break;
		}
		default:
		{
			break;
		}
	}
	
	return;
}

#pragma mark copy to clipboard
-(void)copyToClipboard
{
    [UIPasteboard generalPasteboard].image = [self getTheSnapshot];
    
    [self updateCommand:UPLOAD_CLIPBOARD status:YES msg:nil];
    
    return;
}

#pragma mark twitter upload
#if TWITTER_SUPPORT_ENABLED
-(void)setTwitterUser:(NSString*)user password:(NSString*)pass
{
    if(nil != twitUser)
    {
        [twitUser release];
        twitUser = nil;
    }
    
    if(nil != twitPassword)
    {
        [twitPassword release];
        twitPassword = nil;
    }
    
    if((user == nil)||(pass == nil))
    {
        twitUser = nil;
        twitPassword = nil;
        
        return;
    }
    
    twitUser = [[NSString alloc]initWithString:user];
    twitPassword = [[NSString alloc]initWithString:pass];
    
    [self updateTwitterCredentials];
    
    return;
}

-(NSString*)getTwitterUser
{
    return twitUser;
}

-(NSString*)getTwitterPassword
{
    return twitPassword;
}

-(void)uploadToTwitpic
{
    CustomAlertView *alert = [[CustomAlertView alloc] init];
    alert.delegate = self;
    alert.userField.text = [self getTwitterUser];
    alert.inputField.text = [self getTwitterPassword];
    
    if(nil == [self getTwitterUser])
    {
        NSLog(@"twit user and pass are nil");
    }
    else
    {
        NSLog(@"twit user %@ and pass %@",[self getTwitterUser],[self getTwitterPassword]);
    }
    
    [alert show];
    [alert release];
}

- (void) CustomAlertView:(CustomAlertView *)alert wasDismissedWithUserName:(NSString *)user passward:(NSString*)pass;
{
    TwitpicManager *pmgr = [TwitpicManager alloc];
    pmgr.delegate = self;
    
    [self setTwitterUser:user password:pass];
    
    self.view.hidden = YES;
    
    [pmgr upload:[self getTheSnapshot] 
      withStatus:nil user:[self getTwitterUser] 
        password:[self getTwitterPassword]];
    
    self.view.hidden = NO;
}

- (void) customAlertViewWasCancelled:(CustomAlertView *)alert
{
    return;
}
#endif
#pragma mark photo album upload
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo 
{  
    if (!error) 
    {  
        /* update the status */
        [self updateCommand:UPLOAD_PHOTO_ALBUM status:YES msg:nil];
    } 
    else 
    {  
        /* update the status */
        if(self.savingCountLimit>0)
        {
            NSLog(@"got the limit---%d",self.savingCountLimit);
        }
        NSLog(@"Image saved error description ------%@",error.description);
        NSLog(@"Image saved error debugDescription ------%@",error.debugDescription);
        [self updateCommand:UPLOAD_PHOTO_ALBUM status:NO msg:[error localizedDescription]];
        NSLog(@"got the limit---%d",self.savingCountLimit);
    }
 
    return;
} 

-(void)uploadToPhotoAlbum
{
    /* Save the image to photo album */
    
    
  
    NSInteger saveCount = [Saving_Number_defaults integerForKey:@"SavingCount"];
    self.savingCountLimit = (int)saveCount;
    NSLog(@"got the limit---%d",self.savingCountLimit);
    
    
   // if(self.currentSavingCount<=self.savingCountLimit)
   // {
        self.currentSavingCount++;
     //   UIImageWriteToSavedPhotosAlbum([self getTheSnapshot], self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    [self checkPhotoLibraryPermissionAndSaveImage:[self getTheSnapshot]];
        NSLog(@"Current Saving Count is---%d",self.currentSavingCount);
   // }
    
//    else
//    {
//        UIImageWriteToSavedPhotosAlbum([self getTheSnapshot], self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
//
//    }
 
    NSLog(@"image is saving here");
    return;
}

- (void)checkPhotoLibraryPermissionAndSaveImage:(UIImage *)image {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PhotoLibraryPermission"] == 1)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), NULL);
    }
    else
    {
        [self showAccessDeniedAlert];
//        if (@available(iOS 14, *)) {
//            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
//            if (status == PHAuthorizationStatusNotDetermined) {
//                [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus newStatus) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self handleAuthorizationStatus:newStatus forImage:image];
//                    });
//                }];
//            } else {
//                [self handleAuthorizationStatus:status forImage:image];
//            }
//        } else {
//            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//            if (status == PHAuthorizationStatusNotDetermined) {
//                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus newStatus) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self handleAuthorizationStatus:newStatus forImage:image];
//                    });
//                }];
//            } else {
//                [self handleAuthorizationStatus:status forImage:image];
//            }
//        }
    }
}

- (void)handleAuthorizationStatus:(PHAuthorizationStatus)status forImage:(UIImage *)image {
    switch (status) {
        case PHAuthorizationStatusAuthorized:
        case PHAuthorizationStatusLimited:
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"PhotoLibraryPermission"];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), NULL);
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
                                                                   message:@"To save photos, please enable access in Settings."
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






//- (NSString *)uploadImageToOurServer:(UIImage*)image
//{
//    if(nil == image)
//    {
//        return nil;
//    }
//    
//    [Utility addActivityIndicatotTo:view withMessage:NSLocalizedString(@"UPLOADING",@"Uploading")];
//    
//    NSString *uuid = nil;
//    CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
//    if (theUUID) 
//    {
//        uuid = NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID));
//        [uuid autorelease];
//        CFRelease(theUUID);
//    }
//    else
//    {
//        NSLog(@"FileName is nil");
//    }
//    
//    
//    //NSLog(@"UUID:%@",uuid);
//    
//	/*
//	 turning the image into a NSData object
//	 setting the quality to 90
//     */
//	NSData *imageData = UIImageJPEGRepresentation(image, 90);
//	// setting up the URL to post to
//	NSString *urlString = @"http://photoandvideoapps.com/test-upload.php";
//	
//	// setting up the request object now
//	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
//	[request setURL:[NSURL URLWithString:urlString]];
//	[request setHTTPMethod:@"POST"];
//	
//	/*
//	 add some header info now
//	 we always need a boundary when we post a file
//	 also we need to set the content type
//	 
//	 You might want to generate a random boundary.. this is just the same 
//	 as my output from wireshark on a valid html post
//     */
//	//NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//	
//	/*
//	 now lets create the body of the post
//     */
//	NSMutableData *body = [NSMutableData data];
//	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
//	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",uuid] dataUsingEncoding:NSUTF8StringEncoding]];
//	//[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[NSData dataWithData:imageData]];
//	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//	// setting the body of the post to the reqeust
//	[request setHTTPBody:body];
//	
//	// now lets make the connection to the web
//    NSError *error = nil;
//    NSURLResponse *res = nil;
//	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
//    if(nil != error)
//    {
//        NSLog(@"Error: %@",[error localizedDescription]);
//        return nil;
//    }
//    
//    if(nil != res)
//    {
//        //NSLog(@"Response: %@",[res URL]);
//    }
//    
//	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//	
//	NSLog(@"upload Image To Our Server result: %@",returnString);
//    
//    return returnString;
//}

//-(void)uploadToGlobalWallInMainThread
//{
//    /*
//    NSString *imgPath = [self uploadImageToOurServer:[self getTheSnapshot]];
//
//    FacebookUser *puser = [[FacebookUser alloc]init];
//
//    puser.imgDelegate   = self;
//
//    [puser postOnAppsWallUsingImage:imgPath messag:msg];
//    */
//    return;
//}

//-(void)uploadToUserWallInMainThread
//{
//    /*
//    NSString *imgPath = [self uploadImageToOurServer:[self getTheSnapshot]];
//
//    FacebookUser *puser = [[FacebookUser alloc]init];
//
//    puser.imgDelegate   = self;
//
//    [puser postOnUserWallUsingImage:imgPath messag:msg];
//    */
//    }

//-(void)uploadToGlobalWall
//{
//    [self performSelectorOnMainThread:@selector(uploadToGlobalWallInMainThread) withObject:nil waitUntilDone:NO];
//    
//    return;
//}
//
//-(void)uploadToUserWall
//{
//    [self performSelectorOnMainThread:@selector(uploadToUserWallInMainThread) withObject:nil waitUntilDone:NO];
//    
//    return;
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    /*
//    if(YES == [[alertView title] isEqualToString:NSLocalizedString(@"FBUPLOAD",@"Facebook Upload")])
//    {
//        if(NO == bAlreadyLiked)
//        {
//            if(buttonIndex == 1)
//            {
//                [self showLikeButton];
//                
//                bAlreadyLiked = YES;
//                [self updateAlreadyLiked];
//                return;
//            }
//        }
//        
//        [self release];
//    }
//    else */if(YES == [[alertView title] isEqualToString:NSLocalizedString(@"ADDCAPTION",@"Add Photo Caption")])
//    {
//        if(buttonIndex == 1)
//        {
//            msg = textField.text;
//         //   [msg retain];
//            
//            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(uploadToUserWall) userInfo:nil repeats:NO];
//        }
//        
//        [textField removeFromSuperview];
//    }
//    else
//    {
//       //[self release];
//    }
//}

-(void)getTheCaptionAndUploadToGlobalWall
{
    /*UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Add Photo Caption" 
                                                     message:@"\n\n\n" // IMPORTANT
                                                    delegate:nil 
                                           cancelButtonTitle:@"Cancel" 
                                           otherButtonTitles:@"OK", nil];*/
//    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADDCAPTION",@"Add Photo Caption")
//                                                     message:@"\n\n\n" // IMPORTANT
//                                                    delegate:nil 
//                                           cancelButtonTitle:NSLocalizedString(@"CANCEL",@"Cancel") 
//                                           otherButtonTitles:NSLocalizedString(@"OK",@"OK"), nil];
//    
//    prompt.delegate = self;
//    textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 50.0)]; 
//    [textField setBackgroundColor:[UIColor whiteColor]];
//    [textField setPlaceholder:NSLocalizedString(@"CAPTION",@"caption")];
//    [prompt addSubview:textField];
//    
//    // set place
//    [prompt setTransform:CGAffineTransformMakeTranslation(0.0, 10.0)];
//    //[prompt setTransform:CGAffineTransformMakeScale(0.0,-20.0)];
//    [prompt show];
   // [prompt release];
   // [textField release];
    
    // set cursor and show keyboard
//    [textField becomeFirstResponder];
    
    return;
}

- (void)loginStatus:(BOOL)isSuccess
{
    if(isSuccess)
    {
        [self getTheCaptionAndUploadToGlobalWall];
    }
    
    return;
}
-(void)uploadToInstagram
{
    UIImage *pImage = [self getTheSnapshot];
    if(nil == pImage)
    {
        NSLog(@"Image is nil");
    }
    /* First Save the Image to documents directory
     1. Generate the path to save the file*/
    NSString *pathToSave = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/captions1.ig"];
    
    /* 2. Save the file */
    [UIImageJPEGRepresentation(pImage, 1.0) writeToFile:pathToSave atomically:YES];
    
    /* Verify if the instagram app is installed */
    NSURL *instagramUrl = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication]canOpenURL:instagramUrl])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:uploaddone object:nil];
        documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:pathToSave]];//retain];
        NSString *caption = [NSString stringWithFormat:@"#VideoCollage, Created using @VideoCollage free iphone app"];
        documentInteractionController.UTI = @"com.instagram.photo";
        documentInteractionController.delegate = self;
        documentInteractionController.annotation = [NSDictionary dictionaryWithObject:caption forKey:@"InstagramCaption"];
        [documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:uploaddone object:nil];
        
        [WCAlertView showAlertWithTitle:@"Failed"
                                message:@"Instagram is not installed in your device. You need to install Instagram application to share your image with Instagram. Would you like to download it now?"
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
         {
             if(buttonIndex == 1)
             {
                 //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/instagram/id389801252?mt=8"]];
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/instagram/id389801252?mt=8"] options:@{} completionHandler:nil];
             }
         }
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Download", nil];
        
    }

}
- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application
{
    //[documentInteractionController release];
    documentInteractionController = nil;
}
-(void)uploadToEmail
{
   // NSAutoreleasePool *localPool     = [[NSAutoreleasePool alloc] init];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        /* We must always check whether the current device is configured for sending emails */
        if ([mailClass canSendMail])
        {
            if (viewController) {
                 NSLog(@"((((((((((()))))))))))");
            }
           
            NSString *appUrl = ituneslinktoApp;
            NSString *yoziohyperlink = [NSString stringWithFormat:
                                        @"<a href=\"%@\" target=\"itunes_store\">%@</a>",appUrl,appname];
            NSString *websiteLink    = [NSString stringWithFormat:
                                        @"<a href=\"%@\" target=\"www.videocollageapp.com \">%@</a>",appUrl,@"www.videocollageapp.com "];
            NSString *emailBody = [NSString stringWithFormat:@"Made with iphone application - %@. Download it from %@ \n",yoziohyperlink,websiteLink];
            
            NSString *emailSubject = [NSString stringWithFormat:@"From %@ iphone application",appname];
            
            /* Compose the email */
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate          = self;
            [picker setSubject:emailSubject];
            
            /* Set the model transition style */
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            /* Attach an image to the email */
            //[picker addAttachmentData:UIImagePNGRepresentation([sess.frame renderToImageOfSize:nvm.uploadSize])
            //                 mimeType:@"image/png" fileName:@"PicShells"];
            [picker addAttachmentData:UIImageJPEGRepresentation([self getTheSnapshot],1.0)
                             mimeType:@"image/jpeg" fileName:@"PicShells"];
            
            /* Fill out the email body text */
            [picker setMessageBody:emailBody isHTML:YES];
            
            /* Present the email compose view to the user */
           // [viewController presentModalViewController:picker animated:YES];
            [viewController presentViewController:picker animated:YES completion:nil];

            /* Free the resources */
      //      [picker release];
        }
        else
        {
            [WCAlertView showAlertWithTitle:NSLocalizedString(@"EMAIL",@"Email")
                                    message:NSLocalizedString(@"NOEMAIL",@"Email is not configured for this device!!!")
                         customizationBlock:nil
                            completionBlock:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
        }
        
        /* Free the mailclass object */
       // [mailClass release];
    }
    
  //  [localPool release];
    
    return;

}
-(void)upload
{
    nvm = [Settings Instance];
    
    [self initAlreadyLiked];
    [self initTwitterCredentials];
  
    switch(nvm.uploadCommand)
    {
        case UPLOAD_PHOTO_ALBUM:
        {
            [self uploadToPhotoAlbum];
            break;
        }           
        case UPLOAD_FACEBOOK_ALBUM:
        {
            [self uploadToFacebook];
            break;
        }
        case UPLOAD_EMAIL:
        {
            if (NO == nvm.connectedToInternet) {
                [WCAlertView showAlertWithTitle:@"Failed!!" message:@"Currently your device is not connected to internet. To share image by email , first you need to connect to intenet" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                return;
            }
            else
            {
            [self uploadToEmail];
            }
            break;
        }
        case UPLOAD_INSTAGRAM:
        {
            [self uploadToInstagram];
            break;
        }
#if TWITTER_SUPPORT_ENABLED
        case UPLOAD_TWITTER:
        {
            [self uploadToTwitpic];
            break;
        }
#endif
        case UPLOAD_CLIPBOARD:
        {
            [self copyToClipboard];
            break;
        }
        default:
        {
            break;
        }
    }

}

/*Deligate methods of FBSDKShare Dialogs created by Rajesh Kumar*/
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
@end
