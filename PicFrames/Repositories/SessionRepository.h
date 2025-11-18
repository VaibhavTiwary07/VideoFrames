//
//  SessionRepository.h
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//  Repository for session database operations
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Repository.h"
#import "PhotoInfo.h"
#import "ImageInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * SessionRepository handles all database operations for sessions.
 *
 * Replaces direct SQL calls in SessionDB.h/m with clean, testable interface.
 *
 * Responsibilities:
 * - CRUD operations for sessions
 * - Photo/image info retrieval for sessions
 * - Image transformation updates
 * - Session deletion with cleanup
 *
 * Benefits:
 * - Single Responsibility: Only handles session data access
 * - Testability: Can be mocked for unit tests
 * - Modern patterns: Async operations, error handling
 * - Type safety: Uses PhotoInfo/ImageInfo models instead of C structs
 */
@interface SessionRepository : BaseRepository

// MARK: - Session Operations

/**
 * Get photo information for a session
 * @param sessionId Session identifier
 * @param error Error pointer
 * @return Array of PhotoInfo objects or nil on error
 */
- (nullable NSArray<PhotoInfo *> *)getPhotoInfoForSession:(NSInteger)sessionId
                                                     error:(NSError **)error;

/**
 * Get image transformation info for a session
 * @param sessionId Session identifier
 * @param error Error pointer
 * @return Array of ImageInfo objects or nil on error
 */
- (nullable NSArray<ImageInfo *> *)getImageInfoForSession:(NSInteger)sessionId
                                                     error:(NSError **)error;

/**
 * Get adjustor information for a session
 * (Kept for backward compatibility - returns C struct array)
 * @param sessionId Session identifier
 * @param adjustorInfo Pointer to receive adjustor info array
 * @param error Error pointer
 * @return Count of adjustors or 0 on error
 */
- (NSInteger)getAdjustorInfoForSession:(NSInteger)sessionId
                          adjustorInfo:(void * _Nullable * _Nullable)adjustorInfo
                                 error:(NSError * _Nullable * _Nullable)error;

// MARK: - Update Operations

/**
 * Update image size for a photo in session
 * @param size New image size
 * @param photoIndex Index of photo to update
 * @param sessionId Session identifier
 * @param error Error pointer
 * @return YES if successful
 */
- (BOOL)updateImageSize:(CGSize)size
            atPhotoIndex:(NSInteger)photoIndex
              forSession:(NSInteger)sessionId
                   error:(NSError **)error;

/**
 * Update image scale and offset for a photo
 * @param scale Scale factor
 * @param offset Pan offset
 * @param photoIndex Index of photo to update
 * @param sessionId Session identifier
 * @param error Error pointer
 * @return YES if successful
 */
- (BOOL)updateImageScale:(CGFloat)scale
                  offset:(CGPoint)offset
            atPhotoIndex:(NSInteger)photoIndex
              forSession:(NSInteger)sessionId
                   error:(NSError **)error;

// MARK: - Delete Operations

/**
 * Delete session and all associated data
 * @param sessionId Session identifier
 * @param error Error pointer
 * @return YES if successful
 */
- (BOOL)deleteSession:(NSInteger)sessionId error:(NSError **)error;

/**
 * Delete session dimensions data only
 * @param sessionId Session identifier
 * @param error Error pointer
 * @return YES if successful
 */
- (BOOL)deleteSessionDimensions:(NSInteger)sessionId error:(NSError **)error;

// MARK: - Debugging

/**
 * Print session table contents (for debugging)
 * @param sessionId Session identifier
 */
- (void)printSessionTable:(NSInteger)sessionId;

@end

NS_ASSUME_NONNULL_END
