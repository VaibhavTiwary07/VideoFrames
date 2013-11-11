/*
 * This file is part of the IIISDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "IIISDWebImageCompat.h"
#import "IIISDWebImageDownloaderDelegate.h"
#import "IIISDWebImageManagerDelegate.h"
#import "IIISDImageCacheDelegate.h"

typedef enum
{
    IIISDWebImageRetryFailed = 1 << 0,
    IIISDWebImageLowPriority = 1 << 1,
    IIISDWebImageCacheMemoryOnly = 1 << 2,
    IIISDWebImageProgressiveDownload = 1 << 3
} IIISDWebImageOptions;

#if NS_BLOCKS_AVAILABLE
typedef void(^IIISDWebImageSuccessBlock)(UIImage *image, BOOL cached);
typedef void(^IIISDWebImageFailureBlock)(NSError *error);
#endif

/**
 * The IIISDWebImageManager is the class behind the UIImageView+WebCache category and likes.
 * It ties the asynchronous downloader (IIISDWebImageDownloader) with the image cache store (IIISDImageCache).
 * You can use this class directly to benefit from web image downloading with caching in another context than
 * a UIView.
 *
 * Here is a simple example of how to use IIISDWebImageManager:
 *
 *  IIISDWebImageManager *manager = [IIISDWebImageManager sharedManager];
 *  [manager downloadWithURL:imageURL
 *                  delegate:self
 *                   options:0
 *                   success:^(UIImage *image, BOOL cached)
 *                   {
 *                       // do something with image
 *                   }
 *                   failure:nil];
 */
@interface IIISDWebImageManager : NSObject <IIISDWebImageDownloaderDelegate, IIISDImageCacheDelegate>
{
    NSMutableArray *downloadInfo;
    NSMutableArray *downloadDelegates;
    NSMutableArray *downloaders;
    NSMutableArray *cacheDelegates;
    NSMutableArray *cacheURLs;
    NSMutableDictionary *downloaderForURL;
    NSMutableArray *failedURLs;
}

#if NS_BLOCKS_AVAILABLE
typedef NSString *(^CacheKeyFilter)(NSURL *url);

/**
 * The cache filter is a block used each time IIISDWebManager need to convert an URL into a cache key. This can
 * be used to remove dynamic part of an image URL.
 *
 * The following example sets a filter in the application delegate that will remove any query-string from the
 * URL before to use it as a cache key:
 *
 * 	[[IIISDWebImageManager sharedManager] setCacheKeyFilter:^(NSURL *url)
 *	{
 *	    url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
 *	    return [url absoluteString];
 *	}];
 */
@property (strong) CacheKeyFilter cacheKeyFilter;
#endif


/**
 * Returns global IIISDWebImageManager instance.
 *
 * @return IIISDWebImageManager shared instance
 */
+ (id)sharedManager;

- (UIImage *)imageWithURL:(NSURL *)url __attribute__ ((deprecated));

/**
 * Downloads the image at the given URL if not present in cache or return the cached version otherwise.
 *
 * @param url The URL to the image
 * @param delegate The delegate object used to send result back
 * @see [IIISDWebImageManager downloadWithURL:delegate:options:userInfo:]
 * @see [IIISDWebImageManager downloadWithURL:delegate:options:userInfo:success:failure:]
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate;

/**
 * Downloads the image at the given URL if not present in cache or return the cached version otherwise.
 *
 * @param url The URL to the image
 * @param delegate The delegate object used to send result back
 * @param options A mask to specify options to use for this request
 * @see [IIISDWebImageManager downloadWithURL:delegate:options:userInfo:]
 * @see [IIISDWebImageManager downloadWithURL:delegate:options:userInfo:success:failure:]
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate options:(IIISDWebImageOptions)options;

/**
 * Downloads the image at the given URL if not present in cache or return the cached version otherwise.
 *
 * @param url The URL to the image
 * @param delegate The delegate object used to send result back
 * @param options A mask to specify options to use for this request
 * @param info An NSDictionnary passed back to delegate if provided
 * @see [IIISDWebImageManager downloadWithURL:delegate:options:success:failure:]
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate options:(IIISDWebImageOptions)options userInfo:(NSDictionary *)info;

// use options:IIISDWebImageRetryFailed instead
- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed __attribute__ ((deprecated));
// use options:IIISDWebImageRetryFailed|IIISDWebImageLowPriority instead
- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed lowPriority:(BOOL)lowPriority __attribute__ ((deprecated));

#if NS_BLOCKS_AVAILABLE
/**
 * Downloads the image at the given URL if not present in cache or return the cached version otherwise.
 *
 * @param url The URL to the image
 * @param delegate The delegate object used to send result back
 * @param options A mask to specify options to use for this request
 * @param success A block called when image has been retrived successfuly
 * @param failure A block called when couldn't be retrived for some reason
 * @see [IIISDWebImageManager downloadWithURL:delegate:options:]
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id)delegate options:(IIISDWebImageOptions)options success:(IIISDWebImageSuccessBlock)success failure:(IIISDWebImageFailureBlock)failure;

/**
 * Downloads the image at the given URL if not present in cache or return the cached version otherwise.
 *
 * @param url The URL to the image
 * @param delegate The delegate object used to send result back
 * @param options A mask to specify options to use for this request
 * @param info An NSDictionnary passed back to delegate if provided
 * @param success A block called when image has been retrived successfuly
 * @param failure A block called when couldn't be retrived for some reason
 * @see [IIISDWebImageManager downloadWithURL:delegate:options:]
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id)delegate options:(IIISDWebImageOptions)options userInfo:(NSDictionary *)info success:(IIISDWebImageSuccessBlock)success failure:(IIISDWebImageFailureBlock)failure;
#endif

/**
 * Cancel all pending download requests for a given delegate
 *
 * @param delegate The delegate to cancel requests for
 */
- (void)cancelForDelegate:(id<IIISDWebImageManagerDelegate>)delegate;

/**
 * Cancel all current opreations
 */
- (void)cancelAll;

@end
