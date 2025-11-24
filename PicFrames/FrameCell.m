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
@property (nonatomic, strong) UIImageView *proBadgeView;
@end

@implementation FrameCell

@synthesize imageCache = _imageCache;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        printf("--- FrameCell.m: initWithFrame ---\n");
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

    // PRO badge view (top-right corner for premium frames)
    CGFloat badgeSize = 28.0;
    self.proBadgeView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width - badgeSize - 1, 1, badgeSize, badgeSize)];
    self.proBadgeView.image = [UIImage imageNamed:@"ProBadge"];
    self.proBadgeView.contentMode = UIViewContentModeScaleAspectFit;
    self.proBadgeView.hidden = YES;  // Hidden by default, shown only for locked frames
    [self.contentView addSubview:self.proBadgeView];

    // Setup border
    self.contentView.layer.cornerRadius = FRAME_CORNER_RADIUS;
    self.contentView.layer.borderWidth = FRAME_BORDER_WIDTH;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    // Ensure badge isn't clipped
    self.contentView.clipsToBounds = NO;
    self.clipsToBounds = NO;
}

- (void)configureWithFrame:(FrameItem *)frameItem isSelected:(BOOL)selected {
    printf("--- FrameCell: configureWithFrame %ld, isSelected: %d ---\n", (long)frameItem.frameNumber, selected);
    // Update subview frames for dynamic cell sizing (critical for iPad)
    CGFloat padding = 3.0;
    self.thumbnailImageView.frame = CGRectInset(self.contentView.bounds, padding, padding);
    self.lockIconView.center = CGPointMake(self.contentView.bounds.size.width / 2,
                                           self.contentView.bounds.size.height / 2);
    // Scale badge size based on cell size (25% of cell width, min 20, max 32)
    CGFloat badgeSize = MIN(MAX(self.contentView.bounds.size.width * 0.25, 20.0), 32.0);
    self.proBadgeView.frame = CGRectMake(self.contentView.bounds.size.width - badgeSize - 2,
                                         2, badgeSize, badgeSize);

    // Set thumbnail image with caching and async loading for performance
    NSString *imagePath = selected ? frameItem.coloredThumbnailPath : frameItem.thumbnailPath;

    // Check cache first (instant if cached)
    UIImage *cachedImage = [self.imageCache objectForKey:imagePath];
    if (cachedImage) {
        self.thumbnailImageView.image = cachedImage;
    } else {
        // Not in cache - load asynchronously to avoid blocking UI
        self.thumbnailImageView.image = nil;  // Clear while loading

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Load image from disk on background thread
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

            if (image) {
                // Cache the image for future use
                [self.imageCache setObject:image forKey:imagePath];

                // Update UI on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.thumbnailImageView.image = image;
                });
            }
        });
    }

    // Show/hide lock icon and PRO badge
    self.lockIconView.hidden = !frameItem.isLocked;
    self.proBadgeView.hidden = !frameItem.isLocked;  // Show PRO badge for all locked frames

    // Update border for selection
    if (selected) {
        self.contentView.layer.borderColor = FRAME_SELECTED_COLOR.CGColor;

        // Add subtle scale animation
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.05, 1.05);
        }];
    } else {
        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.transform = CGAffineTransformIdentity;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.thumbnailImageView.image = nil;
    self.lockIconView.hidden = YES;
    self.proBadgeView.hidden = YES;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.transform = CGAffineTransformIdentity;
}

@end
