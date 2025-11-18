//
//  FrameRepository.h
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//  Repository for frame database operations
//

#import <Foundation/Foundation.h>
#import "Repository.h"
#import "PhotoInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * FrameRepository handles all database operations for frame templates.
 *
 * Replaces direct SQL calls in FrameDB.h/m with clean, testable interface.
 *
 * Responsibilities:
 * - Retrieve frame template information
 * - Get photo layout for frame numbers
 * - Get adjustor positions for frames
 *
 * Note: Frame templates are pre-defined layouts stored in the database.
 * This is different from Session which contains user data.
 */
@interface FrameRepository : BaseRepository

// MARK: - Frame Template Operations

/**
 * Get photo layout information for a frame template
 * @param frameNumber Frame template number
 * @param error Error pointer
 * @return Array of PhotoInfo objects or nil on error
 */
- (nullable NSArray<PhotoInfo *> *)getPhotoInfoForFrame:(NSInteger)frameNumber
                                                   error:(NSError **)error;

/**
 * Get adjustor information for a frame template
 * (Kept for backward compatibility - returns C struct array)
 * @param frameNumber Frame template number
 * @param adjustorInfo Pointer to receive adjustor info array
 * @param error Error pointer
 * @return Count of adjustors or 0 on error
 */
- (NSInteger)getAdjustorInfoForFrame:(NSInteger)frameNumber
                        adjustorInfo:(void * _Nullable * _Nullable)adjustorInfo
                               error:(NSError * _Nullable * _Nullable)error;

/**
 * Get photo count for a frame template
 * @param frameNumber Frame template number
 * @param error Error pointer
 * @return Number of photos in frame or 0 on error
 */
- (NSInteger)getPhotoCountForFrame:(NSInteger)frameNumber
                             error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
