//
//  ShadowedImageView.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 2/16/13.
//
//

#import "ShadowedImageView.h"

@implementation ShadowedImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"[shadowview]DrawRect !!!!!!!!!!!!!!!!!!!!!!!!!!!");
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextSetShadow(currentContext, CGSizeMake(0,0), 5);
    CGContextSetShadowWithColor(currentContext, CGSizeMake(0,0), 5,[UIColor whiteColor].CGColor);
    [super drawRect: rect];
    CGContextRestoreGState(currentContext);
}


@end
