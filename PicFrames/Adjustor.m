//
//  Adjustor.m
//  PicFrames
//
//  Created by Sunitha Gadigota on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Adjustor.h"

@interface Adjustor ()
{
    CGPoint stPrev;
    CGPoint stCur;
    NSMutableArray *LeftOrUpArray;
    NSMutableArray *RightOrDownArray;
    
    NSMutableArray *LeftOrUpAdjArray;
    NSMutableArray *RightOrDownAdjArray;
    
    NSMutableArray *_adjustors;
    
    NSArray *photos;
}

@end

@implementation Adjustor

@synthesize eShape;
@synthesize rowCount;
@synthesize colCount;
@synthesize rowIndex;
@synthesize colIndex;

-(NSMutableArray*)adjustors
{
    return _adjustors;
}

-(CGRect)actualFrame
{
    return _actualFrame;
}

-(void)setActualFrame:(CGRect)actualFrame
{
    _actualFrame = actualFrame;
    
    return;
}

-(void)dealloc
{
    //NSLog(@"Releasing Adj ");
//    [LeftOrUpAdjArray release];
//    [RightOrDownAdjArray release];
//    [LeftOrUpArray release];
//    [RightOrDownArray release];
//    [super dealloc];
}

-(void)setAdjustors:(NSMutableArray *)adjustors
{
    int iIndex = 0;
    
    _adjustors = adjustors;
    
    LeftOrUpAdjArray = [[NSMutableArray alloc]initWithCapacity:[adjustors count]];
    RightOrDownAdjArray = [[NSMutableArray alloc]initWithCapacity:[adjustors count]];
    
    /* Construct Left/Up and Right/Down adjustors */
    for(iIndex = 0; iIndex < [_adjustors count]; iIndex++)
    {
        Adjustor *adj = [_adjustors objectAtIndex:iIndex];
        if(nil == adj)
        {
            continue;
        }
        
        if(self == adj)
        {
            continue;
        }
        
        if(NO == CGRectIntersectsRect(self.frame, adj.frame))
        {
            continue;
        }
        
        if(self.eShape == ADJUSTOR_HORIZANTAL)
        {
            if(adj.frame.origin.x < self.frame.origin.x)
            {
                if((adj.frame.origin.x+adj.frame.size.width) <= (self.frame.origin.x + self.frame.size.width))
                {
                    [LeftOrUpAdjArray addObject:adj];
                }
            }
            else 
            {
                [RightOrDownAdjArray addObject:adj];
            }
        }
        else 
        {
            if(adj.frame.origin.y < self.frame.origin.y)
            {
                if((adj.frame.origin.y+adj.frame.size.height) <= (self.frame.origin.y + self.frame.size.height))
                {
                    [LeftOrUpAdjArray addObject:adj];
                }
            }
            else 
            {
                [RightOrDownAdjArray addObject:adj];
            }
        }
    }
}

- (id)initWithFrame:(CGRect)frame photos:(NSMutableArray*)array
{
    Settings *nvm = [Settings Instance];
#if 0    
    frame = CGRectMake(frame.origin.x * nvm.wRatio/nvm.maxRatio, frame.origin.y * nvm.hRatio/nvm.maxRatio, frame.size.width * nvm.wRatio/nvm.maxRatio, frame.size.height* nvm.hRatio/nvm.maxRatio);
#else
    frame = CGRectMake(frame.origin.x * (nvm.wRatio/nvm.maxRatio) * DEV_MULTIPLIER, frame.origin.y * (nvm.hRatio/nvm.maxRatio) * DEV_MULTIPLIER, frame.size.width * (nvm.wRatio/nvm.maxRatio) * DEV_MULTIPLIER, frame.size.height * (nvm.hRatio/nvm.maxRatio) * DEV_MULTIPLIER);
#endif
    self = [super initWithFrame:frame];
    if (self) 
    {
        int iIndex = 0;
        _actualFrame = frame;

        //self.backgroundColor = [UIColor whiteColor];
        /* First set the mode */
        self.eShape = ADJUSTOR_VERTICLE;
        if(frame.size.width < frame.size.height)
        {
            self.eShape = ADJUSTOR_HORIZANTAL;
        }
        
        LeftOrUpArray = [[NSMutableArray alloc]initWithCapacity:[array count]];
        RightOrDownArray = [[NSMutableArray alloc]initWithCapacity:[array count]];
        photos = array;
        
        /* browse through the photos and fill the array */
        for(iIndex = 0; iIndex < [array count]; iIndex++)
        {
            Photo *pht = [array objectAtIndex:iIndex];
            if(nil == pht)
            {
                NSLog(@"Photo is nil, get the next one");
                continue;
            }
            
            if(NO == CGRectIntersectsRect(frame, pht.frame))
            {
                //NSLog(@"Adjustor doesn't intersect, so ignore the node");
                continue;
            }
            
            if(self.eShape == ADJUSTOR_HORIZANTAL)
            {
                if(pht.frame.origin.x < frame.origin.x)
                {
                    [LeftOrUpArray addObject:pht];
                }
                else 
                {
                    [RightOrDownArray addObject:pht];
                }
            }
            else 
            {
                if(pht.frame.origin.y < frame.origin.y)
                {
                    [LeftOrUpArray addObject:pht];
                }
                else 
                {
                    [RightOrDownArray addObject:pht];
                }
            }
        }
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    
    /* set it as previous point */
    stPrev = location;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    Photo *leftOrUpPhoto = [LeftOrUpArray objectAtIndex:0];;
    Photo *rightOrDownPhoto = [RightOrDownArray objectAtIndex:0];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];

    stCur = location;
    
    int delta = 0;
    int index = 0;
    if(self.eShape == ADJUSTOR_HORIZANTAL)
    {
        /* first validate the adjustment */
        if(stCur.x < (leftOrUpPhoto.frame.origin.x + MINIMUM_WIDTH_OR_HEIGHT))
        {
            stCur.x = leftOrUpPhoto.frame.origin.x + MINIMUM_WIDTH_OR_HEIGHT;
        }
        else if(stCur.x > (rightOrDownPhoto.frame.origin.x + rightOrDownPhoto.frame.size.width - MINIMUM_WIDTH_OR_HEIGHT))
        {
            stCur.x = rightOrDownPhoto.frame.origin.x + rightOrDownPhoto.frame.size.width - MINIMUM_WIDTH_OR_HEIGHT;
        }
        
        if(stPrev.x < (leftOrUpPhoto.frame.origin.x + MINIMUM_WIDTH_OR_HEIGHT))
        {
            stPrev.x = leftOrUpPhoto.frame.origin.x + MINIMUM_WIDTH_OR_HEIGHT;
        }
        else if(stPrev.x > (rightOrDownPhoto.frame.origin.x + rightOrDownPhoto.frame.size.width - MINIMUM_WIDTH_OR_HEIGHT))
        {
            stPrev.x = rightOrDownPhoto.frame.origin.x + rightOrDownPhoto.frame.size.width - MINIMUM_WIDTH_OR_HEIGHT;
        }
        
        delta = stCur.x - stPrev.x;
        
        /* If delta is zero then no need to proceed further */
        if(delta == 0)
        {
            return;
        }
        
        /* Now adjust the left frames */
        for(index = 0; index < [LeftOrUpArray count]; index++)
        {
            Photo *pht = [LeftOrUpArray objectAtIndex:index];
            pht.frame = CGRectMake(pht.frame.origin.x, pht.frame.origin.y, pht.frame.size.width+delta, pht.frame.size.height);
            pht.actualFrame = CGRectMake(pht.actualFrame.origin.x, pht.actualFrame.origin.y, pht.actualFrame.size.width+delta, pht.actualFrame.size.height);
            
            //NSLog(@"Left(%d) %f, %f, %f, %f",index,pht.frame.origin.x,pht.frame.origin.y,pht.frame.size.width,pht.frame.size.height);
        }
        
        /* Adjust the right frames */
        for(index = 0; index < [RightOrDownArray count]; index++)
        {
            Photo *pht = [RightOrDownArray objectAtIndex:index];
            pht.frame = CGRectMake(pht.frame.origin.x+delta, pht.frame.origin.y, pht.frame.size.width - delta, pht.frame.size.height);
            pht.actualFrame = CGRectMake(pht.actualFrame.origin.x+delta, pht.actualFrame.origin.y, pht.actualFrame.size.width - delta, pht.actualFrame.size.height);
        }

        /* Now adjust Left adjustors */
        for(index = 0; index < [LeftOrUpAdjArray count]; index++)
        {
            Adjustor *adj = [LeftOrUpAdjArray objectAtIndex:index];
            adj.frame = CGRectMake(adj.frame.origin.x, adj.frame.origin.y, adj.frame.size.width+delta, adj.frame.size.height);
            adj.actualFrame = CGRectMake(adj.actualFrame.origin.x, adj.actualFrame.origin.y, adj.actualFrame.size.width+delta, adj.actualFrame.size.height);
            //adj.actualFrame = adj.frame;
        }
        
        /* Now adjust right adjustors */
        for(index = 0; index < [RightOrDownAdjArray count]; index++)
        {
            Adjustor *adj = [RightOrDownAdjArray objectAtIndex:index];
            adj.frame = CGRectMake(adj.frame.origin.x+delta, adj.frame.origin.y, adj.frame.size.width-delta, adj.frame.size.height);
            adj.actualFrame = CGRectMake(adj.actualFrame.origin.x+delta, adj.actualFrame.origin.y, adj.actualFrame.size.width-delta, adj.actualFrame.size.height);;
            //adj.actualFrame = adj.frame;
        }

        /* Adjust ourself */
        self.center = CGPointMake(self.center.x + delta, self.center.y);
        self.actualFrame = CGRectMake(self.actualFrame.origin.x+delta, self.actualFrame.origin.y, self.actualFrame.size.width, self.actualFrame.size.height);
        //self.actualFrame = self.frame;
    }
    else 
    {
        /* first validate the adjustment */
        if(stCur.y < (leftOrUpPhoto.frame.origin.y + MINIMUM_WIDTH_OR_HEIGHT))
        {
            stCur.y = leftOrUpPhoto.frame.origin.y + MINIMUM_WIDTH_OR_HEIGHT;
        }
        else if(stCur.y > (rightOrDownPhoto.frame.origin.y + rightOrDownPhoto.frame.size.height - MINIMUM_WIDTH_OR_HEIGHT))
        {
            stCur.y = rightOrDownPhoto.frame.origin.y + rightOrDownPhoto.frame.size.height - MINIMUM_WIDTH_OR_HEIGHT;
        }
        
        if(stPrev.y < (leftOrUpPhoto.frame.origin.y + MINIMUM_WIDTH_OR_HEIGHT))
        {
            stPrev.y = leftOrUpPhoto.frame.origin.y + MINIMUM_WIDTH_OR_HEIGHT;
        }
        else if(stPrev.y > (rightOrDownPhoto.frame.origin.y + rightOrDownPhoto.frame.size.height - MINIMUM_WIDTH_OR_HEIGHT))
        {
            stPrev.y = rightOrDownPhoto.frame.origin.y + rightOrDownPhoto.frame.size.height - MINIMUM_WIDTH_OR_HEIGHT;
        }
        
        delta = stCur.y - stPrev.y;
        
        /* If delta is zero then no need to proceed further */
        if(delta == 0)
        {
            //NSLog(@"Delta is zero so ignore the touch");
            return;
        }
        
        /* Now adjust the left frames */
        for(index = 0; index < [LeftOrUpArray count]; index++)
        {
            Photo *pht = [LeftOrUpArray objectAtIndex:index];
            pht.frame = CGRectMake(pht.frame.origin.x, pht.frame.origin.y, pht.frame.size.width, pht.frame.size.height + delta);
            pht.actualFrame = CGRectMake(pht.actualFrame.origin.x, pht.actualFrame.origin.y, pht.actualFrame.size.width, pht.actualFrame.size.height + delta);
        }
        
        /* Adjust the right frames */
        for(index = 0; index < [RightOrDownArray count]; index++)
        {
            Photo *pht = [RightOrDownArray objectAtIndex:index];
            pht.frame = CGRectMake(pht.frame.origin.x, pht.frame.origin.y+delta, pht.frame.size.width, pht.frame.size.height - delta);
            pht.actualFrame = CGRectMake(pht.actualFrame.origin.x, pht.actualFrame.origin.y+delta, pht.actualFrame.size.width, pht.actualFrame.size.height - delta);
        }
   
        /* Now adjust Up adjustors */
        for(index = 0; index < [LeftOrUpAdjArray count]; index++)
        {
            Adjustor *adj = [LeftOrUpAdjArray objectAtIndex:index];
            adj.frame = CGRectMake(adj.frame.origin.x, adj.frame.origin.y, adj.frame.size.width, adj.frame.size.height + delta);
            adj.actualFrame = CGRectMake(adj.actualFrame.origin.x, adj.actualFrame.origin.y, adj.actualFrame.size.width, adj.actualFrame.size.height + delta);;
            //adj.actualFrame = adj.frame;
        }
        
        /* Now adjust Down adjustors */
        for(index = 0; index < [RightOrDownAdjArray count]; index++)
        {
            Adjustor *adj = [RightOrDownAdjArray objectAtIndex:index];
            adj.frame = CGRectMake(adj.frame.origin.x, adj.frame.origin.y+delta, adj.frame.size.width, adj.frame.size.height-delta);
            adj.actualFrame = CGRectMake(adj.actualFrame.origin.x, adj.actualFrame.origin.y+delta, adj.actualFrame.size.width, adj.actualFrame.size.height-delta);;
            //adj.actualFrame = adj.frame;
        }
    
        /* Adjust ourself */
        self.center = CGPointMake(self.center.x, self.center.y + delta);
        self.actualFrame = CGRectMake(self.actualFrame.origin.x, self.actualFrame.origin.y+delta, self.actualFrame.size.width, self.actualFrame.size.height);
        //self.actualFrame = self.frame;
    }
    
    stPrev = stCur;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:photoDimensionsChanged
                                                        object:nil];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:photoDimensionsChanged
    //                                                    object:nil];
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
