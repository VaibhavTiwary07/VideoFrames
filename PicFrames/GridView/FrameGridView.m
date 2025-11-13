//
//  FrameGridView.m
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 3/18/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "FrameGridView.h"

@interface FrameGridView()
{
    BOOL pageControlUsed;
    int _itemsPerPage;
    int _totalItemsCount;
    int _pageCount;
    int _rows;
    int _cols;
    NSMutableArray *_pages;
    int _curSelectedFrameTag;
}

@property(nonatomic,readwrite)int itemsPerPage;

- (void)pageChanged:(id)sender;
-(void)loadPage:(int)pageNum;
@end


@implementation FrameGridView

@synthesize filePrefix;
@synthesize delegate;
@synthesize selectedItemIndex;

-(int)pageNumberOfItemIndex:(int)index
{
    int framePage = 0;
    if(index <= _itemsPerPage)
    {
        framePage = 0;
    }
    else
    {
        framePage = (index-1)/_itemsPerPage;
    }
    
    return framePage;
}

-(void)setRowCount:(int)rows colCount:(int)cols
{
    _rows = rows;
    _cols = cols;
    self.itemsPerPage = rows * cols;
    
    int pageIndex = [self pageNumberOfItemIndex:selectedItemIndex];
    if(pageIndex > 0)
    {
        [self loadPage:pageIndex-1];
    }
    
    [self loadPage:pageIndex];
    
    if(pageIndex < (_pageCount - 1))
    {
        [self loadPage:pageIndex+1];
    }
    pgControl.currentPage = pageIndex;
    
    CGRect frame = scrlView.frame;
    frame.origin.x = frame.size.width * pageIndex;
    frame.origin.y = 0;
    [scrlView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
    
    return;
}

-(void)removeFromSuperview
{
    if(nil != _pages)
    {
      //  [_pages release];
        _pages = nil;
    }
    
    if(nil != scrlView)
    {
        [scrlView removeFromSuperview];
        scrlView = nil;
    }
    
    if(nil != pgControl)
    {
        [pgControl removeFromSuperview];
        pgControl = nil;
    }
    
    [super removeFromSuperview];
}

-(void)dealloc
{
    [self unregisterForNotifications];
    
    if(nil != filePrefix)
    {
      //  [filePrefix release];
        filePrefix = nil;
    }
    
    if(nil != _pages)
    {
     //   [_pages release];
        _pages = nil;
    }
    
    if(nil != scrlView)
    {
        [scrlView removeFromSuperview];
        scrlView = nil;
    }
    
    if(nil != pgControl)
    {
        [pgControl removeFromSuperview];
        pgControl = nil;
    }
    
  //  [super dealloc];
}

-(void)updatePageCount
{
    /* no need to proceed further if items per page is not configured */
    if((0 == _itemsPerPage)||(0 == _totalItemsCount))
    {
        return;
    }
    
    /* Now calculate thepage count */
    _pageCount = _totalItemsCount/_itemsPerPage;
    if(_totalItemsCount%_itemsPerPage)
    {
        _pageCount = _pageCount+1;
    }
    
    if(_pageCount > 1)
    {
        /* Configure the scroll view */
        scrlView.pagingEnabled = YES;
    }
    else
    {
        /* Configure the scroll view */
        scrlView.pagingEnabled = NO;
    }
    
    if(_pageCount == pgControl.numberOfPages)
    {
        return;
    }
    
    pgControl.numberOfPages = _pageCount;
    
    if(nil != _pages)
    {
       // [_pages release];
    }
    
    _pages = [[NSMutableArray alloc]initWithCapacity:_pageCount];
    if(nil == _pages)
    {
        return;
    }
    
    for (unsigned i = 0; i < _pageCount; i++) 
    {
        [_pages addObject:[NSNull null]];
    }
    
    scrlView.contentSize = CGSizeMake(scrlView.frame.size.width * _pageCount, scrlView.frame.size.height);
}

-(int)totalItemsCount
{
    return _totalItemsCount;
}

-(void)setTotalItemsCount:(int)totalItemsCount
{
    _totalItemsCount = totalItemsCount;
    
    [self updatePageCount];
    
    return;
}

-(int)itemsPerPage
{
    return _itemsPerPage;
}

-(void)setItemsPerPage:(int)itemsPerPage
{
    _itemsPerPage = itemsPerPage;
    
    [self updatePageCount];
}

- (void) receiveNotification:(NSNotification *) notification
{
    if([[notification name]isEqualToString:notification_updateFrameImages])
    {
        //[sess.frame enterSwapMode];
        //[self pageChanged:nil];
        if(nil == notification.userInfo)
        {
            NSLog(@"receiveNotification: Invalid input(notification_updateFrameImages) No tag information is passed");
            return;
        }
        
        int tag = [[notification.userInfo objectForKey:@"Group"]intValue];
        if(tag != self.tag)
        {
            return;
        }
        
        UIView *page = [_pages objectAtIndex:pgControl.currentPage];
        if (nil != page)
        {
            NSLog(@"receiveNotification: curselectedframetag %d",_curSelectedFrameTag);
            UIButton *btn = (UIButton*)[page viewWithTag:_curSelectedFrameTag];
            if(nil != btn)
            {
                if(NO == [btn isKindOfClass:[UIButton class]])
                {
                    NSLog(@"receiveNotification: Not a button");
                    return;
                }
                [btn setBackgroundImage:[self imageForItem:(int)btn.tag] forState:UIControlStateNormal];
                //[btn setImage:nil forState:UIControlStateNormal];
                //check here
            }
        }
    }
    
    return;
}

-(void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:nil
                                                  object:nil];
}

-(void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
}

- (id)initWithFrame:(CGRect)frame indextag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.tag = tag;
        scrlView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - FGV_PAGECONTROL_HEIGHT)];
        scrlView.pagingEnabled = YES;
        scrlView.contentSize = frame.size;
        scrlView.showsHorizontalScrollIndicator = NO;
        scrlView.showsVerticalScrollIndicator = NO;
        scrlView.scrollsToTop = NO;
        scrlView.delegate = self;
        //scrlView.backgroundColor = [UIColor redColor];
        scrlView.userInteractionEnabled = YES;
        
        pgControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,frame.size.height - FGV_PAGECONTROL_HEIGHT,FGV_PAGECONTROL_HEIGHT,FGV_PAGECONTROL_HEIGHT)];
        pgControl.numberOfPages = 3;
        pgControl.currentPage   = 0;
        pgControl.center        = CGPointMake(scrlView.center.x,pgControl.center.y);
        [pgControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        pgControl.userInteractionEnabled = YES;
        [self addSubview:scrlView];
        [self addSubview:pgControl];
      //  [scrlView release];
      //  [pgControl release];
        self.userInteractionEnabled = YES;
        
        [self registerForNotifications];
    }
    
    return self;
}

-(float)horizantalGap
{
    float hSpaceForItems = FGV_ITEM_WIDTH * _cols;
    float gap = (scrlView.frame.size.width-hSpaceForItems)/(_cols+1);
    
    return gap;
}

-(float)verticleGap
{
    float vSpaceForItems = FGV_ITEM_HEIGHT * _rows;
    float gap = (scrlView.frame.size.height-vSpaceForItems)/(_rows+1);
    //NSLog(@"verticleGap: %f",gap);
    return gap;
}

-(UIImage*)imageForItem:(int)itemIndex
{
    NSString *pPath = [Utility frameThumbNailPathForFrameNumber:itemIndex];

    //NSString *pFileName = nil;
    //pFileName = [NSString stringWithFormat:@"%@_%d",filePrefix,itemIndex];

    
    return [UIImage imageWithContentsOfFile:pPath];
}

-(UIImage*)coloredImageForItem:(int)itemIndex
{
    NSString *pPath = [Utility  coloredFrameThumbNailPathForFrameNumber:itemIndex];
    
    return [UIImage imageWithContentsOfFile:pPath];
}

-(void)frameSelected:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    _curSelectedFrameTag = (int)btn.tag;
    
    NSLog(@"frameselected: %d",_curSelectedFrameTag);
    if([self.delegate respondsToSelector:@selector(gridView:selectedFrameButton:)])
    {
        [self.delegate gridView:self selectedFrameButton:btn];
    }
    else
    {
        [delegate frameSelectedAtIndex:(int)btn.tag ofGridView:self];
    }
    
    return;
}

// Scale up on button press
- (void) buttonPress:(UIButton*)button 
{
    /* first set the image of the previous frame back to original color only if it is 
       in same page*/
    if([self pageNumberOfItemIndex:selectedItemIndex] == [self pageNumberOfItemIndex:(int)button.tag])
    {
        UIButton *bt = (UIButton*)[button.superview viewWithTag:selectedItemIndex];
        if(nil != bt)
        {
            if([bt isKindOfClass:[UIButton class]])
            {
                //[bt setImage:[self imageForItem:selectedItemIndex] forState:UIControlStateNormal];
                [bt setBackgroundImage:[self imageForItem:selectedItemIndex] forState:UIControlStateNormal];
            }
        }
    }
    
    if([self.delegate respondsToSelector:@selector(gridView:contentLockedAtIndex:)])
    {
        if(NO == [self.delegate gridView:self contentLockedAtIndex:(int)button.tag])
        {
            /* set the colored image for the current selected frame */
            //[button setImage:[self coloredImageForItem:button.tag] forState:UIControlStateNormal];
            [button setBackgroundImage:[self coloredImageForItem:(int)button.tag] forState:UIControlStateNormal];
        }
    }
    
//    /* Now animate the button press */
//    [UIView beginAnimations:@"ScaleButton" context:NULL];
//    [UIView setAnimationDuration: 0.5f];
//    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
//    [UIView commitAnimations];
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         // Optional: Handle completion if needed
                     }];

}

// Scale down on button release
- (void) buttonRelease:(UIButton*)button 
{
//    [UIView beginAnimations:@"ScaleButton" context:NULL];
//    [UIView setAnimationDuration: 0.5f];
//    button.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    [UIView commitAnimations];
    // Do something else
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        button.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }
                     completion:^(BOOL finished) {
                         // Optional: Handle completion if needed
                     }];

}

-(UIView*)allocPageForPageNume:(int)pageNum
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrlView.frame.size.width, scrlView.frame.size.height)];
    if(nil == v)
    {
        NSLog(@"alloc Page For Page Nume:Failed to allocate memory for view");
        return nil;
    }
    
    //UIColor *clr = [UIColor greenColor];
    v.userInteractionEnabled = YES;
    
    int itemIndex = 0;
    itemIndex = pageNum * _itemsPerPage;
    int i = 0;
    int j = 0;
    for(i = 0; i < _rows;i++)
    {
        for(j = 0; j < _cols;j++)
        {
            itemIndex++;
            if(itemIndex > _totalItemsCount)
            {
                continue;
            }
            float x = ([self horizantalGap] * (j+1)) + (j * FGV_ITEM_WIDTH);
            //float y = ([self verticleGap] * (i+1)) + (i * FGV_ITEM_HEIGHT);
            float y = ([self verticleGap] * (i)) + (i * FGV_ITEM_HEIGHT);
            float width = FGV_ITEM_WIDTH;
            float height = FGV_ITEM_HEIGHT;
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x,y,width,height)];
            [v addSubview:btn];
        //    [btn release];
            
            /* set the tag for the button */
            btn.tag = ((self.tag - TAG_BASEFRAME_GRIDVIEW)*1000)+itemIndex;
            
            /* set the image */
            if(nil == filePrefix)
            {
                NSLog(@"File Prefix is not yet set");
                continue;
            }

#if defined(VideoCollagePRO)
            if(([self selectedItemIndex] > 0) && ([self selectedItemIndex] == itemIndex))
            {
                [btn setBackgroundImage:[self.delegate frameScrollView:self coloredImageForItemAtIndex:btn.tag] forState:UIControlStateNormal];
            }
            else
            {
                [btn setBackgroundImage:[self.delegate frameScrollView:self imageForItemAtIndex:btn.tag] forState:UIControlStateNormal];
//                if (proVersion == 0)
//                {
//                    if (itemIndex == 52)
//                    {
//
//                        [btn setBackgroundImage:[UIImage imageNamed:@"pro 1.png"] forState:UIControlStateNormal];
//                    }
//                }
                
            }
#else
            [btn setBackgroundImage:[self imageForItem:(int)btn.tag] forState:UIControlStateNormal];
#endif
           
            if([self.delegate respondsToSelector:@selector(gridView:contentLockedAtIndex:)])
            {
                if([self.delegate gridView:self contentLockedAtIndex:(int)btn.tag])
                {
                    if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                    {
                        [btn setImage:[UIImage imageNamed:@"lock_corner_ipad.png"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"lock_corner.png"] forState:UIControlStateNormal];     
                    }
                }
            }
            else{
                NSLog(@"Delegate(%d) doesnot respond to content Locked At Index",(int)self.tag);
            }
            
            [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
            /* set the action */
            [btn addTarget:self action:@selector(frameSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return v;
}

-(void)loadPage:(int)pageNum
{
    if((pageNum < 0) || (pageNum >= _pageCount))
    {
        NSLog(@" frame grid view loadPage: invalid pagenumber %d for pagecount %d",pageNum,_pageCount);
        return;
    }
    
    // replace the placeholder if necessary
    UIView *page = [_pages objectAtIndex:pageNum];
    if ((NSNull *)page == [NSNull null]) 
    {
        page = [self allocPageForPageNume:pageNum];
        [_pages replaceObjectAtIndex:pageNum withObject:page];
     //   [page release];
    }
    
    // add the controller's view to the scroll view
    if (nil == page.superview) 
    {
        CGRect frame = scrlView.frame;
        frame.origin.x = frame.size.width * pageNum;
        frame.origin.y = 0;
        page.frame = frame;
        [scrlView addSubview:page];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) 
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    //NSLog(@"scrollViewDidScroll");
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrlView.frame.size.width;
    int page = floor((scrlView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pgControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadPage:page - 1];
    [self loadPage:page];
    [self loadPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    pageControlUsed = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches Began");
}

- (void)pageChanged:(id)sender 
{
    int page = (int)pgControl.currentPage;
    NSLog(@"page changed %d",page);
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadPage:page - 1];
    [self loadPage:page];
    [self loadPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = scrlView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrlView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
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
