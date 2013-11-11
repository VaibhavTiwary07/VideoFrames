//
//  fbmgr.h
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 7/22/11.
//  Copyright 2011 motorola. All rights reserved.
//
#if 0
#import <Foundation/Foundation.h>
#import "Facebook.h"
#import "FBConnect.h"
#include "config.h"
#import "Settings.h"

@protocol fbmgrDelegate 
- (void)loginStatus:(BOOL)isSuccess;
@end

@interface fbmgr : NSObject <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>
{
    Facebook *_facebook;
    NSArray  *_permissions;
    
    id <fbmgrDelegate> fbDelegate;
    BOOL      _isLoggedIn;
    Settings *nvm;
    BOOL bIsLoginInProgress;
}

@property(nonatomic,readwrite)BOOL _isLoggedIn;
@property(nonatomic,assign)Facebook *_facebook;
@property(nonatomic,assign)id <fbmgrDelegate> fbDelegate;

+(fbmgr*)Instance;
-(void)getTheAlbumFor:(id)del;
- (void)login;
- (void)logout;
-(BOOL)isLoginValid;
@end
#endif