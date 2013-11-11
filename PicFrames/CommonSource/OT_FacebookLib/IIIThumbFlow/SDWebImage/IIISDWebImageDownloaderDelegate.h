/*
 * This file is part of the IIISDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "IIISDWebImageCompat.h"

@class IIISDWebImageDownloader;

/**
 * Delegate protocol for IIISDWebImageDownloader
 */
@protocol IIISDWebImageDownloaderDelegate <NSObject>

@optional

- (void)imageDownloaderDidFinish:(IIISDWebImageDownloader *)downloader;

/**
 * Called repeatedly while the image is downloading when [IIISDWebImageDownloader progressive] is enabled.
 *
 * @param downloader The IIISDWebImageDownloader instance
 * @param image The partial image representing the currently download portion of the image
 */
- (void)imageDownloader:(IIISDWebImageDownloader *)downloader didUpdatePartialImage:(UIImage *)image;

/**
 * Called when download completed successfuly.
 *
 * @param downloader The IIISDWebImageDownloader instance
 * @param image The downloaded image object
 */
- (void)imageDownloader:(IIISDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image;

/**
 * Called when an error occurred
 *
 * @param downloader The IIISDWebImageDownloader instance
 * @param error The error details
 */
- (void)imageDownloader:(IIISDWebImageDownloader *)downloader didFailWithError:(NSError *)error;

@end
