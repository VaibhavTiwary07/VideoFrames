/*
 * This file is part of the IIISDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "IIISDWebImageManager.h"
#import "IIISDImageCache.h"
#import "IIISDWebImageDownloader.h"
#import <objc/message.h>

static IIISDWebImageManager *instance;

@implementation IIISDWebImageManager

#if NS_BLOCKS_AVAILABLE
@synthesize cacheKeyFilter;
#endif

- (id)init
{
    if ((self = [super init]))
    {
        downloadInfo = [[NSMutableArray alloc] init];
        downloadDelegates = [[NSMutableArray alloc] init];
        downloaders = [[NSMutableArray alloc] init];
        cacheDelegates = [[NSMutableArray alloc] init];
        cacheURLs = [[NSMutableArray alloc] init];
        downloaderForURL = [[NSMutableDictionary alloc] init];
        failedURLs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    SDWISafeRelease(downloadInfo);
    SDWISafeRelease(downloadDelegates);
    SDWISafeRelease(downloaders);
    SDWISafeRelease(cacheDelegates);
    SDWISafeRelease(cacheURLs);
    SDWISafeRelease(downloaderForURL);
    SDWISafeRelease(failedURLs);
    SDWISuperDealoc;
}


+ (id)sharedManager
{
    if (instance == nil)
    {
        instance = [[IIISDWebImageManager alloc] init];
    }

    return instance;
}

- (NSString *)cacheKeyForURL:(NSURL *)url
{
#if NS_BLOCKS_AVAILABLE
    if (self.cacheKeyFilter)
    {
        return self.cacheKeyFilter(url);
    }
    else
    {
        return [url absoluteString];
    }
#else
    return [url absoluteString];
#endif
}

/*
 * @deprecated
 */
- (UIImage *)imageWithURL:(NSURL *)url
{
    return [[IIISDImageCache sharedImageCache] imageFromKey:[self cacheKeyForURL:url]];
}

/*
 * @deprecated
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed
{
    [self downloadWithURL:url delegate:delegate options:(retryFailed ? IIISDWebImageRetryFailed : 0)];
}

/*
 * @deprecated
 */
- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed lowPriority:(BOOL)lowPriority
{
    IIISDWebImageOptions options = 0;
    if (retryFailed) options |= IIISDWebImageRetryFailed;
    if (lowPriority) options |= IIISDWebImageLowPriority;
    [self downloadWithURL:url delegate:delegate options:options];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate
{
    [self downloadWithURL:url delegate:delegate options:0];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate options:(IIISDWebImageOptions)options
{
    [self downloadWithURL:url delegate:delegate options:options userInfo:nil];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<IIISDWebImageManagerDelegate>)delegate options:(IIISDWebImageOptions)options userInfo:(NSDictionary *)userInfo
{
    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, XCode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    if ([url isKindOfClass:NSString.class])
    {
        url = [NSURL URLWithString:(NSString *)url];
    }
    else if (![url isKindOfClass:NSURL.class])
    {
        url = nil; // Prevent some common crashes due to common wrong values passed like NSNull.null for instance
    }

    if (!url || !delegate || (!(options & IIISDWebImageRetryFailed) && [failedURLs containsObject:url]))
    {
        return;
    }

    // Check the on-disk cache async so we don't block the main thread
    [cacheDelegates addObject:delegate];
    [cacheURLs addObject:url];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          delegate, @"delegate",
                          url, @"url",
                          [NSNumber numberWithInt:options], @"options",
                          userInfo ? userInfo : [NSNull null], @"userInfo",
                          nil];
    [[IIISDImageCache sharedImageCache] queryDiskCacheForKey:[self cacheKeyForURL:url] delegate:self userInfo:info];
}

#if NS_BLOCKS_AVAILABLE
- (void)downloadWithURL:(NSURL *)url delegate:(id)delegate options:(IIISDWebImageOptions)options success:(IIISDWebImageSuccessBlock)success failure:(IIISDWebImageFailureBlock)failure
{
    [self downloadWithURL:url delegate:delegate options:options userInfo:nil success:success failure:failure];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id)delegate options:(IIISDWebImageOptions)options userInfo:(NSDictionary *)userInfo success:(IIISDWebImageSuccessBlock)success failure:(IIISDWebImageFailureBlock)failure
{
    // repeated logic from above due to requirement for backwards compatability for iOS versions without blocks
    
    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, XCode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    if ([url isKindOfClass:NSString.class])
    {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    if (!url || !delegate || (!(options & IIISDWebImageRetryFailed) && [failedURLs containsObject:url]))
    {
        return;
    }
    
    // Check the on-disk cache async so we don't block the main thread
    [cacheDelegates addObject:delegate];
    [cacheURLs addObject:url];
    IIISDWebImageSuccessBlock successCopy = [success copy];
    IIISDWebImageFailureBlock failureCopy = [failure copy];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          delegate, @"delegate",
                          url, @"url",
                          [NSNumber numberWithInt:options], @"options",
                          userInfo ? userInfo : [NSNull null], @"userInfo",
                          successCopy, @"success",
                          failureCopy, @"failure",
                          nil];
    SDWIRelease(successCopy);
    SDWIRelease(failureCopy);
    [[IIISDImageCache sharedImageCache] queryDiskCacheForKey:[self cacheKeyForURL:url] delegate:self userInfo:info];
}
#endif

- (void)cancelForDelegate:(id<IIISDWebImageManagerDelegate>)delegate
{
    NSUInteger idx;
    while ((idx = [cacheDelegates indexOfObjectIdenticalTo:delegate]) != NSNotFound)
    {
        [cacheDelegates removeObjectAtIndex:idx];
        [cacheURLs removeObjectAtIndex:idx];
    }

    while ((idx = [downloadDelegates indexOfObjectIdenticalTo:delegate]) != NSNotFound)
    {
        IIISDWebImageDownloader *downloader = SDWIReturnRetained([downloaders objectAtIndex:idx]);

        [downloadInfo removeObjectAtIndex:idx];
        [downloadDelegates removeObjectAtIndex:idx];
        [downloaders removeObjectAtIndex:idx];

        if (![downloaders containsObject:downloader])
        {
            // No more delegate are waiting for this download, cancel it
            [downloader cancel];
            [downloaderForURL removeObjectForKey:downloader.url];
        }

        SDWIRelease(downloader);
    }
}

- (void)cancelAll
{
    for (IIISDWebImageDownloader *downloader in downloaders)
    {
        [downloader cancel];
    }
    [cacheDelegates removeAllObjects];
    [cacheURLs removeAllObjects];

    [downloadInfo removeAllObjects];
    [downloadDelegates removeAllObjects];
    [downloaders removeAllObjects];
    [downloaderForURL removeAllObjects];
}

#pragma mark IIISDImageCacheDelegate

- (NSUInteger)indexOfDelegate:(id<IIISDWebImageManagerDelegate>)delegate waitingForURL:(NSURL *)url
{
    // Do a linear search, simple (even if inefficient)
    NSUInteger idx;
    for (idx = 0; idx < [cacheDelegates count]; idx++)
    {
        if ([cacheDelegates objectAtIndex:idx] == delegate && [[cacheURLs objectAtIndex:idx] isEqual:url])
        {
            return idx;
        }
    }
    return NSNotFound;
}

- (void)imageCache:(IIISDImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:@"url"];
    id<IIISDWebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];

    NSUInteger idx = [self indexOfDelegate:delegate waitingForURL:url];
    if (idx == NSNotFound)
    {
        // Request has since been canceled
        return;
    }

    if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
    {
        [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
    }
    if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:)])
    {
        objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:), self, image, url);
    }
    if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:userInfo:)])
    {
        NSDictionary *userInfo = [info objectForKey:@"userInfo"];
        if ([userInfo isKindOfClass:NSNull.class])
        {
            userInfo = nil;
        }
        objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:userInfo:), self, image, url, userInfo);
    }
#if NS_BLOCKS_AVAILABLE
    if ([info objectForKey:@"success"])
    {
        IIISDWebImageSuccessBlock success = [info objectForKey:@"success"];
        success(image, YES);
    }
#endif

    [cacheDelegates removeObjectAtIndex:idx];
    [cacheURLs removeObjectAtIndex:idx];
}

- (void)imageCache:(IIISDImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:@"url"];
    id<IIISDWebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];
    IIISDWebImageOptions options = [[info objectForKey:@"options"] intValue];

    NSUInteger idx = [self indexOfDelegate:delegate waitingForURL:url];
    if (idx == NSNotFound)
    {
        // Request has since been canceled
        return;
    }

    [cacheDelegates removeObjectAtIndex:idx];
    [cacheURLs removeObjectAtIndex:idx];

    // Share the same downloader for identical URLs so we don't download the same URL several times
    IIISDWebImageDownloader *downloader = [downloaderForURL objectForKey:url];

    if (!downloader)
    {
        downloader = [IIISDWebImageDownloader downloaderWithURL:url delegate:self userInfo:info lowPriority:(options & IIISDWebImageLowPriority)];
        [downloaderForURL setObject:downloader forKey:url];
    }
    else
    {
        // Reuse shared downloader
        downloader.lowPriority = (options & IIISDWebImageLowPriority);
    }

    if ((options & IIISDWebImageProgressiveDownload) && !downloader.progressive)
    {
        // Turn progressive download support on demand
        downloader.progressive = YES;
    }

    [downloadInfo addObject:info];
    [downloadDelegates addObject:delegate];
    [downloaders addObject:downloader];
}

#pragma mark IIISDWebImageDownloaderDelegate

- (void)imageDownloader:(IIISDWebImageDownloader *)downloader didUpdatePartialImage:(UIImage *)image
{
    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        IIISDWebImageDownloader *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            id<IIISDWebImageManagerDelegate> delegate = [downloadDelegates objectAtIndex:uidx];
            SDWIRetain(delegate);
            SDWIAutorelease(delegate);

            if ([delegate respondsToSelector:@selector(webImageManager:didProgressWithPartialImage:forURL:)])
            {
                objc_msgSend(delegate, @selector(webImageManager:didProgressWithPartialImage:forURL:), self, image, downloader.url);
            }
            if ([delegate respondsToSelector:@selector(webImageManager:didProgressWithPartialImage:forURL:userInfo:)])
            {
                NSDictionary *userInfo = [[downloadInfo objectAtIndex:uidx] objectForKey:@"userInfo"];
                if ([userInfo isKindOfClass:NSNull.class])
                {
                    userInfo = nil;
                }
                objc_msgSend(delegate, @selector(webImageManager:didProgressWithPartialImage:forURL:userInfo:), self, image, downloader.url, userInfo);
            }
        }
    }
}

- (void)imageDownloader:(IIISDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image
{
    SDWIRetain(downloader);
    IIISDWebImageOptions options = [[downloader.userInfo objectForKey:@"options"] intValue];

    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        IIISDWebImageDownloader *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            id<IIISDWebImageManagerDelegate> delegate = [downloadDelegates objectAtIndex:uidx];
            SDWIRetain(delegate);
            SDWIAutorelease(delegate);

            if (image)
            {
                if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
                }
                if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:)])
                {
                    objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:), self, image, downloader.url);
                }
                if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:forURL:userInfo:)])
                {
                    NSDictionary *userInfo = [[downloadInfo objectAtIndex:uidx] objectForKey:@"userInfo"];
                    if ([userInfo isKindOfClass:NSNull.class])
                    {
                        userInfo = nil;
                    }
                    objc_msgSend(delegate, @selector(webImageManager:didFinishWithImage:forURL:userInfo:), self, image, downloader.url, userInfo);
                }
#if NS_BLOCKS_AVAILABLE
                if ([[downloadInfo objectAtIndex:uidx] objectForKey:@"success"])
                {
                    IIISDWebImageSuccessBlock success = [[downloadInfo objectAtIndex:uidx] objectForKey:@"success"];
                    success(image, NO);
                }
#endif
            }
            else
            {
                if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:nil];
                }
                if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:)])
                {
                    objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:), self, nil, downloader.url);
                }
                if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:userInfo:)])
                {
                    NSDictionary *userInfo = [[downloadInfo objectAtIndex:uidx] objectForKey:@"userInfo"];
                    if ([userInfo isKindOfClass:NSNull.class])
                    {
                        userInfo = nil;
                    }
                    objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:userInfo:), self, nil, downloader.url, userInfo);
                }
#if NS_BLOCKS_AVAILABLE
                if ([[downloadInfo objectAtIndex:uidx] objectForKey:@"failure"])
                {
                    IIISDWebImageFailureBlock failure = [[downloadInfo objectAtIndex:uidx] objectForKey:@"failure"];
                    failure(nil);
                }
#endif
            }

            [downloaders removeObjectAtIndex:uidx];
            [downloadInfo removeObjectAtIndex:uidx];
            [downloadDelegates removeObjectAtIndex:uidx];
        }
    }

    if (image)
    {
        // Store the image in the cache
        [[IIISDImageCache sharedImageCache] storeImage:image
                                          imageData:downloader.imageData
                                             forKey:[self cacheKeyForURL:downloader.url]
                                             toDisk:!(options & IIISDWebImageCacheMemoryOnly)];
    }
    else if (!(options & IIISDWebImageRetryFailed))
    {
        // The image can't be downloaded from this URL, mark the URL as failed so we won't try and fail again and again
        // (do this only if IIISDWebImageRetryFailed isn't activated)
        [failedURLs addObject:downloader.url];
    }


    // Release the downloader
    [downloaderForURL removeObjectForKey:downloader.url];
    SDWIRelease(downloader);
}

- (void)imageDownloader:(IIISDWebImageDownloader *)downloader didFailWithError:(NSError *)error;
{
    SDWIRetain(downloader);

    // Notify all the downloadDelegates with this downloader
    for (NSInteger idx = (NSInteger)[downloaders count] - 1; idx >= 0; idx--)
    {
        NSUInteger uidx = (NSUInteger)idx;
        IIISDWebImageDownloader *aDownloader = [downloaders objectAtIndex:uidx];
        if (aDownloader == downloader)
        {
            id<IIISDWebImageManagerDelegate> delegate = [downloadDelegates objectAtIndex:uidx];
            SDWIRetain(delegate);
            SDWIAutorelease(delegate);

            if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
            {
                [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:error];
            }
            if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:)])
            {
                objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:), self, error, downloader.url);
            }
            if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:forURL:userInfo:)])
            {
                NSDictionary *userInfo = [[downloadInfo objectAtIndex:uidx] objectForKey:@"userInfo"];
                if ([userInfo isKindOfClass:NSNull.class])
                {
                    userInfo = nil;
                }
                objc_msgSend(delegate, @selector(webImageManager:didFailWithError:forURL:userInfo:), self, error, downloader.url, userInfo);
            }
#if NS_BLOCKS_AVAILABLE
            if ([[downloadInfo objectAtIndex:uidx] objectForKey:@"failure"])
            {
                IIISDWebImageFailureBlock failure = [[downloadInfo objectAtIndex:uidx] objectForKey:@"failure"];
                failure(error);
            }
#endif

            [downloaders removeObjectAtIndex:uidx];
            [downloadInfo removeObjectAtIndex:uidx];
            [downloadDelegates removeObjectAtIndex:uidx];
        }
    }

    // Release the downloader
    [downloaderForURL removeObjectForKey:downloader.url];
    SDWIRelease(downloader);
}

@end
