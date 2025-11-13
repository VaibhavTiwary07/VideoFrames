//
//  CircularProgressView.h
//  VideoFrames
//
//  Created by apple on 07/07/25.
//

// CircularProgressView.h
#import <UIKit/UIKit.h>

@interface CircularProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) NSString *bottomText;
@property (nonatomic, strong) UIColor *viewBackgroundColor;
@property (nonatomic, assign) CGFloat cornerRadius;

// Label customization
@property (nonatomic, strong) UIFont *percentageFont;
@property (nonatomic, strong) UIColor *percentageColor;
@property (nonatomic, strong) UIFont *bottomTextFont;
@property (nonatomic, strong) UIColor *bottomTextColor;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
