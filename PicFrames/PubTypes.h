//
//  PubTypes.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 2/13/13.
//
//

#import "ssivPub.h"
#import "UploadHandlerPub.h"

#ifndef Instapicframes_PubTypes_h
#define Instapicframes_PubTypes_h
#define full_screen [[UIScreen mainScreen]bounds]
typedef enum
{
    ASPECTRATIO_1_1,
    ASPECTRATIO_3_4,
    ASPECTRATIO_4_3,
    ASPECTRATIO_2_3,
    ASPECTRATIO_3_2,
    ASPECTRATIO_1_2,
    ASPECTRATIO_2_1,
    ASPECTRATIO_MAX, // wall paper
    ASPECTRATIO_9_16,// Instagram Story
    ASPECTRATIO_4_5, // Instagram portrait
    ASPECTRATIO_5_4, // Card
    ASPECTRATIO_4_6,
    ASPECTRATIO_5_7,
    ASPECTRATIO_8_10,
    ASPECTRATIO_16_9,
    ASPECTRATIO_WALLPAPER,
    ASPECTRATIO_CUSTOM
}eAspectRatio;

typedef enum
{
    PHOTO_NOSHAPE,
    PHOTO_CIRCLE,
    PHOTO_ELLIPS,
    PHOTO_TRIANGLE
}ePhotoShape;

typedef enum
{
    ADJUSTOR_HORIZANTAL,
    ADJUSTOR_VERTICLE
    
}eAdjustorShape;

typedef struct
{
    CGRect      dimension;
    ePhotoShape eShape;
    eShape      eFrameShape;
}stPhotoInfo;

typedef struct
{
    CGRect      dimension;
    eAdjustorShape eShape;
}stAdjustorInfo;

typedef struct
{
    CGSize imageSize;
    CGPoint offset;
    float scale;
    float rotation;
}stImageInfo;

#if defined(APP_INSTAPICFRAMES)
typedef enum
{
    MODE_FRAMES,
    MODE_EDIT,
    MODE_SWAP,
    //MODE_LABELS,
    MODE_FREEAPPS,
    MODE_SHARE,
    MODE_MAX
}eAppMode;
#else
#if STANDARD_TABBAR
typedef enum
{
    MODE_FRAMES,
    MODE_EDIT,
    //
    //MODE_LABELS,
    MODE_FREEAPPS,
    MODE_SHARE,
    MODE_SWAP,
    MODE_MAX
}eAppMode;
#else
typedef enum
{
    MODE_FRAMES,
    MODE_COLOR_AND_PATTERN,
    MODE_ADJUST_SETTINGS,
    MODE_ADD_EFFECT,
    MODE_VIDEO_SETTINGS,
    MODE_PREVIEW,
    MODE_SHARE,
    //MODE_SWAP,
    MODE_SIZES,
    MODE_STICKERS,
    MODE_TEXT,
    MODE_VOLUME,
    MODE_MAX
}eAppMode;
#endif
#endif
#endif
