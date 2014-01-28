//
//  GridImageView.m
//  AlterButton
//
//  Created by Deepti's Mac on 1/7/14.
//  Copyright (c) 2014 D.Yoganjulu  Reddy. All rights reserved.
//

#import "GridImageView.h"

@implementation GridImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        [self addGesture];
        originalRect = frame;
    }
    return self;
}

-(void)addGesture
{
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture . delegate = self;
   // [self addGestureRecognizer:panGesture];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview bringSubviewToFront:self];
    // get touch event
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.superview];
    
    float xDifference = originalRect.origin.x - touchLocation.x;
    float yDifference = originalRect.origin.y - touchLocation.y;
    float positiveXDifference , positiveYDifference;
    if (xDifference<0)
    {
        positiveXDifference = -xDifference;
    }else
    {
        positiveXDifference = xDifference;
    }
    
    if (yDifference<0) {
        positiveYDifference = -yDifference;
    }else
    {
        positiveYDifference = yDifference;
    }
    
    if (positiveYDifference>positiveXDifference) {
        NSLog(@"change in y coordinate");
        if (yDifference<0) {
            NSLog(@"Top");
        }else
        {
            NSLog(@"DOwn");
        }
        
        
    }else
    {
        NSLog(@"change in x coordinate");
        if (xDifference<0) {
            NSLog(@"Left");
        }else
        {
            NSLog(@"Right");
        }
        
    }
  //  NSLog(@" x :%f Y :%f", touchLocation.x,touchLocation.y);
  //  NSLog(@"original rect x: %f y:%f",originalRect.origin.x,originalRect.origin.y);
    if ([touch view] == self) {
        // move the image view
        self.center = touchLocation;
    }
}
-(void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    static CGPoint originalCenter;
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        originalCenter = sender.view.center;
        sender.view.alpha = 0.8;
        [sender.view.superview bringSubviewToFront:sender.view];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [sender translationInView:self.superview];
        NSLog(@" orx  %f  : tranx : %f",originalCenter.x, translation.x );
        NSLog(@"ory  %f  : trany : %f",originalCenter.y, translation.y );
        if (translation.x <0) {
            
            NSLog(@"left");
            
        }else if( translation.x>0)
        {
            NSLog(@"right");
            
        }else if ( translation.y<0)
        {
            NSLog(@"UP");
        }else if(translation.y>0)
        {
            NSLog(@"Down");
        }
        
        sender.view.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y + translation.y);
    }
    else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed)
    {
        // do whatever post dragging you want, e.g.
        // snap the piece into place
        
    /*    [UIView animateWithDuration:0.2 animations:^
        {
            CGPoint center = sender.view.center;
            center.x = round(center.x / 50.0) * 50.0;
            center.y = round(center.y / 50.0) * 50.0;
            sender.view.center = center;
            sender.view.alpha  = 1.0;
        }];*/
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
