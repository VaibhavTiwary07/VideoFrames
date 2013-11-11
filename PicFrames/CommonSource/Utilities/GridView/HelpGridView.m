//
//  HelpGridView.m
//  PicFrames
//
//  Created by Vijaya kumar reddy Doddavala on 4/24/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "HelpGridView.h"


@interface TouchView : UIView {
	HelpGridView *delegate;
}
@property (nonatomic, assign) HelpGridView *delegate;
@property (nonatomic, readwrite)CGRect excludeRect;
@end

@implementation TouchView

@synthesize delegate;
@synthesize excludeRect;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        self.alpha = 0.8;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	DNSLogMethod
    UITouch *t = [touches anyObject];
    if(t == nil)
    {
        return;
    }
    
    CGPoint loc = [t locationInView:self];
    
    if(CGRectContainsPoint(self.excludeRect, loc))
    {
        return;
    }
    
    [delegate dismissModel];
}

@end


@interface HelpGridView()
{
    BOOL pageControlUsed;
    int _pageCount;
    NSMutableArray *_pages;
    TouchView* peekView;
}

- (void)pageChanged:(id)sender;
-(void)loadPage:(int)pageNum;
- (void)getNextPage:(id *)sender ;
@end

@implementation HelpGridView

-(void)dealloc
{
    if(nil != _pages)
    {
        [_pages release];
        _pages = nil;
    }
    
    [super dealloc];
}

-(void)dismissModel
{
    [peekView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)createAndAttachTouchPeekView {
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if(nil != peekView)
    {
        [peekView removeFromSuperview];
    }
    
	peekView = nil;
	peekView = [[TouchView alloc] initWithFrame:window.frame];
	[peekView setDelegate:self];
    peekView.excludeRect = self.frame;
	
    [self.superview insertSubview:peekView belowSubview:self];
	//[window addSubview:peekView];
    [peekView release];
}

-(void)didMoveToSuperview
{
    if(nil == peekView)
    {
        [self createAndAttachTouchPeekView];
    }
}

-(void)updatePageCount
{
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
    
    pgControl.numberOfPages = _pageCount;
    
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
    
    scrlView.contentSize = CGSizeMake(scrlView.frame.size.width * _pageCount, scrlView.frame.size.height);
}

-(void)closeHelp:(id)sender
{
    [self dismissModel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = PHOTO_DEFAULT_COLOR;
        
        UILabel *mainTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, TOP_DELIMITER)];
        mainTitle.backgroundColor = [UIColor clearColor];
        mainTitle.textColor = [UIColor whiteColor];
        mainTitle.textAlignment = UITextAlignmentCenter;
        mainTitle.font = [UIFont boldSystemFontOfSize:TOP_DELIMITER-10.0];
        mainTitle.text = @"Help";
        [self addSubview:mainTitle];
        [mainTitle release];
        _pageCount = 9;
        // Initialization code
        scrlView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TOP_DELIMITER, frame.size.width, frame.size.height - HELP_PAGECONTROL_HEIGHT - TOP_DELIMITER)];
        scrlView.pagingEnabled = YES;
        scrlView.contentSize = frame.size;
        scrlView.showsHorizontalScrollIndicator = NO;
        scrlView.showsVerticalScrollIndicator = NO;
        scrlView.scrollsToTop = NO;
        scrlView.delegate = self;
        //scrlView.backgroundColor = [UIColor redColor];
        scrlView.userInteractionEnabled = YES;
        
        pgControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,frame.size.height - HELP_PAGECONTROL_HEIGHT,HELP_PAGECONTROL_HEIGHT,HELP_PAGECONTROL_HEIGHT)];
        pgControl.numberOfPages = 3;
        pgControl.currentPage   = 0;
        pgControl.center        = CGPointMake(scrlView.center.x,pgControl.center.y);
        [pgControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        pgControl.userInteractionEnabled = YES;
        [self addSubview:scrlView];
        [self addSubview:pgControl];
        [scrlView release];
        [pgControl release];
        
        [self updatePageCount];
        [self loadPage:0];
        
        UIButton *next = [[UIButton alloc]initWithFrame:CGRectNull];
        float buttonWidth = 60.0;
        float radius = 10.0;
        next.frame = CGRectMake(frame.size.width-buttonWidth-10.0, frame.size.height-(TOP_DELIMITER), buttonWidth, TOP_DELIMITER);
        next.backgroundColor = [UIColor whiteColor];
        next.layer.cornerRadius = radius;
        next.layer.masksToBounds = NO;
        next.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        next.titleLabel.textColor = PHOTO_DEFAULT_COLOR;
        next.titleLabel.text = @"Next";
        next.showsTouchWhenHighlighted = YES;
        [next setTitle:@"Next" forState:UIControlStateNormal];
        [next setTitleColor:PHOTO_DEFAULT_COLOR forState:UIControlStateNormal];
        [next addTarget:self action:@selector(getNextPage:) forControlEvents:UIControlEventTouchUpInside];
        next.center = CGPointMake(next.center.x, pgControl.center.y);
        
        [self addSubview:next];
        [next release];
        
        UIButton *close = [[UIButton alloc]initWithFrame:CGRectNull];
        close.frame = CGRectMake(10.0, frame.size.height-(TOP_DELIMITER), buttonWidth, TOP_DELIMITER);
        close.backgroundColor = [UIColor whiteColor];
        close.layer.cornerRadius = radius;
        close.layer.masksToBounds = NO;
        close.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        close.titleLabel.textColor = PHOTO_DEFAULT_COLOR;
        close.titleLabel.text = @"Close";
        close.showsTouchWhenHighlighted = YES;
        [close setTitle:@"Close" forState:UIControlStateNormal];
        [close setTitleColor:PHOTO_DEFAULT_COLOR forState:UIControlStateNormal];
        close.center = CGPointMake(close.center.x, pgControl.center.y);
        [close addTarget:self action:@selector(closeHelp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:close];
        [close release];
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = HELP_GRID_RADIUS;
    }
    return self;
}

-(UIView*)allocPageForPageNume:(int)pageNum
{
    if(pageNum == 0)
    {
        
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT-TOP_DELIMITER)];
        //h.centerImage = [UIImage imageWithContentsOfFile:[Utility helpImagePathForNumber:1]];
        h.centerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help-01" ofType:@"png"]];
#if 0
        UIImageView *singleTouch = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,50.0*GESTURE_SCALE,50.0*GESTURE_SCALE)];
        singleTouch.contentMode = UIViewContentModeScaleAspectFit;
        singleTouch.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"SingleTap" ofType:@"png"]];
        [h addSubview:singleTouch];
        [singleTouch release];
        singleTouch.center = CGPointMake(h.center.x, (self.frame.size.height)/4.0);
#endif
        [h setHelpText:NSLocalizedString(@"Select your frame and shape",@"Select your frame and shape")];
        [h setTitleText:NSLocalizedString(@"Select Frame",@"Select Frame")];
        
        return h;
    }
    else if(pageNum == 1)
    {
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT -TOP_DELIMITER )];
        //h.centerImage = [UIImage imageWithContentsOfFile:[Utility helpImagePathForNumber:2]];
        h.centerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help-02" ofType:@"png"]];
#if 0
        UIImageView *touch = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,70.0*GESTURE_SCALE,70.0*GESTURE_SCALE)];
        touch.contentMode = UIViewContentModeScaleAspectFit;
        touch.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"DoubleTap" ofType:@"png"]];
        [h addSubview:touch];
        [touch release];
        touch.center = CGPointMake(h.center.x, (self.frame.size.height)/4.0);

        [h setHelpText:NSLocalizedString(@"HELP2_B",@"Double Tap to Apply effects to Photo")];
        [h setTitleText:NSLocalizedString(@"HELP2_T",@"Apply Effect")];
#endif
        [h setHelpText:@"Tap and select your image or video."];
        [h setTitleText:NSLocalizedString(@"Select Image or Video",@"Select Image or Video")];
        
        return h;
    }
    else if(pageNum == 2)
    {
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT -TOP_DELIMITER )];
        //h.centerImage = [UIImage imageWithContentsOfFile:[Utility helpImagePathForNumber:2]];
        h.centerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help-03" ofType:@"png"]];
#if 0
        UIImageView *touch = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,70.0*GESTURE_SCALE,70.0*GESTURE_SCALE)];
        touch.contentMode = UIViewContentModeScaleAspectFit;
        touch.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"DoubleTap" ofType:@"png"]];
        [h addSubview:touch];
        [touch release];
        touch.center = CGPointMake(h.center.x, (self.frame.size.height)/4.0);
        
        [h setHelpText:@"Double Tap to Apply effects to Photo";
        [h setTitleText:NSLocalizedString(@"HELP2_T",@"Apply Effect")];
#endif
        [h setHelpText:@"Change Frame's Color and Pattern By using Color and Pattern Picker"];
        [h setTitleText:@"Color And Pattern"];
        
        return h;
    }
    else if(pageNum == 3)
    {
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT -TOP_DELIMITER )];
        //h.centerImage = [UIImage imageWithContentsOfFile:[Utility helpImagePathForNumber:2]];
        h.centerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help-04" ofType:@"png"]];
#if 0
        UIImageView *touch = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,70.0*GESTURE_SCALE,70.0*GESTURE_SCALE)];
        touch.contentMode = UIViewContentModeScaleAspectFit;
        touch.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"DoubleTap" ofType:@"png"]];
        [h addSubview:touch];
        [touch release];
        touch.center = CGPointMake(h.center.x, (self.frame.size.height)/4.0);
#endif
        [h setHelpText:@"Use the Sliders to Adjust Corner radius and Frame Width"];
        [h setTitleText:@"Width and Corner"];
        
        return h;
    }

    else if(pageNum == 4)
    {
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT-TOP_DELIMITER)];
        h.centerImage = [UIImage imageWithContentsOfFile:[Utility helpImagePathForNumber:3]];
        
        /* Add Pan Icon */
        UIImageView *touch = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,70.0*GESTURE_SCALE,70.0*GESTURE_SCALE)];
        touch.contentMode = UIViewContentModeScaleAspectFit;
        touch.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Pan" ofType:@"png"]];
        [h addSubview:touch];
        [touch release];
        touch.center = CGPointMake(h.center.x, (self.frame.size.height)/4.0);
        
        /* Add Pinch Icon */
        UIImageView *touch1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,70.0*GESTURE_SCALE,70.0*GESTURE_SCALE)];
        touch1.contentMode = UIViewContentModeScaleAspectFit;
        touch1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ZoomOut" ofType:@"png"]];
        [h addSubview:touch1];
        [touch1 release];
        touch1.center = CGPointMake(h.center.x, (self.frame.size.height)*2.5/4.0);
        
        [h setHelpText:@"Pinch to Zoom in and Zoom out, Pan to move the photo around"];
        [h setTitleText:@"Zoom And Pan"];
        
        return h;
    }
    else if(pageNum == 5)
    {
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT - TOP_DELIMITER)];
        h.centerImage = [UIImage imageWithContentsOfFile:[Utility helpImagePathForNumber:1]];
        UIImageView *touch = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,70.0*GESTURE_SCALE,70.0*GESTURE_SCALE)];
        touch.contentMode = UIViewContentModeScaleAspectFit;
        touch.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"AdjustBorder" ofType:@"png"]];
        [h addSubview:touch];
        [touch release];
        touch.center = CGPointMake(h.center.x, (self.frame.size.height)/2.15);
        [h setHelpText:@"Drag The border to adjust the frame"];
        [h setTitleText:@"Adjust Frame"];
        
        return h;
    }
#if 1
    else if(pageNum == 8)
    {
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT - TOP_DELIMITER)];
        h.centerStackImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help-07" ofType:@"png"]];
        [h setHelpText:@"Share your Video/Image Frame with friends."];
        [h setTitleText:@"Share"];
        
        return h;
    }
#endif    
    else if(pageNum == 6)
    {
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT - TOP_DELIMITER)];
        h.centerStackImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help-05" ofType:@"png"]];
        [h setHelpText:@"Select music to add in your video."];
        [h setTitleText:@"Video Settings"];
        
        return h;
    }
    else if(pageNum == 7)
    {
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT - TOP_DELIMITER)];
        h.centerStackImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help-06" ofType:@"png"]];
        [h setHelpText:@"Click on preview button to play video preview."];
        [h setTitleText:@"Preview"];
        
        return h;
    }
#if 0
    else if(pageNum == 8)
    {
        HelpFrame *h = [[HelpFrame alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height-HELP_PAGECONTROL_HEIGHT - TOP_DELIMITER)];
        h.centerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"help6" ofType:@"jpg"]];;
        [h setHelpText:NSLocalizedString(@"HELP8_B",@"Click On Menu To create New project or load the eralier saved projects")];
        [h setTitleText:NSLocalizedString(@"HELP8_T",@"Projects")];
        
        return h;
    }
#endif
    else
    {
        NSLog(@"Allocating UIView");
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrlView.frame.size.width, scrlView.frame.size.height)];
        if(nil == v)
        {
            NSLog(@"allocPageForPageNume:Failed to allocate memory for view");
            return nil;
        }
        
        v.backgroundColor = [UIColor greenColor];
        
        return v;
    }
}

-(void)loadPage:(int)pageNum
{
    if((pageNum < 0) || (pageNum >= _pageCount))
    {
        NSLog(@"loadPage: invalid pagenumber %d for pagecount %d",pageNum,_pageCount);
        return;
    }
    
    NSLog(@"LoadPage %d",pageNum);
    
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

- (void)getNextPage:(id *)sender 
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) 
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    int page = pgControl.currentPage + 1;
    pgControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadPage:page - 1];
    [self loadPage:page];
    [self loadPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
    CGRect frame = scrlView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrlView scrollRectToVisible:frame animated:YES];
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    pageControlUsed = NO;
}

- (void)pageChanged:(id)sender 
{
    int page = pgControl.currentPage;
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
