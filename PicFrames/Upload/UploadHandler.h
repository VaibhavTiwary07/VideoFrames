//
//  UploadHandler.h
//  Color Splurge
//
//  Created by Vijaya kumar reddy Doddavala on 10/8/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TWITTER_SUPPORT_ENABLED
#import "CustomAlertView.h"
#import "TwitpicManager.h"
#endif
#import "Appirater.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Settings.h"
#import "Utility.h"
#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"
#import "Session.h"
//#import "TwitpicManager.h"
//#import <FBSDKShareKit/FBSDKShareKit.h>
typedef struct 
{
    char user[64];
    char password[64];
}t_TwitterCredentials;


@interface UploadHandler : NSObject <UIAlertViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate> //FBSDKSharingDelegate
{
    /* Facebook like */
    BOOL bAlreadyLiked;
    
    /* twitter username and password */
    t_TwitterCredentials tCredentials;
    NSString *twitUser;
    NSString *twitPassword;
    
    __weak UIView *view;
    
    Settings *nvm;
    
    UITextField *textField;
    NSString *msg;
    UIDocumentInteractionController *documentInteractionController;
    UIViewController *viewController;
}

-(void)upload;
#if TWITTER_SUPPORT_ENABLED
-(void)setTwitterUser:(NSString*)user password:(NSString*)pass;
#endif
@property (nonatomic,retain)UIViewController *viewController;
@property(nonatomic,weak)UIView *view;
@property(nonatomic,assign)Session *cursess;
//New Value Is Adding
@property(nonatomic,assign)int savingCountLimit;
@property(nonatomic,assign)int currentSavingCount;
-(UIImage*)getTheSnapshot;
@end
