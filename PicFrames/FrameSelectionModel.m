//
//  FrameSelectionModel.m
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//  Simple model to manage frame selection state
//

#import "FrameSelectionModel.h"

@interface FrameSelectionModel()
@property (nonatomic, assign, readwrite) NSInteger selectedFrameIndex;
@property (nonatomic, assign, readwrite) FrameType selectedFrameType;
@end

@implementation FrameSelectionModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedFrameIndex = 0; // 0 means no selection (frames start at 1)
        _selectedFrameType = FrameTypeNormal;
    }
    return self;
}

- (void)selectFrameAtIndex:(NSInteger)index frameType:(FrameType)type {
    printf("\n[MODEL] ═══════════════════════════════════════\n");
    printf("[MODEL] Selecting frame: index=%ld, type=%d\n", (long)index, type);

    _selectedFrameIndex = index;
    _selectedFrameType = type;

    printf("[MODEL] Selection updated: hasSelection=%s\n", self.hasSelection ? "YES" : "NO");
    printf("[MODEL] ═══════════════════════════════════════\n\n");

    // Notify listeners
    if (self.onSelectionChanged) {
        self.onSelectionChanged(index, type);
    }
}

- (void)clearSelection {
    printf("[MODEL] Clearing selection\n");
    _selectedFrameIndex = 0;
    _selectedFrameType = FrameTypeNormal;

    if (self.onSelectionChanged) {
        self.onSelectionChanged(0, FrameTypeNormal);
    }
}

- (BOOL)hasSelection {
    return _selectedFrameIndex >= 1; // Frames are 1-indexed
}

@end
