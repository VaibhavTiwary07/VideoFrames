//
//  FreeAppsList.h
//  vj
//
//  Created by Vijaya kumar reddy Doddavala on 8/12/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuartzCore/CALayer.h"
#import "onlineapplist.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "config.h"

@interface FreeAppsList : UITableView <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int iAppCount;
    
    onlineapplist *applist;
    NSThread      *imgRetriveThread;
    BOOL           exiting;
}

@end
