//
//  Utility.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 9/20/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "Utility.h"


@implementation Utility
+(void)removeActivityIndicatorFrom:(UIView*)view
{
    MBProgressHUD *activity = (MBProgressHUD*)[view viewWithTag:TAG_ACTIVITYINDICATOR];
    if(nil != activity)
    {
        [activity removeFromSuperview];
        [activity release];
        activity = nil;
    }
    
    return;
}

+(CGPoint)screenCenter
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    
    return center;
}

+(void)addActivityIndicatotTo:(UIView*)view withMessage:(NSString*)msg;
{
    [Utility removeActivityIndicatorFrom:view];
#if 1
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
	
    //HUD.delegate = self;
    HUD.labelText = msg;
    HUD.tag       = TAG_ACTIVITYINDICATOR;
    
    [HUD show:NO];
#endif
}

+(void)updateActivityMessageInView:(UIView*)v to:(NSString*)msg
{
    MBProgressHUD *activity = (MBProgressHUD*)[v viewWithTag:TAG_ACTIVITYINDICATOR];
    if(nil != activity)
    {
        activity.labelText = msg;
    }
    
    return;
}

+(CGContextRef)createBitmapContext:(CGRect)targetSize
{
	CGFloat targetWidth = targetSize.size.width;
	CGFloat targetHeight = targetSize.size.height;
	size_t  fBytesPerRow = targetSize.size.width*4;
	size_t  fBitsPerComponent = 8;
    CGContextRef localContext;
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();

    /* Create the bitmap context */
    localContext = CGBitmapContextCreate(NULL, targetWidth, targetHeight, fBitsPerComponent,
                                         fBytesPerRow, colorSpaceInfo,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	
    /* Release the resources */
	CGColorSpaceRelease(colorSpaceInfo);
	
	return localContext; 
}

void pattern2Callback (void *info, CGContextRef context) 
{      
    UIImage *image = (id)info;
    CGImageRef imageRef = [image CGImage];
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
}

+(NSString*)frameThumbNailPathForFrameNumber:(int)framenum
{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
	NSString *pFileName    = nil;
	
	/* file name */
	pFileName = [NSString stringWithFormat:@"frame_t_%d.png",framenum];
    
	
	/* Return the path to the puzzle status information */
	return [docDirectory stringByAppendingPathComponent:pFileName];
}

+(NSString*)coloredFrameThumbNailPathForFrameNumber:(int)framenum
{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
	NSString *pFileName    = nil;
	
	/* file name */
	pFileName = [NSString stringWithFormat:@"frame_c_%d.png",framenum];
	
	/* Return the path to the puzzle status information */
	return [docDirectory stringByAppendingPathComponent:pFileName];
}

+(NSString*)helpImagePathForNumber:(int)framenum
{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
	NSString *pFileName    = nil;
	
	/* file name */
	pFileName = [NSString stringWithFormat:@"help_c_%d.png",framenum];
	
	/* Return the path to the puzzle status information */
	return [docDirectory stringByAppendingPathComponent:pFileName];
}

+(void)generateImagesForHelp
{
    NSString *filePath = nil;
    NSData *data = nil;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    NSAutoreleasePool *localPool     = [[NSAutoreleasePool alloc] init];
    
    filePath = [Utility helpImagePathForNumber:1];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:filePath])
    {
        //NSLog(@"generateImagesForHelp:Files already exist");
        return;
    }
    
    /* Create frame and generate the image */
    Frame *frame = [[Frame alloc]initWithFrameNumber:2];
    
    /* setTheWidth */
    [frame setWidth:5];
    
    /* configure the color */
    [frame setColor:[UIColor whiteColor]];
    
    /* Render The image */
    UIImage *img = [frame renderToImageOfScale:1.0];
    
    /* Save the image to document directory */
    data = UIImagePNGRepresentation(img);
    
    /* Now create the file with image contents */
    if(NO == [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:attributes])
    {
        NSLog(@"Failed to save the help image1");
    }
    
    /* generate image2 by setting image to the photo1 */
    filePath = [Utility helpImagePathForNumber:2];
    
    Photo *pht = [frame getPhotoAtIndex:0];
    pht.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help1" ofType:@"jpg"]];
    
    img = [frame renderToImageOfScale:1.0];
    
    /* Save the image to document directory */
    data = UIImagePNGRepresentation(img);
    
    /* Now create the file with image contents */
    if(NO == [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:attributes])
    {
        NSLog(@"Failed to save the help image2");
    }
    
    /* generate image2 by setting image to the photo1 */
    filePath = [Utility helpImagePathForNumber:3];
    
    pht = [frame getPhotoAtIndex:1];
    pht.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help2" ofType:@"jpg"]];
    //CGPoint pnt = pht.offset;
    //pht.offset = CGPointMake(0, 0);
    //pht.offset = CGPointMake(pnt.x, 100);
    
    img = [frame renderToImageOfScale:1.0];
    
    /* Save the image to document directory */
    data = UIImagePNGRepresentation(img);
    
    /* Now create the file with image contents */
    if(NO == [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:attributes])
    {
        NSLog(@"Failed to save the help image3");
    }
    
    /* release the frame */
    [frame release];
    
    [localPool release];
}

+(void)generateThumnailsForFrames
{
    int index = 0;
    NSString *filePath = nil;
    NSData *data = nil;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSNumber numberWithInt:511] forKey:NSFilePosixPermissions];
    NSAutoreleasePool *localPool     = [[NSAutoreleasePool alloc] init];
    
    for(index = 0; index < FRAME_COUNT; index++)
    {
        /* First verify if the image already exist, if exist do not proceed further */
        filePath = [Utility coloredFrameThumbNailPathForFrameNumber:index];
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath] == YES)
        {
            continue;
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        }
        
        /* Create frame and generate the image */
        Frame *frame = [[Frame alloc]initWithFrameNumber:index withBgColor:[UIColor whiteColor]];
        
        /* setTheWidth */
        [frame setWidth:20];
        
        /* configure the color */
        [frame setColor:[UIColor blackColor]];
        
        /* Render The image */
        UIImage *img = [frame renderToImageOfScale:0.2];
        
        /* Save the image to document directory */
        data = UIImagePNGRepresentation(img);
        
        /* Now create the file with image contents */
        if(NO == [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:attributes])
        {
            NSLog(@"Failed to save the thumnail for frame %d",index);
        }
        
        /* release the frame */
        [frame release];
    }
  
    for(index = 0; index < FRAME_COUNT; index++)
    {
        /* First verify if the image already exist, if exist do not proceed further */
        filePath = [Utility frameThumbNailPathForFrameNumber:index];
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath] == YES)
        {
            continue;
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        }
        
        /* Create frame and generate the image */
        Frame *frame = [[Frame alloc]initWithFrameNumber:index];
        
        /* setTheWidth */
        [frame setWidth:20];
        
        /* configure the color */
        [frame setColor:[UIColor whiteColor]];
        
        /* Render The image */
        UIImage *img = [frame renderToImageOfScale:0.2];
        
        /* Save the image to document directory */
        data = UIImagePNGRepresentation(img);
        
        /* Now create the file with image contents */
        if(NO == [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:attributes])
        {
            NSLog(@"Failed to save the thumnail for frame %d",index);
        }
        
        /* release the frame */
        [frame release];
    }
   
    for(index = UNEVEN_FRAME_INDEX; index < (UNEVEN_FRAME_INDEX+UNEVEN_FRAME_COUNT); index++)
    {
        /* First verify if the image already exist, if exist do not proceed further */
        filePath = [Utility coloredFrameThumbNailPathForFrameNumber:index];
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath] == YES)
        {
            continue;
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        }
        
        /* Create frame and generate the image */
        Frame *frame = [[Frame alloc]initWithFrameNumber:index withBgColor:[UIColor whiteColor]];
        
        /* setTheWidth */
        [frame setWidth:20];
        
        /* configure the color */
        [frame setColor:[UIColor blackColor]];
        
        /* Render The image */
        UIImage *img = [frame renderToImageOfScale:0.2];
        
        /* Save the image to document directory */
        data = UIImagePNGRepresentation(img);
        
        /* Now create the file with image contents */
        if(NO == [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:attributes])
        {
            NSLog(@"Failed to save the thumnail for frame %d",index);
        }
        
        /* release the frame */
        [frame release];
    }
    
    for(index = UNEVEN_FRAME_INDEX; index < (UNEVEN_FRAME_INDEX+UNEVEN_FRAME_COUNT); index++)
    {
        /* First verify if the image already exist, if exist do not proceed further */
        filePath = [Utility frameThumbNailPathForFrameNumber:index];
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath] == YES)
        {
            continue;
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        }
        
        /* Create frame and generate the image */
        Frame *frame = [[Frame alloc]initWithFrameNumber:index];
        
        /* setTheWidth */
        [frame setWidth:20];
        
        /* configure the color */
        [frame setColor:[UIColor whiteColor]];
        
        /* Render The image */
        UIImage *img = [frame renderToImageOfScale:0.2];
        
        /* Save the image to document directory */
        data = UIImagePNGRepresentation(img);
        
        /* Now create the file with image contents */
        if(NO == [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:attributes])
        {
            NSLog(@"Failed to save the thumnail for frame %d",index);
        }
        
        /* release the frame */
        [frame release];
    }
    
    [localPool release];
    
    return;
}

+(UIImage*)createPatternImageOfSize:(CGRect)rect withImage:(UIImage*)ptrn
{
    /* First create the context */
    CGContextRef context = [Utility createBitmapContext:rect];
    if(context == nil)
    {
        NSLog(@"createPatternImageOfSize: Failed to create context");
        return nil;
    }
    
    static const CGPatternCallbacks callbacks = { 0, &pattern2Callback, NULL };
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    //CGSize patternSize = CGSizeMake(315, 44);
    CGSize patternSize = ptrn.size;
    CGPatternRef pattern = CGPatternCreate((void*)ptrn, rect, CGAffineTransformIdentity, patternSize.width, patternSize.height, kCGPatternTilingConstantSpacing, true, &callbacks);
    CGFloat alpha = 1;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, rect); 
    
    CGImageRef colorref = CGBitmapContextCreateImage (context);
    
    UIImage *outImage = [UIImage imageWithCGImage:colorref];
    
    CGContextRelease(context);
    
    return outImage;
}

+(NSString*)documentDirectoryPathForFile:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    NSString *path         = [docDirectory stringByAppendingPathComponent:fileName];

    return path;
}

+(CGContextRef)createBitmapContextOfSize:(CGSize)targetSize
{
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	size_t  fBytesPerRow = targetSize.width*4;
	size_t  fBitsPerComponent = 8;
    CGContextRef localContext;
	
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();

    localContext = CGBitmapContextCreate(NULL, targetWidth, targetHeight, fBitsPerComponent,
                                         fBytesPerRow, colorSpaceInfo,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	
	
    /* Release the resources */
	CGColorSpaceRelease(colorSpaceInfo);
	
	return localContext; 
}

+(UIImage *)optimizedImage:(UIImage *)image withMaxResolution:(int)maxRes
{      
    CGImageRef imgRef           = image.CGImage;  
    CGFloat width               = CGImageGetWidth(imgRef);  
    CGFloat height              = CGImageGetHeight(imgRef);  
    CGAffineTransform transform = CGAffineTransformIdentity;  
    CGRect bounds               = CGRectMake(0, 0, width, height);  
    
#ifdef GRAYTOUCHCONTEXT    
    int kMaxResolution          = [DeviceHw optimizedResolution];
#else
    int kMaxResolution          = maxRes;
#endif
    
    if (width > kMaxResolution || height > kMaxResolution) 
    {  
        CGFloat ratio = width/height;  
        if (ratio > 1) 
        {  
            bounds.size.width = kMaxResolution;  
            bounds.size.height = bounds.size.width / ratio;  
        }  
        else 
        {  
            bounds.size.height = kMaxResolution;  
            bounds.size.width = bounds.size.height * ratio;  
        }  
    }  
    
    CGFloat scaleRatio = bounds.size.width / width;  
    CGSize imageSize   = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
    CGFloat boundHeight;  
    UIImageOrientation orient = image.imageOrientation;  
    
    switch(orient) 
    {  
            
        case UIImageOrientationUp: //EXIF = 1  
            transform = CGAffineTransformIdentity;  
            break;  
            
        case UIImageOrientationUpMirrored: //EXIF = 2  
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            break;  
            
        case UIImageOrientationDown: //EXIF = 3 
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);  
            transform = CGAffineTransformRotate(transform, M_PI);  
            break;  
            
        case UIImageOrientationDownMirrored: //EXIF = 4  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);  
            transform = CGAffineTransformScale(transform, 1.0, -1.0);  
            break;  
            
        case UIImageOrientationLeftMirrored: //EXIF = 5  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationLeft: //EXIF = 6  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRightMirrored: //EXIF = 7  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeScale(-1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRight: //EXIF = 8  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        default:  
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];  
            
    }  
    
    UIGraphicsBeginImageContext(bounds.size);  
    
    CGContextRef context = UIGraphicsGetCurrentContext();  
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) 
    {  
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
        CGContextTranslateCTM(context, -height, 0);  
    }  
    else 
    {  
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);  
        CGContextTranslateCTM(context, 0, -height);  
    }  
    
    CGContextConcatCTM(context, transform);  
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);  
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return imageCopy;  
}  

+(UIImage *)optimizedImage:(UIImage *)image
{      
    CGImageRef imgRef           = image.CGImage;  
    CGFloat width               = CGImageGetWidth(imgRef);  
    CGFloat height              = CGImageGetHeight(imgRef);  
    CGAffineTransform transform = CGAffineTransformIdentity;  
    CGRect bounds               = CGRectMake(0, 0, width, height);  
    
#ifdef GRAYTOUCHCONTEXT    
    int kMaxResolution          = [DeviceHw optimizedResolution];
#else
    int kMaxResolution          = 1024;
#endif
    
    if (width > kMaxResolution || height > kMaxResolution) 
    {  
        CGFloat ratio = width/height;  
        if (ratio > 1) 
        {  
            bounds.size.width = kMaxResolution;  
            bounds.size.height = bounds.size.width / ratio;  
        }  
        else 
        {  
            bounds.size.height = kMaxResolution;  
            bounds.size.width = bounds.size.height * ratio;  
        }  
    }  
    
    CGFloat scaleRatio = bounds.size.width / width;  
    CGSize imageSize   = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
    CGFloat boundHeight;  
    UIImageOrientation orient = image.imageOrientation;  
    
    switch(orient) 
    {  
            
        case UIImageOrientationUp: //EXIF = 1  
            transform = CGAffineTransformIdentity;  
            break;  
            
        case UIImageOrientationUpMirrored: //EXIF = 2  
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            break;  
            
        case UIImageOrientationDown: //EXIF = 3 
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);  
            transform = CGAffineTransformRotate(transform, M_PI);  
            break;  
            
        case UIImageOrientationDownMirrored: //EXIF = 4  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);  
            transform = CGAffineTransformScale(transform, 1.0, -1.0);  
            break;  
            
        case UIImageOrientationLeftMirrored: //EXIF = 5  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationLeft: //EXIF = 6  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRightMirrored: //EXIF = 7  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeScale(-1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        case UIImageOrientationRight: //EXIF = 8  
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);  
            break;  
            
        default:  
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];  
            
    }  
    
    UIGraphicsBeginImageContext(bounds.size);  
    
    CGContextRef context = UIGraphicsGetCurrentContext();  
    
    if(nil == context)
    {
        NSLog(@"Failed to get default context");
        context = [Utility createBitmapContextOfSize:bounds.size];
        if(nil == context)
        {
            NSLog(@"Failed to create context by ourself as well");
        }
    }
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) 
    {  
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
        CGContextTranslateCTM(context, -height, 0);  
    }  
    else 
    {  
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);  
        CGContextTranslateCTM(context, 0, -height);  
    }  
    
    CGContextConcatCTM(context, transform);  
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);  
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return imageCopy;  
}  

@end
