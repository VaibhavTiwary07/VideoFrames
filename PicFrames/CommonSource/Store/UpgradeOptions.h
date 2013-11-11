//
//  UpgradeOptions.h
//  MirroFx
//
//  Created by Vijaya kumar reddy Doddavala on 10/19/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "PopoverView.h"

#define bought_fullversion NO

@interface UpgradeOptions : UIView <PopoverViewDelegate>

-(void)showPopupIn:(UIView*)v at:(CGPoint)point;
@end
