//
//  ViewController.m
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Config.h"
#import "KxMenu.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/CALayer.h>
#import "OT_TabBar.h"
#import "VideoUploadHandler.h"
#import <GoogleMobileAds/GADBannerView.h>
#import "configparser.h"
#import "VideoSettings.h"
#import <MediaPlayer/MediaPlayer.h>
#import "InAppPurchasePreview.h"
#import "FTWButton.h"
#import "CMPopTipView.h"
#import "VideoSettingsController.h"
#import "HelpScreenViewController.h"
#import "VideoGridViewViewController.h"
#import "CTAssetsPickerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Effects.h"
#import "ShareViewController.h"

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)



@interface ViewController () <KxMenuDelegate,OT_TabBarDelegate,UIPopoverControllerDelegate,PopoverViewDelegate,AVAudioPlayerDelegate,MPMediaPickerControllerDelegate,InAppPurchasePreviewViewDelegate,CTAssetsPickerControllerDelegate>
{
    eAppMode eMode;
    UIView  *pickerView;
    
    /* Needs to delete */
    Frame *frm;
    Session *sess;
    
    /* Aspect Ratios and sizes
     1:1 -> 300:300
     3:2 -> 300:200
     4:3 -> 300:225
     3:4 -> 225:300
     */
    UIPopoverController *uploadPopover;
    UIPopoverController *backgroundPopover;
    UIPopoverController *photoAlbumPopover;
    
    SNPopupView *aspectRatioView;
    SNPopupView *sliders;
    SNPopupView *colorAndPatternView;
    
    BOOL _editWhileImageSelection;
    //UIImage *_selectedImageBeforeEdit;dsl;vjsl;dighsl;idfh
    UIButton *_appoxeeBadge;
    
    BOOL isInEditMode;
    UIView *curPopupViewParent;
    OT_TabBar *customTabBar;
    PopoverView *popOver;
    //GADBannerView *bannerView_;
    
    /* Video Preview Global Vars */
    BOOL gIsPreviewInProgress; //asdasdfsdfsdf
    BOOL gIsPreviewPaused;
    int  gCurPreviewFrameIndex; //sdfbljsdfbksjdbg
    int  gTotalPreviewFrames;
    int  gPreviewFrameCounterVariable;
    AVAudioPlayer *previewAudioPlayer;
    CMPopTipView *preViewControls;
    UISlider *previewAdjSlider;
    UILabel *previewTimeLabel;
    
    /* Add music */
    UIView *musicTrackCell;
    
    BOOL isSequentialPlay;
    
    PopupMenu *menu ;
    HelpScreenViewController  *helpScreen;
    NSMutableDictionary *dictionary, *dictionaryOfEffectInfo;
    VideoGridViewViewController *gridView;
    
    bool  isEffectEnabled;
    
    //    GADInterstitial *interstitial_; //fgthfjufghjghjk
    
}

-(void)selectEditTab;
    //@property (nonatomic, assign)bool isVideoOrderChangedByUser;
@property(nonatomic   , assign) BOOL isVideoFile;
@property (nonatomic  , assign) BOOL isTouchWillDetect;
@property (nonatomic  , assign) int videoTimeRange;
@property (nonatomic  , assign) int initialPhotoIndex;
@property (nonatomic , retain) NSMutableArray *videoImageInfo;
@property (nonatomic , retain) NSMutableArray *orderArrayForVideoItems;
@property (nonatomic  , assign) int counterVariable;
@property (nonatomic , assign) int currentSelectedPhotoNumberForEffect;



@end

@implementation ViewController
    //@synthesize isVideoOrderChangedByUser;
@synthesize videoTimeRange;
@synthesize isVideoFile;
@synthesize isTouchWillDetect;
@synthesize tabBar;
@synthesize imageForEdit;
@synthesize applicationSuspended;
@synthesize initialPhotoIndex;
@synthesize videoImageInfo;
@synthesize orderArrayForVideoItems;
@synthesize counterVariable;
@synthesize  currentSelectedPhotoNumberForEffect;
#pragma mark image editing

- (void)doneWithPhotoEffectsEditor:(NSTimer*)t
{
    UIImage *img = [t.userInfo objectForKey:@"image"];
    
    if(nil == img)
    {
        return;
    }
    
    [sess imageSelectedForPhoto:img];
}
#if SHAPE_CHAGING_SUPPORT
- (int)numberOfItemsInSqwController:(sgwController*)sender
{
    return [ShapeMapping shapeCount];
}

- (NSString*)sgwController:(sgwController*)sender titleForTheItemAtIndex:(int)index
{
    return [ShapeMapping nameOfTheShapeAtIndex:index];
}

- (UIImage*)sgwController:(sgwController*)sender imageForTheItemAtIndex:(int)index
{
    return [ssivView imageForShape:index];
}

- (void)sgwController:(sgwController*)sender itemDidSelectAtIndex:(int)index
{
    [sess shapePreviewSelectedForPhoto:index];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notification_sgwcontroller_updatepreview object:nil];
}

- (BOOL)sgwController:(sgwController*)sender isItemLockedAtIndex:(int)index
{
    return [ShapeMapping getLockStatusOfShape:index group:FRAME_SHAPE_GROUP_1];
}

- (void)sgwControllerDidCancel:(sgwController*)sender initialItem:(int)index
{
    [sess shapeSelectedForPhoto:index];
}

- (void)sgwController:(sgwController*)sender didDoneSelectingItemAtIndex:(int)index
{
    [sess shapeSelectedForPhoto:index];
}

- (UIImage*)previewImageForSgwController:(sgwController*)sender
{
    return [sess.frame renderToImageOfScale:2.0];
}

- (void)showShapes
{
    sgwController *sgw = [[sgwController alloc]initWithDelegate:self currentItem:[sess shapeOfCurrentlySelectedPhoto]];
    [self.navigationController presentModalViewController:sgw animated:NO];
    [sgw release];
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        sgw.backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"mainbackground_ipad" ofType:@"png"]];
    }
    else
    {
        sgw.backgroundView.image = [UIImage imageWithContentsOfFile:[Utility documentDirectoryPathForFile:@"mainbackground.jpg"]];
    }
}
#endif
#pragma mark imageselection
- (void)imageSelected:(UIImage *)img
{
    if(nil == img)
    {
        NSLog(@"Received invalid image from image selection");
        return;
    }
    
    [sess imageSelectedForPhoto:img];
    
    return;
}

- (int)numberOfItemsInPopupMenu:(PopupMenu*)sender
{
    return 3;
}

- (NSString*)popupMenu:(PopupMenu*)sender titleForItemAtIndex:(int)index
{
    NSString *title = nil;
    switch(index)
    {
        case 0:
        {
            title = @"SELECT PHOTO";
            break;
        }
        case 1:
        {
            title = @"SELECT VIDEO";
            break;
        }
        case 2:
        {
            title = @"REMOVE";
            break;
        }
    }
    
    return title;
}

- (BOOL)popupMenu:(PopupMenu *)sender isNewBadgeRequiredForItemAtIndex:(int)index;
{
    return NO;
}

- (BOOL)popupMenu:(PopupMenu*)sender enableStatusForItemAtIndex:(int)index
{
    BOOL val = NO;
    
    if((index <= 1)||(isInEditMode == YES))
    {
        val = YES;
    }
    
    return val;
}

- (UIImage*)popupMenu:(PopupMenu*)sender imageForItemAtIndex:(int)index
{
    if(index == 0)
    {
        return [UIImage imageNamed:@"malbum.png"];
    }
    else if(index == 1)
    {
        return [UIImage imageNamed:@"menucamera.png"];
    }
    else if(index == 2)
    {
        return [UIImage imageNamed:@"trash.png"];
    }
    
    return [UIImage imageNamed:@"mail1.png"];
}

- (void)popupMenuDidDismiss:(PopupMenu*)sender
{
   
}

- (void)popupMenu:(PopupMenu*)sender itemDidSelectAtIndex:(int)index
{
    ImageSelectionHandler *ish = [[ImageSelectionHandler alloc]initWithViewController:self];
    int maximumNumberOfImage = 0;
    
    for (int index= 0; index< sess.frame.photoCount; index++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:index ];
        if (pht.image == nil) {
            maximumNumberOfImage ++;
        }
        
    }
    Photo *currentSelectedPhoto = [sess.frame getPhotoAtIndex:sess.photoNumberOfCurrentSelectedPhoto];
    if (currentSelectedPhoto.image != nil ) {
        maximumNumberOfImage++;
    }
    
    switch(index)
    {
        case 0:
        {
            
            [ish pickImage:maximumNumberOfImage];
            
            break;
        }
        case 1:
        {
            if (freeVersion) {
               
                [WCAlertView showAlertWithTitle:@"Info"
                                        message:@"Maximum video length supported is 30 seconds. Videos bigger than 30 seconds will be automatically trimmed to first 30 seconds. To add Video more than 30 seconds download VideoCollage Pro app."
                             customizationBlock:nil
                                completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
                 {
                     if(buttonIndex == 0)
                     {
                         [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:@"optOutVideoHelp"];
                         [ish pickVideo];
                     }
                     if (buttonIndex == 1) {
                         [self openProApp];
                     }
                 }
                        cancelButtonTitle:@"Cancel"
                        otherButtonTitles:@"Open Pro",nil];
            }else
            {
                [WCAlertView showAlertWithTitle:@"Info"
                                        message:@"Maximum video length supported is 120 seconds. Videos bigger than 120 seconds will be automatically trimmed to first 120 seconds"
                             customizationBlock:nil
                                completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
                 {
                     if(buttonIndex == 0)
                     {
                         [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:@"optOutVideoHelp"];
                         [ish pickVideo];
                     }
                     
                 }
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,nil];
            }
            break;
        }
        case 2:
        {
            
            NSString *key     = [sess getVideoInfoKeyForPhotoAtIndex:sess.photoNumberOfCurrentSelectedPhoto];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            [sess deleteCurrentAudioMix];
            [sess deleteVideoAtPhototIndex:sess.photoNumberOfCurrentSelectedPhoto];
            [sess deleteVideoFramesForPhotoAtIndex:sess.photoNumberOfCurrentSelectedPhoto];
            [self clearCurImage];
            break;
        }
            
    }
    
}

- (void)showPhotoEffectsEditor
{
    [Utility removeActivityIndicatorFrom:self.view];
    
}


- (void)showPhotoOptions:(NSTimer*)t
{
    float x = [[t.userInfo objectForKey:@"x_location"]floatValue];
    float y = [[t.userInfo objectForKey:@"y_location"]floatValue];
    UIImageView *v = [t.userInfo objectForKey:@"view"];
    
     menu = [[PopupMenu alloc]initWithFrame:CGRectMake(0, 0, 200.0, 300.0) style:UITableViewStylePlain delegate:self];
    
    [menu reloadData];
    [menu showPopupIn:v at:CGPointMake(x, y)];
    curPopupViewParent = [t.userInfo objectForKey:@"scrollview"];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /* Dismiss the controller */
    [photoAlbumPopover dismissPopoverAnimated:YES];
    [picker dismissModalViewControllerAnimated:NO];
    
    /* Get Media Type */
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo)
    {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        if(nil == moviePath)
        {
            NSLog(@"moviePath is nil");
        }
        
        NSURL *movieUrl = [[NSURL alloc]initFileURLWithPath:moviePath];
        
        NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:movieUrl forKey:backgroundVideoSelected];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:backgroundVideoSelected object:nil userInfo:usrInfo];
       
    }
    else
    {
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        /* Image selected */
        NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:selectedImage forKey:@"backgroundImageSelected"];
        [[NSNotificationCenter defaultCenter] postNotificationName:backgroundImageSelected object:nil userInfo:usrInfo];
    }
    
	return;
}

- (void)openVideoAlbumForIpad
{
    /* Allocate the picker view */
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    
    /* Set the source type */
    imgPicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    
    /* Do not allow editing */
    imgPicker.allowsEditing = NO;
    
    /* Set th delegate for the picker view */
    imgPicker.delegate = self;
    
    /* Set the model transition style */
    imgPicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    imgPicker.mediaTypes = [[[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil]autorelease];
    
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    CGRect rec = CGRectMake(330.0, fullScreen.size.height-50.0, 50, 50);
    
    photoAlbumPopover = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    
    [photoAlbumPopover presentPopoverFromRect:rec inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    
    [imgPicker release];
}

- (void)openPhotoAlbumForIpad
{
    /* Allocate the picker view */
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    
    /* Set the source type */
    imgPicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    
    /* Do not allow editing */
    imgPicker.allowsEditing = NO;
    
    /* Set th delegate for the picker view */
    imgPicker.delegate = self;
    
    /* Set the model transition style */
    imgPicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    CGRect rec = CGRectMake(330.0, fullScreen.size.height-50.0, 0, 0);
    
    photoAlbumPopover = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    
    [photoAlbumPopover presentPopoverFromRect:rec inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    
    [imgPicker release];
}

- (void)loadTheSession
{
    
    sess = [[Session alloc]initWithSessionId:nvm.currentSessionIndex];
    
    if(nil == sess)
    {
        sess = [[Session alloc]initWithFrameNumber:nvm.currentFrameNumber];
        if(nil == sess)
        {
            return;
        }
    }
    
    [sess showSessionOn:self.view];
    
    [self selectEditTab];
    
    [Utility removeActivityIndicatorFrom:self.view];
    
    nvm = [Settings Instance];
    if(nvm.videoTutorialWatched == NO)
    {
        [self perform_Help];
        nvm.videoTutorialWatched = YES;
    }
#if FULLSCREENADS_ENABLE
    if(bShowRevModAd)
    {
        bShowRevModAd = NO;
    }
#endif
}


#pragma mark Start saving video frames to HDD

- (UIImageOrientation)getOrientationFrom:(AVAssetTrack*)inputAssetTrack
{
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    
    CGAffineTransform videoTransform = inputAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    
    return videoAssetOrientation_;
}

- (CGSize)getOptimalSizeFor:(AVAssetTrack*)inputAssetTrack
{
    float maxWidth = full_screen.size.width;
    //float maxHeight = full_screen.size.width;
    float width = inputAssetTrack.naturalSize.width;
    float height = inputAssetTrack.naturalSize.height;
    
#if MIN_SIZE_320
    if(width > height)
    {
        if(height > 320.0)
        {
            width  = (320.0/height)*width;
            height = 320.0;
        }
    }
    else
    {
        if(width > 320.0)
        {
            height = (320.0/width)*height;
            width = 320.0;
        }
    }
#else
    if(width > height)
    {
        if(width > maxWidth)
        {
            height = (maxWidth/width)*height;
            width  = maxWidth;
        }
    }
    else
    {
        if(height > maxWidth)
        {
            width = (maxWidth/height)*width;
            height = maxWidth;
        }
    }
#endif
    
    CGSize sze = CGSizeMake(width, height);
    
    return sze;
}

- (void)writeFrame:(UIImage*)image atFrameIndex:(int)frmIndex videoIndex:(int)vidIndex ofTotalFrame:(int)frames
{
   
    NSString *imgPath = [sess pathForImageAtIndex:frmIndex inPhoto:vidIndex];
    
    [UIImageJPEGRepresentation(image, 0.8) writeToFile:imgPath atomically:YES];
   
    
    float pr = (float)frmIndex/(float)frames;
    
    [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:pr] waitUntilDone:YES];
}

- (void)saveVideoFramesToHDD:(AVAsset *)inputAsset onCompletion:(void (^)(BOOL status, NSMutableDictionary *videoInfo))completion
{
    NSAutoreleasePool *bpool = [NSAutoreleasePool new];
    NSError           *error = nil;
    AVAssetTrack      *inputAssetTrack = [[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    double duration = CMTimeGetSeconds([inputAsset duration]);
    double nrFrames = CMTimeGetSeconds([inputAsset duration]) * 30;
    int frameIndex = 0;
    int origCount  = 0;
    int duplicateFrequency = 0;
    BOOL requiresDuplication = NO;
    float timeDurationLimit = 30.0;
    if (proVersion) {
        timeDurationLimit = 120.0;
    }
    videoTimeRange =videoTimeRange+ duration;
    //round the duration to 30 seconds
    if(duration > timeDurationLimit)
    {
        duration = timeDurationLimit;
        videoTimeRange =videoTimeRange+ 30;
    }
 
    nrFrames = duration * 30;
 
    
    /* Caluclate how often do we need to repeat the frames to achive 30fps, and inject those frames while
     reading and saving those frames */
    if(inputAssetTrack.nominalFrameRate < 30.0f)
    {
       
        float currentFrameCount          = inputAssetTrack.nominalFrameRate * duration;
        float framesRequiredToReach30fps = (currentFrameCount/inputAssetTrack.nominalFrameRate)*30.0f;
        float framesToDuplicate = framesRequiredToReach30fps - currentFrameCount;
       
        
        /* How often do we need to Duplicate the frames */
        duplicateFrequency = (int)((float)currentFrameCount/framesToDuplicate);
        requiresDuplication = YES;
        
    }
    
    //print brief details of the track
    
    //get video orientataion
    UIImageOrientation videoAssetOrientation_ = [self getOrientationFrom:inputAssetTrack];
    
    // Check status of "tracks", make sure they were loaded
    AVKeyValueStatus tracksStatus = [inputAsset statusOfValueForKey:@"tracks" error:&error];
    if (!tracksStatus == AVKeyValueStatusLoaded)
    {
        // failed to load
        if(nil != completion)
        {
            completion(NO,nil);
        }
        [bpool release];
        return;
    }
    
    /* delete existing frames */
    [sess deleteVideoFramesForPhotoAtIndex:[sess photoNumberOfCurrentSelectedPhoto]];
    
    /* Read video samples from input asset video track */
    AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:inputAsset error:&error];
    NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
    CGSize sze = [self getOptimalSizeFor:inputAssetTrack];
    
    /* TBD uncomment below line if optimization doesn't work */
    [outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
    [outputSettings setObject:[NSNumber numberWithFloat:sze.width] forKey:(NSString*)kCVPixelBufferWidthKey];
    [outputSettings setObject:[NSNumber numberWithFloat:sze.height] forKey:(NSString*)kCVPixelBufferHeightKey];
    
    //[outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_24BGR]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput *readerVideoTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] outputSettings:outputSettings];
    
    // Assign the tracks to the reader and start to read
    [reader addOutput:readerVideoTrackOutput];
    if ([reader startReading] == NO)
    {
        // Handle error
       
        if(nil != completion)
        {
            completion(NO,nil);
        }
        [bpool release];
        return;
    }
    
    while (reader.status == AVAssetReaderStatusReading)
    {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        CMSampleBufferRef sampleBufferRef = [readerVideoTrackOutput copyNextSampleBuffer];
        if (sampleBufferRef)
        {
            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);
            /*Lock the image buffer*/
            CVPixelBufferLockBaseAddress(imageBuffer,0);
            /*Get information about the image*/
            uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
            size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
            size_t width = CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            
            /*We unlock the  image buffer*/
            CVPixelBufferUnlockBaseAddress(imageBuffer,0);
            
            /*Create a CGImageRef from the CVImageBufferRef*/
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
            CGImageRef newImage = CGBitmapContextCreateImage(newContext);
            
            /*We release some components*/
            CGContextRelease(newContext);
            CGColorSpaceRelease(colorSpace);
            
#if 0
            UIImage *image = [self scaledCopyOfImage:newImage toSize:sze inputOrientation:videoAssetOrientation_];
            [self writeFrame:image atFrameIndex:frameIndex videoIndex:currentIndex ofTotalFrame:nrFrames];
#else
            [self writeFrame:[UIImage imageWithCGImage:newImage scale:1.0 orientation:videoAssetOrientation_] atFrameIndex:frameIndex videoIndex:[sess photoNumberOfCurrentSelectedPhoto] ofTotalFrame:nrFrames];
#endif
            frameIndex++;
            
            if(requiresDuplication)
            {
                
                if((0 != duplicateFrequency)&&(0 ==(origCount%duplicateFrequency)))
                {
                    [self writeFrame:[UIImage imageWithCGImage:newImage scale:1.0 orientation:videoAssetOrientation_] atFrameIndex:frameIndex videoIndex:[sess photoNumberOfCurrentSelectedPhoto] ofTotalFrame:nrFrames];
                    frameIndex++;
                }
            }
            /*We release the CGImageRef*/
            CGImageRelease(newImage);
            
            CMSampleBufferInvalidate(sampleBufferRef);
            CFRelease(sampleBufferRef);
            sampleBufferRef = NULL;
            
            origCount++;
        }
        
        [pool release];
        
        if(nrFrames == frameIndex)
        {
            break;
        }
    }
    

    [bpool release];
    
    NSMutableDictionary *videoInfo = [[NSMutableDictionary alloc]initWithCapacity:3];
    [videoInfo setObject:[NSNumber numberWithInt:frameIndex] forKey:@"FrameCount"];
    [videoInfo setObject:[NSNumber numberWithInt:[sess photoNumberOfCurrentSelectedPhoto]] forKey:@"VideoFrameIndex"];
    [videoInfo setObject:[NSNumber numberWithFloat:duration] forKey:@"Duration"];
    [videoInfo setObject:[NSNumber numberWithFloat:inputAssetTrack.nominalFrameRate] forKey:@"Fps"];
    [[NSUserDefaults standardUserDefaults]setObject:videoInfo forKey:@"VideoInfo"];
    
    if(nil != completion)
    {
        completion(YES,videoInfo);
    }
}

- (void)updateProgress:(NSNumber*)prog
{
    /*UIProgressView *pv = (UIProgressView*)[self.view viewWithTag:3658];
     if(nil != pv)
     {
     [pv setProgress:[prog floatValue]];
     }*/
    NSLog(@"Print app suspend --- %d",self.applicationSuspended);
    UIImageView *touchBlock = (UIImageView*)[self.view viewWithTag:33658];
    if(nil != touchBlock)
    {
        //[touchBlock removeFromSuperview];
        
        UIProgressView *pv = (UIProgressView*)[touchBlock viewWithTag:3658];
        if(nil != pv)
        {
            float value = [prog floatValue];
            [pv setProgress:value];
        }
    }
}

- (void)removeProgressBar
{
    UIImageView *touchBlock = (UIImageView*)[self.view viewWithTag:33658];
    if(nil != touchBlock)
    {
        //UIProgressView *pv = (UIProgressView*)[self.view viewWithTag:3658];
        UIProgressView *pv = (UIProgressView*)[touchBlock viewWithTag:3658];
        if(nil != pv)
        {
            [pv removeFromSuperview];
            [pv release];
        }
        [touchBlock removeFromSuperview];
        [touchBlock release];
    }
}

- (void)addprogressBarWithMsg:(NSString*)msgText
{
    CGRect full = [[UIScreen mainScreen]bounds];
    
    /* Add touch block view */
    UIImageView *touchBlock = [[UIImageView alloc]initWithFrame:full];
    touchBlock.userInteractionEnabled = YES;
    touchBlock.tag = 33658;
    [self.view addSubview:touchBlock];
    //[touchBlock release];
    
    /* add lable and bar display frame */
    UIView *displayArea = [[UIView alloc]initWithFrame:CGRectMake(0, 0, full.size.width-150, 100)];
    displayArea.backgroundColor = DARK_GRAY_BG;
    displayArea.alpha = 0.8;
    displayArea.layer.cornerRadius = 9.0;
    displayArea.center = touchBlock.center;
    [touchBlock addSubview:displayArea];
    [displayArea release];
    
    /* Add label */
    UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, displayArea.frame.size.width, displayArea.frame.size.height/2.0)];
    msg.backgroundColor = [UIColor clearColor];
    msg.text = msgText;
    msg.textAlignment = NSTextAlignmentCenter;
    msg.textColor = [UIColor whiteColor];
    msg.font = [UIFont boldSystemFontOfSize:15.0];
    msg.center = CGPointMake(touchBlock.center.x, touchBlock.center.y-(msg.frame.size.height/2.0));
    [touchBlock addSubview:msg];
    [msg release];
    
    UIProgressView *pv = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    pv.tag = 3658;
    pv.frame = CGRectMake(10, msg.frame.origin.y+msg.frame.size.height, displayArea.frame.size.width-20, displayArea.frame.size.height/2.0);
    pv.center = CGPointMake(touchBlock.center.x, pv.center.y+pv.frame.size.height/2.0);
    [touchBlock addSubview:pv];
    //[pv release];
}

#pragma mark end saving video frames to HDD
#pragma mark start generating video from images
- (NSDictionary*)getVideoSettings
{
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   //codecSettings,AVVideoCompressionPropertiesKey,
                                   [NSNumber numberWithInt:640], AVVideoWidthKey,
                                   [NSNumber numberWithInt:640], AVVideoHeightKey,
                                   nil];
    
    return videoSettings;
}

- (CVPixelBufferRef) pixelBufferFromUIImage:(UIImage*)imag size:(CGSize)size
{
    if(nil == imag)
    {
        NSLog(@"pixelBufferFromUIImage: Image is Nil");
    }
    
    CGImageRef image = imag.CGImage;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (CFDictionaryRef) options,
                                          &pxbuffer);
    status=status;//Added to make the stupid compiler not show a stupid warning.
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 (CGBitmapInfo) kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    //CGContextTranslateCTM(context, 0, CGImageGetHeight(image));
    //CGContextScaleCTM(context, 1.0, -1.0);//Flip vertically to account for different origin
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (void)addAudioFilesAtPath:(NSArray*)audioInfoArray
                 usingMode:(BOOL)serialMixing
             toVideoAtPath:(NSString*)videoPath
       outputToFileAtApath:(NSString*)outputPath
              onCompletion:(void (^)(BOOL status))completion
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    CMTime                videoClipStartTime = kCMTimeZero;
    CMTime                audioStartTime = kCMTimeZero;
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    NSURL                *video_inputFileUrl = [NSURL fileURLWithPath:videoPath];
    NSURL                *outputFileUrl = [NSURL fileURLWithPath:outputPath];
    float                 kRecordingFPS = 30.0;
    int                   audioFileCount = 0;
    double                 videoDuration = 0;
    
    /* delete if the putput file already exists */
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    }
    
    //Add video Assets to the composition
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:videoClipStartTime error:nil];
    videoDuration = CMTimeGetSeconds(videoAsset.duration);
    //add audio assets to the composition
    for (NSDictionary * audInfo in audioInfoArray)
    {
        NSURL *audioUrl = [audInfo objectForKey:@"audioFilePath"];
        AVURLAsset * urlAsset = [AVURLAsset URLAssetWithURL:audioUrl
                                                    options:nil];
        NSArray *tracks = [urlAsset tracksWithMediaType:AVMediaTypeAudio];
        audioFileCount = audioFileCount + 1;
        double audioDuration = [[audInfo objectForKey:@"audioDuration"] doubleValue];
        
        if(audioDuration > videoDuration)
        {
            audioDuration = videoDuration;
        }
        if(nil == tracks)
        {
            
            if (isSequentialPlay) {
                CMTime audioAssetDuration = CMTimeMake((int) (audioDuration * kRecordingFPS), kRecordingFPS);
                 audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
            }
            continue;
        }
        
        if((nil != tracks)&&(0 == tracks.count))
        {
            
            if (isSequentialPlay) {
                CMTime audioAssetDuration = CMTimeMake((int) (audioDuration * kRecordingFPS), kRecordingFPS);
                audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
            }
            continue;
        }
        
        
        AVAssetTrack * audioAssetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                       preferredTrackID: kCMPersistentTrackID_Invalid];
        CMTime audioAssetDuration = CMTimeMake((int) (audioDuration * kRecordingFPS), kRecordingFPS);
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetDuration) ofTrack:audioAssetTrack atTime:audioStartTime error:nil];
        
        if(serialMixing)
        {
            audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
        }
    }

    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputURL = outputFileUrl;
    
    [pool release];
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         
         if(nil != completion)
         {
             completion(YES);
         }
     }];
}

- (float)getRenderSize
{
    float renderSize;
    
    /* checking frame size to fit proper video resolution */
    if (sess.frame.frame.size.width >= 700.0) {
        renderSize = 656.0;
    }else{
        renderSize = 639.0; //Original code
    }
    
    float videoSettingSize = 640.0;
    int maxTries = 10;
    for(int photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
        
        UIImage *image = [sess getVideoFrameAtIndex:0 forPhoto:photoIndex];
        if(nil != image)
        {
            //pht.image  = image;
            pht.view.imageView.image = image;
        }
    }
    
    /* render current frame */
    //UIImage *img = [sess.frame renderToImageOfSize:CGSizeMake(640, 640)];
    UIImage *img = [sess.frame quickRenderToImageOfSize:CGSizeMake(renderSize, renderSize)];
    if(img.size.width == videoSettingSize)
    {
        return 639.0;
    }
    else if(img.size.width < videoSettingSize)
    {
        for(int index = 0; index < maxTries;index++)
        {
            img = [sess.frame quickRenderToImageOfSize:CGSizeMake(renderSize+index, renderSize+index)];
            if(img.size.width == videoSettingSize)
            {
                renderSize = renderSize+index;
                break;
            }
        }
    }
    else
    {
        for(int index = 0; index < maxTries;index++)
        {
            img = [sess.frame quickRenderToImageOfSize:CGSizeMake(renderSize-index, renderSize-index)];
            if(img.size.width == videoSettingSize)
            {
                renderSize = renderSize+index;
                break;
            }
        }
    }
    
    return renderSize;
}

- (void)continueGenerateVideo:(void (^)(BOOL status, NSString *videoPath))completion
{
    NSLog(@"applicationSuspended************");
    NSString *interVideoPath = [sess pathToIntermediateVideo];
    NSString *currentVideoPath = [sess pathToCurrentVideo];
    AVAssetWriterInputPixelBufferAdaptor *adaptor = nil;
    float renderSize = [self getRenderSize];
    
    /* check if we already have a generated video, if yes, no need to generate it again */
    if(YES == [[NSFileManager defaultManager]fileExistsAtPath:interVideoPath])
    {
        [[NSFileManager defaultManager]removeItemAtPath:interVideoPath error:nil];
    }
    
    if(YES == [[NSFileManager defaultManager]fileExistsAtPath:currentVideoPath])
    {
        if(nil != completion)
        {
            completion(YES,currentVideoPath);
        }
        
        return;
    }
    
    /* Setup the writer */
    NSAutoreleasePool *bpool = [NSAutoreleasePool new];
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:interVideoPath]
                                                           fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings     = [self getVideoSettings];
    AVAssetWriterInput* writerInput = [[AVAssetWriterInput
                                        assetWriterInputWithMediaType:AVMediaTypeVideo
                                        outputSettings:videoSettings] retain];
    
    adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                               sourcePixelBufferAttributes:nil];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    /* Find number of iterations that we need to make to generate video
     it is going to be the photo with maximum number of frames */
    int frameCount = [sess getFrameCountOfFrame:sess.frame];
    int frameIndex = 0;
    int photoIndex = 0;
    
    int counter_Variable= 0;
    int currentPhotoIndex = 0;
    int currentFrameIndex = 0;
    
    [self addWaterMarkToFrame];
    
    [sess enterNoTouchMode];
    
    int totalNumberOfFrames = 0;
    for (int i = 0; i < sess.frame.photoCount; i++)
    {
        totalNumberOfFrames = totalNumberOfFrames + [sess getFrameCountForPhotoAtIndex:i];
        
    }
    if (isSequentialPlay == TRUE) {
       frameCount = totalNumberOfFrames;
    }
     gTotalPreviewFrames = [sess getFrameCountOfFrame:sess.frame];
    if (isSequentialPlay)
    {
    gTotalPreviewFrames = totalNumberOfFrames;
    
//    if (isVideoOrderChangedByUser== NO) {
//        [self setTheDefaultOrderArray];
//    }
    }
    
    /* we couldn't find the existing video, so lets generate one by ourself */
    for(frameIndex = 0; frameIndex < frameCount; frameIndex++)
    {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        if (isSequentialPlay)
        {
            if (counter_Variable>= sess.frame.photoCount) {
                break;
            }
            
            if (frameIndex ==0)
            {
                //initialize the frame
                for(photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
                {
                    
                    Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
                    
                    UIImage *image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
                    if(nil != image)
                    {
                        pht.view.imageView.image = image;
                    }
                }
            }else
            {
                if ([orderArrayForVideoItems count]==0)
                {
                    /* if video order is not set , set them to default oreder*/
                    [self setTheDefaultOrderArray];
                }
            
            
            NSNumber *number =[orderArrayForVideoItems objectAtIndex:counter_Variable];
            currentPhotoIndex = number.intValue;
            gCurPreviewFrameIndex = frameIndex;
            Photo  *pht= [sess.frame getPhotoAtIndex:currentPhotoIndex];
            UIImage *image = [sess getVideoFrameAtIndex:currentFrameIndex forPhoto:currentPhotoIndex];
            if(nil != image)
            {
                pht.view.imageView.image = image;
            }else
            {
                counter_Variable++;
                currentFrameIndex = 0;
            }
            currentFrameIndex++;
            }
        }else
        {
            for(photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
            {
                Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
                
                UIImage *image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
                if(nil != image)
                {
                    
                    pht.view.imageView.image = image;
                }
            }
        }

        /* render current frame */
        UIImage *img = [sess.frame renderToImageOfSize:CGSizeMake(renderSize, renderSize)];
        //UIImage *img = [sess.frame quickRenderToImageOfSize:CGSizeMake(639, 639)];
        
        CVPixelBufferRef buffer = [self pixelBufferFromUIImage:img size:img.size];
        [adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frameIndex, 30)];
        CVPixelBufferRelease(buffer);
        [pool release];
        
        float prg = (float)frameIndex/(float)frameCount;
        //dispatch_async(dispatch_get_main_queue(), ^{
            // update your UI here
            //[self updateProgress:[NSNumber numberWithFloat:prg]];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:prg] waitUntilDone:YES];
        //});
        
        if(self.applicationSuspended)
        {
            if(nil != completion)
            {
                completion(NO,nil);
            }
            
            self.applicationSuspended = NO;
            
            [self removeWaterMarkFromFrame];
            
            /* restore frame images */
            [sess exitNoTouchMode];
            [self performSelectorOnMainThread:@selector(shoeErrorMessage) withObject:self waitUntilDone:YES];

            
//            [WCAlertView showAlertWithTitle:@"Failed"
//                                    message:@"Failed to generate video. Application is interrupted while generating video, please do not close/interrupt the application while generating video"
//                         customizationBlock:nil
//                            completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
//             {
//                 [customTabBar unselectCurrentSelectedTab];
//             }
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil];

            return;
        }
    }

    [self removeWaterMarkFromFrame];
    
    [writerInput markAsFinished];
    [videoWriter endSessionAtSourceTime:CMTimeMake(frameIndex-1, 30)];
    
    [bpool release];
    
    [videoWriter finishWritingWithCompletionHandler:^{
        NSAutoreleasePool *bpool = [NSAutoreleasePool new];
        
        /* Mix audio */
        NSMutableArray *audioFiles = [[NSMutableArray alloc]initWithCapacity:1];
        BOOL useLibraryAudio = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY]boolValue];
        BOOL librarayAudioValid = NO;
        if(useLibraryAudio)
        {
            NSNumber *persistentId = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
            MPMediaItem *mItem = [self getMediaItemFromMediaItemId:persistentId];
            if(nil != mItem)
            {
                NSURL *audioUrl = [mItem valueForProperty:MPMediaItemPropertyAssetURL];
                AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
                double duration = CMTimeGetSeconds( songAsset.duration);
                
                NSArray *objs = [NSArray arrayWithObjects:audioUrl,[NSNumber numberWithDouble:duration], nil];
                NSArray *keys = [NSArray arrayWithObjects:@"audioFilePath",@"audioDuration", nil];
                NSDictionary *dict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
                [audioFiles addObject:dict];
                librarayAudioValid = YES;
                
            }
        }
        
        if(NO == librarayAudioValid)
        {
            int tempIndex = 0;
            for(int index = 0; index < sess.frame.photoCount; index++)
            {
                NSNumber *videoNumber = [NSNumber numberWithInt:index];
                if (isSequentialPlay)
                {
                    if (tempIndex < [orderArrayForVideoItems count])
                    {
                        videoNumber = [orderArrayForVideoItems objectAtIndex:tempIndex];
                        
                    }else
                    {
                        continue;
                    
                    }
                }
                if (isSequentialPlay) {
                    tempIndex++;
                }
                NSURL *audioUrl = [sess getVideoUrlForPhotoAtIndex:videoNumber.intValue];
                if(nil == audioUrl)
                {
                    continue;
                }
                
                double duration = [sess getVideoDurationForPhotoAtIndex:videoNumber.intValue];
                if(duration == 0.0)
                {
                    continue;
                }
                
                NSArray *objs = [NSArray arrayWithObjects:audioUrl,[NSNumber numberWithDouble:duration], nil];
                NSArray *keys = [NSArray arrayWithObjects:@"audioFilePath",@"audioDuration", nil];
                NSDictionary *dict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
                [audioFiles addObject:dict];
                
            }
        }
        
        [bpool release];
        
        if(self.applicationSuspended)
        {
            NSLog(@"application suspended.....");
            if(nil != completion)
            {
                completion(NO,nil);
            }
            
            self.applicationSuspended = NO;
            
            [self removeWaterMarkFromFrame];
            
            /* restore frame images */
            [sess exitNoTouchMode];


           [WCAlertView showAlertWithTitle:@"Failed"
                                    message:@"Failed to generate video. Application is interrupted while generating video, please do not close/interrupt the application while generating video"
                         customizationBlock:nil
                            completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
             {
                 [customTabBar unselectCurrentSelectedTab];
             }
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
            
            return;
        }
        
        [self addAudioFilesAtPath:audioFiles usingMode:isSequentialPlay toVideoAtPath:interVideoPath outputToFileAtApath:currentVideoPath onCompletion:^(BOOL status) {
            if(nil != completion)
            {
                completion(status,currentVideoPath);
            }
            
            /* restore frame images */
            [sess exitNoTouchMode];
        }];
        
    }];
    
    return;
}
-(void)shoeErrorMessage
{
    [WCAlertView showAlertWithTitle:@"Failed"
                            message:@"Failed to generate video. Application is interrupted while generating video, please do not close/interrupt the application while generating video"
                 customizationBlock:nil
                    completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
     {
         [customTabBar unselectCurrentSelectedTab];
     }
                  cancelButtonTitle:@"OK"
                  otherButtonTitles:nil];
}
#pragma mark end saving video frames to HDD
#pragma mark video import
- (void)importVideo:(NSTimer *)timer
{
    
        //isVideoOrderChangedByUser = NO;
    if (orderArrayForVideoItems != nil && [orderArrayForVideoItems count]>0) {
        [self.orderArrayForVideoItems removeAllObjects];
    }
    
    NSURL *videoURL = [timer.userInfo objectForKey:@"videoPath"];
   
    if(nil == videoURL)
    {
        NSAssert(nil != videoURL,@"Video path is nil to import");
    }
    NSLog(@"importVideo:%@",videoURL);
    [sess saveVideoToDocDirectory:videoURL completion:^(NSString *localVideoPath) {
        [self performSelectorOnMainThread:@selector(addprogressBarWithMsg:) withObject:@"Prepairing to import" waitUntilDone:YES];
        // NSString *localPath = [localVideoPath retain];
        /* Initialize AVImage Generator */
        AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        [self clearCurImage];
        
        [inputAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler: ^{
            [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(addprogressBarWithMsg:) withObject:@"Importing Video" waitUntilDone:YES];
            
            [self saveVideoFramesToHDD:inputAsset onCompletion:^(BOOL status, NSMutableDictionary *videoInfo) {
                if(status == YES)
                {
                    [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                    /* Get the first image */
                    UIImage *img = [UIImage imageWithContentsOfFile:[sess pathForImageAtIndex:2 inPhoto:[sess photoNumberOfCurrentSelectedPhoto]]];
                    NSAssert(nil != img, @"Image in Video is nil, looks like video parsing went wrong");
                    NSURL *url = [NSURL fileURLWithPath:localVideoPath];
                    [videoInfo setObject:url forKey:@"videoPath"];
                    //[videoInfo setObject:img forKey:@"image"];
                    NSDictionary *info = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:img,videoInfo, nil]
                                                                     forKeys:[NSArray arrayWithObjects:@"image",@"videoInfo", nil]];
                    
                    [self performSelectorOnMainThread:@selector(handleVideoSelectionWithInfo:) withObject:info waitUntilDone:NO];
                }
            }];
        }];
    }];
    return;
}

- (void)generateVideo:(void (^)(BOOL status,NSString *videoPath))complete
{
    [[configparser Instance] badgeAdUserInteractionDisable];

    BOOL optOutVideoHelp = [[[NSUserDefaults standardUserDefaults]objectForKey:@"optOutVideoGenerationHelp"]boolValue];
    
    self.applicationSuspended = NO;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self addprogressBarWithMsg:@"Generating Video"];
    
    if(NO == optOutVideoHelp)
    {
        [WCAlertView showAlertWithTitle:@"Info"
                                message:@"Please do not close the application while generating video, On doing so Video generation will fail!!"
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
         {
             if(buttonIndex == 1)
             {
                 [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:@"optOutVideoGenerationHelp"];
             }
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 [self continueGenerateVideo:^(BOOL status, NSString *videoPath) {
                     NSLog(@"Completed generating video with Status %d path %@",status,videoPath);
                     [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                     [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                     [[configparser Instance] badgeAdUserInteractionEnable];
                     if(nil != complete)
                     {
                         complete(status,videoPath);
                     }
                 }];
             });
         }
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:@"Got It",nil];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self continueGenerateVideo:^(BOOL status, NSString *videoPath) {
                NSLog(@"Completed generating video with Status %d path %@",status,videoPath);
                [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                if(nil != complete)
                {
                    complete(status,videoPath);
                }
            }];
        });
    }
}

- (void)generateAudioOfVideoFrame:(void (^)(BOOL status, NSString *audioPath))completion
{
    NSAutoreleasePool *bpool = [NSAutoreleasePool new];
    
    CMTime                audioStartTime = kCMTimeZero;
    int                   audioFileCount = 0;
    float                  kRecordingFPS = 30.0;
    BOOL                    serialMixing = isSequentialPlay;
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    BOOL userMusicEnabled = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY]boolValue];
    BOOL userMusicIsValid = NO;
    
    
    
    if(userMusicEnabled)
    {
        NSLog(@"Deleting current audio mix");
        [sess deleteCurrentAudioMix];
    }
    
    NSString *audioPath = [sess pathToCurrentAudioMix];
    if([[NSFileManager defaultManager]fileExistsAtPath:audioPath])
    {
        NSAssert(userMusicEnabled == NO, @"Failed to delete audio mix in above step");
        NSLog(@"No Need to mix Audio, Mixed file already exists");
        dispatch_async(dispatch_get_main_queue(), ^{
            if(nil != completion)
            {
                completion(YES,audioPath);
            }});
        [bpool release];
        return;
    }
    
    if(userMusicEnabled)
    {
        NSNumber *persistentId = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
        NSURL *audioUrl        = [self getUrlFromMediaItemId:persistentId];
        AVURLAsset *urlAsset   = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
        NSArray      *tracks   = [urlAsset tracksWithMediaType:AVMediaTypeAudio];
        double duration        = CMTimeGetSeconds( urlAsset.duration);
        
        if((nil != tracks)&&(0 != tracks.count))
        {
            audioFileCount++;
            
            double maxVideoDuration = [sess getMaxVideoDuration:isSequentialPlay];

            if(duration > maxVideoDuration)
            {
                duration = maxVideoDuration;
            }
            if (isSequentialPlay== TRUE) {
                duration = maxVideoDuration;
            }
        
            NSLog(@" maximum duration :%f",duration);
            AVAssetTrack * audioAssetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
            AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                           preferredTrackID: kCMPersistentTrackID_Invalid];
            CMTime audioAssetDuration = CMTimeMake((int) (duration * kRecordingFPS), kRecordingFPS);
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetDuration) ofTrack:audioAssetTrack atTime:audioStartTime error:nil];
            
            userMusicIsValid = YES;
        }
    }
    
    if(NO == userMusicIsValid)
    {
        int tempIndex = 0;
        
        for(int index = 0; index < sess.frame.photoCount; index++)
        {
            NSLog(@"tempIndex :%d", tempIndex);
            NSNumber *videoNumber = [NSNumber numberWithInt:index];
            if (isSequentialPlay)
            {
                if (tempIndex < [orderArrayForVideoItems count]) {
                    videoNumber = [orderArrayForVideoItems objectAtIndex:tempIndex];
                }else
                {
                    continue;
                }
            }
            if (isSequentialPlay) {
                tempIndex++;
            }
            
            NSURL *audioUrl = [sess getVideoUrlForPhotoAtIndex:videoNumber.intValue];
            if(nil == audioUrl)
            {
                continue;
            }
            
            double duration = [sess getVideoDurationForPhotoAtIndex:videoNumber.intValue];
            if(duration == 0.0)
            {
                continue;
            }
            
            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
            NSArray      *tracks = [urlAsset tracksWithMediaType:AVMediaTypeAudio];
            audioFileCount++;
            if(nil == tracks)
            {
                 //tempIndex++;
                 CMTime audioAssetDuration = CMTimeMake((int) (duration * kRecordingFPS), kRecordingFPS);
                if (serialMixing) {
                    audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
                }
                NSLog(@"Audio Tracks doesn't exist 1");
                continue;
            }
            
            if((nil != tracks)&&(0 == tracks.count))
            {
                // tempIndex++;
                CMTime audioAssetDuration = CMTimeMake((int) (duration * kRecordingFPS), kRecordingFPS);
                if (serialMixing) {
                    audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
                }
                NSLog(@"Audio Tracks Doesn't exist 2");
                continue;
            }
            
           AVAssetTrack * audioAssetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
            AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                           preferredTrackID: kCMPersistentTrackID_Invalid];
            CMTime audioAssetDuration = CMTimeMake((int) (duration * kRecordingFPS), kRecordingFPS);
           // [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetDuration) ofTrack:audioAssetTrack atTime:audioStartTime error:nil];
            
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetDuration) ofTrack:audioAssetTrack atTime:audioStartTime error:nil];
           
            
            if(serialMixing)
            {
               // tempIndex++;
                audioStartTime = CMTimeAdd(audioStartTime, audioAssetDuration);
            }
        }
    }
    
    if(audioFileCount > 0)
    {
        NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
        AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
        _assetExport.outputFileType = AVFileTypeAppleM4A;
        _assetExport.outputURL = audioUrl;
        
        [_assetExport exportAsynchronouslyWithCompletionHandler:
         ^(void ) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if(_assetExport.status != AVAssetExportSessionStatusCompleted)
                 {
                     if(nil != completion)
                     {
                         completion(NO,nil);
                     }
                 }
                 else
                 {
                     if(nil != completion)
                     {
                         completion(YES,audioPath);
                     }
                 }
             });
             
         }];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(nil != completion)
            {
                completion(YES,nil);
            }
        });
    }
    
    [bpool release];
}

- (void)addWaterMarkToFrame
{
    
    float width = 172.0;
    float height = 50.0;
    CGRect waterMarkRect = CGRectMake(sess.frame.frame.size.width-width, sess.frame.frame.size.height-height, width, height);
    
    UILabel *waterMark = [[UILabel alloc]initWithFrame:waterMarkRect];
    waterMark.backgroundColor = [UIColor clearColor];
    waterMark.tag = TAG_WATERMARK_LABEL;
    waterMark.font = [UIFont boldSystemFontOfSize:13.0];

    if(NO == bought_watermarkpack)
    {
        if (freeVersion)
        {
            waterMark.text = @"www.videocollageapp.com";
        }
    }

    waterMark.textColor = [UIColor whiteColor];
    [sess.frame addSubview:waterMark];
    
}

- (void)removeWaterMarkFromFrame
{
    UILabel *waterMark = (UILabel*)[sess.frame viewWithTag:TAG_WATERMARK_LABEL];
    if(nil != waterMark)
    {
        [waterMark removeFromSuperview];
    }
}

- (void)updatePreviewFrame:(NSTimer *)timer
{
    int frameIndex = gCurPreviewFrameIndex;
    int   photoIndex = initialPhotoIndex;
    if(0 == frameIndex)
    {
        [self addWaterMarkToFrame];
    }
    
    if(frameIndex == gTotalPreviewFrames)
    {
        
        [timer invalidate];
        
        [self removeWaterMarkFromFrame];
        
        gIsPreviewInProgress  = NO;
        gCurPreviewFrameIndex = 0;
        gTotalPreviewFrames   = 0;
        gPreviewFrameCounterVariable = 0;
        
        [sess exitNoTouchMode];
        
        [self releaseToolBarIfAny];
        
        UIView *blockTouches = [self.view viewWithTag:TAG_PREVIEW_BLOCKTOUCHES];
        if(nil != blockTouches)
        {
            [blockTouches removeFromSuperview];
        }
        
        if(nil != preViewControls)
        {
            [preViewControls dismissAnimated:NO];
            [preViewControls release];
            preViewControls = nil;
        }
        
        [customTabBar unselectCurrentSelectedTab];
        
        [self selectEditTab];
        
        
        return;
    }
    
    if(gIsPreviewPaused)
    {
        return;
    }
    if (isSequentialPlay) {
        
        Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
        UIImage *image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
        
        if(nil != image)
        {
            pht.view.imageView.image = image;
        }else
        {
            
            photoIndex++;
            counterVariable++;
            if (counterVariable >= [orderArrayForVideoItems count])
            {
                initialPhotoIndex     = 0;
                gPreviewFrameCounterVariable = 0;
                gCurPreviewFrameIndex = gTotalPreviewFrames;
                counterVariable = 0;
                
                return;
                
            }else
            {
                
                frameIndex = 0;
                NSNumber *number =[orderArrayForVideoItems objectAtIndex:counterVariable];
                initialPhotoIndex = number.intValue;
                gCurPreviewFrameIndex = frameIndex;
                pht= [sess.frame getPhotoAtIndex:initialPhotoIndex];
                
            }
        }
        [previewAdjSlider setValue:gPreviewFrameCounterVariable];
        
        gCurPreviewFrameIndex++;
        gPreviewFrameCounterVariable++;
        
        if(gPreviewFrameCounterVariable == (gPreviewFrameCounterVariable % gTotalPreviewFrames))
        {
            previewTimeLabel.text = [self getCurrentPreviewTime];
            
        }
        
    }else
    {
        for (int photo_Index = 0; photo_Index< sess.frame.photoCount; photo_Index++)
        {
             Photo *pht = [sess.frame getPhotoAtIndex:photo_Index];
            UIImage *image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photo_Index];
            if(nil != image)
            {
                pht.view.imageView.image = image;
            }
        }
        
        [previewAdjSlider setValue:gCurPreviewFrameIndex];
        gCurPreviewFrameIndex++;
        
        if(gCurPreviewFrameIndex == (gCurPreviewFrameIndex%gTotalPreviewFrames))
        {
            previewTimeLabel.text = [self getCurrentPreviewTime];
        }
    }

}


- (void)playPreviewOfVideoFrame
{
    /* First check if the preview is in progress */
    if(gIsPreviewInProgress == YES)
    {
        NSLog(@"Preview is already in progress");
        return;
    }
    
    gIsPreviewInProgress = YES;
    gIsPreviewPaused = NO;
    
    [sess enterNoTouchMode];
    
    /* Mix audio */
    [self generateAudioOfVideoFrame:^(BOOL status, NSString *audioPath) {
        if(status == YES)
        {
            if(nil != audioPath)
            {
                NSURL *audioUrl1 = [NSURL fileURLWithPath:audioPath];
                previewAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl1 error:NULL];
                previewAudioPlayer.delegate = self;
                [previewAudioPlayer prepareToPlay];
            }
            else
            {
                previewAudioPlayer = nil;
            }
            int totalNumberOfFrames = 0;
            for (int i = 0; i < sess.frame.photoCount; i++)
            {
                totalNumberOfFrames = totalNumberOfFrames + [sess getFrameCountForPhotoAtIndex:i];
                
            }
            counterVariable = 0;
            gTotalPreviewFrames = [sess getFrameCountOfFrame:sess.frame];
            if (isSequentialPlay)
            {
                if ([orderArrayForVideoItems count]==0)
                {
                    [self setTheDefaultOrderArray];
                }
                gTotalPreviewFrames = totalNumberOfFrames;
                NSNumber *value = [orderArrayForVideoItems objectAtIndex:0];
                initialPhotoIndex = value.intValue;
                
            }
            gCurPreviewFrameIndex = 0;
            
            
            NSLog(@"print : %d", initialPhotoIndex);
            /* Started  */
            
            if(NO == gIsPreviewPaused)
            {
                
               [previewAdjSlider setMaximumValue:gTotalPreviewFrames];
                /* start perodic timer to change the frames of the video */
                [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                                 target:self
                                               selector:@selector(updatePreviewFrame:)
                                               userInfo:nil
                                                repeats:YES];
                if(nil != previewAudioPlayer)
                {
                    [previewAudioPlayer play];
                }

            }
        }
        else
        {
            gIsPreviewInProgress  = NO;
            gIsPreviewPaused      = NO;
            gTotalPreviewFrames   = 0;
            gCurPreviewFrameIndex = 0;
            
        }
    }];
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player release];
    previewAudioPlayer = nil;
}

- (void)previewVideo
{
    [self playPreviewOfVideoFrame];
}

- (void)pausePreView
{
    if(gIsPreviewInProgress)
    {
        if(nil != previewAudioPlayer)
        {
            /* First Pause the audio */
            [previewAudioPlayer pause];
        }
        
        /* Also make sure that we stop frame updates */
        gIsPreviewPaused = YES;
    }
}

- (void)resumePreview
{
    if(gIsPreviewInProgress)
    {
        if(YES == gIsPreviewPaused)
        {
            gIsPreviewPaused = NO;
            
            if(nil != previewAudioPlayer)
            {
                [previewAudioPlayer play];
            }
        }
    }
}

- (void)stopPreview
{
    if(gIsPreviewInProgress)
    {
        /* Below 3 initializtion for serial play not required in ParallelPlay*/
        if (isSequentialPlay) {
            initialPhotoIndex = 0;
        gCurPreviewFrameIndex = 0;
        gTotalPreviewFrames   = 0;
        gPreviewFrameCounterVariable = gTotalPreviewFrames;
        }else
        {
           gCurPreviewFrameIndex = gTotalPreviewFrames;
        }
        
        if (nil != previewAudioPlayer)
        {
            [previewAudioPlayer stop];
            
        }
        
        gIsPreviewInProgress = NO;
    }
}

- (void)handleVideoSelectionWithInfo:(NSDictionary*)info
{
    UIImage *img = [info objectForKey:@"image"];
    NSDictionary *videoInfo = [info objectForKey:@"videoInfo"];
    
    [sess videoSelectedForCurrentPhotoWithInfo:videoInfo image:img];
    
   
}

- (void)handleImageSelection:(NSTimer*)timer
{
    NSMutableArray *imageArray =  [timer.userInfo objectForKey:@"imageArray"];
    
    NSMutableArray *arrayOfEmptyIndex = [[NSMutableArray alloc] init];
    [arrayOfEmptyIndex addObject:[NSNumber numberWithInt:sess.photoNumberOfCurrentSelectedPhoto]];
    
    for (int i = 0; i< sess.frame.photoCount; i++)
    {
        if (i == sess.photoNumberOfCurrentSelectedPhoto)
        {
            continue;
        }else
            {
                Photo *pht = [sess.frame getPhotoAtIndex:i];
                if (pht.image == nil) {
                    [arrayOfEmptyIndex addObject:[NSNumber numberWithInt:i]];
                }
            }
    }
    
    
    for (int index = 0; index< [imageArray count]; index++)
    {
        int photoNumber = [[arrayOfEmptyIndex objectAtIndex:index] intValue];
        UIImage *image = [imageArray objectAtIndex:index];
        [sess imageSelectedForPhoto:image  indexOfPhoto:photoNumber];
    }
    
    [arrayOfEmptyIndex release];
    arrayOfEmptyIndex = nil;
    /*
    for (int index = 0; index<[imageArray count]; index++)
    {
        UIImage *image = [imageArray objectAtIndex:index];
        if (index == 0)
        {
            [sess imageSelectedForPhoto:image indexOfPhoto:sess.photoNumberOfCurrentSelectedPhoto];
            
        }else
        {
            for (int photoNumber = 0; photoNumber<sess.frame.photoCount; photoNumber++)
            {
                Photo *pht = [sess.frame getPhotoAtIndex:photoNumber];
                
                if (photoNumber == sess.photoNumberOfCurrentSelectedPhoto)
                {
                    continue;
                }
                
                if (pht.image ==  Nil)
                {
                    NSLog(@" image is nill at photo index : %d", photoNumber);
                    
                    [sess imageSelectedForPhoto:image indexOfPhoto:photoNumber];
                    image = nil;
                    break;
                    
                }
            }
        }
    }
     */
    [imageArray release];
    imageArray = nil;
    
    [Utility removeActivityIndicatorFrom:self.view];
}

#pragma mark notification center methods
- (void) receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:selectImageForSession])
    {
        isInEditMode = NO;
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showPhotoOptions:) userInfo:notification.userInfo repeats:NO];
    }
    else if([[notification name] isEqualToString:editImageForSession])
    {
        isInEditMode = YES;
        //self.imageForEdit = notification.object;
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showPhotoOptions:) userInfo:notification.userInfo repeats:NO];
    }
    
    else if([[notification name] isEqualToString:createNewSession])
    {
        if(nil != sess)
        {
            [sess hideSession];
            [sess release];
            sess = nil;
        }
        
        if(nil == nvm)
        {
            nvm = [Settings Instance];
        }
        
        [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"CREATING",@"Creating")];
        
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(loadTheSession) userInfo:nil repeats:NO];
    }
    else if([[notification name] isEqualToString:newframeselected])
    {
        
        
        if(bought_watermarkpack)
        {
            UIButton *removeWaterMark = (UIButton*)[self.view viewWithTag:TAG_WATERMARK_BUTTON];
            if(nil != removeWaterMark)
            {
                [removeWaterMark removeFromSuperview];
            }
        }
        if(notification.userInfo == nil)
        {
            NSLog(@"Invalid newframeselected Event, No frame number is passed");
            return;
        }
        
        NSNumber *frame = [notification.userInfo objectForKey:@"FrameNumber"];
        NSLog(@"ViewController: New frame selected %d",[frame integerValue]);
        [sess deleteCurrentAudioMix];
        [self frameSelectedAtIndex:frame.integerValue ofGridView:nil];
        [self setTheDefaultOrderArray];
    }
    else if([[notification name] isEqualToString:aspectratiochanged])
    {
        if(notification.userInfo == nil)
        {
            NSLog(@"Invalid aspectratiochanged Event, No aspect ratio number is passed");
            return;
        }
        
        NSNumber *aspect = [notification.userInfo objectForKey:@"aspectratio"];
        if(nil == aspect)
        {
            NSLog(@"Couldn't find aspectratio object in aspectratiochanged event");
            return;
        }
        
        nvm = [Settings Instance];
        nvm.aspectRatio = [aspect intValue];
        eAspectRatio eRat = [aspect intValue];
        if(sess.aspectRatio == eRat)
        {
            [Utility removeActivityIndicatorFrom:self.view];
            return;
        }
        
        [sess setAspectRatio:eRat];
    }
    else if([[notification name] isEqualToString:loadSession])
    {
        
        if((nil != sess)&&(sess.sessionId == nvm.currentSessionIndex))
        {
            return;
        }
        
        if(nil != sess)
        {
            [sess hideSession];
            [sess release];
            sess = nil;
        }
        
        if(nil == nvm)
        {
            nvm = [Settings Instance];
        }
        
        [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"LOADING",@"Loading")];
        
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(loadTheSession) userInfo:nil repeats:NO];
    }
    else if([[notification name] isEqualToString:backgroundImageSelected])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            /* First Dismiss the popover */
            [backgroundPopover dismissPopoverAnimated:YES];
        }
        
        /* UIImage *img = [[notification userInfo] objectForKey:@"backgroundImageSelected"];
         if(nil == img)
         {
         return;
         }*/
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        imageArray = [[notification userInfo] objectForKey:@"backgroundImageSelected"];
        if ([imageArray count]== 0) {
            return;
        }
        
        _editWhileImageSelection = YES;
        //self.imageForEdit = img;
        [sess deleteCurrentAudioMix];
        [Utility removeActivityIndicatorFrom:self.view];
        [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"LOADING",@"Loading")];
        
        //    NSDictionary *input = [NSDictionary dictionaryWithObject:img forKey:@"image"];
        //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showPhotoEffectsEditor) userInfo:nil repeats:NO];
        NSDictionary *input = [NSDictionary dictionaryWithObject:imageArray forKey:@"imageArray"];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleImageSelection:) userInfo:input repeats:NO];
        [imageArray release];
        imageArray = nil;
    }
    else if([[notification name] isEqualToString:backgroundVideoSelected])
    {
        _editWhileImageSelection = YES;
        self.imageForEdit        = nil;
        
        /* Get the video path and send it to importer */
        NSLog(@"user info inside notification handler %@",notification.userInfo);
        NSURL *videoPath = [notification.userInfo objectForKey:backgroundVideoSelected];
        NSAssert(nil != videoPath, @"Received nil videoPathUrl in backgroundvideoSelected notification");
        NSDictionary *info = [NSDictionary dictionaryWithObject:videoPath forKey:@"videoPath"];
        [sess deleteCurrentAudioMix];
    
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(importVideo:) userInfo:info repeats:NO];
    }
   
    else if([[notification name] isEqualToString:openIpadPhotoAlbum])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            /* First Dismiss the popover */
            [backgroundPopover dismissPopoverAnimated:YES];
        }
        
        [self openPhotoAlbumForIpad];
    }
    else if([[notification name] isEqualToString:openIpadVideoAlbum])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            /* First Dismiss the popover */
            [backgroundPopover dismissPopoverAnimated:YES];
        }
        
        [self openVideoAlbumForIpad];
    }
    else if([[notification name] isEqualToString:kInAppPurchaseManagerTransactionSucceededNotification])
    {
#if BANNERADS_ENABLE
        [self hideBannerAd];
#endif
        if(bought_watermarkpack)
        {
            UIButton *waterMarkRemove = (UIButton*)[self.view viewWithTag:TAG_WATERMARK_BUTTON];
            if(nil != waterMarkRemove)
            {
                [waterMarkRemove removeFromSuperview];
            }
        }
    }
    else if([[notification name]isEqualToString:swapmodeentered])
    {
        
        [sess.frame enterSwapMode];
    }
    else if([[notification name]isEqualToString:uploaddone])
    {
        //[self KxMenuWillDismissByUser:nil];
    }
    else if([[notification name]isEqualToString:@"notificationdidfinishwithframeview"])
    {
        
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationDidEnterToFirstScreen" object:nil];
    }
    else if([[notification name]isEqualToString:@"notificationdidLoadView"])
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                       selector:@selector(showFrameSelectionController)
                                       userInfo:nil
                                        repeats:NO];
        
        
    }else if ([[notification name]isEqualToString:@"didEnterToTouchDetectedMode"])
    {
        isTouchWillDetect = YES;
        helpScreen = nil;
    }else if ([[notification name]isEqualToString:@"selectImageForEffect"])
    {
        NSDictionary *dict = [notification userInfo];
        NSNumber *PhotoNumber = [dict objectForKey:@"photoNumber"];
        int currentSelectedPhotoNumber = PhotoNumber.intValue;
        for(int index = 0; index < sess.frame.photoCount; index++)
        {
            Photo *pht = [sess.frame getPhotoAtIndex:index];
            if(nil != pht)
            {
                currentSelectedPhotoNumberForEffect = currentSelectedPhotoNumber;
                pht.view.scrollView.layer.borderColor = [UIColor redColor].CGColor;
                pht.view.scrollView . layer. borderWidth = 0.0;
                if (index== currentSelectedPhotoNumber) {
                 pht.view.scrollView . layer. borderWidth = 5.0;
                }
                
            }
        }
    }
    return;
}

- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:nil
                                                  object:nil];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:sess];
}

- (void)dealloc
{
    NSLog(@"**********  view controller dealloc called***********");
    [self unregisterForNotifications];
    
    [super dealloc];
}
#pragma frame thumbnail image generation

#pragma mark first time processing
- (void)generateTheResourcesRequiredOnFirstRun
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *filename     = [NSString stringWithFormat:@"mainbackground.jpg"];
    NSString *path         = [docDirectory stringByAppendingPathComponent:filename];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    /* First generate the main background image */
    if(NO == [filemgr fileExistsAtPath:path])
    {
        UIImage *mainBgnd = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mainbackground_ipad" ofType:@"png"]];
        if(nil != mainBgnd)
        {
            UIImage *optimizedImage = [Utility optimizedImage:mainBgnd withMaxResolution:480];
            NSData *data = UIImageJPEGRepresentation(optimizedImage, 1.0);
            [filemgr createFileAtPath:path contents:data attributes:attributes];
            NSLog(@"generateTheResourcesRequiredOnFirstRun: Created Mainbackground");
        }
        else
        {
            NSLog(@"mainbackground_ipad doesn't exists");
        }
    }
}

#pragma mark viewcontroller methods

- (void)showFrameSelectionController
{
#if SESSIONSUPPORT_ENABLE
    InitSessionManager *mg = [[InitSessionManager alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:mg];
    navBar.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController presentModalViewController:navBar animated:YES];
    [navBar release];
    [mg release];
#else
    FrameSelectionController *sc = [[FrameSelectionController alloc]init];
    
    if(nil == sc)
    {
        return;
    }
    
    [self.navigationController presentModalViewController:sc animated:NO];
    
    [sc release];
#endif
}

- (void)removeWaterMark:(id)sender
{
    [[InAppPurchaseManager Instance]puchaseProductWithId:kInAppPurchaseRemoveWaterMarkPack];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    printf("--- ViewController.m: viewDidLoad ---\n");
    NSLog(@"View did load");
        //isVideoOrderChangedByUser = NO;
    isEffectEnabled = NO;
    currentSelectedPhotoNumberForEffect =  [sess photoNumberOfCurrentSelectedPhoto];
    
    BOOL      enableStatus = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_SEQUENTIAL_Play_STATUS]boolValue];
    isSequentialPlay = enableStatus;
    isTouchWillDetect = YES;
    videoImageInfo = [[NSMutableArray alloc] init];
    
    if (orderArrayForVideoItems != nil) {
        [orderArrayForVideoItems removeAllObjects];
        [orderArrayForVideoItems release];
        orderArrayForVideoItems = nil;
    }
    orderArrayForVideoItems = [[NSMutableArray alloc] init];
    initialPhotoIndex = 0;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    } 
    
    [[InAppPurchaseManager Instance]loadStore];
    
    /* Get the settings instance */
    nvm = [Settings Instance];
    
    [self generateTheResourcesRequiredOnFirstRun];
    
    /* First register for notifications */
    [self registerForNotifications];
    
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.view = imgview;
    self.view.userInteractionEnabled = YES;
    
    if(NO == bought_watermarkpack)
    {
        UIButton *removeWaterMark = [UIButton buttonWithType:UIButtonTypeCustom];
        removeWaterMark.frame = CGRectMake(0,customBarHeight,full_screen.size.width,30);
        removeWaterMark.backgroundColor = PHOTO_DEFAULT_COLOR;
        [removeWaterMark setTitle:@"Remove Watermark" forState:UIControlStateNormal];
        removeWaterMark.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        removeWaterMark.alpha = 0.8;
        removeWaterMark.showsTouchWhenHighlighted = YES;
        removeWaterMark.tag = TAG_WATERMARK_BUTTON;
        [removeWaterMark addTarget:self action:@selector(removeWaterMark:) forControlEvents:UIControlEventTouchUpInside];
        if (freeVersion)
        {
        [self.view addSubview:removeWaterMark];
        }
    }
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        imgview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"background_ipad" ofType:@"png"]];
        [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-customBarHeight,full_screen.size.width,customBarHeight)];
    }
    else
    {
        imgview.image = [UIImage imageNamed:@"background"];
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && full_screen.size.height>480) {
            imgview.image = [UIImage imageNamed:@"background_1136.png"] ;
        }
        [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-customBarHeight,full_screen.size.width,customBarHeight)];
    }
    
#if FULLSCREENADS_ENABLE
    bShowRevModAd = YES;
#endif
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                   selector:@selector(showFrameSelectionController)
                                   userInfo:nil
                                    repeats:NO];
    int adjustDistanceFromWall = adviewdistancefromwall;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && full_screen.size.height== 480) {
        adjustDistanceFromWall = 0;
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        adjustDistanceFromWall =30;
    }
    
    CGPoint point = CGPointMake(full_screen.size.width-adviewdistancefromwall-adviewsize, adjustDistanceFromWall+50);
    if (freeVersion) {
        [[configparser Instance] showAdInView:self.view atLocation:point];
    [[configparser Instance] bringAdToTheTop];
    }
#if BANNERADS_ENABLE
    
    [self showBannerAd];
    
#endif
    
    return;
}
- (void)allocateUIForTabbar:(CGRect )rect
{
    NSLog(@"custom tabbar of view controller allocated -------");
    if (customTabBar != nil) {
        [customTabBar removeFromSuperview];
        customTabBar = nil;
    }
    customTabBar = [[OT_TabBar alloc]initWithFrame:rect];
    OT_TabBarItem *frames = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:frame_imageName]
                                                  selectedImage:[UIImage imageNamed:frame_active_imageName]
                                                            tag:MODE_FRAMES];
    OT_TabBarItem *colorAndPattern = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:select_imageName]
                                                           selectedImage:[UIImage imageNamed:select_active_imageName]
                                                                     tag:MODE_COLOR_AND_PATTERN];
    OT_TabBarItem *adjustSettings = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:setting_imageName]
                                                          selectedImage:[UIImage imageNamed:setting_active_imageName]
                                                                    tag:MODE_ADJUST_SETTINGS];
    OT_TabBarItem *effect = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:effects_imageName]
                                                          selectedImage:[UIImage imageNamed:effects_active_imageName]
                                                                    tag:MODE_ADD_EFFECT];
    OT_TabBarItem *preview = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:play_imageName]
                                                   selectedImage:[UIImage imageNamed:play_active_imageName]
                                                             tag:MODE_PREVIEW];
    OT_TabBarItem *videoSettings = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:swap_imageName]
                                                         selectedImage:[UIImage imageNamed:swap_active_imageName]
                                                                   tag:MODE_VIDEO_SETTINGS];
    OT_TabBarItem *share = [[OT_TabBarItem alloc]initWithImage:[UIImage imageNamed:share_imageName]
                                                 selectedImage:[UIImage imageNamed:share_active_imageName]
                                                           tag:MODE_SHARE];
    preview.nestedSelectionEnabled = NO;
    customTabBar.showOverlayOnSelection = NO;
    // customTabBar.backgroundImage = [UIImage imageNamed:bottombarImage];  // Commented to use OT_TabBar background color
    customTabBar.delegate        = self;
    customTabBar.items = [NSArray arrayWithObjects:frames,colorAndPattern,adjustSettings,effect,videoSettings,share, nil];
    
    [self.view addSubview:customTabBar];
    [customTabBar release];
    [frames release];
    [colorAndPattern release];
    [adjustSettings release];
    [preview release];
    [videoSettings release];
    [share release];
    
}

- (void)viewDidUnload
{
    /* First Release the Session */
    if(nil != sess)
    {
        [sess hideSession];
        [sess release];
        sess = nil;
    }
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@" viewwill appear---------------------");
    self.navigationController.navigationBarHidden = YES;
    
    
}

#if defined(VideoCollagePRO)
#else
-(void)showAdmobFullscreenAd:(NSTimer*)timer
{
    GADInterstitial *interstitial_ = (GADInterstitial*)timer.userInfo;
    
    if(self.navigationController.visibleViewController == self)
    {
        if(interstitial_.hasBeenUsed == NO)
        {
            [interstitial_ presentFromRootViewController:self];
        }
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showAdmobFullscreenAd:) userInfo:interstitial_ repeats:NO];
    }
    
}
-(void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    if(bought_watermarkpack== NO)
    {
        if(self.navigationController.visibleViewController == self)
        {
            [ad presentFromRootViewController:self];
        }
        else
        {
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showAdmobFullscreenAd:) userInfo:ad repeats:NO];
        }
    }
}
#endif
#if BANNERADS_ENABLE
-(void)showBannerAd
{
    NSLog( @"Show BannerAd");
    if(CONFIG_ADVERTISEMENTS_DISABLE == [configparser Instance].advertisements)
    {
        NSLog(@"Advertisements are disabled, so not showing ads");
        return;
    }
    
    if(bought_watermarkpack)
    {
        NSLog(@"Pro version, so don't show the ads");
        return;
    }
    
    
    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    bannerView . delegate = self;
    bannerView.tag = TAG_BANNERAD_VIEW;
    // Specify the ad's "unit identifier". This is your AdMob Publisher ID.
    
    NSString *banner_ID  = admobpublishedid_iphone;
    CGRect     aRect     = CGRectMake(0, full_screen.size.height-topBarHeight , full_screen.size . width, 50);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        banner_ID = admobpublishedid_ipad;
        aRect = CGRectMake(0, full_screen.size.height-70, full_screen.size.width, 70);
    }
    
    bannerView.adUnitID = banner_ID;
    bannerView.frame = aRect;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView.rootViewController = self;
    [self.view addSubview:bannerView];
    [self.view bringSubviewToFront:customTabBar];
    
    // Initiate a generic request to load it with an ad.
    [bannerView loadRequest:[GADRequest request]];
    [bannerView release];
}

-(void)adViewDidReceiveAd:(GADBannerView *)view
{
    NSLog(@" Ad received.........");
    
    if (eMode == MODE_ADD_EFFECT) {
        return;
    }
    if (nvm.noAdMode) {
        return;
    }
    UIImageView *shareImageView = (UIImageView *)[self.view viewWithTag:2134];
    UIView  *proView = (UIView *)[self.view viewWithTag:5000];
    CGRect rect;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        rect = CGRectMake(0, full_screen.size.height-140, full_screen.size.width, 70);
    }else
    {
        rect = CGRectMake(0, full_screen.size.height-100, full_screen.size.width, 50);
    }
    
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         customTabBar.frame = rect;
                         [customTabBar setNeedsDisplay];
                         [self.view bringSubviewToFront:view];
                         if (shareImageView != nil)
                         {
                             [self.view bringSubviewToFront:shareImageView];
                         }
                         if (proView != nil) {
                             [self.view bringSubviewToFront:proView];
                         }
                         if (helpScreen != nil) {
                             [self.view bringSubviewToFront:helpScreen.view];
                         }
                     }
                     completion:nil ];
}

-(void)adView:(GADBannerView*)banner didFailToReceiveAdWithError:(GADRequestError*)error
{
    [self hideBannerAd];
}

-(void)hideBannerAd
{
    UIImageView *shareImageView = (UIImageView *)[self.view viewWithTag:2134];
    UIView   *proView = (UIView *)[self.view  viewWithTag:5000];
    GADBannerView *bannerView = (GADBannerView*)[self.view viewWithTag:TAG_BANNERAD_VIEW];
    if(nil != bannerView)
    {
        [bannerView removeFromSuperview];
    }
    
    CGRect rect;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        rect = CGRectMake(0, full_screen.size.height-70, full_screen.size.width, 70);
    }
    else
    {
        rect = CGRectMake(0, full_screen.size.height-50, full_screen.size.width, 50);
    }
    
    [UIView animateWithDuration:0.05 delay:0.05
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         customTabBar.frame = rect;
                         
                     }
                     completion:^(BOOL complete){
                         [self allocateUIForTabbar:rect];
                         if (shareImageView != nil)
                         {
                             [self.view bringSubviewToFront:shareImageView];
                         }
                         if (proView != nil) {
                             [self.view bringSubviewToFront:proView];
                         }
                         if (helpScreen != nil) {
                             [self.view bringSubviewToFront:helpScreen.view];
                         }
                     }
     ];
    
    return;
}
#endif

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (NO == nvm.connectedToInternet)
    {
        if (freeVersion)
        {
        if (bought_watermarkpack == NO)
            {
                [self hideBannerAd];
            }
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"shouldAutorotateToInterfaceOrientation");
    //return NO;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark comman exit function for settings
-(void)exitAnySettings
{
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView *v1 = (CMPopTipView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v1)
    {
        [v1 dismissAnimated:YES];
        [v1 release];
    }
    
    v1 = (CMPopTipView*)[self.view viewWithTag:TAG_COLORPICKER_TIPVIEW];
    if(nil != v1)
    {
        [v1 dismissAnimated:YES];
        [v1 release];
    }
    
    CMPopTipView *v = (CMPopTipView*)[self.view viewWithTag:TAG_ASPECTRATIO_TIPVIEW];
    if(nil != v)
    {
        [v dismissAnimated:YES];
        [v release];
    }
    
#else
    if(nil != sliders)
    {
        [sliders dismissModal];
        [sliders release];
        sliders = nil;
    }
    
    if(nil != colorAndPatternView)
    {
        [colorAndPatternView dismissModal];
        [colorAndPatternView release];
        colorAndPatternView = nil;
    }
    
    if(nil != aspectRatioView)
    {
        [aspectRatioView dismissModal];
        [aspectRatioView release];
        aspectRatioView = nil;
    }
#endif
    
    if(nil != sess)
    {
        [sess updateTheSessionIcon];
    }
    
    return;
}

#pragma mark inner and outer radius implementation
-(void)outerRadiusChanged:(UISlider*)slider
{
    
    /* needs to delete */
    [sess setOuterRadius:slider.value];
    
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView *v = (CMPopTipView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v)
    {
        [v setNeedsDisplay];
    }
#else
    //SNPopupView *v = (SNPopupView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    //if(nil != v)
    //{
    //    [v setNeedsDisplay];
    //}
#endif
}

-(void)innerRadiusChanged:(UISlider*)slider
{
    
    [sess setInnerRadius:slider.value];
    
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView *v = (CMPopTipView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v)
    {
        [v setNeedsDisplay];
    }
#else
    //SNPopupView *v = (SNPopupView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    //if(nil != v)
    //{
    //    [v setNeedsDisplay];
    //}
#endif
}

-(void)widthChanged:(UISlider*)slider
{
    
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView *v = (CMPopTipView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v)
    {
        [v setNeedsDisplay];
    }
    //#else
    SNPopupView *v = (SNPopupView*)[self.view viewWithTag:TAG_SLIDERS_TIPVIEW];
    if(nil != v)
    {
        [v setNeedsDisplay];
    }
#endif
    
    [sess setFrameWidth:slider.value];
    
    //v.hidden = NO;
}

-(void)showRadiusSettings:(id)sender fromFrame:(CGRect)fromRect
{
    /* First exit the settings menu if it exists */
    [self exitAnySettings];
    
    CGRect       rect              = CGRectMake(RADIUS_SETTINGS_X, RADIUS_SETTINGS_Y, RADIUS_SETTINGS_WIDTH, RADIUS_SETTINGS_HEIGHT);
    UISlider    *outerRadius       = nil;
    UISlider    *innerRadius       = nil;
    UIView *radiusSettingsBgnd = nil;
    UIFont *lblFont = [UIFont systemFontOfSize:14.0];
    float outerRadiusIndex = 10.0;
    float innerRadiusIndex = 50.0;
    float widthIndex       = 90.0;
    
    
    /* Set the background image */
    radiusSettingsBgnd = [[UIView alloc]initWithFrame:rect];
    radiusSettingsBgnd.alpha = 0.8;
    radiusSettingsBgnd.userInteractionEnabled = YES;
    radiusSettingsBgnd.tag = RADIUS_TAG_INDEX;
    
    UILabel *innerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+innerRadiusIndex, 150, 25)];
    innerRadiusLbl.tag = RADIUS_TAG_INDEX+1;
    innerRadiusLbl.font = lblFont;
    innerRadiusLbl.text = NSLocalizedString(@"INNERRADIUS", @"Inner Radius");
    innerRadiusLbl.textAlignment = UITextAlignmentLeft;
    innerRadiusLbl.backgroundColor = [UIColor clearColor];
    innerRadiusLbl.textColor = [UIColor whiteColor];
    
    //innerRadius = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+140.0, rect.origin.y+innerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 23.0)];
    innerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+140.0, rect.origin.y+innerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 23.0)];
    innerRadius.tag = RADIUS_TAG_INDEX+2;
    /* Configure the brush Slider  */
	innerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
	innerRadius.minimumValue     = 0.0;
	innerRadius.continuous       = YES;
	innerRadius.value            = sess.innerRadius;
    [innerRadius addTarget:self action:@selector(innerRadiusChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    UILabel *outerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+outerRadiusIndex, 150, 25)];
    outerRadiusLbl.tag =RADIUS_TAG_INDEX+3;
    outerRadiusLbl.text = NSLocalizedString(@"OUTERRADIUS",@"Outer Radius");
    outerRadiusLbl.font = lblFont;
    outerRadiusLbl.textAlignment = UITextAlignmentLeft;
    outerRadiusLbl.backgroundColor = [UIColor clearColor];
    outerRadiusLbl.textColor = [UIColor whiteColor];
    
    /* Allocate the slider */
    //outerRadius = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+140.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 23.0)];
    outerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+140.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 23.0)];
    outerRadius.tag = RADIUS_TAG_INDEX+4;
    /* Configure the brush Slider  */
	outerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
	outerRadius.minimumValue     = 0;
	outerRadius.continuous       = YES;
	outerRadius.value            = sess.outerRadius;
    
    [outerRadius addTarget:self action:@selector(outerRadiusChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    UILabel *widthLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+widthIndex, 150, 25)];
    widthLbl.tag =RADIUS_TAG_INDEX+5;
    widthLbl.text = NSLocalizedString(@"WIDTH",@"Width");
    widthLbl.font = lblFont;
    widthLbl.textAlignment = UITextAlignmentLeft;
    widthLbl.backgroundColor = [UIColor clearColor];
    widthLbl.textColor = [UIColor whiteColor];
    
    //UISlider *width = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+140.0, rect.origin.y+widthIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 24.0)];
    UISlider *width = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+140.0, rect.origin.y+widthIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 24.0)];
    width.tag = RADIUS_TAG_INDEX+6;
    /* Configure the brush Slider  */
	width.maximumValue     = 30;
	width.minimumValue     = 0;
	width.continuous       = YES;
	width.value            = sess.frameWidth;
    
    [width addTarget:self action:@selector(widthChanged:)
    forControlEvents:UIControlEventValueChanged];
    
    [radiusSettingsBgnd addSubview:innerRadiusLbl];
    [radiusSettingsBgnd addSubview:outerRadiusLbl];
    [radiusSettingsBgnd addSubview:innerRadius];
    [radiusSettingsBgnd addSubview:outerRadius];
    [radiusSettingsBgnd addSubview:widthLbl];
    [radiusSettingsBgnd addSubview:width];
    
    radiusSettingsBgnd.backgroundColor = [UIColor clearColor];
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView *sliders = [[CMPopTipView alloc]initWithCustomView:radiusSettingsBgnd];
    sliders.backgroundColor = [UIColor blackColor];
    sliders.alpha = 0.5;
    sliders.tag = TAG_SLIDERS_TIPVIEW;
    sliders.disableTapToDismiss = YES;
    UIBarButtonItem *bar = (UIBarButtonItem*)sender;
    [sliders presentPointingAtBarButtonItem:bar animated:YES];
#else
    sliders = [[SNPopupView alloc]initWithContentView:radiusSettingsBgnd contentSize:radiusSettingsBgnd.frame.size];
    //UIBarButtonItem *bar = (UIBarButtonItem*)sender;
    sliders.tag = TAG_SLIDERS_TIPVIEW;
    sliders.delegate = self;
    NSLog(@"SettingsBgnd (%f,%f,%f,%f)",radiusSettingsBgnd.frame.origin.x,radiusSettingsBgnd.frame.origin.y,radiusSettingsBgnd.frame.size.width,radiusSettingsBgnd.frame.size.height);
    //UIView *targetView = (UIView *)[bar performSelector:@selector(view)];
    //CGPoint tipPoint = CGPointMake(targetView.center.x, targetView.frame.origin.y+targetView.frame.size.height);
    CGPoint tipPoint = CGPointMake(fromRect.origin.x+fromRect.size.width/2.0, fromRect.origin.y);
    [sliders presentModalAtPoint:tipPoint inView:self.view];
#endif
    [width release];
    [widthLbl release];
    [radiusSettingsBgnd release];
    [innerRadiusLbl release];
    [outerRadius release];
    [innerRadius release];
    [outerRadiusLbl release];
    
    return;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch;
	CGPoint location;
    
	/* Get the location */
	touch    = [touches anyObject];
	location = [touch locationInView:self.view];
    
    CGRect settingsRect = CGRectMake(RADIUS_SETTINGS_X, RADIUS_SETTINGS_Y, RADIUS_SETTINGS_WIDTH, RADIUS_SETTINGS_HEIGHT);
    if(CGRectContainsPoint(settingsRect, location))
    {
        //[self exitRadiusSettings];
    }
    UIImageView *adjustImageView = (UIImageView *)[self.view viewWithTag:TAG_ADJUST_BG];
    UIImageView *previewImageView  = (UIImageView *)[self.view viewWithTag:TAG_PREVIEW_BGPAD];
    UIImageView *settings = (UIImageView *)[self.view viewWithTag:TAG_VIDEOSETTINGS_BGPAD];
    
    // [self releaseResourcesForColorAndPatternSettings_updated];
    if (isTouchWillDetect) {
        
        if (eMode == MODE_ADJUST_SETTINGS)
        {
            if ((location.y >adjustImageView.frame.origin.y+adjustImageView.frame.size.height) || (location.y < adjustImageView.frame.origin.y))
            {
                [self releaseResourcesForAdjustSettings];
                
            }
            
        }else if(eMode == MODE_COLOR_AND_PATTERN)
        {
            [self releaseResourcesForColorAndPatternSettings_updated];
            
        }else if (eMode == MODE_ADD_EFFECT)
        {
            [self releaseResourcesForEffects];
        }
        else if (eMode == MODE_VIDEO_SETTINGS)
        {
            if ((location.y >settings.frame.origin.y+settings.frame.size.height) || (location.y < settings.frame.origin.y))
            {
                [self releaseResourcesForVideoSetttings];
            }
            
            
        }else if (eMode == MODE_PREVIEW)
        {
            if ((location.y >previewImageView.frame.origin.y+previewImageView.frame.size.height) || (location.y < previewImageView.frame.origin.y))
            {
                [self releaseResourcesForPreview];
            }
        }
    }
    
}

#pragma mark color and pattern picker
-(void)colorPickerDidChangeSelection:(RSColorPickerView *)cp
{
    sess.color = [cp selectionColor];
    
    [pickerView setNeedsDisplay];
}

- (void)itemSelectedAtIndex:(int)index ofGridView:(GridView*)gView
{
    
    if(gView.tag == TAG_PATTERNPICKER)
    {
        NSLog(@"itemSelectedAtIndex %d of pattern picker",index);
        sess.pattern = index;
        
        return;
    }
    else
    {
        NSLog(@"itemSelectedAtIndex %d of unknown picker",index);
    }
}

#if CMTIPPOPVIEW_ENABLE
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    UIView *cView = nil;
    UIView *pView = nil;
    NSLog(@"popTipViewWasDismissedByUser");
    cView = [pickerView viewWithTag:TAG_COLORPICKER];
    if(nil != cView)
    {
        NSLog(@"Removing color picker");
        [cView removeFromSuperview];
    }
    
    pView = [pickerView viewWithTag:TAG_PATTERNPICKER];
    if(nil != pView)
    {
        NSLog(@"Removing pattern picker");
        [pView removeFromSuperview];
    }
    
    if(nil != pickerView)
    {
        [pickerView removeFromSuperview];
        pickerView = nil;
    }
    
    return;
}
#endif

- (void)didDismissModal:(SNPopupView*)popupview;
{
    UIView *cView = nil;
    UIView *pView = nil;
    NSLog(@"didDismissModal");
    cView = [pickerView viewWithTag:TAG_COLORPICKER];
    if(nil != cView)
    {
        NSLog(@"Removing color picker");
        [cView removeFromSuperview];
    }
    
    pView = [pickerView viewWithTag:TAG_PATTERNPICKER];
    if(nil != pView)
    {
        NSLog(@"Removing pattern picker");
        [pView removeFromSuperview];
    }
    
    pView = [pickerView viewWithTag:TAG_SLIDERS_TIPVIEW];
    {
        NSLog(@"Removing radius settings");
        [sess updateTheSessionIcon];
        [pView removeFromSuperview];
    }
    
    if(nil != pickerView)
    {
        [pickerView removeFromSuperview];
        pickerView = nil;
    }
    
    return;
}

-(UIView*)allocateColorPicker
{
    /* make sure that we ignore colo */
    UIView *pickerBg = [[UIView alloc]initWithFrame:CGRectMake(0.0, 40.0, 250.0, 200.0)];
#if defined(APP_INSTAPICFRAMES)
    /* RS color picker */
    RSColorPickerView *colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(40.0, 0.0, 150.0, 150.0)];
#else
    RSColorPickerView *colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(25.0, 0.0, 150.0, 150.0)];
#endif
	[colorPicker setDelegate:self];
	[colorPicker setBrightness:1.0];
	[colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
	[colorPicker setBackgroundColor:[UIColor clearColor]];
	
    /* Allocate bright ness slider */
    //RSBrightnessSlider *brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake((colorPicker.frame.origin.x + colorPicker.frame.size.width/2 + 30.0), (colorPicker.center.y-15.0), colorPicker.frame.size.width, 30.0*DEV_MULTIPLIER)];
    RSBrightnessSlider *brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake((colorPicker.frame.origin.x + colorPicker.frame.size.width/2.0 + 30.0), (colorPicker.center.y-15.0), colorPicker.frame.size.width, 30.0)];
	[brightnessSlider setColorPicker:colorPicker];
	[brightnessSlider setUseCustomSlider:YES]; // Defaults to NO
    brightnessSlider.layer.cornerRadius = 9.0;
    brightnessSlider.layer.masksToBounds = YES;
    brightnessSlider.layer.borderColor = [UIColor redColor].CGColor;
    brightnessSlider.layer.borderWidth = 3.0;
    brightnessSlider.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    /* Add color picker */
    [pickerBg addSubview:colorPicker];
    [pickerBg addSubview:brightnessSlider];
    
    /* Release memory for color pickers */
    [colorPicker release];
    [brightnessSlider release];
    
    pickerBg.tag = TAG_COLORPICKER;
    
    return pickerBg;
}

-(void)showColorAndPatternPicker:(id)sender
{
    [self exitAnySettings];
    
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 200)];
    pickerView.tag = TAG_COLORPICKER_BG;
    /* by default show the color picker */
    
    /* add segment control */
    NSArray *sgItems = [NSArray arrayWithObjects:NSLocalizedString(@"COLOR",@"Color"),NSLocalizedString(@"PATTERN",@"Pattern"), nil];
    UISegmentedControl *sgctrl = [[UISegmentedControl alloc]initWithItems:sgItems];
    sgctrl.frame = CGRectMake(0, 0, 150, 30);
    sgctrl.selectedSegmentIndex = 0;
    sgctrl.segmentedControlStyle = UISegmentedControlStyleBar;
    sgctrl.tintColor = [UIColor grayColor];
    sgctrl.center    = CGPointMake(pickerView.center.x, sgctrl.center.y);
    [sgctrl addTarget:self
               action:@selector(colorAndPalletSelectionChanged:)
     forControlEvents:UIControlEventValueChanged];
    [pickerView addSubview:sgctrl];
    [sgctrl release];
    
    UIView *pickerBg = [self allocateColorPicker];
    
    [pickerView addSubview:pickerBg];
    
    colorAndPatternView = [[SNPopupView alloc]initWithContentView:pickerView contentSize:pickerView.frame.size];
    colorAndPatternView.delegate = self;
    UIBarButtonItem *bar = (UIBarButtonItem*)sender;
    colorAndPatternView.tag = TAG_COLORPICKER_TIPVIEW;
    
    UIView *targetView = (UIView *)[bar performSelector:@selector(view)];
    CGPoint tipPoint = CGPointMake(targetView.center.x, targetView.frame.origin.y+targetView.frame.size.height);
    [colorAndPatternView presentModalAtPoint:tipPoint inView:self.view];
    
    /* relelase picker bg */
    [pickerBg release];
    [pickerView release];
    
    return;
}

#pragma mark Aspect Ratio UI
-(void)releaseAspectRatioMenu
{
#if CMTIPPOPVIEW_ENABLE
    CMPopTipView * v = (CMPopTipView*)[self.view viewWithTag:TAG_ASPECTRATIO_TIPVIEW];
    if(nil == v)
    {
        NSLog(@"releaseAspectRatioMenu: something is seriously wrong, CMPopTipView is nil");
        return;
    }
    
    [v dismissAnimated:NO];
    [v release];
#else
    if(nil == aspectRatioView)
    {
        NSLog(@"releaseAspectRatioMenu: something is seriously wrong, SNPopupView is nil");
        return;
    }
    
    [aspectRatioView dismissModal];
    aspectRatioView = nil;
#endif
    return;
}

-(void)performAspectRatioChange:(NSTimer*)theTimer
{
    NSNumber *num    = theTimer.userInfo;
    eAspectRatio eRat = [num intValue];
    
    /* Release aspect ratio menu */
    [self releaseAspectRatioMenu];
    
    /* No need to proceed further of the user selects the same aspect ratio */
    if(sess.aspectRatio == eRat)
    {
        [Utility removeActivityIndicatorFrom:self.view];
        return;
    }
    
    [sess setAspectRatio:eRat];
    
    UIToolbar *toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_EDIT];
    if(nil != toolBar)
    {
        UIBarButtonItem *itm = [toolBar.items objectAtIndex:8];
        itm.title = [NSString stringWithFormat:@"%d:%d",(int)nvm.wRatio,(int)nvm.hRatio];
    }
    
    [Utility removeActivityIndicatorFrom:self.view];
}

-(void)aspectRatioChanged:(id)sender
{
    UIButton *btn     = sender;
    eAspectRatio eRat = btn.tag - TAG_ASPECTRATIO_BUTTON;
    NSNumber *num     = [NSNumber numberWithInt:eRat];
    
    /* First show the activity indicator */
    [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"PROCESSING", @"Processing")];
    
    /* Schdule the timer to process the aspect ratio change */
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(performAspectRatioChange:) userInfo:num repeats:NO];
    
    return;
}

-(void)showAspectRatioMenu:(id)sender
{
    [self exitAnySettings];
    
    int index = 0;
    UIScrollView *aspectRatioMenu = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 295, 60)];
    aspectRatioMenu.tag = TAG_ASPECTRATIO_BG;
    aspectRatioMenu.scrollEnabled = YES;
    aspectRatioMenu.bounces = YES;
    aspectRatioMenu.alwaysBounceHorizontal = YES;
    float aspectButtonWidth = aspectRatioMenu.frame.size.width/6;
    float aspectButtonY     = 4.0;
    float aspectButtonX     = 0.0;
    for(index = 0; index < ASPECTRATIO_MAX; index++)
    {
        UIButton *aspect = [[UIButton alloc]initWithFrame:CGRectMake(aspectButtonX, aspectButtonY, aspectButtonWidth, aspectButtonWidth)];
        CGPoint cntr = aspect.center;
        CGSize  ratio = [Settings aspectRatioToValues:index];
        float   maxRatio = (ratio.width > ratio.height)?ratio.width:ratio.height;
        aspect.frame = CGRectMake(aspect.frame.origin.x, aspect.frame.origin.y, aspect.frame.size.width * ratio.width / maxRatio, aspect.frame.size.height * ratio.height / maxRatio);
        aspect.center = CGPointMake(aspect.center.x, cntr.y);
        aspect.tag = TAG_ASPECTRATIO_BUTTON + index;
        aspect.layer.cornerRadius = 5.0;
        aspectButtonX = aspectButtonX + aspect.frame.size.width + 10.0;
        [aspect addTarget:self action:@selector(aspectRatioChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *title = [NSString stringWithFormat:@"%d:%d",(int)ratio.width,(int)ratio.height];
        if(nvm.aspectRatio == index)
        {
            aspect.backgroundColor = PHOTO_DEFAULT_COLOR;
        }
        else
        {
            aspect.backgroundColor = [UIColor whiteColor];
        }
        
        [aspect setTitle:title forState:UIControlStateNormal];
        aspect.titleLabel.font            = [UIFont boldSystemFontOfSize: 12];
        aspect.titleLabel.lineBreakMode   = UILineBreakModeTailTruncation;
        aspect.titleLabel.textColor       = [UIColor blackColor];
        [aspectRatioMenu addSubview:aspect];
        [aspect release];
        aspectRatioMenu.contentSize = CGSizeMake(aspectButtonWidth * index + 70.0, 50.0);
    }
#if CMTIPPOPVIEW_ENABLE
    /* add it on top of tipview */
    CMPopTipView *aspectRatioView = [[CMPopTipView alloc]initWithCustomView:aspectRatioMenu];
    aspectRatioView.backgroundColor = DARK_GRAY_BG;
    aspectRatioView.alpha = 0.5;
    aspectRatioView.tag = TAG_ASPECTRATIO_TIPVIEW;
    aspectRatioView.disableTapToDismiss = YES;
    
    [aspectRatioMenu release];
    UIBarButtonItem *bar = (UIBarButtonItem*)sender;
    [aspectRatioView presentPointingAtBarButtonItem:bar animated:YES];
#else
    aspectRatioView      = [[SNPopupView alloc]initWithContentView:aspectRatioMenu contentSize:aspectRatioMenu.frame.size];
    UIBarButtonItem *bar = (UIBarButtonItem*)sender;
    aspectRatioMenu.tag  = TAG_ASPECTRATIO_TIPVIEW;
    UIView *targetView   = (UIView *)[bar performSelector:@selector(view)];
    CGPoint tipPoint     = CGPointMake(targetView.center.x, targetView.frame.origin.y+targetView.frame.size.height);
    [aspectRatioView presentModalAtPoint:tipPoint inView:self.view];
#endif
}

#pragma mark save

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        NSLog(@"Successfuly saved the image");
    }
    else
    {
        /* update the status */
        NSLog(@"failed to save the image");
    }
    
    return;
}

-(void)saveImage
{
    UIImage *img = [sess.frame renderToImageOfSize:CGSizeMake(2400, 2400)];
    
    if(nil != img)
    {
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }
    else
    {
        NSLog(@"Image is NULL to save ");
    }
}

#pragma mark clear implementation
-(void)clearSessionAnimationStoped:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    int index = 0;
    for(index = 0; index < MAX_PHOTOS_SUPPORTED; index++)
    {
        UIImageView *v = (UIImageView*)[self.view viewWithTag:(index + TAG_CLEARANIMATION)];
        [v removeFromSuperview];
    }
    
    [sess updateTheSessionIcon];
}

-(void)clearCurImage
{
    //UIBarButtonItem *dest             = (UIBarButtonItem*)sender;
    int             index             = 0;
    NSMutableArray *viewsForAnimation = [sess eraseCurImageAndReturnImageForAnimation];
    UIView *targetView                = (UIView *)[viewsForAnimation objectAtIndex:0];
    
    for(index = 0; index < [viewsForAnimation count]; index++)
    {
        UIImageView *img = [viewsForAnimation objectAtIndex:index];
        CGRect rect = [sess.frame convertRect:img.frame toView:self.view];
        img.frame   = rect;
        img.tag     = TAG_CLEARANIMATION + index;
        [self.view addSubview:img];
    }
    
    
    CAKeyframeAnimation *rotationAnimation;
    rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.values = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0 * M_PI],
                                [NSNumber numberWithFloat:0.75 * M_PI],
                                [NSNumber numberWithFloat:1.5 * M_PI],
                                [NSNumber numberWithFloat:2.0 * M_PI], nil];
    rotationAnimation.calculationMode = kCAAnimationPaced;
    
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 0.5;
    
    [UIView beginAnimations:@"ClearTheSessionAnimation" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(clearSessionAnimationStoped:finished:context:)];
    [UIView setAnimationDuration:0.5f];
    
    /* Now Animate the view */
    for(index = 0; index < [viewsForAnimation count]; index++)
    {
        UIImageView *img = [viewsForAnimation objectAtIndex:index];
        img.frame        = CGRectMake(targetView.center.x, targetView.center.y, 0, 0);
        [img.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        //img.frame        = targetView.frame;
    }
    [UIView commitAnimations];
    
    [viewsForAnimation release];

}

-(void)clearTheSession:(id)sender
{
    UIBarButtonItem *dest             = (UIBarButtonItem*)sender;
    int             index             = 0;
    NSMutableArray *viewsForAnimation = [sess eraseAndReturnImagesForAnimation];
    UIView *targetView                = (UIView *)[dest performSelector:@selector(view)];
    
    for(index = 0; index < [viewsForAnimation count]; index++)
    {
        UIImageView *img = [viewsForAnimation objectAtIndex:index];
        CGRect rect = [sess.frame convertRect:img.frame toView:self.view];
        img.frame   = rect;
        img.tag     = TAG_CLEARANIMATION + index;
        [self.view addSubview:img];
    }
    
    
    CAKeyframeAnimation *rotationAnimation;
    rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.values = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0 * M_PI],
                                [NSNumber numberWithFloat:0.75 * M_PI],
                                [NSNumber numberWithFloat:1.5 * M_PI],
                                [NSNumber numberWithFloat:2.0 * M_PI], nil];
    rotationAnimation.calculationMode = kCAAnimationPaced;
    
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 0.5;
    
    [UIView beginAnimations:@"ClearTheSessionAnimation" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(clearSessionAnimationStoped:finished:context:)];
    [UIView setAnimationDuration:0.5f];
    
    /* Now Animate the view */
    for(index = 0; index < [viewsForAnimation count]; index++)
    {
        UIImageView *img = [viewsForAnimation objectAtIndex:index];
        img.frame        = CGRectMake(targetView.center.x, targetView.center.y, 0, 0);
        [img.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        //img.frame        = targetView.frame;
    }
    [UIView commitAnimations];
    
    
    [viewsForAnimation release];
}

#pragma mark help implementation
-(void)perform_Help
{
    helpScreen = [[HelpScreenViewController alloc] init];
    
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        isTouchWillDetect = NO;
                        [self.view addSubview:helpScreen.view];
                        [self.view bringSubviewToFront:helpScreen.view];
                        
                    }
                    completion:nil ];
    
    
}

#pragma utility functions mainly to clean the resources
-(void)releaseToolBarIfAny
{
    
    UIToolbar *toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_EDIT];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_FRAMES];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_SWAP];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_SHARE];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_FREEAPPS];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_ADJUST];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_PREVIEW];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_SETTINGS];
    if(nil != toolBar)
    {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
    toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_EFFECT];
    if (nil!= toolBar) {
        [toolBar removeFromSuperview];
        toolBar = nil;
    }
}

#pragma mark tabbar implementation


- (void)showAppoxee:(id)sender
{
    
    //Ask the Appoxee to appear (only for modal mode)
    //[[AppoxeeManager sharedManager] show];
    [self showStore];
}

-(void)inAppPurchasePreviewWillExit:(InAppPurchasePreview *)gView
{
    self.navigationController.navigationBarHidden = YES;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [[configparser Instance] showAdInView:self.view atLocation:CGPointMake(self.view.frame.size.width-adviewsize-adviewdistancefromwall, adviewdistancefromwall+80)];
    }else
    {
        [[configparser Instance] showAdInView:self.view atLocation:CGPointMake(self.view.frame.size.width-adviewsize-adviewdistancefromwall, adviewdistancefromwall+50)];
    }

}

-(void)restoreDidSelectForInAppPurchasePreview:(InAppPurchasePreview *)gView
{
    [[InAppPurchaseManager Instance]restoreProUpgrade];
}

-(void)inAppPurchasePreview:(InAppPurchasePreview *)gView itemPurchasedAtIndex:(int)index
{
    
    [[InAppPurchaseManager Instance]puchaseProductWithId:kInAppPurchaseRemoveWaterMarkPack];
}

-(void)showStore
{
    InAppPurchasePreview *preview = [[InAppPurchasePreview alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:preview];
    preview.delegate = self;
    
    
    NSString *watermarkPackPrice = [[InAppPurchaseManager Instance]getPriceOfProduct:kInAppPurchaseRemoveWaterMarkPack];
    NSString *watermarkPackTitle = [[InAppPurchaseManager Instance]getTitleOfProduct:kInAppPurchaseRemoveWaterMarkPack];
    NSString *watermarkPackDescription = [[InAppPurchaseManager Instance]getDescriptionOfProduct:kInAppPurchaseRemoveWaterMarkPack];
    
    
    if(nil == watermarkPackPrice)
    {
        watermarkPackPrice = DEFAULT_WATERMARK_PACK_PRICE;
        watermarkPackTitle = DEFAULT_WATERMARK_PACK_TITLE;
        watermarkPackDescription = DEFAULT_WATERMARK_PACK_DESCRIPTION;
    }
    
    NSArray *framesPackKeys = [NSArray arrayWithObjects:key_inapppreview_package_image,key_inapppreview_package_price,key_inapppreview_package_msgheading, key_inapppreview_package_msgbody,nil];
    
    NSArray *watermarkPackObjs = [NSArray arrayWithObjects:watermarkPackPrice,watermarkPackTitle, watermarkPackDescription,nil];
    NSArray *watermarkPackKeys = [NSArray arrayWithObjects:key_inapppreview_package_price,key_inapppreview_package_msgheading, key_inapppreview_package_msgbody,nil];
    NSDictionary *watermarkPack = [NSDictionary dictionaryWithObjects:watermarkPackObjs forKeys:watermarkPackKeys];
    
    NSArray *packages = [NSArray arrayWithObjects:watermarkPack, nil];
    
    [preview showInAppPurchaseWithPackages:packages];


    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [[configparser Instance] showAdInView:self.view atLocation:CGPointMake(self.view.frame.size.width-adviewsize-adviewdistancefromwall, adviewdistancefromwall+120)];
    }else
    {
        [[configparser Instance] showAdInView:self.view atLocation:CGPointMake(self.view.frame.size.width-adviewsize-adviewdistancefromwall, adviewdistancefromwall+100)];
    }

}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _appoxeeBadge = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, customBarHeight, customBarHeight)];
        [_appoxeeBadge addTarget:self action:@selector(showAppoxee:) forControlEvents:UIControlEventTouchDown];
        [_appoxeeBadge setImage:[UIImage imageNamed:@"357-store.png"] forState:UIControlStateNormal];
    }
    return self;
}

-(void)updateNewsBadgeTo:(NSString*)badge flashState:(BOOL)flash
{
    //[[AppoxeeManager sharedManager] addBadgeToView:_appoxeeBadge badgeText:[[NSUserDefaults standardUserDefaults] objectForKey:@"Appoxeebadge"] badgeLocation:CGPointMake(0,0) shouldFlashBadge:flash];
}

-(void)releaseResourcesForEdit
{
    [self releaseToolBarIfAny];
    
    return;
}

-(void)allocateResourcesForEdit
{
    [self releaseToolBarIfAny];
    [self addToolbarWithTitle:@"Select Images" tag:TAG_TOOLBAR_EDIT];
    
    if(nil == sess)
    {
        [self loadTheSession];
    }
    
    return;
}

-(void)selectEditTab
{
    //[self allocateResourcesForEdit];
#if STANDARD_TABBAR
    UITabBarItem *edit = (UITabBarItem*)[[tabBar items] objectAtIndex:1];
    [self tabBar:tabBar didSelectItem:edit];
    [tabBar setSelectedItem:edit];
#else
    //[customTabBar setSelectedItem:1];
    [self releaseResourcesForModeChange];
    [customTabBar unselectCurrentSelectedTab];
    
    [self allocateResourcesForEdit];
    
    eMode = MODE_MAX;
#endif
}

-(void)frameSelectedAtIndex:(int)index ofGridView:(FrameGridView *)gView
{
    sess.frameNumber   = index;
    sess. frameWidth   = 10.0;
    sess . innerRadius = 0.0;
    sess . outerRadius = 0.0;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(selectEditTab) userInfo:nil repeats:NO];
}

-(void)allocateResourcesForFrames
{
    FrameSelectionController *sc = [FrameSelectionController alloc];
    
    if(nil == sc)
    {
        return;
    }
    
    [self.navigationController presentModalViewController:sc animated:NO];
    
    [sc release];
    
    return;
}

-(void)releaseResourcesForFrames
{
    
    /* Release tool bar if available */
    [self releaseToolBarIfAny];
    
#if defined(APP_INSTAPICFRAMES)
    /* release grid view */
    FrameGridView *fgv = (FrameGridView*)[self.view viewWithTag:TAG_EVENFRAME_GRIDVIEW];
    if(nil != fgv)
    {
        [fgv removeFromSuperview];
    }
#endif
    
    self.navigationController.navigationBarHidden = YES;
    [sess showSessionOn:self.view];
    
#if defined(APP_INSTAPICFRAMES)
    self.title = NSLocalizedString(@"APPNAME",@"InstapicFrames");
#elif defined(APP_PICCELLS)
    self.title = @"PicCells";
#endif
}

-(void)togglePreviewState:(UIButton*)sender
{
    
    if(sender.tag == TAG_PREVIEW_PAUSE)
    {
        sender.tag = TAG_PREVIEW_PLAY;
        [sender setImage:[UIImage imageNamed:@"playNew"] forState:UIControlStateNormal];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [sender setImage:[UIImage imageNamed:@"play_ipad"] forState:UIControlStateNormal];
            
        }
        [self pausePreView];
    }
    else if(sender.tag == TAG_PREVIEW_PLAY)
    {
        sender.tag = TAG_PREVIEW_PAUSE;
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [sender setImage:[UIImage imageNamed:@"pause_ipad"] forState:UIControlStateNormal];
            
        }
        [self resumePreview];
    }
}

-(NSString*)getCurrentPreviewTime
{
    int totalTime = gTotalPreviewFrames * (1.0/30.0);
    int elapsedTime= 0;
    if (isSequentialPlay) {
       elapsedTime = gPreviewFrameCounterVariable * (1.0/30.0);
    }else
    {
      elapsedTime =  gCurPreviewFrameIndex*(1.0/30.0);
    }
    int remainingSeconds = totalTime-elapsedTime;
    
    int mins = remainingSeconds/60;
    int seconds = remainingSeconds%60;
    
    return [NSString stringWithFormat:@"%d:%d",mins,seconds];
}

/*
-(void)generateVideoFromImage
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    [imageArray addObject:[sess.frame renderToImageOfSize:nvm.uploadSize]];
    for (int photoNumber = 0; photoNumber< sess.frame.photoCount; photoNumber++)
    {
        for (int index = 0; index<30; index++)
        {
            
            Photo *pht = [sess.frame getPhotoAtIndex:photoNumber];
            
            UIImage *image = pht.image;
            UIImageView *maskImage = [[UIImageView alloc] init];
            maskImage.frame = CGRectMake(0, 0, sess.frame.frame.size.width, sess.frame.frame.size.height);
            maskImage . image  = image;
            [sess.frame addSubview:maskImage];
          //  [imageArray addObject:image];
            if (index == 0) {
                UIImageWriteToSavedPhotosAlbum([imageArray objectAtIndex:0], self, nil, nil);
                UIImageWriteToSavedPhotosAlbum([sess.frame renderToImageOfSize:nvm.uploadSize], self, nil, nil);
            
            }
        }
        
    }
    NSLog(@" FINISHED");

}
 */
-(void)allocateResourcesForPreview:(OT_TabBarItem*)tItem
{
    /* check if it is video frame, if not exit from preview */
    if(NO == [sess anyVideoFrameSelected])
    {
        [self releaseToolBarIfAny];
        [self selectEditTab];
        eMode = MODE_MAX;
        [WCAlertView showAlertWithTitle:@"Info"
                                message:@"No Videos selected to show video preview. Select one or more videos to preview the video"
                     customizationBlock:nil
                        completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
         {
             [customTabBar unselectCurrentSelectedTab];
         }
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];
        return;
    }
    
    UIToolbar *toolBar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR_PREVIEW];
    if(nil != toolBar)
    {
        return;
    }
    
    [self releaseToolBarIfAny];
    [self addToolbarWithTitle:@"Preview" tag:TAG_TOOLBAR_PREVIEW];
    
    CGRect blockTouchRect = CGRectMake(0, 00, full_screen.size.width,customTabBar.frame.origin.y+customTabBar.frame.size.height+colorBackgroundBarHeightHeight);
    
    UIView *blockTouches = [[UIView alloc]initWithFrame:blockTouchRect];
    blockTouches.userInteractionEnabled = YES;
    blockTouches.tag = TAG_PREVIEW_BLOCKTOUCHES;
    [self.view addSubview:blockTouches];
    
    UIImageView *previewControlsBgnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, customTabBar.frame.origin.y, full_screen.size.width, 0)];
    previewControlsBgnd . userInteractionEnabled = YES;
    previewControlsBgnd . image = [UIImage imageNamed:@"color-gallery-strip.png"];
    previewControlsBgnd . tag = TAG_PREVIEW_BGPAD;
    [self.view addSubview:previewControlsBgnd];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, customBarHeight/4, customBarHeight/2, customBarHeight/2);
    button.tag = TAG_PREVIEW_PAUSE;
    [button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [button setImage:[UIImage imageNamed:@"pause_ipad"] forState:UIControlStateNormal];
        
    }
    
    [button addTarget:self action:@selector(togglePreviewState:) forControlEvents:UIControlEventTouchUpInside];
    
    
    previewTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(previewControlsBgnd.frame.size.width-30, 0, 25, customBarHeight)];
    previewTimeLabel.backgroundColor = [UIColor clearColor];
    previewTimeLabel.textColor = [UIColor whiteColor];
    previewTimeLabel.font = [UIFont boldSystemFontOfSize:12.0];
    previewTimeLabel.text = [self getCurrentPreviewTime];
    
    
    previewAdjSlider = [CustomUI allocateCustomSlider:CGRectMake(button.frame.origin.x+button.frame.size.width+5, 0, previewControlsBgnd.frame.size.width-button.frame.size.width-button.frame.origin.x-15-previewTimeLabel.frame.size.width, customBarHeight)];
    previewAdjSlider.tag = RADIUS_TAG_INDEX+2;
    /* Configure the brush Slider  */
	previewAdjSlider.maximumValue     = [sess getFrameCountOfFrame:sess.frame];
	previewAdjSlider.minimumValue     = 0;
	previewAdjSlider.continuous       = NO;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        previewControlsBgnd.frame = CGRectMake(0, customTabBar.frame.origin.y-customBarHeight, full_screen.size.width, customBarHeight);
        
    }completion:^(BOOL finished)
     {
         [previewControlsBgnd addSubview:button];
         [previewControlsBgnd addSubview:previewTimeLabel];
         [previewTimeLabel release];
         [previewControlsBgnd addSubview:previewAdjSlider];
         [previewAdjSlider release];
     }];
    
    
    [self previewVideo];
}

-(void)releaseResourcesForPreview
{
    
    if(NO == gIsPreviewInProgress)
    {
        
        [self releaseToolBarIfAny];
        [self addToolbarWithTitle:@"Select Image" tag:TAG_TOOLBAR_EDIT];
        UIView *blockTouches = [self.view viewWithTag:TAG_PREVIEW_BLOCKTOUCHES];
        if(nil != blockTouches)
        {
            [blockTouches removeFromSuperview];
        }
        
        [preViewControls dismissAnimated:NO];
        [preViewControls release];
        preViewControls = nil;
        
        UIImageView *previewImageView  = (UIImageView *)[self.view viewWithTag:TAG_PREVIEW_BGPAD];
        NSArray *viewToRemove = [previewImageView subviews];
        for (UIView *v in viewToRemove)
        {
            [v removeFromSuperview];
            
        }
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            previewImageView.frame = CGRectMake(0, customTabBar.frame.origin.y, full_screen.size.width, 0);
            
        }completion:^(BOOL finished)
         {
             [previewImageView removeFromSuperview];
         }];
    }
    else
    {
        /* Make sure that we stop preview if it is going on */
        [self stopPreview];
    }
    
    
}

-(UIView*)allocateVideoSettingsCellWithRect:(CGRect)rect
{
    UIImageView *bgnd = [[UIImageView alloc]initWithFrame:rect];
    UIImageView *color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgnd.frame.size.width, bgnd.frame.size.height)];
    color.backgroundColor = DARK_GRAY_BG;
    color.alpha = 0.3;
    [bgnd addSubview:color];
    [color release];
    
    /* Enable user interaction for the views */
    bgnd.userInteractionEnabled = YES;
    color.userInteractionEnabled = YES;
    
    return bgnd;
}

-(UIView*)allocateVideoSettingsCellWithRect:(CGRect)rect
                                      title:(NSString*)title
{
    UIView *cell = [self allocateVideoSettingsCellWithRect:rect];
    
    /* Add title to it */
    UILabel *songTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    songTitle.backgroundColor = [UIColor clearColor];
    songTitle.text = title;
    songTitle.textColor = [UIColor whiteColor];
    songTitle.font = [UIFont boldSystemFontOfSize:16];
    songTitle.textAlignment = UITextAlignmentCenter;
    [cell addSubview:songTitle];
    [songTitle release];
    cell.userInteractionEnabled = YES;
    
    return cell;
}

-(UIView*)allocateVideoSettingsCellWithRect:(CGRect)rect
                                      title:(NSString*)title
                                      image:(UIImage*)img
                                     enable:(BOOL)enableStatus
{
    UIView *cell         = [self allocateVideoSettingsCellWithRect:rect];
    float   imageSize    = cell.frame.size.height;
    float   switchWidth  = cell.frame.size.height + 10;
    float   switchHeight = cell.frame.size.height;
    int   imageBoderSize = 5;
    
    /* Add title to it */
    UILabel *songTitle = [[UILabel alloc]initWithFrame:CGRectMake(imageSize, 0, cell.frame.size.width-imageSize-switchWidth, cell.frame.size.height)];
    songTitle.backgroundColor = [UIColor clearColor];
    songTitle.text = title;
    songTitle.textColor = [UIColor whiteColor];
    songTitle.font = [UIFont boldSystemFontOfSize:16];
    songTitle.textAlignment = UITextAlignmentCenter;
    songTitle.tag = TAG_AUDIO_CELL_TITLE;
    [cell addSubview:songTitle];
    [songTitle release];
    
    /* Add image to it */
    UIImageView *albumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageBoderSize, imageBoderSize, imageSize-imageBoderSize-imageBoderSize, imageSize-imageBoderSize-imageBoderSize)];
    albumImageView.image = img;
    albumImageView.tag = TAG_AUDIO_CELL_IMAGE;
    [cell addSubview:albumImageView];
    [albumImageView release];
    
    
    /* Add switch */
    UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(cell.frame.size.width-switchWidth, 15, switchWidth, switchHeight)];
    swit.on = enableStatus;
    swit.tag = TAG_AUDIO_CELL_SWITCH;
    [cell addSubview:swit];
    
    /* Add action to switch */
    [swit addTarget:self
             action:@selector(handleUpadteAudioFromLibraraySwitchStatus:)
   forControlEvents:UIControlEventValueChanged];
    
    [swit release];
    
    return cell;
}
-(UIView*)allocateSquentialPlayButtonCellWithRect:(CGRect)rect  enable:(BOOL)enableStatus
{
    UIView *cell         = [self allocateVideoSettingsCellWithRect:rect];
    float   labelSize    = cell.frame.size.height;
    float   switchWidth  = cell.frame.size.height + 10;
    float   switchHeight = cell.frame.size.height;
    
    
    UILabel *songTitle = [[UILabel alloc]initWithFrame:CGRectMake(labelSize, 0, cell.frame.size.width-labelSize-switchWidth, cell.frame.size.height)];
    songTitle.backgroundColor = [UIColor clearColor];
    songTitle.text = @"SequentialPlay";
    songTitle.textColor = [UIColor whiteColor];
    songTitle.font = [UIFont boldSystemFontOfSize:16];
    songTitle.textAlignment = UITextAlignmentCenter;
   // songTitle.tag = TAG_AUDIO_CELL_TITLE;
    [cell addSubview:songTitle];
    [songTitle release];
    
    /* Add switch */
    UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(cell.frame.size.width-switchWidth, 15, switchWidth, switchHeight)];
    swit.on = enableStatus;
    swit.tag = TAG_SQUENTIAL_CELL_SWITCH;
    
    /* Add action to switch */
    [swit addTarget:self
             action:@selector(handleUpdateFromSquentialPlaySwitchStatus:)
   forControlEvents:UIControlEventValueChanged];
    [cell addSubview:swit];
   
    [swit release];
    
    return cell;

}

-(void)handleUpadteAudioFromLibraraySwitchStatus:(UISwitch*)swit
{
    /* Store enable status */
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:swit.on]
                                             forKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY];
    [sess handleVideoFrameSettingsUpdate];
    [sess deleteCurrentAudioMix];
}
-(void)handleUpdateFromSquentialPlaySwitchStatus:(UISwitch *)swt
{
    if (swt.on)
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:swt.on]
                                                 forKey:KEY_USE_SEQUENTIAL_Play_STATUS];
        isSequentialPlay = TRUE;
        [self setTheDefaultOrderArray];
        UIImageView *settingImageView = (UIImageView *)[self.view viewWithTag:TAG_VIDEOSETTINGS_BGPAD];
        CGRect rect = CGRectMake(0,settingImageView.frame.origin.y , full_screen.size.width, 0);
        [self addVideoGrid:rect];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:swt.on]
                                                 forKey:KEY_USE_SEQUENTIAL_Play_STATUS];
        isSequentialPlay = FALSE;
        UIImageView *gridBackGroundView = (UIImageView *)[self.view viewWithTag:TAG_VIDEOGRIDVIEW];
        [gridBackGroundView removeFromSuperview];
    }
    
    [sess handleVideoFrameSettingsUpdate];
    
    [sess deleteCurrentAudioMix];

}

-(void)addVideoGrid:(CGRect) aRect
{
    [videoImageInfo removeAllObjects];
    [sess handleVideoFrameSettingsUpdate];
    [sess deleteCurrentAudioMix];
    
    if ( dictionary != nil) {
        [dictionary removeAllObjects];
        [dictionary release];
        dictionary = nil;
    }
    dictionary = [[NSMutableDictionary alloc] init];
    int photoIndex = 0;
    for (int index = 0; index<sess.frame.photoCount; index++)
    {
        eFrameResourceType type = [sess getFrameResourceTypeAtIndex:index];

        if (type == FRAME_RESOURCE_TYPE_VIDEO)
        {
            UIImage *image = [sess getVideoFrameAtIndex:1 forPhoto:index];
            [videoImageInfo addObject:image];
            [dictionary setObject:[NSNumber numberWithInt:index] forKey:[NSNumber numberWithInt:photoIndex]];
            photoIndex++;
            
        }
    }
    if (photoIndex == 0) {
        return;
    }
    [WCAlertView showAlertWithTitle:@"Help" message:@"To select video longpress on video item and move using your finger to alter order of videos" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    UIImageView *gridBackGroundView = [[UIImageView alloc] init];
    gridBackGroundView . userInteractionEnabled = YES;
    gridBackGroundView . backgroundColor = [UIColor greenColor];
    gridBackGroundView . tag   =  TAG_VIDEOGRIDVIEW;
    gridBackGroundView . frame = CGRectMake(0,aRect.origin.y, aRect.size.width, 0);
    gridBackGroundView . image = [UIImage imageNamed:@"gridPopupBg.png"];
    gridBackGroundView . layer . borderColor = [UIColor cyanColor].CGColor;
    gridBackGroundView . layer . borderWidth = 2.0;
    [self.view addSubview:gridBackGroundView];
    
    [videoImageInfo retain];
    
    if (gridView != nil)
    {
        [gridView.view removeFromSuperview];
        gridView = nil;
    }
    gridView = [[VideoGridViewViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    gridView . frameOfView = CGRectMake(0, 0, full_screen.size.width, videoGridViewHeight);
    gridView . totalNumberOfItems = [videoImageInfo count];
    gridView . imageArray = videoImageInfo;
    
    if ([orderArrayForVideoItems count]>0)
    {
        [orderArrayForVideoItems removeAllObjects];
    }

    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        gridBackGroundView . frame =   CGRectMake(0, aRect.origin.y-videoGridViewHeight, full_screen.size.width, videoGridViewHeight);
        
    }completion:^(BOOL finished)
     {
         [gridBackGroundView addSubview:gridView.view];
        
     }];
}

-(void)setTheDefaultOrderArray
{
    NSLog(@"setTheDefaultOrderArray");
    if ([orderArrayForVideoItems count]>0)
    {

        [orderArrayForVideoItems removeAllObjects];
    }
    for (int index = 0; index<sess.frame.photoCount; index++)
    {
        eFrameResourceType type = [sess getFrameResourceTypeAtIndex:index];
        
        if (type == FRAME_RESOURCE_TYPE_VIDEO)
        {
        NSLog(@"ORDER OF ARRAY :%@", orderArrayForVideoItems);
            [orderArrayForVideoItems addObject:[NSNumber numberWithInt:index]];
        }
    }
}

-(void)audioCell:(UIView*)cell setTitle:(NSString*)title
{
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:TAG_AUDIO_CELL_TITLE];
    if(nil == titleLabel)
    {
        return;
    }
    
    titleLabel.text = title;
    
    return;
}

-(void)audioCell:(UIView*)cell setImage:(UIImage*)image
{
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:TAG_AUDIO_CELL_IMAGE];
    if(nil == imgView)
    {
        NSLog(@"imageView is nil");
        return;
    }
    
    imgView.image = image;
    
    return;
}

-(void)audioCell:(UIView*)cell setStatus:(BOOL)enableStatus
{
    UISwitch *swit = (UISwitch*)[cell viewWithTag:TAG_AUDIO_CELL_SWITCH];
    if(nil == swit)
    {
        return;
    }
    
    swit.on = enableStatus;
    
    /* Store enable status */
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:enableStatus]
                                             forKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY];
    
    return;
}

-(void)showAudioPicker
{
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    
    picker.delegate                     = self;
    picker.allowsPickingMultipleItems   = NO;
    picker.prompt                       = NSLocalizedString (@"Select any song from the list", @"Prompt to user to choose some songs to play");
    
    [self presentModalViewController: picker animated: YES];
    [picker release];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
}


-(NSURL*)getUrlFromMediaItemId:(NSNumber*)persistentId
{
    /* Get the title from the media item */
    MPMediaItem *mItem = [self getMediaItemFromMediaItemId:persistentId];
    
    return [mItem valueForProperty:MPMediaItemPropertyAssetURL];
}

-(UIImage*)getImageFromMediaItem:(MPMediaItem*)mItem
{
    /* Extract artwork and title and assign it to Audio Cell */
    MPMediaItemArtwork *itemArtwork = [mItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artWorkImage = nil;
    
    if (itemArtwork != nil)
    {
        artWorkImage = [itemArtwork imageWithSize:CGSizeMake(250.0, 250.0)];
    }
    
    return artWorkImage;
}

-(NSString*)getTitleFromMediaItem:(MPMediaItem*)mItem
{
    NSString *title = [mItem valueForProperty:MPMediaItemPropertyTitle];
    
    return title;
}

-(MPMediaItem*)getMediaItemFromMediaItemId:(NSNumber*)persistentId
{
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:persistentId
                                                                           forProperty:MPMediaItemPropertyPersistentID];
    [query addFilterPredicate:predicate];
    
    /* Query for media items */
    NSArray *mediaItems = [query items];
    NSLog(@" Media item :%@", mediaItems);
    if(nil == mediaItems || [mediaItems count]==0)
    {
        return nil;
    }
    
    /* Get the title from the media item */
    MPMediaItem *mediaItem = [mediaItems objectAtIndex:0];
    
    return mediaItem;
}

-(NSString*)getTitleFromMediaItemId:(NSNumber *)persistentId
{
    /* Get the title from the media item */
    MPMediaItem *mediaItem = [self getMediaItemFromMediaItemId:persistentId];
    
    return [self getTitleFromMediaItem:mediaItem];
}

-(UIImage*)getImageFromMediaItemId:(NSNumber *)persistentId
{
    /* Get the title from the media item */
    MPMediaItem *mediaItem = [self getMediaItemFromMediaItemId:persistentId];
    
    return [self getImageFromMediaItem:mediaItem];
}

-(void)reshowPopoverForVideoSettings:(NSTimer*)timer
{
    if([customTabBar isTabbarBusy])
    {
        return;
    }
    
    [timer invalidate];
    
    [customTabBar setSelectedItem:MODE_VIDEO_SETTINGS];
    
}

- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    BOOL selectedAudioForFirstTime = NO;
    
    [sess deleteCurrentAudioMix];
    
    /* Save MPMediaItem persistent ID */
    MPMediaItem *mediaItem = [[mediaItemCollection items]objectAtIndex:0];
    NSNumber *persistentId = [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
    
    /* if we are seleting music for the first time then we need to reopen the popover */
    if(nil == [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY])
    {
        selectedAudioForFirstTime = YES;
        [popOver dismiss];
    }
    
    /* save persistent ID of the current selected Item */
    [[NSUserDefaults standardUserDefaults] setObject:persistentId
                                              forKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
    
    
    if(selectedAudioForFirstTime)
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(reshowPopoverForVideoSettings:)
                                       userInfo:nil
                                        repeats:YES];
    }
    else
    {
        /* Extract artwork and title and assign it to Audio Cell */
        MPMediaItem *item = [[mediaItemCollection items]objectAtIndex:0];
        MPMediaItemArtwork *itemArtwork = [item valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *artWorkImage = nil;
        
        if (itemArtwork != nil)
        {
            artWorkImage = [itemArtwork imageWithSize:CGSizeMake(250.0, 250.0)];
            if(nil != artWorkImage)
            {
                [self audioCell:musicTrackCell setImage:artWorkImage];
            }
        }
        
        NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
        if(nil != title)
        {
            [self audioCell:musicTrackCell setTitle:title];
        }
        
        [self audioCell:musicTrackCell setStatus:YES];
    }
    
    [self dismissModalViewControllerAnimated: YES];
    
    return;
}

-(void)allocateResourcesForVideoSettings:(OT_TabBarItem*)tItem
{
    [self releaseToolBarIfAny];
    
        // isVideoOrderChangedByUser = YES;
    
    /* Add settings title to toolbar */
    [self addToolbarWithTitle:@"Video Settings" tag:TAG_TOOLBAR_SETTINGS];
    NSNumber *mediaItemId  = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
    
    CGRect    settingsRect = CGRectMake(0, customTabBar.frame.origin.y-180, full_screen.size.width, 180);
    CGRect selectSqlRect = CGRectMake(0, 0,
                                      settingsRect.size.width, 60);
    CGRect  musicTrackRect = CGRectMake(0, 60+1.25, settingsRect.size.width, 60);
    CGRect selectTrackRect = CGRectMake(0, 120+2.50,
                                        settingsRect.size.width, 60.0-1.25);
    
    
    /* Add touch sheild */
    CGRect full = [[UIScreen mainScreen]bounds];
    CGRect frameForTouchShieldView = CGRectMake(0, 0.0, full.size.width, customTabBar.frame.origin.y+customTabBar.frame.size.height+colorBackgroundBarHeightHeight);
    
    UIView *touchSheiled = [[UIView alloc]initWithFrame:frameForTouchShieldView];
    touchSheiled.tag = TAG_ADJUST_TOUCHSHEILD;
    touchSheiled.userInteractionEnabled = YES;
    [self.view addSubview:touchSheiled];
    [touchSheiled release];
    
    
    
    UIImageView       *settings = nil;
    BOOL      enableStatus = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY]boolValue];
    
    settings = [[UIImageView alloc]initWithFrame:CGRectMake(0, customTabBar.frame.origin.y, full_screen.size.width, 0)];
    settings . tag = TAG_VIDEOSETTINGS_BGPAD;
    settings . image = [UIImage imageNamed:@"color-gallery-strip.png"];
    //settings.backgroundColor = popup_color;
    settings.userInteractionEnabled = YES;
    [self.view addSubview:settings];
    
    if(nil != mediaItemId)
    {
        
        NSString *musicTitle   = [self getTitleFromMediaItemId:mediaItemId];
        UIImage  *musicImage   = [self getImageFromMediaItemId:mediaItemId];
        
        /* Allocate music track cell */
        musicTrackCell = [self allocateVideoSettingsCellWithRect:musicTrackRect
                                                           title:musicTitle
                                                           image:musicImage
                                                          enable:enableStatus];
    }
    else
    {
        settingsRect = CGRectMake(settingsRect.origin.x, customTabBar.frame.origin.y-120,
                                  settingsRect.size.width, 120.0);
        selectTrackRect = CGRectMake(0, 60+1.25,settingsRect.size.width, 60.0);
    }
    
    /* Allocate select video button cell */
    UIView *selectMusic = [self allocateVideoSettingsCellWithRect:selectTrackRect
                                                            title:@"Select Music"];
    
    /* Add button to Select Music */
    UIButton *selectMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectMusicButton.showsTouchWhenHighlighted = YES;
    selectMusicButton.frame = selectMusic.frame;
    selectMusicButton.center = CGPointMake(selectMusic.center.x-selectMusic.frame.origin.x, selectMusic.center.y-selectMusic.frame.origin.y);
    selectMusicButton.tag = TAG_AUDIO_CELL_SELECT_AUDIO;
    [selectMusicButton addTarget:self action:@selector(showAudioPicker) forControlEvents:UIControlEventTouchUpInside];
    /* Lets add popup with music items */
    selectMusic.userInteractionEnabled = YES;
    
    UIView *selectSquentialPlayView = [self allocateSquentialPlayButtonCellWithRect:selectSqlRect enable:isSequentialPlay];
    if (isSequentialPlay) {
        
        [self setTheDefaultOrderArray];
    }
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        settings.frame = settingsRect;
        
    }completion:^(BOOL finished)
     {
         if (nil != mediaItemId)
         {
             [settings addSubview:musicTrackCell];
             [musicTrackCell release];
         }
         [settings addSubview:selectSquentialPlayView];
         [settings addSubview:selectMusic];
         [selectMusic addSubview:selectMusicButton];
         [selectSquentialPlayView release];
         [selectMusic release];
         if (isSequentialPlay)
         {
             [self addVideoGrid:CGRectMake(0, settings.frame.origin.y, full_screen.size.width, videoGridViewHeight)];
         }
     }];
    
    return;
}

-(void)releaseResourcesForVideoSetttings
{
    [self releaseToolBarIfAny];
    [self addToolbarWithTitle:@"Select Image" tag:TAG_TOOLBAR_ADJUST];
    
    NSMutableArray *gridOrderArray = [gridView getOrderOfItem];
    
    for (int index = 0; index<[gridOrderArray count];index++)
    {
        NSNumber *element = [dictionary objectForKey:[gridOrderArray objectAtIndex:index]];
        [orderArrayForVideoItems addObject:element];
    }
    
    UIView *a  = (UIView*)[self.view viewWithTag:TAG_ADJUST_TOUCHSHEILD];
    if(nil != a)
    {
        [a removeFromSuperview];
    }
    UIImageView *gridBackGroundView = (UIImageView *)[self.view viewWithTag:TAG_VIDEOGRIDVIEW];
    if (isSequentialPlay)
    {
        [gridView.view removeFromSuperview];
        gridView  = nil;
        [gridBackGroundView removeFromSuperview];
    }
    UIImageView *settings = (UIImageView *)[self.view viewWithTag:TAG_VIDEOSETTINGS_BGPAD];
    NSArray *viewToRemove = [settings subviews];
    for (UIView *v in viewToRemove)
    {
        [v removeFromSuperview];
    }
    if (nil != settings)
    {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            settings.frame = CGRectMake(0, customTabBar.frame.origin.y, full_screen.size.width, 0);
            
        }completion:^(BOOL finished)
         {
             [customTabBar unselectCurrentSelectedTab];
             [settings removeFromSuperview];
             [settings release];
         }];
    }
}

-(void)releaseResourcesForSwap
{
    [self releaseToolBarIfAny];
    
    [sess.frame exitSwapMode];
}

-(void)allocateResourcesForSwap
{
    [self addToolbarWithTitle:NSLocalizedString(@"SWAPIMAGES", @"Swap Images") tag:TAG_TOOLBAR_SWAP];
    
    [sess.frame enterSwapMode];
}


-(UIImageView*)addToolbarWithTitle:(NSString*)title tag:(int)toolbarTag
{
    
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, customBarHeight)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = UIColorFromRGB(0xFFFFFFFF);
    label.text = title;
    label.font = [UIFont systemFontOfSize:20.0];
    
    UIImageView *toolbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, fullScreen.size.width, customBarHeight)];
    // toolbar.image = [UIImage imageNamed:@"top-bar_vpf"];
    toolbar.userInteractionEnabled = YES;
    toolbar.tag = TAG_TOOLBAR_EDIT;
    
    [toolbar addSubview:label];
    label.center = toolbar.center;
    [label release];
    if (toolbarTag == TAG_TOOLBAR_EFFECT)
    {
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel. tintColor = [UIColor whiteColor];
        [cancel addTarget:self action:@selector(perform_Cancel) forControlEvents:UIControlEventTouchUpInside];
        cancel.frame = CGRectMake(hepl_button_x, 0, customBarHeight, customBarHeight);
        [cancel setImage:[UIImage imageNamed:effect_cancel_Image] forState:UIControlStateNormal];
        [toolbar addSubview:cancel];
        cancel.showsTouchWhenHighlighted = YES;
        
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        [done addTarget:self action:@selector(applySelectedEffectToAllImages) forControlEvents:UIControlEventTouchUpInside];
        [done setImage:[UIImage imageNamed:effect_done_Image] forState:UIControlStateNormal];
        done.frame = CGRectMake(fullScreen.size.width-customBarHeight-hepl_button_x, 0, customBarHeight, customBarHeight);
        [toolbar addSubview:done];
        done.showsTouchWhenHighlighted = YES;
    }
    else
    {
    UIButton *help = [UIButton buttonWithType:UIButtonTypeInfoLight];
    help. tintColor = [UIColor whiteColor];
    [help addTarget:self action:@selector(perform_Help) forControlEvents:UIControlEventTouchUpInside];
    help.frame = CGRectMake(hepl_button_x, 0, customBarHeight, customBarHeight);
    [toolbar addSubview:help];
    help.showsTouchWhenHighlighted = YES;
    
    UIButton *proButton = [UIButton buttonWithType:UIButtonTypeCustom];
    proButton . tag = 8000;
    [proButton addTarget:self action:@selector(open_ProVersion) forControlEvents:UIControlEventTouchUpInside];
    [proButton setBackgroundImage:[UIImage imageNamed:@"pro 1.png"] forState:UIControlStateNormal];
    proButton.frame = CGRectMake(fullScreen.size.width-pro_x, 0, customBarHeight, customBarHeight);
    proButton.showsTouchWhenHighlighted = YES;
        
    if (freeVersion)
    {
        [toolbar addSubview:proButton];
        [self addAnimationToProButton:proButton];
    }
    _appoxeeBadge.frame = CGRectMake(fullScreen.size.width-appoxee_button_x, 0, customBarHeight, customBarHeight);
    _appoxeeBadge.showsTouchWhenHighlighted = YES;
#if defined(VideoCollagePRO)
#else
    [toolbar addSubview:_appoxeeBadge];
#endif
        }
    [self.view addSubview:toolbar];
    
    [toolbar release];
    int adjustDistanceFromWall = adviewdistancefromwall;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && full_screen.size.height== 480) {
        adjustDistanceFromWall = 0;
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        adjustDistanceFromWall =30;
    }
    if (freeVersion)
    {
    [[configparser Instance] showAdInView:self.view atLocation:CGPointMake(fullScreen.size.width-adviewdistancefromwall-adviewsize, 50+adjustDistanceFromWall)];
    [[configparser Instance] bringAdToTheTop];
    }
    return toolbar;
}
-(void)perform_Cancel
{
    for (int index = 0; index<sess.frame.photoCount; index++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:index];
        UIImage *image= nil;
        if ([sess getFrameCountForPhotoAtIndex:index]==0)
        {
            image = [sess getImageAtIndex:index];
        }else
        {
            image = [sess getImageAtIndex:index];
        }
        if (pht.view.imageView.image != nil)
        {
            pht.view.imageView.image = nil;
            pht.view.imageView.image = image;
            
            [pht.view.imageView setNeedsDisplay];
        }
    }
    [self releaseResourcesForEffects];
}

-(void)applySelectedEffectToAllImages
{
    isTouchWillDetect = NO;
    
    [self performSelectorOnMainThread:@selector(addprogressBarWithMsg:) withObject:@"Applying effect" waitUntilDone:YES];
    
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperationWithBlock:^
    {
        [self applyEffectAndSaveImage:^(BOOL isFinished)
        {
            if (isFinished)
            {
                isTouchWillDetect = YES;
                [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(perform_Cancel) withObject:nil waitUntilDone:YES];;
            }
        }];
    }];
  
     [operationQueue release];
    
}

-(void)applyEffectAndSaveImage:(void (^)(BOOL isCompleted))complete
{
    NSString *currentVideoPath = [sess pathToCurrentVideo];
    if(YES == [[NSFileManager defaultManager]fileExistsAtPath:currentVideoPath])
    {
        [[NSFileManager defaultManager]removeItemAtPath:currentVideoPath error:nil];
    }
    Effects *effect = [Effects alloc];
    int totalNoOfPhoto=0;
    int  currentFrameNumber = 0;
    int totalNumberOfFrames = 0;
    for (int photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
    {
        NSNumber *effectNo = [dictionaryOfEffectInfo objectForKey:[NSNumber numberWithInt:photoIndex]];
        
        if (nil== effectNo)
        {
            continue;
        }

        totalNumberOfFrames = totalNumberOfFrames + [sess getFrameCountForPhotoAtIndex:photoIndex];
        
    }
    for (int phototIndex = 0; phototIndex<sess.frame.photoCount; phototIndex++)
    {
       
        totalNoOfPhoto++;
        
        NSNumber *effectNo = [dictionaryOfEffectInfo objectForKey:[NSNumber numberWithInt:phototIndex]];
        
        if (nil== effectNo)
        {
            
            continue;
        }
        if ([sess getFrameCountForPhotoAtIndex:phototIndex]==0)
        {
            currentFrameNumber ++;
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
            UIImage *image = [sess getImageAtIndex:phototIndex];
            
            /* applly effect on image */
            image = [effect applyCurrentSelectedEffcect:image withEffect:effectNo.intValue];
            
            /*replace image with old image and save it*/
            [sess saveImage:image atIndex:phototIndex];
            [pool release];
            
            continue;
        }
        for (int frameIndex = 0; frameIndex<[sess getFrameCountForPhotoAtIndex:phototIndex]; frameIndex++)
        {
            
            
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            /* get images form photo */
            UIImage *image = [sess getVideoFrameAtIndex:frameIndex forPhoto:phototIndex];

            /* apply effect on image */
            UIImage  *processedImage = [effect applyCurrentSelectedEffcect:image withEffect:effectNo.intValue];
            if (frameIndex == 0) {
                [sess saveImage:processedImage atIndex:phototIndex];
            }
            
            /* replace effect applied image with old image */
            [sess saveImageAfterApplyingEffect:processedImage atPhotoIndex:phototIndex atFrameIndex:frameIndex];
            
            currentFrameNumber++;
            
            float prg = (float)currentFrameNumber/(float)totalNumberOfFrames;
          //  dispatch_async(dispatch_get_main_queue(), ^{
                
                // update your UI here
               // [self updateProgress:[NSNumber numberWithFloat:prg]];
            [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:prg] waitUntilDone:YES];
                
           // });
            [pool release];
        }
        
    }
    if (totalNoOfPhoto==sess.frame.photoCount )
    {
        complete(YES);
        
    }else
    {
        complete(NO);
    }
}
-(void)addAnimationToProButton:(UIButton *)aButton
{
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = 0.5;
    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.2];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = FLT_MAX;
    [aButton.layer addAnimation:pulseAnimation forKey:nil];
    
}
-(void)open_ProVersion
{
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    UIView *backgroundView = [[UIView alloc] initWithFrame:fullScreen];
    backgroundView . tag = 5000;
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]];
    
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        [self.view addSubview:backgroundView];
                    }
                    completion:NULL];
    
    
    UIImageView *proImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,fullScreen.size.width , fullScreen.size.height)];
    [proImageView setImage:[UIImage imageNamed:@"ProAd.png"]];
    
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone && fullScreen.size.height>480)
    {
        [proImageView setImage:[UIImage imageNamed:@"ProAd1136.png"] ];
        
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [proImageView setImage:[UIImage imageNamed:@"ProAd~ipad.png"]];
    }
    [backgroundView addSubview:proImageView];
    
    UIButton *bigInstall = [UIButton buttonWithType:UIButtonTypeCustom];
    bigInstall . frame = proImageView.frame;
    //[bigInstall setImage:[UIImage imageNamed:@"install.png"] forState:UIControlStateNormal];
    [bigInstall addTarget:self action:@selector(openProApp) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:bigInstall];
    
    UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crossButton . frame = CGRectMake(fullScreen.size.width- ad_x, ad_y, ad_size, ad_size);
    [crossButton setImage:[UIImage imageNamed:@"close_ad.png"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:crossButton];
    
    UIButton *installButton = [UIButton buttonWithType:UIButtonTypeCustom];
    installButton . frame = CGRectMake(ad_x, ad_y+20, install_size_width, ad_size);
    [installButton setImage:[UIImage imageNamed:@"install.png"] forState:UIControlStateNormal];
    [installButton addTarget:self action:@selector(openProApp) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:installButton];
}
-(void)openProApp
{
    NSURL *proUrl = [NSURL URLWithString:ituneslinktoProVersion];
    if([[UIApplication sharedApplication]canOpenURL:proUrl])
    {
        [[UIApplication sharedApplication] openURL:proUrl];
    }
}
-(void)closeView
{
    UIView *viewToClose =(UIView *)[self.view viewWithTag:5000];
    [UIView transitionWithView:viewToClose
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        [viewToClose removeFromSuperview];
                    }
                    completion:Nil];
    viewToClose = nil;
    
}

-(void)handleResolutionOptionSelection:(KxMenuItem*)item
{
    nvm.uploadResolution = item.tag;
    [self allocateShareResources];
}

-(void)KxMenuWillDismissByUser:(KxMenu*)menu
{
    
    [self releaseResourcesForUpload];
    
    [customTabBar unselectCurrentSelectedTab];
    
    [self selectEditTab];
}

-(void)allocateResourcesForUpload
{
    [customTabBar unselectCurrentSelectedTab];
    [self releaseToolBarIfAny];
    
    [self addToolbarWithTitle:@"Select Image" tag:TAG_TOOLBAR_SHARE];
    
    /* first check if the frame is video frame or not */
    if([sess anyVideoFrameSelected])
    {
        [self generateVideo:^(BOOL status, NSString *videoPath)
         {
             if(YES == status)
             {
                 isVideoFile = YES;
                 [self performSelectorOnMainThread:@selector(allocateShareResources) withObject:nil waitUntilDone:YES];
             }
         }];
    }
    else
    {
        isVideoFile = NO;
        [self showResolutionOptios];
    }
}



-(void)releaseResourcesForAdjustSettings
{
    [self releaseToolBarIfAny];
    [self addToolbarWithTitle:@"Select Image" tag:TAG_TOOLBAR_ADJUST];
    
    UIImageView *ta = (UIImageView*)[self.view viewWithTag:TAG_ADJUST_BG];
    if(nil != ta)
    {
        NSArray *viewsToRemove = [ta subviews];
        for (UIView *v in viewsToRemove) [v removeFromSuperview];
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            ta.frame = CGRectMake(0, customTabBar.frame.origin.y, full_screen.size.width, 0);
            
        }completion:^(BOOL finished)
         {
             [customTabBar unselectCurrentSelectedTab];
             [ta removeFromSuperview];
         }];
    }
    
    UIView *a = (UIView*)[self.view viewWithTag:TAG_ADJUST_BGPAD];
    if(nil != a)
    {
        [a removeFromSuperview];
    }
    
    a = (UIView*)[self.view viewWithTag:TAG_ADJUST_TOUCHSHEILD];
    if(nil != a)
    {
        [a removeFromSuperview];
        [customTabBar unselectCurrentSelectedTab];
        eMode = MODE_MAX;
    }
}

-(void)allocateResourcesForAdjustSettings:(OT_TabBarItem*)tItem
{
    [self releaseToolBarIfAny];
    [self addToolbarWithTitle:@"Adjust" tag:TAG_TOOLBAR_ADJUST];
    
    CGRect backgroundRect = CGRectMake(0, customTabBar.frame.origin.y, RADIUS_SETTINGS_WIDTH, 0);
    float height_bar= 150;
    float outerRadiusIndex         = 15.0;
    float innerRadiusIndex         = 65.0;
    float widthIndex               = 115.0;
    float gap                       = 0;
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        backgroundRect = CGRectMake(0,customTabBar.frame.origin.y, full_screen.size.width, 0);
        height_bar =  300;
        outerRadiusIndex         = 40.0;
        innerRadiusIndex         = 135.0;
        widthIndex               = 240.0;
        gap                      = 50;
    }
    
    /* Add touch sheild */
    CGRect full = [[UIScreen mainScreen]bounds];
    UIView *touchSheiled = [[UIView alloc]initWithFrame:CGRectMake(0, 00.0, full.size.width, customTabBar.frame.origin.y+customTabBar.frame.size.height+colorBackgroundBarHeightHeight)];
    touchSheiled.tag = TAG_ADJUST_TOUCHSHEILD;
    touchSheiled.userInteractionEnabled = YES;
    [self.view addSubview:touchSheiled];
    [touchSheiled release];
    
    /* Add background */
    UIImageView *backGround = [[UIImageView alloc]initWithFrame:backgroundRect];
    [self.view addSubview:backGround];
    //backGround.backgroundColor = popup_color;
    backGround . image = [UIImage imageNamed:@"settingsBackground.png"];
    backGround.tag = TAG_ADJUST_BG;
    [backGround release];
    backGround.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        backGround.frame = CGRectMake(0, customTabBar.frame.origin.y-height_bar, full_screen.size.width, height_bar);
        
    }completion:^(BOOL finished)
     {
         /* add radius sliders */
         CGRect       rect              = CGRectMake(RADIUS_SETTINGS_X, RADIUS_SETTINGS_Y, RADIUS_SETTINGS_WIDTH-40,         RADIUS_SETTINGS_HEIGHT);
         UISlider    *outerRadius       = nil;
         UISlider    *innerRadius       = nil;
         
         UIFont *lblFont                = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
         
         UILabel *innerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+20+gap, rect.origin.y+innerRadiusIndex, 150, 20)];
         innerRadiusLbl.tag = RADIUS_TAG_INDEX+1;
         innerRadiusLbl.font = lblFont;
         innerRadiusLbl.text = NSLocalizedString(@"INNERRADIUS", @"Inner Radius");
         innerRadiusLbl.textAlignment = UITextAlignmentLeft;
         innerRadiusLbl.backgroundColor = [UIColor clearColor];
         innerRadiusLbl.textColor = [UIColor whiteColor];
         
         innerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+115.0+2*gap, rect.origin.y+innerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 20.0)];
         innerRadius.tag = RADIUS_TAG_INDEX+2;
         /* Configure the brush Slider  */
         innerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
         innerRadius.minimumValue     = 0.0;
         innerRadius.continuous       = YES;
         innerRadius.value            = sess.innerRadius;
         [innerRadius addTarget:self action:@selector(innerRadiusChanged:)
               forControlEvents:UIControlEventValueChanged];
         
         
         UILabel *outerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+20+gap, rect.origin.y+outerRadiusIndex, 150, 20)];
         outerRadiusLbl.tag =RADIUS_TAG_INDEX+3;
         outerRadiusLbl.text = NSLocalizedString(@"OUTERRADIUS",@"Outer Radius");
         outerRadiusLbl.font = lblFont;
         outerRadiusLbl.textAlignment = UITextAlignmentLeft;
         outerRadiusLbl.backgroundColor = [UIColor clearColor];
         outerRadiusLbl.textColor = [UIColor whiteColor];
         
         
         /* Allocate the slider */
         outerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+115.0+2*gap, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
         //outerRadius = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+100.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
         outerRadius.tag = RADIUS_TAG_INDEX+4;
         /* Configure the brush Slider  */
         outerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
         outerRadius.minimumValue     = 0;
         outerRadius.continuous       = YES;
         outerRadius.value            = sess.outerRadius;
         
         [outerRadius addTarget:self action:@selector(outerRadiusChanged:)
               forControlEvents:UIControlEventValueChanged];
         
         
         UILabel *widthLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+20+gap, rect.origin.y+widthIndex, 150, 20)];
         widthLbl.tag =RADIUS_TAG_INDEX+5;
         widthLbl.text = NSLocalizedString(@"WIDTH",@"Width");
         widthLbl.font = lblFont;
         widthLbl.textAlignment = UITextAlignmentLeft;
         widthLbl.backgroundColor = [UIColor clearColor];
         widthLbl.textColor = [UIColor whiteColor];
         
         
         UISlider *width = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+115.0+2*gap, rect.origin.y+widthIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
         width.tag = RADIUS_TAG_INDEX+6;
         /* Configure the brush Slider  */
         width.maximumValue     = 30;
         width.minimumValue     = 0;
         width.continuous       = YES;
         width.value            = sess.frameWidth;
         
         [width addTarget:self action:@selector(widthChanged:)
         forControlEvents:UIControlEventValueChanged];
         
         /* Add all UI elements to background view */
         [backGround addSubview:innerRadiusLbl];
         [backGround addSubview:outerRadiusLbl];
         [backGround addSubview:innerRadius];
         [backGround addSubview:outerRadius];
         [backGround addSubview:widthLbl];
         [backGround addSubview:width];
         
         /* Release the resources that are not required any more */
         [width release];
         [widthLbl release];
         [innerRadiusLbl release];
         [outerRadius release];
         [innerRadius release];
         [outerRadiusLbl release];
     }];
    
}
-(CABasicAnimation *)addAnimation:(float)fromValue tovalue:(float)toValue
{
    CABasicAnimation  *move = [CABasicAnimation animationWithKeyPath:@"transform.translation.y" ];
    
    [move setFromValue:[NSNumber numberWithFloat:fromValue]];
    
    [move setToValue:[NSNumber numberWithFloat:200]];
    
    [move setDuration:1.0f];
    return move;
    
}
-(void)releaseResourcesForColorAndPatternSettings_updated
{
    UIImageView *parentView = (UIImageView *)[self.view viewWithTag:2002];
    UIScrollView *scrollView = (UIScrollView *)[parentView viewWithTag:4000];
    UIButton *colorBut = (UIButton *)[parentView viewWithTag:10098];
    UIButton  *patternBut = (UIButton *)[parentView viewWithTag:20000];
    if (scrollView)
    {
        parentView . image = [UIImage imageNamed:@"backgroundStrip.png"];
        [colorBut   setHidden:NO];
        [patternBut setHidden:NO];
        [scrollView removeFromSuperview];
        [scrollView release];
        scrollView = nil;
        return;
    }
    if (parentView)
    {
        [self releaseToolBarIfAny];
        
        [self addToolbarWithTitle:@"Select Image" tag:TAG_TOOLBAR_SETTINGS];
        
        UIView  *a = (UIView*)[self.view viewWithTag:TAG_ADJUST_TOUCHSHEILD];
        [a removeFromSuperview];
        [colorBut   removeFromSuperview];
        [patternBut removeFromSuperview];
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            parentView.frame = CGRectMake(0, customTabBar.frame.origin.y, full_screen.size.width, 00);
            
        }completion:^(BOOL finished)
        {
            [parentView removeFromSuperview];
            [customTabBar unselectCurrentSelectedTab];
        }];
    }
    
}
-(void)allocateResourcesForEffects:(OT_TabBarItem *)tItem
{
    if (dictionaryOfEffectInfo!= nil)
    {
        [dictionary release];
        dictionary = nil;
    }
    dictionaryOfEffectInfo = [[NSMutableDictionary alloc] init];
    [self releaseToolBarIfAny];
    [self addToolbarWithTitle:@"Effect" tag:TAG_TOOLBAR_EFFECT];
    [sess enterTouchModeForSlectingImage:currentSelectedPhotoNumberForEffect];
    //[self hideBannerAd];
    Effects *effect = [[Effects alloc] init];
    
    CGRect backgroundRect = CGRectMake(0, full_screen.size.height, full_screen.size.width, 0);

    /* Add background */
    UIImageView *backGround = [[UIImageView alloc]initWithFrame:backgroundRect];
    [self.view addSubview:backGround];
    //backGround.backgroundColor = popup_color;
    backGround . image = [UIImage imageNamed:colorPatternBarImage];
    backGround.tag = TAG_ADJUST_BG;
    [backGround release];
    backGround.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         customTabBar.frame = CGRectMake(0, full_screen.size.height, full_screen.size.width, 0);
                         
                     }
                     completion:^(BOOL finished)
                        {
                        isEffectEnabled = YES;
                            
                         [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                         backGround.frame =  CGRectMake(0, full_screen.size.height -colorBackgroundBarHeightHeight, full_screen.size.width, colorBackgroundBarHeightHeight);
                             
                         } completion:^(BOOL finishhed)
                         {
                             UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, full_screen.size.width, colorBackgroundBarHeightHeight)];
                             scrollView . tag = 4000;
                             scrollView . backgroundColor = [UIColor clearColor];
                             scrollView . userInteractionEnabled = YES;
                             
                             float xAxis  = 5;
                             float yAxis  = (colorBackgroundBarHeightHeight - colorBurttonHeight)/2;
                             float width  = colorBurttonHeight;
                             float height = colorBurttonHeight;
                             int   gap    = colorBurttonHeight+10;
                             
                             for (int index=0; index<18; index++)
                             {
                                 UIButton *effectItem  = [UIButton buttonWithType:UIButtonTypeCustom];
                                 effectItem . tag = index;
                                 effectItem . frame = CGRectMake(xAxis, yAxis, width, height);
                                 [effectItem setBackgroundImage:[effect getImageForItem:index] forState:UIControlStateNormal];
                                 effectItem . layer. borderColor = [UIColor whiteColor].CGColor;
                                 effectItem . layer. borderWidth = 3.0;
                                 if ([effect getItemLockStatus:index ])
                                 {
                                     if (freeVersion)
                                     {
                                         UIImageView *lockImageView = [[UIImageView alloc] init];
                                         lockImageView.frame = CGRectMake(0, 0, colorBurttonHeight, colorBurttonHeight);
                                         lockImageView.image = [UIImage imageNamed:@"lock.png"];
                                         [effectItem addSubview:lockImageView];
                                         [lockImageView release];

                                     }
                                 }
                                 [effectItem addTarget:self action:@selector(applySelectedeffectOnPhoto:) forControlEvents:UIControlEventTouchUpInside];
                                 [scrollView addSubview:effectItem];
                                 xAxis = xAxis+gap;
                             }
                             
                             scrollView . contentSize = CGSizeMake(xAxis, height);
                             scrollView . showsHorizontalScrollIndicator = NO;
                             scrollView . showsVerticalScrollIndicator = NO;
                             [backGround addSubview:scrollView];
                         }];
                     
                     }];

}
-(void)applySelectedeffectOnPhoto:(UIButton *)button
{
    Effects *effect = [[Effects alloc] init];
    
    if ([effect getItemLockStatus:button.tag]) {
        if (freeVersion)
        {
            /* item is locked , so show alert to upgrade to pro version */
            [WCAlertView showAlertWithTitle:@"Upgrade To Pro" message:@"This item is locked. Upgrade free version to pro to avail this item." customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView){
                if (buttonIndex == 0) {
                    return ;
                }
                else
                {
                    [self openProApp];
                }
                
            } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade", nil];
        }
    }else
    {
    /* apply effect on image*/
        
        Photo *pht = [sess.frame getPhotoAtIndex:currentSelectedPhotoNumberForEffect];
        if (pht.view.imageView.image != nil)
        {
            NSNumber *effectNumber = [NSNumber numberWithInt:button.tag];
            
            NSNumber *photoNumber = [NSNumber numberWithInt:currentSelectedPhotoNumberForEffect];
            
            [dictionaryOfEffectInfo setObject:effectNumber forKey:photoNumber];
            
            UIImage *image =[sess getImageAtIndex:currentSelectedPhotoNumberForEffect];
            
            pht . view . imageView. image = [effect applyCurrentSelectedEffcect:image withEffect:button.tag];
            
        }else
        {
            [WCAlertView showAlertWithTitle:@"Oops.." message:@"Plaese select image before appling effect" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        }
        
        
    }
}
-(void)releaseResourcesForEffects
{
   
    [self releaseToolBarIfAny];
    [self addToolbarWithTitle:@"Select Image" tag:TAG_TOOLBAR_ADJUST];
    [sess exitTouchModeForSlectingImage];
    
    UIImageView *ta = (UIImageView*)[self.view viewWithTag:TAG_ADJUST_BG];
    if(nil != ta)
    {
        
        NSArray *viewsToRemove = [ta subviews];
        for (UIView *v in viewsToRemove) [v removeFromSuperview];
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^
        {
            ta.frame = CGRectMake(0, customTabBar.frame.origin.y, full_screen.size.width, 0);
            
        }completion:^(BOOL finished)
         {
             [customTabBar unselectCurrentSelectedTab];
             [ta removeFromSuperview];
             CGRect frameForCustomTabBar;
             if (freeVersion)
             {
                 GADBannerView *bannerView = (GADBannerView*)[self.view viewWithTag:TAG_BANNERAD_VIEW];
                 
                 frameForCustomTabBar = CGRectMake(0, full_screen.size.height-(2*bannerView.frame.size.height), full_screen.size.width, bannerView.frame.size.height);
                 if (bannerView== nil)
                 {
                     frameForCustomTabBar = CGRectMake(0, full_screen.size.height-customBarHeight, full_screen.size.width, customBarHeight);
                 }
                 
             }else
             {
                 frameForCustomTabBar = CGRectMake(0, full_screen.size.height-customBarHeight, full_screen.size.width, customBarHeight);
             }
             [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                 
                 customTabBar . frame = frameForCustomTabBar;
                 
             }completion:^(BOOL finished)
              {
                  eMode = MODE_MAX;
              }];
             
         }];
    }
    
    UIView *a = (UIView*)[self.view viewWithTag:TAG_ADJUST_BGPAD];
    if(nil != a)
    {
        [a removeFromSuperview];
    }
    
    a = (UIView*)[self.view viewWithTag:TAG_ADJUST_TOUCHSHEILD];
    if(nil != a)
    {
        [a removeFromSuperview];
    }

}
-(void)allocateResourcesForColorAndPatternSettings_updated:(OT_TabBarItem*)tItem
{
    
    [self releaseToolBarIfAny];
    [self addToolbarWithTitle:@"Settings" tag:TAG_TOOLBAR_ADJUST];
    
    /* Add touch sheild */
    CGRect full = [[UIScreen mainScreen]bounds];
    UIView *touchSheiled = [[UIView alloc]initWithFrame:CGRectMake(0, 0.0, full.size.width, customTabBar.frame.origin.y+customTabBar.frame.size.height+colorBackgroundBarHeightHeight)];
    touchSheiled.tag = TAG_ADJUST_TOUCHSHEILD;
    touchSheiled.userInteractionEnabled = YES;
    [self.view addSubview:touchSheiled];
    [touchSheiled release];
    
    UIImageView *sliderBackground = [[UIImageView alloc]init];
    sliderBackground . frame = CGRectMake(0, customTabBar.frame.origin.y, full_screen.size.width, 0);
    sliderBackground . tag   = 2002;
    sliderBackground . image = [UIImage imageNamed:backgroundBarImage];
    sliderBackground . UserInteractionEnabled = YES;
    sliderBackground. backgroundColor = [UIColor yellowColor];
    [self.view addSubview:sliderBackground];
    
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        sliderBackground.frame = CGRectMake(0, customTabBar.frame.origin.y-colorBackgroundBarHeightHeight, full_screen.size.width, colorBackgroundBarHeightHeight);
        
    }completion:^(BOOL finished)
     {
         UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
         colorButton . tag = 10098;
         colorButton . frame = CGRectMake(0, 0, full_screen.size.width*0.48, colorBurttonHeight);
         colorButton . center = CGPointMake(full_screen.size.width*0.25, sliderBackground.frame.size.height/2);
         [colorButton setImage:[UIImage imageNamed:colorButtonImage] forState:UIControlStateNormal];
         [colorButton setImage:[UIImage imageNamed:colorButtonImage_active] forState:UIControlStateHighlighted];
         [colorButton addTarget:self action:@selector(addActionForSelection:) forControlEvents:UIControlEventTouchUpInside];
         [sliderBackground addSubview:colorButton];
         
         UIButton *patternButton = [UIButton buttonWithType:UIButtonTypeCustom];
         patternButton . tag = 20000;
         patternButton . frame = CGRectMake(0, 0, full_screen.size.width*0.48, colorBurttonHeight);
         patternButton . center = CGPointMake(full_screen.size.width*0.75, sliderBackground.frame.size.height/2);
         [patternButton setImage:[UIImage imageNamed:patternButtonImage] forState:UIControlStateNormal];
         [patternButton setImage:[UIImage imageNamed:patternButtonImage_active] forState:UIControlStateHighlighted];
         [patternButton addTarget:self action:@selector(addActionForSelection:) forControlEvents:UIControlEventTouchUpInside];
         [sliderBackground addSubview:patternButton];
         
     }];
}

-(void )addActionForSelection:(UIButton *)aButton
{
    UIImageView *parentView = (UIImageView *)[self.view viewWithTag:2002];
    parentView . image      = [UIImage imageNamed:colorPatternBarImage];
    UIButton *colorBut      = (UIButton *)[parentView viewWithTag:10098];
    UIButton  *patternBut   = (UIButton *)[parentView viewWithTag:20000];
    [colorBut   setHidden:YES];
    [patternBut setHidden:YES];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, full_screen.size.width, colorBackgroundBarHeightHeight)];
    scrollView . tag = 4000;
    scrollView . backgroundColor = [UIColor clearColor];
    scrollView . userInteractionEnabled = YES;
    
    float xAxis  = 5;
    float yAxis  = (colorBackgroundBarHeightHeight - colorBurttonHeight)/2;
    float width  = colorBurttonHeight;
    float height = colorBurttonHeight;
    int   gap    = colorBurttonHeight+10;
    
    if (aButton.tag == 10098)
    {
        for ( int i = 0; i<52; i++)
        {
            UIButton *but  = [UIButton buttonWithType:UIButtonTypeCustom];
            but . tag = i;
            but . frame = CGRectMake(xAxis, yAxis, width, height);
            [but setBackgroundColor:[GridView getColorAtIndex:i]];
            if ([GridView getLockStatusOfColor:i ])
            {
                if (freeVersion)
                {
                    [but setBackgroundImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
                }
            }
            [but addTarget:self action:@selector(applyColor:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:but];
            xAxis = xAxis+gap;
        }
        scrollView . contentSize = CGSizeMake(xAxis, height);
    }
    else
    {
        for ( int i = 0; i<33; i++)
        {
            UIButton *but  = [UIButton buttonWithType:UIButtonTypeCustom];
            but . tag = i;
            but . frame = CGRectMake(xAxis, yAxis, width, height);
            [but setBackgroundColor:[GridView getPatternAtIndex:i]];
            if ([GridView getLockStatusOfPatern:i]) {
                if (freeVersion)
                {
                [but setBackgroundImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
                }
            }
            [but addTarget:self action:@selector(applyPattern:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:but];
            xAxis = xAxis+gap;
        }
    }
    
    scrollView . contentSize = CGSizeMake(xAxis, height);
    scrollView . showsHorizontalScrollIndicator = NO;
    scrollView . showsVerticalScrollIndicator = NO;
    [parentView addSubview:scrollView];
}

-(void)applyColor:(UIButton *)but
{
    BOOL isLock = [GridView getLockStatusOfColor:but.tag];
    if (proVersion) {
        isLock = NO;
    }
    if (isLock)
    {
        [WCAlertView showAlertWithTitle:@"Upgrade To Pro" message:@"This item is locked. Upgrade free version to pro to avail this item." customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
        {
            if (buttonIndex == 0)
            {
                return ;
            }
            else
            {
                [self openProApp];
            }
        } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade", nil];
    }else
    {
        sess.color = [GridView getColorAtIndex:but.tag];
    }
}

-(void)applyPattern:(UIButton *)but
{
    BOOL isLock = [GridView getLockStatusOfPatern:but.tag];
    if (proVersion) {
        isLock = NO;
    }
    if (isLock) {
        [WCAlertView showAlertWithTitle:@"Upgrade To Pro" message:@"This item is locked. Upgrade free version to pro to avail this item." customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView){
            if (buttonIndex == 0) {
                return ;
            }
            else
            {
                [self openProApp];
            }
            
            
        } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Upgrade", nil];
    }else
    {
        sess.color = [GridView getPatternAtIndex:but.tag];
    }
}

-(void)colorItemSelected:(UIColor *)selectedColor
{
    sess.color = selectedColor;
}

-(void)releaseResourcesForUpload
{
    [self releaseToolBarIfAny];
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)releaseResourcesForModeChange
{
    switch (eMode)
    {
        case MODE_FRAMES:
        {
            [self releaseResourcesForFrames];
            break;
        }
        case MODE_COLOR_AND_PATTERN:
        {
            
            [self releaseResourcesForColorAndPatternSettings_updated];
            break;
        }
        case MODE_ADJUST_SETTINGS:
        {
            [self releaseResourcesForAdjustSettings];
            break;
        }
        case MODE_VIDEO_SETTINGS:
        {
            
            [self releaseResourcesForVideoSetttings];
            break;
        }
        case MODE_ADD_EFFECT:
        {
            [self releaseResourcesForEffects];
        }
        case MODE_SHARE:
        {
            [self releaseResourcesForUpload];
            break;
        }
            //need to delete
        case MODE_PREVIEW:
        {
            [self releaseResourcesForPreview];
            break;
        }
            //end
        default:
        {
            break;
        }
    }
}

-(void)otTabBar:(OT_TabBar*)tbar didSelectItem:(OT_TabBarItem*)tItem
{
    
    if(NO == tItem.nestedSelectionEnabled)
    {
        if(tItem.tag == eMode)
        {
            NSLog(@"Nested selection is not enabled for this tab item, ignoring tabbar selection");
            return;
        }
    }
    
    /* First release resources of the previous mode */
    [self releaseResourcesForModeChange];
    
    if(nil == tItem)
    {
        eMode = MODE_MAX;
    }
    else
    {
        /* Now get the new mode */
        eMode = (eAppMode)tItem.tag;
    }
    
    /* handle the new mode */
    switch (eMode)
    {
        case MODE_FRAMES:
        {
            [self allocateResourcesForFrames];
            break;
        }
        case MODE_COLOR_AND_PATTERN:
        {
            
            [self allocateResourcesForColorAndPatternSettings_updated:tItem];
            break;
        }
        case MODE_ADJUST_SETTINGS:
        {
            
            [self allocateResourcesForAdjustSettings:tItem];
            break;
        }
        case MODE_ADD_EFFECT:
        {
            [self allocateResourcesForEffects:tItem];
            break;
        }
        case MODE_VIDEO_SETTINGS:
        {
            [self allocateResourcesForVideoSettings:tItem];
            //[self allocateResourcesForEdit];
            break;
        }
        case MODE_SHARE:
        {
            [self allocateResourcesForUpload];
            break;
        }
            //need to delete
        case MODE_PREVIEW:
        {
            [self allocateResourcesForPreview:tItem];
            break;
        }
            //end
        default:
        {
            break;
        }
    }
}

#pragma mark smooth transition
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self == viewController)
    {
        [self selectEditTab];
    }
}

#pragma mark upload implementation
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	/* Dismiss the modelview controller */
	[controller dismissModalViewControllerAnimated:YES];
	
	switch(result)
	{
		case MFMailComposeResultSent:
		{
            [WCAlertView showAlertWithTitle:NSLocalizedString(@"EMAIL",@"Email")
                                    message:NSLocalizedString(@"EMAILSUCCESS",@"Successfully Sent the email!!!")
                         customizationBlock:nil
                            completionBlock:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK",@"OK"), nil];
            
            [Appirater userDidSignificantEvent:YES];
            
			break;
		}
		case MFMailComposeResultFailed:
		{
            [WCAlertView showAlertWithTitle:NSLocalizedString(@"EMAIL",@"Email")
                                    message:[error localizedDescription]
                         customizationBlock:nil
                            completionBlock:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK",@"OK"), nil];
			break;
		}
		default:
		{
			break;
		}
	}
    
    [[NSNotificationCenter defaultCenter]postNotificationName:uploaddone object:nil];
	
	return;
}

-(void)uploadToEmail
{
    NSAutoreleasePool *localPool     = [[NSAutoreleasePool alloc] init];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        /* We must always check whether the current device is configured for sending emails */
        if ([mailClass canSendMail])
        {
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
            [picker addAttachmentData:UIImageJPEGRepresentation([sess.frame renderToImageOfSize:nvm.uploadSize],1.0)
                             mimeType:@"image/jpeg" fileName:@"PicShells"];
            
            /* Fill out the email body text */
            [picker setMessageBody:emailBody isHTML:YES];
            
            /* Present the email compose view to the user */
            [self presentModalViewController:picker animated:YES];
            
            /* Free the resources */
            [picker release];
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
        [mailClass release];
    }
    
    [localPool release];
    
    return;
}

-(void) saveImageToInstagram:(UIImage *)pImage
{
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
        documentInteractionController = [[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:pathToSave]]retain];
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
                 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/instagram/id389801252?mt=8"]];
             }
         }
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Download", nil];
        
    }
}

- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application
{
    [documentInteractionController release];
    documentInteractionController = nil;
}

-(void)uploadImage
{

    if (NO == bought_watermarkpack)
    {
        [self addWaterMarkToFrame];
    }

    if(nvm.uploadCommand == UPLOAD_EMAIL)
    {
        if (NO == nvm.connectedToInternet) {
            [WCAlertView showAlertWithTitle:@"Failed!!" message:@"Currently your device is not connected to internet. To share image by email , first you need to connect to internet" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            return;
        }
        else
        {
        [self uploadToEmail];
        }
    }
#ifdef POSTCARD_SINCERLY
    else if(nvm.uploadCommand == SEND_POSTCARD)
    {
        [self sendPostCard];
    }
#endif
    else if(nvm.uploadCommand == SEND_TO_INSTAGRAM)
    {
       
        [self saveImageToInstagram:[sess.frame renderToImageOfSize:nvm.uploadSize]];
        [Appirater userDidSignificantEvent:YES];
       
    }
    else
    {
        UploadHandler *uploadH = nil;
        
        uploadH = [UploadHandler alloc];
        uploadH.view = self.view;
        uploadH.cursess = sess;
        
        [uploadH upload];
    }
    
    /* Now destroy the activity indicator */
    [Utility removeActivityIndicatorFrom:self.view];
}

-(void)uploadVideo
{
    //bShowRevModAd = NO;/* Rajesh Kumar*/
    VideoUploadHandler *vHandler = [VideoUploadHandler alloc];
    vHandler.viewController = self;
    vHandler . _view = self.view;
    vHandler.applicationName = appname;
    vHandler.downloadUrl = @"http://www.videocollageapp.com";
    vHandler.website = @"http://www.videocollageapp.com";
    
    [vHandler uploadVideoAtPath:[sess pathToCurrentVideo] to:nvm.uploadCommand];
    //bShowRevModAd=YES;
}
-(void)uploadSelected
{
    //TBD - not required can be deleted in next version
    //if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //{
    //    [uploadPopover dismissPopoverAnimated:YES];
    //}
    if(YES == [sess anyVideoFrameSelected])
    {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(uploadVideo) userInfo:nil repeats:NO];
        return;
    }
    
    /* Add the activity indicator */
    [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"GENERATING", @"Generating")];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(uploadImage) userInfo:nil repeats:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(YES == [[alertView title] isEqualToString:NSLocalizedString(@"EMAIL",@"Email")])
    {
        //[self retrieveAndDislayTodaysAdd];
    }
    else if(YES == [[alertView title] isEqualToString:NSLocalizedString(@"VIDEOTUT",@"Video Tutorial")])
    {
        if(buttonIndex == 1)
        {
            //[self showVideoTutorial];
        }
    }
    else if(YES == [[alertView title] isEqualToString:NSLocalizedString(@"IVOKEHEAD",@"Personalized Items")])
    {
        if(buttonIndex == 1)
        {
            [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"RENDERING",@"Rendering")];
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(orderPersanalItem) userInfo:nil repeats:NO];
        }
    }
    else if(YES == [[alertView title] isEqualToString:@"Failed"])
    {
        if(buttonIndex == 1)
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/instagram/id389801252?mt=8"]];
        }
    }
    
    return;
}

-(void)allocateShareResources
{
    if (NO == bought_watermarkpack)
    {
        [self addWaterMarkToFrame];
        nvm.noAdMode = YES;
//    [Appirater userDidSignificantEvent:YES];
    }
    
    ShareViewController *shareView = [[ShareViewController alloc] init];
    shareView . frameSize = frame_size;
    shareView . videoPath = [sess pathToCurrentVideo];
    shareView . sess = sess;
    shareView . isVideo = isVideoFile;
    
        // [self.view addSubview:shareView.view];
    [self presentViewController:shareView animated:YES completion:nil];
    
    /*
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView . tag = 2134;
    backgroundView . frame = CGRectMake(0, full_screen.size.height, full_screen.size.width, 0);
    backgroundView . image =[UIImage imageNamed:@"background.png"];
    backgroundView . userInteractionEnabled = YES;
    [self.view addSubview:backgroundView];
    [self.view bringSubviewToFront:backgroundView];
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"background_ipad" ofType:@"png"]];
    }
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && full_screen.size.height>480) {
        backgroundView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"background_1136" ofType:@"png"]];
    }
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        backgroundView.frame = CGRectMake(0, 0, full_screen.size.width, full_screen.size.height);
    }completion:^(BOOL finished)
     {
     }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, full_screen.size.width, customBarHeight)];
    titleLabel. text = @"Share";
    titleLabel . textAlignment = NSTextAlignmentCenter;
    titleLabel . textColor = [UIColor whiteColor];
    titleLabel . backgroundColor = [UIColor clearColor];
    titleLabel . font = [UIFont systemFontOfSize:20.0f];
    [backgroundView addSubview:titleLabel];
    
    float xaxis = 43;
    float yaxis = 70;
    float width = 95;
    float height = 95;
    float xgap = 140;
    float ygap = 120;
    float limit = 250;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        xaxis =  128;
        yaxis  = 150;
        height = 192;
        width = 192;
        xgap = 320;
        ygap = 260;
        limit = 500;
    }
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) && (full_screen.size.height >480)) {
        yaxis = 90;
        ygap = 140;
    }
    
    if (isVideoFile)
    {
        for (int index = 1; index<=6; index++) {
            NSString *shareImage = [NSString stringWithFormat:@"share_option%d.png",index];
            NSString *shareImage_active = [NSString stringWithFormat:@"share_option%d_active.png",index];
            UIButton *shareButton = [UIButton  buttonWithType:UIButtonTypeCustom];
            shareButton . tag = index;
            shareButton . frame = CGRectMake(xaxis, yaxis, width, height);
            [shareButton setImage:[UIImage imageNamed:shareImage] forState:UIControlStateNormal];
            [shareButton setImage:[UIImage imageNamed:shareImage_active] forState:UIControlStateHighlighted];
            [shareButton addTarget:self action:@selector(handleVideoAndImageSharing:) forControlEvents:UIControlEventTouchUpInside];
            [backgroundView addSubview:shareButton];
            xaxis = xaxis + xgap;
            
            if (xaxis>limit) {
                yaxis = yaxis+ygap;
                xaxis = 50;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    xaxis = 128;
                }
            }
            
        }
    }
    else
    {
        for (int index = 1; index<=5; index++) {
            NSString *shareImage = [NSString stringWithFormat:@"share_option%d.png",index];
            NSString *shareImage_active = [NSString stringWithFormat:@"share_option%d_active.png",index];
            UIButton *shareButton = [UIButton  buttonWithType:UIButtonTypeCustom];
            shareButton . tag = index;
            [shareButton setImage:[UIImage imageNamed:shareImage] forState:UIControlStateNormal];
            [shareButton setImage:[UIImage imageNamed:shareImage_active] forState:UIControlStateHighlighted];
            shareButton . frame = CGRectMake(xaxis, yaxis, width, height);
            
            if (index == 3) {
                shareButton . center = CGPointMake(full_screen.size.width/2, full_screen.size.height/2);
                [shareButton setImage:[UIImage imageNamed:@"share_option5_image.png"] forState:UIControlStateNormal];
                [shareButton setImage:[UIImage imageNamed:@"share_option5_image_active.png"] forState:UIControlStateHighlighted];
                
            }
            if (index == 4) {
                
                [shareButton setImage:[UIImage imageNamed:@"share_option6.png"] forState:UIControlStateNormal];
                [shareButton setImage:[UIImage imageNamed:@"share_option6_active.png"] forState:UIControlStateHighlighted];
                
            }
            
            [shareButton addTarget:self action:@selector(handleVideoAndImageSharing:) forControlEvents:UIControlEventTouchUpInside];
            [backgroundView addSubview:shareButton];
            xaxis = xaxis + xgap;
            if (index == 3) {
                xaxis = 300;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    xaxis = limit+1;
                }
            }
            if (xaxis>limit) {
                yaxis = yaxis+ygap;
                xaxis = 50;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    xaxis = 128;
                }
            }
            
        }
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton . frame = CGRectMake(0, full_screen.size.height-customBarHeight, full_screen.size.width, customBarHeight);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:cancelButton];
     
     */
}
#if 0
-(void)handleVideoAndImageSharing:(UIButton *)aBUtton
{
    switch (aBUtton.tag) {
        case 1:
        {
            nvm.uploadCommand = UPLOAD_FACEBOOK_ALBUM;
            break;
        }
        case 2:
        {
            if (isVideoFile) {
            nvm.uploadCommand = UPLOAD_INSTAGRAM;
            }else
            {
            nvm.uploadCommand = SEND_TO_INSTAGRAM;
            }
            break;
        }
        case 3:
        {
            if (isVideoFile) {
                nvm.uploadCommand = UPLOAD_YOUTUBE;
            }
            else
            {
                nvm . uploadCommand = UPLOAD_CLIPBOARD;
            }
            
            break;
        }
        case 4:
        {
            if (isVideoFile) {
                nvm.uploadCommand = UPLOAD_VIDDY;
            }else
            {
                nvm.uploadCommand = UPLOAD_EMAIL;
            }
            break;
        }
        case 5:
        {
            if (isVideoFile) {
                nvm.uploadCommand = UPLOAD_PHOTO_ALBUM;
            }else
            {
                nvm.uploadCommand = UPLOAD_PHOTO_ALBUM;
            }
            
            break;
        }
        case 6:
        {
            nvm.uploadCommand = UPLOAD_EMAIL;
            break;
        }
        default:
            break;
    }
    
    if (isVideoFile)
    {
        [self uploadVideo];
    }else
    {
        [self uploadImage];
    }
     
    
}

-(void)closeShareView
{
    UIImageView *shareView = (UIImageView *)[self.view viewWithTag:2134];
    NSArray *viewToRemove = [shareView subviews];
    for (UIView *v in viewToRemove) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        shareView.frame = CGRectMake(0, full_screen.size.height, full_screen.size.width, 0);
        
    }completion:^(BOOL finished)
     {
         if (nil!= shareView) {
             [customTabBar unselectCurrentSelectedTab];
             [shareView removeFromSuperview];
             [self releaseToolBarIfAny];
             
             [self addToolbarWithTitle:@"Select Image" tag:TAG_TOOLBAR_SHARE];
         }
     }];
    if (shareView != nil) {
        shareView = nil;
    }
    
}

#endif
-(void)showResolutionOptios
{
    
    CGRect full               = [[UIScreen mainScreen]bounds];
    CGRect shareRect          = CGRectMake(full.size.width-55.0, customTabBar.frame.origin.y, full_screen.size.width, 50);
    // NSMutableArray *menuItems = [[NSMutableArray alloc]initWithCapacity:1];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        shareRect.origin.x = shareRect.origin.x - 60.0;
    }
    
    
    KxMenuItem *title    = [KxMenuItem menuItem:@"Resolution"
                                          image:nil
                                         target:nil
                                         action:NULL];
    KxMenuItem *res_2400 = [KxMenuItem menuItem:@"2400 x 2400"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_2400.tag         = RESOLUTION_PIXCOUNT_HIGH0;
    KxMenuItem *res_2100 = [KxMenuItem menuItem:@"2100 x 2100"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_2100.tag         = RESOLUTION_PIXCOUNT_HIGH1;
    KxMenuItem *res_1800 = [KxMenuItem menuItem:@"1800 x 1800"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_1800.tag         = RESOLUTION_PIXCOUNT_MED0;
    KxMenuItem *res_1200 = [KxMenuItem menuItem:@"1200 x 1200"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_1200.tag         = RESOLUTION_PIXCOUNT_MED2;
    KxMenuItem *res_600  = [KxMenuItem menuItem:@"600 x 600"
                                          image:nil
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    res_600.tag          = RESOLUTION_PIXCOUNT_LOW1;
    
    NSArray *menuItems   = @[title,res_2400,res_2100,res_1800,res_1200,res_600];
    
    for(int index = 0; index < [menuItems count]; index++)
    {
        KxMenuItem *menuitem = menuItems[index];
        
        menuitem.alignment = NSTextAlignmentCenter;
    }
    
    KxMenuItem *first = menuItems[0];
    
    first.foreColor = PHOTO_DEFAULT_COLOR;
    
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:shareRect
                 menuItems:menuItems
                  delegate:self];
    
    
}


@end
