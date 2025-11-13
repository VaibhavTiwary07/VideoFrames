//
//  WhatsAppShareManager.m
//  VideoFrames
//
//  Created by apple on 04/07/25.
//

#import <Foundation/Foundation.h>
#import "WhatsAppShareManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface WhatsAppShareManager () <UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) UIDocumentInteractionController *documentController;
@property (weak, nonatomic) UIViewController *currentViewController;
@end

@implementation WhatsAppShareManager

+ (instancetype)sharedManager {
    static WhatsAppShareManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public Methods

- (void)shareImageToWhatsApp:(UIImage *)image fromViewController:(UIViewController *)viewController {
    self.currentViewController = viewController;
    
    // Save image to temporary file
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    NSString *tempPath = [self temporaryFilePathForType:@"image" extension:@"jpg"];
    [imageData writeToFile:tempPath atomically:YES];
    
    [self shareMediaAtPath:tempPath isVideo:NO];
}

- (void)shareVideoToWhatsApp:(NSURL *)videoURL fromViewController:(UIViewController *)viewController {
    self.currentViewController = viewController;
    
//    // Verify video is MP4
//    if (![videoURL.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
//        [self showAlertWithTitle:@"Invalid Format" message:@"Video must be in MP4 format"];
//        return;
//    }
    
    // Copy to temporary directory
    NSString *tempPath = [self temporaryFilePathForType:@"video" extension:@"mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
    
    NSError *copyError;
    if (![[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:[NSURL fileURLWithPath:tempPath] error:&copyError]) {
        [self showAlertWithTitle:@"Error" message:@"Failed to prepare video for sharing"];
        return;
    }
    
    [self shareMediaAtPath:tempPath isVideo:YES];
}

#pragma mark - Private Methods

- (NSString *)temporaryFilePathForType:(NSString *)type extension:(NSString *)extension {
    NSString *fileName = [NSString stringWithFormat:@"whatsapp_%@_%@.%@", type, [[NSUUID UUID] UUIDString], extension];
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
}

- (void)shareMediaAtPath:(NSString *)filePath isVideo:(BOOL)isVideo {
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    // Try URL scheme method first (more direct)
    if ([self tryWhatsAppURLSchemeWithFileURL:fileURL isVideo:isVideo]) {
        return;
    }
    
    // Fall back to document interaction controller
    [self shareUsingDocumentInteractionController:fileURL isVideo:isVideo];
}

- (BOOL)tryWhatsAppURLSchemeWithFileURL:(NSURL *)fileURL isVideo:(BOOL)isVideo {
    NSString *urlString = [NSString stringWithFormat:@"whatsapp://%@?file=%@&source=%@",
                          isVideo ? @"send" : @"library",
                          fileURL.path,
                          [[NSBundle mainBundle] bundleIdentifier]];
    
    NSURL *whatsappURL = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL]) {
        [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                [self shareUsingDocumentInteractionController:fileURL isVideo:isVideo];
            }
        }];
        return YES;
    }
    return NO;
}

- (void)shareUsingDocumentInteractionController:(NSURL *)fileURL isVideo:(BOOL)isVideo {
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documentController.UTI = isVideo ? (__bridge NSString *)kUTTypeMPEG4 : (__bridge NSString *)kUTTypeJPEG;
    self.documentController.delegate = self;
    
    if (![self.documentController presentOpenInMenuFromRect:CGRectZero
                                                    inView:self.currentViewController.view
                                                  animated:YES]) {
        [self showWhatsAppNotInstalledAlert];
    }
}

#pragma mark - Alerts

- (void)showWhatsAppNotInstalledAlert {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"WhatsApp Not Installed"
        message:@"Would you like to install WhatsApp from the App Store?"
        preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction
        actionWithTitle:@"Install"
        style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {
            NSURL *appStoreURL = [NSURL URLWithString:@"https://apps.apple.com/app/whatsapp-messenger/id310633997"];
            [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
        }]];
    
    [alert addAction:[UIAlertAction
        actionWithTitle:@"Cancel"
        style:UIAlertActionStyleCancel
        handler:nil]];
    
    [self.currentViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:title
        message:message
        preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction
        actionWithTitle:@"OK"
        style:UIAlertActionStyleDefault
        handler:nil]];
    
    [self.currentViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    // Clean up if needed
    self.documentController = nil;
}

@end
