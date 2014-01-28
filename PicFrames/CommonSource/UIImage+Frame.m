//
//  UIImage+Frame.m
//  Effects
//
//  Created by OutThinking India Pvt Ltd on 21/12/12.
//  Copyright (c) 2012 OutThinking India Pvt Ltd. All rights reserved.
//

#import "UIImage+Frame.h"
#import "StaticFilterMappingPriv.h"
@implementation UIImage (frame)
+(NSString*)textureNameForType:(eStaticFrames)eType
{
    if(eType >= STATIC_FILTER_FRAME_LAST)
    {
        NSLog(@"UIImage(frameNameForType): Frame %d not supported",eType);
        return nil;
    }
    
    if(frame_maping[eType].eType != eType)
    {
        NSLog(@"UIImage(frameNameForType): frame Mapping is corrupted");
        return nil;
    }
    
    return [NSString stringWithFormat:@"%s",frame_maping[eType].name];
}
-(UIImage*)applyFrame:(eStaticFrames)eFrames onImageType:(eImageType1)eType1 value:(int)v
{
    /* Generate frame Image name */
    NSString *frameName = [NSString stringWithFormat:@"%s_%d",frame_maping[eFrames].name,eType1];
    NSString *framePath = [[NSBundle mainBundle]pathForResource:frameName ofType:@"png"];
    
    /* Check if the file really exist */
    if(nil == framePath)
    {
        NSLog(@"Failed to find the file %@",frameName);
        return nil;
    }
    
    /* Get the frame image */
    UIImage *frame = [UIImage imageWithContentsOfFile:framePath];
    if(nil == frame)
    {
        return nil;
    }
    
    /* apply frame */
    //return [self imageWithImage:self borderImage:frame covertToSize:self.size];
    if (v==1)
    {
        if ([frameName isEqualToString:@"NoFrame_0"])
        {
            return [UIImage imageNamed:@""];
        }
        else
        {
              return  frame;
        }
    }
    else
    {
        return    [self overlayWithImage:frame];
    }
    
   // return frame;

}
-(UIImage *)imageWithImage:(UIImage *)image borderImage:(UIImage *)borderImage covertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [borderImage drawInRect:CGRectMake( 0, 0, size.width, size.height )];
    [image drawInRect:CGRectMake( 10, 10, size.width , size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (UIImage *)overlayWithImage:(UIImage *)image2  {
    
    UIImage *image1 = self;
    CGRect drawRect = CGRectMake(0.0, 0.0, image1.size.width, image1.size.height);
    
    // Create the bitmap context
    CGContextRef    bitmapContext = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    CGColorSpaceRef colorRef;
    CGSize          size = CGSizeMake(image1.size.width, image1.size.height);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    
    bitmapBytesPerRow   = (size.width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * size.height);
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL) {
        
        return nil;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    colorRef = CGColorSpaceCreateDeviceRGB();
    
    bitmapContext = CGBitmapContextCreate (bitmapData, size.width, size.height,8,bitmapBytesPerRow,colorRef,kCGImageAlphaNoneSkipFirst);
    CGColorSpaceRelease(colorRef);
    if (bitmapContext == NULL)
    {

        // error creating context
        
        return nil;
    }
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    
    CGContextDrawImage(bitmapContext, drawRect, [image1 CGImage]);
    CGContextDrawImage(bitmapContext, drawRect, [image2 CGImage]);
    CGImageRef   img = CGBitmapContextCreateImage(bitmapContext);
    UIImage*     ui_img = [UIImage imageWithCGImage: img];
    
    CGImageRelease(img);
    CGContextRelease(bitmapContext);
    free(bitmapData);
    
    return ui_img;
}
@end
