//
//  PopupMenu.m
//  ViewMasking
//
//  Created by Vijaya kumar reddy Doddavala on 11/4/12.
//  Copyright (c) 2012 Vijaya kumar reddy Doddavala. All rights reserved.
//

#import "PopupMenu.h"
#import "Config.h"
@interface PopupMenu()
{
    PopoverView *_popover;
    SNPopupView *_snpopover;
}
@end

@implementation PopupMenu
//@synthesize _touchButton;
@synthesize menudelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id)del
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:(9.0/255.0) green:(22.0/255.0) blue:(48.0/255.0) alpha:1.0];
        self.layer.cornerRadius = 10.0;
        
        self.delegate   = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        //self._touchButton = nil;
        self.menudelegate = del;
        self.layer.masksToBounds = YES;
        _popover = nil;
    }
    return self;
}

-(void)releaseResources
{
    //if(nil != self._touchButton)
    //{
    //    [self._touchButton removeFromSuperview];
    //}
    //self._touchButton = nil;
    self.menudelegate = nil;
    _popover = nil;
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"popoverView: didSelectItemAtIndex %d",(int)index);
    
    //- (void)PopupMenuDidDismiss:(PopupMenu*)popupmenu;
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    [self.menudelegate popupMenuDidDismiss:self];
    //[self.menudelegate PopupMenuDidDismiss:self];
    //NSLog(@"popoverViewDidDismiss");
    [self releaseResources];
  //  [self release];
}

-(void)dealloc
{
    //NSLog(@"Deallocating PopupMenu");
    //[menudelegate release];
  // [super dealloc];
}

-(void)showPopupIn:(UIView*)v at:(CGPoint)point
{
    _popover = [[PopoverView alloc]init];
    
    //[_popover showAtPoint:point inView:v withContentView:self delegate:self];
    
    _popover.delegate = self;
    [_popover showAtPoint:point inView:v withContentView:self];
    //[_popover release];
    
    return;
}

-(void)showSNPopupIn:(UIView*)v at:(CGPoint)point
{
    if(nil != _snpopover)
    {
        [_snpopover dismiss];
        _snpopover = nil;
    }
    
    _snpopover = [[SNPopupView alloc]initWithContentView:self contentSize:self.frame.size];
    _snpopover.userInteractionEnabled = YES;
    [_snpopover showAtPoint:point inView:v];
//    [_snpopover release];
}

-(void)dismissSNPopup
{
    if(nil == _snpopover)
    {
        return;
    }
    
    [_snpopover dismiss];
    _snpopover = nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil == self.menudelegate)
    {
        return 0;
    }
    
    int count = [self.menudelegate numberOfItemsInPopupMenu:self];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, POPUPMENU_CELL_WIDTH, count * POPUPMENU_CELL_HEIGHT);
    return count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return POPUPMENU_CELL_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(nil == self.menudelegate)
    {
        return nil;
    }
    
    static NSString *CellIdentifier = @"PopupMenuIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];// autorelease];
    }
    
    /* Configure the cell */
    cell. backgroundColor =[UIColor colorWithRed:(28/255.0f) green:(31.0f/255.0f) blue:(38.0f/255.0f) alpha:PHOTO_DEFAULT_COLOR_A];
//    cell. backgroundColor =[UIColor colorWithRed:(102/255.0f) green:(154.0f/255.0f) blue:(174.0f/255.0f) alpha:PHOTO_DEFAULT_COLOR_A];
    cell.textLabel.text = [self.menudelegate popupMenu:self titleForItemAtIndex:(int)indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = POPUPMENU_FONT;

    
    UIImageView *i = (UIImageView*)[cell.contentView viewWithTag:658];
    if(nil != i)
    {
        [i removeFromSuperview];
    }
    
    //cell.textLabel.font=[UIFont systemFontOfSize:15];
    if([self.menudelegate respondsToSelector:@selector(popupMenu: isNewBadgeRequiredForItemAtIndex:)])
    {
        if([self.menudelegate popupMenu:self isNewBadgeRequiredForItemAtIndex:(int)indexPath.row])
        {
            UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_badge.png"]];
            iv.tag = 658;
            iv.frame = CGRectMake(150.0, 0, 25.0, 25.0);
            [cell.contentView addSubview:iv];
           // [iv release];
        }
    }
    
    cell.imageView.image = [self.menudelegate popupMenu:self imageForItemAtIndex:(int)indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    //cell.selectedBackgroundView =
    
    if(![self.menudelegate popupMenu:self enableStatusForItemAtIndex:(int)indexPath.row])
    {
        cell.userInteractionEnabled = NO;
        cell.contentView.alpha = 0.35;
    }
    else{
        cell.userInteractionEnabled = YES;
        cell.contentView.alpha = 1.0;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didDeselectRowAtIndexPath");
#if 1
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // @autoreleasepool {
        
    [self.menudelegate popupMenu:self itemDidSelectAtIndex:(int)indexPath.row];
   // }
   
//    [self.menudelegate PopupMenuDidSelectOptionAtIndex:indexPath.row];
    
    if(nil != _popover)
    {
        [_popover dismiss];
    }
#endif
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

