//
//  HelpScreenViewController.h
//  HelpScreen
//
//  Created by Outthinking Mac 1 on 30/08/13.
//  Copyright (c) 2013 OutThinking India Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"
@interface HelpScreenViewController : UIViewController<KASlideShowDelegate,UIGestureRecognizerDelegate>
-(void)finishedWithHelpScreen:(void (^)(bool finished))complete;
@end
