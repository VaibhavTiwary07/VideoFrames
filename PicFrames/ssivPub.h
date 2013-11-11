//
//  ssivPub.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/25/12.
//
//

#ifndef Instapicframes_ssivPub_h
#define Instapicframes_ssivPub_h

typedef enum
{
    SHAPE_NOSHAPE,
    SHAPE_CIRCLE=1,
    SHAPE_ZIGZAG=2,
    SHAPE_BUTTERFLY=3,
    SHAPE_STAR=4,
    SHAPE_TRIANGLE=5,
    SHAPE_FLOWER=6,
    SHAPE_DIAMONDFLOWER=7,
    SHAPE_HEART=8,
    SHAPE_HEXAGON=9,
    SHAPE_CHRISTMASTREE=10,
    SHAPE_CHRISTMASLIGHT=11,
    SHAPE_LEAF=12,
    SHAPE_APPLE=13,
    SHAPE_MESSAGE=14,
    SHAPE_CLOUD=15,
    SHAPE_BROKENHEART=16,
    SHAPE_LAST
}eShape;

#define ssiv_notification_snapshotmode_enter @"ssiv_notification_snapshotmode_enter"
#define ssiv_notification_snapshotmode_exit @"ssiv_notification_snapshotmode_exit"

#endif
