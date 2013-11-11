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
#import "FacebookUser.h"
#import "FacebookAlbumList.h"
#import "Settings.h"

//@protocol BackgroundManagerDelegate 
//-(void)sessionSelected:(Session*)sess;
//@end

@interface BackgroundManager : UITableViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate/*,FacebookAlbumListDelegate*/,FacebookUserDelegate>
{
//    id <BackgroundManagerDelegate> actionDelegate;
    
    fbmgr *mg;
    int iCurrentSessionIndex;
    FacebookUser *fbUser;
    Settings *nvm;
}

//@property(assign)id <BackgroundManagerDelegate> actionDelegate;

@end
