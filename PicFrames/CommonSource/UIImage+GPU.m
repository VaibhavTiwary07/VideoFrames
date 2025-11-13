//
//  UIImage+GPU.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/28/12.
//
//

#import "UIImage+GPU.h"

@implementation UIImage (GPU)

-(id)filterWithLookupmage:(UIImage*)image
{
    id fil = [[GPUImageFilterGroup alloc]init];
    
    
    NSAssert(image, @"To use GPUImageAmatorkaFilter you need to add lookup_amatorka.png from GPUImage/framework/Resources to your application bundle.");
    
    GPUImagePicture *lookupImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
    
    [lookupImageSource addTarget:lookupFilter atTextureLocation:1];
    [lookupImageSource processImage];
    
    [fil setInitialFilters:[NSArray arrayWithObjects:lookupFilter, nil]];
    [fil setTerminalFilter:lookupFilter];

    //[lookupImageSource release];
  //  [lookupFilter release];
    
    return fil;
}
#if 0
-(UIImage*)applyVintageFilter:(int)filter onImage:(UIImage*)img
{
    //UIImage *img = nil;
    UIImage *upDatedImage = nil;
    id _filter = nil;
    
    switch (filter)
    {
        case STATIC_GPU_FILTER_VINTAGE_EFFECT1:
        {
            UIImage *image = [UIImage imageNamed:@"lookup_300.png"];
            NSAssert(image, @"To use lookup_300 you need to add lookup_300.png from GPUImage/framework/Resources to your application bundle.");
            id fil = [self filterWithLookupmage:image];
            upDatedImage = [fil imageByFilteringImage:self];
            [fil release];
            
            GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
            //vignetteImageFilter.vignetteEnd = 0.85;
            //vignetteImageFilter.vignetteStart = 0.6;
            
            _filter = vignetteImageFilter;
            break;
        }
        case STATIC_GPU_FILTER_VINTAGE_EFFECT2:
        {
            UIImage *image = [UIImage imageNamed:@"lookup_customchrom.png"];
            NSAssert(image, @"To use lookup_chrom you need to add lookup_chrom.png from GPUImage/framework/Resources to your application bundle.");
            id fil = [self filterWithLookupmage:image];
            
            upDatedImage = [fil imageByFilteringImage:self];
            [fil release];
            
            GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
            //vignetteImageFilter.vignetteEnd = 0.85;
            //vignetteImageFilter.vignetteStart = 0.6;
            
            _filter = vignetteImageFilter;
            
            break;
        }
        case STATIC_GPU_FILTER_VINTAGE_EFFECT3:
        {
            //UIImage *image = [UIImage imageNamed:@"lookup_chrom_retro.png"];
            UIImage *image = [UIImage imageNamed:@"lookup_lomo.png"];
            NSAssert(image, @"To use lookup_chrom_retro you need to add lookup_chrom_retro.png from GPUImage/framework/Resources to your application bundle.");
            //_filter = [self filterWithLookupmage:image];
            id fil = [self filterWithLookupmage:image];
            
            upDatedImage = [fil imageByFilteringImage:self];
            [fil release];
            
            GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
            //vignetteImageFilter.vignetteEnd = 0.85;
            //vignetteImageFilter.vignetteStart = 0.6;
            
            _filter = vignetteImageFilter;
            break;
        }
        case STATIC_GPU_FILTER_VINTAGE_EFFECT4:
        {
            UIImage *image = [UIImage imageNamed:@"lookup_chrom_dodge.png"];
            NSAssert(image, @"To use lookup_chrom_dodge you need to add lookup_chrom_dodge.png from GPUImage/framework/Resources to your application bundle.");
            //_filter = [self filterWithLookupmage:image];
            id fil = [self filterWithLookupmage:image];
            
            upDatedImage = [fil imageByFilteringImage:self];
            [fil release];
            
            GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
            //vignetteImageFilter.vignetteEnd = 0.85;
            //vignetteImageFilter.vignetteStart = 0.6;
            
            _filter = vignetteImageFilter;
            break;
        }
        case STATIC_GPU_FILTER_VINTAGE_EFFECT5:
        {
            UIImage *image = [UIImage imageNamed:@"lookup_vintagefilm.png"];
            NSAssert(image, @"To use lookup_vintagefilm you need to add lookup_vintagefilm.png from GPUImage/framework/Resources to your application bundle.");
            //_filter = [self filterWithLookupmage:image];
            id fil = [self filterWithLookupmage:image];
            
            upDatedImage = [fil imageByFilteringImage:self];
            [fil release];
            
            GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
            //vignetteImageFilter.vignetteEnd = 0.85;
            //vignetteImageFilter.vignetteStart = 0.6;
            
            _filter = vignetteImageFilter;
            break;
        }
        case STATIC_GPU_FILTER_VINTAGE_EFFECT6:
        {
            UIImage *image = [UIImage imageNamed:@"lookup_splittonecolor.png"];
            NSAssert(image, @"To use lookup_splittonecolor you need to add lookup_splittonecolor.png from GPUImage/framework/Resources to your application bundle.");
            //_filter = [self filterWithLookupmage:image];
            id fil = [self filterWithLookupmage:image];
            
            upDatedImage = [fil imageByFilteringImage:self];
            [fil release];
            
            GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
            //vignetteImageFilter.vignetteEnd = 0.85;
            //vignetteImageFilter.vignetteStart = 0.6;
            
            _filter = vignetteImageFilter;
            break;
        }
        case STATIC_GPU_FILTER_VINTAGE_EFFECT7:
        {
            //UIImage *image = [UIImage imageNamed:@"lookup_technicolor3.png"];
            UIImage *image = [UIImage imageNamed:@"lookup_lomo1.png"];
            NSAssert(image, @"To use lookup_technicolor3 you need to add lookup_technicolor3.png from GPUImage/framework/Resources to your application bundle.");
            //_filter = [self filterWithLookupmage:image];
            id fil = [self filterWithLookupmage:image];
            
            upDatedImage = [fil imageByFilteringImage:self];
            [fil release];
            
            GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
            //vignetteImageFilter.vignetteEnd = 0.85;
            //vignetteImageFilter.vignetteStart = 0.6;
            
            _filter = vignetteImageFilter;
            break;
        }
        default:
        {
            break;
        }
    }
    
    UIImage *outImage = nil;
    
    if(nil != upDatedImage)
    {
        outImage = [_filter imageByFilteringImage:upDatedImage];
    }
    else
    {
        outImage = [_filter imageByFilteringImage:self];
    }
    
    [_filter removeAllTargets];
    [_filter release];
    
    return outImage;
}
#endif





-(UIImage*)applyToneFilter:(int)filter onImage:(UIImage*)img
{
    UIImage *outImage = nil;
    id _filter = nil;
    
    switch(filter)
    {
        case STATIC_GPU_FILTER_TONE_EFFECT1:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow"];
            //_filter = [[GPUImageAmatorkaFilter alloc]init];
            //UIImage *image = [UIImage imageNamed:@"lookup_amatorka.png"];
            //NSAssert(image, @"To use lookup_amatorka you need to add lookup_amatorka.png from GPUImage/framework/Resources to your application bundle.");
            //_filter = [self filterWithLookupmage:image];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickantique"];
            break;
        }
        case STATIC_GPU_FILTER_TONE_EFFECT2:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"zeebra"];
            //_filter = [[GPUImageMissEtikateFilter alloc]init];
            //UIImage *image = [UIImage imageNamed:@"lookup_miss_.png"];
            //NSAssert(image, @"To use lookup_amatorka you need to add lookup_amatorka.png from GPUImage/framework/Resources to your application bundle.");
            //_filter = [self filterWithLookupmage:image];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickantique2"];
            break;
        }
        case STATIC_GPU_FILTER_TONE_EFFECT3:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"green"];
            //_filter = [[GPUImageSoftEleganceFilter alloc]init];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickblue"];
            break;
        }
        case STATIC_GPU_FILTER_TONE_EFFECT4:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
            break;
        }
        case STATIC_GPU_FILTER_TONE_EFFECT5:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"arrow"];
            break;
        }
        case STATIC_GPU_FILTER_TONE_EFFECT6:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"berry"];
            break;
        }
        case STATIC_GPU_FILTER_TONE_EFFECT7:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"mixed"];
            break;
        }
        default:
        {
            break;
        }
    }
    
    outImage = [_filter imageByFilteringImage:img];
  //  [_filter release];
    return outImage;
}

-(UIImage*)applyColorFilter:(int)filter onImage:(UIImage*)img
{
    UIImage *outImage = nil;
    UIImage *inImage = img;
    id _filter = nil;
    
    switch(filter)
    {
        case STATIC_GPU_FILTER_COLOR_EFFECT1:
        {
            _filter = [[GPUImageAmatorkaFilter alloc] init];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickgreengrey"];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT2:
        {
            
            id fil = [[GPUImageAmatorkaFilter alloc]init];
            inImage = [fil imageByFilteringImage:inImage];
          //  [fil release];
            
            inImage = [inImage applyTexture:STATIC_FILTER_TEXTURE_JEANS onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0f];
            //inImage = [inImage applySpaceTexture:STATIC_FILTER_SPACE_RAYS onImageType:IMAGETYPE_FULLIMAGE withAlpha:0.6];
            
            //_filter = [[GPUImageAmatorkaFilter alloc] init];
            _filter = [[GPUImageFilter alloc] init];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickice"];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT3:
        {
            id fil = [[GPUImageAmatorkaFilter alloc]init];
            inImage = [fil imageByFilteringImage:inImage];
        //    [fil release];
            
            inImage = [inImage applyTexture:STATIC_FILTER_TEXTURE_PENCIL onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0f];
            //inImage = [inImage applySpaceTexture:STATIC_FILTER_SPACE_RAYS onImageType:IMAGETYPE_FULLIMAGE withAlpha:0.6];
            
            //_filter = [[GPUImageAmatorkaFilter alloc] init];
            _filter = [[GPUImageFilter alloc] init];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clicklavender"];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT4:
        {
            /* Change The contrast of the image */
            GPUImageContrastFilter *fil = [[GPUImageContrastFilter alloc]init];
            fil.contrast = 3.5;
            inImage = [fil imageByFilteringImage:inImage];
       //     [fil release];
            
            GPUImageToneCurveFilter *fil2 = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickblue"];
            
            inImage = [fil2 imageByFilteringImage:inImage];
        //    [fil2 release];
            
            GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
            //vignetteImageFilter.vignetteEnd = 0.8;
            //vignetteImageFilter.vignetteStart = 0.6;
            
            _filter = vignetteImageFilter;
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clicklilac"];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT5:
        {
            _filter = [[GPUImageGrayscaleFilter alloc]init];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickmarshmallow"];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT6:
        {
            id fil = [[GPUImageGrayscaleFilter alloc]init];
            inImage = [fil imageByFilteringImage:inImage];
         //   [fil release];
            
            fil = [[GPUImageAmatorkaFilter alloc] init];
            inImage = [fil imageByFilteringImage:inImage];
         ///   [fil release];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickmemory"
                   //    ];
            GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init];
            //vignetteImageFilter.vignetteEnd = 0.8;
            //vignetteImageFilter.vignetteStart = 0.6;
            
            _filter = vignetteImageFilter;
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT7:
        {
            _filter = [[GPUImageGaussianBlurFilter alloc]init];
            [_filter setBlurRadiusInPixels:3.0];
            UIImage *opasity = [_filter imageByFilteringImage:inImage];
          //  [_filter release];
            
            inImage = [opasity blendOn:inImage from:opasity inblendmode:kCGBlendModeNormal withAlpha:0.6];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"curves03"];
            _filter = [[GPUImageFilter alloc]init];
            
            
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT8:
        {
            _filter = [[GPUImageSepiaFilter alloc]init];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickwarm"];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT9:
        {
            _filter = [[GPUImageSepiaFilter alloc]init];
            inImage = [_filter imageByFilteringImage:inImage];
        //    [_filter release];
            
            inImage = [inImage applyGrungeTexture:STATIC_FILTER_GRUNGE22 onImageType:IMAGETYPE_FULLIMAGE withAlpha:0.6];
            
            _filter = [[GPUImageVignetteFilter alloc] init];
            
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickwarm2"];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT10:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
            inImage = [_filter imageByFilteringImage:inImage];
         //   [_filter release];
            
            _filter = [[GPUImageVignetteFilter alloc] init];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT11:
        {
            _filter = [[GPUImageMissEtikateFilter alloc]init];
            
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"curves01"];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT12:
        {
            UIImage *image = [UIImage imageNamed:@"lookup_splittonecolor.png"]; //good
            _filter = [self filterWithLookupmage:image];
            //_filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"curves02"];
            break;
        }
        case STATIC_GPU_FILTER_COLOR_EFFECT13:
        {
            
            UIImage *image = [UIImage imageNamed:@"lookup_skyblue.png"];
            _filter = [self filterWithLookupmage:image];
            
            inImage = [_filter imageByFilteringImage:inImage];
         //   [_filter release];
            
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickmint"];
            break;
        }
        default:
        {
            break;
        }
    }
    

    outImage = [_filter imageByFilteringImage:inImage];

    
    [_filter removeAllTargets];
   // [_filter release];
    
    return outImage;
}







#if SKETCHGROUP_SUPPORT
-(UIImage*)applySketchFilter:(int)filter onImage:(UIImage*)img
{
    UIImage *outImage = nil;
    id _filter = nil;
    id sketch =[[GPUImageSketchFilter alloc]init];
    //id sketch =[[GPUImageSmoothToonFilter alloc]init];
    UIImage *sketchImg = [sketch imageByFilteringImage:img];
    [sketch release];
    
    switch(filter)
    {
        case STATIC_GPU_FILTER_SKETCH_EFFECT1:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickmist"];
            break;
        }
        case STATIC_GPU_FILTER_SKETCH_EFFECT2:
        {
            sketchImg = [sketchImg applyTexture:STATIC_FILTER_TEXTURE_WALL  
                              onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            sketchImg = [sketchImg applyTexture:STATIC_FILTER_TEXTURE_PAPER2
                                    onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickmustard"];
            break;
        }
        case STATIC_GPU_FILTER_SKETCH_EFFECT3:
        {
            sketchImg = [sketchImg applyTexture:STATIC_FILTER_TEXTURE_PAPER2
                              onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickoldtimes"];
            break;
        }
        case STATIC_GPU_FILTER_SKETCH_EFFECT4:
        {
            sketchImg = [sketchImg applyTexture:STATIC_FILTER_TEXTURE_PAPER2
                                    onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            sketchImg = [sketchImg applyTexture:STATIC_FILTER_TEXTURE_STROKES
                                    onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickorange"];
            break;
        }
        case STATIC_GPU_FILTER_SKETCH_EFFECT5:
        {
            sketchImg = [sketchImg applyTexture:STATIC_FILTER_TEXTURE_PAPER2
                                    onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            sketchImg = [sketchImg applyTexture:STATIC_FILTER_TEXTURE_PENCIL
                                    onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickpast"];
            break;
        }
        case STATIC_GPU_FILTER_SKETCH_EFFECT6:
        {
            sketchImg = [sketchImg applyGrungeTexture:STATIC_FILTER_GRUNGE12
                                         onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            sketchImg = [sketchImg applyTexture:STATIC_FILTER_TEXTURE_PAPER2
                                    onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickpeach"];
            break;
        }
        case STATIC_GPU_FILTER_SKETCH_EFFECT7:
        {
            sketchImg = [sketchImg applySpaceTexture:STATIC_FILTER_SPACE_DUST
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            sketchImg = [sketchImg applyTexture:STATIC_FILTER_TEXTURE_PAPER2
                                         onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickpinkvintage"];
            break;
        }
        default:
        {
            break;
        }
    }
    
    outImage = [_filter imageByFilteringImage:sketchImg];
    [_filter release];
    
    return outImage;
}
#endif
#if CARTOONGROUP_SUPPORT
-(UIImage*)applyCartoonFilter:(int)filter onImage:(UIImage*)img
{
    UIImage *outImage = nil;
    id _filter = nil;
    //id sketch =[[GPUImageSketchFilter alloc]init];
    id toon =[[GPUImageSmoothToonFilter alloc]init];
    UIImage *toonImg = [toon imageByFilteringImage:img];
    [toon release];
    
    switch(filter)
    {
        case STATIC_GPU_FILTER_TOON_EFFECT1:
        {
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickmist"];
            break;
        }
        case STATIC_GPU_FILTER_TOON_EFFECT2:
        {
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_PAPER2
                                    onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_PENCIL
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickmustard"];
            break;
        }
        case STATIC_GPU_FILTER_TOON_EFFECT3:
        {
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_PAPER2
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_STROKES
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickoldtimes"];
            break;
        }
        case STATIC_GPU_FILTER_TOON_EFFECT4:
        {
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_OLDPAPER
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_STROKES
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickorange"];
            break;
        }
        case STATIC_GPU_FILTER_TOON_EFFECT5:
        {
            toonImg = [toonImg applyGrungeTexture:STATIC_FILTER_GRUNGE9
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_STROKES
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickpast"];
            break;
        }
        case STATIC_GPU_FILTER_TOON_EFFECT6:
        {
            toonImg = [toonImg applyGrungeTexture:STATIC_FILTER_GRUNGE22
                                      onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_PAPER2
                                onImageType:IMAGETYPE_FULLIMAGE
                                  withAlpha:1.0];
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_PENCIL
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickpeach"];
            break;
        }
        case STATIC_GPU_FILTER_TOON_EFFECT7:
        {
            toonImg = [toonImg applyTexture:STATIC_FILTER_TEXTURE_JEANS
                                onImageType:IMAGETYPE_FULLIMAGE withAlpha:1.0];
            _filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"1clickpinkvintage"];
            break;
        }
        default:
        {
            break;
        }
    }
    
    outImage = [_filter imageByFilteringImage:toonImg];
    [_filter release];
    
    return outImage;
}
#endif
-(UIImage*)applyGPUFilter:(int)filter onImage:(UIImage*)img ofGroup:(eGroupStaticFilter)eGrp withAlpha:(float)alpha
{
    UIImage *image = nil;

    switch(eGrp)
    {
#if VINTAGEGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_VINTAGE:
        {
            image = [self applyVintageFilter:filter onImage:img];
            break;
        }
#endif
#if COLORGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_COLOR:
        {
            NSLog(@"GROUP_STATIC_GPU_FILTER_COLOR");
            image = [self applyColorFilter:filter onImage:img];
            break;
        }
#endif
#if CARTOONGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_CARTOON:
        {
            image = [self applyCartoonFilter:filter onImage:img];
            break;
        }
#endif
#if TONEGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_TONE:
        {
            NSLog(@"GROUP_STATIC_GPU_FILTER_TONE");
            image = [self applyToneFilter:filter onImage:img];
            break;
        }
#endif
#if SKETCHGROUP_SUPPORT
        case GROUP_STATIC_GPU_FILTER_SKETCH:
        {
            image = [self applySketchFilter:filter onImage:img];
            break;
        }
#endif
        default:
        {
            break;
        }
    }
    
    return image;
}
@end
