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
#define FRAME_SELECTED_COLOR [UIColor greenColor]

@interface FrameCell : UICollectionViewCell

@property (nonatomic, strong) NSCache<NSString *, UIImage *> *imageCache;

- (void)configureWithFrame:(FrameItem *)frameItem isSelected:(BOOL)selected;

@end
