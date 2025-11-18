//
//  ImageInfo.h
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//  Modern Objective-C model replacing stImageInfo C struct
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PubTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * ImageInfo represents image transformation data (scale, offset, rotation).
 *
 * Replaces legacy stImageInfo C struct with modern Objective-C class.
 *
 * Used for storing how an image is positioned within a photo frame:
 * - Size of the source image
 * - Scale factor applied
 * - Offset for panning
 * - Rotation angle
 */
@interface ImageInfo : NSObject <NSCopying>

/// Original size of the image
@property (nonatomic, assign, readonly) CGSize imageSize;

/// Pan offset (translation)
@property (nonatomic, assign, readonly) CGPoint offset;

/// Scale factor (zoom)
@property (nonatomic, assign, readonly) CGFloat scale;

/// Rotation angle in radians
@property (nonatomic, assign, readonly) CGFloat rotation;

/// Photo index this image info belongs to
@property (nonatomic, assign, readonly) NSInteger photoIndex;

// MARK: - Initialization

/**
 * Designated initializer
 */
- (instancetype)initWithImageSize:(CGSize)imageSize
                           offset:(CGPoint)offset
                            scale:(CGFloat)scale
                         rotation:(CGFloat)rotation
                       photoIndex:(NSInteger)photoIndex NS_DESIGNATED_INITIALIZER;

/**
 * Convenience initializer from legacy C struct
 */
- (instancetype)initWithStruct:(stImageInfo)imageInfo photoIndex:(NSInteger)index;

// MARK: - Conversion

/**
 * Convert to legacy C struct (for backward compatibility)
 */
- (stImageInfo)toStruct;

/**
 * Create from database row
 */
+ (nullable instancetype)fromDatabaseRow:(NSDictionary *)row;

// MARK: - Transform

/**
 * Get CGAffineTransform representing this image info
 */
- (CGAffineTransform)affineTransform;

@end

NS_ASSUME_NONNULL_END
