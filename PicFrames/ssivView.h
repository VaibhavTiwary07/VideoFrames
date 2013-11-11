//
//  ssivView.h
//  Instapicframes
//
//  Created by Vijaya kumar reddy Doddavala on 11/25/12.
//
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"
#import "ssivPub.h"
#import "TouchView.h"
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerDemoPlaybackView.h"

@class  AVPlayer;

@interface ssivView : UIImageView

@property(nonatomic,assign)UIScrollView *scrollView;
@property(nonatomic,assign)TouchDetectView  *imageView;
@property(nonatomic,readwrite)eShape curShape;
@property (nonatomic, retain) AVPlayer* player;

+(UIImage*)imageForShape:(eShape)shp;
-(void)setShape:(eShape)shape;
-(void)previewShape:(eShape)shape;
- (void)setPlayer:(AVPlayer*)player;
-(void)removePlayer;
-(UIImage*)getCurrentAssignedShapeImage;
@end
