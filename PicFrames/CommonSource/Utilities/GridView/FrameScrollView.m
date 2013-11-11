//
//  FrameScrollView.m
//  Instapicframes
//
//  Created by Sunitha Gadigota on 6/8/13.
//
//

#import "FrameScrollView.h"

@interface FrameScrollView()
{
    int _pageCount;
    NSMutableArray *_pages;
    BOOL pageControlUsed;
}

@end

@implementation FrameScrollView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame indextag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tag = tag;
        UIScrollView *scrlView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - FSV_PAGECONTROL_HEIGHT)];
        scrlView.pagingEnabled = YES;
        scrlView.contentSize = frame.size;
        scrlView.showsHorizontalScrollIndicator = NO;
        scrlView.showsVerticalScrollIndicator = NO;
        scrlView.scrollsToTop = NO;
        scrlView.delegate = self;
        scrlView.userInteractionEnabled = YES;
        scrlView.tag = FSV_TAG_SCROLLVIEW;
        
        UIPageControl *pgControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,frame.size.height - FSV_PAGECONTROL_HEIGHT,FSV_PAGECONTROL_HEIGHT,FSV_PAGECONTROL_HEIGHT)];
        pgControl.numberOfPages = 3;
        pgControl.currentPage   = 0;
        pgControl.center        = CGPointMake(scrlView.center.x,pgControl.center.y);
        [pgControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        pgControl.userInteractionEnabled = YES;
        pgControl.tag = FSV_TAG_PAGECONTROLVIEW;
        [self addSubview:scrlView];
        [self addSubview:pgControl];
        [scrlView release];
        [pgControl release];
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

-(int)rowCount
{
    int rCount = 0;
    
    if([self.delegate respondsToSelector:@selector(rowCountOfFrameScrollView:)])
    {
        rCount = [self.delegate rowCountOfFrameScrollView:self];
    }
    
    return rCount;
}

-(int)columnCount
{
    int cCount = 0;
    
    if([self.delegate respondsToSelector:@selector(colCountOfFrameScrollView:)])
    {
        cCount = [self.delegate colCountOfFrameScrollView:self];
    }
    
    return cCount;
}

-(int)totalItemCount
{
    int iCount = 0;
    
    if([self.delegate respondsToSelector:@selector(totalItemCountOfFrameScrollView:)])
    {
        iCount = [self.delegate totalItemCountOfFrameScrollView:self];
    }
    
    return iCount;
}

-(int)itemsPerPage
{
    return ([self rowCount] * [self columnCount]);
}

-(UIScrollView*)scrollView
{
    UIScrollView *sView = (UIScrollView*)[self viewWithTag:FSV_TAG_SCROLLVIEW];
    
    return sView;
}

-(UIPageControl*)pageControlView
{
    UIPageControl *pView = (UIPageControl*)[self viewWithTag:FSV_TAG_PAGECONTROLVIEW];
    
    return pView;
}

-(int)selectedItemIndex
{
    int iSelectedItemIndex = 0;
    
    if([self.delegate respondsToSelector:@selector(selectedItemIndexOfFrameScrollView:)])
    {
        iSelectedItemIndex = [self.delegate selectedItemIndexOfFrameScrollView:self];
    }

    return iSelectedItemIndex;
}

-(void)updatePageCount
{
    int totalItems   = [self totalItemCount];
    int itemsPerPage = [self itemsPerPage];
    UIScrollView *scrollView = [self scrollView];
    UIPageControl *pageControl = [self pageControlView];
    _pageCount       = 0;
    
    /* get page count */
    _pageCount = totalItems/itemsPerPage;
    
    if(totalItems%itemsPerPage)
    {
        _pageCount = _pageCount + 1;
    }
    
    if(_pageCount > 1)
    {
        /* Configure the scroll view */
        scrollView.pagingEnabled = YES;
    }
    else
    {
        /* Configure the scroll view */
        scrollView.pagingEnabled = NO;
    }
    
    if(_pageCount == pageControl.numberOfPages)
    {
        return;
    }
    
    pageControl.numberOfPages = _pageCount;
    
    if(nil != _pages)
    {
        [_pages release];
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
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * _pageCount, scrollView.frame.size.height);
}

-(int)pageNumberOfItemIndex:(int)index
{
    int framePage    = 0;
    int itemsPerPage = [self itemsPerPage];
    
    if(index <= itemsPerPage)
    {
        framePage = 0;
    }
    else
    {
        framePage = (index-1)/itemsPerPage;
    }
    
    return framePage;
}

-(void)frameSelected:(id)sender
{
    UIButton *btn = (UIButton*)sender;

    if([self.delegate respondsToSelector:@selector(frameScrollView:selectedItemIndex:button:)])
    {
        [self.delegate frameScrollView:self selectedItemIndex:btn.tag button:btn];
    }
    
    return;
}

// Scale up on button press
- (void) buttonPress:(UIButton*)button
{
    
    int selectedItemIndex = [self selectedItemIndex];

    /* first set the image of the previous frame back to original color only if it is
     in same page*/
    if([self pageNumberOfItemIndex:selectedItemIndex] == [self pageNumberOfItemIndex:button.tag])
    {
        UIButton *bt = (UIButton*)[button.superview viewWithTag:selectedItemIndex];
        if(nil != bt)
        {
            if([bt isKindOfClass:[UIButton class]])
            {
                [bt setBackgroundImage:[self.delegate frameScrollView:self imageForItemAtIndex:selectedItemIndex]
                              forState:UIControlStateNormal];
            }
        }
    }
    
#if 0    
    if([self.delegate respondsToSelector:@selector(frameScrollView:contentLockTypeAtIndex:)])
    {
        if(FRAMES_LOCK_FREE == [self.delegate frameScrollView:self contentLockTypeAtIndex:button.tag-1])
        {
            /* set the colored image for the current selected frame */
            //[button setBackgroundImage:[self.delegate frameScrollView:self coloredImageForItemAtIndex:button.tag-1]
            //                  forState:UIControlStateNormal];
            [button setBackgroundImage:[self.delegate frameScrollView:self imageForItemAtIndex:button.tag-1]
                              forState:UIControlStateNormal];
        }
    }
#endif
    /* Now animate the button press */
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.5f];
    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView commitAnimations];
}

// Scale down on button release
- (void) buttonRelease:(UIButton*)button
{
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.5f];
    button.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView commitAnimations];
    // Do something else
}

-(float)horizantalGap
{
    int cols = [self columnCount];
    UIScrollView *scrlView = [self scrollView];
    float hSpaceForItems = FSV_ITEM_WIDTH * cols;
    float gap = (scrlView.frame.size.width-hSpaceForItems)/(cols+1);
    
    return gap;
}

-(float)verticleGap
{
    UIScrollView *scrlView       = [self scrollView];
    int           rows           = [self rowCount];
    float         vSpaceForItems = FSV_ITEM_HEIGHT * rows;
    float         gap            = (scrlView.frame.size.height-vSpaceForItems)/(rows+1);
    
    return gap;
}


-(UIView*)allocPageForPageNume:(int)pageNum
{
    UIScrollView *scrlView = [self scrollView];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrlView.frame.size.width, scrlView.frame.size.height)];
    if(nil == v)
    {
        NSLog(@"allocPageForPageNume:Failed to allocate memory for view");
        return nil;
    }
    
    v.userInteractionEnabled = YES;
    
    int itemIndex = pageNum * [self itemsPerPage];
    int i = 0;
    int j = 0;
    int rows = [self rowCount];
    int cols = [self columnCount];
    int totalItemsCount = [self totalItemCount];
    
    for(i = 0; i < rows;i++)
    {
        for(j = 0; j < cols;j++)
        {
            itemIndex++;
            if(itemIndex > totalItemsCount)
            {
                continue;
            }
            float x = ([self horizantalGap] * (j+1)) + (j * FSV_ITEM_WIDTH);
            float y = ([self verticleGap] * (i+1)) + (i * FSV_ITEM_HEIGHT);
            float width = FSV_ITEM_WIDTH;
            float height = FSV_ITEM_HEIGHT;
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x,y,width,height)];
            [v addSubview:btn];
            [btn release];
            
            /* set the tag for the button */
            btn.tag = ((self.tag - TAG_BASEFRAME_GRIDVIEW)*1000)+itemIndex;

//#if defined(APP_INSTAPICFRAMES)
#if 1
            if(([self selectedItemIndex] > 0) && ([self selectedItemIndex] == itemIndex))
            {
                [btn setBackgroundImage:[self.delegate frameScrollView:self coloredImageForItemAtIndex:btn.tag] forState:UIControlStateNormal];
            }
            else
            {
                [btn setBackgroundImage:[self.delegate frameScrollView:self imageForItemAtIndex:btn.tag] forState:UIControlStateNormal];
                if (proVersion == 0)
                {
                    if (itemIndex == 52)
                    {
        
                       [btn setBackgroundImage:[UIImage imageNamed:@"pro 1.png"] forState:UIControlStateNormal];
                    }
                }

            }
#else
            [btn setBackgroundImage:[self.delegate frameScrollView:self imageForItemAtIndex:btn.tag] forState:UIControlStateNormal];
#endif
            if([self.delegate respondsToSelector:@selector(frameScrollView:contentLockTypeAtIndex:)])
            {
                if(nil != [btn backgroundImageForState:UIControlStateNormal])
                {
                    if(FRAMES_LOCK_INAPP == [self.delegate frameScrollView:self contentLockTypeAtIndex:btn.tag])
                    {
                        if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
                        {
                            [btn setImage:[UIImage imageNamed:@"lock_corner_ipad.png"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [btn setImage:[UIImage imageNamed:@"lock_corner.png"] forState:UIControlStateNormal];
                        }
                    }
                    else if(FRAMES_LOCK_FACEBOOK == [self.delegate frameScrollView:self contentLockTypeAtIndex:btn.tag])
                    {
                        if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
                        {
                            [btn setImage:[UIImage imageNamed:@"f_lock_corner_ipad.png"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [btn setImage:[UIImage imageNamed:@"f_lock_corner.png"] forState:UIControlStateNormal];
                        }
                    }
                    else if(FRAMES_LOCK_INSTAGRAM == [self.delegate frameScrollView:self contentLockTypeAtIndex:btn.tag])
                    {
                        if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
                        {
                            [btn setImage:[UIImage imageNamed:@"i_lock_corner_new_ipad.png"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [btn setImage:[UIImage imageNamed:@"i_lock_corner_new.png"] forState:UIControlStateNormal];
                        }
                    } else if(FRAMES_LOCK_TWITTER == [self.delegate frameScrollView:self contentLockTypeAtIndex:btn.tag])
                    {
                        if(UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
                        {
                            [btn setImage:[UIImage imageNamed:@"t_lock_corner_new_ipad.png"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [btn setImage:[UIImage imageNamed:@"t_lock_corner_new.png"] forState:UIControlStateNormal];
                        }
                    }
                }
                else{
                    NSLog(@"Button %d background image is nil ",itemIndex);
                }
            }
            else
            {
                NSLog(@"Delegate(%d) doesnot respond to contentLockedAtIndex",self.tag);
            }
            if (proVersion == 0)
            {
                if (itemIndex == 52)
                {

                    [btn setBackgroundImage:[UIImage imageNamed:@"pro 1.png"] forState:UIControlStateNormal];
                }
            }
            [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
            [btn addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchCancel];
            /* set the action */
            [btn addTarget:self action:@selector(frameSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return v;
}

-(void)loadPage:(int)pageNum
{
    UIScrollView *scrlView = [self scrollView];
    if((pageNum < 0) || (pageNum >= _pageCount))
    {
        //NSLog(@"loadPage: invalid pagenumber %d for pagecount %d",pageNum,_pageCount);
        return;
    }
    
    // replace the placeholder if necessary
    UIView *page = [_pages objectAtIndex:pageNum];
    if ((NSNull *)page == [NSNull null])
    {
        page = [self allocPageForPageNume:pageNum];
        [_pages replaceObjectAtIndex:pageNum withObject:page];
        [page release];
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

-(void)loadPages
{
    UIPageControl *pgControl  = [self pageControlView];
    UIScrollView  *scrlView   = [self scrollView];
    int index                 = 0;
    int pageIndex             = _pageCount-1;
    
    [self updatePageCount];
    
    for(index = 0; index < _pageCount; index++)
    {
        [self loadPage:index];
    }
    
    pgControl.currentPage = pageIndex;
    CGRect frame   = scrlView.frame;
    frame.origin.x = frame.size.width * pageIndex;
    frame.origin.y = 0;
    [scrlView scrollRectToVisible:frame animated:YES];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateFrames:) userInfo:nil repeats:NO];
    
    return;
}

-(void)animateFrames:(id)timer
{
    CGPoint offset;
    UIScrollView  *scrlView   = [self scrollView];
    int selectedItemIndex     = [self selectedItemIndex];
    int pageIndex             = [self pageNumberOfItemIndex:selectedItemIndex];

    /* Move the last page */
    offset.x = scrlView.frame.size.width * (_pageCount-1);
    offset.y = 0;
    [scrlView setContentOffset:offset animated:NO];
    
    /* animate the page where selected item resides */
    offset.x = scrlView.frame.size.width * pageIndex;
    offset.y = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [scrlView setContentOffset:offset];
    [UIView commitAnimations];
    
    return;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    UIPageControl *pgControl = [self pageControlView];
    UIScrollView *scrlView   = [self scrollView];
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrlView.frame.size.width;
    int page = floor((scrlView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pgControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadPage:page - 1];
    [self loadPage:page];
    [self loadPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
    return;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void)pageChanged:(id)sender
{
    UIPageControl *pgControl = [self pageControlView];
    UIScrollView *scrlView   = [self scrollView];
    int page = pgControl.currentPage;

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
