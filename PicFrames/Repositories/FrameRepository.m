//
//  FrameRepository.m
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//

#import "FrameRepository.h"
#import "PubTypes.h"

@implementation FrameRepository

#pragma mark - Frame Template Operations

- (nullable NSArray<PhotoInfo *> *)getPhotoInfoForFrame:(NSInteger)frameNumber
                                                   error:(NSError **)error {
    // Query for photo layout from frames table (type = 0 means photo)
    NSString *query = @"SELECT * FROM frames WHERE frame = ? AND type = ? ORDER BY photo";
    NSArray *arguments = @[@(frameNumber), @(0)];

    NSArray<NSDictionary *> *rows = [self executeQuery:query arguments:arguments error:error];
    if (!rows) return nil;

    NSMutableArray<PhotoInfo *> *photoInfoArray = [NSMutableArray arrayWithCapacity:rows.count];

    for (NSDictionary *row in rows) {
        // Map database columns to PhotoInfo
        // Assuming frames table has: frame, photo, type, x, y, width, height
        CGRect dimension = CGRectMake(
            [row[@"x"] doubleValue],
            [row[@"y"] doubleValue],
            [row[@"width"] doubleValue],
            [row[@"height"] doubleValue]
        );

        PhotoInfo *info = [[PhotoInfo alloc] initWithDimension:dimension
                                                     photoShape:PHOTO_NOSHAPE
                                                     frameShape:SHAPE_NOSHAPE
                                                     photoIndex:[row[@"photo"] integerValue]];
        [photoInfoArray addObject:info];
    }

    return [photoInfoArray copy];
}

- (NSInteger)getAdjustorInfoForFrame:(NSInteger)frameNumber
                        adjustorInfo:(void * _Nullable * _Nullable)adjustorInfo
                               error:(NSError * _Nullable * _Nullable)error {
    // Query for adjustors from frames table (type = 1 means adjustor)
    NSString *query = @"SELECT * FROM frames WHERE frame = ? AND type = ?";
    NSArray *arguments = @[@(frameNumber), @(1)];

    NSArray<NSDictionary *> *rows = [self executeQuery:query arguments:arguments error:error];
    if (!rows) return 0;

    NSInteger count = rows.count;
    if (count == 0 || !adjustorInfo) return count;

    // Allocate C struct array for backward compatibility
    stAdjustorInfo *adjustors = (stAdjustorInfo *)malloc(sizeof(stAdjustorInfo) * count);
    if (!adjustors) {
        if (error) {
            *error = [NSError errorWithDomain:@"com.picframes.repository"
                                         code:-400
                                     userInfo:@{NSLocalizedDescriptionKey: @"Failed to allocate memory"}];
        }
        return 0;
    }

    for (NSInteger i = 0; i < count; i++) {
        NSDictionary *row = rows[i];
        adjustors[i].dimension = CGRectMake(
            [row[@"x"] doubleValue],
            [row[@"y"] doubleValue],
            [row[@"width"] doubleValue],
            [row[@"height"] doubleValue]
        );

        // Determine adjustor type based on dimensions
        // If width > height, it's horizontal; otherwise vertical
        CGFloat width = [row[@"width"] doubleValue];
        CGFloat height = [row[@"height"] doubleValue];
        adjustors[i].eShape = (width > height) ? ADJUSTOR_HORIZANTAL : ADJUSTOR_VERTICLE;
    }

    *adjustorInfo = adjustors;
    return count;
}

- (NSInteger)getPhotoCountForFrame:(NSInteger)frameNumber
                             error:(NSError **)error {
    NSString *query = @"SELECT COUNT(*) as count FROM frames WHERE frame = ? AND type = ?";
    NSArray *arguments = @[@(frameNumber), @(0)]; // type 0 = photo

    NSArray<NSDictionary *> *rows = [self executeQuery:query arguments:arguments error:error];
    if (!rows || rows.count == 0) return 0;

    return [rows[0][@"count"] integerValue];
}

@end
