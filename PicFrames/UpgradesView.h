//
//  UpgradesView.h
//  InstaSplash
//
//  Created by Vijaya kumar reddy Doddavala on 9/27/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "InAppInstaSplashIAPHelper.h"
#import "InAppPurchaseManager.h"
#import "OT_OfferWallView.h"
#import "CellFullSizeText.h"
#import "config.h"
#import "TapjoyConnect.h"
#import "goalBasedOfferWallController.h"
#import "tapPoints.h"
#import "PhotoEffects_Config.h"
#import "WCAlertView.h"
#import "FTWButton.h"
#import "PopoverView.h"
#import "Flurry.h"

#define TAPPOINTS_TO_REMOVE_ADS 30


@interface UpgradesView : UITableView <UITableViewDataSource,UITableViewDelegate,goalbasedOfferWallDelegate>

@property(nonatomic,assign)UIViewController *controller;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style toobar:(UIToolbar*)tbar title:(UILabel*)title;
@end
