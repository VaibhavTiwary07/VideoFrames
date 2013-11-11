//
//  Adjustor.h
//  PicFrames
//
//  Created by Sunitha Gadigota on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Photo.h"

#define MINIMUM_WIDTH_OR_HEIGHT 30

@interface Adjustor : UIView
{
    CGRect _actualFrame;
    
    float rowCount;
    float colCount;
    float rowIndex;
    float colIndex;
}

@property(nonatomic,assign)NSMutableArray *adjustors;
@property(nonatomic,readwrite)eAdjustorShape eShape;
@property(nonatomic,readwrite)CGRect actualFrame;
@property(nonatomic,readwrite)float rowCount;
@property(nonatomic,readwrite)float colCount;
@property(nonatomic,readwrite)float rowIndex;
@property(nonatomic,readwrite)float colIndex;

- (id)initWithFrame:(CGRect)frame photos:(NSArray*)array;

@end
