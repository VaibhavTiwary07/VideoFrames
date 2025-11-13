//
//  ImageSelectionHandler.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/18/12.
//
//

#import "ImageSelectionHandler.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/CALayer.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface ImageSelectionHandler()<CTAssetsPickerControllerDelegate>
{
    id _controller;
    PHImageRequestOptions  *requestOptions;
    int maximum_NumberOf_Image;
    PHVideoRequestOptions *videoRequestOptions;
    PHFetchOptions *videoFetchOptions;
    BOOL imageGotDownloaded;
    Reachability *internetReach;
    PHAccessLevel accessLevel;
}
@property (nonatomic, retain) NSMutableArray *assets_array;

//@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
//@property (nonatomic, strong) ALAsset *asset;

@property(nonatomic   , assign) BOOL isVideoFile;

//PHAsset
@property (nonatomic, strong) PHAsset *asset1;


@end

@implementation ImageSelectionHandler

-(id)initWithViewController:(id)controller
{
    self = [super init];
    if(self)
    {
        _controller = controller;
        nvm = [Settings Instance];
        internetReach = [Reachability reachabilityForInternetConnection] ;
        [internetReach startNotifier];
        requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.networkAccessAllowed = YES;
        
        videoRequestOptions = [[PHVideoRequestOptions alloc]init];
        videoRequestOptions.networkAccessAllowed = YES;
        videoRequestOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        videoFetchOptions = [PHFetchOptions new];
        videoFetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeVideo];
       
        
    }
    
    return self;
}

-(void)videoSelected:(NSURL*)videoPath result:(NSString*)res
//-(void)videoSelected:(NSURL*)videoPath result:(NSString*)res

{
    if(nil != videoPath)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@" Video path not nil %@",videoPath);
            NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:videoPath forKey:backgroundVideoSelected];
            [[NSNotificationCenter defaultCenter] postNotificationName:backgroundVideoSelected object:nil userInfo:usrInfo];
            if([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad)
            {
        
            [[_controller navigationController] popToViewController:_controller animated:NO];//---Existing one
            }
        });
        
    }
    else
    {
        NSLog(@" Video path  nil------");
        if(nil != res)
        {
            [self ShowAlert:NSLocalizedString(@"FAILED",@"Failed") message:res];
        }
    }
    
   // [self release];
}

-(void)imageSelected:(NSMutableArray *)imgArray result:(NSString*)res
{
    NSLog(@"image Selected =========  %ld",imgArray.count);
    if(0 != imgArray.count)
    {
        NSLog(@"image Selected %ld",imgArray.count);
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:imgArray forKey:@"backgroundImageSelected"];
            [[NSNotificationCenter defaultCenter] postNotificationName:backgroundImageSelected object:nil userInfo:usrInfo];
            if([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad)
            {
               //  [[_controller navigationController] popToRootViewControllerAnimated:NO];
              //  [_controller dismissViewControllerAnimated:NO completion:nil]; //kasaram
                if (@available(iOS 14, *))
                {
                    NSLog(@"14 and above after image selcted move to viewcontroller");
                   
                    [[_controller navigationController] popToViewController:_controller animated:NO];//Existing one //kasaram
                }
                else
                {
                    NSLog(@"14 below after image selcted move to viewcontroller");

                    [[_controller navigationController] popToViewController:_controller animated:NO];//Existing one
                }
              
                
            }
        });
        
    }
    else
    {
        if(nil != res)
        {
            [self ShowAlert:NSLocalizedString(@"FAILED",@"Failed") message:res];
        }
    }
    
    /*  if(nil != img)
     {
     NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:img forKey:@"backgroundImageSelected"];
     [[NSNotificationCenter defaultCenter] postNotificationName:backgroundImageSelected object:nil userInfo:usrInfo];
     if([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad)
     {
     // [[_controller navigationController] popToRootViewControllerAnimated:NO];
     [[_controller navigationController] popToViewController:_controller animated:NO];
     }
     }
     else
     {
     if(nil != res)
     {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FAILED",@"Failed") message:res delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
     [alert show];
     [alert release];
     }
     }*/
    
   // [self release];
}



-(void)handleVideoAlbum
{
   // NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {

        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        
        /* Set the source type */
        imgPicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
        
        /* Do not allow editing */
        //imgPicker.allowsEditing = NO;
        
        /* Set th delegate for the picker view */
//        imgPicker.delegate = self;
        
        //[imgPicker setVideoMaximumDuration:30.0];
        //[imgPicker setVideoQuality:UIImagePickerControllerQualityTypeLow];
        
        /* Set the model transition style */
//        imgPicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        imgPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)UTTypeMovie,nil];
        
        [_controller presentViewController:imgPicker animated:YES completion:NULL];
        
        /* Release the image picker */
    //    [imgPicker release];
        }
    //}
    else
    {
        [self ShowAlert:@"Photo Library" message:@"Photo Library is not available to pick the background!!!"];
    }
    //[localPool release];
    return;
}

-(void)ShowAlert:(NSString*)title message:(NSString*)msg
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"OK") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
  
    [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(void)handleCamera
{
//    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        /* Allocate the picker view */
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        /* Set the source type */
        imgPicker.sourceType    = UIImagePickerControllerSourceTypeCamera;
        /* Do not allow editing */
        imgPicker.allowsEditing = NO;
        /* Set th delegate for the picker view */
//        imgPicker.delegate = self;
        /* Set the model transition style */
        imgPicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        /* present the picker */
//        [_controller presentModalViewController:imgPicker animated:YES];
        [_controller presentViewController:imgPicker animated:YES completion:nil];

        /* Release the image picker */
    //    [imgPicker release];
    }
    //[localPool release];
    return;
}

-(void)pickImage:(int)maximumNumberOfImage
{
  
    Videoselection = NO;
    Imageselection = YES;
    
    if (self.assets_array == nil) {
        NSLog(@"new asset selected");
        self.assets_array = [[NSMutableArray alloc] init];
    }
    maximum_NumberOf_Image = maximumNumberOfImage;
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.showsSelectionIndex = YES;
            picker.delegate = self;
            
           picker.modalPresentationStyle = UIModalPresentationFullScreen;
            
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
            /// assign options
            picker.assetsFetchOptions = fetchOptions;
            //dispatch_async(dispatch_get_main_queue(), ^{
                [_controller presentViewController:picker animated:YES completion:nil];
           // });
    NSLog(@"assetsPickerController opens photos library");
    });
//}];
}

-(void)pickVideo
{
    dispatch_async(dispatch_get_main_queue(), ^{
    maximum_NumberOf_Image = 1;

    @autoreleasepool {
            Imageselection = NO;
            Videoselection = YES;
            if (self.asset1== nil) {
                NSLog(@"new pick Video2 asset selected");
                //here leak is there 15 %
                self.assets_array = [[NSMutableArray alloc] init];
            }
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.showsSelectionIndex = YES;
            picker.delegate = self;
        
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        
            /// create options for fetching photo only
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeVideo];
            /// assign options
            picker.assetsFetchOptions = fetchOptions;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_controller presentViewController:picker animated:YES completion:nil];
        });
        }
    });
}

-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldHighlightAsset:(PHAsset *)asset
{
    NSLog(@"assetsPickerController should Highlight Asset");
    return true;
}

-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldDeselectAsset:(PHAsset *)asset
{
    NSLog(@"assetsPickerController should Deselect Asset");
    return true;
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(PHAsset *)asset
{
    NSLog(@"assetsPickerController should Enable Asset");
   if(asset.mediaType != PHAssetMediaTypeImage)
   {
       NSLog(@"asset.mediaType is PHAssetMediaTypeImage ");
   }
      // asset.isHidden;
     return !asset.isHidden;
}

// implement should select asset delegate
-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSLog(@"assetsPickerController should Select Asset");
    NSInteger max = maximum_NumberOf_Image;
    NSLog(@"shouldSelectAsset %ld",max);
    // show alert gracefully
    if (picker.selectedAssets.count >= max)
    {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Attention"
                                            message:[NSString stringWithFormat:@"Please select not more than %ld assets", (long)max]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action =
        [UIAlertAction actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
        
        [alert addAction:action];
        
        [picker presentViewController:alert animated:YES completion:nil];
    }
    
    // limit selection to max
    return (picker.selectedAssets.count < max);
}

-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    imageGotDownloaded = NO;
    NSLog(@"assetsPickerController did Finish Picking Assets");
    NSLog(@"Asset count is %lu",(unsigned long)assets.count);
    if ([assets count]==0) {
        [[SRSubscriptionModel shareKit]ShowAlert:@"No Item Selected" message:@"Currently no image selected."];
        return;
    }
    PHImageManager *manager = [PHImageManager defaultManager];
    if (Videoselection) {
        picker.title = @"VideoPicker";
    } else
    {
        picker.title = @"PhotoPicker";
    }
    NSLog(@" !!!!!!!!!!!!  %@ ******",picker.title);
    
    if ([picker.title isEqualToString:@"VideoPicker"])
    {
        [LoadingClass addActivityIndicatotTo:picker.view withMessage:@""];
        internetReach = [Reachability reachabilityForInternetConnection];
        PHAsset *selectedVideo = [assets firstObject];
//        for (PHAsset *selectedVideo in assets) {
            NSLog(@"PHAsset description %lu ",selectedVideo.sourceType);
            if(selectedVideo.sourceType == PHAssetSourceTypeNone)
            {
                NSLog(@"PHAsset PHAssetSourceTypeNone");
            }else if(selectedVideo.sourceType == PHAssetSourceTypeCloudShared || selectedVideo.sourceType == PHAssetSourceTypeiTunesSynced)
            {
                if([internetReach currentReachabilityStatus] == NotReachable)
                {
                    [LoadingClass removeActivityIndicatorFrom:picker.view];
                    UIAlertController *alert =
                    [UIAlertController alertControllerWithTitle:@"No Internet"message:@"Check your internet connection!!!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {[picker dismissViewControllerAnimated:YES completion:nil];}];
                    [alert addAction:action];
                    [picker dismissViewControllerAnimated:YES completion:nil];
                    [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                    return;
                }
            }else if(selectedVideo.sourceType == PHAssetSourceTypeUserLibrary)
            {
                NSLog(@"PHAsset PHAssetSourceTypeUserLibrary");
            }
        NSLog(@"identifier =====> %@ location ======> %@",selectedVideo.localIdentifier,selectedVideo.location);
        [manager requestAVAssetForVideo:selectedVideo options:videoRequestOptions resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info)
         {
            NSLog(@"avasset before -----  %@",avAsset);
            if(avAsset == nil)
            {
                NSLog(@"Failed to retrieve AVAsset. Info: %@", info);
                NSLog(@"Cloudn't download avAsset");
                dispatch_async(dispatch_get_main_queue(), ^{
                        [LoadingClass removeActivityIndicatorFrom:picker.view];
                        UIAlertController *alert =
                        [UIAlertController alertControllerWithTitle:@"Video not found"message:@"Could not download video!!!" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {[picker dismissViewControllerAnimated:YES completion:nil];}];
                        [alert addAction:action];
                        [picker dismissViewControllerAnimated:YES completion:nil];
                        [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                });
            }
            
            else {
                if ([avAsset isKindOfClass:[AVURLAsset class]]) {
                    AVURLAsset* myAsset = (AVURLAsset*)avAsset;
                    // __block  NSURL *url = myAsset.URL;
                    NSURL *usingVideourl = myAsset.URL;
                    NSString *urlString = [usingVideourl absoluteString];
                    NSLog(@"avasset %@",avAsset);
                    NSLog(@"asset info %@",info);
                    NSLog(@"url %@",usingVideourl);
                    NSLog(@"url absoluteString %@",usingVideourl);
                    NSLog(@"url relativePath %@",[usingVideourl relativePath]);
                    NSLog(@"string contains .medium %@",urlString);
                    NSLog(@"video in cloud");
                    NSData * data = [NSData dataWithContentsOfFile:myAsset.URL.relativePath];
                    if (data) {
                        NSLog(@"Got file content %ld",data.length);
                        NSString *filePath = [myAsset.URL.fileReferenceURL absoluteString] ;
                        NSString* fileExt = myAsset.URL.pathExtension;  //[[usingVideourl absoluteString]lastPathComponent];
                        NSLog(@"last path component %@",myAsset.URL.pathExtension);
                        if ([fileExt length] > 0) {
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
                            NSString *documentsDirectory = [paths objectAtIndex:0] ;
                            NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"temp.%@",fileExt]] ;
                            NSError *error = nil ;
                            NSLog(@"file path %@",localFilePath);
                            if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath])
                            {
                                [[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];
                            }
                            // [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:localFilePath error:&error];
                            //                                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSLog(@"Got file content ...... %ld",data.length);
                            bool Success=  [data writeToFile:localFilePath atomically:YES];
                            if (Success) {
                                NSLog(@"Video Saved---in doc");
                                usingVideourl = [NSURL fileURLWithPath:localFilePath];
                                NSLog(@"Video old path is----%@",filePath);
                                NSLog(@"Video new path is----%@",localFilePath);
                            }
                            else
                            {
                                usingVideourl = nil;
                                NSLog(@"Video failed---in doc %@",error.localizedDescription);
                            }
                            //                                   });
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"1111 URL is %@",usingVideourl);
                        //            if(url != nil){
                        NSLog(@"2222 URL is %@",usingVideourl);
                        NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:usingVideourl forKey:backgroundVideoSelected];
                        [[NSNotificationCenter defaultCenter] postNotificationName:backgroundVideoSelected object:nil userInfo:usrInfo];
                        [picker dismissViewControllerAnimated:NO completion:^{
                            //[self showInterstitial];//commented//
                        }];
                        NSLog(@"movie $$$$$$$$$$ ----3");
                    });
                    
                }
                else if ([avAsset isKindOfClass:[AVComposition class]]) {
                    
                    // It's a slow-motion video; export to a temp file
                           AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
                           
                        NSString *outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"exported.mov"];
                        NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:[outputURL path]]) {
                        NSError *removeError = nil;
                        [[NSFileManager defaultManager] removeItemAtURL:outputURL error:&removeError];
                        if (removeError) {
                            NSLog(@"Error removing file at URL: %@", removeError.localizedDescription);
                        }
                    }
                           exportSession.outputURL = outputURL;
                           exportSession.outputFileType = AVFileTypeQuickTimeMovie;
                           
                           [exportSession exportAsynchronouslyWithCompletionHandler:^{
                               if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                                   NSLog(@"Exported video at: %@", outputURL);
                                   // Use outputURL
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"1111 URL is %@",outputURL);
                                       NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:outputURL forKey:backgroundVideoSelected];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:backgroundVideoSelected object:nil userInfo:usrInfo];
                                       [picker dismissViewControllerAnimated:NO completion:^{
                    
                                       }];
                                       NSLog(@"slow motion movie $$$$$$ ----3");
                                   });
                               } else {
                                   NSLog(@"Export failed: %@", exportSession.error);
                                   [LoadingClass removeActivityIndicatorFrom:picker.view];
                                   NSLog(@"Cloudn't download video");
                                   UIAlertController *alert =
                                   [UIAlertController alertControllerWithTitle:@"Failed!!!" message:@"Failed to import video!!!" preferredStyle:UIAlertControllerStyleAlert];
                                   UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault
                                                                            handler:^(UIAlertAction * _Nonnull action) {[picker dismissViewControllerAnimated:YES completion:nil];}];
                                   [alert addAction:action];
                                   [picker dismissViewControllerAnimated:YES completion:nil];
                                   [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                               }
                           }];
                }
        }
        }];
    }else
    {
        if ([picker.title isEqualToString:@"PhotoPicker"])
          {
              __block NSData *iData = nil;
              __block UIImage *image = nil;
              
              [LoadingClass addActivityIndicatotTo:picker.view withMessage:@""];
              internetReach = [Reachability reachabilityForInternetConnection];
              for (PHAsset *selectedImage in assets) {
                  NSLog(@"PHAsset description %lu ",selectedImage.sourceType);
                  if(selectedImage.sourceType == PHAssetSourceTypeNone)
                  {
                      NSLog(@"PHAsset PHAssetSourceTypeNone");
                      requestOptions.synchronous = NO;
                  }else if(selectedImage.sourceType == PHAssetSourceTypeCloudShared || selectedImage.sourceType == PHAssetSourceTypeiTunesSynced)
                  {
                      if([internetReach currentReachabilityStatus] == NotReachable)
                      {
                          [LoadingClass removeActivityIndicatorFrom:picker.view];
                          UIAlertController *alert =
                          [UIAlertController alertControllerWithTitle:@"No Internet"message:@"Check your internet connection!!!" preferredStyle:UIAlertControllerStyleAlert];
                          UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {[picker dismissViewControllerAnimated:YES completion:nil];}];
                          [alert addAction:action];
                          [picker dismissViewControllerAnimated:YES completion:nil];
                          [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                          return;
                      }
                  }else if(selectedImage.sourceType == PHAssetSourceTypeUserLibrary)
                  {
                      NSLog(@"PHAsset PHAssetSourceTypeUserLibrary");
                      if([internetReach currentReachabilityStatus] == NotReachable)
                          requestOptions.synchronous = YES;
                      else requestOptions.synchronous = NO;
                  }
                  NSLog(@"image source type %lu", selectedImage.sourceType);
                  [manager requestImageDataAndOrientationForAsset:selectedImage
                    options:requestOptions resultHandler:^(NSData *imageData, NSString *dataUTI, CGImagePropertyOrientation orientation, NSDictionary *info) {
                      NSLog(@"image info %@",info);
                      NSLog(@"image data uti %@",dataUTI);
                      iData = [imageData copy];
                      if(iData.length > 0){
                          NSLog(@"requestImageDataForAsset returned info(%@)", info);
                          image = [UIImage imageWithData:iData];
                          NSLog(@"image height is %f",image.size.height);
                          [self.assets_array addObject:image];
                          if(assets.count == self.assets_array.count)
                          {
                              imageGotDownloaded = YES;
                              [LoadingClass removeActivityIndicatorFrom:picker.view];
                              NSLog(@"All images got downloaded");
                              NSLog(@"assets_array count %ld",self.assets_array.count);
                              [self imageSelected:self.assets_array result:nil];
                        //      [self.asset1 release];
                              [picker dismissViewControllerAnimated:NO completion:^{
                                 // [self showInterstitial]; //commented//
                              }];
                              self.asset1 = nil;
                          }
                          NSLog(@"Size of image = %f ",image.size.width);
                      }
                      else
                      {
                          if([internetReach currentReachabilityStatus] == NotReachable )
                          {
                              [LoadingClass removeActivityIndicatorFrom:picker.view];
                              NSLog(@"No internet connection");
                              UIAlertController *alert =
                              [UIAlertController alertControllerWithTitle:@"No Internet"message:@"Do not have internet connection !!!" preferredStyle:UIAlertControllerStyleAlert];
                              UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * _Nonnull action) {[picker dismissViewControllerAnimated:YES completion:nil];}];
                              [alert addAction:action];
                              [picker dismissViewControllerAnimated:YES completion:nil];
                              [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                          }
                          else
                          {
                              [LoadingClass removeActivityIndicatorFrom:picker.view];
                              NSLog(@"Cloudn't download image");
                              UIAlertController *alert =
                              [UIAlertController alertControllerWithTitle:@"Image not found!!!"message:@"Could not download image!!!" preferredStyle:UIAlertControllerStyleAlert];
                              UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * _Nonnull action) {[picker dismissViewControllerAnimated:YES completion:nil];}];
                              [alert addAction:action];
                              [picker dismissViewControllerAnimated:YES completion:nil];
                              [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                          }
                      }
                }];
            }
        }
    }
    
    
}


-(void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
    NSLog(@"assetsPickerController did cancle Picking Assets");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)assetsPickerController:(CTAssetsPickerController *)picker didSelectAsset:(PHAsset *)asset
{
    NSLog(@"assetsPickerController did select Picking Assets");
}

-(void)exportingURL:(NSURL*)exportURL
{
    AVAsset *asset2      = [AVURLAsset URLAssetWithURL:exportURL options:nil];

    AVAssetExportSession *session =
    [AVAssetExportSession exportSessionWithAsset:asset2 presetName:AVAssetExportPresetLowQuality];

    session.outputFileType  = AVFileTypeQuickTimeMovie;
    session.outputURL       = exportURL;

    [session exportAsynchronouslyWithCompletionHandler:^{

        if (session.status == AVAssetExportSessionStatusCompleted)
        {
            NSData *data    = [NSData dataWithContentsOfURL:session.outputURL];
            NSLog(@"Video after export is----%@",data);
        }

    }];
}


-(NSURL*)createVideoCopyFromReferenceUrl:(NSURL*)inputUrlFromVideoPicker{

        NSURL __block *videoURL;
    
//        PHFetchResult *phAssetFetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[inputUrlFromVideoPicker] options:nil];
    PHFetchResult *phAssetFetchResult = [PHAsset fetchAssetsWithOptions:nil];
        NSLog(@"1----------");
        PHAsset *phAsset = [phAssetFetchResult firstObject];
        NSLog(@"2----------");
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
    NSLog(@"3----------");

        [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:nil resultHandler:^(id asset, AVAudioMix *audioMix, NSDictionary *info) {
            NSLog(@"4----------");

            if ([asset isKindOfClass:[AVURLAsset class]]) {
                
                NSLog(@"5----------");
                NSURL *url = [(AVURLAsset *)asset URL];
                
                NSLog(@"Final URL %@",url);
                NSData *videoData = [NSData dataWithContentsOfURL:url];

                // optionally, write the video to the temp directory
                NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.mp4",[NSDate timeIntervalSinceReferenceDate]]];

                videoURL = [NSURL fileURLWithPath:videoPath];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL writeResult = [videoData writeToURL:videoURL atomically:true];

                if(writeResult) {
                    NSLog(@"video success");
                }
                else {
                    NSLog(@"video failure");
                }
//                });
                 dispatch_group_leave(group);
                // use URL to get file content
            }
        }];
        dispatch_group_wait(group,  DISPATCH_TIME_FOREVER);
        return videoURL;
}






-(void)checkingVideoURL
{
   
    
    dispatch_async(dispatch_get_main_queue(), ^{
    shareView = [[ShareViewController alloc] init];
   
        _isVideoFile  = YES;
        shareView . frameSize = frame_size;
       
    
     //   pickerPATH = [pickerURL absoluteString];
        shareView . videoPath = localFilePath;
        NSLog(@"player path is %@",localFilePath);
        //shareView . videoPath = [sess pathToCurrentVideo];
        shareView . sess = sess;
           // shareView.SharingURL =
        shareView . isVideo = _isVideoFile;
   // [_controller pushViewController:shareView animated:NO];
        [_controller presentViewController:shareView animated:NO completion:nil];
        
    });
        //[self.view addSubview:shareView.view];
}



- (void)showInterstitial {
    NSLog(@"show ad");
    if (![[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
      if (self.interstitial) {
          NSLog(@"showing ad");
        [self.interstitial presentFromRootViewController:_controller];
      } else {
        NSLog(@"Ad wasn't ready");
      }
    }else NSLog(@"Ads are purchased");
}

- (void)adDidPresentFullScreenContent:(id)ad {
  NSLog(@"Ad did present full screen content.");
}

- (void)ad:(id)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
  NSLog(@"Ad failed to present full screen content with error %@.", [error localizedDescription]);
}

- (void)adDidDismissFullScreenContent:(id)ad {
  NSLog(@"Ad did dismiss full screen content.");
    
  
}

- (void)loadInterstitial {
  GADRequest *request = [GADRequest request];
    //ca-app-pub-3940256099942544/4411468910
    //fullscreen_admob_id
  [GADInterstitialAd
       loadWithAdUnitID:fullscreen_admob_id
                request:request
      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
          NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
          return;
        }
      self.interstitial = ad;
      self.interstitial.fullScreenContentDelegate = self;
      }];
}


@end

