//
//  HelpFrame.m
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 4/19/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "HelpFrame.h"
#import "Utility.h"

@interface HelpFrame()
{
    UIImage *_centerImage;
    UIImageView *_centerImageView;
    UILabel *_helpTextLable;
    UILabel *_titleTextLable;
    UIViewContentMode eContentMode;
    SWSnapshotStackView *_centerStackView;
}

@end

@implementation HelpFrame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"mainbackground_ipad" ofType:@"png"]];
        }
        else
        {
            NSString *path = [Utility documentDirectoryPathForFile:@"mainbackground.jpg"];
            self.image = [UIImage imageWithContentsOfFile:path];
        }
        
        _centerImage = nil;
        _centerImageView = nil;
        _helpTextLable = nil;
        _titleTextLable = nil;
        _centerStackView = nil;
        eContentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

-(void)dealloc
{
    
    [super dealloc];
}

-(UIImage*)centerStackImage
{
    return _centerImage;
}

-(void)setCenterStackImage:(UIImage *)centerStackImage
{
    _centerImage = centerStackImage;
    
    if(nil == _centerStackView)
    {
        CGRect centerImageRect = CGRectMake(LEFT_DELIMITER, TITLE_DELIMITER, self.frame.size.width-(2*LEFT_DELIMITER), self.frame.size.height-(TITLE_DELIMITER + HELPTEXT_HEIGHT));
        
        /* allocate center imageview */
        _centerStackView = [[SWSnapshotStackView alloc]initWithFrame:centerImageRect];
        _centerStackView.displayAsStack = NO;
        
        [self addSubview:_centerStackView];
        
        [_centerStackView release];
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([_centerImage CGImage], CGRectMake(0, 0, _centerImage.size.width, _centerImage.size.width));
    
    _centerStackView.image = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
}

-(UIImage*)centerImage
{
    return _centerImage;
}

-(void)setCenterImageContentMode:(UIViewContentMode)eM
{
    eContentMode = eM;
}

-(void)setCenterImage:(UIImage *)centerImage
{
    _centerImage = centerImage;
    
    if(nil == _centerImageView)
    {    
        CGRect centerImageRect = CGRectMake(LEFT_DELIMITER, TITLE_DELIMITER, self.frame.size.width-(2*LEFT_DELIMITER), self.frame.size.height-(TITLE_DELIMITER + HELPTEXT_HEIGHT));
        
        /* allocate center imageview */
        _centerImageView = [[UIImageView alloc]initWithFrame:centerImageRect];
        
        _centerImageView.contentMode = eContentMode;
        _centerImageView.backgroundColor = [UIColor redColor];
        _centerImageView.layer.shadowRadius = 5.0;
        _centerImageView.clipsToBounds = NO;
        _centerImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _centerImageView.layer.shadowOffset = CGSizeMake(1, 1);
        _centerImageView.layer.shadowOpacity = 1;
        _centerImageView.layer.shadowRadius = 5.0;
        
        [self addSubview:_centerImageView];
        
        [_centerImageView release];
    }

    CGImageRef imageRef = CGImageCreateWithImageInRect([centerImage CGImage], CGRectMake(0, 0, centerImage.size.width, centerImage.size.width));
    
    _centerImageView.image = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);


    //_centerImageView.image = centerImage;
    
    return;
}

-(void)setHelpText:(NSString*)text
{
    if(nil == _helpTextLable)
    {
        CGRect helpTextRect = CGRectMake(LEFT_DELIMITER, self.frame.size.height-HELPTEXT_HEIGHT, self.frame.size.width-(2*LEFT_DELIMITER), HELPTEXT_HEIGHT);
        
        _helpTextLable = [[UILabel alloc]initWithFrame:helpTextRect];
        
        [self addSubview:_helpTextLable];
        
        [_helpTextLable release];
        
        _helpTextLable.backgroundColor = [UIColor clearColor];
        _helpTextLable.textAlignment = UITextAlignmentCenter;
        _helpTextLable.textColor = [UIColor whiteColor];
        //_helpTextLable.lineBreakMode = UILineBreakModeWordWrap;
        _helpTextLable.numberOfLines = 2;
        _helpTextLable.font = [UIFont systemFontOfSize:HELPTEXT_FONTSIZE];
    }
    
    _helpTextLable.text = text;
}

-(void)setTitleText:(NSString*)text
{
    if(nil == _titleTextLable)
    {
        CGRect helpTextRect = CGRectMake(LEFT_DELIMITER, 0.0, self.frame.size.width-(2*LEFT_DELIMITER), TITLE_DELIMITER);
        
        _titleTextLable = [[UILabel alloc]initWithFrame:helpTextRect];
        
        [self addSubview:_titleTextLable];
        
        [_titleTextLable release];
        
        _titleTextLable.backgroundColor = [UIColor clearColor];
        _titleTextLable.textAlignment = UITextAlignmentCenter;
        _titleTextLable.textColor = [UIColor whiteColor];
        _titleTextLable.font = [UIFont boldSystemFontOfSize:TITLETEXT_FONTSIZE];
    }
    
    _titleTextLable.text = text;
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
