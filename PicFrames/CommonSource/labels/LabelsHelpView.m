//
//  LabelsHelpView.m
//  Instacolor Splash
//
//  Created by Vijaya kumar reddy Doddavala on 8/27/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "LabelsHelpView.h"

@interface LabelsHelpView()
{
    UILabel *header;
    UILabel *addLable;
    UILabel *deleteLable;
    UIImageView *addLabelImage;
    UIImageView *deleteLabelImage;
}
@end

@implementation LabelsHelpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        float imgSize = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?200.0f:90.f;
        CGSize sze = CGSizeMake(imgSize, imgSize);
        float nextY = 0.0;
        float labelHeight = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?140.0f:70.f;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.8;
        [self addSubview:bgView];
        [bgView release];
        
        // Initialization code
        UIFont *ft = [UIFont boldSystemFontOfSize:15.0];
        
        addLable = [[UILabel alloc]initWithFrame:CGRectMake(0, nextY, frame.size.width, labelHeight)];
        addLable.backgroundColor = [UIColor clearColor];
        addLable.font = ft;
        addLable.numberOfLines = 2;
        addLable.text = @"Adding Labels: Swipe with you finger to add label";
        addLable.textColor = [UIColor whiteColor];
        [self addSubview:addLable];
        [addLable release];
        
        nextY = addLable.frame.origin.y+addLable.frame.size.height;
        addLabelImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, nextY, sze.width, sze.height)];
        addLabelImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"addLabel" ofType:@"png"]];
        addLabelImage.center = CGPointMake(frame.size.width/2.0, (nextY+(addLabelImage.frame.size.height/2.0)));
        [self addSubview:addLabelImage];
        [addLabelImage release];
        
        nextY = addLabelImage.frame.origin.y+addLabelImage.frame.size.height;
        deleteLable = [[UILabel alloc]initWithFrame:CGRectMake(0, nextY, frame.size.width,labelHeight)];
        deleteLable.backgroundColor = [UIColor clearColor];
        deleteLable.font = ft;
        deleteLable.numberOfLines = 2;
        deleteLable.text = @"Deleting Labels: Touch and hold on the label to delete it";
        deleteLable.textColor = [UIColor whiteColor];
        [self addSubview:deleteLable];
        [deleteLable release];
        
        nextY = deleteLable.frame.origin.y + deleteLable.frame.size.height;
        deleteLabelImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, nextY, sze.width, sze.height)];
        deleteLabelImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"deleteLabel" ofType:@"png"]];
        deleteLabelImage.center = CGPointMake(frame.size.width/2.0, (nextY+(deleteLabelImage.frame.size.height/2.0)));
        [self addSubview:deleteLabelImage];
        [deleteLabelImage release];
        
        nextY = deleteLabelImage.frame.origin.y+deleteLabelImage.frame.size.height;
        header = [[UILabel alloc]initWithFrame:CGRectMake(0, nextY, frame.size.width,labelHeight)];
        header.backgroundColor = [UIColor clearColor];
        header.font = ft;
        header.numberOfLines = 2;
        header.textAlignment = UITextAlignmentCenter;
        header.text = @"<Tap To Exit Help>";
        header.textColor = [UIColor whiteColor];
        [self addSubview:header];
        [header release];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
