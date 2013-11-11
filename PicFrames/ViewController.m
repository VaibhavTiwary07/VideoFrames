//
//  ViewController.m
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "KxMenu.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/CALayer.h>
#import "OT_TabBar.h"
#import "VideoUploadHandler.h"
#import "GADBannerView.h"
#import "configparser.h"
#import "VideoSettings.h"
#import <MediaPlayer/MediaPlayer.h>
#import "InAppPurchasePreview.h"
#import "FTWButton.h"
#import "CMPopTipView.h"
#import "VideoSettingsController.h"
#import "HelpScreenViewController.h"

#import "CTAssetsPickerController.h"
#import <MediaPlayer/MediaPlayer.h>

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface ViewController () <KxMenuDelegate,OT_TabBarDelegate,UIPopoverControllerDelegate,PopoverViewDelegate,AVAudioPlayerDelegate,MPMediaPickerControllerDelegate,InAppPurchasePreviewViewDelegate>
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
    AVAudioPlayer *previewAudioPlayer;
    CMPopTipView *preViewControls;
    UISlider *previewAdjSlider;
    UILabel *previewTimeLabel;
    
    /* Add music */
    UIView *musicTrackCell;

    GADInterstitial *interstitial_; //fgthfjufghjghjk
    
    //asfadsfsdfsdfsd
 // Test ....

    
}
@property (nonatomic, retain) NSMutableArray *assets_array;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAsset *asset;
-(void)selectEditTab;
@end

@implementation ViewController
@synthesize assets_array;
@synthesize dateFormatter;
@synthesize tabBar;
@synthesize imageForEdit;
@synthesize applicationSuspended;
#pragma mark image editing

-(void)doneWithPhotoEffectsEditor:(NSTimer*)t
{
    UIImage *img = [t.userInfo objectForKey:@"image"];
    if(nil == img)
    {
        return;
    }
    
    [sess imageSelectedForPhoto:img];
}
#if SHAPE_CHAGING_SUPPORT
-(int)numberOfItemsInSqwController:(sgwController*)sender
{
    return [ShapeMapping shapeCount];
}

-(NSString*)sgwController:(sgwController*)sender titleForTheItemAtIndex:(int)index
{
    //return @"Shape";
    return [ShapeMapping nameOfTheShapeAtIndex:index];
}

-(UIImage*)sgwController:(sgwController*)sender imageForTheItemAtIndex:(int)index
{
    return [ssivView imageForShape:index];
}

-(void)sgwController:(sgwController*)sender itemDidSelectAtIndex:(int)index
{
    [sess shapePreviewSelectedForPhoto:index];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:notification_sgwcontroller_updatepreview object:nil];
}

-(BOOL)sgwController:(sgwController*)sender isItemLockedAtIndex:(int)index
{
    return [ShapeMapping getLockStatusOfShape:index group:FRAME_SHAPE_GROUP_1];
}

-(void)sgwControllerDidCancel:(sgwController*)sender initialItem:(int)index
{
    //[sess shapePreviewCancelled];
    [sess shapeSelectedForPhoto:index];
}

-(void)sgwController:(sgwController*)sender didDoneSelectingItemAtIndex:(int)index
{
    [sess shapeSelectedForPhoto:index];
}

-(UIImage*)previewImageForSgwController:(sgwController*)sender
{
    return [sess.frame renderToImageOfScale:2.0];
}

-(void)showShapes
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
-(void)imageSelected:(UIImage *)img
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
    NSLog(@"Popupmenu dismissed");
}

- (void)popupMenu:(PopupMenu*)sender itemDidSelectAtIndex:(int)index
{
    ImageSelectionHandler *ish = [[ImageSelectionHandler alloc]initWithViewController:self];
    switch(index)
    {
        case 0:
        {
            [ish handlePhotoAlbum];
            break;
        }
        case 1:
        {
            BOOL optOutVideoHelp = [[[NSUserDefaults standardUserDefaults]objectForKey:@"optOutVideoHelp"]boolValue];
            if(optOutVideoHelp)
            {
                [ish handleVideoAlbum];
            }
            else
            {
                [WCAlertView showAlertWithTitle:@"Info"
                                        message:@"Maximum video length supported is 30 seconds. Videos bigger than 30 seconds will be automatically trimmed to first 30 seconds"
                             customizationBlock:nil
                                completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView)
                 {
                     if(buttonIndex == 1)
                     {
                         [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:@"optOutVideoHelp"];
                     }
                     
                     [ish handleVideoAlbum];
                 }
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:@"Got it",nil];
            }
            
            break;
        }
        case 2:
        {
            [self clearCurImage];
            break;
        }

    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[self popupMenu:nil titleForItemAtIndex:index],@"Option", nil];
   // [Flurry logEvent:@"Popup Menu Selections" withParameters:dict];
}

-(void)showPhotoEffectsEditor
{
    [Utility removeActivityIndicatorFrom:self.view];

}

#if 1
-(void)showPhotoOptions:(NSTimer*)t
{
    float x = [[t.userInfo objectForKey:@"x_location"]floatValue];
    float y = [[t.userInfo objectForKey:@"y_location"]floatValue];
    UIImageView *v = [t.userInfo objectForKey:@"view"];
    
    PopupMenu *menu = menu = [[PopupMenu alloc]initWithFrame:CGRectMake(0, 0, 200.0, 300.0) style:UITableViewStylePlain delegate:self];
    [menu reloadData];
    [menu showPopupIn:v at:CGPointMake(x, y)];
    curPopupViewParent = [t.userInfo objectForKey:@"scrollview"];
}
#else
-(void)showPhotoOptions:(NSTimer*)t
{
    /* allocate menu items */
    KxMenuItem *photo    = [KxMenuItem menuItem:@"Select Photo"
                                          image:[UIImage imageNamed:@"malbum.png"]
                                         target:nil
                                         action:NULL];
    KxMenuItem *video = [KxMenuItem menuItem:@"Select Video"
                                          image:[UIImage imageNamed:@"menucamera.png"]
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];
    KxMenuItem *remove = [KxMenuItem menuItem:@"Remove"
                                          image:[UIImage imageNamed:@"trash.png"]
                                         target:self
                                         action:@selector(handleResolutionOptionSelection:)];

    NSArray *menuItems   = @[photo,video,remove];
    
    for(int index = 0; index < [menuItems count]; index++)
    {
        KxMenuItem *menuitem = menuItems[index];
        menuitem.alignment = NSTextAlignmentCenter;
    }
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = PHOTO_DEFAULT_COLOR;
    first.alignment = NSTextAlignmentCenter;
    
    float x = [[t.userInfo objectForKey:@"x_location"]floatValue];
    float y = [[t.userInfo objectForKey:@"y_location"]floatValue];
    CGRect rec = CGRectMake(x, y, 0.0, 0.0);
    UIImageView *v = [t.userInfo objectForKey:@"view"];
    
    [KxMenu showMenuInView:v
                  fromRect:rec
                 menuItems:menuItems
                  delegate:self];
}
#endif
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
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
        NSLog(@"userinfo before sending notification %@",usrInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:backgroundVideoSelected object:nil userInfo:usrInfo];
        NSLog(@"userinfo after sending notification %@",usrInfo);
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

-(void)openVideoAlbumForIpad
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

-(void)openPhotoAlbumForIpad
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

-(void)loadTheSession
{
    NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
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
        [self performHelp];
        nvm.videoTutorialWatched = YES;
    }
#if FULLSCREENADS_ENABLE
    if(bShowRevModAd)
    {
        //[[OT_AdControl sharedInstance]showInterstitialIn:self];
        //[[OT_FlurryAd sharedInstance]showFullscreenAd];
        bShowRevModAd = NO;
    }
#endif
}


#pragma mark Start saving video frames to HDD

-(UIImageOrientation)getOrientationFrom:(AVAssetTrack*)inputAssetTrack
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

-(CGSize)getOptimalSizeFor:(AVAssetTrack*)inputAssetTrack
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

-(void)writeFrame:(UIImage*)image atFrameIndex:(int)frmIndex videoIndex:(int)vidIndex ofTotalFrame:(int)frames
{
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *imgPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image_%d_%d.jpg",index,frmIndex]];*/
    NSString *imgPath = [sess pathForImageAtIndex:frmIndex inPhoto:vidIndex];
    
    [UIImageJPEGRepresentation(image, 0.8) writeToFile:imgPath atomically:YES];
    //if(frmIndex == 2)
    //{
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    //    NSLog(@"Saved image %f, %f image path %@",image.size.height,image.size.width,imgPath);
    //}
    
    float pr = (float)frmIndex/(float)frames;
    
    [self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:pr] waitUntilDone:YES];
}

-(void)saveVideoFramesToHDD:(AVAsset *)inputAsset onCompletion:(void (^)(BOOL status, NSMutableDictionary *videoInfo))completion
{
    NSAutoreleasePool *bpool = [NSAutoreleasePool new];
    NSError           *error = nil;
    AVAssetTrack      *inputAssetTrack = [[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    double duration = CMTimeGetSeconds([inputAsset duration]);
    double nrFrames = CMTimeGetSeconds([inputAsset duration]) * 30;
    int frameIndex = 0;
    int origCount = 0;
    int duplicateFrequency = 0;
    BOOL requiresDuplication = NO;
    
    //round the duration to 30 seconds
    if(duration > 30.0)
    {
        duration = 30.0;
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
        //NSLog(@"FrameDuplication Is Required - Original FPS %f frames %d required Frames %f duplicate frequency %d frames to duplicate %f",inputAssetTrack.nominalFrameRate,frameIndex,framesRequiredToReach30fps,duplicateFrequency,framesToDuplicate);
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
        NSLog(@"saveVideoFramesToHDD:Error While reading");
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
                    //NSLog(@"Duplicating %d with %d original count %d duplicate frequency %d",frameIndex,frameIndex-1,origCount,duplicateFrequency);
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
    
    //NSLog(@"Total frames(30fps) = %f duration %f fps %f original frames %f corrected frames %d", nrFrames,duration,inputAssetTrack.nominalFrameRate,inputAssetTrack.nominalFrameRate*duration,frameIndex);
    //  NSLog(@"Exiting thread nrframes - %f frameIndex %d",nrFrames,frameIndex);
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

-(void)updateProgress:(NSNumber*)prog
{
    /*UIProgressView *pv = (UIProgressView*)[self.view viewWithTag:3658];
    if(nil != pv)
    {
        [pv setProgress:[prog floatValue]];
    }*/
    
    UIImageView *touchBlock = (UIImageView*)[self.view viewWithTag:33658];
    if(nil != touchBlock)
    {
        //[touchBlock removeFromSuperview];
        
         UIProgressView *pv = (UIProgressView*)[self.view viewWithTag:3658];
         if(nil != pv)
         {
             [pv setProgress:[prog floatValue]];
         }
    }
}

-(void)removeProgressBar
{
    UIImageView *touchBlock = (UIImageView*)[self.view viewWithTag:33658];
    if(nil != touchBlock)
    {
        [touchBlock removeFromSuperview];
        /*
        UIProgressView *pv = (UIProgressView*)[self.view viewWithTag:3658];
        if(nil != pv)
        {
            [pv removeFromSuperview];
        }*/
    }
}

-(void)addprogressBarWithMsg:(NSString*)msgText
{
    CGRect full = [[UIScreen mainScreen]bounds];
    
    /* Add touch block view */
    UIImageView *touchBlock = [[UIImageView alloc]initWithFrame:full];
    touchBlock.userInteractionEnabled = YES;
    touchBlock.tag = 33658;
    [self.view addSubview:touchBlock];
    [touchBlock release];
    
    /* add lable and bar display frame */
    UIView *displayArea = [[UIView alloc]initWithFrame:CGRectMake(0, 0, full.size.width-150, 100)];
    displayArea.backgroundColor = [UIColor blackColor];
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
    [pv release];
}

#pragma mark end saving video frames to HDD
#pragma mark start generating video from images


-(NSDictionary*)getVideoSettings
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

-(void)addAudioFilesAtPath:(NSArray*)audioInfoArray
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
        if(nil == tracks)
        {
            NSLog(@"Audio Tracks doesn't exist");
            continue;
        }
        
        if((nil != tracks)&&(0 == tracks.count))
        {
            NSLog(@"Audio Tracks Doesn't exist");
            continue;
        }
        NSLog(@"Mixing Audion file %@ of duration %f",audioUrl.path,[[audInfo objectForKey:@"audioDuration"] doubleValue]);
        audioFileCount = audioFileCount + 1;
        double audioDuration = [[audInfo objectForKey:@"audioDuration"] doubleValue];
        
        if(audioDuration > videoDuration)
        {
            audioDuration = videoDuration;
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
#if 0
    if(0 == audioFileCount)
    {
        NSLog(@"No Audio files to mix");
        if(nil != completion)
        {
            completion(NO);
        }
        return;
    }
#endif
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputURL = outputFileUrl;
    
    [pool release];
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         
         //NSLog(@"Saving audio and video file to album");
         //save it to photo album
         //UISaveVideoAtPathToSavedPhotosAlbum([outputFileUrl path], nil, nil, nil);
         
         if(nil != completion)
         {
             completion(YES);
         }
     }];
}

-(float)getRenderSize
{
    float renderSize = 639.0;
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

-(void)continueGenerateVideo:(void (^)(BOOL status, NSString *videoPath))completion
{
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
    
    [self addWaterMarkToFrame];
    
    [sess enterNoTouchMode];
    
    /* we couldn't find the existing video, so lets generate one by ourself */
    for(frameIndex = 0; frameIndex < frameCount; frameIndex++)
    {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        
        //initialize the frame
        for(photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
        {
            Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
            
            UIImage *image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
            if(nil != image)
            {
                //pht.image  = image;
                pht.view.imageView.image = image;
            }
        }
#if 0
        int rendersize ;
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            rendersize = 639;
        }else
        {
            rendersize = 640;
            
        }
#endif
        /* render current frame */
        UIImage *img = [sess.frame renderToImageOfSize:CGSizeMake(renderSize, renderSize)];
        //UIImage *img = [sess.frame quickRenderToImageOfSize:CGSizeMake(639, 639)];
        
        CVPixelBufferRef buffer = [self pixelBufferFromUIImage:img size:img.size];
        [adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frameIndex, 30)];
        CVPixelBufferRelease(buffer);
        [pool release];
        
        float prg = (float)frameIndex/(float)frameCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            // update your UI here
            [self updateProgress:[NSNumber numberWithFloat:prg]];
            //[self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithFloat:prg] waitUntilDone:YES];
        });
        
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
                NSLog(@"Libraray Audio is valid");
            }
        }
        
        if(NO == librarayAudioValid)
        {
            for(int index = 0; index < sess.frame.photoCount; index++)
            {
                NSURL *audioUrl = [sess getVideoUrlForPhotoAtIndex:index];
                if(nil == audioUrl)
                {
                    continue;
                }
                
                double duration = [sess getVideoDurationForPhotoAtIndex:index];
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
        
        [self addAudioFilesAtPath:audioFiles usingMode:NO toVideoAtPath:interVideoPath outputToFileAtApath:currentVideoPath onCompletion:^(BOOL status) {
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
#pragma mark end saving video frames to HDD
#pragma mark video import
-(void)importVideo:(NSTimer *)timer
{
    NSURL *videoURL = [timer.userInfo objectForKey:@"videoPath"];
    if(nil == videoURL)
    {
        NSAssert(nil != videoURL,@"Video path is nil to import");
    }
    
    NSString *localPath = [[sess saveVideoToDocDirectory:videoURL]retain];
    
    /* Initialize AVImage Generator */
    AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];

    [inputAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler: ^{
        
        [self performSelectorOnMainThread:@selector(addprogressBarWithMsg:) withObject:@"Importing Video" waitUntilDone:YES];
        
        [self saveVideoFramesToHDD:inputAsset onCompletion:^(BOOL status, NSMutableDictionary *videoInfo) {
            if(status == YES)
            {
                [self performSelectorOnMainThread:@selector(removeProgressBar) withObject:nil waitUntilDone:YES];
                /* Get the first image */
                UIImage *img = [UIImage imageWithContentsOfFile:[sess pathForImageAtIndex:2 inPhoto:[sess photoNumberOfCurrentSelectedPhoto]]];
                NSAssert(nil != img, @"Image in Video is nil, looks like video parsing went wrong");
                NSURL *url = [NSURL fileURLWithPath:localPath];
                [videoInfo setObject:url forKey:@"videoPath"];
                //[videoInfo setObject:img forKey:@"image"];
                NSDictionary *info = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:img,videoInfo, nil]
                                                                 forKeys:[NSArray arrayWithObjects:@"image",@"videoInfo", nil]];
                [self performSelectorOnMainThread:@selector(handleVideoSelectionWithInfo:) withObject:info waitUntilDone:NO];
            }
        }];
    }];
    
    return;
}

-(void)generateVideo:(void (^)(BOOL status,NSString *videoPath))complete
{
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

-(void)generateAudioOfVideoFrame:(void (^)(BOOL status, NSString *audioPath))completion
{
    NSAutoreleasePool *bpool = [NSAutoreleasePool new];
    
    CMTime                audioStartTime = kCMTimeZero;
    int                   audioFileCount = 0;
    float                  kRecordingFPS = 30.0;
    BOOL                    serialMixing = NO;
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    BOOL userMusicEnabled = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY]boolValue];
    BOOL userMusicIsValid = NO;
    
    /* Check if user has selected the music from Library and enabled it */
    /*if(userMusicEnabled)
    {
        NSNumber *persistentId = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
        NSURL *audioUrl = [self getUrlFromMediaItemId:persistentId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(nil != completion)
            {
                NSLog(@"Found local audio file selected from libraray %@",audioUrl.path);
                completion(YES,audioUrl.path);
            }});
        [bpool release];
        return;
    }*/
    
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
            
            double maxVideoDuration = [sess getMaxVideoDuration];
            if(duration > maxVideoDuration)
            {
                duration = maxVideoDuration;
            }
            
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
        for(int index = 0; index < sess.frame.photoCount; index++)
        {
            NSURL *audioUrl = [sess getVideoUrlForPhotoAtIndex:index];
            if(nil == audioUrl)
            {
                continue;
            }
            
            double duration = [sess getVideoDurationForPhotoAtIndex:index];
            if(duration == 0.0)
            {
                continue;
            }
            
            AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
            NSArray      *tracks = [urlAsset tracksWithMediaType:AVMediaTypeAudio];
            
            if(nil == tracks)
            {
                NSLog(@"Audio Tracks doesn't exist");
                continue;
            }
            
            if((nil != tracks)&&(0 == tracks.count))
            {
                NSLog(@"Audio Tracks Doesn't exist");
                continue;
            }
            
            audioFileCount++;
            
            AVAssetTrack * audioAssetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
            AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                           preferredTrackID: kCMPersistentTrackID_Invalid];
            CMTime audioAssetDuration = CMTimeMake((int) (duration * kRecordingFPS), kRecordingFPS);
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,audioAssetDuration) ofTrack:audioAssetTrack atTime:audioStartTime error:nil];
            
            if(serialMixing)
            {
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

-(void)addWaterMarkToFrame
{
    if(NO == bought_watermarkpack)
    {
        float width = 172.0;
        float height = 50.0;
        CGRect waterMarkRect = CGRectMake(sess.frame.frame.size.width-width, sess.frame.frame.size.height-height, width, height);
        
        UILabel *waterMark = [[UILabel alloc]initWithFrame:waterMarkRect];
        waterMark.backgroundColor = [UIColor clearColor];
        waterMark.tag = TAG_WATERMARK_LABEL;
        waterMark.font = [UIFont boldSystemFontOfSize:13.0];
        waterMark.text = @"www.videocollageapp.com";
        waterMark.textColor = [UIColor whiteColor];
        [sess.frame addSubview:waterMark];
    }
}

-(void)removeWaterMarkFromFrame
{
    UILabel *waterMark = (UILabel*)[sess.frame viewWithTag:TAG_WATERMARK_LABEL];
    if(nil != waterMark)
    {
        [waterMark removeFromSuperview];
    }
}

-(void)updatePreviewFrame:(NSTimer*)timer
{
    int frameIndex = gCurPreviewFrameIndex;
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
    
    for(int photoIndex = 0; photoIndex < sess.frame.photoCount; photoIndex++)
    {
        Photo *pht = [sess.frame getPhotoAtIndex:photoIndex];
        
        UIImage *image = [sess getVideoFrameAtIndex:frameIndex forPhoto:photoIndex];
        if(nil != image)
        {
            //pht.image  = image;
            pht.view.imageView.image = image;
        }
    }
    [previewAdjSlider setValue:gCurPreviewFrameIndex];
    gCurPreviewFrameIndex++;
    
    if(0 == (gCurPreviewFrameIndex%30))
    {
        previewTimeLabel.text = [self getCurrentPreviewTime];
    }
}

-(void)playPreviewOfVideoFrame
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
            
            gTotalPreviewFrames = [sess getFrameCountOfFrame:sess.frame];
            gCurPreviewFrameIndex = 0;
            
            /* Started  */
            //NSLog(@"updatePreviewFrame:updating frame %d Started ",gTotalPreviewFrames);
            
            if(NO == gIsPreviewPaused)
            {
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
            gIsPreviewInProgress = NO;
            gIsPreviewPaused = NO;
            gTotalPreviewFrames = 0;
            gCurPreviewFrameIndex = 0;
            
        }
    }];

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player release];
    previewAudioPlayer = nil;
}

-(void)previewVideo
{
    [self playPreviewOfVideoFrame];
}

-(void)pausePreView
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

-(void)resumePreview
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

-(void)stopPreview
{
    if(gIsPreviewInProgress)
    {
        gCurPreviewFrameIndex = gTotalPreviewFrames;
        
        if (nil != previewAudioPlayer)
        {
            [previewAudioPlayer stop];
        }
        
        gIsPreviewInProgress = NO;
    }
}

-(void)handleVideoSelectionWithInfo:(NSDictionary*)info
{
    UIImage *img = [info objectForKey:@"image"];
    NSDictionary *videoInfo = [info objectForKey:@"videoInfo"];

    [sess videoSelectedForCurrentPhotoWithInfo:videoInfo image:img];
}

-(void)handleImageSelection:(NSTimer*)timer
{
    if(_editWhileImageSelection)
    {
        UIImage *image = [timer.userInfo objectForKey:@"image"];
        [image retain];
        [sess imageSelectedForPhoto:image];
    }
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
        NSLog(@" *******  loadSession ********");
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
        
        UIImage *img = [[notification userInfo] objectForKey:@"backgroundImageSelected"]; 
        if(nil == img)
        {
            return;
        }
        
        _editWhileImageSelection = YES;
        //self.imageForEdit = img;
        [sess deleteCurrentAudioMix];
        [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"LOADING",@"Loading")];

        NSDictionary *input = [NSDictionary dictionaryWithObject:img forKey:@"image"];
        //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showPhotoEffectsEditor) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleImageSelection:) userInfo:input repeats:NO];
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
    else if([[notification name] isEqualToString:OT_FBBackgroundImageSelected])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            /* First Dismiss the popover */
            [backgroundPopover dismissPopoverAnimated:YES];
        }
        
        UIImage *img = [[notification userInfo] objectForKey:OT_FBBackgroundImageKey];
        if(nil == img)
        {
            return;
        }
        
        _editWhileImageSelection = YES;
        self.imageForEdit = img;
        [Utility addActivityIndicatotTo:self.view withMessage:NSLocalizedString(@"LOADING",@"Loading")];

        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showPhotoEffectsEditor) userInfo:nil repeats:NO];
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
        [self KxMenuWillDismissByUser:nil];
    }
    else if([[notification name]isEqualToString:@"notificationdidfinishwithframeview"])
    {
        NSLog(@"ghghghghhghghghghghghghghhghghgh");
        [self.navigationController popViewControllerAnimated:NO];
       [[NSNotificationCenter defaultCenter]postNotificationName:@"notificationDidEnterToFirstScreen" object:nil];
    }
    return;
}

-(void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:nil 
                                                  object:nil];
}

-(void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:) 
                                                 name:nil
                                               object:sess];
}

-(void)dealloc
{
    [self unregisterForNotifications];

    [super dealloc];
}
#pragma frame thumbnail image generation

#pragma mark first time processing
-(void)generateTheResourcesRequiredOnFirstRun
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

-(void)showFrameSelectionController
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

-(void)removeWaterMark:(id)sender
{
    [[InAppPurchaseManager Instance]puchaseProductWithId:kInAppPurchaseRemoveWaterMarkPack];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];



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

#if STANDARD_TABBAR
    /* Allocate tabbar and add tabbar items to it */
    tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, full_screen.size.height-50.0, full_screen.size.width, 50.0)];
    
    UITabBarItem *frames = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"FRAMES", @"Frames")
                                                        image:[UIImage imageNamed:@"Frames.png"]
                                                          tag:0];
    UITabBarItem *select = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"SELECT", @"Select")
                                                        image:[UIImage imageNamed:@"move.png"]
                                                          tag:1];
    UITabBarItem *swap =   [[UITabBarItem alloc]initWithTitle:@"Adjust"
                                                        image:[UIImage imageNamed:@"colorpickernew.png"]
                                                          tag:2];
    UITabBarItem *share =  [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"SHARE", @"Share")
                                                        image:[UIImage imageNamed:@"uploadnew.png"]
                                                          tag:2];
    
    tabBar.items    = [NSArray arrayWithObjects:frames,select,swap,share, nil];
    tabBar.delegate = self;
    
    [self.view addSubview:tabBar];
    [tabBar release];
    [frames release];
    [select release];
    [swap release];
    [share release];
    
    UIImageView *imgview = (UIImageView*)self.view;
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        imgview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"mainbackground_ipad" ofType:@"png"]];
    }
    else
    {
        imgview.image = [UIImage imageWithContentsOfFile:[Utility documentDirectoryPathForFile:@"mainbackground.jpg"]];
    }
    
#else
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.view = imgview;
    self.view.userInteractionEnabled = YES;
    
    if(NO == bought_watermarkpack)
    {
        UIButton *removeWaterMark = [UIButton buttonWithType:UIButtonTypeCustom];
        removeWaterMark.frame = CGRectMake(0,50,full_screen.size.width,30);
        removeWaterMark.backgroundColor = PHOTO_DEFAULT_COLOR;
        [removeWaterMark setTitle:@"Remove Watermark" forState:UIControlStateNormal];
        removeWaterMark.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        removeWaterMark.alpha = 0.8;
        removeWaterMark.showsTouchWhenHighlighted = YES;
        removeWaterMark.tag = TAG_WATERMARK_BUTTON;
        [removeWaterMark addTarget:self action:@selector(removeWaterMark:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:removeWaterMark];
    }
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        imgview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"background~ipad" ofType:@"png"]];
         [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-70,full_screen.size.width,70)];
    }
    else
    {
        imgview.image = [UIImage imageNamed:@"background"];
         [self allocateUIForTabbar:CGRectMake(0,full_screen.size.height-50,full_screen.size.width,50)];
    }
    

#endif
    

#if STANDARD_TABBAR    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        if([self.tabBar respondsToSelector:@selector(setBackgroundImage:)])
        {
            if(self.tabBar.items.count == 5)
            {
                self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar5.png"];
                self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabselection5.png"];
            }
            else
            {
                self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar4.png"];
                self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabselection4.png"];
            }
        }
    }
#endif
    
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
    [[configparser Instance] showAdInView:self.view atPoint:point];
    [[configparser Instance] bringAdToTheTop];
    
    return;
}
-(void)allocateUIForTabbar:(CGRect )rect
{
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
    customTabBar.backgroundImage = [UIImage imageNamed:@"bottom bar"];
    customTabBar.delegate        = self;
    customTabBar.items = [NSArray arrayWithObjects:frames,colorAndPattern,adjustSettings,videoSettings,preview,share, nil];

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
#if BANNERADS_ENABLE
    //[[OT_AdControl sharedInstance]removeBannerAds];
#endif
    NSLog(@"View Did Unload----------------");
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
#if BANNERADS_ENABLE
    //[[OT_AdControl sharedInstance] pauseBannerAds];
#endif
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#if BANNERADS_ENABLE
-(void)showBannerAd
{
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

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        banner_ID = admobpublishedid_ipad;
        aRect = CGRectMake(0, full_screen.size.height-70, full_screen.size.width, 70);
    }
    
    bannerView.adUnitID = banner_ID;
    bannerView.frame = aRect;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView.rootViewController = self;
    [self.view addSubview:bannerView];
    
    // Initiate a generic request to load it with an ad.
    [bannerView loadRequest:[GADRequest request]];
    [bannerView release];
}

-(void)adViewDidReceiveAd:(GADBannerView *)view
{
     CGRect rect;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        rect = CGRectMake(0, full_screen.size.height-140, full_screen.size.width, 70);
    }else
    {
        rect = CGRectMake(0, full_screen.size.height-100, full_screen.size.width, 50);
    }


    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         customTabBar.frame = rect;
                     }
                     completion:nil ];
}

-(void)adView:(GADBannerView*)banner didFailToReceiveAdWithError:(GADRequestError*)error
{
    //Never gets called, should be called when both iAd and AdMob fails.
    [self hideBannerAd];
}

-(void)hideBannerAd
{
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
    
    
    [UIView animateWithDuration:0.1 delay:0.1
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^{
                         customTabBar.frame = rect;
                     }
                     completion:nil ];
    
    return;
}
#endif

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#if BANNERADS_ENABLE
    [self showBannerAd];
    
    //[[OT_AdControl sharedInstance] resumeBannerAds];
#endif
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
#if 0    
    UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(radiusSettingsBgnd.frame.origin.x+radiusSettingsBgnd.frame.size.width-25.0, 0, 25, 25)];
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"close" ofType:@"png"]];
    [close setImage:img forState:UIControlStateNormal];
    [close addTarget:self action:@selector(exitAnySettings) forControlEvents:UIControlEventTouchUpInside];
    [radiusSettingsBgnd addSubview:close];
    [close release];
#endif
    
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
    aspectRatioView.backgroundColor = [UIColor blackColor];
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
        NSLog(@"Rectangle (%f,%f,%f,%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
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
    
    NSLog(@"Deleting %d images",[viewsForAnimation count]);
    
    [viewsForAnimation release];
    
    [sess deleteCurrentAudioMix];
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
        NSLog(@"Rectangle (%f,%f,%f,%f)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
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
  
    NSLog(@"Deleting %d images",[viewsForAnimation count]);
    
    [viewsForAnimation release];
}

#pragma mark help implementation
-(void)performHelp
{
#if 0
    CGRect rect;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        rect = CGRectMake(10, 50, 600, 700);
    }
    else
    {
        rect = CGRectMake(10,50,300,380);
    }
    
    HelpGridView *hg = [[HelpGridView alloc]initWithFrame:rect];
    
    hg.center = self.view.center;
    
    [self.view addSubview:hg];
    
    [hg release];
#else

    HelpScreenViewController  *helpScreen = [[HelpScreenViewController alloc] init];
    [UIView transitionWithView:self.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        [self.view addSubview:helpScreen.view];
                    }
                    completion:NULL];
   // [self.view addSubview:helpScreen.view];
   // [helpScreen release];
#endif

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
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _appoxeeBadge = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
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
    [self addToolbarWithTitle:@"Select Images" tag:TAG_TOOLBAR_EDIT];
    
    if(nil == sess)
    {
        NSLog(@"load the session");
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
    NSLog(@"frame selected at index %d",index);
    sess.frameNumber = index;
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
        [sender setBackgroundImage:[UIImage imageNamed:@"play2"] forState:UIControlStateNormal];
        [self pausePreView];
    }
    else if(sender.tag == TAG_PREVIEW_PLAY)
    {
        sender.tag = TAG_PREVIEW_PAUSE;
        [sender setBackgroundImage:[UIImage imageNamed:@"pause2"] forState:UIControlStateNormal];
        [self resumePreview];
    }
}

-(NSString*)getCurrentPreviewTime
{
    int totalTime = gTotalPreviewFrames * (1.0/30.0);
    int elapsedTime = gCurPreviewFrameIndex * (1.0/30.0);
    int remainingSeconds = totalTime-elapsedTime;
    
    int mins = remainingSeconds/60;
    int seconds = remainingSeconds%60;
    
    return [NSString stringWithFormat:@"%d:%d",mins,seconds];
}

-(void)allocateResourcesForPreview:(OT_TabBarItem*)tItem
{
    /* check if it is video frame, if not exit from preview */
    if(NO == [sess anyVideoFrameSelected])
    {
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
        NSLog(@"Preview screen is already active");
        return;
    }
    
    [self addToolbarWithTitle:@"Preview" tag:TAG_TOOLBAR_PREVIEW];
    CGRect blockTouchRect = CGRectMake(0, 50, full_screen.size.width,full_screen.size.height-50.0-50.0);
    GADBannerView *bannerView = (GADBannerView*)[self.view viewWithTag:TAG_BANNERAD_VIEW];
    if(nil != bannerView)
    {
        blockTouchRect.size.height = blockTouchRect.size.height - bannerView.frame.size.height;
    }
    
    UIView *blockTouches = [[UIView alloc]initWithFrame:blockTouchRect];
    blockTouches.userInteractionEnabled = YES;
    blockTouches.tag = TAG_PREVIEW_BLOCKTOUCHES;
    [self.view addSubview:blockTouches];
    
    UIView *previewControlsBgnd = [[UIView alloc]initWithFrame:CGRectMake(0, 0, full_screen.size.width-25, 25)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    button.tag = TAG_PREVIEW_PAUSE;
    [button setBackgroundImage:[UIImage imageNamed:@"pause2"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(togglePreviewState:) forControlEvents:UIControlEventTouchUpInside];
    [previewControlsBgnd addSubview:button];

    previewTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(previewControlsBgnd.frame.size.width-25, 0, 25, 25.0)];
    previewTimeLabel.backgroundColor = [UIColor clearColor];
    previewTimeLabel.textColor = [UIColor whiteColor];
    previewTimeLabel.font = [UIFont boldSystemFontOfSize:12.0];
    previewTimeLabel.text = [self getCurrentPreviewTime];
    [previewControlsBgnd addSubview:previewTimeLabel];
    [previewTimeLabel release];
    
    previewAdjSlider = [CustomUI allocateCustomSlider:CGRectMake(button.frame.origin.x+button.frame.size.width+5, 0, previewControlsBgnd.frame.size.width-button.frame.size.width-button.frame.origin.x-10-previewTimeLabel.frame.size.width, 25)];
    previewAdjSlider.tag = RADIUS_TAG_INDEX+2;
    /* Configure the brush Slider  */
	previewAdjSlider.maximumValue     = [sess getFrameCountOfFrame:sess.frame];
	previewAdjSlider.minimumValue     = 0;
	previewAdjSlider.continuous       = NO;
    
    [previewControlsBgnd addSubview:previewAdjSlider];
    [previewAdjSlider release];

    preViewControls = [[CMPopTipView alloc]initWithCustomView:previewControlsBgnd];
    preViewControls.backgroundColor = [UIColor colorWithRed:78.0/256.0 green:78.0/256.0 blue:78.0/256.0 alpha:1.0];
    preViewControls.disableTapToDismiss = YES;
    [preViewControls presentPointingAtView:tItem inView:self.view animated:NO];
    [previewControlsBgnd release];
    //[preViewControls presentModalAtPoint:CGPointMake(180.0, full_screen.size.height-50) inView:self.view];
    
    [self previewVideo];
}

-(void)releaseResourcesForPreview
{
    if(NO == gIsPreviewInProgress)
    {
        [self releaseToolBarIfAny];
        
        UIView *blockTouches = [self.view viewWithTag:TAG_PREVIEW_BLOCKTOUCHES];
        if(nil != blockTouches)
        {
            [blockTouches removeFromSuperview];
        }
        
        [preViewControls dismissAnimated:NO];
        [preViewControls release];
        preViewControls = nil;
        
    }
    else
    {
        /* Make sure that we stop preview if it is going on */
        [self stopPreview];
    }
    
    //[preViewControls dismissAnimated:NO];
    
    /*
    UIButton *btn = (UIButton*)[self.view viewWithTag:TAG_PREVIEW_PAUSE];
    if(nil != btn)
    {
        [btn removeFromSuperview];
    }
    
    btn = (UIButton*)[self.view viewWithTag:TAG_PREVIEW_PLAY];
    if(nil != btn)
    {
        [btn removeFromSuperview];
    }*/
    
    /*
    UIView *blockTouches = [self.view viewWithTag:TAG_PREVIEW_BLOCKTOUCHES];
    if(nil != blockTouches)
    {
        [blockTouches removeFromSuperview];
    }
    
    [preViewControls dismissAnimated:NO];
    [preViewControls release];
    preViewControls = nil;*/
    
    /* Release resources */
    //[self releaseToolBarIfAny];
}

-(UIView*)allocateVideoSettingsCellWithRect:(CGRect)rect
{
    UIImageView *bgnd = [[UIImageView alloc]initWithFrame:rect];
    UIImageView *color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgnd.frame.size.width, bgnd.frame.size.height)];
    color.backgroundColor = [UIColor blackColor];
    color.alpha = 0.4;
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
    UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(cell.frame.size.width-switchWidth, 0, switchWidth, switchHeight)];
    swit.on = enableStatus;
    swit.tag = TAG_AUDIO_CELL_SWITCH;
    [cell addSubview:swit];
    swit.center = CGPointMake(swit.center.x, cell.center.y);
   
    /* Add action to switch */
    [swit addTarget:self
             action:@selector(handleUpadteAudioFromLibraraySwitchStatus:)
   forControlEvents:UIControlEventValueChanged];
    
    [swit release];
    
    return cell;
}

-(void)handleUpadteAudioFromLibraraySwitchStatus:(UISwitch*)swit
{
    /* Store enable status */
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:swit.on]
                                             forKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY];
    
    [sess deleteCurrentAudioMix];
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

/*
- (NSNumber *)getPersistentId:(MPMediaItemCollection *)collection atIndex:(int)index
{
    MPMediaItem *mediaItem = [collection.items objectAtIndex:index];
    NSNumber    *anId      = [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
    
    return anId;
}*/

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
    if(nil == mediaItems)
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
    
    
    /*
    OT_TabBarItem *item = [customTabBar getTabbarItemWithTag:4];
    if(nil != item)
    {
        [self allocateResourcesForVideoSettings:item];
    }
    else{
        NSLog(@"item is nil to show video settings");
    }*/
}

- (void)mediaPicker:(MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    BOOL selectedAudioForFirstTime = NO;
    
    [sess deleteCurrentAudioMix];
    
    /* Save MPMediaItem persistent ID */
    MPMediaItem *mediaItem = [[mediaItemCollection items]objectAtIndex:0];
    NSNumber *persistentId = [mediaItem valueForProperty:MPMediaItemPropertyPersistentID];
    
    NSLog(@"Saving Persistent Id %@",persistentId);
    
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
    NSNumber *mediaItemId  = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUDIOID_SELECTED_FROM_LIBRARY];
    CGRect    settingsRect = CGRectMake(0, 0, full_screen.size.width-20, 140);
    CGRect  musicTrackRect = CGRectMake(0, 0, settingsRect.size.width, settingsRect.size.height/2.0-1.25);
    CGRect selectTrackRect = CGRectMake(0, settingsRect.size.height/2.0+1.25,
                                        settingsRect.size.width, settingsRect.size.height/2.0-1.25);
    UIView       *settings = nil;
    BOOL      enableStatus = [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USE_AUDIO_SELECTED_FROM_LIBRARY]boolValue];
    
    
    /* Add settings title to toolbar */
    [self addToolbarWithTitle:@"Settings" tag:TAG_TOOLBAR_SETTINGS];
    
    settings = [[UIView alloc]initWithFrame:settingsRect];
    settings.backgroundColor = popup_color;
    settings.userInteractionEnabled = YES;
    
    if(nil != mediaItemId)
    {
        NSString *musicTitle   = [self getTitleFromMediaItemId:mediaItemId];
        UIImage  *musicImage   = [self getImageFromMediaItemId:mediaItemId];
        
        /* Allocate music track cell */
        musicTrackCell = [self allocateVideoSettingsCellWithRect:musicTrackRect
                                                                   title:musicTitle
                                                                   image:musicImage
                                                                  enable:enableStatus];
        [settings addSubview:musicTrackCell];
        [musicTrackCell release];
    }
    else
    {
        NSLog(@"Media Item id is nil");
        settingsRect = CGRectMake(settingsRect.origin.x, settingsRect.origin.y,
                                  settingsRect.size.width, settingsRect.size.height/2.0);
        settings.frame = settingsRect;
        selectTrackRect = CGRectMake(0, 0,settingsRect.size.width, settingsRect.size.height);
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
    [selectMusic addSubview:selectMusicButton];
    
    /* Lets add popup with music items */
    selectMusic.userInteractionEnabled = YES;
    [settings addSubview:selectMusic];
    [selectMusic release];
    
    popOver = [PopoverView showPopoverAtPoint:CGPointMake(tItem.center.x, customTabBar.frame.origin.y)
                                       inView:self.view
                              withContentView:settings
                                     delegate:self];
    [settings release];
    
    return;
}

-(void)releaseResourcesForVideoSetttings
{
    [self releaseToolBarIfAny];
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

#if 0
-(UIToolbar*)addToolbarWithTitle:(NSString*)title tag:(int)toolbarTag
{
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, 23)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    //label.shadowColor = UIColorFromRGB(0xe5e7eb);
    label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = UIColorFromRGB(0xFFFFFFFF);
    label.text = title;//NSLocalizedString(@"SWAPIMAGES", @"Select Images");
    label.font = [UIFont boldSystemFontOfSize:20.0];
    UIBarButtonItem *toolBarTitle = [[UIBarButtonItem alloc] initWithCustomView:label];
    [label release];
    
    UIBarButtonItem *newsBarButton = [[UIBarButtonItem alloc]initWithCustomView:_appoxeeBadge];
    newsBarButton.style = UIBarButtonItemStylePlain;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];

    [button addTarget:self action:@selector(performHelp) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    /* flexible toolbar item */
    UIBarButtonItem *flex1BarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flex2BarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *itms = [[NSArray alloc]initWithObjects:infoItem,flex1BarButton,toolBarTitle,flex2BarButton,newsBarButton,nil];
    
    /* Now allocate the toolbar */
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 0.0, fullScreen.size.width, 50.0)];
    toolBar.layer.shadowColor = [UIColor blackColor].CGColor;
    toolBar.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    toolBar.layer.shadowOpacity = 0.7;
    toolBar.layer.shadowRadius = 1.0;
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_ipad.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.tag = toolbarTag;
    [toolBar sizeToFit];
    
    /* set the toolbar items */
    [toolBar setItems:itms];
    
    [itms release];
    [flex1BarButton release];
    [flex2BarButton release];
    [toolBarTitle release];
    [infoItem release];
    [newsBarButton release];
    
    [self.view addSubview:toolBar];
    
    [toolBar release];
    
    return toolBar;
}
#else
-(UIImageView*)addToolbarWithTitle:(NSString*)title tag:(int)toolbarTag
{
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, 23)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = UIColorFromRGB(0xFFFFFFFF);
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    
    UIImageView *toolbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, fullScreen.size.width, 50.0)];
    toolbar.image = [UIImage imageNamed:@"top-bar_vpf"];
    toolbar.userInteractionEnabled = YES;
    toolbar.tag = TAG_TOOLBAR_EDIT;
    
    [toolbar addSubview:label];
    label.center = toolbar.center;
    [label release];
    
    UIButton *help = [UIButton buttonWithType:UIButtonTypeInfoLight];
    help. tintColor = [UIColor whiteColor];
    [help addTarget:self action:@selector(performHelp) forControlEvents:UIControlEventTouchUpInside];
    help.frame = CGRectMake(hepl_button_x, 0, 50, 50);
    [toolbar addSubview:help];
    help.showsTouchWhenHighlighted = YES;

    UIButton *proButton = [UIButton buttonWithType:UIButtonTypeCustom];
    proButton . tag = 8000;
    [proButton addTarget:self action:@selector(openProVersion) forControlEvents:UIControlEventTouchUpInside];
    [proButton setBackgroundImage:[UIImage imageNamed:@"pro 1.png"] forState:UIControlStateNormal];
    proButton.frame = CGRectMake(fullScreen.size.width-pro_x, 0, 50, 50);
    [toolbar addSubview:proButton];
    proButton.showsTouchWhenHighlighted = YES;

    [self addAnimationToProButton:proButton];

    
    _appoxeeBadge.frame = CGRectMake(fullScreen.size.width-appoxee_button_x, 12.5, 25, 25);
    _appoxeeBadge.showsTouchWhenHighlighted = YES;
    
    [toolbar addSubview:_appoxeeBadge];
    
    [self.view addSubview:toolbar];
    
    [toolbar release];
    int adjustDistanceFromWall = adviewdistancefromwall;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && full_screen.size.height== 480) {
        adjustDistanceFromWall = 0;
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        adjustDistanceFromWall =30;
    }

    [[configparser Instance] showAdInView:self.view atPoint:CGPointMake(fullScreen.size.width-adviewdistancefromwall-adviewsize, 50+adjustDistanceFromWall)];
    [[configparser Instance] bringAdToTheTop];
    
    return toolbar;
}
#endif

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
-(void)openProVersion
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
    
    
}

-(void)handleResolutionOptionSelection:(KxMenuItem*)item
{
    nvm.uploadResolution = item.tag;
    
    [self uploadSelected];
}

-(void)handleUploadOptionSelection:(KxMenuItem*)item
{
    nvm.uploadCommand    = item.tag;
 
    /* check if it is a video frame, for video frames we do not support resolution selection */
    if(YES == [sess anyVideoFrameSelected])
    {
        [self uploadSelected];
        
        return;
    }
    
    /* Lets open resolution selection */
    CGRect full          = [[UIScreen mainScreen]bounds];
    CGRect shareRect     = CGRectMake(full.size.width-80.0, full.size.height-50-20.0, 80.0, 50);
    OT_TabBarItem *shareItem = [customTabBar getTabbarItemWithTag:MODE_SHARE];
    if(nil != shareItem)
    {
        shareRect.origin.x = shareItem.frame.origin.x;
        shareRect.size.width = shareItem.frame.size.width;
        shareRect.size.height = shareItem.frame.size.height;
        NSLog(@"Sharerect is %f,%f",shareRect.origin.x,shareRect.origin.y);
    }
    

    //if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //{
    //    shareRect.origin.x = shareRect.origin.x - 180.0;
    //}
    
    /* allocate menu items */
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
    
    
    return;
}

-(void)KxMenuWillDismissByUser:(KxMenu*)menu
{
    NSLog(@"KxMenuWillDismissByUser");
    [self releaseResourcesForUpload];
    
    [customTabBar unselectCurrentSelectedTab];
    
    [self selectEditTab];
}

- (void)showUploadMenu:(UIButton *)sender
{
    
    CGRect full               = [[UIScreen mainScreen]bounds];
    CGRect shareRect          = CGRectMake(full.size.width-55.0, customTabBar.frame.origin.y, 55.0, 50);
    NSMutableArray *menuItems = [[NSMutableArray alloc]initWithCapacity:1];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        shareRect.origin.x = shareRect.origin.x - 60.0;
    }
    
    /* First Add all share options supported for both Image And Video */
    KxMenuItem *saveToAlbum = [KxMenuItem menuItem:@"Save to album"
                                             image:[UIImage imageNamed:@"6331-download.png"]
                                            target:self
                                            action:@selector(handleUploadOptionSelection:)];
    saveToAlbum.tag         = UPLOAD_PHOTO_ALBUM;
    [menuItems addObject:saveToAlbum];
    
    KxMenuItem *email       = [KxMenuItem menuItem:@"Email"
                                             image:[UIImage imageNamed:@"489-gmail.png"]
                                            target:self
                                            action:@selector(handleUploadOptionSelection:)];
    email.tag               = UPLOAD_EMAIL;
    [menuItems addObject:email];
    
    
    
    KxMenuItem *facebook    = [KxMenuItem menuItem:@"Facebook"
                                             image:[UIImage imageNamed:@"6485-facebook.png"]
                                            target:self
                                            action:@selector(handleUploadOptionSelection:)];
    facebook.tag            = UPLOAD_FACEBOOK_ALBUM;
    [menuItems addObject:facebook];
    KxMenuItem *instagram   = [KxMenuItem menuItem:@"Instagram"
                                             image:[UIImage imageNamed:@"6492-instagram.png"]
                                            target:self
                                            action:@selector(handleUploadOptionSelection:)];

    
    
    /* Clipboard support and twitter is there only for image */
    if(NO == [sess anyVideoFrameSelected])
    {
         instagram.tag           = SEND_TO_INSTAGRAM;
        [menuItems addObject:instagram];
        KxMenuItem *clipboard   = [KxMenuItem menuItem:@"Copy to Clipboard"
                                             image:[UIImage imageNamed:@"330-layers4.png"]
                                            target:self
                                            action:@selector(handleUploadOptionSelection:)];
        clipboard.tag           = UPLOAD_CLIPBOARD;
        [menuItems addObject:clipboard];
        
        /*KxMenuItem *twitter   = [KxMenuItem menuItem:@"Twitter"
                                                 image:[UIImage imageNamed:@"498-twitter.png"]
                                                target:self
                                                action:@selector(handleUploadOptionSelection:)];
        twitter.tag           = UPLOAD_TWITTER;
        [menuItems addObject:twitter];*/
    }
    else
    {
         instagram.tag           = UPLOAD_INSTAGRAM;
        [menuItems addObject:instagram];
        KxMenuItem *youtube   = [KxMenuItem menuItem:@"Youtube"
                                                 image:[UIImage imageNamed:@"youtube.png"]
                                                target:self
                                                action:@selector(handleUploadOptionSelection:)];
        youtube.tag           = UPLOAD_YOUTUBE;
        [menuItems addObject:youtube];
        
        KxMenuItem *viddy   = [KxMenuItem menuItem:@"Viddy"
                                               image:[UIImage imageNamed:@"viddy.png"]
                                              target:self
                                              action:@selector(handleUploadOptionSelection:)];
        viddy.tag           = UPLOAD_VIDDY;
        [menuItems addObject:viddy];
    }

    [KxMenu showMenuInView:self.view
                  fromRect:shareRect
                 menuItems:menuItems
                  delegate:self];
}

-(void)allocateResourcesForUpload
{
    [self addToolbarWithTitle:@"Share" tag:TAG_TOOLBAR_SHARE];
    
    /* first check if the frame is video frame or not */
    if([sess anyVideoFrameSelected])
    {
        [self generateVideo:^(BOOL status, NSString *videoPath)
        {
            if(YES == status)
            {
                [self performSelectorOnMainThread:@selector(showUploadMenu:) withObject:nil waitUntilDone:YES];
            }
        }];
    }
    else
    {
        /* show menu */
        [self showUploadMenu:nil];
    }
}

-(void)releaseResourcesForColorAndPatternSettings
{
    [self releaseToolBarIfAny];
    
    UIImageView *ta = (UIImageView*)[self.view viewWithTag:TAG_ADJUST_BG];
    if(nil != ta)
    {
        [ta removeFromSuperview];
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

#if 0
-(void)colorAndPalletSelectionChanged:(UISegmentedControl*)sgctrl
{
    if(nil == pickerView)
    {
        NSLog(@"colorAndPalletSelectionChanged:No tip view to add the color or pattern picker");
        return;
    }
    
    if(sgctrl.selectedSegmentIndex == 0)
    {
        GridView *pView = nil;
        UIView   *cView = nil;
        pView = (GridView*)[pickerView viewWithTag:TAG_PATTERNPICKER];
        if(nil != pView)
        {
            [pView removeFromSuperview];
        }
        
        cView = [self allocatePatternPicker:TAG_GRIDVIEW_COLOR];
        [pickerView addSubview:cView];
        [cView release];
    }
    else if(sgctrl.selectedSegmentIndex == 1)
    {
        GridView *pView = nil;
        UIView *cView   = nil;
        
        cView = [pickerView viewWithTag:TAG_COLORPICKER];
        if(nil != cView)
        {
            [cView removeFromSuperview];
        }
        
        pView = [self allocatePatternPicker:TAG_GRIDVIEW_PATTERN];
        [pickerView addSubview:pView];
        [pView release];
    }
    
}

-(GridView*)allocatePatternPicker:(int)colorORPattern
{
    GridView *grd = nil;
    
    if (colorORPattern == TAG_GRIDVIEW_COLOR)
    {
        grd = [[GridView alloc]initWithFrame:CGRectMake(20.0, 40.0, 200.0, 120.0) option:colorORPattern];
        grd.totalItemsCount = 48;
        grd.tag = TAG_COLORPICKER;
        grd.filePrefix = FILENAME_PATTERN_PREFIX;
        grd.userInteractionEnabled = YES;
        [grd setRowCount:2 colCount:4];
        grd.delegate = self;
    }
    else
    {
        grd = [[GridView alloc]initWithFrame:CGRectMake(20.0, 40.0, 200.0, 120.0) option:colorORPattern];
        grd.totalItemsCount = 54;
        grd.tag = TAG_PATTERNPICKER;
        grd.filePrefix = FILENAME_PATTERN_PREFIX;
        grd.userInteractionEnabled = YES;
        [grd setRowCount:2 colCount:4];
        grd.delegate = self;
    }
    
    return grd;
}

-(void)allocateResourcesForSettings
{
    CGRect fullScreen = [[UIScreen mainScreen]bounds];
    
    [self addToolbarWithTitle:@"Settings" tag:TAG_TOOLBAR_ADJUST];
    
    CGRect backgroundRect = CGRectMake(fullScreen.size.width-RADIUS_SETTINGS_WIDTH+40-5, full_screen.size.height-368-60.0, RADIUS_SETTINGS_WIDTH-40, 368.0);
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        backgroundRect = CGRectMake(fullScreen.size.width-RADIUS_SETTINGS_WIDTH+40-200, full_screen.size.height-348-60.0, RADIUS_SETTINGS_WIDTH-40, 348.0);
    }
    
    CGRect full = [[UIScreen mainScreen]bounds];
    UIView *touchSheiled = [[UIView alloc]initWithFrame:CGRectMake(0, 50.0, full.size.width, full.size.height-100)];
    touchSheiled.tag = TAG_ADJUST_TOUCHSHEILD;
    touchSheiled.userInteractionEnabled = YES;
    [self.view addSubview:touchSheiled];
    [touchSheiled release];
    
    UIView *blackBgnd = [[UIImageView alloc]initWithFrame:backgroundRect];
    blackBgnd.layer.cornerRadius = 10.0;
    blackBgnd.backgroundColor = [UIColor darkGrayColor];
    blackBgnd.alpha = 1.0;
    blackBgnd.tag = TAG_ADJUST_BGPAD;
    //  [self.view addSubview:blackBgnd];
    [blackBgnd release];
    
    UIImageView *backGround = [[UIImageView alloc]initWithFrame:backgroundRect];
    [self.view addSubview:backGround];
    backGround.backgroundColor = [UIColor darkGrayColor];
    backGround.tag = TAG_ADJUST_BG;
    [backGround release];
    backGround.userInteractionEnabled = YES;
    
    
    /* add radius sliders */
    CGRect       rect              = CGRectMake(RADIUS_SETTINGS_X, RADIUS_SETTINGS_Y, RADIUS_SETTINGS_WIDTH-40, RADIUS_SETTINGS_HEIGHT);
    UISlider    *outerRadius       = nil;
    UISlider    *innerRadius       = nil;
    //UIView *radiusSettingsBgnd = nil;
    UIFont *lblFont = [UIFont systemFontOfSize:14.0];
    float outerRadiusIndex = 10.0;
    float innerRadiusIndex = 50.0;
    float widthIndex       = 90.0;
    //float musicLibraryIndex       = 130.0;
    //float playseuqentialIndex = 170;
    
    UILabel *innerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+innerRadiusIndex, 150, 20)];
    innerRadiusLbl.tag = RADIUS_TAG_INDEX+1;
    innerRadiusLbl.font = lblFont;
    innerRadiusLbl.text = NSLocalizedString(@"INNERRADIUS", @"Inner Radius");
    innerRadiusLbl.textAlignment = UITextAlignmentLeft;
    innerRadiusLbl.backgroundColor = [UIColor clearColor];
    innerRadiusLbl.textColor = [UIColor whiteColor];
    
    
    innerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+100.0, rect.origin.y+innerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 20.0)];
    innerRadius.tag = RADIUS_TAG_INDEX+2;
    /* Configure the brush Slider  */
	innerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
	innerRadius.minimumValue     = 0.0;
	innerRadius.continuous       = YES;
	innerRadius.value            = sess.innerRadius;
    [innerRadius addTarget:self action:@selector(innerRadiusChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *outerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+outerRadiusIndex, 150, 20)];
    outerRadiusLbl.tag =RADIUS_TAG_INDEX+3;
    outerRadiusLbl.text = NSLocalizedString(@"OUTERRADIUS",@"Outer Radius");
    outerRadiusLbl.font = lblFont;
    outerRadiusLbl.textAlignment = UITextAlignmentLeft;
    outerRadiusLbl.backgroundColor = [UIColor clearColor];
    outerRadiusLbl.textColor = [UIColor whiteColor];
    
    
    /* Allocate the slider */
    outerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+100.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
    //outerRadius = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+100.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
    outerRadius.tag = RADIUS_TAG_INDEX+4;
    /* Configure the brush Slider  */
	outerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
	outerRadius.minimumValue     = 0;
	outerRadius.continuous       = YES;
	outerRadius.value            = sess.outerRadius;
    
    [outerRadius addTarget:self action:@selector(outerRadiusChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *widthLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+widthIndex, 150, 20)];
    widthLbl.tag =RADIUS_TAG_INDEX+5;
    widthLbl.text = NSLocalizedString(@"WIDTH",@"Width");
    widthLbl.font = lblFont;
    widthLbl.textAlignment = UITextAlignmentLeft;
    widthLbl.backgroundColor = [UIColor clearColor];
    widthLbl.textColor = [UIColor whiteColor];
    
    
    UISlider *width = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+100.0, rect.origin.y+widthIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
    width.tag = RADIUS_TAG_INDEX+6;
    /* Configure the brush Slider  */
	width.maximumValue     = 30;
	width.minimumValue     = 0;
	width.continuous       = YES;
	width.value            = sess.frameWidth;
    
    [width addTarget:self action:@selector(widthChanged:)
    forControlEvents:UIControlEventValueChanged];
    
    /*
    UILabel *selectMusicLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+musicLibraryIndex, 150, 20)];
    selectMusicLbl.tag =RADIUS_TAG_INDEX+6;
    selectMusicLbl.text = NSLocalizedString(@"Select Music",@"Select Music");
    selectMusicLbl.font = lblFont;
    selectMusicLbl.textAlignment = UITextAlignmentLeft;
    selectMusicLbl.backgroundColor = [UIColor clearColor];
    selectMusicLbl.textColor = [UIColor whiteColor];
    
    
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton . tag = RADIUS_TAG_INDEX + 7;
    chooseButton . frame = CGRectMake(selectMusicLbl.frame.origin.x+selectMusicLbl.frame.size.width+13 , rect.origin.y+musicLibraryIndex, 60, 25);
    [chooseButton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [chooseButton setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    
    
    UILabel *playSeuqentiallylbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+playseuqentialIndex, 155, 20)];
    playSeuqentiallylbl.tag =RADIUS_TAG_INDEX+8;
    playSeuqentiallylbl.text = NSLocalizedString(@"Play Video Seuqentially",@"Play Video Sequentially");
    playSeuqentiallylbl.font = lblFont;
    playSeuqentiallylbl.textAlignment = UITextAlignmentLeft;
    playSeuqentiallylbl.backgroundColor = [UIColor clearColor];
    playSeuqentiallylbl.textColor = [UIColor whiteColor];
    
    UISwitch *onOffSwitch = [[UISwitch alloc] init];
    onOffSwitch . frame = CGRectMake(playSeuqentiallylbl.frame.origin.x+playSeuqentiallylbl.frame.size.width ,
                                     rect.origin.y+playseuqentialIndex,
                                     40, 20);
    onOffSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    onOffSwitch.tag = RADIUS_TAG_INDEX+9;
    [onOffSwitch addTarget:self action:@selector(onOrOff:) forControlEvents:UIControlEventValueChanged];
    */
    
    [backGround addSubview:innerRadiusLbl];
    [backGround addSubview:outerRadiusLbl];
    [backGround addSubview:innerRadius];
    [backGround addSubview:outerRadius];
    [backGround addSubview:widthLbl];
    [backGround addSubview:width];
    //[backGround addSubview:selectMusicLbl];
    //[backGround addSubview:chooseButton];
    //[backGround addSubview:playSeuqentiallylbl];
    //[backGround addSubview:onOffSwitch];
    
    
    [width release];
    [widthLbl release];
    [innerRadiusLbl release];
    [outerRadius release];
    [innerRadius release];
    [outerRadiusLbl release];
    
    
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y+widthIndex+120, 250, 150)];
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
    
    UIView *pickerBg = [self allocatePatternPicker:TAG_GRIDVIEW_COLOR];
    
    [pickerView addSubview:pickerBg];
    
    [backGround addSubview:pickerView];
    
    
    popOver = [PopoverView showPopoverAtPoint:CGPointMake(full_screen.size.width/2-30, full.size.height- toolbar_height) inView:self.view withContentView:backGround delegate:self];
    
    /* relelase picker bg */
    [pickerBg release];
    [pickerView release];
}

-(void)colorItemSelected:(UIColor *)selectedColor
{
    sess.color = selectedColor;
}

-(void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    [customTabBar setSelectedItem:1];
}
#else
-(void)colorAndPalletSelectionChanged:(UISegmentedControl*)sgctrl
{
    if(nil == pickerView)
    {
        NSLog(@"colorAndPalletSelectionChanged:No tip view to add the color or pattern picker");
        return;
    }
    
    if(sgctrl.selectedSegmentIndex == 0)
    {
        GridView *pView = nil;
        UIView   *cView = nil;
        pView = (GridView*)[pickerView viewWithTag:TAG_PATTERNPICKER];
        if(nil != pView)
        {
            [pView removeFromSuperview];
        }
        
        cView = [self allocatePatternPicker:TAG_GRIDVIEW_COLOR];
        [pickerView addSubview:cView];
        [cView release];
    }
    else if(sgctrl.selectedSegmentIndex == 1)
    {
        GridView *pView = nil;
        UIView *cView   = nil;
        
        cView = [pickerView viewWithTag:TAG_COLORPICKER];
        if(nil != cView)
        {
            [cView removeFromSuperview];
        }
        
        pView = [self allocatePatternPicker:TAG_GRIDVIEW_PATTERN];
        [pickerView addSubview:pView];
        [pView release];
    }
    
}

-(GridView*)allocatePatternPicker:(int)colorORPattern
{
    GridView *grd = nil;
    
    if (colorORPattern == TAG_GRIDVIEW_COLOR)
    {
        grd = [[GridView alloc]initWithFrame:CGRectMake(20.0, 40.0, 200.0, 240.0) option:colorORPattern];
        //grd.totalItemsCount = 48;
        grd.totalItemsCount = 52;
        grd.tag = TAG_COLORPICKER;
        grd.filePrefix = FILENAME_PATTERN_PREFIX;
        grd.userInteractionEnabled = YES;
        [grd setRowCount:4 colCount:4];
        grd.delegate = self;
    }
    else
    {
        grd = [[GridView alloc]initWithFrame:CGRectMake(20.0, 40.0, 200.0, 240.0) option:colorORPattern];
        grd.totalItemsCount = 54;
        grd.tag = TAG_PATTERNPICKER;
        grd.filePrefix = FILENAME_PATTERN_PREFIX;
        grd.userInteractionEnabled = YES;
        [grd setRowCount:4 colCount:4];
        grd.delegate = self;
    }
    
    return grd;
}

-(void)releaseResourcesForAdjustSettings
{
    [self releaseToolBarIfAny];
    
    UIImageView *ta = (UIImageView*)[self.view viewWithTag:TAG_ADJUST_BG];
    if(nil != ta)
    {
        [ta removeFromSuperview];
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

-(void)allocateResourcesForAdjustSettings:(OT_TabBarItem*)tItem
{
    [self addToolbarWithTitle:@"Adjust" tag:TAG_TOOLBAR_ADJUST];
    
    CGRect backgroundRect = CGRectMake(0, 0, RADIUS_SETTINGS_WIDTH, 120);
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        backgroundRect = CGRectMake(0,0, RADIUS_SETTINGS_WIDTH, 120);
    }
    
    /* Add touch sheild */
    CGRect full = [[UIScreen mainScreen]bounds];
    UIView *touchSheiled = [[UIView alloc]initWithFrame:CGRectMake(0, 50.0, full.size.width, full.size.height-100)];
    touchSheiled.tag = TAG_ADJUST_TOUCHSHEILD;
    touchSheiled.userInteractionEnabled = YES;
    [self.view addSubview:touchSheiled];
    [touchSheiled release];
    
    /* Add background */
    UIImageView *backGround = [[UIImageView alloc]initWithFrame:backgroundRect];
    [self.view addSubview:backGround];
    backGround.backgroundColor = popup_color;
    backGround.tag = TAG_ADJUST_BG;
    [backGround release];
    backGround.userInteractionEnabled = YES;
    
    /* add radius sliders */
    CGRect       rect              = CGRectMake(RADIUS_SETTINGS_X, RADIUS_SETTINGS_Y, RADIUS_SETTINGS_WIDTH-40,         RADIUS_SETTINGS_HEIGHT);
    UISlider    *outerRadius       = nil;
    UISlider    *innerRadius       = nil;
    float outerRadiusIndex         = 10.0;
    float innerRadiusIndex         = 50.0;
    float widthIndex               = 90.0;
    UIFont *lblFont                = [UIFont systemFontOfSize:14.0];
    
    
    UILabel *innerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+innerRadiusIndex, 150, 20)];
    innerRadiusLbl.tag = RADIUS_TAG_INDEX+1;
    innerRadiusLbl.font = lblFont;
    innerRadiusLbl.text = NSLocalizedString(@"INNERRADIUS", @"Inner Radius");
    innerRadiusLbl.textAlignment = UITextAlignmentLeft;
    innerRadiusLbl.backgroundColor = [UIColor clearColor];
    innerRadiusLbl.textColor = [UIColor whiteColor];
    
    innerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+100.0, rect.origin.y+innerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 20.0)];
    innerRadius.tag = RADIUS_TAG_INDEX+2;
    /* Configure the brush Slider  */
	innerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
	innerRadius.minimumValue     = 0.0;
	innerRadius.continuous       = YES;
	innerRadius.value            = sess.innerRadius;
    [innerRadius addTarget:self action:@selector(innerRadiusChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *outerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+outerRadiusIndex, 150, 20)];
    outerRadiusLbl.tag =RADIUS_TAG_INDEX+3;
    outerRadiusLbl.text = NSLocalizedString(@"OUTERRADIUS",@"Outer Radius");
    outerRadiusLbl.font = lblFont;
    outerRadiusLbl.textAlignment = UITextAlignmentLeft;
    outerRadiusLbl.backgroundColor = [UIColor clearColor];
    outerRadiusLbl.textColor = [UIColor whiteColor];
    
    
    /* Allocate the slider */
    outerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+100.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
    //outerRadius = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+100.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
    outerRadius.tag = RADIUS_TAG_INDEX+4;
    /* Configure the brush Slider  */
	outerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
	outerRadius.minimumValue     = 0;
	outerRadius.continuous       = YES;
	outerRadius.value            = sess.outerRadius;
    
    [outerRadius addTarget:self action:@selector(outerRadiusChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *widthLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+widthIndex, 150, 20)];
    widthLbl.tag =RADIUS_TAG_INDEX+5;
    widthLbl.text = NSLocalizedString(@"WIDTH",@"Width");
    widthLbl.font = lblFont;
    widthLbl.textAlignment = UITextAlignmentLeft;
    widthLbl.backgroundColor = [UIColor clearColor];
    widthLbl.textColor = [UIColor whiteColor];
    
    
    UISlider *width = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+100.0, rect.origin.y+widthIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
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
    
    
    popOver = [PopoverView showPopoverAtPoint:CGPointMake(tItem.center.x, customTabBar.frame.origin.y)
                                       inView:self.view
                              withContentView:backGround
                                     delegate:self];
    
    //[self.view addSubview:backGround];

}

-(void)allocateResourcesForColorAndPatternSettings:(OT_TabBarItem*)tItem
{
    //CGRect fullScreen = [[UIScreen mainScreen]bounds];
    
    [self addToolbarWithTitle:@"Settings" tag:TAG_TOOLBAR_ADJUST];
    
    CGRect backgroundRect = CGRectMake(0, 0, RADIUS_SETTINGS_WIDTH-40, RADIUS_SETTINGS_WIDTH);
    
    if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
    {
        backgroundRect = CGRectMake(0,0, RADIUS_SETTINGS_WIDTH-40, RADIUS_SETTINGS_WIDTH);
    }
    
    CGRect full = [[UIScreen mainScreen]bounds];
    UIView *touchSheiled = [[UIView alloc]initWithFrame:CGRectMake(0, 50.0, full.size.width, full.size.height-100)];
    touchSheiled.tag = TAG_ADJUST_TOUCHSHEILD;
    touchSheiled.userInteractionEnabled = YES;
    [self.view addSubview:touchSheiled];
    [touchSheiled release];
    
    //UIView *blackBgnd = [[UIImageView alloc]initWithFrame:backgroundRect];
    //blackBgnd.layer.cornerRadius = 10.0;
    //blackBgnd.backgroundColor = [UIColor darkGrayColor];
    //blackBgnd.alpha = 1.0;
    //blackBgnd.tag = TAG_ADJUST_BGPAD;
    //[self.view addSubview:blackBgnd];
    //[blackBgnd release];
    
    UIImageView *backGround = [[UIImageView alloc]initWithFrame:backgroundRect];
    [self.view addSubview:backGround];
    backGround.backgroundColor = popup_color;
    backGround.tag = TAG_ADJUST_BG;
    [backGround release];
    backGround.userInteractionEnabled = YES;
    
    
    /* add radius sliders */
    //CGRect       rect              = CGRectMake(RADIUS_SETTINGS_X, RADIUS_SETTINGS_Y, RADIUS_SETTINGS_WIDTH-40, RADIUS_SETTINGS_HEIGHT);
    //UISlider    *outerRadius       = nil;
    //UISlider    *innerRadius       = nil;
    //UIView *radiusSettingsBgnd = nil;
    //UIFont *lblFont = [UIFont systemFontOfSize:14.0];
    //float outerRadiusIndex = 10.0;
    //float innerRadiusIndex = 50.0;
    //float widthIndex       = 90.0;
    //float musicLibraryIndex       = 130.0;
    //float playseuqentialIndex = 170;
    
    //UILabel *innerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+innerRadiusIndex, 150, 20)];
    //innerRadiusLbl.tag = RADIUS_TAG_INDEX+1;
    //innerRadiusLbl.font = lblFont;
    //innerRadiusLbl.text = NSLocalizedString(@"INNERRADIUS", @"Inner Radius");
    //innerRadiusLbl.textAlignment = UITextAlignmentLeft;
    //innerRadiusLbl.backgroundColor = [UIColor clearColor];
    //innerRadiusLbl.textColor = [UIColor whiteColor];
    
    
    //innerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+100.0, rect.origin.y+innerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 20.0)];
    //innerRadius.tag = RADIUS_TAG_INDEX+2;
    /* Configure the brush Slider  */
	//innerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
	//innerRadius.minimumValue     = 0.0;
	//innerRadius.continuous       = YES;
	//innerRadius.value            = sess.innerRadius;
    //[innerRadius addTarget:self action:@selector(innerRadiusChanged:)
    //      forControlEvents:UIControlEventValueChanged];
    
    
    //UILabel *outerRadiusLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+outerRadiusIndex, 150, 20)];
    //outerRadiusLbl.tag =RADIUS_TAG_INDEX+3;
    //outerRadiusLbl.text = NSLocalizedString(@"OUTERRADIUS",@"Outer Radius");
    //outerRadiusLbl.font = lblFont;
    //outerRadiusLbl.textAlignment = UITextAlignmentLeft;
    //outerRadiusLbl.backgroundColor = [UIColor clearColor];
    //outerRadiusLbl.textColor = [UIColor whiteColor];
    
    
    /* Allocate the slider */
    //outerRadius = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+100.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
    //outerRadius = [[UISlider alloc]initWithFrame:CGRectMake(rect.origin.x+100.0, rect.origin.y+outerRadiusIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
    //outerRadius.tag = RADIUS_TAG_INDEX+4;
    /* Configure the brush Slider  */
	//outerRadius.maximumValue     = RADIUS_SETTINGS_MAXIMUM;
	//outerRadius.minimumValue     = 0;
	//outerRadius.continuous       = YES;
	//outerRadius.value            = sess.outerRadius;
    
    //[outerRadius addTarget:self action:@selector(outerRadiusChanged:)
    //      forControlEvents:UIControlEventValueChanged];
    
    
    //UILabel *widthLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+widthIndex, 150, 20)];
    //widthLbl.tag =RADIUS_TAG_INDEX+5;
    //widthLbl.text = NSLocalizedString(@"WIDTH",@"Width");
    //widthLbl.font = lblFont;
    //widthLbl.textAlignment = UITextAlignmentLeft;
    //widthLbl.backgroundColor = [UIColor clearColor];
    //widthLbl.textColor = [UIColor whiteColor];
    
    
    //UISlider *width = [CustomUI allocateCustomSlider:CGRectMake(rect.origin.x+100.0, rect.origin.y+widthIndex, RADIUS_SETTINGS_SLIDER_WIDTH, 19.0)];
    //width.tag = RADIUS_TAG_INDEX+6;
    /* Configure the brush Slider  */
	//width.maximumValue     = 30;
	//width.minimumValue     = 0;
	//width.continuous       = YES;
	//width.value            = sess.frameWidth;
    
    //[width addTarget:self action:@selector(widthChanged:)
    //forControlEvents:UIControlEventValueChanged];
    
    /*
     UILabel *selectMusicLbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+musicLibraryIndex, 150, 20)];
     selectMusicLbl.tag =RADIUS_TAG_INDEX+6;
     selectMusicLbl.text = NSLocalizedString(@"Select Music",@"Select Music");
     selectMusicLbl.font = lblFont;
     selectMusicLbl.textAlignment = UITextAlignmentLeft;
     selectMusicLbl.backgroundColor = [UIColor clearColor];
     selectMusicLbl.textColor = [UIColor whiteColor];
     
     
     UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
     chooseButton . tag = RADIUS_TAG_INDEX + 7;
     chooseButton . frame = CGRectMake(selectMusicLbl.frame.origin.x+selectMusicLbl.frame.size.width+13 , rect.origin.y+musicLibraryIndex, 60, 25);
     [chooseButton addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
     [chooseButton setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
     
     
     UILabel *playSeuqentiallylbl = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x+10, rect.origin.y+playseuqentialIndex, 155, 20)];
     playSeuqentiallylbl.tag =RADIUS_TAG_INDEX+8;
     playSeuqentiallylbl.text = NSLocalizedString(@"Play Video Seuqentially",@"Play Video Sequentially");
     playSeuqentiallylbl.font = lblFont;
     playSeuqentiallylbl.textAlignment = UITextAlignmentLeft;
     playSeuqentiallylbl.backgroundColor = [UIColor clearColor];
     playSeuqentiallylbl.textColor = [UIColor whiteColor];
     
     UISwitch *onOffSwitch = [[UISwitch alloc] init];
     onOffSwitch . frame = CGRectMake(playSeuqentiallylbl.frame.origin.x+playSeuqentiallylbl.frame.size.width ,
     rect.origin.y+playseuqentialIndex,
     40, 20);
     onOffSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
     onOffSwitch.tag = RADIUS_TAG_INDEX+9;
     [onOffSwitch addTarget:self action:@selector(onOrOff:) forControlEvents:UIControlEventValueChanged];
     */
    
    //[backGround addSubview:innerRadiusLbl];
    //[backGround addSubview:outerRadiusLbl];
    //[backGround addSubview:innerRadius];
    //[backGround addSubview:outerRadius];
    //[backGround addSubview:widthLbl];
    //[backGround addSubview:width];
    //[backGround addSubview:selectMusicLbl];
    //[backGround addSubview:chooseButton];
    //[backGround addSubview:playSeuqentiallylbl];
    //[backGround addSubview:onOffSwitch];
    
    
    //[width release];
    //[widthLbl release];
    //[innerRadiusLbl release];
    //[outerRadius release];
    //[innerRadius release];
    //[outerRadiusLbl release];
    
    
    pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backGround.frame.size.width, backGround.frame.size.height)];
    pickerView.tag = TAG_COLORPICKER_BG;
    /* by default show the color picker */
    
    /* add segment control */
    NSArray *sgItems = [NSArray arrayWithObjects:NSLocalizedString(@"COLOR",@"Color"),NSLocalizedString(@"PATTERN",@"Pattern"), nil];
    UISegmentedControl *sgctrl = [[UISegmentedControl alloc]initWithItems:sgItems];
    sgctrl.frame = CGRectMake(0, 10, 150, 30);
    sgctrl.selectedSegmentIndex = 0;
    sgctrl.segmentedControlStyle = UISegmentedControlStyleBar;
    sgctrl.tintColor = [UIColor grayColor];
    sgctrl.center    = CGPointMake(pickerView.center.x, sgctrl.center.y);
    [sgctrl addTarget:self
               action:@selector(colorAndPalletSelectionChanged:)
     forControlEvents:UIControlEventValueChanged];
    [pickerView addSubview:sgctrl];
    [sgctrl release];
    
    UIView *pickerBg = [self allocatePatternPicker:TAG_GRIDVIEW_COLOR];
    
    [pickerView addSubview:pickerBg];
    
    [backGround addSubview:pickerView];
    
    
    popOver = [PopoverView showPopoverAtPoint:CGPointMake(tItem.center.x, customTabBar.frame.origin.y)
                                       inView:self.view
                              withContentView:backGround
                                     delegate:self];
    
    /* relelase picker bg */
    [pickerBg release];
    [pickerView release];
}

-(void)colorItemSelected:(UIColor *)selectedColor
{
    sess.color = selectedColor;
}

-(void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    //[customTabBar setSelectedItem:1];
    [customTabBar unselectCurrentSelectedTab];
    [self releaseResourcesForModeChange];
    [self selectEditTab];
}
#endif
-(void)releaseResourcesForUpload
{
    [self releaseToolBarIfAny];
    
    self.navigationController.navigationBar.hidden = YES;
}


#if STANDARD_TABBAR
-(void)releaseResourcesForModeChange
{
    switch (eMode)
    {
        case MODE_FRAMES:
        {
            [self releaseResourcesForFrames];
            break;
        }
        case MODE_EDIT:
        {
            [self releaseResourcesForEdit];
            break;
        }
        case MODE_FREEAPPS:
        {
            //[self releaseResourcesForFreeApps];
            [self releaseResourcesForAdjust];
            break;
        }
        case MODE_SHARE:
        {
            [self releaseResourcesForUpload];
            break;
        }
        case MODE_SWAP:
        {
            [self releaseResourcesForSwap];
            //[self releaseResourcesForUpload];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)tabBar:(UITabBar *)tab didSelectItem:(UITabBarItem *)item
{
    [self.tabBar setNeedsDisplay];
    
    /* First release resources of the previous mode */
    [self releaseResourcesForModeChange];
    
    if(nil == item)
    {
        eMode = MODE_MAX;
    }
    else
    {
        /* Now get the new mode */
        eMode = (eAppMode)item.tag;
    }
    
    /* handle the new mode */
    switch (eMode) 
    {
        case MODE_FRAMES:
        {
            [self allocateResourcesForFrames];
            break;
        }
        case MODE_EDIT:
        {
            [self allocateResourcesForEdit];
            break;
        }
        case MODE_FREEAPPS:
        {
            //[self allocateResourcesForFreeApps];
            [self allocateResourcesForAdjust];
            break;
        }
        case MODE_SHARE:
        {
            [self allocateResourcesForUpload];
            break;
        }
        case MODE_SWAP:
        {
            [self allocateResourcesForSwap];
            //[self allocateResourcesForUpload];
            break;
        }
        default:
        {
            break;
        }
    }
}
#else
-(void)releaseResourcesForModeChange
{
    [self releaseResourcesForEdit];
    
    switch (eMode)
    {
        case MODE_FRAMES:
        {
            [self releaseResourcesForFrames];
            break;
        }
        case MODE_COLOR_AND_PATTERN:
        {
            //[self releaseResourcesForSettings];
            [self releaseResourcesForColorAndPatternSettings];
            break;
        }
        case MODE_ADJUST_SETTINGS:
        {
            [self releaseResourcesForAdjustSettings];
            break;
        }
        case MODE_VIDEO_SETTINGS:
        {
            //[self releaseResourcesForSwap];
            [self releaseResourcesForVideoSetttings];
            break;
        }
        case MODE_SHARE:
        {
            [self releaseResourcesForUpload];
            break;
        }
        case MODE_PREVIEW:
        {
            [self releaseResourcesForPreview];
            break;
        }
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
            [self allocateResourcesForColorAndPatternSettings:tItem];
            break;
        }
        case MODE_ADJUST_SETTINGS:
        {
            //[self allocateResourcesForSettings:tItem];
            [self allocateResourcesForAdjustSettings:tItem];
            //[self allocateResourcesForSettings];
            //[self showRadiusSettings:nil fromFrame:CGRectMake(40, full_screen.size.height-50, 40, 50)];
            
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
        //case MODE_SWAP:
        //{
            //[self allocateResourcesForSwap];
        //    [self allocateResourcesForVideoSettings:tItem];
        //    break;
        //}
        case MODE_PREVIEW:
        {
            [self allocateResourcesForPreview:tItem];
            break;
        }
        default:
        {
            break;
        }
    }
}
#endif
#pragma mark smooth transition
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self == viewController)
    {
        [self selectEditTab];
        NSLog(@"--------willShowViewController-----------");
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
        /*
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"Instagram is not installed in your device. You need to install Instagram application to share your image with Instagram. Would you like to download it now?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download", nil];
        [alert show];
        [alert release];*/
    }
}

- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application
{
    [documentInteractionController release];
    documentInteractionController = nil;
}

-(void)uploadImage
{
    if(nvm.uploadCommand == UPLOAD_EMAIL)
    {
        [self uploadToEmail];
    }
#ifdef POSTCARD_SINCERLY   
    else if(nvm.uploadCommand == SEND_POSTCARD)
    {
        [self sendPostCard];
    }
#endif    
    else if(nvm.uploadCommand == SEND_TO_INSTAGRAM)
    {
        //[self orderPersanalItem];
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
    VideoUploadHandler *vHandler = [VideoUploadHandler alloc];
    vHandler.viewController = self;
    vHandler . _view = self.view;
    vHandler.applicationName = appname;
    vHandler.downloadUrl = @"http://www.videocollageapp.com";
    vHandler.website = @"http://www.videocollageapp.com";
    
    [vHandler uploadVideoAtPath:[sess pathToCurrentVideo] to:nvm.uploadCommand];
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

@end
