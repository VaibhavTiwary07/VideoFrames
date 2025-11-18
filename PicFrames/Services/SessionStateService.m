//
//  SessionStateService.m
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//

#import "SessionStateService.h"

// Persistence keys
static NSString * const kSessionStateCurrentSession = @"SessionState_CurrentSession";
static NSString * const kSessionStateCurrentFrame = @"SessionState_CurrentFrame";
static NSString * const kSessionStateNextFree = @"SessionState_NextFree";

@interface SessionStateService ()
@property (nonatomic, assign, readwrite) NSInteger nextFreeSessionIndex;
@end

@implementation SessionStateService

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithSessionIndex:0 frameNumber:0];
}

- (instancetype)initWithSessionIndex:(NSInteger)sessionIndex
                         frameNumber:(NSInteger)frameNumber {
    self = [super init];
    if (self) {
        _currentSessionIndex = sessionIndex;
        _currentFrameNumber = frameNumber;
        _nextFreeSessionIndex = 0;

        // Try to restore state from storage
        [self restoreState];
    }
    return self;
}

#pragma mark - State Management

- (BOOL)saveState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setInteger:self.currentSessionIndex forKey:kSessionStateCurrentSession];
    [defaults setInteger:self.currentFrameNumber forKey:kSessionStateCurrentFrame];
    [defaults setInteger:self.nextFreeSessionIndex forKey:kSessionStateNextFree];

    return [defaults synchronize];
}

- (BOOL)restoreState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults objectForKey:kSessionStateCurrentSession] != nil) {
        self.currentSessionIndex = [defaults integerForKey:kSessionStateCurrentSession];
        self.currentFrameNumber = [defaults integerForKey:kSessionStateCurrentFrame];
        self.nextFreeSessionIndex = [defaults integerForKey:kSessionStateNextFree];
        return YES;
    }

    return NO;
}

- (void)reset {
    self.currentSessionIndex = 0;
    self.currentFrameNumber = 0;
    self.nextFreeSessionIndex = 0;
    [self saveState];
}

- (NSInteger)allocateNextFreeSession {
    // TODO: Implement session allocation logic
    // For now, just increment and return
    NSInteger allocated = self.nextFreeSessionIndex;
    self.nextFreeSessionIndex++;
    [self saveState];
    return allocated;
}

#pragma mark - Property Setters (Auto-save on change)

- (void)setCurrentSessionIndex:(NSInteger)currentSessionIndex {
    if (_currentSessionIndex != currentSessionIndex) {
        _currentSessionIndex = currentSessionIndex;
        [self saveState];
    }
}

- (void)setCurrentFrameNumber:(NSInteger)currentFrameNumber {
    if (_currentFrameNumber != currentFrameNumber) {
        _currentFrameNumber = currentFrameNumber;
        [self saveState];
    }
}

@end
