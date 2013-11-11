//
//  fbmgr.m
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 7/22/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "fbmgr.h"

//static NSString* kAppId = @"165303643543341";

@implementation fbmgr
@synthesize _isLoggedIn;
@synthesize _facebook;
@synthesize fbDelegate;

// use these as the keys for storing the token and date in user defaults
#define ACCESS_TOKEN_KEY @"fb_access_token"
#define EXPIRATION_DATE_KEY @"fb_expiration_date"

static fbmgr *fbmgrSingleton = nil;

+(fbmgr*)Instance 
{
    @synchronized([fbmgr class]) 
	{
        if (fbmgrSingleton == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
	
    return fbmgrSingleton;
}


+(id)allocWithZone:(NSZone *)zone 
{
    @synchronized([fbmgr class]) 
	{
        if (fbmgrSingleton == nil) 
		{
            fbmgrSingleton = [super allocWithZone:zone];
            return fbmgrSingleton;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


-(void)dealloc 
{
    [_facebook release];
	[_permissions release];
    
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
    return;
}

-(id)autorelease
{
    return self;    
}

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin 
{
    _isLoggedIn = YES;
    nvm.facebookLogin = YES;
    bIsLoginInProgress = NO;
    
    // store the access token and expiration date to the user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_facebook.accessToken forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:_facebook.expirationDate forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];
    
    [fbDelegate loginStatus:YES];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled 
{
    NSLog(@"fbmgr:Failed login");
    
    [fbDelegate loginStatus:NO];
    
    _isLoggedIn = NO;
    nvm.facebookLogin = NO;
    bIsLoginInProgress = NO;
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout 
{
    [fbDelegate loginStatus:NO];
 
    _isLoggedIn = NO;
    nvm.facebookLogin = NO;
    bIsLoginInProgress = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:nil forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];
    
    return;
}

/**
 * Show the authorization dialog.
 */
- (void)login 
{
    if(_isLoggedIn)
    {
        NSLog(@"Already logged in");
        return;
    }
    
    if(bIsLoginInProgress == YES)
    {
        NSLog(@"login is in progress");
        return;
    }
    
    bIsLoginInProgress = YES;
    
    NSLog(@"fbmgr: login Calling authorize method");
    [_facebook authorize:_permissions delegate:self];
    
    return;
}

/**
 * invoke the delegate method
 */
- (void) invokeDelegate: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	assert([NSThread isMainThread]);
	if([self respondsToSelector: selector])
	{
		if(arg != NULL)
		{
			[self performSelector: selector withObject: arg withObject: err];
		}
		else
		{
			[self performSelector: selector withObject: err];
		}
	}
	else
	{
		NSLog(@"FB:Missed Method");
	}
}

/**
 * make sure that we are running in the main thread
 */
- (void) invokeDelegateOnMainThread: (SEL) selector withArg: (id) arg error: (NSError*) err
{
	dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self invokeDelegate: selector withArg: arg error: err];
                   });
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout 
{
    [_facebook logout:self];
}

-(id)init 
{	
	/* Initilize the super class */
    self = [super init];
	
    if(NULL != self)
	{
        /* Initialize the singleton instance */
        fbmgrSingleton = self;
        
        bIsLoginInProgress = NO;
        
        nvm = [Settings Instance];
        
        /* Allocate facebook initialization */
        _facebook = [[Facebook alloc] initWithAppId:fbAppId];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // on login, use the stored access token and see if it still works
        _facebook.accessToken = [defaults objectForKey:ACCESS_TOKEN_KEY];
        _facebook.expirationDate = [defaults objectForKey:EXPIRATION_DATE_KEY];
        
        // only authorize if the access token isn't valid
        // if it *is* valid, no need to authenticate. just move on
        if ([_facebook isSessionValid]) 
        {
            NSLog(@"fbmgr: Sesion is valid so not logging in again");
            nvm.facebookLogin = YES;
            _isLoggedIn = YES;
            return self;
        }
        
        /* Allocate permissions */
        //_permissions =  [[NSArray arrayWithObjects:
        //                  @"read_stream", @"publish_stream", @"offline_access",@"user_photos",@"user_photo_video_tags",@"read_friendlists",@"friends_photos",nil] retain];
        
        _permissions =  [[NSArray arrayWithObjects:@"read_stream",@"publish_stream",@"user_photos",@"offline_access",@"read_friendlists",@"friends_photos",nil] retain];
                  
        NSLog(@"fbmgr: Calling login");
        [self login];
        
        _isLoggedIn = NO;
        nvm.facebookLogin = NO;
    }
    
    return self;
}

-(BOOL)isLoginValid
{
    return [_facebook isSessionValid];
}

-(void)getTheAlbumFor:(id)del
{
    [_facebook requestWithGraphPath:@"me/albums"
                        andDelegate:del];
}

@end
