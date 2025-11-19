//
//  FrameCell.h
//  VideoFrames
//
//  UICollectionViewCell for displaying frame thumbnails
//

#import <UIKit/UIKit.h>
#import "FrameItem.h"

// Constants for consistent styling
#define FRAME_BORDER_WIDTH 3.0
#define FRAME_CORNER_RADIUS 4.0

// Selection color (green)
#define FRAME_SELECTED_COLOR [UIColor colorWithRed:184/255.0 green:234/255.0 blue:112/255.0 alpha:1.0]

@interface FrameCell : UICollectionViewCell

- (void)configureWithFrame:(FrameItem *)frameItem isSelected:(BOOL)selected;

@end
