//
//  FrameSelectionModel.h
//  PicFrames
//
//  Created by Claude on 2025-11-18.
//  Simple model to manage frame selection state
//

#import <Foundation/Foundation.h>

@interface FrameSelectionModel : NSObject

// Current selection state
@property (nonatomic, assign, readonly) NSInteger selectedFrameIndex;
@property (nonatomic, assign, readonly) NSInteger selectedFrameType;
@property (nonatomic, assign, readonly) BOOL hasSelection;

// Selection management
- (void)selectFrameAtIndex:(NSInteger)index frameType:(NSInteger)type;
- (void)clearSelection;

// Callback for when selection changes
@property (nonatomic, copy) void (^onSelectionChanged)(NSInteger index, NSInteger type);

@end
