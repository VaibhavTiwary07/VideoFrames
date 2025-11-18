//
//  PhotoInfo.h
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//  Modern Objective-C model replacing stPhotoInfo C struct
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PubTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * PhotoInfo represents a photo's placement and shape within a frame.
 *
 * Replaces legacy stPhotoInfo C struct with modern Objective-C class:
 * - Immutable by default (NSCopying protocol)
 * - Nullability annotations
 * - Value semantics
 * - Easy to serialize/deserialize
 *
 * Benefits over C struct:
 * - Type safety
 * - Easy to extend
 * - Works with collections (NSArray, NSDictionary)
 * - Can be mocked for testing
 */
@interface PhotoInfo : NSObject <NSCopying>

/// Photo frame dimensions within the overall frame
@property (nonatomic, assign, readonly) CGRect dimension;

/// Shape of the photo cutout
@property (nonatomic, assign, readonly) ePhotoShape photoShape;

/// Shape of the surrounding frame
@property (nonatomic, assign, readonly) eShape frameShape;

/// Photo index within the session
@property (nonatomic, assign, readonly) NSInteger photoIndex;

// MARK: - Initialization

/**
 * Designated initializer
 */
- (instancetype)initWithDimension:(CGRect)dimension
                       photoShape:(ePhotoShape)photoShape
                       frameShape:(eShape)frameShape
                       photoIndex:(NSInteger)photoIndex NS_DESIGNATED_INITIALIZER;

/**
 * Convenience initializer from legacy C struct
 */
- (instancetype)initWithStruct:(stPhotoInfo)photoInfo photoIndex:(NSInteger)index;

// MARK: - Conversion

/**
 * Convert to legacy C struct (for backward compatibility)
 */
- (stPhotoInfo)toStruct;

/**
 * Create from database row
 */
+ (nullable instancetype)fromDatabaseRow:(NSDictionary *)row;

@end

NS_ASSUME_NONNULL_END
