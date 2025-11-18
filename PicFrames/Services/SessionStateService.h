//
//  SessionStateService.h
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//  Manages current session and frame selection state
//
//  Extracted from Settings singleton to follow Single Responsibility Principle
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * SessionStateService manages the current session and frame selection state.
 *
 * Responsibilities:
 * - Track current session index
 * - Track current frame number
 * - Manage next available free session
 * - Persist and restore session state
 *
 * This service was extracted from the Settings God object to improve:
 * - Testability (can easily mock session state)
 * - Single Responsibility (focused on session management only)
 * - Dependency clarity (controllers explicitly depend on session state)
 */
@interface SessionStateService : NSObject

// MARK: - Current State

/// Currently selected session index
@property (nonatomic, assign) NSInteger currentSessionIndex;

/// Currently selected frame number
@property (nonatomic, assign) NSInteger currentFrameNumber;

/// Next available free session slot
@property (nonatomic, assign, readonly) NSInteger nextFreeSessionIndex;

// MARK: - Initialization

/// Initialize with default state
- (instancetype)init;

/// Initialize with specific state (for testing or restoration)
- (instancetype)initWithSessionIndex:(NSInteger)sessionIndex
                         frameNumber:(NSInteger)frameNumber;

// MARK: - State Management

/**
 * Save current state to persistent storage
 * @return YES if save succeeded
 */
- (BOOL)saveState;

/**
 * Restore state from persistent storage
 * @return YES if restore succeeded
 */
- (BOOL)restoreState;

/**
 * Reset to default state
 */
- (void)reset;

/**
 * Allocate next free session
 * @return Index of newly allocated session, or -1 if none available
 */
- (NSInteger)allocateNextFreeSession;

@end

NS_ASSUME_NONNULL_END
