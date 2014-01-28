//
//  UIImage+Frame.h
//  Effects
//
//  Created by OutThinking India Pvt Ltd on 21/12/12.
//  Copyright (c) 2012 OutThinking India Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaticFilterMapping.h"
typedef enum
{
    IMAGETYPE_FULLIMAGE1,
    IMAGETYPE_ICON1,
    IMAGETYPE_LAST1
}eImageType1;
@interface UIImage (frame)

-(UIImage*)applyFrame:(eStaticFrames)eFrames onImageType:(eImageType1)eType value:(int) v;
- (UIImage *)overlayWithImage:(UIImage *)image2;
@end
