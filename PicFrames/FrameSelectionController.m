//
//  FrameSelectionController.m
//  VideoFrames
//
//  Refactored for senior dev quality - simplified single-controller design
//

#define NSLog(...) [[FIRCrashlytics crashlytics] logWithFormat: __VA_ARGS__]

@import FirebaseCrashlytics;
#import "FrameSelectionController.h"
#import "FrameCell.h"
#import "FrameItem.h"
#import "Settings.h"
#import "SRSubscriptionModel.h"
#import "Config.h"
#import "Utility.h"

// Lock mapping for frames (frame number -> lock type)
// Frames 1-2 are free, rest follow this mapping
static NSDictionary *frameLockMapping = nil;

@interface FrameSelectionController ()

// UI Components
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *customDoneButton;

// Data
@property (nonatomic, strong) NSMutableArray<FrameItem *> *frameItems;
@property (nonatomic, assign) NSInteger selectedFrameIndex;

@end

@implementation FrameSelectionController

#pragma mark - Lifecycle

+ (void)initialize {
    if (self == [FrameSelectionController class]) {
        // Initialize frame lock mapping
        // Free frames: 1, 2, 9, 19, 31, 36, 39, 69, 73, 85
        // Rest require unlock via various methods
        frameLockMapping = @{
            // Free frames
            @(1): @(FrameLockTypeFree),
            @(2): @(FrameLockTypeFree),
            @(9): @(FrameLockTypeFree),
            @(19): @(FrameLockTypeFree),
            @(31): @(FrameLockTypeFree),
            @(36): @(FrameLockTypeFree),
            @(39): @(FrameLockTypeFree),
            @(69): @(FrameLockTypeFree),
            @(73): @(FrameLockTypeFree),
            @(85): @(FrameLockTypeFree),

            // Facebook unlock frames (example mapping)
            @(3): @(FrameLockTypeFacebook),
            @(4): @(FrameLockTypeFacebook),

            // Instagram unlock frames (example mapping)
            @(5): @(FrameLockTypeInstagram),
            @(6): @(FrameLockTypeInstagram),

            // Twitter unlock frames (example mapping)
            @(7): @(FrameLockTypeTwitter),
            @(8): @(FrameLockTypeTwitter),

            // Default: Premium frames require InApp purchase or subscription
            // All other frames will default to FrameLockTypeInApp
        };
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedFrameIndex = -1;  // No selection
    self.view.backgroundColor = [UIColor blackColor];

    [self setupNavigationBar];
    [self setupCollectionView];
    [self loadFrameData];
    [self generateFrameThumbnailsIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    // Pre-select current frame from Settings
    Settings *settings = [Settings Instance];
    if (settings.currentFrameNumber > 0) {
        self.selectedFrameIndex = settings.currentFrameNumber;
        [self updateDoneButtonAppearance];

        // Scroll to selected frame
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectedFrameIndex - 1 inSection:0];
            if (indexPath.item < self.frameItems.count) {
                [self.collectionView scrollToItemAtIndexPath:indexPath
                                             atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                                     animated:NO];
            }
        });
    }
}

#pragma mark - UI Setup

- (void)setupNavigationBar {
    // Hide default back button
    self.navigationItem.hidesBackButton = YES;

    // Custom back button
    UIImage *backButtonImage = [UIImage imageNamed:@"back_svg"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButton;

    // Custom done button with gradient support
    self.customDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.customDoneButton.frame = CGRectMake(0, 0, 70, 35);
    [self.customDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.customDoneButton addTarget:self
                              action:@selector(doneButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
    self.customDoneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.customDoneButton.layer.cornerRadius = 5.0;
    self.customDoneButton.clipsToBounds = YES;

    // Set initial appearance (disabled)
    [self updateDoneButtonAppearance];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:self.customDoneButton];
    self.navigationItem.rightBarButtonItem = doneButton;

    // Navigation bar appearance
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.backgroundColor = [UIColor blackColor];
        appearance.shadowColor = nil;
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        self.navigationController.navigationBar.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"FRAMES", @"Frames");
}

- (void)setupCollectionView {
    // Calculate cell size (3 columns grid)
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat spacing = 12.0;
    CGFloat cellWidth = (screenWidth - (4 * spacing)) / 3.0;  // 3 columns
    CGFloat cellHeight = cellWidth;

    // Collection view layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    layout.minimumInteritemSpacing = spacing;
    layout.minimumLineSpacing = spacing;
    layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    // Collection view
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height +
                           [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect collectionFrame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height - navBarHeight);

    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame
                                             collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.alwaysBounceVertical = YES;

    // Register cell
    [self.collectionView registerClass:[FrameCell class]
             forCellWithReuseIdentifier:FRAME_CELL_IDENTIFIER];

    [self.view addSubview:self.collectionView];
}

#pragma mark - Data Loading

- (void)loadFrameData {
    self.frameItems = [NSMutableArray array];

    // Load all frames (total count from Config.h: FRAME_COUNT)
    // Free frames: 1, 2
    // Premium frames: 1001-1049 (mapping to display indices 3-51)

    // Add free frames (1-2)
    for (int i = 1; i <= 2; i++) {
        FrameItem *item = [[FrameItem alloc] initWithFrameNumber:i
                                                       lockType:FrameLockTypeFree];
        [self.frameItems addObject:item];
    }

    // Add premium frames (1001-1049, displayed as indices 3-51)
    for (int i = 1001; i <= 1049; i++) {
        FrameLockType lockType = [self lockTypeForFrameNumber:i];
        FrameItem *item = [[FrameItem alloc] initWithFrameNumber:i
                                                       lockType:lockType];
        [self.frameItems addObject:item];
    }

    [self.collectionView reloadData];
}

- (FrameLockType)lockTypeForFrameNumber:(NSInteger)frameNumber {
    // Check mapping dictionary first
    NSNumber *lockTypeNumber = frameLockMapping[@(frameNumber)];
    if (lockTypeNumber) {
        return [lockTypeNumber integerValue];
    }

    // Default to InApp purchase for unlisted frames
    return FrameLockTypeInApp;
}

- (void)generateFrameThumbnailsIfNeeded {
    // Check if thumbnails exist by checking a sample frame from premium range
    NSString *sampleThumbnailPath = [Utility frameThumbNailPathForFrameNumber:1001];

    if (![[NSFileManager defaultManager] fileExistsAtPath:sampleThumbnailPath]) {
        // Thumbnails don't exist, generate them
        [Utility addActivityIndicatotTo:self.view withMessage:@"Loading Frames..."];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Generate thumbnails in background
            [Utility generateThumnailsForFrames];

            // Update UI on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utility removeActivityIndicatorFrom:self.view];
                [self.collectionView reloadData];
            });
        });
    }
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.frameItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FrameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FRAME_CELL_IDENTIFIER
                                                                 forIndexPath:indexPath];

    FrameItem *frameItem = self.frameItems[indexPath.item];
    BOOL isSelected = (frameItem.frameNumber == self.selectedFrameIndex);

    [cell configureWithFrame:frameItem isSelected:isSelected];

    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FrameItem *selectedFrame = self.frameItems[indexPath.item];

    // Update selection (allow all frames, including locked ones)
    NSInteger previousSelection = self.selectedFrameIndex;
    self.selectedFrameIndex = selectedFrame.frameNumber;

    // Reload cells for visual update
    NSMutableArray *indexPathsToReload = [NSMutableArray array];
    [indexPathsToReload addObject:indexPath];

    // Also reload previously selected cell
    if (previousSelection > 0) {
        NSInteger previousIndex = [self indexForFrameNumber:previousSelection];
        if (previousIndex != NSNotFound) {
            [indexPathsToReload addObject:[NSIndexPath indexPathForItem:previousIndex inSection:0]];
        }
    }

    [collectionView reloadItemsAtIndexPaths:indexPathsToReload];

    // Update done button
    [self updateDoneButtonAppearance];

    // Save selection to Settings
    Settings *settings = [Settings Instance];
    settings.currentFrameNumber = (int)self.selectedFrameIndex;

    NSLog(@"Frame selected: %ld", (long)self.selectedFrameIndex);
}

- (NSInteger)indexForFrameNumber:(NSInteger)frameNumber {
    for (NSInteger i = 0; i < self.frameItems.count; i++) {
        if (self.frameItems[i].frameNumber == frameNumber) {
            return i;
        }
    }
    return NSNotFound;
}

#pragma mark - Locked Frame Handling

- (void)handleLockedFrameSelection:(FrameItem *)frameItem {
    NSString *message = @"";
    NSString *actionTitle = @"";

    switch (frameItem.lockType) {
        case FrameLockTypeFacebook:
            message = @"Like us on Facebook to unlock this frame";
            actionTitle = @"Like on Facebook";
            break;

        case FrameLockTypeInstagram:
            message = @"Follow us on Instagram to unlock this frame";
            actionTitle = @"Follow on Instagram";
            break;

        case FrameLockTypeTwitter:
            message = @"Follow us on Twitter to unlock this frame";
            actionTitle = @"Follow on Twitter";
            break;

        case FrameLockTypeInApp:
        case FrameLockTypeRateUs:
            message = @"Subscribe or purchase to unlock all premium frames";
            actionTitle = @"View Subscription";
            break;

        default:
            return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Frame Locked"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:actionTitle
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        [self handleUnlockAction:frameItem.lockType];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleUnlockAction:(FrameLockType)lockType {
    // Handle unlock actions based on type
    // This is where you'd integrate with your social unlock or IAP flow
    switch (lockType) {
        case FrameLockTypeFacebook:
            // TODO: Implement Facebook like flow
            NSLog(@"Facebook unlock requested");
            break;

        case FrameLockTypeInstagram:
            // TODO: Implement Instagram follow flow
            NSLog(@"Instagram unlock requested");
            break;

        case FrameLockTypeTwitter:
            // TODO: Implement Twitter follow flow
            NSLog(@"Twitter unlock requested");
            break;

        case FrameLockTypeInApp:
        case FrameLockTypeRateUs:
            // TODO: Show subscription/purchase screen
            NSLog(@"Subscription unlock requested");
            break;

        default:
            break;
    }
}

#pragma mark - Done Button

- (void)updateDoneButtonAppearance {
    if (self.selectedFrameIndex > 0) {
        // Frame selected: gradient green → cyan, black text, enabled
        [self removeGradientLayers];

        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.customDoneButton.bounds;
        gradientLayer.colors = @[(id)DONE_BUTTON_GREEN.CGColor, (id)DONE_BUTTON_CYAN.CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        [self.customDoneButton.layer insertSublayer:gradientLayer atIndex:0];

        [self.customDoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.customDoneButton.enabled = YES;
    } else {
        // No selection: dark grey, white text, disabled
        [self removeGradientLayers];

        self.customDoneButton.backgroundColor = DONE_BUTTON_DISABLED_BG;
        [self.customDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.customDoneButton.enabled = NO;
    }
}

- (void)removeGradientLayers {
    // Remove existing gradient layers
    for (CALayer *layer in [self.customDoneButton.layer.sublayers copy]) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    self.customDoneButton.backgroundColor = [UIColor clearColor];
}

#pragma mark - Actions

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPressed {
    if (self.selectedFrameIndex <= 0) {
        return;  // No frame selected
    }

    // Save selection
    Settings *settings = [Settings Instance];
    settings.currentFrameNumber = (int)self.selectedFrameIndex;
    settings.currentSessionIndex = settings.nextFreeSessionIndex;

    // Post notification for other screens
    NSDictionary *params = @{
        @"FrameNumber": @(settings.currentFrameNumber),
        @"SessionNumber": @(settings.currentSessionIndex)
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newframeselected"
                                                        object:nil
                                                      userInfo:params];

    NSLog(@"Done pressed with frame: %ld", (long)self.selectedFrameIndex);

    // Navigate back
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
