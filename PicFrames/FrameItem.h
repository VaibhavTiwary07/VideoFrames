//
//  FrameItem.h
//  VideoFrames
//
//  Frame data model for simplified frame selection
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FrameLockType) {
    FrameLockTypeFree = 0,
    FrameLockTypeFacebook,
    FrameLockTypeInstagram,
    FrameLockTypeTwitter,
    FrameLockTypeInApp,
    FrameLockTypeRateUs
};

@interface FrameItem : NSObject

@property (nonatomic, assign) NSInteger frameNumber;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) FrameLockType lockType;
@property (nonatomic, strong) NSString *thumbnailPath;
@property (nonatomic, strong) NSString *coloredThumbnailPath;

- (instancetype)initWithFrameNumber:(NSInteger)frameNumber
                         lockType:(FrameLockType)lockType;

@end
