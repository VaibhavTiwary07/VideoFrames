//
//  Settings.m
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 10/7/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "Settings.h"


@implementation Settings


@synthesize connectedToInternet;
@synthesize videoTutorialWatched;
@synthesize uploadCommand;
@synthesize uploadSize;
@synthesize uploadResolution;
@synthesize noAdMode;

static Settings *SettingsSingleton = nil;

+(NSString*)appSettingsFilePath
{
	NSArray  *paths        = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
	NSString *pFileName    = nil;
	
	/* file name */
	pFileName = @"settings.txt";
	
	/* Return the path to the puzzle status information */
	return [docDirectory stringByAppendingPathComponent:pFileName];
}
-(void)setNoAdMode:(BOOL)yesOrNo
{
    noAdMode =yesOrNo;
}
-(BOOL)getNoAdMode
{
    return noAdMode;
}
-(CGSize)getTheSizeForResolution:(eResolutionType)eResType
{
    CGSize calcSize = CGSizeZero;
    float width  = 0;
    float height = 0;
    int times  = 0;
    switch (eResType)
    {
        case RESOLUTION_PIXCOUNT_HIGH0:
        {
            times = 8;
            //calcSize = CGSizeMake(2400, 2400);
            break;
        }
        case RESOLUTION_PIXCOUNT_HIGH1:
        {
            times = 7;
            //calcSize = CGSizeMake(2100, 2100);
            break;
        }
        case RESOLUTION_PIXCOUNT_MED0:
        {
            times = 6;
            //calcSize = CGSizeMake(1800, 1800);
            break;
        }
        case RESOLUTION_PIXCOUNT_MED1:
        {
            times = 5;
            //calcSize = CGSizeMake(1500, 1500);
            break;
        }
        case RESOLUTION_PIXCOUNT_MED2:
        {
            times = 4;
            //calcSize = CGSizeMake(1200, 1200);
            break;
        }
        case RESOLUTION_PIXCOUNT_LOW0:
        {
            times = 3;
            //calcSize = CGSizeMake(900, 900);
            break;
        }
        case RESOLUTION_PIXCOUNT_LOW1:
        {
            times = 2;
            //calcSize = CGSizeMake(600, 600);
            break;
        }
        case RESOLUTION_PIXCOUNT_LOW2:
        {
            times = 1;
            break;
        }
        default:
            break;
    }
    
    int wConst = 0;
    int hConst = 0;
    /*
    if(mstSettings.wRatio > mstSettings.hRatio)
    {
        wConst = 400; //newly changed
        hConst = wConst * (mstSettings.hRatio/mstSettings.wRatio);
    }
   
    else
    {
        hConst = 400; //newly changed
        wConst = hConst * (mstSettings.wRatio/mstSettings.hRatio);
    }
    
    width  = wConst * times;
    height = hConst * times;
    if ([UIDevice currentDevice].userInterfaceIdiom== UIUserInterfaceIdiomPad)
    {
            calcSize = CGSizeMake(width, height);
    }
    else if(([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) && full_screen.size.height>670)
        {
            calcSize = CGSizeMake(width, height);
            NSLog(@"Iphone X...");
        }
    else
    {
            calcSize = CGSizeMake(width, height);
    }

    NSLog(@"getTheSizeForResolution: %d size %f,%f",eResType,calcSize.width,calcSize.height);
    return calcSize;
    */
    if(mstSettings.wRatio > mstSettings.hRatio)
    {
        wConst = 300;
        hConst = wConst * (mstSettings.hRatio/mstSettings.wRatio);
    }
    else
    {
        hConst = 300;
        wConst = hConst * (mstSettings.wRatio/mstSettings.hRatio);
    }
    NSLog(@"getTheSizeFor hconst %d wconst %d",hConst,wConst);
    width  = wConst * times;
    height = hConst * times;
    calcSize = CGSizeMake(width, height);
    NSLog(@"getTheSizeForResolution: %d size %f,%f",eResType,calcSize.width,calcSize.height);
    return calcSize;
}


-(eResolutionType)uploadResolution
{
    return _uploadResolution;
}

-(void)setUploadResolution:(eResolutionType)resolution
{
    _uploadResolution = resolution;
    
    uploadSize = [self getTheSizeForResolution:resolution];
    
    return;
}

-(UIImage*)generateTheImage
{
    return nil;
}

-(void)update
{
    NSData *data;
	NSFileHandle *fd;
	
	if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[Settings appSettingsFilePath]])
	{
		/* Open the File */
		fd = [NSFileHandle fileHandleForWritingAtPath:[Settings appSettingsFilePath]];
		
		/* write the default status information to the file */
		data = [[NSData alloc] initWithBytes:&mstSettings length:sizeof(stSettings)];
		
		/* Write the data to the file */
		[fd writeData:data];
		
		/* Release the data */
	//	[data release];
		
		/* Close the file */
		[fd closeFile];
	}
	
	return;
}

+(float)defaultFrameWidth
{
    /* This value should be based on the device, but for now we will return */
    return 300.0;
}

+(float)defaultFrameHeight
{
    return 300.0;
}

+(CGSize)aspectRatioToValues:(eAspectRatio)ratio
{
    CGSize sze;
    NSLog(@"aspect Ratio To Values %d",ratio);
    switch(ratio)
    {
        case ASPECTRATIO_1_1:
        {
            sze.width  = 1.0;
            sze.height = 1.0;
            break;
        }
        case ASPECTRATIO_3_2:
        {
            sze.width  = 3.0;
            sze.height = 2.0;
            break;
        }
        case ASPECTRATIO_2_3:
        {
            sze.width  = 2.0;
            sze.height = 3.0;
            break;
        }
        case ASPECTRATIO_4_3:
        {
            sze.width  = 4.0;
            sze.height = 3.0;
            break;
        }
        case ASPECTRATIO_3_4:
        {
            sze.width  = 3.0;
            sze.height = 4.0;
            break;
        }
        case ASPECTRATIO_1_2:
        {
            sze.width  = 1.0;
            sze.height = 2.0;
            break;
        }
        case ASPECTRATIO_2_1:
        {
            sze.width  = 2.0;
            sze.height = 1.0;
            break;
        }
        case   ASPECTRATIO_9_16:// Instagram Story
        {
            sze.width  = 9.0;
            sze.height = 16.0;
            break;
        }
        case   ASPECTRATIO_4_5: // Instagram portrait
        {
            sze.width  = 4.0;
            sze.height = 5.0;
            break;
        }
        case    ASPECTRATIO_5_4: // Card
        {
            sze.width  = 5.0;
            sze.height = 4.0;
            break;
        }
        case    ASPECTRATIO_4_6:
        {
            sze.width  = 4.0;
            sze.height = 6.0;
            break;
        }
        case   ASPECTRATIO_5_7:
        {
            sze.width  = 5.0;
            sze.height = 7.0;
            break;
        }
        case   ASPECTRATIO_8_10:
        {
            sze.width  = 8.0;
            sze.height = 10.0;
            break;
        }
        case   ASPECTRATIO_16_9:
        {
            sze.width  = 16.0;
            sze.height = 9.0;
            break;
        }
        case   ASPECTRATIO_WALLPAPER:
        {
            // Get the width and height
            CGFloat width = fullScreen.size.width;
            CGFloat height = fullScreen.size.height;
            
            // Calculate the greatest common divisor (GCD)
            int gcd = [self gcd:(int)width and:(int)height];
            
            // Divide width and height by GCD to get the ratio
            sze.width  = width / gcd;
            sze.height = height / gcd;
            break;
        }
        case ASPECTRATIO_CUSTOM:
        {
            sze.width  = customWidth;
            sze.height =  customHeight;
            break;
        }
        case ASPECTRATIO_MAX:
        default:
        {
            sze.width  = 1.0;
            sze.height = 1.0;
            break;
        }
    }
    
    return sze;
}



// Helper method to calculate the GCD
+ (int)gcd:(int)a and:(int)b {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}


-(eAspectRatio)aspectRatio
{
    return mstSettings.aspectRatio;
}

-(void)setAspectRatio:(eAspectRatio)aspectRatio
{
    NSLog(@"set Aspect Ratio %d",aspectRatio);
    if(aspectRatio == ASPECTRATIO_CUSTOM)
    {
        mstSettings.wRatio = customWidth;
        mstSettings.hRatio = customHeight;
    }
    else
    {
        CGSize sze = [Settings aspectRatioToValues:aspectRatio];
        mstSettings.wRatio = sze.width;
        mstSettings.hRatio = sze.height;
    }
    mstSettings.aspectRatio = aspectRatio;

    mstSettings.maxRatio = (mstSettings.wRatio > mstSettings.hRatio)?mstSettings.wRatio:mstSettings.hRatio;
    NSLog(@"set Aspect .maxRatio  Ratio %f", mstSettings.maxRatio );
    [self update];
    
    return;
}

// Static variable to hold the width value
static float customWidth = 1.0;  // Default value
static float customHeight = 1.0;  // Default value

+ (float)customWidth {
    return customWidth;
}

+ (void)setCustomWidth:(float)width {
    customWidth = width;
}

+ (float)customHeight {
    return customHeight;
}

+ (void)setCustomHeight:(float)height {
    customHeight = height;
}


-(void)setCustomAspectRatioWidth:(float)wRatio height:(float)hRatio
{
    mstSettings.aspectRatio = ASPECTRATIO_CUSTOM;
//    customWidth = wRatio;
//    customHeight = hRatio;
    mstSettings.wRatio = wRatio;
    mstSettings.hRatio = hRatio;
    mstSettings.maxRatio = (mstSettings.wRatio > mstSettings.hRatio)?mstSettings.wRatio:mstSettings.hRatio;
    NSLog(@"set Aspect .maxRatio  Ratio %f", mstSettings.maxRatio );
    [self update];
    return;
}

-(float)wRatio
{
    return mstSettings.wRatio;
}

-(float)hRatio
{
    return mstSettings.hRatio;
}

-(float)maxRatio
{
    return mstSettings.maxRatio;
}

-(int)currentFrameNumber
{
    return mstSettings.currentFrameNumber;
}

-(void)setCurrentFrameNumber:(int)currentFrameNumber
{
    mstSettings.currentFrameNumber = currentFrameNumber;
    
    [self update];
    
    return;
}

-(void)setCurrentSessionIndex:(int)currentSessionIndex
{
    mstSettings.currentSessionIndex = currentSessionIndex;
    
    [self update];
}

-(int)currentSessionIndex
{
    //return mstSettings.currentSessionIndex;
    return 0;
}

-(int)nextFreeSessionIndex
{
    mstSettings.nextFreeSessionIndex = mstSettings.nextFreeSessionIndex + 1;
    mstSettings.currentSessionIndex = mstSettings.nextFreeSessionIndex;
    
    [self update];
    
    //return mstSettings.nextFreeSessionIndex;
    return 0;
}

-(BOOL)videoTutorialWatched
{
    return mstSettings.videoTutorialWatched;
}

-(void)setVideoTutorialWatched:(BOOL)watched
{
    mstSettings.videoTutorialWatched = watched;
    
    [self update];
    
    return;
}

-(BOOL)facebookLogin
{
    return mstSettings.facebookLogin;
}

-(void)setFacebookLogin:(BOOL)_facebookLogin
{
    mstSettings.facebookLogin = _facebookLogin;
    
    [self update];
    
    return;
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"Internet not reachable");
            break;
        }
        default:
        {
            NSLog(@"Internet reachable");
            break;
        }
    }
}

-(BOOL)connectedToInternet
{
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    return !(netStatus == NotReachable);
}

-(id)init
{
    self = [super init];
    if(self)
    {
        NSData *data;
        NSFileHandle *fd;
        
        internetReach = [Reachability reachabilityForInternetConnection];// retain];
        [internetReach startNotifier];
        
        /* initiatialize the data with default values */
        memset(&mstSettings, 0, sizeof(stSettings));
        
        /* By default initialize it to TRUE */
        mstSettings.facebookLogin        = NO;
        mstSettings.videoTutorialWatched = NO;
        mstSettings.aspectRatio          = ASPECTRATIO_1_1;
        mstSettings.wRatio               = 1;
        mstSettings.hRatio               = 1;
        mstSettings.maxRatio             = 1;
        
        if(YES == [[NSFileManager defaultManager] fileExistsAtPath:[Settings appSettingsFilePath]])
        {            
            /* File exist so read the saved status from the file  */
            fd = [NSFileHandle fileHandleForReadingAtPath:[Settings appSettingsFilePath]];
            NSLog(@"app settings file path %@",[Settings appSettingsFilePath]);
            /* Read the data from the file */
            if([(data = [fd readDataOfLength:sizeof(stSettings)]) length]>0)
            {			
                memcpy(&mstSettings, [data bytes], sizeof(stSettings));
                
                self.aspectRatio = mstSettings.aspectRatio; //ASPECTRATIO_3_4; //
            }
            
            [fd closeFile];
        }
        else
        {
            /* File doesn't exist so create one for future usage */
            if(NO == [[NSFileManager defaultManager] createFileAtPath:[Settings appSettingsFilePath] contents:nil attributes:nil])
            {
                return self;
            }
            
            [self update];
        }
        
        return self;
    }
    
    return self;
}

+(Settings*)Instance 
{
    
   // @autoreleasepool {
       
        @synchronized([Settings class])
        {
            if (SettingsSingleton == nil)
            {
                SettingsSingleton = [[self alloc] init]; // assignment not done here
            }
        }
        
        return SettingsSingleton;
    }
   
//}


+(id)allocWithZone:(NSZone *)zone 
{
    @synchronized([Settings class]) 
	{
        if (SettingsSingleton == nil) 
		{
            SettingsSingleton = [super allocWithZone:zone];
            return SettingsSingleton;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


-(void)dealloc 
{    
  //  [super dealloc];
}

-(id)copyWithZone:(NSZone *)zone 
{
    return self;
}


//-(id)retain 
//{
//    return self;
//}


//-(unsigned)retainCount 
//{
//    return UINT_MAX;  //denotes an object that cannot be release
//}


//-(oneway void)release
//{
//    //do nothing    
//}
//
//-(id)autorelease
//{
//    return self;    
//}

@end
