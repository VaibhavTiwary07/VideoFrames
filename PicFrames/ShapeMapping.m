////
//  ShapeMapping.m
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 12/9/12.
//
//

#import "ShapeMapping.h"
#import "Config.h"

@implementation ShapeMapping

typedef struct
{
    int shape;
    NSString *name;
    BOOL bLocked;
}tShapeMap;

static BOOL shapelockstatus[FRAME_SHAPE_GROUP_LAST][30];

static tShapeMap shape_mapping[FRAME_SHAPE_LAST] = {
    {FRAME_SHAPE_1,@"Original",NO},
    {FRAME_SHAPE_2,@"Circle",NO},
    {FRAME_SHAPE_3,@"Zigzag",YES},
    {FRAME_SHAPE_4,@"Butterfly",YES},
    {FRAME_SHAPE_5,@"Star",YES},
    {FRAME_SHAPE_6,@"Triangle",YES},
    {FRAME_SHAPE_7,@"Flower 1",NO},
    {FRAME_SHAPE_8,@"Flower 2",YES},
    {FRAME_SHAPE_9,@"Heart",YES},
    {FRAME_SHAPE_10,@"Hexagon",NO},
    {FRAME_SHAPE_11,@"Xmas Tree",YES},
    {FRAME_SHAPE_12,@"Xmas Light",YES},
    {FRAME_SHAPE_13,@"Leaf",YES},
    {FRAME_SHAPE_14,@"Apple",YES},
    {FRAME_SHAPE_15,@"MessageBox",YES},
    {FRAME_SHAPE_16,@"Cloud",YES}
};

+ (void)setLockStatusOfShape:(int)fil group:(int)grp to:(BOOL)newstatus
{
    if(shapelockstatus[grp][fil] == newstatus)
    {
        return;
    }
    
    shapelockstatus[grp][fil] = newstatus;
    NSData *data = [NSData dataWithBytes:&shapelockstatus[0] length:(sizeof(BOOL) * FRAME_SHAPE_GROUP_LAST * 30)];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"shapelockstatus"];
    
    return;
}

+ (int)getLockStatusOfShape:(int)fil group:(int)grp
{
    if(bought_allpackages)
    {
        return NO;
    }
    
    
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"shapelockstatus"];
    if(nil == data)
    {
        memset(&shapelockstatus[0],1,sizeof(BOOL) * FRAME_SHAPE_GROUP_LAST * 30);
        
        /* store the values in lockstatus and upload to defaults */
        for(int i = 0; i < FRAME_SHAPE_LAST; i++)
        {
            shapelockstatus[FRAME_SHAPE_GROUP_1][i] = shape_mapping[i].bLocked;
            NSLog(@"Shape Lock Status for shape %d is %d",i,shapelockstatus[FRAME_SHAPE_GROUP_1][i]);
        }
        
        /* update in defaults */
        NSData *data = [NSData dataWithBytes:&shapelockstatus[0] length:(sizeof(BOOL) * FRAME_SHAPE_GROUP_LAST * 30)];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"shapelockstatus"];
    }
    else
    {
        memcpy(&shapelockstatus[0], data.bytes, data.length);
    }
    
    return shapelockstatus[grp][fil];
}

+ (BOOL)isShapeLockedAtIndex:(int)shape
{
    return shape_mapping[shape].bLocked;
}

+ (NSString*)nameOfTheShapeAtIndex:(int)shape
{
    NSLog(@"shape name is %@",shape_mapping[shape].name);
    return shape_mapping[shape].name;
}

+ (int)shapeCount
{
    return FRAME_SHAPE_LAST;
}
@end
