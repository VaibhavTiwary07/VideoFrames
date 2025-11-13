//
//  TouchView.m
//  MirroCamFx
//
//  Created by Vijaya kumar reddy Doddavala on 10/30/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "TouchView.h"
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerDemoPlaybackView.h"

@interface TouchDetectView()
{
    AVPlayerDemoPlaybackView *playbackView;
}
@end
@implementation TouchDetectView
@synthesize touchdelegate;
@synthesize redirectView;

-(void)removePlayer
{
    //NSLog(@"Playbackview ref count %d frame %f,%f,%f,%f self.frame %f,%f,%f,%f",[playbackView retainCount],playbackView.frame.origin.x,playbackView.frame.origin.y,playbackView.frame.size.width,playbackView.frame.size.height,self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    [playbackView removeFromSuperview];
    //NSLog(@"remove playbackview");
}

- (void)setPlayer:(AVPlayer*)player
{
    NSLog(@"Adding playback view");
    
	//[(AVPlayerLayer*)[self layer] setPlayer:player];
    playbackView = [[AVPlayerDemoPlaybackView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    playbackView.tag = 658;
    playbackView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    [playbackView setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
    [playbackView setPlayer:player];
    
    //[self clipsToBounds];
    [self addSubview:playbackView];
    
    playbackView.center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y-self.frame.origin.y);
   // [playbackView release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.redirectView = nil;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchView: grabbed the touch");
    
    /* Forward the touches began */
    if(nil != self.redirectView)
    {
        [self.redirectView touchesBegan:touches withEvent:event];
    }
    
    if([self.touchdelegate respondsToSelector:@selector(touchDetected:)])
    {
        [self.touchdelegate touchDetected:[touches anyObject]];
    }
#if 0
    UITouch *t = [touches anyObject];
    if(nil == t)
    {
        return;
    }

    if(t.tapCount == 1)
    {
        if([self.touchdelegate respondsToSelector:@selector(singleTapDetected:)])
        {
            [self.touchdelegate singleTapDetected:t];
        }
    }
    
    if(t.tapCount == 2)
    {
        if([self.touchdelegate respondsToSelector:@selector(doubleTapDetected:)])
        {
            [self.touchdelegate doubleTapDetected:t];
        }
    }
#endif
    return;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(nil != self.redirectView)
    {
        [self.redirectView touchesMoved:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(nil != self.redirectView)
    {
        [self.redirectView touchesEnded:touches withEvent:event];
    }
    
    UITouch *t = [touches anyObject];
    if(nil == t)
    {
        return;
    }
    
    if(t.tapCount == 1)
    {
        if([self.touchdelegate respondsToSelector:@selector(singleTapDetected:)])
        {
            [self.touchdelegate singleTapDetected:t];
        }
    }
    
    if(t.tapCount == 2)
    {
        if([self.touchdelegate respondsToSelector:@selector(doubleTapDetected:)])
        {
            [self.touchdelegate doubleTapDetected:t];
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(nil != self.redirectView)
    {
        [self.redirectView touchesCancelled:touches withEvent:event];
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
//-(void)dealloc
//{
//    [_player release];
//    [super dealloc];
//}
@end
