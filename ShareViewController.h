//
//  ShareViewController.h
//  VideoFrames
//
//  Created by Deepti's Mac on 1/24/14.
//
//

#import <UIKit/UIKit.h>
#import "Session.h"
@interface ShareViewController : UIViewController
{
    Settings *nvm;
}
@property(nonatomic,assign) float frameSize;
@property(nonatomic , retain) NSString *videoPath;
@property (nonatomic, assign) bool isVideo;
@property (nonatomic, retain) Session *sess;
@end
