//
//  VideoGridViewViewController.h
//  AlterButton
//
//  Created by Deepti's Mac on 1/8/14.
//  Copyright (c) 2014 D.Yoganjulu  Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoGridViewViewController : UIViewController
@property (nonatomic , assign)CGRect frameOfView;
@property (nonatomic , retain) NSMutableArray *imageArray;
@property (nonatomic , assign) int totalNumberOfItems;
-(NSMutableArray *)getOrderOfItem;
@end
