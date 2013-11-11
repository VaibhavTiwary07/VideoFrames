//
//  FrameButton.m
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 3/18/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "FrameButton.h"

@interface FrameButton ()
{
    int iFrameNumber;
}
@end

@implementation FrameButton

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrameNumber:(int)frameNumber andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(nil != self)
    {
        /* Render The image */
        self.image = [UIImage imageWithContentsOfFile:[Utility frameThumbNailPathForFrameNumber:frameNumber]];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
    // Drawing code
//}


@end
