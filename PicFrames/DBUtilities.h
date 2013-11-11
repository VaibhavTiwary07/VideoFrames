//
//  DBUtilities.h
//  PicFrame
//
//  Created by Vijaya kumar reddy Doddavala on 2/28/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define PICFARME_DATABASE @"PicFrame.sql"

@interface DBUtilities : NSObject

+(FMDatabase*)openDataBase;
+(void)checkAndCreateDatabase;
@end
