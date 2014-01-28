//
//  Settings.h
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 10/7/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "config.h"

typedef struct
{
    BOOL facebookLogin;
    BOOL videoTutorialWatched;
    int  nextFreeSessionIndex;
    int  currentSessionIndex;
    int  currentFrameNumber;
    int  sessionCount;
    float wRatio;
    float hRatio;
    float maxRatio;
    eAspectRatio aspectRatio;
}stSettings;

typedef enum
{
    RESOLUTION_PIXCOUNT_HIGH0,
    RESOLUTION_PIXCOUNT_HIGH1,
    RESOLUTION_PIXCOUNT_MED0,
    RESOLUTION_PIXCOUNT_MED1,
    RESOLUTION_PIXCOUNT_MED2,
    RESOLUTION_PIXCOUNT_LOW0,
    RESOLUTION_PIXCOUNT_LOW1,
    RESOLUTION_PIXCOUNT_LOW2,
    
    RESOLUTION_PIXCOUNT_MAX
}eResolutionType;

@interface Settings : NSObject 
{
    stSettings mstSettings;
    Reachability* internetReach;
    eResolutionType _uploadResolution;
}

@property(nonatomic,readwrite)eAspectRatio aspectRatio;
@property(nonatomic,readwrite)eUPLOAD_CMD uploadCommand;
@property(nonatomic,readwrite)eResolutionType uploadResolution;
@property(nonatomic,readwrite)CGSize uploadSize;
@property(nonatomic,readwrite)BOOL facebookLogin;
@property(nonatomic,readonly)BOOL connectedToInternet;
@property(nonatomic,readwrite)BOOL videoTutorialWatched;
@property(nonatomic,readonly)int nextFreeSessionIndex;
@property(nonatomic,readwrite)int currentSessionIndex;
@property(nonatomic,readwrite)int currentFrameNumber;
@property(nonatomic,readonly)float wRatio;
@property(nonatomic,readonly)float hRatio;
@property(nonatomic,readonly)float maxRatio;
@property(nonatomic,assign)BOOL noAdMode;


+(Settings*)Instance ;
+(id)allocWithZone:(NSZone *)zone;
-(UIImage*)generateTheImage;
-(CGSize)getTheSizeForResolution:(eResolutionType)eResType;
+(CGSize)aspectRatioToValues:(eAspectRatio)ratio;
-(void)setNoAdMode:(BOOL)yesOrNo;
-(BOOL)getNoAdMode;
@end
