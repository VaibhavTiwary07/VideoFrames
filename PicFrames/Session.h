//
//  Session.h
//  PicFrame
//
//  Created by Vijaya kumar reddy Doddavala on 2/28/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DBUtilities.h"
#import "Frame.h"
#import "Settings.h"
#import "SessionDB.h"
#import "Utility.h"
#import "ssivPub.h"

#define DEFAULT_ASPECTRATIO 1
#define DEFAULT_FRAMEWIDTH  DEFAULT_FRAME_WIDTH

typedef enum
{
    FRAME_RESOURCE_TYPE_INVALID,
    FRAME_RESOURCE_TYPE_PHOTO,
    FRAME_RESOURCE_TYPE_VIDEO
}eFrameResourceType;

typedef struct
{
    float fRed;
    float fGreen;
    float fBlue;
    float fAlpha;
}stColor;

@interface Session : NSObject
{
    int iSessionId;
    int iFrameNumber;
    int iPattern;
    int iAspectRatio;
    float fInnerRadius;
    float fOuterRadius;
    float fFrameWidth;
    BOOL bPatternSelected;
    stColor sColor;
    
    Frame *_frame;
    Settings *nvm;
}

@property(nonatomic,readwrite)int frameNumber;
@property(nonatomic,readwrite)int sessionId;
@property(nonatomic,readwrite)int pattern;
@property(nonatomic,readwrite)int aspectRatio;
@property(nonatomic,readwrite)float innerRadius;
@property(nonatomic,readwrite)float outerRadius;
@property(nonatomic,readwrite)float frameWidth;
@property(nonatomic,readonly)BOOL patternSelected;
@property(nonatomic,readwrite)BOOL videoSelected;
@property(nonatomic,assign)UIColor *color;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,assign)Frame *frame;
@property(nonatomic,assign)UIImage *imageFromApp;
@property(nonatomic,retain)NSMutableArray *playerItems;
@property(nonatomic,retain)NSMutableArray *players
;
-(id)initWithSessionId:(int)sessionId;
-(id)initWithFrameNumber:(int)iFrmNumber;

-(void)showSessionOn:(UIView*)view;
-(void)hideSession;
-(void)imageSelectedForPhoto:(UIImage*)img;
-(void)imageSelectedForPhoto:(UIImage*)img indexOfPhoto:(int)photoNumer;
-(void)imageEditedForPhoto:(UIImage*)img;
-(NSMutableArray*)eraseAndReturnImagesForAnimation;
-(void)deleteAllSessionResources;

-(void)updateTheSessionIcon;
+(UIImage *)iconImageFromSession:(int)sessionId;
+(NSDate*)createdDateForSession:(int)sessionId;
+(void)deleteSessionWithId:(int)sessId;
-(NSMutableArray*)eraseCurImageAndReturnImageForAnimation;
-(void)shapeSelectedForPhoto:(eShape)shape;
-(int)shapeOfCurrentlySelectedPhoto;
-(void)shapePreviewSelectedForPhoto:(eShape)shape;
-(void)shapePreviewCancelled;
//-(void)videoSelectedForPhoto:(UIImage *)img atPath:(NSURL*)path;
//-(void)videoSelectedForCurrentPhotoWithInfo:(NSDictionary*)videoInfo;
-(void)videoSelectedForCurrentPhotoWithInfo:(NSDictionary*)videoInfo image:(UIImage*)img;
-(void)previewVideo;
-(void)saveVideoToDocDirectory:(NSURL*)url completion:(void (^)(NSString *localVideoPath))complete;
-(int)photoNumberOfCurrentSelectedPhoto;
-(NSString*)pathForImageAtIndex:(int)index inPhoto:(int)photoIndex;
-(NSString*)getVideoInfoKeyForPhotoAtIndex:(int)index;
-(int)getFrameCountForPhotoAtIndex:(int)index;
-(int)getFrameCountOfFrame:(Frame*)frame;
-(NSString*)pathToCurrentVideo;
-(UIImage*)getVideoFrameAtIndex:(int)frameIndex forPhoto:(int)photoIndex;
-(eFrameResourceType)getFrameResourceTypeAtIndex:(int)index;
-(double)getVideoDurationForPhotoAtIndex:(int)index;
-(double)getMaxVideoDuration:(BOOL)isSequentialPlay;
-(NSURL*)getVideoUrlForPhotoAtIndex:(int)index;
-(NSString*)pathToIntermediateVideo;
-(void)deleteVideoFramesForPhotoAtIndex:(int)photoIndex;
-(void)deleteVideoAtPhototIndex:(int)photoIndex;
-(void)deleteImageOfFrame:(int)photoIndex frame:(int)frameIndex;
-(BOOL)anyVideoFrameSelected;
-(void)handleVideoFrameSettingsUpdate;
-(void)restoreFrameImages;
-(NSString*)pathToCurrentAudioMix;
-(NSString *)pathToAudioOfRespectedVideo:(int)videoIndex;
-(void)deleteCurrentAudioMix;
-(NSString*)pathToMusciSelectedFromLibrary;
-(void)enterNoTouchMode;
-(void)exitNoTouchMode;
-(void)enterTouchModeForSlectingImage:(int)photoIndex;
-(void)exitTouchModeForSlectingImage;
-(UIImage*)getImageAtIndex:(int)index;
-(void)saveImageAfterApplyingEffect:(UIImage *)image atPhotoIndex:(int)photoIndex atFrameIndex:(int)frameIndex;
-(void)saveImage:(UIImage*)img atIndex:(int)index;
@end
