//
//  HelpGridView.h
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 4/24/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpFrame.h"
#import "Utility.h"


#define HELP_PAGECONTROL_HEIGHT ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?60:38)
#define TOP_DELIMITER      ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?50:30)
#define HELP_GRID_RADIUS   ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?16:8)
#define GESTURE_SCALE      ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?2:1)

@interface HelpGridView : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrlView;
    UIPageControl *pgControl;
}

-(void)dismissModel;
@end
