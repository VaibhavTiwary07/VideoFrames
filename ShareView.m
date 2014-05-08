//
//  ShareView.m
//  VideoFrames
//
//  Created by Outthinking Mac 1 on 14/11/13.
//
//

#import "ShareView.h"
#import "Config.h"
@implementation ShareView
@synthesize videoPath;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)allocateUI
{
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView . frame = CGRectMake(0, 0, full_screen.size.width, full_screen.size.height);
    [self addSubview:backgroundView];

    float xaxis = 43;
    float yaxis = 60;
    float width = 95;
    float height = 95;
    float xgap = 140;
    float ygap = 150;

    for (int index = 1; index<=6; index++)
        {
        NSString *shareImage = [NSString stringWithFormat:@"share_option%d.png",index];
        NSString *shareImage_active = [NSString stringWithFormat:@"share_option%d_active.png",index];
        UIButton *shareButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        shareButton . tag = index;
        shareButton . frame = CGRectMake(xaxis, yaxis, width, height);
        [shareButton setImage:[UIImage imageNamed:shareImage] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:shareImage_active] forState:UIControlStateHighlighted];
        [shareButton addTarget:self action:@selector(handleShareSlecetion:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:shareButton];
        xaxis = xaxis + xgap;
        if (xaxis>250) {
            yaxis = yaxis+ygap;
            xaxis = 50;
        }

    }

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton . frame = CGRectMake(0, 0, full_screen.size.width, 50);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:cancelButton];
}
-(void)handleShareSlecetion:(UIButton *)aBUtton
{
        //int indexNUMBER = aBUtton.tag;

}
-(void)goBack
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
