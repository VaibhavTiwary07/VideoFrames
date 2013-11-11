//
//  TwitpicManager.h
//  GlowLabels
//
//  Created by Vijaya kumar reddy Doddavala on 8/3/11.
//  Copyright 2011 motorola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"

@protocol TwitpicManagerDelegate 
-(void)updateCommand:(eUPLOAD_CMD)eCmd status:(BOOL)status msg:(NSString*)mg;
@end

@interface TwitpicManager : NSObject <NSXMLParserDelegate>
{
    //NSString *pUser;
    //NSString *pPassword;
    id <TwitpicManagerDelegate> delegate;
}
//@property(retain)NSString *pUser;
//@property(retain)NSString *pPassword;
@property(retain)id <TwitpicManagerDelegate> delegate;

-(void)upload:(UIImage*)pImg withStatus:(NSString*)pstr user:(NSString*)usr password:(NSString*)pass;

@end
