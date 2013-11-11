//
//  YouTubeView.h
//  ShareView
//
//  Created by Outthinking Mac 1 on 07/09/13.
//  Copyright (c) 2013 OutThinking India Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GData.h"
#import "WCAlertView.h"
@interface YouTubeView : UIView<UITextFieldDelegate>{
    IBOutlet UITextField *mUsernameField;
    IBOutlet UITextField *mPasswordField;
    IBOutlet UIProgressView *mProgressView;

    UITextField *mDeveloperKeyField;
    UITextField *mClientIDField;
    UITextField *mTitleField;
    UITextField *mDescriptionField;
    UITextField *mKeywordsField;
    UITextField *mCategoryField;
    BOOL mIsPrivate;

    GDataServiceTicket *mUploadTicket;
    UIImageView *backgroundImage;
}

@property (nonatomic, retain)  UITextField *mUsernameField;
@property (nonatomic, retain)  UITextField *mPasswordField;
@property (nonatomic, retain)  UIProgressView *mProgressView;
@property (nonatomic, retain) NSString *filePath;

- (IBAction)uploadPressed:(id)sender;


@end
