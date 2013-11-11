//
//  videoAds.m
//  videoAds
//
//  Created by Vijaya kumar reddy Doddavala on 3/28/13.
//  Copyright (c) 2013 Vijaya kumar reddy Doddavala. All rights reserved.
//
#import "videoAds.h"
#import <objc/runtime.h>
#if ADCOLONY_SUPPORT
#import "adColonyAdconfig.h"
#endif
#if FLURRY_SUPPORT
#import "flurryAdconfig.h"
#endif
#if VUNGLE_SUPPORT
#import "vungleAdconfig.h"
#endif

#define VIDEOADS_NEXTVIDEOALERT_TAG  1001
#define TIMEGAP_BETWEEN_VIDEOS       1.0
@interface videoAds() <UIAlertViewDelegate>

@end

@implementation videoAds
static videoAds *singletonDelegate = nil;

-(void)initializeAdNetworksWithIds:(NSMutableDictionary*)ids
{
#if ADCOLONY_SUPPORT
    NSMutableDictionary *adcolony = [ids objectForKey:videoads_adcolony_dictionary_key];
    if(nil != adcolony)
    {
        [[adColonyAdconfig sharedInstance]initAdNetworkWithKeys:adcolony];
    }
#endif
#if FLURRY_SUPPORT
    NSMutableDictionary *flurry = [ids objectForKey:videoads_flurry_dictionary_key];
    if(nil != flurry)
    {
        [[flurryAdconfig sharedInstance]initAdNetworkWithKeys:flurry];
    }
#endif
#if VUNGLE_SUPPORT
    NSMutableDictionary *vungle = [ids objectForKey:videoads_vungle_dictionary_key];
    if(nil != vungle)
    {
        [[vungleAdconfig sharedInstance]initAdNetworkWithKeys:vungle];
    }
#endif
}

-(void)showVideoInViewController:(UIViewController*)vc withCompletion:(void (^)(eVideoAdStatusCode eStatus))completion
{

    [[adColonyAdconfig sharedInstance]playVideoAtSpot:1 inController:(UIViewController*)vc withCompletion:^(BOOL filled, BOOL watched)
    {
        if(NO == filled)
        {
            [[flurryAdconfig sharedInstance]playVideoAtSpot:1 inController:(UIViewController*)vc withCompletion:^(BOOL filled, BOOL watched){
                if(NO == filled)
                {

                    [[vungleAdconfig sharedInstance]playVideoAtSpot:1 inController:(UIViewController*)vc withCompletion:^(BOOL filled, BOOL watched){
                        if(filled == NO)
                        {
                            completion(eVideoAdNotAvailable);
                        }
                        else if(watched == NO)
                        {
                            completion(eVideoAdUsedCanceledTheAd);
                        }
                        else
                        {
                            completion(eVideoAdSuccessfullyCompleted);
                        }
                        //NSLog(@"Show Video Status is %d !!!!!!!!!!!!!!!",success);
                    }];
                }
                else
                {
                    if(watched == NO)
                    {
                        completion(eVideoAdUsedCanceledTheAd);
                    }
                    else
                    {
                        completion(eVideoAdSuccessfullyCompleted);
                    }
                }
                //NSLog(@"Show Video Status is %d !!!!!!!!!!!!!!!",success);
            }];
        }
        else
        {
            if(watched == NO)
            {
                completion(eVideoAdUsedCanceledTheAd);
            }
            else
            {
                completion(eVideoAdSuccessfullyCompleted);
            }
        }
    }];
}

#if 0
-(void)showVideosInViewController:(UIViewController*)vc ofCount:(int)count toUnlock:(NSString*)rewardName withStatusUpdate:(void (^)(eVideoAdStatusCode eStatusCode,int remainingVideos))statusUpdate
{
    objc_setAssociatedObject(self, "showVideoTestInCallback", [statusUpdate copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, "showVideosRewardName", [rewardName copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self showVideoInViewController:vc withCompletion:^(eVideoAdStatusCode eStatus){
        if(eStatus == eVideoAdSuccessfullyCompleted)
        {
            [self requestForNextVideoToPlayOfRemaining:(count-1) withCompletion:^(BOOL bPlayVideo){
                if(bPlayVideo)
                {
                    NSDictionary *usrInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(count-1)],@"videocount",vc,@"viewController", nil];
                    
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showNextVideo:) userInfo:usrInfo repeats:NO];
                }
                else
                {
                    statusUpdate(eVideoAdUsedCanceledTheAd,count-1);
                    objc_setAssociatedObject(self, "showVideoTestInCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    objc_setAssociatedObject(self, "showVideosRewardName", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
            }];
            
        }
        else
        {
            statusUpdate(eStatus,count);
            objc_setAssociatedObject(self, "showVideoTestInCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(self, "showVideosRewardName", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }];
}
#else
-(void)showVideosInViewController:(UIViewController*)vc ofCount:(int)count toUnlock:(NSString*)rewardName withStatusUpdate:(void (^)(eVideoAdStatusCode eStatusCode,int remainingVideos))statusUpdate
{
    objc_setAssociatedObject(self, "showVideoTestInCallback", [statusUpdate copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, "showVideosRewardName", [rewardName copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSDictionary *usrInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(count)],@"videocount",vc,@"viewController", nil];
    
    [NSTimer scheduledTimerWithTimeInterval:TIMEGAP_BETWEEN_VIDEOS target:self selector:@selector(showNextVideo:) userInfo:usrInfo repeats:NO];
/*
    [self showVideoInViewController:vc withCompletion:^(eVideoAdStatusCode eStatus){
        if(eStatus == eVideoAdSuccessfullyCompleted)
        {
            [self requestForNextVideoToPlayOfRemaining:(count-1) withCompletion:^(BOOL bPlayVideo){
                if(bPlayVideo)
                {
                    NSDictionary *usrInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(count-1)],@"videocount",vc,@"viewController", nil];
                    
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showNextVideo:) userInfo:usrInfo repeats:NO];
                }
                else
                {
                    statusUpdate(eVideoAdUsedCanceledTheAd,count-1);
                    objc_setAssociatedObject(self, "showVideoTestInCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    objc_setAssociatedObject(self, "showVideosRewardName", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                }
            }];
            
        }
        else
        {
            statusUpdate(eStatus,count);
            objc_setAssociatedObject(self, "showVideoTestInCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(self, "showVideosRewardName", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }];*/
    
}
#endif

-(void)requestForNextVideoToPlayOfRemaining:(int)videosToPlay withCompletion:(void (^)(BOOL bPlayVideo))completion
{
    if(videosToPlay == 0)
    {
        completion(YES);
        return;
        
    }
    
    objc_setAssociatedObject(self, "alertViewBlockCallback", [completion copy],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSString *rewardName = objc_getAssociatedObject(self, "showVideosRewardName");
    NSString *message = [NSString stringWithFormat:@"You have %d more videos to %@, Would you like to Continue?", videosToPlay,rewardName];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Continue" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    alert.tag = VIDEOADS_NEXTVIDEOALERT_TAG;
    [alert show];
    [alert release];
}

/* This is required to makesure that no alert screen is completely exited from screen, some
 ads won't work if the alertview is still active*/
-(void)sendDelayedAlertStatus:(NSTimer*)timer
{
    int buttonIndex = [[timer.userInfo objectForKey:@"ButtonIndex"]integerValue];
    void (^comp)(BOOL bPlayVideo) = objc_getAssociatedObject(self, "alertViewBlockCallback");
    if(nil != comp)
    {
        if(buttonIndex == 1)
        {
            NSLog(@"User Continued To Watch Videos!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            comp(YES);
        }
        else
        {
            NSLog(@"User Canceled To Watch Videos!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            comp(NO);
        }
        
        objc_setAssociatedObject(self, "alertViewBlockCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == VIDEOADS_NEXTVIDEOALERT_TAG)
    {
#if 1
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:buttonIndex] forKey:@"ButtonIndex"];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendDelayedAlertStatus:) userInfo:dict repeats:NO];
#else
        void (^comp)(BOOL bPlayVideo) = objc_getAssociatedObject(self, "alertViewBlockCallback");
        if(nil != comp)
        {
            if(buttonIndex == 1)
            {
                comp(YES);
            }
            else
            {
                comp(NO);
            }
            
            objc_setAssociatedObject(self, "alertViewBlockCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        }
#endif
    }
}

-(void)showNextVideo:(NSTimer*)timer
{
    void (^comp)(eVideoAdStatusCode eStatusCode,int remainingVideos) = objc_getAssociatedObject(self, "showVideoTestInCallback");
    if(nil != comp)
    {
        int count = [[timer.userInfo objectForKey:@"videocount"]integerValue];
        id vc = [timer.userInfo objectForKey:@"viewController"];
        
        if(0 == count)
        {
            comp(eVideoAdSuccessfullyCompleted,count);
            objc_setAssociatedObject(self, "showVideoTestInCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(self, "showVideosRewardName", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return;
        }
        
        [self showVideoInViewController:vc withCompletion:^(eVideoAdStatusCode eStatus){
            if(eStatus == eVideoAdSuccessfullyCompleted)
            {
                [self requestForNextVideoToPlayOfRemaining:(count-1) withCompletion:^(BOOL bPlayVideo){
                    if(bPlayVideo)
                    {
                        NSDictionary *usrInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(count-1)],@"videocount",vc,@"viewController", nil];
                        
                        [NSTimer scheduledTimerWithTimeInterval:TIMEGAP_BETWEEN_VIDEOS target:self selector:@selector(showNextVideo:) userInfo:usrInfo repeats:NO];
                    }
                    else
                    {
                        comp(eVideoAdUsedCanceledTheAd,count-1);
                        objc_setAssociatedObject(self, "showVideoTestInCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        objc_setAssociatedObject(self, "showVideosRewardName", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    }
                }];
            }
            else
            {
                comp(eStatus,count);
                objc_setAssociatedObject(self, "showVideoTestInCallback", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(self, "showVideosRewardName", nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }];
    }
    else
    {
        NSLog(@"showNextVideo: completion block is nil");
    }
}

/* Singleton implementation */
- (id)init
{
    self = [super init];
    if(nil != self)
    {
        /* For now we don't have anything to initialize here. */

    }
    return self;
}

+ (videoAds *)sharedInstance {
	@synchronized(self) {
		if (singletonDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return singletonDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (singletonDelegate == nil) {
			singletonDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return singletonDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}

@end
