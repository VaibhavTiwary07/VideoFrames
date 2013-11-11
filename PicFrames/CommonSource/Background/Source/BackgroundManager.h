//
//  BackgroundManager.h
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 8/30/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "FMDatabase.h"
#import "Session.h"
#import "OT_Facebook.h"
#import "FacebookAlbumList.h"
#import "Settings.h"

@protocol BackgroundManagerDelegate 
-(void)imageSelected:(UIImage*)img;
@end

@interface BackgroundManager : UITableViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate>
{
    id <BackgroundManagerDelegate> actionDelegate;
    
    int iCurrentSessionIndex;
    Settings *nvm;
}

@property(assign)id <BackgroundManagerDelegate> actionDelegate;

@end
