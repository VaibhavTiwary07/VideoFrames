//
//  PhotoInfo.m
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//

#import "PhotoInfo.h"

@implementation PhotoInfo

#pragma mark - Initialization

- (instancetype)initWithDimension:(CGRect)dimension
                       photoShape:(ePhotoShape)photoShape
                       frameShape:(eShape)frameShape
                       photoIndex:(NSInteger)photoIndex {
    self = [super init];
    if (self) {
        _dimension = dimension;
        _photoShape = photoShape;
        _frameShape = frameShape;
        _photoIndex = photoIndex;
    }
    return self;
}

- (instancetype)initWithStruct:(stPhotoInfo)photoInfo photoIndex:(NSInteger)index {
    return [self initWithDimension:photoInfo.dimension
                        photoShape:photoInfo.eShape
                        frameShape:photoInfo.eFrameShape
                        photoIndex:index];
}

- (instancetype)init {
    return [self initWithDimension:CGRectZero
                        photoShape:PHOTO_NOSHAPE
                        frameShape:SHAPE_NOSHAPE
                        photoIndex:0];
}

#pragma mark - Conversion

- (stPhotoInfo)toStruct {
    stPhotoInfo info;
    info.dimension = self.dimension;
    info.eShape = self.photoShape;
    info.eFrameShape = self.frameShape;
    return info;
}

+ (nullable instancetype)fromDatabaseRow:(NSDictionary *)row {
    if (!row) return nil;

    CGRect dimension = CGRectMake(
        [row[@"photo_x"] doubleValue],
        [row[@"photo_y"] doubleValue],
        [row[@"photo_width"] doubleValue],
        [row[@"photo_height"] doubleValue]
    );

    // Note: Database doesn't store shape info currently
    // Default to no shape for now
    return [[PhotoInfo alloc] initWithDimension:dimension
                                     photoShape:PHOTO_NOSHAPE
                                     frameShape:SHAPE_NOSHAPE
                                     photoIndex:[row[@"photoIndex"] integerValue]];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    // Immutable object - can return self
    return self;
}

#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"<PhotoInfo: index=%ld, frame=%@, photoShape=%ld, frameShape=%ld>",
            (long)self.photoIndex,
            NSStringFromCGRect(self.dimension),
            (long)self.photoShape,
            (long)self.frameShape];
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[PhotoInfo class]]) return NO;

    PhotoInfo *other = (PhotoInfo *)object;
    return CGRectEqualToRect(self.dimension, other.dimension) &&
           self.photoShape == other.photoShape &&
           self.frameShape == other.frameShape &&
           self.photoIndex == other.photoIndex;
}

- (NSUInteger)hash {
    return [@(self.photoIndex) hash] ^
           [@(self.dimension.origin.x) hash] ^
           [@(self.photoShape) hash];
}

@end
