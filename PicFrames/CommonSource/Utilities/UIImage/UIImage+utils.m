//
//  UIImage+utils.m
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 8/5/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "UIImage+utils.h"
@implementation UIImage(util_extensions)
-(UIImage *) cutout: (CGRect) coords {
    UIGraphicsBeginImageContext(coords.size);
    [self drawAtPoint: CGPointMake(-coords.origin.x, -coords.origin.y)];
    UIImage *rslt = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rslt;
}

-(UIImage *) stretchImageWithCapInsets: (UIEdgeInsets) cornerCaps toSize: (CGSize) size { 
    UIGraphicsBeginImageContext(size);
    
    [[self cutout: CGRectMake(0,0,cornerCaps.left,cornerCaps.top)] drawAtPoint: CGPointMake(0,0)]; //topleft
    [[self cutout: CGRectMake(self.size.width-cornerCaps.right,0,cornerCaps.right,cornerCaps.top)] drawAtPoint: CGPointMake(size.width-cornerCaps.right,0)]; //topright
    [[self cutout: CGRectMake(0,self.size.height-cornerCaps.bottom,cornerCaps.left,cornerCaps.bottom)] drawAtPoint: CGPointMake(0,size.height-cornerCaps.bottom)]; //bottomleft
    [[self cutout: CGRectMake(self.size.width-cornerCaps.right,self.size.height-cornerCaps.bottom,cornerCaps.right,cornerCaps.bottom)] drawAtPoint: CGPointMake(size.width-cornerCaps.right,size.height-cornerCaps.bottom)]; //bottomright
    
    [[self cutout: CGRectMake(cornerCaps.left,0,self.size.width-cornerCaps.left-cornerCaps.right,cornerCaps.top)]
     drawInRect: CGRectMake(cornerCaps.left,0,size.width-cornerCaps.left-cornerCaps.right,cornerCaps.top)]; //top
    
    [[self cutout: CGRectMake(0,cornerCaps.top,cornerCaps.left,self.size.height-cornerCaps.top-cornerCaps.bottom)]
     drawInRect: CGRectMake(0,cornerCaps.top,cornerCaps.left,size.height-cornerCaps.top-cornerCaps.bottom)]; //left
    
    [[self cutout: CGRectMake(cornerCaps.left,self.size.height-cornerCaps.bottom,self.size.width-cornerCaps.left-cornerCaps.right,cornerCaps.bottom)]
     drawInRect: CGRectMake(cornerCaps.left,size.height-cornerCaps.bottom,size.width-cornerCaps.left-cornerCaps.right,cornerCaps.bottom)]; //bottom
    
    [[self cutout: CGRectMake(self.size.width-cornerCaps.right,cornerCaps.top,cornerCaps.right,self.size.height-cornerCaps.top-cornerCaps.bottom)]
     drawInRect: CGRectMake(size.width-cornerCaps.right,cornerCaps.top,cornerCaps.right,size.height-cornerCaps.top-cornerCaps.bottom)]; //right
    
    [[self cutout: CGRectMake(cornerCaps.left,cornerCaps.top,self.size.width-cornerCaps.left-cornerCaps.right,self.size.height-cornerCaps.top-cornerCaps.bottom)]
     drawInRect: CGRectMake(cornerCaps.left,cornerCaps.top,size.width-cornerCaps.left-cornerCaps.right,size.height-cornerCaps.top-cornerCaps.bottom)]; //interior
    
    UIImage *rslt = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [rslt resizableImageWithCapInsets: cornerCaps];
}

@end
