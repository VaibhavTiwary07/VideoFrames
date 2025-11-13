//
//  Effects.m
//  VideoFrames
//
//  Created by Deepti's Mac on 1/20/14.
//
//

#import "Effects.h"
#import "GPUImage.h"
#import "UIImage+GPU.h"
#import "StaticFilterMapping.h"
#import "SRSubscriptionModel.h"



@implementation Effects

NSArray<NSString *> *videoSafeCIFilters = @[
    // Photo Effects
    @"CIPhotoEffectNoir",
    @"CIPhotoEffectMono",
    @"CIPhotoEffectChrome",
    @"CIPhotoEffectFade",
    @"CIPhotoEffectInstant",
    @"CIPhotoEffectProcess",
    @"CIPhotoEffectTonal",
    @"CIPhotoEffectTransfer",
    @"CIColorPosterize",
    @"CISepiaTone",
    @"CIHighlightShadowAdjust",
    @"CIColorMonochrome",
    @"CIFalseColor"
];

- (UIImage *)applyCurrentSelectedEffcect:(UIImage *)image withEffect:(int)effectNo
{
    eGroupStaticFilter groupId=  [self getGroupIdForItem:effectNo];
    int itemNumber =0;
    itemNumber = effectNo;
    if (effectNo>10)
    {
        itemNumber = effectNo-11;
    }
    NSLog(@"effect number is %d",itemNumber);
    UIImage   *resultImage  =   [image applyGPUFilter:itemNumber onImage:image ofGroup:groupId withAlpha:1.0];
    return resultImage;
}


- (NSString *)getEffectNameForItem:(int)itemNo
{
    return videoSafeCIFilters[itemNo];
}

- (UIImage *)getImageForItem:(int)itemNo
{
    UIImage *sampleImage = [UIImage imageNamed:@"pic_eff_image.png"];
    NSLog(@"filter name from effect class on sample image %@ item number %d" ,videoSafeCIFilters[itemNo],itemNo);
    UIImage   *resultImage  =   [self applyFilter:videoSafeCIFilters[itemNo] toImage:sampleImage];
    return resultImage;
}


- (UIImage *)applyCurrentSelectedCIFilterEffect:(UIImage *)image withEffect:(int)effectNo
{
    NSLog(@"filter name from effect class actual image %@ item number %d",videoSafeCIFilters[effectNo],effectNo);
    UIImage   *resultImage  =   [self applyFilter:videoSafeCIFilters[effectNo] toImage:image];
    return resultImage;
}


NSDictionary *defaultParamsForFilter(NSString *filterName) {
    if ([filterName isEqualToString:@"CIColorPosterize"]) {
        return @{@"inputLevels": @6.0};
    } else if ([filterName isEqualToString:@"CISepiaTone"]) {
        return @{@"inputIntensity": @1.0};
    } else if ([filterName isEqualToString:@"CIHighlightShadowAdjust"]) {
        return @{
            @"inputHighlightAmount": @0.7,
            @"inputShadowAmount": @0.3
        };
    } else if ([filterName isEqualToString:@"CIColorMonochrome"]) {
        return @{
            @"inputColor": [CIColor colorWithRed:0.8 green:0.2 blue:0.2],
            @"inputIntensity": @1.0
        };
    } else if ([filterName isEqualToString:@"CIFalseColor"]) {
        return @{
            @"inputColor0": [CIColor colorWithRed:0.0 green:0.0 blue:0.0],
            @"inputColor1": [CIColor colorWithRed:1.0 green:0.5 blue:0.0]
        };
    }
    return @{};
}


- (UIImage *)applyFilter:(NSString *)filterName toImage:(UIImage *)image {
    CIImage *inputCI = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setValue:inputCI forKey:kCIInputImageKey];

    NSDictionary *defaults = defaultParamsForFilter(filterName);
    for (NSString *key in defaults) {
        [filter setValue:defaults[key] forKey:key];
    }

    CIImage *outputCI = filter.outputImage ?: inputCI;
    CIContext *context = [CIContext context];
    CGImageRef cgImage = [context createCGImage:outputCI fromRect:[outputCI extent]];
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return finalImage;
}


- (eGroupStaticFilter)getGroupIdForItem:(int)itemNo
{
    eGroupStaticFilter groupId=  0;
    if (itemNo<=10)
    {
        groupId = GROUP_STATIC_GPU_FILTER_COLOR;
        
    }else if(itemNo>11)
    {
        groupId = GROUP_STATIC_GPU_FILTER_TONE;
        
    }
    return groupId;
}

- (NSString *)getNameOfEffect:(int )itemNo
{
    eGroupStaticFilter groupId=  [self getGroupIdForItem:itemNo];
    int itemNumber =0;
    itemNumber = itemNo;
    
    if (itemNo>10)
    {
        itemNumber = itemNo-11;
    }
    NSString *titlename =[StaticFilterMapping nameOfFilterInGroup:groupId atIndex:itemNumber];
    return titlename;
}

- (BOOL)getItemLockStatus:(int)itemNo
{
    int itemNumber =0;
    BOOL isLocked = NO;
    itemNumber = itemNo;
    
  //  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    if ([prefs integerForKey:@"Productpurchased"] == 1)
//    {
    //ExpiryStatus//
    NSUserDefaults *prefsTime = nil;
    NSUserDefaults *prefsDate = nil;
    NSUserDefaults *SuccessStatus = nil;
    //For Subscription Expiry Status
    prefsTime = [NSUserDefaults standardUserDefaults];
    prefsDate= [NSUserDefaults standardUserDefaults];
    SuccessStatus = [NSUserDefaults standardUserDefaults];
    //here it is//
    if (itemNo < 1)
    {
        isLocked = NO;
    }
    else if([[SRSubscriptionModel shareKit]IsAppSubscribed])
    {
        isLocked = NO;
    }
    else
    {
        //if ([SuccessStatus integerForKey:@"PurchasedYES"] == 1) {
            
            isLocked = YES;
        //}
    }
    //if (!freeVersion) {
      //  isLocked = NO;
    //}
    return isLocked;
}



@end
