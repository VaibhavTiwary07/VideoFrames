//
//  DeviceHw.m
//  RND
//
//  Created by Vijaya kumar reddy Doddavala on 9/19/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import "DeviceHw.h"
#include <sys/sysctl.h>

@implementation DeviceHw

+(NSString*)platform
{
    size_t size;
    char *machine = NULL;
    
    /* First get the size */
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    /* Allocate the memory */
    machine = malloc(size);
    if(NULL == machine)
    {
        return nil;
    }
    
    /* Get the data again */
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    /* Now get the platform string */
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    
    /* Now deallocate the meory */
    free(machine);
    
    return platform;
}

+(eDEVICE_TYPE)platformType
{
    eDEVICE_TYPE eType = DEVICE_IPHONE3G;
    
    NSString *platform = [self platform];
    if([platform isEqualToString:@"iPhone1,1"])
    {
        eType = DEVICE_IPHONE1;
    }
    else if([platform isEqualToString:@"iPhone1,2"])
    {
        eType = DEVICE_IPHONE3G;
    }
    else if([platform isEqualToString:@"iPhone2,1"])
    {
        eType = DEVICE_IPHONE3GS;
    }
    else if([platform isEqualToString:@"iPhone3,1"])
    {
        eType = DEVICE_IPHONE4;
    }
    else if([platform isEqualToString:@"iPhone3,2"])
    {
        eType = DEVICE_IPHONE4;
    }
    else if([platform isEqualToString:@"iPod1,1"])
    {
        eType = DEVICE_IPOD1;
    }
    else if([platform isEqualToString:@"iPod2,1"])
    {
        eType = DEVICE_IPOD2;
    }
    else if([platform isEqualToString:@"iPod3,1"])
    {
        eType = DEVICE_IPOD3;
    }
    else if([platform isEqualToString:@"iPod4,1"])
    {
        eType = DEVICE_IPOD4;
    }
    else if([platform isEqualToString:@"iPad"])
    {
        eType = DEVICE_IPAD1;
    }
    else if([platform isEqualToString:@"iPad2,1"])
    {
        eType = DEVICE_IPOD2;
    }
    else if([platform isEqualToString:@"iPad2,2"])
    {
        eType = DEVICE_IPOD2;
    }
    else if([platform isEqualToString:@"iPod2,3"])
    {
        eType = DEVICE_IPOD2;
    }
    else if([platform isEqualToString:@"i386"])
    {
        eType = DEVICE_SIMULATOR;
    }
    
    return eType;
}

+(BOOL)retinaSupport
{
    BOOL bSupport = NO;
    
    if([[UIScreen mainScreen] respondsToSelector:NSSelectorFromString(@"scale")])
    {
        if([[UIScreen mainScreen] scale] < 1.1)
        {
            bSupport = NO;
        }
        
        if([[UIScreen mainScreen] scale] > 1.9)
        {
            bSupport = YES;
        }
    }
    
    return bSupport;
}

+(eDEVICE_CAT)platformCatageory
{
    eDEVICE_CAT eType = DEVICE_CAT_IPHONE;
    
    NSString *platform = [self platform];
    if([platform hasPrefix:@"iPhone"])
    {
        eType = DEVICE_CAT_IPHONE;
    }
    else if([platform hasPrefix:@"iPod"])
    {
        eType = DEVICE_CAT_IPOD;
    }
    else if([platform hasPrefix:@"iPad"])
    {
        eType = DEVICE_CAT_IPAD;
    }
    
    return eType;
}

+(CGSize)optimizedSize
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat scale;
    
    if([DeviceHw retinaSupport])
    {
        scale = [[UIScreen mainScreen]scale];
        size = CGSizeMake(rect.size.width * scale, rect.size.height * scale);
    }

    return size;
}

+(int)optimizedResolution
{
    CGSize size = [DeviceHw optimizedSize];
    
    if(size.width > size.height)
    {
        return (int)size.width;
    }
    
    return (int)size.height;
}

+(NSString*)platformString
{
    return nil;
}

@end
