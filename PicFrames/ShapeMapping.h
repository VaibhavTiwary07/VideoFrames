//
//  ShapeMapping.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 12/9/12.z,.xcnzkljvzs
//
//

#import <Foundation/Foundation.h> /*asldhaksjalkjf*/

typedef enum
{
    FRAME_SHAPE_GROUP_1,
    FRAME_SHAPE_GROUP_LAST
}eFrameShapeGroup;

typedef enum
{
    FRAME_SHAPE_1,
    FRAME_SHAPE_2,
    FRAME_SHAPE_3,
    FRAME_SHAPE_4,
    FRAME_SHAPE_5,
    FRAME_SHAPE_6,
    FRAME_SHAPE_7,
    FRAME_SHAPE_8,
    FRAME_SHAPE_9,
    FRAME_SHAPE_10,
    FRAME_SHAPE_11,
    FRAME_SHAPE_12,
    FRAME_SHAPE_13,
    FRAME_SHAPE_14,
    FRAME_SHAPE_15,
    FRAME_SHAPE_16,
    FRAME_SHAPE_LAST,
}eFrameShape;

@interface ShapeMapping : NSObject

//+(BOOL)isShapeLockedAtIndex:(int)shape;
+(NSString*)nameOfTheShapeAtIndex:(int)shape;
+(int)shapeCount;
+(void)setLockStatusOfShape:(int)fil group:(int)grp to:(BOOL)newstatus;
+(int)getLockStatusOfShape:(int)fil group:(int)grp;
@end
