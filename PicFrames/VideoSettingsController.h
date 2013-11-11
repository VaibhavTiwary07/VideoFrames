//
//  VideoSettingsController.h
//  VideoFrames
//
//  Created by Sunitha Gadigota on 10/15/13.
//
//

#import <UIKit/UIKit.h>

@class VideoSettingsController;
@protocol VideoSettingsControllerDelegate <NSObject>
@optional
- (int)numberOfVideosSelectedFor:(VideoSettingsController*)ctrl;
- (UIImage*)videoSettingsController:(VideoSettingsController*)ctrl imageForVideoAtIndex:(int)index;
@end

@interface VideoSettingsController : UITableViewController

@property(nonatomic,readwrite)int numberOfVideosSelected;
@end
