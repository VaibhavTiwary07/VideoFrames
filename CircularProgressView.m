//
//  CircularProgressView.m
//  VideoFrames
//
//  Created by apple on 07/07/25.
//
// CircularProgressView.m
#import "CircularProgressView.h"

@interface CircularProgressView ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) UILabel *percentageLabel;
@property (nonatomic, strong) UILabel *bottomTextLabel;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation CircularProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
        [self setupView];
        [self setupLayers];
        [self setupLabels];
    }
    return self;
}

- (void)setupDefaults {
    _progress = 0.0;
    _progressColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
    _trackColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    _lineWidth = 8.0;
    _viewBackgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    _cornerRadius = 12.0;
    _percentageFont = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    _percentageColor = [UIColor darkTextColor];
    _bottomTextFont = [UIFont systemFontOfSize:14];
    _bottomTextColor = [UIColor grayColor];
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = _viewBackgroundColor;
    _backgroundView.layer.cornerRadius = _cornerRadius;
    _backgroundView.layer.masksToBounds = YES;
    [self addSubview:_backgroundView];
}

- (void)setupLayers {
    _trackLayer = [CAShapeLayer layer];
    _trackLayer.fillColor = UIColor.clearColor.CGColor;
    _trackLayer.strokeColor = _trackColor.CGColor;
    _trackLayer.lineWidth = _lineWidth;
    _trackLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_trackLayer];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = UIColor.clearColor.CGColor;
    _progressLayer.strokeColor = _progressColor.CGColor;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeEnd = _progress;
    [self.layer addSublayer:_progressLayer];
}

- (void)setupLabels {
    _percentageLabel = [[UILabel alloc] init];
    _percentageLabel.textAlignment = NSTextAlignmentCenter;
    _percentageLabel.font = _percentageFont;
    _percentageLabel.textColor = _percentageColor;
    _percentageLabel.text = @"0%";
    _percentageLabel.adjustsFontSizeToFitWidth = YES;
    _percentageLabel.minimumScaleFactor = 0.5;
    [self addSubview:_percentageLabel];
    
    _bottomTextLabel = [[UILabel alloc] init];
    _bottomTextLabel.textAlignment = NSTextAlignmentCenter;
    _bottomTextLabel.font = _bottomTextFont;
    _bottomTextLabel.textColor = _bottomTextColor;
    _bottomTextLabel.text = @"Processing";
    [self addSubview:_bottomTextLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backgroundView.frame = self.bounds;
    _backgroundView.layer.cornerRadius = _cornerRadius;
    
    [self updatePaths];
    [self updateLabels];
}

- (void)updatePaths {
    CGFloat availableHeight = self.bounds.size.height - 40; // Space for bottom text
    CGFloat circleDiameter = MIN(self.bounds.size.width, availableHeight) * 0.8;
    CGFloat circleRadius = circleDiameter / 2;
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(self.bounds),
                                     (availableHeight - circleDiameter)/2 + circleRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleCenter
                                                       radius:circleRadius
                                                   startAngle:-M_PI_2
                                                     endAngle:3*M_PI_2
                                                    clockwise:YES];
    
    _trackLayer.path = path.CGPath;
    _progressLayer.path = path.CGPath;
}

- (void)updateLabels {
    CGFloat availableHeight = self.bounds.size.height - 40;
    CGFloat circleDiameter = MIN(self.bounds.size.width, availableHeight) * 0.8;
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(self.bounds),
                                     (availableHeight - circleDiameter)/2 + circleDiameter/2);
    
    // Center percentage label perfectly in circle
    _percentageLabel.frame = CGRectMake(0, 0, circleDiameter * 0.8, circleDiameter * 0.5);
    _percentageLabel.center = circleCenter;
    
    // Position bottom text
    CGFloat bottomTextY = circleCenter.y + circleDiameter/2 + 15;
    _bottomTextLabel.frame = CGRectMake(20, bottomTextY,
                                       self.bounds.size.width - 40, 20);
}

#pragma mark - Property Setters
- (void)setProgress:(CGFloat)progress {
    _progress = MIN(MAX(progress, 0.0), 1.0);
    _progressLayer.strokeEnd = _progress;
    _percentageLabel.text = [NSString stringWithFormat:@"%.0f%%", _progress * 100];
}

- (void)setPercentageFont:(UIFont *)percentageFont {
    _percentageFont = percentageFont;
    _percentageLabel.font = percentageFont;
}

- (void)setPercentageColor:(UIColor *)percentageColor {
    _percentageColor = percentageColor;
    _percentageLabel.textColor = percentageColor;
}

- (void)setBottomTextFont:(UIFont *)bottomTextFont {
    _bottomTextFont = bottomTextFont;
    _bottomTextLabel.font = bottomTextFont;
}

- (void)setBottomTextColor:(UIColor *)bottomTextColor {
    _bottomTextColor = bottomTextColor;
    _bottomTextLabel.textColor = bottomTextColor;
}

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor {
    _viewBackgroundColor = viewBackgroundColor;
    _backgroundView.backgroundColor = viewBackgroundColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    _backgroundView.layer.cornerRadius = cornerRadius;
}

- (void)setBottomText:(NSString *)bottomText
{
    _bottomText = bottomText;
    _bottomTextLabel.text = bottomText;
}

#pragma mark - Public Methods
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    CGFloat newProgress = MIN(MAX(progress, 0.0), 1.0);
    
    if (animated) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.8];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(_progressLayer.strokeEnd);
        animation.toValue = @(newProgress);
        [_progressLayer addAnimation:animation forKey:@"progressAnimation"];
        
        [CATransaction setCompletionBlock:^{
            self->_progress = newProgress;
            self->_progressLayer.strokeEnd = newProgress;
        }];
        
        [CATransaction commit];
        
        // Animate percentage count
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            NSInteger startValue = (NSInteger)(self.progress * 100);
            NSInteger endValue = (NSInteger)(newProgress * 100);
            
            for (NSInteger i = startValue; i <= endValue; i++) {
                self.percentageLabel.text = [NSString stringWithFormat:@"%ld%%", (long)i];
            }
        } completion:nil];
    } else {
        self.progress = newProgress;
    }
}

@end
