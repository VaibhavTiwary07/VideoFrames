//
//  videoAds.h
//  videoAds
//
//  Created by Vijaya kumar reddy Doddavala on 3/28/13.
//  Copyright (c) 2013 Vijaya kumar reddy Doddavala. All rights reserved.
//

//-force_load $(SRCROOT)/videoAds/Adcolony/Library/libAdColony.a
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define ADCOLONY_SUPPORT    1
#define VUNGLE_SUPPORT      1
#define FLURRY_SUPPORT      1
#define videoads_adcolony_dictionary_key   @"adcolony"
#define videoads_flurry_dictionary_key     @"flurry"
#define videoads_vungle_dictionary_key     @"vungle"
#define videoads_vungle_sdkkey             @"vungle_sdkkey"
#define videoads_flurry_sdkkey             @"flurry_sdkkey"
#define videoads_flurry_appspotkey         @"flurry_appspotkey"
#define videoads_flurry_rootviewcontroller @"flurry_rootviewcontroller"
#define videoads_adcolony_sdkkey           @"adcolony_sdkkey"
#define videoads_adcolony_zone1key         @"adcolony_zone1key"
#define videoads_adcolony_zone2key         @"adcolony_zone2key"

#define videoads_common_agekey             @"videoads_common_agekey"
#define videoads_common_genderkey          @"videoads_common_genderkey"
#define videoads_common_locationkey        @"videoads_common_locationkey"
#define videoads_common_orientationkey     @"videoads_common_orientationkey"

typedef enum
{
    eVideoAdNotAvailable,
    eVideoAdUsedCanceledTheAd,
    eVideoAdSuccessfullyCompleted
}eVideoAdStatusCode;

@interface videoAds : NSObject

+ (videoAds *)sharedInstance;
-(void)initializeAdNetworksWithIds:(NSMutableDictionary*)ids;
-(void)showVideoInViewController:(UIViewController*)vc withCompletion:(void (^)(eVideoAdStatusCode eStatus))completion;

-(void)showVideosInViewController:(UIViewController*)vc ofCount:(int)count toUnlock:(NSString*)rewardName withStatusUpdate:(void (^)(eVideoAdStatusCode eStatusCode,int remainingVideos))statusUpdate;
@end
