//
//  MKAnnotationView+WebCache.h
//  IIISDWebImage
//
//  Created by Olivier Poitrey on 14/03/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "MapKit/MapKit.h"
#import "IIISDWebImageCompat.h"
#import "IIISDWebImageManagerDelegate.h"
#import "IIISDWebImageManager.h"

/**
 * Integrates IIISDWebImage async downloading and caching of remote images with MKAnnotationView.
 */
@interface MKAnnotationView (WebCache) <IIISDWebImageManagerDelegate>

/**
 * Set the imageView `image` with an `url`.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)setImageWithURL:(NSURL *)url;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see setImageWithURL:placeholderImage:options:
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options The options to use when downloading the image. @see IIISDWebImageOptions for the possible values.
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(IIISDWebImageOptions)options;

#if NS_BLOCKS_AVAILABLE
/**
 * Set the imageView `image` with an `url`.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param success A block to be executed when the image request succeed This block has no return value and takes a Boolean as parameter indicating if the image was cached or not.
 * @param failure A block object to be executed when the image request failed. This block has no return value and takes the error object describing the network or parsing error that occurred (may be nil).
 */
- (void)setImageWithURL:(NSURL *)url success:(IIISDWebImageSuccessBlock)success failure:(IIISDWebImageFailureBlock)failure;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param success A block to be executed when the image request succeed This block has no return value and takes a Boolean as parameter indicating if the image was cached or not.
 * @param failure A block object to be executed when the image request failed. This block has no return value and takes the error object describing the network or parsing error that occurred (may be nil).
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(IIISDWebImageSuccessBlock)success failure:(IIISDWebImageFailureBlock)failure;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The downloand is asynchronous and cached.
 *
 * @param url The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options The options to use when downloading the image. @see IIISDWebImageOptions for the possible values.
 * @param success A block to be executed when the image request succeed This block has no return value and takes a Boolean as parameter indicating if the image was cached or not.
 * @param failure A block object to be executed when the image request failed. This block has no return value and takes the error object describing the network or parsing error that occurred (may be nil).
 */
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(IIISDWebImageOptions)options success:(IIISDWebImageSuccessBlock)success failure:(IIISDWebImageFailureBlock)failure;
#endif

/**
 * Cancel the current download
 */
- (void)cancelCurrentImageLoad;

@end
