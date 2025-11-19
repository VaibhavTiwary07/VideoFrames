//
//  FrameSelectionController.h
//  VideoFrames
//
//  Refactored for senior dev quality - simplified single-controller design
//

#import <UIKit/UIKit.h>

// Constants
#define FRAME_CELL_IDENTIFIER @"FrameCell"
#define DONE_BUTTON_GREEN [UIColor colorWithRed:188/255.0 green:234/255.0 blue:109/255.0 alpha:1.0]
#define DONE_BUTTON_CYAN [UIColor colorWithRed:20/255.0 green:249/255.0 blue:245/255.0 alpha:1.0]
#define DONE_BUTTON_DISABLED_BG [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]

@interface FrameSelectionController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, readwrite) BOOL isDynamically;

@end
