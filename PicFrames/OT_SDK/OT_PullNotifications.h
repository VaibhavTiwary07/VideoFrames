//
//  onlineDailyNews.h
//  CustomTableViewCell
//
//  Created by Vijaya kumar reddy Doddavala on 1/10/11.
//  Copyright 2011 Out Thinking Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OT_Config.h"

@interface OT_PullNotifications : NSObject <NSXMLParserDelegate>

/****************************************************************
 This property is used to configure the cace size of the ads.
 It is integer value to configure number of ads to cache
 ****************************************************************/
@property(nonatomic,readwrite)int cacheSize;

/****************************************************************
 This function gets the ads from out thinking server and shows it 
 to the user
 ****************************************************************/
-(void)showPullNotification;

/****************************************************************
 This function gets the ads from out thinking server and shows it 
 to the user in asynchronusly
 ****************************************************************/
-(void)showAsynchPullNotification;

/****************************************************************
 This function gets the ads from out thinking server and shows it 
 to the user. this can be used while exiting the app
 ****************************************************************/
+(void)scheduleNotification;

/****************************************************************
 This function gets the ads from out thinking server and shows it 
 to the user. this can be used while exiting the app
 ****************************************************************/
-(BOOL)loadNotifications;


@end
