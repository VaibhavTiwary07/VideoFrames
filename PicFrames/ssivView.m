//
//  ssivView.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/25/12.
//
//

#import "ssivView.h"
#import "AVPlayerDemoPlaybackView.h"

@interface ssivView()
{
    //eShape _curShape;
    //UIColor *bgclr;
    //AVPlayerDemoPlaybackView *playbackView;
    AVPlayerDemoPlaybackView *playbackView;
}

@property(nonatomic,retain)UIColor *bgclr;
@end

@implementation ssivView
@synthesize scrollView;
@synthesize imageView;
@synthesize curShape;

typedef struct
{
    eShape type;
    BOOL  bLocked;
    char imageName[64];
}tShapeMap;

static tShapeMap shape_imagenamemaping[SHAPE_LAST] = {
    {SHAPE_NOSHAPE,NO,"original"},
    {SHAPE_CIRCLE,NO,"circle"},
    {SHAPE_ZIGZAG,NO,"zigzag"},
    {SHAPE_BUTTERFLY,NO,"butterfly"},
    {SHAPE_STAR,NO,"star"},
    {SHAPE_TRIANGLE,NO,"triangle"},
    {SHAPE_FLOWER,NO,"flower"},
    {SHAPE_DIAMONDFLOWER,NO,"diamondflower"},
    {SHAPE_HEART,NO,"heart"},
    {SHAPE_HEXAGON,NO,"hexagon"},
    {SHAPE_CHRISTMASTREE,NO,"christmastree"},
    {SHAPE_CHRISTMASLIGHT,NO,"christmaslight"},
    {SHAPE_LEAF,NO,"leaf"},
    {SHAPE_APPLE,NO,"apple"},
    {SHAPE_MESSAGE,NO,"speach"},
    {SHAPE_CLOUD,NO,"cloud"},
    {SHAPE_BROKENHEART,NO,"brokenheart"},
};

-(void)removePlayer
{
    [playbackView removeFromSuperview];
}

- (void)setPlayer:(AVPlayer*)player
{

    
    NSLog(@"Adding playback view");
	//[(AVPlayerLayer*)[self layer] setPlayer:player];
    playbackView = [[AVPlayerDemoPlaybackView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    playbackView.tag = 658;
    [playbackView setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
    [playbackView setPlayer:player];
    [self addSubview:playbackView];
    [playbackView release];
}



/* Specifies how the video is displayed within a player layer’s bounds.
 (AVLayerVideoGravityResizeAspect is default) */
- (void)setVideoFillMode:(NSString *)fillMode
{
	AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
	playerLayer.videoGravity = fillMode;
}

+(UIImage*)imageForShape:(eShape)shp
{
    if(shp >= SHAPE_LAST)
    {
        shp = SHAPE_CIRCLE;
    }
    
    NSString *imgname = [NSString stringWithFormat:@"%s",shape_imagenamemaping[shp].imageName];
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgname ofType:@"png"]];
}

-(void)setShape:(eShape)shape
{
    if((shape > SHAPE_LAST)||(shape < SHAPE_NOSHAPE))
    {
        NSLog(@"setShape:Invalid Shape");
        return;
    }
    
    UIImage *shapeImage = nil;
    if(shape == SHAPE_NOSHAPE)
    {
        self.curShape = shape;
        self.layer.mask = nil;
        return;
    }
    
    self.curShape = shape;
    
    NSString *imgName = [NSString stringWithFormat:@"%s",shape_imagenamemaping[shape].imageName];
    shapeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
    
    CGImageRef imgAlpha = shapeImage.CGImage;
    CALayer *alphaLayer = [CALayer layer];
    alphaLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    alphaLayer.position = CGPointMake(self.center.x - self.frame.origin.x,self.center.y-self.frame.origin.y);
    alphaLayer.contents = (id)imgAlpha;
    self.layer.mask = alphaLayer;
    
    return;
}

-(void)previewShape:(eShape)shape
{
    if((shape > SHAPE_LAST)||(shape < SHAPE_NOSHAPE))
    {
        NSLog(@"setShape:Invalid Shape");
        return;
    }
    
    UIImage *shapeImage = nil;
    if(shape == SHAPE_NOSHAPE)
    {
        //self.curShape = shape;
        self.layer.mask = nil;
        return;
    }
    
    //self.curShape = shape;
    
    NSString *imgName = [NSString stringWithFormat:@"%s",shape_imagenamemaping[shape].imageName];
    shapeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
    
    CGImageRef imgAlpha = shapeImage.CGImage;
    CALayer *alphaLayer = [CALayer layer];
    alphaLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    alphaLayer.position = CGPointMake(self.center.x - self.frame.origin.x,self.center.y-self.frame.origin.y);
    alphaLayer.contents = (id)imgAlpha;
    self.layer.mask = alphaLayer;
    
    return;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bgclr = nil;
        self.curShape = SHAPE_NOSHAPE;
        self.userInteractionEnabled = YES;
        CGRect internalFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        // Initialization code
        UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:internalFrame];
        self.scrollView = scrollV;
        //self.scrollView = [[UIScrollView alloc]initWithFrame:internalFrame];
        //self.scrollView.scrollEnabled = YES;
        //self.scrollView.showsVerticalScrollIndicator = NO;
        //self.scrollView.showsHorizontalScrollIndicator = NO;
        //self.scrollView.backgroundColor = [UIColor blackColor];
        
        // Allocate image view
        TouchDetectView *imgV = [[TouchDetectView alloc]initWithFrame:internalFrame];
        self.imageView   = imgV;
        //self.imageView.contentMode = UIViewContentModeScaleToFill;
        //self.imageView.backgroundColor = clr;
        [self.imageView setUserInteractionEnabled:YES];
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        
        /* No need to free these */
        [scrollV release];
        [imgV release];
        
        //[self setShape:SHAPE_CIRCLE];
        //self.layer.masksToBounds = YES;
        [self registerForNotifications];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setShape:self.curShape];
}

-(void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:nil
                                                  object:nil];
}

-(void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
}

-(UIImage*)getImageOfShape:(eShape)shp
{
    NSString *imgName = [NSString stringWithFormat:@"%s",shape_imagenamemaping[shp].imageName];
    UIImage *shapeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
    
    return shapeImage;
}

-(UIImage*)getCurrentAssignedShapeImage
{
    return [self getImageOfShape:self.curShape];
}

-(void)snapshotWithScale:(float)scale
{
    
    if((self.curShape == SHAPE_NOSHAPE)||(self.curShape >= SHAPE_LAST))
    {
        return;
    }
    
    //static int count  = 0;
    //count++;
    //NSLog(@"Begin %d (%f,%f) scale %f",count,self.frame.size.width,self.frame.size.height,scale);
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    
    self.bgclr = self.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    NSString *imgName = [NSString stringWithFormat:@"%s",shape_imagenamemaping[self.curShape].imageName];
    UIImage *shapeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgName ofType:@"png"]];
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.bounds.size.height);
	CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
    
    CGContextClipToMask(UIGraphicsGetCurrentContext(),CGRectMake(0, 0, self.frame.size.width, self.frame.size.height),shapeImage.CGImage);
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.bounds.size.height);
	CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();

    self.scrollView.hidden = YES;
    self.imageView.hidden = YES;
    
    UIGraphicsEndImageContext();
    //NSLog(@"End %d",count);
}

-(void)receiveNotification:(NSNotification*)notification
{
    /*  */
    if([notification.name isEqualToString:ssiv_notification_snapshotmode_enter])
    {
        //if(nil != self.imageView.image)
        //{
            if(self.curShape != SHAPE_NOSHAPE)
            {
                /* get the scale */
                float scale = [[notification.userInfo objectForKey:@"scale"]floatValue];
                [self snapshotWithScale:scale];
            }
            //else
            //{
            //    NSLog(@"ssiv_notification_snapshotmode_enter: self.curShape is SHAPE_NOSHAPE");
            //}
        //}
        //else
        //{
        //    NSLog(@"ssiv_notification_snapshotmode_enter: self.imageview.image is nil");
        //}
    }
    else if([notification.name isEqualToString:ssiv_notification_snapshotmode_exit])
    {
        if((self.curShape == SHAPE_NOSHAPE)||(self.curShape >= SHAPE_LAST))
        {
            return;
        }
        self.image = nil;
        self.backgroundColor = self.bgclr;
        self.scrollView.hidden = NO;
        self.imageView.hidden = NO;
        self.bgclr = nil;
    }
}

-(void)dealloc
{
    [self unregisterForNotifications];
    [super dealloc];
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
