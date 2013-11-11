//
//  FacebookAlbum.h
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 7/24/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fbmgr.h"

/* Facebook Album Photo Display Configuration */
#define FB_ALBUM_IMAGES_PER_ROW     3
#define FB_ALBUM_GAP_BETWEEN_IMAGES 5.0

//@protocol FacebookAlbumDelegate 
//-(void)imageSelected:(UIImage *)img result:(NSString*)res;
//@end

@interface FacebookAlbum : UIViewController <fbmgrDelegate,FBRequestDelegate>
{
    UIScrollView *pAlbum;
    NSString     *pAlbumId;
    NSArray      *photos;
    int           photoIndex;
    
    fbmgr    *_fb;
    
//    id <FacebookAlbumDelegate> imgDelegate;
    NSThread *photoRetrieveThread;
    BOOL exiting;
}

@property(nonatomic,retain)NSString *pAlbumId;
//@property(assign)id <FacebookAlbumDelegate> imgDelegate;

@end
