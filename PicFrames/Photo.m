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
    //UIImageView *imgView;sdlnsdkhsdg
    NSTimer     *tapTimer;
    CGSize       imgSize;
    
    UITapGestureRecognizer *singleTap;
    UITapGestureRecognizer *doubleTap;
    UILongPressGestureRecognizer *longPress;
    UIView *view1;
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
@synthesize effectTouchMode;
@synthesize _internalImage;
@synthesize isContentTypeVideo;

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
    NSLog(@"set offset %@",NSStringFromCGPoint(_offset));
    return;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //NSLog(@"scrollViewDidEndZooming %d (%f,%f) to (%f,%f)",iPhotoNumber,_offset.x,_offset.y,scrollView.contentOffset.x,scrollView.contentOffset.y);
    _scale = scale;
    _offset = scrollView.contentOffset;
    NSLog(@"scrollView Did End Zooming - set offset %@ , scale is %f",NSStringFromCGPoint(_offset),_scale);
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
    if (self.effectTouchMode) {
        NSLog(@" 111111 effect selected mode");
        if (nil!= self.view.imageView.image) {
            self.view.scrollView.layer.borderWidth = 5.0;
            self.view.scrollView.layer.borderColor = [UIColor redColor].CGColor;
        }else
        {
            self.view.scrollView.layer.borderWidth = 0.0;
            
        }
        return;
    }
    if(self.noTouchMode)
    {
        return;
    }

    // Add green selection border (shape-aware)
    self.isSelected = YES;
    UIColor *greenColor = [UIColor colorWithRed:184/255.0 green:234/255.0 blue:112/255.0 alpha:1.0];

    if (self.view.curShape == SHAPE_NOSHAPE) {
        self.view.scrollView.layer.borderWidth = 3.0;
        self.view.scrollView.layer.borderColor = greenColor.CGColor;
    } else {
        [self.view setBorderStyle:greenColor
                       lineWidth:3.0f
                     dashPattern:nil];
        self.view.scrollView.layer.borderWidth = 0.0;
    }

    // Notify to deselect other photos
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoSlotSelected"
                                                        object:self
                                                      userInfo:nil];

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
        if (effectTouchMode) {
            NSLog(@" effect touch mode");
            return;
        }
        CGPoint p = [sender locationInView:self.view.imageView];
        NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],self.view.imageView, self.view, nil];
        /// To maintain same view size for slect photo options menu
//        NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],self.view, self.view, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"x_location",@"y_location",@"view",@"scrollview", nil];
        NSDictionary *location = [NSDictionary dictionaryWithObjects:coordinates forKeys:keys];
        NSLog(@" single tap");

        // Set green selection border (shape-aware)
        self.isSelected = YES;
        UIColor *greenColor = [UIColor colorWithRed:184/255.0 green:234/255.0 blue:112/255.0 alpha:1.0];

        if (self.view.curShape == SHAPE_NOSHAPE) {
            self.view.scrollView.layer.borderWidth = 3.0;
            self.view.scrollView.layer.borderColor = greenColor.CGColor;
        } else {
            [self.view setBorderStyle:greenColor
                           lineWidth:3.0f
                         dashPattern:nil];
            self.view.scrollView.layer.borderWidth = 0.0;
        }

        // Post notification to deselect other photos
        [[NSNotificationCenter defaultCenter] postNotificationName:@"photoSlotSelected"
                                                            object:self
                                                          userInfo:nil];

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
        /// To maintain same view size for slect photo options menu
//        NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],self.view, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"x_location",@"y_location",@"view", nil];
        NSDictionary *location = [NSDictionary dictionaryWithObjects:coordinates forKeys:keys];
        tapTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(handleDoubleTap:) userInfo:location repeats:NO];
        
        self.view.imageView.alpha = 0.5;
//        /* Animate the Touch */
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.1];
//        self.view.imageView.alpha = 1.0;
//        [UIView commitAnimations];
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.view.imageView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             // Optional: Handle completion if needed
                         }];

    }
}


- (void)handleDoubleTap:(NSTimer *)t
{
    [[NSNotificationCenter defaultCenter] postNotificationName:editImageForPhoto
                                                        object:self
                                                      userInfo:t.userInfo];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        Settings *nvm = [Settings Instance];
        self.noTouchMode = NO;
#if 0
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            float devMultiPlier = (IPAD_FRAME_SIZE/IPHONE_FRAME_SIZE);
            frame = CGRectMake(frame.origin.x * (nvm.wRatio/nvm.maxRatio) * devMultiPlier, frame.origin.y * (nvm.hRatio/nvm.maxRatio) * devMultiPlier, frame.size.width * (nvm.wRatio/nvm.maxRatio) * devMultiPlier, frame.size.height * (nvm.hRatio/nvm.maxRatio) * devMultiPlier);
            
        }
        else
        {
            frame = CGRectMake(frame.origin.x * nvm.wRatio/nvm.maxRatio, frame.origin.y * nvm.hRatio/nvm.maxRatio, frame.size.width * nvm.wRatio/nvm.maxRatio, frame.size.height* nvm.hRatio/nvm.maxRatio);
        }
#else
        NSLog(@"dev multiplier %f",DEV_MULTIPLIER);
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
       
    }
     return self;
}

- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor*)clr
{
    self = [super init];
    if (self)
    {
        Settings *nvm = [Settings Instance];
        self.noTouchMode = NO;
        self.videoVolume = 1.0; // Default full volume
#if 0        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
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
        NSLog(@"FRAME x %f y %f  w %f  h %f",frame.origin.x,frame.origin.y,frame.size.width, frame.size.height);
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

        // Set dark background color for empty frames (app-consistent theme)
        UIColor *darkBackgroundColor = [UIColor colorWithRed:0.19 green:0.21 blue:0.25 alpha:1.0];
        self.view.backgroundColor = darkBackgroundColor;

        //self.view.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];

        self.view.scrollView.scrollEnabled = YES;
        self.view.scrollView.showsVerticalScrollIndicator = NO;
        self.view.scrollView.showsHorizontalScrollIndicator = NO;
        self.view.scrollView.backgroundColor = darkBackgroundColor;
        self.view.scrollView.layer.masksToBounds=YES;
        
        // Allocate image view 
        //imgView   = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.view.imageView.contentMode = UIViewContentModeScaleToFill;
        self.view.imageView.backgroundColor = clr;
        //checking for frames color
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
        CGFloat initialZoom = self.view.frame.size.width / self.view.imageView.frame.size.width;
        self.view.scrollView.minimumZoomScale = self.view.frame.size.width / self.view.imageView.frame.size.width;
        //NSLog(@"initWithFrame %d content size %f,%f-------------",iPhotoNumber,frame.size.width,frame.size.height);
        [self.view.scrollView setZoomScale:initialZoom];
        self.view.scrollView.delegate = self;
        
        //[imgView release];
        
        self.view.multipleTouchEnabled = NO;
        self.view.exclusiveTouch = YES;
        self.view.imageView.multipleTouchEnabled = NO;
        self.view.imageView.exclusiveTouch = YES;

        // Add "add" icon for empty slots
        UIImage *addImage = [UIImage imageNamed:@"add"];
        self.addIconView = [[UIImageView alloc] initWithImage:addImage];
        CGFloat iconSize = MIN(frame.size.width, frame.size.height) * 0.3;
        self.addIconView.frame = CGRectMake((frame.size.width - iconSize) / 2,
                                            (frame.size.height - iconSize) / 2,
                                            iconSize, iconSize);
        self.addIconView.contentMode = UIViewContentModeScaleAspectFit;
        self.addIconView.userInteractionEnabled = NO;
        [self.view addSubview:self.addIconView];

        self.isSelected = NO;
    }
    return self;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return self.view.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerContent];
}

- (void)centerContent {
    CGSize boundsSize = self.view.scrollView.bounds.size;
    CGSize contentSize = self.view.scrollView.contentSize;
    
    // Calculate offsets to center
    CGFloat offsetX = (boundsSize.width > contentSize.width) ?
        (boundsSize.width - contentSize.width) * 0.5 : 0;
    CGFloat offsetY = (boundsSize.height > contentSize.height) ?
        (boundsSize.height - contentSize.height) * 0.5 : 0;
    
    // Apply centering
    self.view.imageView.center = CGPointMake(
        contentSize.width * 0.5 + offsetX,
        contentSize.height * 0.5 + offsetY
    );
}


-(void)setTheImageToBlank
{
    self.view.imageView.image = nil;
    //_image = nil;
    self._internalImage = nil;
    self.view.imageView.redirectView = nil;

    // Show add icon for empty slot
    self.addIconView.hidden = NO;
}

-(UIImage*)image
{
    //return _image;
    return self._internalImage;
}

-(void)singleTapDetected:(UITouch *)loc
{
    // Photo Selection Mode - for Replace/Adjust/Delete flow
    if (self.photoSelectionMode) {
        NSLog(@"Photo selection mode - slot tapped: %d", iPhotoNumber);
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iPhotoNumber],@"photoIndex", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"photoSlotSelected"
                                                            object:self
                                                          userInfo:dict];
        return;
    }

    if (self.effectTouchMode) {
        NSLog(@" 2222  effect selected mode");
        if (nil!= self.view.imageView.image) {

            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:iPhotoNumber],@"photoNumber", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:selectImageForApplyingEffect
                                                                object:self
                                                              userInfo:dict];
        }else
        {
            self.view.scrollView.layer.borderWidth = 0.0;

        }
        return;
    }

    if(self.noTouchMode)
    {
        return;
    }
   
    CGPoint p = [loc locationInView:self.view.imageView];
    NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],self.view.imageView, self.view, nil];
    /// To maintain same view size for slect photo options menu
//    NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithFloat:p.x],[NSNumber numberWithFloat:p.y],self.view, self.view, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"x_location",@"y_location",@"view",@"scrollview", nil];
    NSDictionary *location = [NSDictionary dictionaryWithObjects:coordinates forKeys:keys];
    
    if(nil == self.view.imageView.image)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:selectImageForPhoto
                         object:self userInfo:location];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:editImageForPhoto
                object:self  userInfo:location];
    }
}

-(void)setImage:(UIImage *)image
{
    NSLog(@"set image is called ");
    if(nil == image)
    {
        [self setTheImageToBlank];
        //checking frames color

        return;
    }

    // Hide add icon when image is set
    self.addIconView.hidden = YES;

    self.view.imageView.redirectView = nil;
    self.view.imageView.transform = CGAffineTransformIdentity;
    //_image = image;
    self._internalImage = image;
    imgSize = image.size;
    NSLog(@"photo img size is %@",NSStringFromCGSize(imgSize));
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
    NSLog(@"width ratio %f height ratio %f",widthRatio,heightRatio);
    NSLog(@"photo frame size %@",NSStringFromCGSize(self.view.frame.size));
    NSLog(@"image size %@",NSStringFromCGSize(image.size));
    CGFloat initialZoom = (widthRatio > heightRatio) ? widthRatio : heightRatio;
    NSLog(@"Set init zoom scale initialZoom 111111 %f",initialZoom);
    [self.view.scrollView setMinimumZoomScale:initialZoom];
    self.view.scrollView.maximumZoomScale = initialZoom+1;
    [self.view.scrollView setZoomScale:initialZoom];
    self.view.scrollView.scrollEnabled = YES;              // Enable scrolling
    self.view.scrollView.bounces = YES;                   // Allow bouncing at edges
    self.view.scrollView.bouncesZoom = YES;               // Allow bouncing while zooming
    self.view.scrollView.alwaysBounceHorizontal = YES;    // Enable horizontal panning
    self.view.scrollView.alwaysBounceVertical = YES;      // Enable vertical panning
    self.view.scrollView.clipsToBounds = YES;             // Prevent content overflow
    self.scale = initialZoom;
    // Center the image
    [self centerContent];
   // NSLog(@"isContentTypeVideo %@  video url is %@",isContentTypeVideo?@"Yes":@"NO",_videoURL);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"videoURL = %@", self.videoURL);
        NSLog(@"videoURL class = %@", NSStringFromClass([self.videoURL class]));
    
    if(isContentTypeVideo)
    {
        self.view.isvideoMute = self.muteAudio;
        self.view.videoURL = self.videoURL;
    }
    else
    {
        //[self.view stop];
    }
        self.view.isProgrammaticPlaybackChange = NO;
    });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitNOTouchMode"
                                                       object:self];
    //[[NSNotificationCenter defaultCenter] postNotificationName:scaleAndOffsetChanged
    //                                                    object:self];
    return;
}

-(void)setEditedImage:(UIImage *)image
{
    if(nil == image)
    {
        [self setTheImageToBlank];
        //checking frames color
        
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
-(int)viewNumber
{
    return viewNumber;
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
    NSLog(@"photo frame width %f, height %f",frame.size.width,frame.size.height);
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
    NSLog(@"Set init zoom scale 222222");
    [self.view setMinimumZoomScale:initialZoom];
    self.view.maximumZoomScale = initialZoom+1;
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
    NSLog(@"Set init zoom scale 333333");
    [self.view.scrollView setMinimumZoomScale:initialZoom]; // to allow zooming out - to make content visible full imside the frame
    self.view.scrollView.maximumZoomScale = initialZoom+1;
    self.view.scrollView.backgroundColor = [UIColor whiteColor];
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
    //[self.view removeFromSuperview];
}

#pragma mark - Video Adjustment Methods

-(void)applyVideoSpeed:(float)speed
{
    NSLog(@"Applying video speed: %.2fx", speed);

    self.videoSpeed = speed;

    // Apply speed to the video player if available
    if (self.view && self.view.player && self.isContentTypeVideo) {
        // Set the playback rate
        self.view.player.rate = speed;

        // If the player is playing, the rate change will apply immediately
        // If paused, the rate will apply when play is called
        NSLog(@"Video speed applied to player");
    } else {
        NSLog(@"No video player available to apply speed");
    }
}

-(void)applyVideoTrimWithStart:(double)startTime end:(double)endTime
{
    NSLog(@"Applying video trim: %.2f to %.2f", startTime, endTime);

    self.videoTrimStart = startTime;
    self.videoTrimEnd = endTime;

    // Apply trim to the video player if available
    if (self.view && self.view.player && self.isContentTypeVideo) {
        AVPlayerItem *playerItem = self.view.player.currentItem;

        if (playerItem) {
            // Create CMTime values for start and end
            CMTime start = CMTimeMakeWithSeconds(startTime, NSEC_PER_SEC);
            CMTime end = CMTimeMakeWithSeconds(endTime, NSEC_PER_SEC);

            // Create a time range
            CMTimeRange timeRange = CMTimeRangeMake(start, CMTimeSubtract(end, start));

            // Seek to start time
            [self.view.player seekToTime:start toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];

            // Add boundary time observer to loop between start and end
            __weak typeof(self) weakSelf = self;
            id timeObserver = [self.view.player addBoundaryTimeObserverForTimes:@[[NSValue valueWithCMTime:end]]
                                                                          queue:dispatch_get_main_queue()
                                                                     usingBlock:^{
                // When reaching end time, seek back to start
                [weakSelf.view.player seekToTime:start toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
            }];

            // Store the observer to remove it later if needed
            // Note: In a production app, you'd want to manage and remove this observer properly

            NSLog(@"Video trim applied: %@ to %@",
                  [NSString stringWithFormat:@"%.2f", startTime],
                  [NSString stringWithFormat:@"%.2f", endTime]);
        } else {
            NSLog(@"No player item available to apply trim");
        }
    } else {
        NSLog(@"No video player available to apply trim");
    }
}

// MARK: - Production-Grade State Management

-(void)deleteContent
{
    NSLog(@"Deleting content from frame");

    // Stop and remove video player if exists
    if (self.isContentTypeVideo) {
        [self.view stopPlayer];
        [self.view removePlayer];
    }

    // Clear image
    self.image = nil;
    self.view.imageView.image = nil;
    self._internalImage = nil;

    // Reset video properties
    self.videoURL = nil;
    self.videoTrimStart = 0.0;
    self.videoTrimEnd = 0.0;
    self.videoSpeed = 1.0;
    self.videoVolume = 1.0;
    self.muteAudio = NO;
    self.isContentTypeVideo = NO;

    // Reset to empty state with dark background
    UIColor *darkBackgroundColor = [UIColor colorWithRed:0.19 green:0.21 blue:0.25 alpha:1.0];
    self.view.backgroundColor = darkBackgroundColor;
    self.view.scrollView.backgroundColor = darkBackgroundColor;

    // Show add icon if available
    if (self.addIconView) {
        self.addIconView.hidden = NO;
    }

    NSLog(@"Content deleted successfully");
}

-(void)replaceWithVideo:(NSURL *)newVideoURL
{
    NSLog(@"Replacing content with new video: %@", newVideoURL);

    // Clean up existing content
    [self deleteContent];

    // Set new video
    self.videoURL = newVideoURL;
    self.isContentTypeVideo = YES;

    // Reset trim to full duration (will be set when video loads)
    self.videoTrimStart = 0.0;
    self.videoTrimEnd = 0.0;

    // Setup new video player
    [self.view setupVideoPlayer];

    // Hide add icon
    if (self.addIconView) {
        self.addIconView.hidden = YES;
    }

    NSLog(@"Video replacement complete");
}

-(void)replaceWithImage:(UIImage *)newImage
{
    NSLog(@"Replacing content with new image");

    // Clean up existing content
    [self deleteContent];

    // Set new image
    self.image = newImage;
    self._internalImage = newImage;
    self.view.imageView.image = newImage;
    self.isContentTypeVideo = NO;

    // Hide add icon
    if (self.addIconView) {
        self.addIconView.hidden = YES;
    }

    NSLog(@"Image replacement complete");
}

-(void)dealloc
{
   // [_internalImage release];
    NSLog(@"[Photo dealloc] is being deallocated (no debugID)");
    [view removePlayer];  // Only if the property is 'retain' or 'strong'
    [view release];
//    // Remove gesture recognizers
//    [self.view.imageView removeGestureRecognizer:singleTap];
//    [self.view.imageView removeGestureRecognizer:doubleTap];
//    [self.view.imageView removeGestureRecognizer:longPress];

    // Release other ivars
    [tapTimer release];
    [singleTap release];
    [doubleTap release];
    [longPress release];

    [super dealloc];
}

- (void)exitPhotoSelectionMode
{
    NSLog(@"[Photo] exitPhotoSelectionMode for index %d", self.photoNumber);
    if (self.view.curShape == SHAPE_NOSHAPE) {
        self.view.scrollView.layer.borderWidth = 0.0;
    } else {
        [self.view removeBorder];
    }
    self.isSelected = NO;
    self.photoSelectionMode = NO;
}

- (void)enterPhotoSelectionMode:(int)targetIndex
{
    NSLog(@"[Photo] enterPhotoSelectionMode for index %d", self.photoNumber);
    
    UIColor *greenColor = [UIColor colorWithRed:184/255.0 green:234/255.0 blue:112/255.0 alpha:1.0];
    if (self.view.curShape == SHAPE_NOSHAPE) {
        self.view.scrollView.layer.borderColor = greenColor.CGColor;
        self.view.scrollView.layer.borderWidth = 5.0;
    } else {
        [self.view setBorderStyle:greenColor lineWidth:5.0f dashPattern:nil];
    }
    self.isSelected = YES;
    self.photoSelectionMode = YES;
}

@end
