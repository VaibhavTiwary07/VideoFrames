//
//  Resolution.h
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 10/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "UploadManager.h"

#define MIN_RESOLUTION_TOSCALE 300
#define RESOLUTION_SCALE_STEP  300

#if 0
typedef enum
{
    RES_UPLOAD_MODE,
    RES_DIRECT_POSTCARD_MODE,
    RES_DIRECT_SAVE_MODE,
    RES_FIXED_MODE,
    RES_MAX_MODE
}eResolutionMode;


#define RESOLUTION_PIXCOUNT_HIGH0 2400
#define RESOLUTION_PIXCOUNT_HIGH1 2100
#define RESOLUTION_PIXCOUNT_MED0 1800
#define RESOLUTION_PIXCOUNT_MED1 1500
#define RESOLUTION_PIXCOUNT_MED2 1200
#define RESOLUTION_PIXCOUNT_LOW0 900
#define RESOLUTION_PIXCOUNT_LOW1 600
#define RESOLUTION_PIXCOUNT_LOW2 300
#endif
typedef enum
{
    RESOLUTION_SECTION_HIGH,
    RESOLUTION_SECTION_MEADIUM,
    RESOLUTION_SECTION_LOW,
    RESOLUTION_SECTION_MAX,
}eResolutionSection;

@interface Resolution : UITableViewController 
{
    CGSize size;
    Settings *nvm;
    
    //eResolutionMode resolutionMode;
    int scaledDownSizes;
}

//@property(nonatomic,readwrite)eResolutionMode resolutionMode;
@property(nonatomic,readwrite)CGSize size;
@property(nonatomic,assign)id delegateController;

@end
