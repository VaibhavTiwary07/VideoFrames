//
//  UIImage+GPU.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/28/12.
//
//

#import <UIKit/UIKit.h>
#import "StaticFilterMapping.h"
#import "GPUImage.h"
#import "UIImage+texture.h"

@interface UIImage (GPU)

-(UIImage*)applyGPUFilter:(int)filter onImage:(UIImage*)img ofGroup:(eGroupStaticFilter)eGrp withAlpha:(float)alpha;

@end
