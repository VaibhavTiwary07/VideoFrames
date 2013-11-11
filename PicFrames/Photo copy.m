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
    UIImageView *imgView;
    NSTimer     *tapTimer;
    CGSize       imgSize;
    
    UITapGestureRecognizer *singleTap;
    UITapGestureRecognizer *doubleTap;
}
@end

@implementation Photo
@synthesize view;
@synthesize rowCount;
@synthesize colCount;
@synthesize rowIndex;
@synthesize colIndex;

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
    [self.view setZoomScale:scale];
    
    return;
}

-(void)setOffset:(CGPoint)offset
{
    //NSLog(@"setOffset %d (%f,%f) to (%f,%f)",iPhotoNumber,_offset.x,_offset.y,offset.x,offset.y);
    _offset = offset;
    
    [self.view setContentOffset:offset];
    
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
    imgView.alpha = 1.0;
    
    if(nil == imgView.image)
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
        CGPoint p = [sender locationInView:imgView];
        NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],imgView, view, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"x_location",@"y_location",@"view",@"scrollview", nil];
        NSDictionary *location = [NSDictionary dictionaryWithObjects:coordinates forKeys:keys];
        tapTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(handleSingleTap:) userInfo:location repeats:NO];
        
        imgView.alpha = 0.5;
        /* Animate the Touch */
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        imgView.alpha = 1.0;
        [UIView commitAnimations];
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
        
        CGPoint p = [sender locationInView:imgView];
        NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],imgView, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"x_location",@"y_location",@"view", nil];
        NSDictionary *location = [NSDictionary dictionaryWithObjects:coordinates forKeys:keys];
        tapTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(handleDoubleTap:) userInfo:location repeats:NO];
        
        imgView.alpha = 0.5;
        /* Animate the Touch */
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        imgView.alpha = 1.0;
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
        _image = nil;
        tapTimer = nil;
        
        /* Allocate  */
        
        // Initialization code
        self.view = [[UIScrollView alloc]initWithFrame:frame];
        self.view.scrollEnabled = YES;
        self.view.showsVerticalScrollIndicator = NO;
        self.view.showsHorizontalScrollIndicator = NO;
        self.view.backgroundColor = [UIColor blackColor];
        
        // Allocate image view 
        imgView   = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.backgroundColor = clr;
        [imgView setUserInteractionEnabled:YES];
        
        // add gesture recognizers to the image view
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkSingleTapValidity:)];
        
        [imgView addGestureRecognizer:singleTap];
        
        doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkDoubleTapValidity:)];
        doubleTap.numberOfTapsRequired = 2;
        [imgView addGestureRecognizer:doubleTap];
        
        [doubleTap release];
        [singleTap release];
        
        [self.view setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
        [self.view setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
        [self.view addSubview:imgView];
        [self.view setCanCancelContentTouches:YES];
        
        self.view.minimumZoomScale = self.view.frame.size.width / imgView.frame.size.width;
        //self.view.maximumZoomScale = 2.0;
        //NSLog(@"initWithFrame %d content size %f,%f-------------",iPhotoNumber,frame.size.width,frame.size.height);
        [self.view setZoomScale:self.view.minimumZoomScale];
        self.view.delegate = self;
        
        [imgView release];
    }
    return self;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return imgView;
}

-(void)setTheImageToBlank
{
    imgView.image = nil;
    _image = nil;
}

-(UIImage*)image
{
    return _image;
}

-(void)setImage:(UIImage *)image
{
    if(nil == image)
    {
        [self setTheImageToBlank];
        
        return;
    }
    
    imgView.transform = CGAffineTransformIdentity;
    _image = image;
    imgSize = image.size;
    
    imgView.image = image;
    
    imgView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    //imgView.center = self.view.center;
    
    
    //imgView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [self.view setContentSize:image.size];
    
    CGPoint offset = CGPointMake(-(self.view.frame.size.width - image.size.width)/2.0, -(self.frame.size.height-image.size.height)/2.0);
    //[self.view setContentOffset:offset];
    self.offset = offset;
    
    //NSLog(@"setImage %d content size %f,%f-------------",iPhotoNumber,self.view.contentSize.width,self.view.contentSize.height);
    CGSize maxSize = self.view.frame.size;
    //CGSize maxSize = self.actualFrame.size;
    CGFloat widthRatio = maxSize.width / image.size.width;
    CGFloat heightRatio = maxSize.height / image.size.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? widthRatio : heightRatio;
    
    [self.view setMinimumZoomScale:initialZoom];
    self.view.maximumZoomScale = 2.0; 
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
    imgView.image = image;
    _image = image;
    
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
    return imgView.frame;
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
    
    [self.view setMinimumZoomScale:initialZoom];
    self.view.maximumZoomScale = 2.0; 
    [self.view setZoomScale:_scale];
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
    //NSLog(@"Releasing Photo resources %d",imgView.retainCount);
    [imgView removeGestureRecognizer:singleTap];
    [imgView removeGestureRecognizer:doubleTap];
    [imgView removeFromSuperview];
    [self.view removeFromSuperview];
}

-(void)dealloc
{
    [super dealloc];
}

@end
