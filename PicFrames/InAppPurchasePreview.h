//
//  InAppPurchasePreview.h
//  Instapicframes
//
//  Created by Sunitha Gadigota on 8/10/13.
//
//

#import <UIKit/UIKit.h>

#define key_inapppreview_package_productid  @"key_inapppreview_package_productid"
#define key_inapppreview_package_image      @"key_inapppreview_package_image"
#define key_inapppreview_package_price      @"key_inapppreview_package_price"
#define key_inapppreview_package_msgheading @"key_inapppreview_package_msgheading"
#define key_inapppreview_package_msgbody    @"key_inapppreview_package_msgbody"

@class InAppPurchasePreview;

@protocol InAppPurchasePreviewViewDelegate <NSObject>
@optional
- (void)inAppPurchasePreviewWillExit:(InAppPurchasePreview*)gView;
- (void)cacelDidSelectForInAppPurchasePreview:(InAppPurchasePreview*)gView;
- (void)restoreDidSelectForInAppPurchasePreview:(InAppPurchasePreview*)gView;
- (void)inAppPurchasePreview:(InAppPurchasePreview*)gView itemPurchasedAtIndex:(int)index;
@end

@interface InAppPurchasePreview : UIView

@property(nonatomic,assign)id <InAppPurchasePreviewViewDelegate> delegate;

/*
 Array of in-app purchase packages are passed as the input. Each package is a dictionary, will have
 all the details about the purchase. Below are the tags that are present in each package
 - product id
 - image
 - price
 - msg heading
 - msg body
 */
-(void)showInAppPurchaseWithPackages:(NSArray*)packages;

- (void)showInAppPreviewWithimage:(UIImage*)img
                            price:(NSString*)price
                          heading:(NSString*)heading
                      description:(NSString*)description;
@end
