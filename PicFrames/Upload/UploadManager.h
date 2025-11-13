//
//  UploadManager.h
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 8/31/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "config.h"
#import "Appirater.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Settings.h"
#import "Resolution.h"


typedef enum
{
    UPLOAD_SECTION_INSTAGRAM,
    UPLOAD_SECTION_ACTIONS,
    UPLOAD_SECTION_SERVICES,
    UPLOAD_SECTION_MAX
}eUploadSection;

typedef enum
{
    UPLOAD_PRODUCT_INSTAGRAM,
    UPLOAD_PRODUCT_MAX
}eUploadProduct;

typedef enum
{
    UPLOAD_ACTION_SAVE,
    UPLOAD_ACTION_EMAIL,
    UPLOAD_ACTION_COPY,
    UPLOAD_ACTION_MAX
}eUploadAction;

typedef enum
{
    UPLOAD_SERVICE_FACEBOOK,
    UPLOAD_SERVICE_FACEBOOKWALL,
    //UPLOAD_SERVICE_TWITTER,
    UPLOAD_SERVICE_MAX
}eUploadService;

@interface UploadManager : UITableViewController 
{
    /* Facebook like */
    BOOL bAlreadyLiked;

    NSString *twitUser;
    NSString *twitPassword;
    
    Settings *nvm;
   
}

@property(nonatomic,assign)id delegateController;
@property(nonatomic,assign) BOOL imageSavedOnce;

@end
