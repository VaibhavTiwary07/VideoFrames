//
//  UIImage+texture.m
//  SimplePhotoFilter
//
//  Created by Vijaya kumar reddy Doddavala on 9/7/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "UIImage+texture.h"
#import "StaticFilterMappingPriv.h"

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }
/*
typedef struct
{
    char         name[50];
    eTextureType eType;
}tTexture;



static tTexture maping[TEXTURE_LAST] = {
    {"Paper",      TEXTURE_PAPER},
    {"Jeans",      TEXTURE_JEANS},
    {"Wall",       TEXTURE_WALL},
    {"Steel",      TEXTURE_STEEL},
    {"Old Paper",  TEXTURE_OLDPAPER},
    {"Cardboard",  TEXTURE_CARDBOARD}
};
*/
@implementation UIImage (texture)

+(NSString*)textureNameForType:(eStaticTextureFilter)eType
{
    if(eType >= STATIC_FILTER_TEXTURE_LAST)
    {
        NSLog(@"UIImage(textureNameForType): Texture %d not supported",eType);
        return nil;
    }
    
    if(texture_maping[eType].eType != eType)
    {
        NSLog(@"UIImage(textureNameForType): Texture Mapping is corrupted");
        return nil;
    }
    
    return [NSString stringWithFormat:@"%s",texture_maping[eType].name];
}

#if 0
-(UIImage*)blendOn:(UIImage*)dest from:(UIImage*)src inblendmode:(CGBlendMode)eMode withAlpha:(float)alpha
{
    CGFloat targetWidth  = CGImageGetWidth(dest.CGImage);
	CGFloat targetHeight = CGImageGetHeight(dest.CGImage);
	size_t  fBytesPerRow = targetWidth*4;
	size_t  fBitsPerComponent = 8;
    CGContextRef localContext;
	
	CGImageRef imageRef = [dest CGImage];
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
	
	if (dest.imageOrientation == UIImageOrientationUp || dest.imageOrientation == UIImageOrientationDown) 
	{
		localContext = CGBitmapContextCreate(NULL, targetWidth, targetHeight, fBitsPerComponent,
                                             fBytesPerRow, colorSpaceInfo,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	} 
	else 
	{
        fBytesPerRow = targetHeight * 4;
		localContext = CGBitmapContextCreate(NULL, targetHeight, targetWidth, fBitsPerComponent,
                                             fBytesPerRow, colorSpaceInfo,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	}
	
	CGContextSetBlendMode(localContext,eMode);
	
	if (dest.imageOrientation == UIImageOrientationLeft) 
    {
		CGContextRotateCTM (localContext, radians(90));
		CGContextTranslateCTM (localContext, 0, -targetHeight);
		
	} 
    else if (dest.imageOrientation == UIImageOrientationRight) 
    {
		CGContextRotateCTM (localContext, radians(-90));
		CGContextTranslateCTM (localContext, -targetWidth, 0);
		
	} 
    else if (dest.imageOrientation == UIImageOrientationUp) 
    {
		// NOTHING
	}
    else if (dest.imageOrientation == UIImageOrientationDown) 
    {
		CGContextTranslateCTM (localContext, targetWidth, targetHeight);
		CGContextRotateCTM (localContext, radians(-180.));
	}
    
    //CGContextSetInterpolationQuality(localContext, kCGInterpolationHigh);
    
    /* First Draw hires gray image */
	CGContextDrawImage(localContext, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    
	/* set the blend mode */
    CGContextSetBlendMode(localContext,eMode);
    //CGContextSetBlendMode(localContext,kCGBlendModeDestinationOut);
    
    CGContextSetAlpha(localContext, alpha);
    
    /* Draw the updated gray image */
    CGContextDrawImage(localContext, CGRectMake(0, 0, targetWidth, targetHeight), src.CGImage);
    
    /* generate the image out of current context */
    CGImageRef blendref = CGBitmapContextCreateImage (localContext);
    
    /* Assign the image */
    UIImage *blendedImage = [UIImage imageWithCGImage:blendref];
    
    /* Now translate the cntext */
    CGContextTranslateCTM(localContext, 0, targetHeight);
	CGContextScaleCTM(localContext, 1.0, -1.0);
    
    /* Release the resources */
    CGColorSpaceRelease(colorSpaceInfo);
    CGImageRelease(blendref);
    CGContextRelease(localContext);
	
	return blendedImage;
}
#else
-(UIImage*)blendOn:(UIImage*)dest from:(UIImage*)src inblendmode:(CGBlendMode)eMode withAlpha:(float)alpha
{
    CGFloat targetWidth  = CGImageGetWidth(dest.CGImage);
	CGFloat targetHeight = CGImageGetHeight(dest.CGImage);
	size_t  fBytesPerRow = targetWidth*4;
	size_t  fBitsPerComponent = 8;
    CGContextRef localContext;
	UIImageOrientation eOrientation = dest.imageOrientation;
	CGImageRef imageRef = [dest CGImage];
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
	
	if (dest.imageOrientation == UIImageOrientationUp || dest.imageOrientation == UIImageOrientationDown)
	{
		localContext = CGBitmapContextCreate(NULL, targetWidth, targetHeight, fBitsPerComponent,
                                             fBytesPerRow, colorSpaceInfo,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	}
	else
	{
        fBytesPerRow = targetHeight * 4;
		localContext = CGBitmapContextCreate(NULL, targetHeight, targetWidth, fBitsPerComponent,
                                             fBytesPerRow, colorSpaceInfo,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	}
	
	CGContextSetBlendMode(localContext,eMode);
#if 0
    NSNumber *orient = [[NSUserDefaults standardUserDefaults]objectForKey:key_force_orientationup];
    if(nil != orient)
    {
        if(YES == [orient boolValue])
        {
            //eOrientation = UIImageOrientationUp;
            dest = [UIImage imageWithCGImage:dest.CGImage scale:1.0 orientation:UIImageOrientationUp];
        }
    }
    if(src.imageOrientation != eOrientation)
    {
        //src = [UIImage imageWithCGImage:src.CGImage scale:1.0 orientation:eOrientation];
        //eOrientation = src.imageOrientation;
    }
#endif
	
#if 1
	if (eOrientation == UIImageOrientationLeft)
    {
		CGContextRotateCTM (localContext, radians(90));
		CGContextTranslateCTM (localContext, 0, -targetHeight);
		
	}
    else if (eOrientation == UIImageOrientationRight)
    {
		CGContextRotateCTM (localContext, radians(-90));
		CGContextTranslateCTM (localContext, -targetWidth, 0);
		
	}
    else if (eOrientation == UIImageOrientationUp)
    {
		// NOTHING
	}
    else if (eOrientation == UIImageOrientationDown)
    {
		CGContextTranslateCTM (localContext, targetWidth, targetHeight);
		CGContextRotateCTM (localContext, radians(-180.));
	}
#endif
    //CGContextSetInterpolationQuality(localContext, kCGInterpolationHigh);
    
    /* First Draw hires gray image */
	CGContextDrawImage(localContext, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    
	/* set the blend mode */
    CGContextSetBlendMode(localContext,eMode);
    //CGContextSetBlendMode(localContext,kCGBlendModeDestinationOut);
    
    CGContextSetAlpha(localContext, alpha);
    
    
    // booking 10laks
    // with in one month 10 laks - agreement
    // 3 months from agreement - 25lakhs - site registration
    // 
    //9885091930
    /* Draw the updated gray image */
    CGContextDrawImage(localContext, CGRectMake(0, 0, targetWidth, targetHeight), src.CGImage);
    
    /* generate the image out of current context */
    CGImageRef blendref = CGBitmapContextCreateImage (localContext);
    
    /* Assign the image */
    UIImage *blendedImage = [UIImage imageWithCGImage:blendref];
    
    /* Now translate the cntext */
    CGContextTranslateCTM(localContext, 0, targetHeight);
	CGContextScaleCTM(localContext, 1.0, -1.0);
    
    /* Release the resources */
    CGColorSpaceRelease(colorSpaceInfo);
    CGImageRelease(blendref);
    CGContextRelease(localContext);
	
	return blendedImage;
}
#endif
-(UIImage*)applyTexture:(eStaticTextureFilter)eTexture onImageType:(eImageType)eType withAlpha:(float)alpha
{
    if(texture_maping[eType].eType != eType)
    {
        NSLog(@"UIImage(applyTexture): Texture Mapping is corrupted");
        return nil;
    }
    
    /* Generate Texture Image name */
    NSString *textureName = [NSString stringWithFormat:@"%s_%d",texture_maping[eTexture].name,eType];
    NSString *texturePath = [[NSBundle mainBundle]pathForResource:textureName ofType:@"jpeg"];
    
    /* Check if the file really exist */
    if(nil == texturePath)
    {
        NSLog(@"Failed to find the file %@",textureName);
        return nil;
    }
    
    /* Get the texture image */
    UIImage *texture = [UIImage imageWithContentsOfFile:texturePath];
    if(nil == texture)
    {
        return nil;
    }
    
    /* apply texture */
    return [self blendOn:self from:texture inblendmode:texture_modemap[eTexture].eMode withAlpha:alpha];
    //return [self blendOn:self from:texture inblendmode:kCGBlendModeMultiply withAlpha:alpha];
}

-(UIImage*)applyGrungeTexture:(eStaticGrungeFilter)eTexture onImageType:(eImageType)eType withAlpha:(float)alpha
{
#if 0
    if(maping[eType].eType != eType)
    {
        NSLog(@"UIImage(applyTexture): Texture Mapping is corrupted");
        return nil;
    }
#endif
    /* Generate Texture Image name */
    NSString *textureName = [NSString stringWithFormat:@"%s_%d",grunge_maping[eTexture].name,eType];
    NSString *texturePath = [[NSBundle mainBundle]pathForResource:textureName ofType:@"jpg"];
    
    /* Check if the file really exist */
    if(nil == texturePath)
    {
        NSLog(@"Failed to find the file %@",textureName);
        return nil;
    }
    
    /* Get the texture image */
    UIImage *texture = [UIImage imageWithContentsOfFile:texturePath];
    if(nil == texture)
    {
        return nil;
    }
    
    /* apply texture */
    return [self blendOn:self from:texture inblendmode:kCGBlendModeOverlay withAlpha:alpha];
}

#if BOKEHGROUP_SUPPORT
-(UIImage*)applyBokehTexture:(eStaticBokehFilter)eTexture onImageType:(eImageType)eType withAlpha:(float)alpha
{
#if 0
    if(maping[eType].eType != eType)
    {
        NSLog(@"UIImage(applyTexture): Texture Mapping is corrupted");
        return nil;
    }
#endif
    /* Generate Texture Image name */
    NSString *textureName = [NSString stringWithFormat:@"%s_%d",bokeh_maping[eTexture].name,eType];
    NSString *texturePath = [[NSBundle mainBundle]pathForResource:textureName ofType:@"jpg"];
    
    /* Check if the file really exist */
    if(nil == texturePath)
    {
        NSLog(@"Failed to find the file %@",textureName);
        return nil;
    }
    
    /* Get the texture image */
    UIImage *texture = [UIImage imageWithContentsOfFile:texturePath];
    if(nil == texture)
    {
        return nil;
    }
    
    /* apply texture */
    return [self blendOn:self from:texture inblendmode:kCGBlendModePlusLighter withAlpha:alpha];
}
#endif
#if SPACEGROUP_SUPPORT
-(UIImage*)applySpaceTexture:(eStaticSpaceFilter)eTexture onImageType:(eImageType)eType withAlpha:(float)alpha
{
#if 0
    if(maping[eType].eType != eType)
    {
        NSLog(@"UIImage(applyTexture): Texture Mapping is corrupted");
        return nil;
    }
#endif
    /* Generate Texture Image name */
    NSString *textureName = [NSString stringWithFormat:@"%s_%d",space_maping[eTexture].name,eType];
    NSString *texturePath = [[NSBundle mainBundle]pathForResource:textureName ofType:@"jpeg"];
    
    /* Check if the file really exist */
    if(nil == texturePath)
    {
        NSLog(@"Failed to find the file %@",textureName);
        return nil;
    }
    
    /* Get the texture image */
    UIImage *texture = [UIImage imageWithContentsOfFile:texturePath];
    if(nil == texture)
    {
        return nil;
    }
    
    /* apply texture */
    return [self blendOn:self from:texture inblendmode:space_modemap[eTexture].eMode withAlpha:alpha];
}
#endif
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    if (self.imageOrientation == UIImageOrientationLeft)
    {
		CGContextRotateCTM (ctx, radians(90));
		CGContextTranslateCTM (ctx, 0, -CGImageGetHeight(self.CGImage));
		
	}
    else if (self.imageOrientation == UIImageOrientationRight)
    {
		CGContextRotateCTM (ctx, radians(-90));
		CGContextTranslateCTM (ctx, -CGImageGetWidth(self.CGImage), 0);
		
	}
    else if (self.imageOrientation == UIImageOrientationUp)
    {
		// NOTHING
	}
    else if (self.imageOrientation == UIImageOrientationDown)
    {
		CGContextTranslateCTM (ctx, CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
		CGContextRotateCTM (ctx, radians(-180.));
	}
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
