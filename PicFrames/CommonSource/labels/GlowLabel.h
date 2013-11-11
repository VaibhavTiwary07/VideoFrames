//
//  GlowLabel.h
//  LabelRND
//
//  Created by Vijaya kumar reddy Doddavala on 7/19/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuartzCore/CALayer.h"

#define deletedlabel      @"deletedlabel"
#define labeltag          7000

@interface GlowLabel : UITextField <UITextFieldDelegate>
{
    id subview;
    NSTimer *deleteTimer;
    UILongPressGestureRecognizer * recognizer;
    
    BOOL bDoneEditing;
    BOOL bSuspendEditing;
}

-(void)doneWithEditing;
-(void)setShadowColorTo:(UIColor*)color;
-(void)setExtraView:(id)extraView;
-(id)getExtraView;
-(void)initializeWithdefaults;
-(void)putInSuspendedState;
-(void)putInReadystate;
@end
