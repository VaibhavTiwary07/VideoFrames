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
		[data release];
		
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

-(eAspectRatio)aspectRatio
{
    return mstSettings.aspectRatio;
}

-(void)setAspectRatio:(eAspectRatio)aspectRatio
{
    //NSLog(@"setAspectRatio %d",aspectRatio);
    CGSize sze = [Settings aspectRatioToValues:aspectRatio];
    mstSettings.aspectRatio = aspectRatio;
    
    mstSettings.wRatio = sze.width;
    mstSettings.hRatio = sze.height;
    
    mstSettings.maxRatio = (mstSettings.wRatio > mstSettings.hRatio)?mstSettings.wRatio:mstSettings.hRatio;

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
        
        internetReach = [[Reachability reachabilityForInternetConnection] retain];
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
            
            /* Read the data from the file */
            if([(data = [fd readDataOfLength:sizeof(stSettings)]) length]>0)
            {			
                memcpy(&mstSettings, [data bytes], sizeof(stSettings));
                
                self.aspectRatio = mstSettings.aspectRatio;
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
    @synchronized([Settings class]) 
	{
        if (SettingsSingleton == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
	
    return SettingsSingleton;
}


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
    [super dealloc];
}

-(id)copyWithZone:(NSZone *)zone 
{
    return self;
}


-(id)retain 
{
    return self;
}


-(unsigned)retainCount 
{
    return UINT_MAX;  //denotes an object that cannot be release
}


-(oneway void)release
{
    //do nothing    
}

-(id)autorelease
{
    return self;    
}

@end
