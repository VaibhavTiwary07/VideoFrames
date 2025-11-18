//
//  FrameScrollView.m
//  Instapicframes
//
//  Created by Sunitha Gadigota on 6/8/13.
//
//

#import "FrameScrollView.h"
#import "SRSubscriptionModel.h"

@interface FrameScrollView()
{
    int _pageCount;
    NSMutableArray *_pages;
    
    //ExpiryStatus//
    NSUserDefaults *prefsTime;
    NSUserDefaults *prefsDate;
   // UIButton *btn;
}

@end

@implementation FrameScrollView
@synthesize delegate;
@synthesize selectionModel;

- (id)initWithFrame:(CGRect)frame indextag:(int)tag
{
    //For Subscription Expiry Status
    prefsTime = [NSUserDefaults standardUserDefaults];
    prefsDate= [NSUserDefaults standardUserDefaults];
//    NSLog(@"Checking ExpiryHere Frame Scrollview controller view-------");
//    [[SRSubscriptionModel shareKit]CheckingExpiryHere];
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tag = tag;
        // Changed to vertical continuous scrolling - use full frame height without page control
        UIScrollView *scrlView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrlView.pagingEnabled = NO;  // Disable paging for continuous scroll
        scrlView.contentSize = frame.size;
        scrlView.showsHorizontalScrollIndicator = NO;
        scrlView.showsVerticalScrollIndicator = YES;
        scrlView.scrollsToTop = NO;
        scrlView.delegate = self;
        scrlView.userInteractionEnabled = YES;
        scrlView.tag = FSV_TAG_SCROLLVIEW;

        // No page control needed for vertical continuous scrolling
        [self addSubview:scrlView];
//        [scrlView release];
        self.userInteractionEnabled = YES;
        NSLog(@"end Frame ScrollView init");
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
-(int)selectedItemIndex
{
    int iSelectedItemIndex = 0;
    
    if([self.delegate respondsToSelector:@selector(selectedItemIndexOfFrameScrollView:)])
    {
        iSelectedItemIndex = [self.delegate selectedItemIndexOfFrameScrollView:self];
    }
    
    return iSelectedItemIndex;
}
//updating
-(void)updatePageCount
{
    int totalItems   = [self totalItemCount];
    int cols         = [self columnCount];
    int rows         = 0;
    UIScrollView *scrollView = [self scrollView];

    // For vertical continuous scrolling, calculate total rows needed
    rows = (totalItems + cols - 1) / cols;  // Ceiling division

    // We only need ONE "page" containing all items
    _pageCount = 1;

    // No paging for continuous scroll
    scrollView.pagingEnabled = NO;

    if(nil != _pages)
    {
     //   [_pages release];
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

    // Set content size for vertical scrolling: all rows stacked vertically
    float itemHeight = FSV_ITEM_HEIGHT;
    float verticalGap = [self verticleGap];
    float totalHeight = (rows * itemHeight) + ((rows + 1) * verticalGap);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, totalHeight);
   // NSLog(@"Vertical continuous scroll - rows=%d, totalHeight=%.0f",rows, totalHeight);
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

// REFACTORED: Simple, model-driven frame selection
-(void)frameSelected:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    printf("\n[FRAME_SCROLL] ═══════════════════════════════════\n");
    printf("[FRAME_SCROLL] Frame button tapped: tag=%ld\n", (long)btn.tag);

    // Refresh all button appearances based on new selection
    // This is simpler than manual tracking - just redraw everything
    [self refreshButtonAppearances];

    // Notify delegate
    if([self.delegate respondsToSelector:@selector(frameScrollView:selectedItemIndex:button:)])
    {
        printf("[FRAME_SCROLL] → Notifying delegate\n");
        [self.delegate frameScrollView:self selectedItemIndex:(int)btn.tag button:btn];
    }

    printf("[FRAME_SCROLL] ═══════════════════════════════════\n\n");
}

// Configure a single button's appearance based on whether it's selected
- (void)configureButton:(UIButton*)button selected:(BOOL)selected
{
    if (selected) {
        // Green border for selected frame
        button.layer.borderWidth = 5.0;
        button.layer.borderColor = [[UIColor colorWithRed:188/255.0
                                                     green:234/255.0
                                                      blue:109/255.0
                                                     alpha:1.0] CGColor];
        button.layer.cornerRadius = 0;
        button.clipsToBounds = NO;
    } else {
        // No border for unselected frames
        button.layer.borderWidth = 0;
        button.layer.borderColor = nil;
    }
}

// Refresh all button appearances based on selection model
- (void)refreshButtonAppearances
{
    if (!self.selectionModel) {
        printf("[FRAME_SCROLL] ⚠️  No selection model set\n");
        return;
    }

    NSInteger selectedIndex = self.selectionModel.selectedFrameIndex;
    printf("[FRAME_SCROLL] Refreshing buttons, selected index: %ld\n", (long)selectedIndex);

    // Get the scroll view that contains all buttons
    UIScrollView *scrollView = [self scrollView];

    // Iterate through all subviews to find buttons
    for (UIView *pageView in scrollView.subviews) {
        if (![pageView isKindOfClass:[UIView class]]) continue;

        for (UIView *subview in pageView.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton*)subview;
                BOOL isSelected = (button.tag == selectedIndex);
                [self configureButton:button selected:isSelected];
            }
        }
    }
}
// Scale up on button press
- (void) buttonPress:(UIButton*)button
{
    NSLog(@"Button frame tag is %ld",button.tag);
    int selectedItemIndex = [self selectedItemIndex];

    /* first set the image of the previous frame back to original color only if it is
     in same page*/
    if([self pageNumberOfItemIndex:selectedItemIndex] == [self pageNumberOfItemIndex:(int)button.tag])
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
    
//#if 0
    if([self.delegate respondsToSelector:@selector(frameScrollView:contentLockTypeAtIndex:)])
    {
        if(FRAMES_LOCK_FREE == [self.delegate frameScrollView:self contentLockTypeAtIndex:(int)button.tag-1])
        {
            /* set the colored image for the current selected frame */
            //[button setBackgroundImage:[self.delegate frameScrollView:self coloredImageForItemAtIndex:button.tag-1]
            //                  forState:UIControlStateNormal];
            [button setBackgroundImage:[self.delegate frameScrollView:self imageForItemAtIndex:(int)button.tag-1]
                              forState:UIControlStateNormal];
        }
    }
//#endif
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

    NSLog(@"alloc Page For Page Nume");
    UIScrollView *scrlView = [self scrollView];

    int cols = [self columnCount];
    int totalItemsCount = [self totalItemCount];

    // For vertical continuous scrolling, calculate total rows needed for all items
    int totalRows = (totalItemsCount + cols - 1) / cols;  // Ceiling division

    // Create view tall enough for all items in vertical layout
    float itemHeight = FSV_ITEM_HEIGHT;
    float verticalGap = [self verticleGap];
    float totalHeight = (totalRows * itemHeight) + ((totalRows + 1) * verticalGap);

    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrlView.frame.size.width, totalHeight)];
    if(nil == v)
    {
        NSLog(@"alloc Page For Page Nume:Failed to allocate memory for view");
        return nil;
    }

    v.userInteractionEnabled = YES;

    // Start at itemIndex 0 (no page offset) for vertical continuous scrolling
    int itemIndex = 0;
    int i = 0;
    int j = 0;

    // Loop through all rows to create all items
    for(i = 0; i < totalRows; i++)
    {
        for(j = 0; j < cols; j++)
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
            
            //for premium feature
            
            float x1 = ([self horizantalGap] * (j+1)) + (j * FSV_ITEM_WIDTH);
            float y1 = ([self verticleGap] * (i+1)) + (i * FSV_ITEM_HEIGHT);
//            float width2 = FSV_ITEM_WIDTH;
//            float height2 = FSV_ITEM_HEIGHT;
            
            
            UIButton*gridbtn = [[UIButton alloc]initWithFrame:CGRectMake(x,y,width,height)];
            gridbtn.layer.shadowColor = [[UIColor blackColor] CGColor];
            gridbtn.layer.shadowOpacity = 0.5;
            gridbtn.layer.shadowRadius = 4;
            gridbtn.layer.shadowOffset = CGSizeMake(-2, 2);
            [v addSubview:gridbtn];
           //  [v sendSubviewToBack:gridbtn];
         //   [gridbtn release];

            /* set the tag for the button */
            gridbtn.tag =((self.tag - TAG_BASEFRAME_GRIDVIEW)*1000)+itemIndex;
          
#if 1
            // Use helper method for consistent button styling
            BOOL isSelected = (self.selectionModel && self.selectionModel.selectedFrameIndex == itemIndex);
            [self configureButton:gridbtn selected:isSelected];

            if(([self selectedItemIndex] > 0) && ([self selectedItemIndex] == itemIndex))
            {
                [gridbtn setBackgroundImage:[self.delegate frameScrollView:self coloredImageForItemAtIndex:(int)gridbtn.tag] forState:UIControlStateNormal];
            }
            else
            {
                [gridbtn setBackgroundImage:[self.delegate frameScrollView:self imageForItemAtIndex:(int)gridbtn.tag] forState:UIControlStateNormal];
                if(gridbtn.tag<100)
                {

                  NSString *imgName,*imgName_withTag,*imgName_WithPng;
                
                    if(gridbtn.tag < 10)
                     imgName =@"thumbles_0";
                    else
                        imgName = @"thumbles_";
                    imgName_withTag = [imgName stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)gridbtn.tag]];
                    imgName_WithPng = [imgName_withTag stringByAppendingString:@".png"];
                    [gridbtn setImage:[UIImage imageNamed:imgName_WithPng] forState:UIControlStateNormal];
                }
            }
#else
            
            [gridbtn setBackgroundImage:[self.delegate frameScrollView:self imageForItemAtIndex:gridbtn.tag] forState:UIControlStateNormal];

#endif
            UIButton*btn;
            if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
            {
                btn = [[UIButton alloc]initWithFrame:CGRectMake(x1+5,y1-15,width,height)];
            }
            else
            {
                btn = [[UIButton alloc]initWithFrame:CGRectMake(x1+5,y1-5,width,height)];
            }
            
            btn.layer.shadowColor = [[UIColor blackColor] CGColor];
            btn.layer.shadowOpacity = 0.3;
            btn.layer.shadowRadius = 1;
            btn.layer.shadowOffset = CGSizeMake(-1, 1);
            [v addSubview:btn];
         //   [btn release];
            
            /* set the tag for the button */
            btn.tag =((self.tag - TAG_BASEFRAME_GRIDVIEW)*1000)+itemIndex;
            if(([self selectedItemIndex] > 0) && ([self selectedItemIndex] == itemIndex))
            {
                [btn setBackgroundImage:[self.delegate frameScrollView:self coloredImageForItemAtIndex:(int)btn.tag] forState:UIControlStateNormal];
            }
            else
            {
                [btn setBackgroundImage:[self.delegate frameScrollView:self imageForItemAtIndex:(int)btn.tag] forState:UIControlStateNormal];
                //NSLog(@"btn tag is %ld",(long)btn.tag);
               // NSLog(@"Frames status is %@",[[SRSubscriptionModel shareKit]IsAppSubscribed]?@"NO":@"YES");
               // NSLog(@"Check here for frame lock status ===========>>>>> ");
                if(btn.tag >2 && btn.tag<100 && !(btn.tag ==9)&& !(btn.tag ==19)&& !(btn.tag ==31) && !(btn.tag ==36)&& !(btn.tag ==39) && !(btn.tag ==69)  && !(btn.tag ==73)&& !(btn.tag ==85) &&  ![[SRSubscriptionModel shareKit]IsAppSubscribed])
                {
                        if(UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom)
                        {
                            [btn setImage:[UIImage imageNamed:@"n_lock_corner_ipad.png"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [btn setImage:[UIImage imageNamed:@"n_lock_corner.png"] forState:UIControlStateNormal];
                        }
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
//  if(btn.tag >2 && btn.tag<100 && !(btn.tag ==9)&& !(btn.tag ==13)&& !(btn.tag ==19)&& !(btn.tag ==31) && !(btn.tag ==36)&& !(btn.tag ==39) && !(btn.tag ==47)&& !(btn.tag ==49)&& !(btn.tag ==54)&& !(btn.tag ==61) && !(btn.tag ==64) && !(btn.tag ==73)&& !(btn.tag ==77)&& !(btn.tag ==85) && !(btn.tag ==90) &&  ![[SRSubscriptionModel shareKit]IsAppSubscribed])
//{
-(void)loadPage:(int)pageNum
{
    UIScrollView *scrlView = [self scrollView];
    if((pageNum < 0) || (pageNum >= _pageCount))
    {
        NSLog(@" frame scroll view loadPage: invalid pagenumber %d for pagecount %d",pageNum,_pageCount);
        return;
    }
    
    // replace the placeholder if necessary
    UIView *page = [_pages objectAtIndex:pageNum];
    if ((NSNull *)page == [NSNull null])
    {
        page = [self allocPageForPageNume:pageNum];
        
        [_pages replaceObjectAtIndex:pageNum withObject:page];
       // [page release];
    }
    
    // add the controller's view to the scroll view
    if (nil == page.superview)
    {
        CGRect frame = scrlView.frame;
        frame.origin.x = 0;  // No horizontal offset for vertical scrolling
        frame.origin.y = 0;  // All content starts at top
        page.frame = frame;
        [scrlView addSubview:page];
    }
}

-(void)loadPages
{
    UIScrollView  *scrlView   = [self scrollView];

    [self updatePageCount];

    // For vertical continuous scrolling, load the single page with all items
    [self loadPage:0];

    // Scroll to top
    [scrlView setContentOffset:CGPointMake(0, 0) animated:NO];

    return;
}

-(void)animateFrames:(id)timer
{
    // For vertical continuous scrolling, no animation needed
    // All frames are already visible in the scroll view
    return;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // For vertical continuous scrolling, no page-based logic needed
    // All frames are already loaded in a single view
    return;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // No additional logic needed for vertical continuous scrolling
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//-(void)removeframelockImage
//{
//  //  [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//}
//- (void)dealloc
//{
//    [delegate release];
//    [super dealloc];
//    
//}
@end
