//
//  ImageInfo.m
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//

#import "ImageInfo.h"

@implementation ImageInfo

#pragma mark - Initialization

- (instancetype)initWithImageSize:(CGSize)imageSize
                           offset:(CGPoint)offset
                            scale:(CGFloat)scale
                         rotation:(CGFloat)rotation
                       photoIndex:(NSInteger)photoIndex {
    self = [super init];
    if (self) {
        _imageSize = imageSize;
        _offset = offset;
        _scale = scale;
        _rotation = rotation;
        _photoIndex = photoIndex;
    }
    return self;
}

- (instancetype)initWithStruct:(stImageInfo)imageInfo photoIndex:(NSInteger)index {
    return [self initWithImageSize:imageInfo.imageSize
                            offset:imageInfo.offset
                             scale:imageInfo.scale
                          rotation:imageInfo.rotation
                        photoIndex:index];
}

- (instancetype)init {
    return [self initWithImageSize:CGSizeZero
                            offset:CGPointZero
                             scale:1.0
                          rotation:0.0
                        photoIndex:0];
}

#pragma mark - Conversion

- (stImageInfo)toStruct {
    stImageInfo info;
    info.imageSize = self.imageSize;
    info.offset = self.offset;
    info.scale = self.scale;
    info.rotation = self.rotation;
    return info;
}

+ (nullable instancetype)fromDatabaseRow:(NSDictionary *)row {
    if (!row) return nil;

    CGSize imageSize = CGSizeMake(
        [row[@"img_width"] doubleValue],
        [row[@"img_height"] doubleValue]
    );

    CGPoint offset = CGPointMake(
        [row[@"img_offset_x"] doubleValue],
        [row[@"img_offset_y"] doubleValue]
    );

    CGFloat scale = [row[@"img_scale"] doubleValue];
    CGFloat rotation = [row[@"img_rotation"] doubleValue] ?: 0.0;

    return [[ImageInfo alloc] initWithImageSize:imageSize
                                         offset:offset
                                          scale:scale
                                       rotation:rotation
                                     photoIndex:[row[@"photoIndex"] integerValue]];
}

#pragma mark - Transform

- (CGAffineTransform)affineTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, self.offset.x, self.offset.y);
    transform = CGAffineTransformScale(transform, self.scale, self.scale);
    transform = CGAffineTransformRotate(transform, self.rotation);
    return transform;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    // Immutable object - can return self
    return self;
}

#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"<ImageInfo: index=%ld, size=%@, scale=%.2f, offset=%@, rotation=%.2f>",
            (long)self.photoIndex,
            NSStringFromCGSize(self.imageSize),
            self.scale,
            NSStringFromCGPoint(self.offset),
            self.rotation];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[ImageInfo class]]) return NO;

    ImageInfo *other = (ImageInfo *)object;
    return CGSizeEqualToSize(self.imageSize, other.imageSize) &&
           CGPointEqualToPoint(self.offset, other.offset) &&
           fabs(self.scale - other.scale) < 0.0001 &&
           fabs(self.rotation - other.rotation) < 0.0001 &&
           self.photoIndex == other.photoIndex;
}

- (NSUInteger)hash {
    return [@(self.photoIndex) hash] ^
           [@(self.scale) hash] ^
           [@(self.rotation) hash];
}

@end
