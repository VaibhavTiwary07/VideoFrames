//
//  GridImageView.h
//  AlterButton
//
//  Created by Deepti's Mac on 1/7/14.
//  Copyright (c) 2014 D.Yoganjulu  Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridImageView : UIImageView<UIGestureRecognizerDelegate>
{
    UIImage *image ;
    CGRect originalRect;
    float oldX, oldY;
    BOOL dragging;
    
}
@end
