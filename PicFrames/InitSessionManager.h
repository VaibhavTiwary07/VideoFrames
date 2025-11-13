//
//  InitSessionManager.h
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 12/21/11.
//  Copyright (c) 2011 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"
#import "config.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "FMDatabase.h"
#import "Session.h"
#import "Settings.h"
#import "FrameViewController.h"

#define TAG_SESSION_BEGIN (3000)
#define TAG_SESSION_ICON  (TAG_SESSION_BEGIN + 1)
#define TAG_SESSION_LBL1  (TAG_SESSION_BEGIN + 2)
#define TAG_SESSION_LBL2  (TAG_SESSION_BEGIN + 3)
#define TAG_SESSION_LBL3  (TAG_SESSION_BEGIN + 4)

@interface InitSessionManager : UITableViewController
{
        Settings *nvm;
}
@end
