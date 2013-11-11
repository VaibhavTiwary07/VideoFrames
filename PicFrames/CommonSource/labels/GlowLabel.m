//
//  GlowLabel.m
//  LabelRND
//
//  Created by Vijaya kumar reddy Doddavala on 7/19/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "GlowLabel.h"


@implementation GlowLabel

-(void)initializeWithdefaults
{
    /* Initializing the timer vars */
    deleteTimer = nil;
    bDoneEditing = NO;
    subview = nil;
    bSuspendEditing = NO;
    
    return;
}

- (void)encodeWithCoder:(NSCoder *)coder 
{
    NSNumber *_doneEditing = [[NSNumber alloc]initWithBool:bDoneEditing];
    
    [super encodeWithCoder:coder];
    
    //[coder encodeObject:recognizer forKey:@"GestureRecognizer"];
    //NSNumber *num = [NSNumber numberWithFloat:self.layer.cornerRadius];
    [coder encodeObject:_doneEditing forKey:@"EditingStatus"];
    [coder encodeObject:subview forKey:@"subview"];
    [coder encodeFloat:self.layer.cornerRadius forKey:@"cornerradius"];
    [_doneEditing release];
    
    //NSLog(@"Encoding Glowlabels (%f,%f,%f,%f) +++++++++++++++++++++++++++++++++++++++",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
}

- (id)initWithCoder:(NSCoder *)coder 
{
    self = [super initWithCoder:coder];
    if (self) 
    {
        NSNumber *_doneEditing;
        
        // Implementation continues.
        //recognizer   = [coder decodeObjectForKey:@"GestureRecognizer"];
        _doneEditing = [coder decodeObjectForKey:@"EditingStatus"];
        subview      = [coder decodeObjectForKey:@"subview"];
        self.layer.cornerRadius = [coder decodeFloatForKey:@"cornerradius"];
        
        bDoneEditing = [_doneEditing boolValue];
        [_doneEditing autorelease];
        deleteTimer = nil;
        //[self addGestureRecognizer:recognizer];
        recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];    
        recognizer.minimumPressDuration = 0.1;  
        [self addGestureRecognizer:recognizer];
        [recognizer release];
        
        bDoneEditing = YES;
        bSuspendEditing = NO;
        
        //NSLog(@"decoding Glow label ----------------------------------------");
        //NSLog(@"Glowlabel:initWithCoder: %f,%f,%f,%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    }
    return self;
}

-(void)dealloc
{
    if(nil != recognizer)
    {
        [self removeGestureRecognizer:recognizer];
        recognizer = nil;
    }
    
    [super dealloc];
}

-(void)doneWithEditing
{
    bDoneEditing = YES;
    bSuspendEditing = NO;
    
    //NSLog(@"GlowLable Before encoding: (%f,%f,%f,%f)",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    /* add the gesture recognizer */
    recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];    
    recognizer.minimumPressDuration = 0.1;  
    [self addGestureRecognizer:recognizer];
    [recognizer release];
    
    return;
}

-(void)setShadowColorTo:(UIColor*)color
{
    CALayer *ref      = self.layer;
    ref.shadowOpacity = 1.0;   
    ref.shadowRadius  = 5.0;
    ref.shadowColor   = color.CGColor;
    ref.shadowOffset  = CGSizeMake(0.0, -1.0);
    
    return;
}

-(void)setExtraView:(id)extraView
{
    subview = extraView;
}

-(id)getExtraView
{
    return subview;
}

-(void)timeoutAndDeleteTheLabel
{
    GlowLabel *pShadow = (GlowLabel*)subview;
    
    /* reduce the alpha */
    if(pShadow)
    {
        pShadow.alpha -= 0.1;
    }
    
    self.alpha    -= 0.1;
    
    /* check if the label is fully dissapeared */
    if(0.0 > self.alpha)
    {
        //NSLog(@"GlowLabel:deleting the label");
        [self removeGestureRecognizer:recognizer];
        [deleteTimer invalidate];
        deleteTimer = nil;
        if(pShadow)
        {
            [pShadow removeFromSuperview];
        }
        [self removeFromSuperview];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:deletedlabel object:nil userInfo:nil];
    }   

    return;
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{ 
    /* Touches began */
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //NSLog(@"GlowLabels:About to start delete process");
        if(nil == deleteTimer)
        {
            deleteTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeoutAndDeleteTheLabel) userInfo:nil repeats:YES];
            
        }
    }
    
    /* touches ended */
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(nil != deleteTimer)
        {
            //NSLog(@"GlowLabel:Not deleting the label");
            GlowLabel *pShadow = (GlowLabel*)subview;
            
            /* delete the timer */
            [deleteTimer invalidate];
            deleteTimer   = nil;
            
            /* Set the alpha back to original position */
            self.alpha    = 1.0;
            if(pShadow)
            {
                pShadow.alpha = 1.0;
            }
        }
    }
    
    return;
}

-(BOOL)canBecomeFirstResponder
{
    /* User is done with entering the text, so don't allow usr to edit it again */
    if(bDoneEditing)
    {
        return NO;
    }
    
    /* User suspended editing to change the label style, so don't show key board */
    if(bSuspendEditing)
    {
        return NO;
    }

    return YES;
}

-(void)putInSuspendedState
{
    //bDoneEditing = NO;
    bSuspendEditing = YES;
}

-(void)putInReadystate
{
    bSuspendEditing = NO;
}

@end
