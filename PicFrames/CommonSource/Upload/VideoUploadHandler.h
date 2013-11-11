//
//  UploadHandler.h
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 10/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appirater.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "OT_Facebook.h"
#import "Utility.h"
#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"
#import "GData.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PopoverView.h"
#import "YouTubeView.h"

@interface VideoUploadHandler : NSObject <UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate,UIPopoverControllerDelegate,PopoverViewDelegate,UIWebViewDelegate>
{

    BOOL mIsPrivate;
    BOOL bAlreadyLiked;
    Settings *nvm;

    GDataServiceTicket *mUploadTicket;
    PopoverView *popover;
    YouTubeView *youtube;
    
}

-(void)uploadVideoAtPath:(NSString*)videoPath to:(eUPLOAD_CMD)eUploadOption;

/* Initializing this property is mandatory before calling uploadVideo method */
@property(nonatomic,assign)UIViewController *viewController;

/* VideoUploadHandler will add any marketing details without initializing the below
   properties */
@property(nonatomic,strong)NSString *applicationName;
@property(nonatomic,strong)NSString *downloadUrl;

/* Initializing this property will let VideoUploadHandler to share information about the website */
@property(nonatomic,strong)NSString *website;

@property (strong, nonatomic) ACAccount *facebookAccount;
@property (nonatomic , retain)NSString *filePath;

@property(nonatomic,retain)UIImage *shareImage;

@property (nonatomic,retain) UIView *_view;

@end
