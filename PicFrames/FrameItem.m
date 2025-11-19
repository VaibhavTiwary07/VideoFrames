//
//  FrameItem.m
//  VideoFrames
//
//  Frame data model for simplified frame selection
//

#import "FrameItem.h"
#import "Utility.h"
#import "SRSubscriptionModel.h"

@implementation FrameItem

- (instancetype)initWithFrameNumber:(NSInteger)frameNumber lockType:(FrameLockType)lockType {
    self = [super init];
    if (self) {
        _frameNumber = frameNumber;
        _lockType = lockType;
        _thumbnailPath = [Utility frameThumbNailPathForFrameNumber:(int)frameNumber];
        _coloredThumbnailPath = [Utility coloredFrameThumbNailPathForFrameNumber:(int)frameNumber];

        // Determine if locked based on lock type and subscription status
        _isLocked = [self checkIfLocked];
    }
    return self;
}

- (BOOL)checkIfLocked {
    // Free frames are never locked
    if (self.lockType == FrameLockTypeFree) {
        return NO;
    }

    // If user has active subscription, all frames are unlocked
    if ([[SRSubscriptionModel shareKit] IsAppSubscribed]) {
        return NO;
    }

    // Check specific unlock status based on lock type
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    switch (self.lockType) {
        case FrameLockTypeFacebook:
            return ![[defaults objectForKey:@"ipf_facebookLikeStatus"] boolValue];

        case FrameLockTypeInstagram:
            return ![[defaults objectForKey:@"ipf_instagramFollowStatus"] boolValue];

        case FrameLockTypeTwitter:
            return ![[defaults objectForKey:@"ipf_twitterLikeStatus"] boolValue];

        case FrameLockTypeInApp:
            return ![[defaults objectForKey:@"PurchasedYES"] boolValue];

        case FrameLockTypeRateUs:
            // Add rate us check if needed
            return YES;

        default:
            return YES;
    }
}

@end
