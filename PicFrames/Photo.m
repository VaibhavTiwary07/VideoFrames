//
//  Photo.m
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"

@interface Photo ()
{
    //UIImageView *imgView;
    NSTimer     *tapTimer;
    CGSize       imgSize;
    
    UITapGestureRecognizer *singleTap;
    UITapGestureRecognizer *doubleTap;
    UILongPressGestureRecognizer *longPress;
}
@property(nonatomic,retain)UIImage *_internalImage;
@end

@implementation Photo
@synthesize view;
@synthesize rowCount;
@synthesize colCount;
@synthesize rowIndex;
@synthesize colIndex;
@synthesize noTouchMode;
@synthesize _internalImage;

-(float)scale
{
    return _scale;
}

-(CGPoint)offset
{
    return _offset;
}

-(void)setScale:(float)scale
{
    _scale = scale;
    //NSLog(@"setScale New Scale %d for %f-------------",iPhotoNumber,_scale);
    [self.view.scrollView setZoomScale:scale];
    
    return;
}

-(void)setOffset:(CGPoint)offset
{
    //NSLog(@"setOffset %d (%f,%f) to (%f,%f)",iPhotoNumber,_offset.x,_offset.y,offset.x,offset.y);
    _offset = offset;
    
    [self.view.scrollView setContentOffset:offset];
    
    return;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    //NSLog(@"scrollViewDidEndZooming %d (%f,%f) to (%f,%f)",iPhotoNumber,_offset.x,_offset.y,scrollView.contentOffset.x,scrollView.contentOffset.y);
    _scale = scale;
    _offset = scrollView.contentOffset;
    [[NSNotificationCenter defaultCenter] postNotificationName:scaleAndOffsetChanged
                                                        object:self];
}

/*
 WARNING: This code actually screws the content offset while changing the photo dimensions
 so do not use this funcion at all
 */
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll (%f,%f) to (%f,%f)",_offset.x,_offset.y,scrollView.contentOffset.x,scrollView.contentOffset.y);
    //_offset = scrollView.contentOffset;
}
*/

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"scrollViewDidEndDragging %d (%f,%f) to (%f,%f)",iPhotoNumber,_offset.x,_offset.y,scrollView.contentOffset.x,scrollView.contentOffset.y);
    _offset = scrollView.contentOffset;
    [[NSNotificationCenter defaultCenter] postNotificationName:scaleAndOffsetChanged
                                                        object:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating %d (%f,%f) to (%f,%f)",iPhotoNumber,_offset.x,_offset.y,scrollView.contentOffset.x,scrollView.contentOffset.y);
    _offset = scrollView.contentOffset;
    [[NSNotificationCenter defaultCenter] postNotificationName:scaleAndOffsetChanged
                                                        object:self];
}

-(void)notifyAsSwapFrom
{
    [[NSNotificationCenter defaultCenter] postNotificationName:swapFromSelected
                                                        object:self];
}

-(void)notifyAsSwapTo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:swapToSelected
                                                        object:self];
}

- (void)handleSingleTap:(NSTimer*)t
{
    tapTimer = nil;
    // handling code
    self.view.imageView.alpha = 1.0;
    
    if(self.noTouchMode)
    {
        return;
    }
    
    if(nil == self.view.imageView.image)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:selectImageForPhoto
                                                        object:self
                                                      userInfo:t.userInfo];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:editImageForPhoto
                                                            object:self
                                                          userInfo:t.userInfo];
    }
    
    return;
}

- (void)checkSingleTapValidity:(UITapGestureRecognizer *)sender
{     
    if (sender.state == UIGestureRecognizerStateEnded)     
    {
        CGPoint p = [sender locationInView:self.view.imageView];
        NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],self.view.imageView, self.view, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"x_location",@"y_location",@"view",@"scrollview", nil];
        NSDictionary *location = [NSDictionary dictionaryWithObjects:coordinates forKeys:keys];
        
        if(nil == self.view.imageView.image)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:selectImageForPhoto
                                                                object:self
                                                              userInfo:location];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:editImageForPhoto
                                                                object:self
                                                              userInfo:location];
        }
#if 0
        tapTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleSingleTap:) userInfo:location repeats:NO];
        self.view.imageView.alpha = 0.5;
        /* Animate the Touch */
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        self.view.imageView.alpha = 1.0;
        [UIView commitAnimations];
#endif
    }
}

-(void)longPressDetected:(UILongPressGestureRecognizer*)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Long Press Detected");
        [[NSNotificationCenter defaultCenter] postNotificationName:swapmodeentered
                                                            object:self
                                                          userInfo:nil];
    }
}

- (void)checkDoubleTapValidity:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if([tapTimer isValid])
        {
            [tapTimer invalidate];
        }
        
        CGPoint p = [sender locationInView:self.view.imageView];
        NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],self.view.imageView, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"x_location",@"y_location",@"view", nil];
        NSDictionary *location = [NSDictionary dictionaryWithObjects:coordinates forKeys:keys];
        tapTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(handleDoubleTap:) userInfo:location repeats:NO];
        
        self.view.imageView.alpha = 0.5;
        /* Animate the Touch */
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        self.view.imageView.alpha = 1.0;
        [UIView commitAnimations];
    }
}


- (void)handleDoubleTap:(NSTimer *)t
{
    [[NSNotificationCenter defaultCenter] postNotificationName:editImageForPhoto
                                                        object:self
                                                      userInfo:t.userInfo];
}

- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor*)clr
{
    self = [super init];
    if (self) 
    {
        Settings *nvm = [Settings Instance];
        self.noTouchMode = NO;
#if 0        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            float devMultiPlier = (IPAD_FRAME_SIZE/IPHONE_FRAME_SIZE);
            frame = CGRectMake(frame.origin.x * (nvm.wRatio/nvm.maxRatio) * devMultiPlier, frame.origin.y * (nvm.hRatio/nvm.maxRatio) * devMultiPlier, frame.size.width * (nvm.wRatio/nvm.maxRatio) * devMultiPlier, frame.size.height * (nvm.hRatio/nvm.maxRatio) * devMultiPlier);
        }
        else
        {
            frame = CGRectMake(frame.origin.x * nvm.wRatio/nvm.maxRatio, frame.origin.y * nvm.hRatio/nvm.maxRatio, frame.size.width * nvm.wRatio/nvm.maxRatio, frame.size.height* nvm.hRatio/nvm.maxRatio);
        }
#else
        frame = CGRectMake(frame.origin.x * (nvm.wRatio/nvm.maxRatio) * DEV_MULTIPLIER, frame.origin.y * (nvm.hRatio/nvm.maxRatio) * DEV_MULTIPLIER, frame.size.width * (nvm.wRatio/nvm.maxRatio) * DEV_MULTIPLIER, frame.size.height * (nvm.hRatio/nvm.maxRatio) * DEV_MULTIPLIER);
#endif
        _frame = frame;
        _actualFrame = frame;
        //_image = nil;
        self._internalImage = nil;
        tapTimer = nil;
        
        /* Allocate  */
        
        // Initialization code
        ssivView *iv = [[ssivView alloc]initWithFrame:frame];
        self.view = iv;
        //[iv release];
        
        //self.view.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        
        self.view.scrollView.scrollEnabled = YES;
        self.view.scrollView.showsVerticalScrollIndicator = NO;
        self.view.scrollView.showsHorizontalScrollIndicator = NO;
        self.view.scrollView.backgroundColor = [UIColor blackColor];
        
        // Allocate image view 
        //imgView   = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.view.imageView.contentMode = UIViewContentModeScaleToFill;
        self.view.imageView.backgroundColor = clr;
        [self.view.imageView setUserInteractionEnabled:YES];
        
        self.view.imageView.touchdelegate = self;
        
        /* set it to nil to not to support SWAP */
        self.view.imageView.redirectView = nil;
#if 0
        // add gesture recognizers to the image view
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkSingleTapValidity:)];
        
        [self.view.imageView addGestureRecognizer:singleTap];
        
        doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkDoubleTapValidity:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.view.imageView addGestureRecognizer:doubleTap];

        longPress = [[UILongPressGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(longPressDetected:)];
        longPress.minimumPressDuration = 3;
        longPress.numberOfTouchesRequired = 1;
        [self.view.imageView addGestureRecognizer:longPress];
        [longPress release];
        [doubleTap release];
        [singleTap release];
#endif
        
        [self.view.scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
        [self.view.scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
        //[self.view addSubview:imgView];
        [self.view.scrollView setCanCancelContentTouches:YES];
        
        self.view.scrollView.minimumZoomScale = self.view.frame.size.width / self.view.imageView.frame.size.width;
        //self.view.maximumZoomScale = 2.0;
        //NSLog(@"initWithFrame %d content size %f,%f-------------",iPhotoNumber,frame.size.width,frame.size.height);
        [self.view.scrollView setZoomScale:self.view.scrollView.minimumZoomScale];
        self.view.scrollView.delegate = self;
        
        //[imgView release];
    }
    return self;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return self.view.imageView;
}

-(void)setTheImageToBlank
{
    self.view.imageView.image = nil;
    //_image = nil;
    self._internalImage = nil;
    self.view.imageView.redirectView = nil;
}

-(UIImage*)image
{
    //return _image;
    return self._internalImage;
}

-(void)singleTapDetected:(UITouch *)loc
{
    if(self.noTouchMode)
    {
        return;
    }
    
    CGPoint p = [loc locationInView:self.view.imageView];
    NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],self.view.imageView, self.view, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"x_location",@"y_location",@"view",@"scrollview", nil];
    NSDictionary *location = [NSDictionary dictionaryWithObjects:coordinates forKeys:keys];
    
    if(nil == self.view.imageView.image)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:selectImageForPhoto
                                                            object:self
                                                          userInfo:location];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:editImageForPhoto
                                                            object:self
                                                          userInfo:location];
    }
}

-(void)setImage:(UIImage *)image
{
    if(nil == image)
    {
        [self setTheImageToBlank];
        
        return;
    }
    
    self.view.imageView.redirectView = nil;
    self.view.imageView.transform = CGAffineTransformIdentity;
    //_image = image;
    self._internalImage = image;
    imgSize = image.size;
    
    self.view.imageView.image = image;
    
    self.view.imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    //imgView.center = self.view.center;
    
    
    //imgView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [self.view.scrollView setContentSize:image.size];
    
    CGPoint offset = CGPointMake(-(self.view.frame.size.width - image.size.width)/2.0, -(self.frame.size.height-image.size.height)/2.0);
    //[self.view setContentOffset:offset];
    self.offset = offset;
    
    //NSLog(@"setImage %d content size %f,%f-------------",iPhotoNumber,self.view.contentSize.width,self.view.contentSize.height);
    CGSize maxSize = self.view.frame.size;
    //CGSize maxSize = self.actualFrame.size;
    CGFloat widthRatio = maxSize.width / image.size.width;
    CGFloat heightRatio = maxSize.height / image.size.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? widthRatio : heightRatio;
    
    [self.view.scrollView setMinimumZoomScale:initialZoom];
    self.view.scrollView.maximumZoomScale = 2.0;
    //[self.view setZoomScale:initialZoom];
    self.scale = initialZoom;
    //
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:scaleAndOffsetChanged
    //                                                    object:self];
    return;
}

-(void)setEditedImage:(UIImage *)image
{
    if(nil == image)
    {
        [self setTheImageToBlank];
        
        return;
    }
    
    /* Set the image to the image view */
    self.view.imageView.image = image;
    //_image = image;
    self._internalImage = image;
    
    return;
}

-(int)photoNumber
{
    return iPhotoNumber;
}

-(void)setPhotoNumber:(int)photoNumber
{
    iPhotoNumber = photoNumber;
    
    return;
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

-(CGRect)contentFrame
{
    return self.view.imageView.frame;
}

-(CGRect)frame
{
    return _frame;
}

-(void)setFrame:(CGRect)frame
{
    _frame = frame;
    
    //NSLog(@"Adjusting Photo Frame %f, %f, %f, %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    self.view.frame = frame;
    self.view.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    /* This change is commented because it was unzooming on changing the width */

#if 0    
    [self.view setContentSize:imgSize];
    
    //CGPoint offset = CGPointMake(-(self.view.frame.size.width - imgSize.width)/2.0, -(self.frame.size.height-imgSize.height)/2.0);
    //CGPoint offset = CGPointMake(0.0,0.0);
    //[self.view setContentOffset:offset];
    
    
    CGSize maxSize = self.view.frame.size;
    CGFloat widthRatio = maxSize.width / imgSize.width;
    CGFloat heightRatio = maxSize.height / imgSize.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? widthRatio : heightRatio;
    
    [self.view setMinimumZoomScale:initialZoom];
    self.view.maximumZoomScale = 2.0; 
    [self.view setZoomScale:_scale];
    [self.view setContentOffset:_offset];

    if(_scale != 0.0)
    {
    NSLog(@"Applying scale %f offset is %f,%f of %f,%f---------------",_scale,self.view.contentOffset.x,self.view.contentOffset.y,_offset.x,_offset.y);
    }
    //NSLog(@"setFrame New Scale of photo %d id %f-------------",self.photoNumber,initialZoom);
#else
    CGSize maxSize = self.view.frame.size;
    CGFloat widthRatio = maxSize.width / imgSize.width;
    CGFloat heightRatio = maxSize.height / imgSize.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? widthRatio : heightRatio;
    
    [self.view.scrollView setMinimumZoomScale:initialZoom];
    self.view.scrollView.maximumZoomScale = 2.0;
    [self.view.scrollView setZoomScale:_scale];
#endif
    return;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)releaseAllResources
{
#if 0
    //NSLog(@"Releasing Photo resources %d",imgView.retainCount);
    [self.view.imageView removeGestureRecognizer:singleTap];
    [self.view.imageView removeGestureRecognizer:doubleTap];
    [self.view.imageView removeGestureRecognizer:longPress];
#endif
    //[self.view.imageView removeFromSuperview];
    [self.view removeFromSuperview];
}

-(void)dealloc
{
    [super dealloc];
}

@end
