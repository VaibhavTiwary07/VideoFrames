//
//  flurryAdconfig.h
//  videoAds
//
//  Created by Vijaya kumar reddy Doddavala on 3/30/13.
//  Copyright (c) 2013 Vijaya kumar reddy Doddavala. All rights reserved.
//
#import "videoAds.h"
#if FLURRY_SUPPORT
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface flurryAdconfig : NSObject

+ (flurryAdconfig *)sharedInstance;
-(void)initAdNetworkWithKeys:(NSMutableDictionary*)keys;
-(void)playVideoAtSpot:(int)spot inController:(UIViewController*)vc withCompletion:(void (^)(BOOL filled,BOOL watched))completion;
@end
#endif