//
//  SessionRepository.m
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//

#import "SessionRepository.h"
#import "PubTypes.h"

@implementation SessionRepository

#pragma mark - Session Operations

- (nullable NSArray<PhotoInfo *> *)getPhotoInfoForSession:(NSInteger)sessionId
                                                     error:(NSError **)error {
    // Query for photo dimensions (type = 0 means photo, not adjustor)
    NSString *query = @"SELECT * FROM sessiondimensions WHERE sessionId = ? AND type = ? ORDER BY photoIndex";
    NSArray *arguments = @[@(sessionId), @(0)];

    NSArray<NSDictionary *> *rows = [self executeQuery:query arguments:arguments error:error];
    if (!rows) return nil;

    NSMutableArray<PhotoInfo *> *photoInfoArray = [NSMutableArray arrayWithCapacity:rows.count];

    for (NSDictionary *row in rows) {
        PhotoInfo *info = [PhotoInfo fromDatabaseRow:row];
        if (info) {
            [photoInfoArray addObject:info];
        }
    }

    return [photoInfoArray copy];
}

- (nullable NSArray<ImageInfo *> *)getImageInfoForSession:(NSInteger)sessionId
                                                     error:(NSError **)error {
    NSString *query = @"SELECT * FROM sessiondimensions WHERE sessionId = ? AND type = ? ORDER BY photoIndex";
    NSArray *arguments = @[@(sessionId), @(0)];

    NSArray<NSDictionary *> *rows = [self executeQuery:query arguments:arguments error:error];
    if (!rows) return nil;

    NSMutableArray<ImageInfo *> *imageInfoArray = [NSMutableArray arrayWithCapacity:rows.count];

    for (NSDictionary *row in rows) {
        ImageInfo *info = [ImageInfo fromDatabaseRow:row];
        if (info) {
            [imageInfoArray addObject:info];
        }
    }

    return [imageInfoArray copy];
}

- (NSInteger)getAdjustorInfoForSession:(NSInteger)sessionId
                          adjustorInfo:(void * _Nullable * _Nullable)adjustorInfo
                                 error:(NSError * _Nullable * _Nullable)error {
    // Query for adjustors (type = 1 means adjustor)
    NSString *query = @"SELECT * FROM sessiondimensions WHERE sessionId = ? AND type = ?";
    NSArray *arguments = @[@(sessionId), @(1)];

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
            [row[@"photo_x"] doubleValue],
            [row[@"photo_y"] doubleValue],
            [row[@"photo_width"] doubleValue],
            [row[@"photo_height"] doubleValue]
        );
        // Default to horizontal - database doesn't store this
        adjustors[i].eShape = ADJUSTOR_HORIZANTAL;
    }

    *adjustorInfo = adjustors;
    return count;
}

#pragma mark - Update Operations

- (BOOL)updateImageSize:(CGSize)size
            atPhotoIndex:(NSInteger)photoIndex
              forSession:(NSInteger)sessionId
                   error:(NSError **)error {
    NSString *query = @"UPDATE sessiondimensions SET img_width = ?, img_height = ? WHERE sessionId = ? AND photoIndex = ? AND type = ?";
    NSArray *arguments = @[@(size.width), @(size.height), @(sessionId), @(photoIndex), @(0)];

    return [self executeUpdate:query arguments:arguments error:error];
}

- (BOOL)updateImageScale:(CGFloat)scale
                  offset:(CGPoint)offset
            atPhotoIndex:(NSInteger)photoIndex
              forSession:(NSInteger)sessionId
                   error:(NSError **)error {
    NSString *query = @"UPDATE sessiondimensions SET img_scale = ?, img_offset_x = ?, img_offset_y = ? WHERE sessionId = ? AND photoIndex = ? AND type = ?";
    NSArray *arguments = @[@(scale), @(offset.x), @(offset.y), @(sessionId), @(photoIndex), @(0)];

    return [self executeUpdate:query arguments:arguments error:error];
}

#pragma mark - Delete Operations

- (BOOL)deleteSession:(NSInteger)sessionId error:(NSError **)error {
    // Delete session dimensions first
    if (![self deleteSessionDimensions:sessionId error:error]) {
        return NO;
    }

    // TODO: Delete session metadata from sessions table
    // This would be added when we refactor Session.m

    return YES;
}

- (BOOL)deleteSessionDimensions:(NSInteger)sessionId error:(NSError **)error {
    NSString *query = @"DELETE FROM sessiondimensions WHERE sessionId = ?";
    NSArray *arguments = @[@(sessionId)];

    return [self executeUpdate:query arguments:arguments error:error];
}

#pragma mark - Debugging

- (void)printSessionTable:(NSInteger)sessionId {
    NSError *error = nil;
    NSString *query = @"SELECT * FROM sessiondimensions WHERE sessionId = ?";
    NSArray *arguments = @[@(sessionId)];

    NSArray<NSDictionary *> *rows = [self executeQuery:query arguments:arguments error:&error];

    if (error) {
        NSLog(@"Error printing session table: %@", error.localizedDescription);
        return;
    }

    NSLog(@"========== Session %ld Contents ==========", (long)sessionId);
    for (NSInteger i = 0; i < rows.count; i++) {
        NSDictionary *row = rows[i];
        NSLog(@"******Photo %ld*******", (long)i + 1);
        NSLog(@"session id: %@", row[@"sessionId"]);
        NSLog(@"photo id: %@", row[@"photoIndex"]);
        NSLog(@"type: %@", row[@"type"]);
        NSLog(@"Frame (%@,%@,%@,%@)",
              row[@"photo_x"], row[@"photo_y"],
              row[@"photo_width"], row[@"photo_height"]);
        NSLog(@"Image Size (%@,%@)", row[@"img_width"], row[@"img_height"]);
        NSLog(@"Image Scale %@, Offset(%@,%@)",
              row[@"img_scale"], row[@"img_offset_x"], row[@"img_offset_y"]);
    }
    NSLog(@"==========================================");
}

@end
