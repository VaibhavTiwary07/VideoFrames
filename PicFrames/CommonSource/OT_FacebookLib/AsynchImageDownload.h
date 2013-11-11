//
//  AsynchImageDownload.h
//  FacebookIntegration
//
//  Created by Sunitha Gadigota on 6/15/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsynchImageDownload : NSObject

// This takes in a string and imagedata object and returns imagedata processed on a background thread
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;

@end
