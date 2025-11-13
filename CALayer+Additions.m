//
//  CALayer+Additions.m
//  VideoFrames
//
//  Created by apple on 25/06/25.
//

#import <Foundation/Foundation.h>
#import "CALayer+Additions.h"

@implementation CALayer (Additions)

- (void)addSublayers:(NSArray<CALayer *> *)layers {
    for (CALayer *layer in layers) {
        [self addSublayer:layer];
    }
}

@end
