//
//  FacebookManager.m
//  SimpleTextInput
//
//  Created by Vijaya kumar reddy Doddavala on 7/9/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "FacebookManager.h"

static NSString* kAppId = @"165303643543341";

@implementation FacebookManager

@synthesize _facebook;
@synthesize fbManagerDelegate;

/**
 * facebook manager initilization
 */
-(id)init
{
	self = [super init];
	if(NULL != self)
	{
        uploadImage = nil;
        
		/* Allocate facebook initialization */
		_facebook = [[Facebook alloc] initWithAppId:kAppId];
		
		/* Allocate permissions */
		_permissions =  [[NSArray arrayWithObjects:
                          @"read_stream", @"publish_stream", @"offline_access",@"user_photos",@"user_photo_video_tags",@"read_friendlists",@"friends_photos",nil] retain];
        
        photoId = nil;
        _isPhotoUploadPending = NO;
	}
	
	return self;
}

/**
 * facebook manager deallocation
 */
-(void)dealloc
{
	/* uninitialize the properties */
	[_facebook release];
	[_permissions release];
	[_caption release];
    
    self.fbManagerDelegate = nil;
	
	/* dealloc super */
	[super dealloc];
	
	return;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * Show the authorization dialog.
 */
- (void)login {
    [_facebook authorize:_permissions delegate:self];
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
    [_facebook logout:self];
}

- (void)uploadPhoto:(UIImage*)photo 
{
    //NSString *path = @"http://www.facebook.com/images/devsite/iphone_connect_btn.jpg";
    //NSURL *url = [NSURL URLWithString:path];
    //NSData *data = [NSData dataWithContentsOfURL:url];
    //UIImage *img  = [[UIImage alloc] initWithData:data];
    NSString *message   = [NSString stringWithFormat:@"From Glow Labels Free Iphone App!!!!"];
    NSData   *imageData = UIImagePNGRepresentation(photo);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   imageData, @"file",message,@"message",
                                   nil];
    
    [_facebook requestWithGraphPath:@"me/photos"
                          andParams:params
                      andHttpMethod:@"POST"
                        andDelegate:self];
    
    //[img release];
    if(nil != uploadImage)
    {
        [uploadImage release];
        uploadImage = nil;
    }
}

-(void)publishStream
{
    SBJsonWriter *jsonWriter = [[SBJsonWriter new] autorelease];
    
    NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
    
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"a long run", @"name",
                                @"The Facebook Running app", @"caption",
                                @"it is fun", @"description",
                                @"http://itsti.me/", @"href", nil];
    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Share on Facebook",  @"user_message_prompt",
                                   actionLinksStr, @"action_links",
                                   attachmentStr, @"attachment",
                                   nil];
    
    
    /*[_facebook dialog:@"feed"
            andParams:params
          andDelegate:self];*/
    [_facebook dialog:@"stream.publish"
            andParams:params
          andDelegate:self];
    
    NSLog(@"inside publish stream");
}
///////////////////////////////////////////////////////////////////////////////////////////////////
// IBAction

/**
 * Login/out button click
 */
- (void) publishToFacebook:(UIImage *)pImg
{
	if(nil == pImg)
	{
		return;
	}
	
    /* retain the image to use it after the login */
    uploadImage = [pImg retain];
    
	/* Check if we are already logged in */
	if (_isLoggedIn) 
	{
		[self uploadPhoto:pImg];
	} 
	else 
	{
        /* also set the flag  */
        _isPhotoUploadPending = YES;
        
        /* Now login into facebook */
		[self login];
	}
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
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin 
{
    NSLog(@"FacebookManager:Logged in");
    
    _isLoggedIn = YES;
    
    /* check if the photo upload is pending */
    if(_isPhotoUploadPending)
    {
        [self uploadPhoto:uploadImage];
    }
    /* Now publish the stream */
    //[self publishStream];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled 
{
    NSLog(@"FacebookManager:Failed login");
    
    _isLoggedIn = NO;
    
    if(nil != uploadImage)
    {
        [uploadImage release];
        uploadImage = nil;
    }
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout 
{
    _isLoggedIn = NO;
    
    if(nil != uploadImage)
    {
        [uploadImage release];
        uploadImage = nil;
    }
}

////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
    NSLog(@"FaceBookManager:received response");
}

-(void)downloadPhotoOfId
{
    [_facebook requestWithGraphPath:photoId andDelegate:self];
}   

/**
 * Open an inline dialog that allows the logged in user to publish a story to his or
 * her wall.
 */
- (IBAction)postToNewsFeed
{
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter new] autorelease];
    
    NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           @"Always Running",@"text",@"http://itsti.me/",@"href", nil], nil];
    
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    
    /* create image media type */
	NSDictionary* imageShare = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"image", @"type",
								photoSrc,@"src",
                                @"http://doodlegames.blogspot.com", @"href",
                                nil];
    
    NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"a long run", @"name",
                                @"The Facebook Running app", @"caption",
                                @"it is fun", @"description",
                                @"http://itsti.me/", @"href", 
                                [NSArray arrayWithObjects:imageShare, nil ], @"media",nil];
    
    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Share on Facebook",  @"user_message_prompt",
                                   actionLinksStr, @"action_links",
                                   attachmentStr, @"attachment",
                                   nil];
    
    
    [_facebook dialog:@"feed"
            andParams:params
          andDelegate:self];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
#if 0
- (void)request:(FBRequest *)request didLoad:(id)result 
{
    
    //NSLog(@"%@",result);
    NSArray *keys=[result allKeys];
    //NSLog(@"%@",keys);
    NSString *requestType =[request.url stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""];
    
    NSDictionary *dict = result;
    
    if ([requestType isEqualToString:@"me/photos"]) 
    {
        NSLog(@"Got response for photo Upload");
    
        [fbManagerDelegate photoUploadStatus:YES];
        /* commening out the below part because fb doesn't support to include
         links to faebook photos in their streams */
#if 0        
        if(nil != photoId)
        {
            [photoId release];
        }
        
        photoId = [[NSString alloc]initWithString: [dict objectForKey:@"id"]];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(downloadPhotoOfId) userInfo:nil repeats:NO];
#endif        
    }
    else if((nil != photoId) && ([requestType isEqualToString:photoId]))
    {
        NSLog(@"Got response for photo download");
        if(nil != photoSrc)
        {
            [photoSrc release];
        }
        
        photoSrc = [[NSString alloc]initWithString:[dict objectForKey:@"source"]]; 
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(postToNewsFeed) userInfo:nil repeats:NO];
    }
    else if([requestType isEqualToString:@"feed"]) 
    {
        NSLog(@"Got response for feed : %@",dict);
    }
    else if([requestType isEqualToString:@"me/friends"])
    {
        NSArray *friends = [dict objectForKey:@"data"];
        
        for(int i = 0; i < [friends count];i++)
        {
            NSDictionary *pFriend = [friends objectAtIndex:i];
            NSLog(@"Friend %d): %@  %@",i,[pFriend objectForKey:@"name"],[pFriend objectForKey:@"id"]);
        }
    }
    else
    {
        NSLog(@"Unknown response type: %@",request);
    }   
};
#else
- (void)request:(FBRequest *)request didLoad:(id)result 
{
    
    //NSLog(@"%@",result);
    //NSArray *keys=[result allKeys];
    //NSLog(@"%@",keys);
    NSString *requestType =[request.url stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""];
    
    NSDictionary *dict = result;
    
    if ([requestType isEqualToString:@"me/photos"]) 
    {
        NSLog(@"Got response for photo Upload");
        
        [fbManagerDelegate photoUploadStatus:YES];
    }
    else if((nil != photoId) && ([requestType isEqualToString:photoId]))
    {
        NSLog(@"Got response for photo download");
        if(nil != photoSrc)
        {
            [photoSrc release];
        }
        
        photoSrc = [[NSString alloc]initWithString:[dict objectForKey:@"source"]]; 
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(postToNewsFeed) userInfo:nil repeats:NO];
    }
    else if([requestType isEqualToString:@"feed"]) 
    {
        NSLog(@"Got response for feed : %@",dict);
    }
    else if([requestType isEqualToString:@"me/friends"])
    {
        NSArray *friends = [dict objectForKey:@"data"];
        
        for(int i = 0; i < [friends count];i++)
        {
            NSDictionary *pFriend = [friends objectAtIndex:i];
            NSLog(@"Friend %d): %@  %@",i,[pFriend objectForKey:@"name"],[pFriend objectForKey:@"id"]);
        }
    }
    else if([requestType isEqualToString:@"me/albums"])
    {
        NSLog(@"albums : %@",dict);
    }
    else
    {
        NSLog(@"Unknown response type: %@",request);
    }   
};

#endif
/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{
    NSLog(@"FaceBookManager:%@",[error localizedDescription]);
    
    NSString *requestType =[request.url stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""];
    
    if ([requestType isEqualToString:@"me/photos"]) 
    {
        [fbManagerDelegate photoUploadStatus:NO];
    }
};


////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog 
{
    NSLog(@"FaceBookManager:published successfully");
}

- (void)getFriendsList
{
    //NSString *path = @"http://www.facebook.com/images/devsite/iphone_connect_btn.jpg";
    //NSURL *url = [NSURL URLWithString:path];
    //NSData *data = [NSData dataWithContentsOfURL:url];
    //UIImage *img  = [[UIImage alloc] initWithData:data];
    //NSString *message   = [NSString stringWithFormat:@"From Glow Labels Free Iphone App!!!!"];
    //NSData   *imageData = UIImagePNGRepresentation(photo);
    
    //NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                               imageData, @"file",message,@"message",
    //                               nil];
    
    
    [_facebook requestWithGraphPath:@"me/friends"
                        andDelegate:self];
    
    //[_facebook requestWithGraphPath:@"me/friends"
    //                      andParams:nil
    //                  andHttpMethod:@"GET"
    //                    andDelegate:self];
}

-(void)getMyAlbums
{
    [_facebook requestWithGraphPath:@"me/albums"
                        andDelegate:self];
}
@end
