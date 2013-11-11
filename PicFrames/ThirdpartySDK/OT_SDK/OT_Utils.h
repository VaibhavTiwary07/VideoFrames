//
//  OT_Utils.h
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 7/26/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    char applistVer[256];
}OT_Settings;

@interface OT_Utils : NSObject

+(NSString*)getCurrentOTApplistVersion;
+(void)setCurrentOTApplistVersion:(NSString*)ver;
+(BOOL)isOTApplistVersionIsSameAs:(NSString*)ver;
+(void)deleteAllIcons;
+(void)saveIcon:(UIImage*)img ForApp:(NSString*)appid;
+(UIImage *)getIconForApp:(NSString*)appId;
@end
