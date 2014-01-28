//
//  UIImage+texture.h
//  SimplePhotoFilter
//
//  Created by Vijaya kumar reddy Doddavala on 9/7/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticFilterMapping.h"

typedef enum
{
    IMAGETYPE_FULLIMAGE,
    IMAGETYPE_ICON,
    IMAGETYPE_LAST
}eImageType;

@interface UIImage (texture)


-(UIImage*)applyTexture:(eStaticTextureFilter)eTexture onImageType:(eImageType)eType withAlpha:(float)alpha;
+(NSString*)textureNameForType:(eStaticTextureFilter)eType;

-(UIImage*)applyGrungeTexture:(eStaticGrungeFilter)eTexture onImageType:(eImageType)eType withAlpha:(float)alpha;

#if BOKEHGROUP_SUPPORT
-(UIImage*)applyBokehTexture:(eStaticBokehFilter)eTexture onImageType:(eImageType)eType withAlpha:(float)alpha;
#endif
#if SPACEGROUP_SUPPORT
-(UIImage*)applySpaceTexture:(eStaticSpaceFilter)eTexture onImageType:(eImageType)eType withAlpha:(float)alpha;
#endif
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;
-(UIImage*)blendOn:(UIImage*)dest from:(UIImage*)src inblendmode:(CGBlendMode)eMode withAlpha:(float)alpha;
@end
