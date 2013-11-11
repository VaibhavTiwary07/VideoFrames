//
//  FacebookAlbumList.h
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 7/21/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"
#import "Facebook.h"
#import "fbmgr.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "FacebookAlbum.h"
#import "Utility.h"

//@protocol FacebookAlbumListDelegate 
//-(void)imageSelected:(UIImage *)img result:(NSString*)res;
//@end

@interface FacebookAlbumList : UITableViewController<FBRequestDelegate,fbmgrDelegate/*,FacebookAlbumDelegate*/> 
{
    fbmgr    *_fb;
    Facebook *_facebook;
    BOOL     bWaitingForLogin;
    
    NSArray *albums;
    NSMutableDictionary *coverphotos;
    
    //id <FacebookAlbumListDelegate> imgDelegate;
    //id imgDelegate;
    NSThread *albumRetrieveThread;
}

//@property(assign)id <FacebookAlbumListDelegate> imgDelegate;
//@property(assign)id imgDelegate;
@end
