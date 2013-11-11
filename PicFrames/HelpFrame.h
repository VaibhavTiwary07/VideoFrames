//
//  HelpFrame.h
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 4/19/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SWSnapshotStackView.h"

#define LEFT_DELIMITER 15.0
#define TITLE_DELIMITER 30.0
#define HELPTEXT_HEIGHT 30.0
#define HELPTEXT_FONTSIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?20.0:12.0)
#define TITLETEXT_FONTSIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?25.0:15.0)

@interface HelpFrame : UIImageView

@property(nonatomic,assign)UIImage *centerImage; 
@property(nonatomic,assign)UIImage *centerStackImage; 

-(void)setHelpText:(NSString*)text;
-(void)setTitleText:(NSString*)text;
-(void)setCenterImageContentMode:(UIViewContentMode)eM;

@end
