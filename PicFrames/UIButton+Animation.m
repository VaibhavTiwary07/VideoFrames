//
//  UIButton+Animation.m
//  VideoFrames
//
//  Created by apple on 26/12/24.
//

#import <Foundation/Foundation.h>
#import "UIButton+Animation.h"

@implementation UIButton (Animation)

- (void)addTapAnimation {
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.transform = CGAffineTransformIdentity;
                                          }
                                          completion:nil];
                     }];
}

@end
