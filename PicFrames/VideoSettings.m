//
//  VideoSettings.m
//  VideoFrames
//
//  Created by Sunitha Gadigota on 9/12/13.
//
//

#import "VideoSettings.h"
#import "CustomUI.h"

@interface VideoSettings() <UITableViewDelegate,UITableViewDataSource>
{
    
}
@end

@implementation VideoSettings

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.dataSource = self;
        self.delegate   = self;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)tableView:(UITableView*)view didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    //cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    if(indexPath.row == 0)
    {
        UISlider *slider = [CustomUI allocateCustomSlider:CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height)];
        slider.maximumValue = 30.0;
        slider.minimumValue = 0.0;
        [cell.contentView addSubview:slider];
        [slider release];
        NSLog(@"Setting Slider");
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"Select Music";
        cell.textLabel.textColor = [UIColor blackColor];
        NSLog(@"setting text");
    }
    
    return cell;
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
