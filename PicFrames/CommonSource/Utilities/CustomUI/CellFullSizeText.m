//
//  CellFullSizeText.m
//  InstaSplash
//
//  Created by Vijaya kumar reddy Doddavala on 9/29/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "CellFullSizeText.h"

@implementation CellFullSizeText

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, self.textLabel.frame.origin.y, self.frame.size.width, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(0, self.detailTextLabel.frame.origin.y, self.frame.size.width, self.detailTextLabel.frame.size.height);
    //self.textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.textLabel.frame.size.height);
    //self.detailTextLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.detailTextLabel.frame.size.height);
    //self.textLabel.backgroundColor = [UIColor greenColor];
    //self.textLabel.center = self.center;
    //NSLog(@"Label %f,%f, %f,%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.textLabel.frame.size.height);
}

@end
