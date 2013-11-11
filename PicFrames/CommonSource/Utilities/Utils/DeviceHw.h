//
//  DeviceHw.h
//  RND
//
//  Created by Vijaya kumar reddy Doddavala on 9/19/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceHw : NSObject 

typedef enum
{
    DEVICE_IPHONE1,
    DEVICE_IPHONE3G,
    DEVICE_IPHONE3GS,
    DEVICE_IPHONE4,
    DEVICE_IPOD1,
    DEVICE_IPOD2,
    DEVICE_IPOD3,
    DEVICE_IPOD4,
    DEVICE_IPAD1,
    DEVICE_IPAD2,
    DEVICE_SIMULATOR
}eDEVICE_TYPE;

typedef enum
{
    DEVICE_CAT_IPHONE,
    DEVICE_CAT_IPOD,
    DEVICE_CAT_IPAD,
    DEVICE_CAT_UNKNOWN
}eDEVICE_CAT;

+(BOOL)retinaSupport;
+(NSString*)platform;
+(NSString*)platformString;
+(eDEVICE_TYPE)platformType;
+(CGSize)optimizedSize;
+(eDEVICE_CAT)platformCatageory;
+(int)optimizedResolution;
@end
