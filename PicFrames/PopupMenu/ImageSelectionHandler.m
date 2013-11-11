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

@interface ImageSelectionHandler()
{
    id _controller;
}
@end

@implementation ImageSelectionHandler

-(id)initWithViewController:(id)controller
{
    self = [super init];
    if(self)
    {
        _controller = controller;
        nvm = [Settings Instance];
    }
    
    return self;
}

-(void)videoSelected:(NSURL*)videoPath result:(NSString*)res
{
    if(nil != videoPath)
    {
        NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:videoPath forKey:backgroundVideoSelected];
        [[NSNotificationCenter defaultCenter] postNotificationName:backgroundVideoSelected object:nil userInfo:usrInfo];
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        {
          //  [[_controller navigationController] popToRootViewControllerAnimated:NO];
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
    }
    
    [self release];
}

-(void)imageSelected:(UIImage *)img result:(NSString*)res
{
    if(nil != img)
    {
        NSDictionary *usrInfo = [NSDictionary dictionaryWithObject:img forKey:@"backgroundImageSelected"];
        [[NSNotificationCenter defaultCenter] postNotificationName:backgroundImageSelected object:nil userInfo:usrInfo];
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
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
    }
    
    [self release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /* Dismiss the controller */
    [picker dismissModalViewControllerAnimated:NO];
    
    /* Get Media Type */
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo)
    {
        NSURL *moviePath = [info objectForKey:UIImagePickerControllerMediaURL];
        [moviePath retain];
        [self videoSelected:moviePath result:nil];
    }
    else
    {
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        /* Image selected */
        [self imageSelected:selectedImage result:nil];
    }
    
	return;
}

-(void)handlePhotoAlbum
{
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:openIpadPhotoAlbum object:nil userInfo:nil];
            return;
        }
        
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
        
        [_controller presentModalViewController:imgPicker animated:YES];
        
		/* Release the image picker */
		[imgPicker release];
	}
	else
	{
		UIAlertView *pickerAlert;
		
		pickerAlert = [[UIAlertView alloc] initWithTitle:@"Photo Library" message:@"Photo Library is not available to pick the background!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		
		/* Show the alert */
		[pickerAlert show];
		
		/* Release the alert */
		[pickerAlert release];
	}
	
	[localPool release];
	
	return;
}

-(void)handleVideoAlbum
{
    NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:openIpadVideoAlbum object:nil userInfo:nil];
            return;
        }
        
		/* Allocate the picker view */
		UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
		
		/* Set the source type */
		imgPicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
		
		/* Do not allow editing */
		imgPicker.allowsEditing = YES;
		
		/* Set th delegate for the picker view */
		imgPicker.delegate = self;
        
        //[imgPicker setVideoMaximumDuration:30.0];
        //[imgPicker setVideoQuality:UIImagePickerControllerQualityTypeLow];
		
		/* Set the model transition style */
		imgPicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        imgPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
        
        [_controller presentModalViewController:imgPicker animated:YES];
        
		/* Release the image picker */
		[imgPicker release];
	}
	else
	{
		UIAlertView *pickerAlert;
		
		pickerAlert = [[UIAlertView alloc] initWithTitle:@"Photo Library" message:@"Photo Library is not available to pick the background!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		
		/* Show the alert */
		[pickerAlert show];
		
		/* Release the alert */
		[pickerAlert release];
	}
	
	[localPool release];
	
	return;
}

-(void)handleCamera
{
	NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		/* Allocate the picker view */
		UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
		
		/* Set the source type */
		imgPicker.sourceType    = UIImagePickerControllerSourceTypeCamera;
		
		/* Do not allow editing */
		imgPicker.allowsEditing = NO;
		
		/* Set th delegate for the picker view */
		imgPicker.delegate = self;
		
		/* Set the model transition style */
		imgPicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        /* present the picker */
		[_controller presentModalViewController:imgPicker animated:YES];
		
		/* Release the image picker */
		[imgPicker release];
	}
    
	[localPool release];
	
	return;
}

-(void)handleFacebookAlbum
{
    if(NO == nvm.connectedToInternet)
    {
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FAILED",@"Failed") message:NSLocalizedString(@"NOINTERNET",@"No active internet connection to connect") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
        [alview show];
        [alview release];
        return;
    }
    
    [[OT_Facebook SharedInstance]selectImageUsing:_controller onCompletion:^(UIImage *selectedImage){
        [self imageSelected:selectedImage result:nil];
    }];
}

-(void)handleProfilePhoto
{
    if(NO == nvm.connectedToInternet)
    {
        UIAlertView *alview = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"FAILED",nil) message:NSLocalizedString(@"NOINTERNET",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
        [alview show];
        [alview release];
        return;
    }
    
    [[OT_Facebook SharedInstance]profilePhoto:^(UIImage *profilePhoto){
        [self imageSelected:profilePhoto result:nil];
    }];

    return;
}

@end
