//
//  OT_Facebook.m
//  FacebookIntegration
//
//  Created by Sunitha Gadigota on 5/26/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import "OT_Facebook.h"
#import <objc/runtime.h>
#import "FacebookAlbumList.h"
#import "AsynchImageDownload.h"

static OT_Facebook *OT_FacebookSingleton = nil;

@implementation OT_Facebook

- (void)receiveNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:OT_FBBackgroundImageSelected])
    {
        [self unregisterForNotifications];
        
        if(nil == notification.userInfo)
        {
            return;
        }
        
        void (^callback)(UIImage *selectedImage) = objc_getAssociatedObject(self, "facebookImageSelectionCallback");
        if(nil != callback)
        {
            UIImage *image = [notification.userInfo objectForKey:OT_FBBackgroundImageKey];
            callback(image);
        }
    }
    
    return;
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

-(void)profilePhoto:(void(^)(UIImage *profilePhoto))completion
{
    [self loginToFacebook:YES onCompletion:^(BOOL loginStatus){
        if(NO == loginStatus)
        {
            completion(nil);
            return ;
        }
        
        NSDictionary *param = [NSDictionary dictionaryWithObject:@"picture" forKey:@"fields"];
        [FBRequestConnection startWithGraphPath:@"me" parameters:param HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, NSDictionary *user, NSError *error){
            
            NSDictionary *picture = [[user objectForKey:@"picture"]objectForKey:@"data"];
            NSString *urlStr      = [picture objectForKey:@"url"];
            [AsynchImageDownload processImageDataWithURLString:urlStr andBlock:^(NSData *imageData)
             {
                 UIImage *image  = [UIImage imageWithData:imageData];
                 completion(image);
             }];
            NSLog(@"ProfilePhoto %@ error %@",user,error.localizedDescription);
        }];
    }];
    
}

- (void)uploadImageToOurServer:(UIImage*)image onCompletion:(void (^)(BOOL uploadStatus,NSString *imgaeUrl))completion
{
    if(nil == image)
    {
        completion(NO,nil);
        return;
    }
    
    //[Utility addActivityIndicatotTo:view withMessage:NSLocalizedString(@"UPLOADING",@"Uploading")];
    
    NSString *uuid = nil;
    CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
    if (theUUID)
    {
        uuid = NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID));
        [uuid autorelease];
        CFRelease(theUUID);
    }
    else
    {
        completion(NO,nil);
        return;
    }
    
	/*
	 turning the image into a NSData object
	 setting the quality to 90
     */
	NSData *imageData = UIImageJPEGRepresentation(image, 90);
	// setting up the URL to post to
	NSString *urlString = @"http://photoandvideoapps.com/test-upload.php";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
    NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",uuid] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
    NSError *error = nil;
    NSURLResponse *res = nil;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    if(nil != error)
    {
        NSLog(@"Error: %@",[error localizedDescription]);
        completion(NO,nil);
        return;
    }
    
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    completion(YES,returnString);
    
    return;
}

-(void)postOnWallWithImageUrl:(NSString *)linkToImage
                      message:(NSString *)msg
                      website:(NSString *)website
                         name:(NSString *)name
                  description:(NSString *)description
                      caption:(NSString *)caption
                 onCompletion:(void (^)(BOOL uploadStatus))completion
{
    [self loginToFacebook:YES onCompletion:^(BOOL loginStatus){
        if(NO == loginStatus)
        {
            NSLog(@"Failed to login to facebook to post to the wall");
            completion(NO);
            return ;
        }
        
        [self performPublishAction:^
         {
        
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:linkToImage,@"picture",caption,@"caption",website,@"link",name,@"name",msg,@"message",description,@"description",nil];
            /* post the story to facebook */
            [FBRequestConnection startWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                 if(nil == error)
                 {
                     completion(YES);
                 }
                 else
                 {
                     completion(NO);
                 }
             }];
         }];
    }];
}

-(void)postOnWallWithImage:(UIImage *)image message:(NSString *)msg website:(NSString*)website onCompletion:(void (^)(BOOL uploadStatus))completion
{
    [self loginToFacebook:YES onCompletion:^(BOOL loginStatus){
        if(NO == loginStatus)
        {
            NSLog(@"Failed to login to facebook to post to the wall");
            completion(NO);
            return ;
        }
        [self performPublishAction:^
         {
            /* we cannot post the image onto wall directly, but we can post using the link, to generate link first
             upload the image to our server */
            [self uploadImageToOurServer:image onCompletion:^(BOOL uploadStatus, NSString *linkToImage){
                
                if(NO == uploadStatus)
                {
                    NSLog(@"Failed to upload the image to our server");
                    completion(NO);
                    return ;
                }
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               linkToImage,@"picture",@"www.photoandvideoapps.com",@"caption",linkToImage,@"link",NSLocalizedString(@"LINKTOIMAGE", @"Link To Image"),@"name",msg,@"message",nil];
                /* post the story to facebook */
                [FBRequestConnection startWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
                {
                    if(nil == error)
                    {
                        completion(YES);
                    }
                    else
                    {
                        completion(NO);
                    }
                }];
            }];
         }];
    }];
}

-(void)selectImageUsing:(id)vc onCompletion:(void (^)(UIImage *selectedImage))completion
{
    [self loginToFacebook:YES onCompletion:^(BOOL loginStatus)
    {
        if(NO == loginStatus)
        {
            NSLog(@"Failed to login to facebook to post to the wall");
            completion(NO);
            return ;
        }
        
        objc_setAssociatedObject(self, "facebookImageSelectionCallback", [completion copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [self registerForNotifications];
        UIViewController *viewController = vc;
        FacebookAlbumList *alist = [[FacebookAlbumList alloc]initWithStyle:UITableViewStyleGrouped];
        [viewController.navigationController pushViewController:alist animated:YES];
        [alist release];
    }];
}

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        if (error.fberrorShouldNotifyUser ||
            error.fberrorCategory == FBErrorCategoryPermissions ||
            error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
            alertMsg = error.fberrorUserMessage;
        } else {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)uploadImage:(UIImage*)image withMessage:(NSString*)msg onCompletion:(void (^)(BOOL uploadStatus))completion
{
    [self loginToFacebook:YES onCompletion:^(BOOL loginStatus)
    {
        if(NO == loginStatus)
        {
            NSLog(@"Failed to login to facebook to post to the wall");
            completion(NO);
            return ;
        }
        
        [self performPublishAction:^
        {
            NSData   *imageData = UIImagePNGRepresentation(image);
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           imageData, @"file",msg,@"message",
                                           nil];
            
            [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                 BOOL uploadSuccess = YES;
                 
                 //Check if the upload is failed
                 if(error)
                 {
                     uploadSuccess = NO;
                 }
                 
                 completion(uploadSuccess);
             }];
        }];
    }];
    
}
-(void)uploadVideo:(NSString *)videoFile withMessage:(NSString*)msg onCompletion:(void (^)(BOOL uploadStatus))completion
{
    [self loginToFacebook:YES onCompletion:^(BOOL loginStatus)
     {
         if(NO == loginStatus)
         {
             NSLog(@"Failed to login to facebook to post to the wall");
             completion(NO);
             return ;
         }

         [self performPublishAction:^
          {
              //   NSData   *imageData = UIImagePNGRepresentation(image);

              NSString *filePath = videoFile;
              NSURL *pathURL = [[NSURL alloc]initFileURLWithPath:filePath isDirectory:NO];
              NSData *videoData = [NSData dataWithContentsOfFile:filePath];
              NSDictionary *videoObject = @{
                                            @"title": @"VideoFrames",
                                            @"description": msg,
                                            [pathURL absoluteString]: videoData
                                            };
              [FBRequestConnection startWithGraphPath:@"me/videos" parameters:videoObject HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
               {
                   BOOL uploadSuccess = YES;

                   //Check if the upload is failed
                   if(error)
                   {
                       uploadSuccess = NO;
                   }

                   completion(uploadSuccess);
               }];
          }];
     }];
    
}

-(void)performPublishStreamAction:(void (^)(void)) action
{
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_stream"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
}

- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"Session State %d",state);
    switch (state)
    {
        case FBSessionStateCreated:
        {
            NSLog(@"Session State FBSessionStateCreated");
            break;
        }
        case FBSessionStateCreatedTokenLoaded:
        {
            NSLog(@"Session State FBSessionStateCreatedTokenLoaded");
            break;
        }
        case FBSessionStateCreatedOpening:
        {
            NSLog(@"Session State FBSessionStateCreatedTokenLoaded");
            break;
        }
        case FBSessionStateOpen:
        {
            NSLog(@"Session State FBSessionStateOpen");
            if (!error)
            {
                // We have a valid session
                NSLog(@"User session found");
                void (^comp)(BOOL loginStatus) = objc_getAssociatedObject(self, "loginStatusCallback");
                if(nil != comp)
                {
                    comp(YES);
                }
                objc_setAssociatedObject(self, "loginStatusCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            break;
        }
        case FBSessionStateClosed:
        {
            NSLog(@"Session State FBSessionStateClosed");
            break;
        }
        case FBSessionStateClosedLoginFailed:
        {
            NSLog(@"Session State FBSessionStateClosedLoginFailed");
            [FBSession.activeSession closeAndClearTokenInformation];
            void (^comp)(BOOL loginStatus) = objc_getAssociatedObject(self, "loginStatusCallback");
            if(nil != comp)
            {
                comp(NO);
            }
            objc_setAssociatedObject(self, "loginStatusCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        }
        default:
        {
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:OT_FBSessionStateChangedNotification
     object:session];
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

-(void)loginToFacebook:(BOOL)allowLoginUI onCompletion:(void(^)(BOOL loginStatus))completion
{
    FBSession *curActiveSession = [FBSession activeSession];
    if(nil != curActiveSession)
    {
        if(curActiveSession.isOpen)
        {
            NSLog(@"Session is already open");
            completion(YES);
            return;
        }
    }
    
    //Store the callback
    objc_setAssociatedObject(self, "loginStatusCallback", [completion copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      [self sessionStateChanged:session
                                                          state:state
                                                          error:error];
                                  }];
}

-(void)handleApplicationDidBecomeActive
{
    [FBSession.activeSession handleDidBecomeActive];
}

-(void)handleApplicationWillTerminate
{
    [FBSession.activeSession close];
}

-(BOOL)handleOpenUrl:(NSURL *)url
{
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

-(void)closeSession
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

-(void)getMyInfo
{
    [FBRequestConnection startWithGraphPath:@"me/albums" completionHandler:^(FBRequestConnection *connection, NSDictionary *user, NSError *error){
        NSDictionary *dict = user;
        //NSLog(@"User Info %@",user);
        {
            albums = [[dict objectForKey:@"data"] retain];
            NSLog(@"Album count is %d",[albums count]);
            if([albums count] > 0)
            {
                if(nil == coverphotos)
                {
                    coverphotos = [[NSMutableDictionary alloc]initWithCapacity:[albums count]];
                }
                else
                {
                    [coverphotos release];
                    coverphotos = [[NSMutableDictionary alloc]initWithCapacity:[albums count]];
                }
                
                /* Now request for the cover photos of the album */
                for(int index = 0; index < [albums count]; index++)
                {
                    NSDictionary *album = [albums objectAtIndex:index];
                    
                    if(nil != [album objectForKey:@"cover_photo"])
                    {
                        NSLog(@"Album %@",album);
             //           [_fb._facebook requestWithGraphPath:[album objectForKey:@"cover_photo"]
             //                                   andDelegate:[self retain]];
                    }
                }
            }
        }}];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        return self;
    }
    
    return self;
}

+(OT_Facebook*)SharedInstance
{
    @synchronized([OT_Facebook class])
	{
        if (OT_FacebookSingleton == nil)
		{
            [[self alloc] init]; // assignment not done here
        }
    }
	
    return OT_FacebookSingleton;
}


+(id)allocWithZone:(NSZone *)zone
{
    @synchronized([OT_Facebook class])
	{
        if (OT_FacebookSingleton == nil)
		{
            OT_FacebookSingleton = [super allocWithZone:zone];
            return OT_FacebookSingleton;  // assignment and return on first allocation
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
