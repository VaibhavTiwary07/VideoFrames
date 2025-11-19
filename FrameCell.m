//
//  FrameCell.m
//  VideoFrames
//
//  UICollectionViewCell for displaying frame thumbnails
//

#import "FrameCell.h"

@interface FrameCell()
@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UIImageView *lockIconView;
@end

@implementation FrameCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    // Thumbnail image view
    self.thumbnailImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbnailImageView.clipsToBounds = YES;
    self.thumbnailImageView.layer.cornerRadius = FRAME_CORNER_RADIUS;
    [self.contentView addSubview:self.thumbnailImageView];

    // Lock icon view
    self.lockIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.lockIconView.image = [UIImage imageNamed:@"lock_icon.png"];
    self.lockIconView.contentMode = UIViewContentModeScaleAspectFit;
    self.lockIconView.hidden = YES;
    self.lockIconView.center = CGPointMake(self.contentView.bounds.size.width / 2,
                                          self.contentView.bounds.size.height / 2);
    [self.contentView addSubview:self.lockIconView];

    // Setup border
    self.contentView.layer.cornerRadius = FRAME_CORNER_RADIUS;
    self.contentView.layer.borderWidth = FRAME_BORDER_WIDTH;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)configureWithFrame:(FrameItem *)frameItem isSelected:(BOOL)selected {
    // Set thumbnail image
    UIImage *thumbnail = nil;
    if (selected) {
        // Show colored version when selected
        thumbnail = [UIImage imageWithContentsOfFile:frameItem.coloredThumbnailPath];
    } else {
        // Show normal version when not selected
        thumbnail = [UIImage imageWithContentsOfFile:frameItem.thumbnailPath];
    }
    self.thumbnailImageView.image = thumbnail;

    // Show/hide lock icon
    self.lockIconView.hidden = !frameItem.isLocked;

    // Update border for selection
    if (selected) {
        self.contentView.layer.borderColor = FRAME_SELECTED_COLOR.CGColor;

        // Add subtle scale animation
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.05, 1.05);
        }];
    } else {
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        self.transform = CGAffineTransformIdentity;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.thumbnailImageView.image = nil;
    self.lockIconView.hidden = YES;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    self.transform = CGAffineTransformIdentity;
}

@end
