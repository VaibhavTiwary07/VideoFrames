//
//  Frame.m
//  PicFrames
//
//  Created by Sunitha Gadigota on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Frame.h"
#import "Config.h"
@interface Frame ()
{
    /* Swap Mode Resources */
    BOOL bSwapMode;
    Photo *swapFrom;
    Photo *swapTo;
    UIImageView *fromSwapView;
    UIImageView *toSwapView;
    UITextView *infoTextView;
    /* Aspect Ratio Resources */
    eAspectRatio eRatio;
    NSTimer *swapTimer;
    
    NSMutableArray *photos1;
    UIView *view1;
    
    }

@end

@implementation Frame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

int intcmp(const void *aa, const void *bb)
{
    const int *a = aa, *b = bb;
    return (*a < *b) ? -1 : (*a > *b);
}


- (CGPoint)getRowAndColomCountForPhoto:(int)index
{
    CGPoint point = CGPointZero;
    int     photoCount = (int)[photos count];
    int     idx = 0;
    int     rowCount = 0;
    int     colCount = 0;
    int     bufXArrayIndex = 0;
    float   bufXArray[photoCount];
    int     bufYArrayIndex = 0;
    float   bufYArray[photoCount];
    
    Photo *p = [photos objectAtIndex:index];
    if(nil == p)
    {
        return point;
    }
    
    float a = p.frame.origin.x;
    float b = p.frame.origin.y;
    float x = 0.0;
    float y = 0.0;
    for(idx = 0; idx < photoCount; idx++)
    {
        Photo *ph = [photos objectAtIndex:idx];
        x = ph.frame.origin.x;
        y = ph.frame.origin.y;
        
        if(index == idx)
        {
            qsort(bufXArray, bufXArrayIndex, sizeof(float), intcmp);
            qsort(bufYArray, bufYArrayIndex, sizeof(float), intcmp);
            
            int i = 0;
            for(i = 0; i < bufXArrayIndex; i++)
            {
                if(bufXArray[i] >= y)
                {
                    break;
                }
            }
            
            p.rowIndex = i;
            
            for(i = 0; i < bufYArrayIndex; i++)
            {
                if(bufYArray[i] >= x)
                {
                    break;
                }
            }
            
            p.colIndex = i;
            
            rowCount = rowCount + 1;
            colCount = colCount + 1;
            continue;
        }
        
        if(x == a)
        {
            if(0 == bufXArrayIndex)
            {
                bufXArray[bufXArrayIndex++] = y;
                rowCount = rowCount+1;
            }
            else
            {
                int i = 0;
                BOOL bFound = NO;
                for(i = 0; i < bufXArrayIndex;i++)
                {
                    if(y == bufXArray[i])
                    {
                        bFound = YES;
                        break;
                    }
                }
                
                if(NO == bFound)
                {
                    bufXArray[bufXArrayIndex++] = y;
                    rowCount = rowCount+1;
                }
            }
        }
        else if(y != b) /*if((a < x) & (x < (a + w)))*/
        {
            CGRect rect1 = p.frame;
            CGRect rect2 = ph.frame;
            
            rect1.origin.y = rect2.origin.y;
            if(CGRectIntersectsRect(rect1, rect2))
            {
                if(0 == bufXArrayIndex)
                {
                    bufXArray[bufXArrayIndex++] = y;
                    rowCount = rowCount+1;
                }
                else
                {
                    int i = 0;
                    BOOL bFound = NO;
                    for(i = 0; i < bufXArrayIndex;i++)
                    {
                        if(y == bufXArray[i])
                        {
                            bFound = YES;
                            break;
                        }
                    }
                    
                    if(NO == bFound)
                    {
                        bufXArray[bufXArrayIndex++] = y;
                        rowCount = rowCount+1;
                    }
                }
            }
        }
        
        if(y == b)
        {
            if(0 == bufYArrayIndex)
            {
                bufYArray[bufYArrayIndex++] = x;
                colCount = colCount+1;
            }
            else
            {
                int i = 0;
                BOOL bFound = NO;
                for(i = 0; i < bufYArrayIndex;i++)
                {
                    if(x == bufYArray[i])
                    {
                        bFound = YES;
                        break;
                    }
                }
                
                if(NO == bFound)
                {
                    bufYArray[bufYArrayIndex++] = x;
                    colCount = colCount+1;
                }
            }
        }
        else if(x != a)/*if((b < y)&&(y < (b + h)))*/
        {
            CGRect rect1 = p.frame;
            CGRect rect2 = ph.frame;
            
            rect1.origin.x = rect2.origin.x;
            if(CGRectIntersectsRect(rect1, rect2))
            {
                if(0 == bufYArrayIndex)
                {
                    bufYArray[bufYArrayIndex++] = x;
                    colCount = colCount+1;
                }
                else
                {
                    int i = 0;
                    BOOL bFound = NO;
                    for(i = 0; i < bufYArrayIndex;i++)
                    {
                        if(x == bufYArray[i])
                        {
                            bFound = YES;
                            break;
                        }
                    }
                    
                    if(NO == bFound)
                    {
                        bufYArray[bufYArrayIndex++] = x;
                        colCount = colCount+1;
                    }
                }
            }
        }
    }
    
    p.rowCount = rowCount;
    p.colCount = colCount;
    
    return point;
}

- (CGPoint)getRowAndColomCountForAdjustor:(int)index
{
    CGPoint point = CGPointZero;
    int     photoCount = (int)[adjustors count];
    int     idx = 0;
    int     rowCount = 0;
    int     colCount = 0;
    int     bufXArrayIndex = 0;
    float   bufXArray[photoCount];
    int     bufYArrayIndex = 0;
    float   bufYArray[photoCount];
    
    Adjustor *p = [adjustors objectAtIndex:index];
    if(nil == p)
    {
        return point;
    }
    
    float a = p.frame.origin.x;
    float b = p.frame.origin.y;
    float x = 0.0;
    float y = 0.0;
    for(idx = 0; idx < photoCount; idx++)
    {
        Adjustor *ph = [adjustors objectAtIndex:idx];
        x = ph.frame.origin.x;
        y = ph.frame.origin.y;
        
        if(index == idx)
        {
            qsort(bufXArray, bufXArrayIndex, sizeof(float), intcmp);
            qsort(bufYArray, bufYArrayIndex, sizeof(float), intcmp);
            
            int i = 0;
            for(i = 0; i < bufXArrayIndex; i++)
            {
                if(bufXArray[i] >= y)
                {
                    break;
                }
            }
            
            p.rowIndex = i;
            
            for(i = 0; i < bufYArrayIndex; i++)
            {
                if(bufYArray[i] >= x)
                {
                    break;
                }
            }
            
            p.colIndex = i;
            
            rowCount = rowCount + 1;
            colCount = colCount + 1;
            continue;
        }
        
        if(x == a)
        {
            if(0 == bufXArrayIndex)
            {
                bufXArray[bufXArrayIndex++] = y;
                rowCount = rowCount+1;
            }
            else
            {
                int i = 0;
                BOOL bFound = NO;
                for(i = 0; i < bufXArrayIndex;i++)
                {
                    if(y == bufXArray[i])
                    {
                        bFound = YES;
                        break;
                    }
                }
                
                if(NO == bFound)
                {
                    bufXArray[bufXArrayIndex++] = y;
                    rowCount = rowCount+1;
                }
            }
        }
        else if(y != b) /*if((a < x) & (x < (a + w)))*/
        {
            CGRect rect1 = p.frame;
            CGRect rect2 = ph.frame;
            
            rect1.origin.y = rect2.origin.y;
            if(CGRectIntersectsRect(rect1, rect2))
            {
                if(0 == bufXArrayIndex)
                {
                    bufXArray[bufXArrayIndex++] = y;
                    rowCount = rowCount+1;
                }
                else
                {
                    int i = 0;
                    BOOL bFound = NO;
                    for(i = 0; i < bufXArrayIndex;i++)
                    {
                        if(y == bufXArray[i])
                        {
                            bFound = YES;
                            break;
                        }
                    }
                    
                    if(NO == bFound)
                    {
                        bufXArray[bufXArrayIndex++] = y;
                        rowCount = rowCount+1;
                    }
                }
            }
        }
        
        if(y == b)
        {
            if(0 == bufYArrayIndex)
            {
                bufYArray[bufYArrayIndex++] = x;
                colCount = colCount+1;
            }
            else
            {
                int i = 0;
                BOOL bFound = NO;
                for(i = 0; i < bufYArrayIndex;i++)
                {
                    if(x == bufYArray[i])
                    {
                        bFound = YES;
                        break;
                    }
                }
                
                if(NO == bFound)
                {
                    bufYArray[bufYArrayIndex++] = x;
                    colCount = colCount+1;
                }
            }
        }
        else if(x != a)/*if((b < y)&&(y < (b + h)))*/
        {
            CGRect rect1 = p.frame;
            CGRect rect2 = ph.frame;
            
            rect1.origin.x = rect2.origin.x;
            if(CGRectIntersectsRect(rect1, rect2))
            {
                if(0 == bufYArrayIndex)
                {
                    bufYArray[bufYArrayIndex++] = x;
                    colCount = colCount+1;
                }
                else
                {
                    int i = 0;
                    BOOL bFound = NO;
                    for(i = 0; i < bufYArrayIndex;i++)
                    {
                        if(x == bufYArray[i])
                        {
                            bFound = YES;
                            break;
                        }
                    }
                    
                    if(NO == bFound)
                    {
                        bufYArray[bufYArrayIndex++] = x;
                        colCount = colCount+1;
                    }
                }
            }
        }
    }
    
    p.rowCount = rowCount;
    p.colCount = colCount;
    
    
    return point;
}

- (void)generateCountsAndIndexsForAllPhotos
{
    int idx = 0;
    for(idx = 0; idx < [photos count]; idx++)
    {
        [self getRowAndColomCountForPhoto:idx];
    }
    
    return;
}

- (void)generateCountsAndIndexsForAllAdjustors
{
    int idx = 0;
    for(idx = 0; idx < [adjustors count]; idx++)
    {
        [self getRowAndColomCountForAdjustor:idx];
    }
    
    return;
}

- (int)adjustorCount
{
    if(nil == adjustors)
    {
        return 0;
    }
    
    return (int)[adjustors count];
}

- (int)photoCount
{
    if(nil == photos)
    {
        return 0;
    }
    
    return (int)[photos count];
}

- (Photo*)getPhotoAtIndex:(int)index
{
    //NSLog(@"photos count %lu ",photos.count);
    return [photos objectAtIndex:index]; //[photos objectAtIndex:(index < photos.count)?index:0];
}

-(Adjustor*)getAdjustorAtIndex:(int)index
{
    return [adjustors objectAtIndex:index];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

/*
 Frame Table contains entries for building the complete frame
 
 FrameNumber - Integer
 x           - float/int
 y           - float/int
 width       - float/int
 height      - float/int
 type        - int - specifies whether it is adjustor or photo
 shape       - int/ePhotoShape
 row         - int (optional)
 index       - int (optional)
 
 */
/*
 -(CGSize)aspectRatioToSize:(eAspectRatio)ratio
 {
 switch(ratio)
 {
 
 }
 }*/

+ (CGRect)getTheFrameSize
{
    //CGRect defaultFrameSize = CGRectMake(10.0, 90.0, 300.0, 300.0);
    Settings *nvm = [Settings Instance];
    CGRect defaultFrameSize;
//    CGRect fullscreen = [[UIScreen mainScreen]bounds];
    float size;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        size= 700.0;
    else if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height != 568.0))
    {
        size = fullScreen.size.width - 40;
    }
    else size = 300.0;

    //float sizeX = fullScreen.size.width * 0.05f;
   // float sizeY = fullScreen.size.height * 0.1f;
    //float width = fullScreen.size.width - (sizeX*2);
    float y = (fullScreen.size.height - size)/2.0;
    float x = (fullScreen.size.width - size)/2.0;//size
    
    defaultFrameSize = CGRectMake(x, y, size, size);
#if 0
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        defaultFrameSize = CGRectMake(34.0, y, width, 700.0);
    }
    else
    {
        defaultFrameSize = CGRectMake(10.0, y, width, 300.0);
    }
#endif
    CGRect rect = defaultFrameSize;
    NSLog(@"before frame === x %f, y %f, width %f , height %f",rect.origin.x , rect.origin.y, rect.size.width,rect.size.height);
    rect.origin.x = rect.origin.x + (rect.size.width - (rect.size.width * nvm.wRatio / nvm.maxRatio))/2.0f;
    rect.origin.y = rect.origin.y + (rect.size.height - (rect.size.height * nvm.hRatio / nvm.maxRatio))/2.0f;//-10;
    rect.size.width = rect.size.width * nvm.wRatio / nvm.maxRatio;
    rect.size.height = rect.size.height * nvm.hRatio / nvm.maxRatio;
    NSLog(@"frame === x %f, y %f, width %f , height %f nvm.wRatio %f , nvm.hRatio %f,nvm.maxRatio %f ",rect.origin.x , rect.origin.y, rect.size.width,rect.size.height,nvm.wRatio,nvm.hRatio,nvm.maxRatio);
    return rect;
}

- (void)addPhotosAndAdjustorsToFrame:(int)frameNumber withBgColor:(UIColor*)clr
{
    int iRowCount = 0;
    int iIndex    = 0;
    CGFloat dbWidth =  300;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        dbWidth= 700.0;
    else dbWidth = 300.0;
    
    stPhotoInfo *PhotoInfo = NULL;
       


    /* First enable the touches */
    self.userInteractionEnabled = YES;
    
    /* Set the background color to default color */
    self.backgroundColor = [UIColor whiteColor];
   // self.backgroundColor = [UIColor greenColor];
//checking for frames color
    
    /* Call database function to get the photoinfos of the frame */
    iRowCount = [FrameDB getThePhotoInfoForFrameNumber:frameNumber to:&PhotoInfo];
    
    photos = [[NSMutableArray alloc]initWithCapacity:iRowCount];
    //NSLog(@"Frame %d> Photo Count %d",frameNumber,iRowCount);
    /* Add the photos */
    for(iIndex = 0; iIndex < iRowCount; iIndex++)
    {
        /* Get the  */
        view1=[[UIView alloc]init];
        NSLog(@"index i is %d photo info is %@ screen height %f",iIndex,NSStringFromCGRect(PhotoInfo[iIndex].dimension),fullScreen.size.height);
        //Note Changes : To adjust the iphone frame size is screen size
        if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height != 568.0))
        {
            //dbWidth = PhotoInfo[iIndex].dimension.size.width;
            CGFloat actaulWidth = fullScreen.size.width - 40;
            CGFloat ratio = actaulWidth / dbWidth;
            PhotoInfo[iIndex].dimension.size.width *= ratio;
            PhotoInfo[iIndex].dimension.size.height *= ratio;
            PhotoInfo[iIndex].dimension.origin.x *= ratio;
            PhotoInfo[iIndex].dimension.origin.y *= ratio;
            
            NSLog(@"index i is %d photo info is %@ ",iIndex,NSStringFromCGRect(PhotoInfo[iIndex].dimension));
        }
        Photo *photo = [[Photo alloc]initWithFrame:PhotoInfo[iIndex].dimension withBgColor:clr];
               // photo.image = [UIImage imageNamed:@"photo.JPG"];
       // photo.image = [UIImage imageNamed:@"filled_image.jpg"];
        photo.view.backgroundColor = clr;
        
        //photo.view.layer.backgroundColor=[UIColor whiteColor].CGColor;
       
        //checking for frames color
        
        /* Set the Photo Number */
        photo.photoNumber = iIndex;
        
        /* Set the tag number also as the index */
        photo.view.tag = iIndex;
        
        /* Add photo as subview */
       
         [self addSubview:view1];
         [self addSubview:photo.view];
        
//        [photo.view release];
//        [view1 release];
        
        
        
        if(SHAPE_NOSHAPE != PhotoInfo[iIndex].eFrameShape)
        {
            [photo.view setShape:PhotoInfo[iIndex].eFrameShape];
        }
        
        /* Add the photo to the photo array */
        [photos insertObject:photo atIndex:iIndex];
        
        /* Release photo */
      //  [photo release];
    }
    
    /* Free the memory for Photo Info */
    free(PhotoInfo);
    
    /* Now initialize the adjustors */
    stAdjustorInfo *AdjustorInfo = NULL;
    
    iRowCount = [FrameDB getTheAdjustorInfoForFrameNumber:frameNumber to:&AdjustorInfo];
    
    adjustors = [[NSMutableArray alloc]initWithCapacity:iRowCount];
    
    /* Add the Adjustors */
    for(iIndex = 0; iIndex < iRowCount; iIndex++)
    {
        NSLog(@"before index i is %d Adjustor Info is %@ ",iIndex,NSStringFromCGRect(AdjustorInfo[iIndex].dimension));
        //Note Changes : To adjust the iphone frame size is screen size
        if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && (fullScreen.size.height != 568.0))
        {
            //Note Changes : To adjust the iphone frame size is screen size
            //CGFloat dbWidth = AdjustorInfo[iIndex].dimension.size.width;
            CGFloat actaulWidth = fullScreen.size.width - 40;
            CGFloat ratio = actaulWidth / dbWidth;
            NSLog(@"ratio =  %f, actaulWidth = %f , dbWidth = %f",ratio,actaulWidth,dbWidth);
            AdjustorInfo[iIndex].dimension.size.width *= ratio;
            AdjustorInfo[iIndex].dimension.size.height *= ratio;
            AdjustorInfo[iIndex].dimension.origin.x *= ratio;
            AdjustorInfo[iIndex].dimension.origin.y *= ratio;
            
            NSLog(@"after index i is %d Adjustor Info is %@ ",iIndex,NSStringFromCGRect(AdjustorInfo[iIndex].dimension));
        }
        
        Adjustor *adjustor = [[Adjustor alloc]initWithFrame:AdjustorInfo[iIndex].dimension photos:photos];
        [self addSubview:view1];
        [self addSubview:adjustor];
        
        /* Decrement the reference count for the adjustor object */
    //    [adjustor release];
        
        /* Add the adjustor to the array */
        [adjustors insertObject:adjustor atIndex:iIndex];
    }
    
    /* Now set the adjustors array to the adjustors */
    for(iIndex = 0; iIndex < [adjustors count]; iIndex++)
    {
        Adjustor *Adj = [adjustors objectAtIndex:iIndex];
        
        Adj.adjustors = adjustors;
    }
    
    free(AdjustorInfo);
    
    /* Now set the shadow for the frame */
    self.layer.masksToBounds = YES;
#if 0
    self.layer.cornerRadius = 0; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(5, 5);
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = 0.8;
#endif
    [self generateCountsAndIndexsForAllPhotos];
    [self generateCountsAndIndexsForAllAdjustors];
    
   
}

- (void)initClassVariables
{
    bSwapMode = NO;
    photos    = nil;
    adjustors = nil;
    swapFrom = nil;
    swapTo = nil;
}

- (id)initWithFrameNumber:(int)frameNumber
{
    self = [super initWithFrame:[Frame getTheFrameSize]];
    NSLog(@"Frame numer is %d",frameNumber);
    if(self)
    {
       // [self addPhotosAndAdjustorsToFrame:frameNumber withBgColor:PHOTO_DEFAULT_COLOR];
        [self addPhotosAndAdjustorsToFrame:frameNumber withBgColor:[UIColor colorWithRed:99.0/255.0 green:104.0/255.0 blue:117.0/255.0 alpha:1.0]];
       
        if([userDefaultForLimitSave integerForKey:@"PhotoLibraryPermission"] == 0) // new User
        {
            NSLog(@"Adding info textview for new users");
            [self addTextview];
        }
        else
        {
            NSLog(@"Do not add info textview for already existing user");
            // Do not show Info textview
            [userDefaultForLimitSave setInteger:1 forKey:@"ShowFrameInfoText"]; // already existing user
        }
    }
    
    return self;
}

-(void)addTextview
{
    NSLog(@"Frame info text get value is %ld ",[userDefaultForLimitSave integerForKey:@"ShowFrameInfoText"]);
    if([userDefaultForLimitSave integerForKey:@"ShowFrameInfoText"] == 0 )
    {
        [userDefaultForLimitSave setInteger:1 forKey:@"ShowFrameInfoText"];
        CGRect frameSize = [Frame getTheFrameSize];
        // Step 1: Initialize the UITextView
        infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, ( frameSize.size.height)/2, frameSize.size.width*0.75, 60)];
        NSLog(@"set text view w %f h %f x %f y %f ",frameSize.size.width,frameSize.size.height,frameSize.origin.x,frameSize.origin.y);
        infoTextView.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:51.0/255.0 blue:58.0/255.0 alpha:1.0];//[UIColor clearColor]; // Set background color
        infoTextView.textColor = [UIColor lightGrayColor]; // Set text color
        infoTextView.font = [UIFont boldSystemFontOfSize:16.0]; // Set font
        infoTextView.text = @"Tap anywhere on the grid\n to add photos or videos"; // Set initial text
        infoTextView.textAlignment = NSTextAlignmentCenter; // Align text
        infoTextView.translatesAutoresizingMaskIntoConstraints = NO; // Enable Auto Layout
        infoTextView.userInteractionEnabled = NO;
        infoTextView.layer.cornerRadius = 10;
        [self addSubview:infoTextView];
        
        // Step 3: Center the UITextView using Auto Layout
        [NSLayoutConstraint activateConstraints:@[
            [infoTextView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [infoTextView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [infoTextView.widthAnchor constraintEqualToConstant:frameSize.size.width*0.75],  // Set a fixed width
            [infoTextView.heightAnchor constraintEqualToConstant:60]  // Set a fixed height
        ]];
        [self bringSubviewToFront:infoTextView];
    }
    else
    {
        NSLog(@"Shown frame info text once already ");
    }
}

-(void)hideInfoTextView
{
    if(infoTextView != nil)
        [infoTextView removeFromSuperview];
    NSLog(@"Hide info textview");
}

- (id)initWithFrameNumber:(int)frameNumber withBgColor:(UIColor *)clr
{
    self = [super initWithFrame:[Frame getTheFrameSize]];
    if(self)
    {
        [self addPhotosAndAdjustorsToFrame:frameNumber withBgColor:clr];
    }
    
    return self;
}

- (id)initWithFrameNumber:(int)frameNumber andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addPhotosAndAdjustorsToFrame:frameNumber withBgColor:[UIColor grayColor]];
        //checking for frames color grayColor
    }
    
    return self;
}

- (void)enterSwapMode
{
    int index = 0;
    
    bSwapMode = YES;
    
    for(index = 0; index < [photos count]; index++)
    {
        Photo *pht = [photos objectAtIndex:index];
        if(nil == pht)
        {
            continue;
        }
        
        pht.view.userInteractionEnabled = NO;
        
    }
    
    self.userInteractionEnabled = YES;
}

- (void)exitSwapMode
{
    int index = 0;
    
    for(index = 0; index < [photos count]; index++)
    {
        Photo *pht = [photos objectAtIndex:index];
        if(nil == pht)
        {
            continue;
        }
        
        pht.view.userInteractionEnabled = YES;
    }
    
    bSwapMode = NO;
}

- (Photo*)touchToPhoto:(UITouch*)touch
{
    
    CGPoint pnt = [touch locationInView:self];
    int index = 0;
    Photo *pht = nil;
    
    for(index = 0; index < [photos count]; index++)
    {
        pht.view.userInteractionEnabled = YES;
        pht = [photos objectAtIndex:index];
        if(nil == pht)
        {
            continue;
        }
        
        if(CGRectContainsPoint(pht.frame, pnt))
        {
            break;
        }
        
        pht = nil;
    }
    return pht;
}

#ifdef ENABLE_SWAP_ANIMATION
- (void)swapDoneAnimationStoped:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    if(nil != fromSwapView)
    {
        [fromSwapView removeFromSuperview];
        fromSwapView = nil;
    }
    
    if(nil != toSwapView)
    {
        [toSwapView removeFromSuperview];
        toSwapView = nil;
    }
    
    /* swap the images */
    [swapTo notifyAsSwapTo];
    
    swapTo = nil;
    swapFrom = nil;
    bSwapMode = YES;
}

- (void)swapCancelAnimationStoped:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    if(nil != fromSwapView)
    {
        [fromSwapView removeFromSuperview];
        fromSwapView = nil;
    }
    
    bSwapMode = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:swapCancelled
                                                        object:nil];
    
    swapTo = nil;
    swapFrom = nil;
}

#endif

- (void)handleSwapTimer:(id)sender
{
    swapTimer = nil;
    NSLog(@"Swap timer expired");
    [self enterSwapMode];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"Redirect View: touchesBegan");
    if(NO == bSwapMode)
    {
        swapFrom = [self touchToPhoto:[touches anyObject]];
        swapTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(handleSwapTimer:) userInfo:nil repeats:NO];
        return;
    }
    
    swapFrom = [self touchToPhoto:[touches anyObject]];
    swapTo   = nil;
    
    if(nil != swapFrom)
    {
        if(swapFrom.image == nil)
        {
            swapFrom = nil;
            return;
        }
        
        [swapFrom notifyAsSwapFrom];
        
        if(nil != fromSwapView)
        {
          //  [fromSwapView release];
            fromSwapView = nil;
        }
        
        fromSwapView = [[UIImageView alloc]initWithFrame:swapFrom.frame];
        fromSwapView.contentMode = UIViewContentModeScaleAspectFit;
        fromSwapView.image = swapFrom.image;
        [swapFrom setTheImageToBlank];
        
        [self addSubview:fromSwapView];
      //  [fromSwapView release];
        
        UITouch *touch = [touches anyObject];
        CGPoint pnt = [touch locationInView:self];
        
//        [UIView beginAnimations:@"take swapfrom image out" context:NULL];
//        [UIView setAnimationDuration: 0.5f];
//        fromSwapView.frame = CGRectMake(pnt.x-50, pnt.y-50, 100, 100);
//        [UIView commitAnimations];
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            fromSwapView.frame = CGRectMake(pnt.x-50, pnt.y-50, 100, 100);
                         }
                         completion:nil];

    }
    
    NSLog(@"Touches began in frame");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(NO == bSwapMode)
    {
        swapFrom = [self touchToPhoto:[touches anyObject]];
        return;
    }
    
    if(nil == swapFrom)
    {
        return;
    }
    
    if(nil != fromSwapView)
    {
        UITouch *touch = [touches anyObject];
        fromSwapView.center = [touch locationInView:self];
    }
    
    Photo *tmp = [self touchToPhoto:[touches anyObject]];
    
    if(nil == tmp)
    {
        if(nil != swapTo)
        {
            swapTo.view.layer.borderColor = [UIColor clearColor].CGColor;
            swapTo.view.layer.borderWidth = 0.0;
            swapTo = nil;
        }
        
        return;
    }
    
    if(tmp.view.tag == swapFrom.view.tag)
    {
        if(nil != swapTo)
        {
            swapTo.view.layer.borderColor = [UIColor clearColor].CGColor;
            swapTo.view.layer.borderWidth = 0.0;
            swapTo = nil;
        }
        
        return;
    }
    
    if(nil != swapTo)
    {
        if(swapTo.view.tag == tmp.view.tag)
        {
            return;
        }
        
        swapTo.view.layer.borderColor = [UIColor clearColor].CGColor;
        swapTo.view.layer.borderWidth = 0.0;
        swapTo = nil;
    }
    
    swapTo = tmp;
    
    /* add the red border to the view */
    swapTo.view.layer.borderColor = [UIColor redColor].CGColor;
    swapTo.view.layer.borderWidth = 5.0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(NO == bSwapMode)
    {
        if(nil != swapTimer)
        {
            if([swapTimer isValid])
            {
                [swapTimer invalidate];
            }
            swapTimer = nil;
        }
        swapFrom = nil;
        swapTo = nil;
        return;
    }
    
    if(nil == swapFrom)
    {
        return;
    }
    
    if(nil != swapTo)
    {
        swapTo.view.layer.borderColor = [UIColor clearColor].CGColor;
        swapTo.view.layer.borderWidth = 0.0;
        swapTo = nil;
    }
    
#ifndef ENABLE_SWAP_ANIMATION
    if(nil != fromSwapView)
    {
        [fromSwapView removeFromSuperview];
        fromSwapView = nil;
    }
    
#else
    bSwapMode = NO;
//    [UIView beginAnimations:@"take swapfrom image out" context:NULL];
//    [UIView setAnimationDuration: 0.5f];
//    [UIView setAnimationDelegate:self];
    
//    [UIView setAnimationDidStopSelector:@selector(swapCancelAnimationStoped:finished:context:)];
//    fromSwapView.frame = swapFrom.frame;
//    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.5 delay:0
    options:UIViewAnimationOptionCurveEaseInOut
    animations:^{
        fromSwapView.frame = swapFrom.frame;
    }
    completion:^(BOOL finished) {
                         // Optional: Handle completion if needed
        if(nil != fromSwapView)
        {
            [fromSwapView removeFromSuperview];
            fromSwapView = nil;
        }
        
        bSwapMode = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:swapCancelled
                                                            object:nil];
        
        swapTo = nil;
        swapFrom = nil;
    }];

    
#endif
    NSLog(@"Touches canceled in frame");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(NO == bSwapMode)
    {
        if(nil != swapTimer)
        {
            if([swapTimer isValid])
            {
                [swapTimer invalidate];
            }
            swapTimer = nil;
        }
        swapTo = nil;
        swapFrom = nil;
        return;
    }
    
    if(nil == swapFrom)
    {
        return;
    }
#ifndef ENABLE_SWAP_ANIMATION
    if(nil != fromSwapView)
    {
        [fromSwapView removeFromSuperview];
        fromSwapView = nil;
    }
#endif
    if(nil == swapTo)
    {
#ifdef ENABLE_SWAP_ANIMATION
        bSwapMode = NO;
//        [UIView beginAnimations:@"take swapfrom image out" context:NULL];
//        [UIView setAnimationDuration: 0.5f];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(swapCancelAnimationStoped:finished:context:)];
//        fromSwapView.frame = swapFrom.frame;
//        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.5 delay:0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            fromSwapView.frame = swapFrom.frame;
        }
        completion:^(BOOL finished) {
                             // Optional: Handle completion if needed
            if(nil != fromSwapView)
            {
                [fromSwapView removeFromSuperview];
                fromSwapView = nil;
            }
            
            bSwapMode = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:swapCancelled
                                                                object:nil];
            
            swapTo = nil;
            swapFrom = nil;
        }];
#else
        /* set the image back to swapFrom */
        [[NSNotificationCenter defaultCenter] postNotificationName:swapCancelled
                                                            object:nil];
#endif
        return;
    }
    
    /* First Remove the border */
    swapTo.view.layer.borderColor = [UIColor clearColor].CGColor;
    swapTo.view.layer.borderWidth = 0.0;
#ifdef ENABLE_SWAP_ANIMATION
    if(swapTo.image != nil)
    {
        if(nil != toSwapView)
        {
            [toSwapView removeFromSuperview];
            toSwapView = nil;
        }
        
        toSwapView = [[UIImageView alloc]initWithFrame:CGRectMake(swapTo.view.center.x-50,swapTo.view.center.y-50,100,100)];
        toSwapView.contentMode = UIViewContentModeScaleAspectFit;
        toSwapView.image = swapTo.image;
        [swapTo setTheImageToBlank];
        
        [self addSubview:toSwapView];
        //[toSwapView release];
        
        bSwapMode = NO;
//        [UIView beginAnimations:@"swapdone animation" context:NULL];
//        [UIView setAnimationDuration: 0.5f];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(swapDoneAnimationStoped:finished:context:)];
//        fromSwapView.frame = swapTo.frame;
//        toSwapView.frame   = swapFrom.frame;
//        [UIView commitAnimations];
        
        [UIView animateWithDuration:0.5 delay:0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            fromSwapView.frame = swapTo.frame;
            toSwapView.frame   = swapFrom.frame;
        }
        completion:^(BOOL finished) {
         // Optional: Handle completion if needed
            if(nil != fromSwapView)
            {
                [fromSwapView removeFromSuperview];
                fromSwapView = nil;
            }
            
            if(nil != toSwapView)
            {
                [toSwapView removeFromSuperview];
                toSwapView = nil;
            }
            
            /* swap the images */
            [swapTo notifyAsSwapTo];
            
            swapTo = nil;
            swapFrom = nil;
            bSwapMode = YES;
        }];
        return;
    }
    else
    {
        bSwapMode = NO;
        toSwapView = nil;
//        [UIView beginAnimations:@"swapdone animation" context:NULL];
//        [UIView setAnimationDuration: 0.5f];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(swapDoneAnimationStoped:finished:context:)];
//        fromSwapView.frame = swapTo.frame;
//        [UIView commitAnimations];
        [UIView animateWithDuration:0.5 delay:0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            fromSwapView.frame = swapTo.frame;
        }
        completion:^(BOOL finished) {
         // Optional: Handle completion if needed
            if(nil != fromSwapView)
            {
                [fromSwapView removeFromSuperview];
                fromSwapView = nil;
            }
            
            if(nil != toSwapView)
            {
                [toSwapView removeFromSuperview];
                toSwapView = nil;
            }
            
            /* swap the images */
            [swapTo notifyAsSwapTo];
            
            swapTo = nil;
            swapFrom = nil;
            bSwapMode = YES;
        }];
    }
#else
    /* swap the images */
    [swapTo notifyAsSwapTo];
    
    swapTo = nil;
#endif
    
    NSLog(@"Touches Ended in frame");
}

#if 0
- (UIImage*)renderToImageOfScale:(float)scale
{
    // IMPORTANT: using weak link on UIKit
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    }
    else
    {
        CGSize scaledSize = CGSizeMake(self.frame.size.width*scale, self.frame.size.height*scale);
        UIGraphicsBeginImageContext(scaledSize);
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#else

- (UIImage*)quickRenderToImageOfScale:(float)scale
{
    int index = 0;
    static int i = 0;;
//    NSLog(@"Start Img generation %d",i);
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.bounds.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
    
//    NSLog(@"Start getImage %d",i);
    /* Add masks to the context */
    for(index = 0; index < self.photoCount; index++)
    {
        Photo *pht = [self getPhotoAtIndex:index];
        if(nil != pht)
        {
            
            if(pht.view.curShape != SHAPE_NOSHAPE)
            {
                UIImage *curShapeImage = [pht.view getCurrentAssignedShapeImage];
                
                NSAssert(nil != curShapeImage, @"quickRenderImageOfScale: shape is not noshape but shape image is nil");
                
                /* mask the shape */
                CGContextClipToMask(UIGraphicsGetCurrentContext(),pht.view.frame,curShapeImage.CGImage);
               
            }
        }
    }
//    NSLog(@"End getImage %d",i);
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.bounds.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *image = [UIImage imageWithCGImage:image1.CGImage];
    
    
//    NSLog(@"End Img generation %d",i);
    i++;
    return image;
}

- (UIImage*)renderToImageOfScale:(float)scale
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:scale] forKey:@"scale"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:ssiv_notification_snapshotmode_enter object:nil userInfo:dict];
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *image = [UIImage imageWithCGImage:image1.CGImage];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:ssiv_notification_snapshotmode_exit object:nil userInfo:dict];
    return image;
}

#endif
- (UIImage*)quickRenderToImageOfSize:(CGSize)sze
{
    float scale = 0.0;
    int   num1  = sze.width;
    int   num2  = self.frame.size.width;
    
    //NSLog(@"renderToImageOfSize frame size %f,%f",self.frame.size.width,self.frame.size.height);
    
    if(0 == (num1 % num2))
    {
        scale = num1/num2;
    }
    else
    {
        scale = (float)num1/(float)num2;
    }
    
    num1 = sze.height;
    num2 = self.frame.size.height;
    
    if(0 == (num1 % num2))
    {
        scale = num1/num2;
    }
    else
    {
        scale = (float)num1/(float)num2;
    }
    
    return [self quickRenderToImageOfScale:scale];
}

- (UIImage*)renderToImageOfSize:(CGSize)sze
{
    float scale = 0.0;
    int   num1  = sze.width;
    int   num2  = self.frame.size.width;
    
    //NSLog(@"renderToImageOfSize frame size %f,%f",self.frame.size.width,self.frame.size.height);
    
    if(0 == (num1 % num2))
    {
        scale = num1/num2;
    }
    else
    {
        scale = (float)num1/(float)num2;
    }
    
    num1 = sze.height;
    num2 = self.frame.size.height;
    
    if(0 == (num1 % num2))
    {
        scale = num1/num2;
    }
    else
    {
        scale = (float)num1/(float)num2;
    }
    
    return [self renderToImageOfScale:scale];
}

-(void)setPatternImage:(UIImage*)img
{
    
}

-(UIImage*)patternImageForPatterIndex:(int)itemIndex
{
    NSString *pFileName = [NSString stringWithFormat:FILENAME_PATTERN_FORMAT, FILENAME_PATTERN_PREFIX,itemIndex];
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:pFileName ofType:@"png"]];
}

-(void)setPattern:(int)patternNumber
{
    UIImage *img = [self patternImageForPatterIndex:patternNumber];
    if(nil == img)
    {
        return;
    }
    
    self.image = [Utility createPatternImageOfSize:self.bounds withImage:img];
}

-(void)setColor:(UIColor*)color
{
    /* First Set the image to nil */
    self.image = nil;
    
    /* Now set the background color */
    self.backgroundColor = color;
    
    return;
}
-(void)setPhotoWidth:(int)width
{
    int iIndex = 0;
    
    for(iIndex = 0; iIndex < [photos count]; iIndex++)
    {
        Photo *pht = [photos objectAtIndex:iIndex];
        if(nil != pht)
        {
            CGRect updatedFrame = pht.actualFrame;
            float dx = 0.0;
            float dy = 0.0;
            float dw = ((pht.colCount + 1.0) * width)/pht.colCount;
            float dh = ((pht.rowCount + 1.0) * width)/pht.rowCount;
            
            
            dx = dw - width;
            dy = dh - width;
            
            updatedFrame.origin.x += (width - (dx * pht.colIndex));
            updatedFrame.origin.y += (width - (dy * pht.rowIndex));
            updatedFrame.size.width -= dw;
            updatedFrame.size.height -= dh;
            
            pht.frame = updatedFrame;
         

        }
    }
    
    return;
}

-(void)setWidth:(int)width
{
    int iIndex = 0;
    
    for(iIndex = 0; iIndex < [photos count]; iIndex++)
    {
        Photo *pht = [photos objectAtIndex:iIndex];
        if(nil != pht)
        {
            CGRect updatedFrame = pht.actualFrame;
            float dx = 0.0;
            float dy = 0.0;
            int colCount = pht.colCount;
            int rowCount = pht.rowCount;
            int colIndex = pht.colIndex;
            int rowIndex = pht.rowIndex;
            float dw = ((colCount + 1.0) * width)/colCount;
            float dh = ((rowCount + 1.0) * width)/rowCount;
            
            
            dx = dw - width;
            dy = dh - width;
            
            updatedFrame.origin.x += (width - (dx * colIndex));
            updatedFrame.origin.y += (width - (dy * rowIndex));
            updatedFrame.size.width -= dw;
            updatedFrame.size.height -= dh;
            
            pht.frame = updatedFrame;
        }
    }
    
    if(width < DEFAULT_FRAME_WIDTH)
    {
        width = DEFAULT_FRAME_WIDTH;
    }
    
    width = width - DEFAULT_FRAME_WIDTH;
    width = -width;
    
    for(iIndex = 0; iIndex < [adjustors count]; iIndex++)
    {
        Adjustor *pht = [adjustors objectAtIndex:iIndex];
        if(nil != pht)
        {
            CGRect updatedFrame = pht.actualFrame;
            float dx = 0.0;
            float dy = 0.0;
            int colCount = pht.colCount;
            int rowCount = pht.rowCount;
            int colIndex = pht.colIndex;
            int rowIndex = pht.rowIndex;
            float dw = ((colCount + 1.0) * width)/colCount;
            float dh = ((rowCount + 1.0) * width)/rowCount;
            
            
            dx = dw - width;
            dy = dh - width;
            
            updatedFrame.origin.x += (width - (dx * colIndex));
            updatedFrame.origin.y += (width - (dy * rowIndex));
            updatedFrame.size.width -= dw;
            updatedFrame.size.height -= dh;
            
            
            pht.frame = updatedFrame;
        }
    }
    
    return;
}

-(void)setOuterRadius:(int)radius
{
    self.layer.cornerRadius = radius;
    return;
}


-(void)setShadowEffect:(float)opacity cornerRadious:(float)rValue
{
    int iIndex = 0;
    NSLog(@"setInnerRadius");
    for(iIndex = 0; iIndex < [photos count]; iIndex++)
        
    {
      Photo *pht = [photos objectAtIndex:iIndex];
        
//        pht.view.layer.cornerRadius=rValue;
//        //pht.view.layer.shadowColor = [[UIColor blackColor] CGColor];
//        view1.layer.shadowColor=[UIColor blackColor].CGColor;
//        //view1.layer.shadowOpacity = opacity;
//        view1.layer.shadowOpacity = opacity;
//        view1.layer.shadowRadius = 5;
//       // view1.layer.cornerRadius=rValue;
//        view1.layer.shadowOffset = CGSizeMake(0, 0);
//
//        pht.view.userInteractionEnabled=YES;
////        [view1 addSubview:pht.view];
////        [self addSubview:view1];
//        [view1.layer addSublayer:pht.view.layer];
//        [self.layer addSublayer:view1.layer];
        
        pht.view.layer.cornerRadius=rValue;
        pht.view.layer.masksToBounds = NO;
        pht.view.layer.shadowOffset = CGSizeMake(0,0);
        pht.view.layer.shadowRadius = 6;
        pht.view.layer.shadowOpacity = opacity;
    }
    return;
}


-(void)setInnerRadius:(int)radius
{
    int iIndex = 0;
    //NSLog(@"setInnerRadius");
    for(iIndex = 0; iIndex < [photos count]; iIndex++)
    {
        Photo *pht = [photos objectAtIndex:iIndex];
        pht.view.layer.cornerRadius = radius;
        pht.view.clipsToBounds = YES;
        NSLog(@"inner radious value is %d",radius);
    }
    return;
}

-(void)setAspectRatio:(eAspectRatio)ratio
{
    
}

-(void)dealloc
{
    //NSLog(@"Releasing Frame");
    if(nil != photos)
    {
        int index = 0;
        Photo *pht = nil;
        for(index = 0; index < [photos count]; index++)
        {
            pht = [photos objectAtIndex:index];
            if(nil == pht)
            {
                continue;
            }
            
            [pht releaseAllResources];
            
            
            pht = nil;
        }
        
      //  [photos release];
     //   [view1 release];
    }
    
    if(nil != adjustors)
    {
    //    [adjustors release];
    }
    
   // [super dealloc];
}
//-(void)loadPhotosFromSession:(Session*)sess
//{

//}

@end

