//
//  UIImage+utils.h
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 8/5/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage(util_extensions)
//extract a portion of an UIImage instance 
-(UIImage *) cutout: (CGRect) coords;
//create a stretchable rendition of an UIImage instance, protecting edges as specified in cornerCaps
-(UIImage *) stretchImageWithCapInsets: (UIEdgeInsets) cornerCaps toSize: (CGSize) size;
@end
