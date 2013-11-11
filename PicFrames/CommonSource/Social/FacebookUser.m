//
//  FacebookUser.m
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 8/1/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "FacebookUser.h"


@implementation FacebookUser

@synthesize imgDelegate;

-(id)init
{
	self = [super init];
	if(NULL != self)
	{
		_fb = [fbmgr Instance];
        _fb.fbDelegate = self;
        bWaitingForLogin = NO;
        //loginTimer = nil;
        image = nil;
        linkToImage = nil;
        caption = nil;
        NSLog(@"FacebookUser init");
	}
	
	return self;
}

-(void)dealloc
{
    if(nil != image)
    {
        [image release];
        image = nil;
    }
    _fb.fbDelegate = nil;
    
    [super dealloc];
}

-(void)publishStream
{
    SBJsonWriter *jsonWriter = [[SBJsonWriter new] autorelease];
    
    NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:appname,@"text",applicationUrl,@"href", nil], nil];
    
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                fb_stream_heading, @"name",
                                fb_stream_caption, @"caption",
                                fb_stream_description, @"description",
                                applicationUrl, @"href", nil];
    NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   //@"Share on Facebook",  @"user_message_prompt",
                                   actionLinksStr, @"action_links",
                                   attachmentStr, @"attachment",
                                   nil];
    
    
    /*[_facebook dialog:@"feed"
     andParams:params
     andDelegate:self];*/
    [_fb._facebook dialog:@"stream.publish"
            andParams:params
          andDelegate:self];
}

-(void)checkLoginAndUploadPhotoToAppPage
{
    NSString *message   = [NSString stringWithFormat:@"%@ \nFrom %@ (%@) Iphone App!!!!",caption,appname,apptinyurl];
    //NSData   *imageData = UIImagePNGRepresentation(image);
    NSString *api = [NSString stringWithFormat:@"%@/feed",fbAppId];
    //NSString *api = [NSString stringWithFormat:@"me/feed"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   linkToImage,@"picture",@"www.photoandvideoapps.com",@"caption",linkToImage,@"link",@"Link To Image",@"name",message,@"message",nil];
    [linkToImage release];
    [caption release];
    linkToImage = nil;
    caption = nil;
    
    [_fb._facebook requestWithGraphPath:api
                              andParams:params
                          andHttpMethod:@"POST"
                            andDelegate:self];
}

-(void)checkLoginAndUploadPhotoToWall
{
    NSString *yozioLink = [Yozio getYozioLink:@"Facebook Viral tracking" channel:@"facebook" destinationUrl:ituneslinktoApp];
    NSString *message   = [NSString stringWithFormat:@"%@ \n%@ %@ (%@) %@",caption,NSLocalizedString(@"FROM", @"From"),appname,yozioLink,NSLocalizedString(@"IPHONEAPP", @"Iphone App!!!!")];
    //NSData   *imageData = UIImagePNGRepresentation(image);
    //NSString *api = [NSString stringWithFormat:@"%@/feed",fbAppId];
    NSString *api = [NSString stringWithFormat:@"me/feed"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   linkToImage,@"picture",@"www.photoandvideoapps.com",@"caption",linkToImage,@"link",NSLocalizedString(@"LINKTOIMAGE", @"Link To Image"),@"name",message,@"message",nil];
    [linkToImage release];
    [caption release];
    linkToImage = nil;
    caption = nil;
    
    [_fb._facebook requestWithGraphPath:api
                              andParams:params
                          andHttpMethod:@"POST"
                            andDelegate:self];
}

-(void)postOnAppsWallUsingImage:(NSString*)url messag:(NSString*)msg
{
    eCurCommand = FBUSRCMD_UPLOADPHOTO_GLOBAL;
    
    linkToImage = [url retain];
    caption = [msg retain];
    
    
    if(_fb._isLoggedIn)
    {
        NSLog(@"postOnAppsWallUsingImage: Already logged in");
        [self checkLoginAndUploadPhotoToAppPage];
    }
    else
    {
        NSLog(@"postOnAppsWallUsingImage: Waiting for log in");
        bWaitingForLogin = YES;
        [_fb login];
    }
}

-(void)postOnUserWallUsingImage:(NSString*)url messag:(NSString*)msg
{
    eCurCommand = FBUSRCMD_UPLOADPHOTO_USERWALL;
    
    linkToImage = [url retain];
    caption = [msg retain];
    
    
    if(_fb._isLoggedIn)
    {
        NSLog(@"postOnUserWallUsingImage: Already logged in");
        [self checkLoginAndUploadPhotoToWall];
    }
    else
    {
        NSLog(@"postOnUserWallUsingImage: Waiting for log in");
        bWaitingForLogin = YES;
        [_fb login];
    }
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{
}

- (void)request:(FBRequest *)request didLoad:(id)result 
{
    NSString *requestType =[request.url stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""];
    //NSString *api = [NSString stringWithFormat:@"%@/feed",fbAppId];
    NSString *api = [NSString stringWithFormat:@"%@/feed",fbAppId];
    //NSDictionary *dict = result; 
    
    /* Now Start a thread to process the photos and add them to scroll view */
    if([requestType isEqualToString:[NSString stringWithFormat:@"me/picture?type=large"]])
    {
        if ([result isKindOfClass:[NSData class]])
        {
            UIImage* profilePicture = [[UIImage alloc] initWithData: result];
            [imgDelegate imageSelected:profilePicture result:nil];
            [profilePicture release];
        }
    } 
    else if([requestType isEqualToString:[NSString stringWithFormat:@"me/photos"]])
    {
        if(eCurCommand == FBUSRCMD_UPLOADPHOTO)
        {
            [imgDelegate photoUploadStatus:YES result:nil];
            //[self publishStream];
            //[self release];
        }
        else if(eCurCommand == FBUSRCMD_SETPROFILEPHOTO)
        {
            NSDictionary *dict = result;
            //http://www.facebook.com/photo.php?fbid=[PID]&makeprofile=1
            //http://www.facebook.com/photo.php?fbid=[PID]&makeprofile=1
            NSString *cmd  = [NSString stringWithFormat:@"photo.php?fbid=[%s]&makeprofile=1",[[dict objectForKey:@"id"] UTF8String]];
            [_fb._facebook requestWithGraphPath:cmd
                                  andParams:nil
                              andHttpMethod:@"POST"
                                andDelegate:self];
        }
    }
    else if([requestType isEqualToString:[NSString stringWithFormat:@"me/feed"]])
    {
        [imgDelegate photoUploadStatus:YES result:nil];
        NSLog(@"%@ :Successfully posted",api);
    }
    else if([requestType isEqualToString:api])
    {
        [imgDelegate photoUploadStatus:YES result:nil];
        NSLog(@"%@ :Successfully posted",api);
    }
    else
    {
        NSLog(@"unknown result:%@",result);
    }
    
    [self release];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error 
{
    NSString *requestType =[request.url stringByReplacingOccurrencesOfString:@"https://graph.facebook.com/" withString:@""];
    //NSString *api = [NSString stringWithFormat:@"%@/feed",fbAppId];
    NSString *api = [NSString stringWithFormat:@"me/feed"];
    
    /* Now Start a thread to process the photos and add them to scroll view */
    if([requestType isEqualToString:[NSString stringWithFormat:@"me/picture?type=large"]])
    {
        [imgDelegate imageSelected:nil result:[error localizedDescription]];
    } 
    else if([requestType isEqualToString:[NSString stringWithFormat:@"me/photos"]])
    {
        [imgDelegate photoUploadStatus:NO result:[error localizedDescription]];
    } 
    else if([requestType isEqualToString:api])
    {
        [imgDelegate photoUploadStatus:NO result:[error localizedDescription]];
        NSLog(@"%@ failed: %@",api,[error localizedDescription]);
        NSLog(@"Err details: %@", [error description]);
    }
    
    [self release];

    return;
};

-(void)requestForProfilePhoto
{

    [_fb._facebook requestWithGraphPath:@"me/picture?type=large"
                            andDelegate:self];
}

-(void)setAsProfilePicture
{
    /* First upload the image and then */
    //http://www.facebook.com/photo.php?fbid=[PID]&makeprofile=1
}

-(void)getProfilePhoto
{
    if(_fb._isLoggedIn)
    {
        [self requestForProfilePhoto];
    }
    else
    {
        bWaitingForLogin = YES;
        eCurCommand = FBUSRCMD_GETPROFILEPHOTO;
        [_fb login];
    }
    
    return;
}

-(void)sendPhotoUploadRequest
{
    NSString *yozioLink = [Yozio getYozioLink:@"Facebook Viral tracking" channel:@"facebook" destinationUrl:ituneslinktoApp];
    NSString *message   = [NSString stringWithFormat:@"From Instapicframes %@ Iphone App!!!!",yozioLink];
    NSData   *imageData = UIImagePNGRepresentation(image);
    
#if FIX_FACEBOOK_NEGATIVEFEEDBACK
    message = nil;
#endif
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   imageData, @"file",message,@"message",
                                   nil];
    
    [_fb._facebook requestWithGraphPath:@"me/photos"
                              andParams:params
                          andHttpMethod:@"POST"
                            andDelegate:self];
}

-(void)checkLoginAndUploadPhoto
{
    if(_fb._isLoggedIn)
    {
        [self sendPhotoUploadRequest];
    }
    else
    {
        bWaitingForLogin = YES;
        [_fb login];
    }
}

-(void)uploadPhotoToAlbum:(UIImage *)photo
{
    eCurCommand = FBUSRCMD_UPLOADPHOTO;
    
    image = [photo retain];
    
    [self checkLoginAndUploadPhoto];
    
    return;
}

-(void)uploadPhotoAsProfilePhoto:(UIImage *)photo
{
    eCurCommand = FBUSRCMD_SETPROFILEPHOTO;
    
    image = [photo retain];
    
    [self checkLoginAndUploadPhoto];
    
    return;
}


- (void)loginStatus:(BOOL)isSuccess
{
    if(isSuccess)
    {
        if(bWaitingForLogin)
        {
            bWaitingForLogin = NO;
            if(eCurCommand == FBUSRCMD_GETPROFILEPHOTO)
            {
                [self getProfilePhoto];
            }
            else if(eCurCommand == FBUSRCMD_UPLOADPHOTO)
            {
                [self sendPhotoUploadRequest];
            }
            else if(eCurCommand == FBUSRCMD_UPLOADPHOTO_GLOBAL)
            {
                [self checkLoginAndUploadPhotoToAppPage];
            }
            else if(eCurCommand == FBUSRCMD_UPLOADPHOTO_USERWALL)
            {
                [self checkLoginAndUploadPhotoToWall];
            }
        }
        else
        {
        }
    }
    else
    {
        if((eCurCommand == FBUSRCMD_UPLOADPHOTO)||(eCurCommand == FBUSRCMD_UPLOADPHOTO_GLOBAL)||(eCurCommand == FBUSRCMD_UPLOADPHOTO_USERWALL))
        {
            if(nil != linkToImage)
            {
                [linkToImage release];
                linkToImage = nil;
            }
            
            if(nil != caption)
            {
                [caption release];
                caption = nil;
            }
            [imgDelegate photoUploadStatus:NO result:@"Facebook Login Failed/Canceled"];
        }
    }
}

@end
