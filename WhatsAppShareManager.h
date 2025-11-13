//
//  WhatsAppShareManager.h
//  VideoFrames
//
//  Created by apple on 04/07/25.
//
#import <UIKit/UIKit.h>

@interface WhatsAppShareManager : NSObject

+ (instancetype)sharedManager;

- (void)shareImageToWhatsApp:(UIImage *)image fromViewController:(UIViewController *)viewController;
- (void)shareVideoToWhatsApp:(NSURL *)videoURL fromViewController:(UIViewController *)viewController;

@end
