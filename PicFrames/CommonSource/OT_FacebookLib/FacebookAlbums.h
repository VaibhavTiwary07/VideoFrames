//
//  FacebookAlbums.h
//  FacebookIntegration
//
//  Created by Sunitha Gadigota on 5/27/13.
//  Copyright (c) 2013 Sunitha Gadigota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIIBaseData.h"
#import "IIIFlowViewDelegate.h"


@interface FacebookAlbums : UIViewController <IIIFlowViewDelegate>

-(id)initWithAlbumId:(NSString*)albumId;

@end
