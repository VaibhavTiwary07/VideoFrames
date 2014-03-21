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

@implementation Effects
- (UIImage *)applyCurrentSelectedEffcect:(UIImage *)image withEffect:(int)effectNo
{
    eGroupStaticFilter groupId=  [self getGroupIdForItem:effectNo];
    int itemNumber =0;
    itemNumber = effectNo;
    if (effectNo>10)
    {
        itemNumber = effectNo-11;
    }
    UIImage   *resultImage  =   [image applyGPUFilter:itemNumber onImage:image ofGroup:groupId withAlpha:1.0];
    return resultImage;

}

- (UIImage *)getImageForItem:(int)itemNo
{
    
    UIImage *sampleImage = [UIImage imageNamed:@"sample2.png"];

    UIImage   *resultImage  =   [self applyCurrentSelectedEffcect:sampleImage withEffect:itemNo];
    return resultImage;
   
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
    if (itemNo>4)
    {
        isLocked = YES;
    }
    if (!freeVersion) {
        isLocked = NO;
    }
    return isLocked;
}



@end
