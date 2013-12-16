//
//  GridView.m
//  GridView
//
//  Created by Vijaya kumar reddy Doddavala on 3/15/12.
//  Copyright (c) 2012 motorola. All rights reserved.
//

#import "GridView.h"

typedef struct
{
    float redValue;
    float greenValue;
    float bluevalue;

}eRGBValues;

eRGBValues rgbValues[52]={
    {255,255,255},
    {0,0,0},
    {51,25,0},
    {76,153,0},//green
    {0,25,51},// nevy blue
    {127,0,255},//pink
    {255,102,255},//meroon
    {0,153,76},// sky blue
    {153,76,0},
    {255,178,102},
    {153,153,0},
    {153,255,255},
    {102,102,255},
    {76,0,153},
    {51,0,25},
    {255,0,178},
    {139,58,98},
    {255,130,171},
    {255,181,197},
    {64,64,64},
    {0,76,153},
    {0,0,204},
    {25,0,51},
    {255,128,0},
    {153,0,0},
    {255,255,0},
    {0,255,128},
    {128,255,0},
    {51,255,255},
    {102,0,102},
    {0,128,255},
    {255,0,0},
    {51,51,255},
    {102,178,255},
    {178,102,255},
    {255,51,255},
    {51,51,0},
    {204,0,204},
    {153,0,76},
    {255,0,127},
    {255,255,102},
    {25,51,0},
    {0,0,102},
    {255,153,153},
    {205,96,144},
    {0,204,204},
    {178,255,102},
    {0,51,25},
    {102,255,178},
    {0,102,102},
    {160,160,160},
    {51,0,0}
};

@interface GridView()
{
    BOOL pageControlUsed;
    int _itemsPerPage;
    int _totalItemsCount;
    int _pageCount;
    int _rows;
    int _cols;
    NSMutableArray *_pages;

    int colororPattern;
}

@property(nonatomic,readwrite)int itemsPerPage;

- (void)pageChanged:(id)sender;
-(void)loadPage:(int)pageNum;
@end

@implementation GridView
@synthesize filePrefix;
@synthesize delegate;

-(void)setRowCount:(int)rows colCount:(int)cols
{
    _rows = rows;
    _cols = cols;
    self.itemsPerPage = rows * cols;
    
    [self loadPage:0];
    [self loadPage:1];
}

-(void)removeFromSuperview
{
    if(nil != _pages)
    {
        [_pages release];
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
    if(nil != filePrefix)
    {
        [filePrefix release];
        filePrefix = nil;
    }
    
    if(nil != _pages)
    {
        [_pages release];
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

    [super dealloc];
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
        NSLog(@"Initializing page %d to nil",i);
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

- (id)initWithFrame:(CGRect)frame option:(int)colorOrPattern
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
        colororPattern = colorOrPattern;

        NSLog(@"%d ***********  &&&&&&& ",colororPattern);
        scrlView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - PAGECONTROL_HEIGHT)];
        scrlView.pagingEnabled = YES;
        scrlView.contentSize = frame.size;
        scrlView.showsHorizontalScrollIndicator = NO;
        scrlView.showsVerticalScrollIndicator = NO;
        scrlView.scrollsToTop = NO;
        scrlView.delegate = self;
        //scrlView.backgroundColor = [UIColor redColor];
        scrlView.userInteractionEnabled = YES;
        
        pgControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,frame.size.height - PAGECONTROL_HEIGHT,PAGECONTROL_HEIGHT,PAGECONTROL_HEIGHT)];
        pgControl.numberOfPages = 3;
        pgControl.currentPage   = 0;
        pgControl.center        = CGPointMake(scrlView.center.x,pgControl.center.y);
        [pgControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        pgControl.userInteractionEnabled = YES;
        [self addSubview:scrlView];
        [self addSubview:pgControl];
        [scrlView release];
        [pgControl release];
    }
    
    return self;
}

-(float)horizantalGap
{
    float hSpaceForItems = ITEM_WIDTH * _cols;
    float gap = (scrlView.frame.size.width-hSpaceForItems)/(_cols+1);
    
    return gap;
}

-(float)verticleGap
{
    float vSpaceForItems = ITEM_HEIGHT * _rows;
    float gap = (scrlView.frame.size.height-vSpaceForItems)/(_rows+1);
   
    return gap;
}

-(UIImage*)imageForItem:(int)itemIndex
{
#if 0    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
	NSString *pFileName = nil;
	NSString *pFileNameWithExt = nil;
    
    pFileName = [NSString stringWithFormat:@"%@_%d",filePrefix,itemIndex];
    pFileNameWithExt = [NSString stringWithFormat:@"%@.png",pFileName];
	
	/* Return the path to the puzzle status information */
	NSString *path = [docDirectory stringByAppendingPathComponent:pFileNameWithExt];
    
    NSLog(@"file %@ ",pFileNameWithExt);
    
    if([[NSFileManager defaultManager]fileExistsAtPath:path] == NO)
    {
        NSLog(@"doesn't exist");
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:pFileName ofType:@"png"]];
#else
    NSString *pFileName = nil;
    pFileName = [NSString stringWithFormat:FILENAME_PATTERN_FORMAT,filePrefix,itemIndex];
    
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:pFileName ofType:@"png"]];
#endif
}

-(void)patternSelected:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (colororPattern == TAG_GRIDVIEW_COLOR)
    {
        [delegate colorItemSelected:btn.backgroundColor];
    }
    else
    {
        [delegate itemSelectedAtIndex:btn.tag ofGridView:self];
    }
    
    return;
}

-(UIView*)allocPageForPageNume:(int)pageNum
{

     NSLog(@"****************  %d",colororPattern);
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrlView.frame.size.width, scrlView.frame.size.height)];
    if(nil == v)
    {
        NSLog(@"allocPageForPageNume:Failed to allocate memory for view");
        return nil;
    }
    
    UIColor *clr = [UIColor whiteColor];
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
            float x = ([self horizantalGap] * (j+1)) + (j * ITEM_WIDTH);
            float y = ([self verticleGap] * (i+1)) + (i * ITEM_HEIGHT);
            float width = ITEM_WIDTH;
            float height = ITEM_HEIGHT;
                       
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x,y,width,height)];
            btn.backgroundColor = clr;
            [v addSubview:btn];
            [btn release];
            
            /* set the tag for the button */
            btn.tag = itemIndex;
            
            /* set the image */
            if(nil == filePrefix)
            {
                NSLog(@"File Prefix is not yet set");
                continue;
            }
            
            if (colororPattern == TAG_GRIDVIEW_COLOR)
            {
                
                int index = itemIndex -1;
                [btn setBackgroundColor:[UIColor colorWithRed:(rgbValues[index].redValue/255) green:(rgbValues[index].greenValue/255) blue:(rgbValues[index].bluevalue/255) alpha:1.0]];
            }
            else if(colororPattern == TAG_GRIDVIEW_PATTERN)
            {
                [btn setBackgroundImage:[self imageForItem:itemIndex] forState:UIControlStateNormal];
            }
            
            /* set the action */
            [btn addTarget:self action:@selector(patternSelected:) forControlEvents:UIControlEventTouchDown];
        }
    }
    
    return v;
}
+(UIColor *)getColorAtIndex:(int)index
{
    UIColor *color = [UIColor colorWithRed:(rgbValues[index].redValue/255) green:(rgbValues[index].greenValue/255) blue:(rgbValues[index].bluevalue/255) alpha:1.0];
    return  color;
}
+(UIColor *)getPatternAtIndex:(int)index
{
    NSString *pFileName = nil;
    pFileName = [NSString stringWithFormat:@"patt%d",index];

    UIImage *patternImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:pFileName ofType:@"png"]];
    UIColor *pattern = [UIColor colorWithPatternImage:patternImage];
    return pattern;

}

+(BOOL)getLockStatusOfColor:(int)index
{
    BOOL locked ;
    if (index>15) {
        locked = YES;
    }else{
        locked = NO;
    }
    return locked;
}
+(BOOL)getLockStatusOfPatern:(int)index
{
    BOOL locked ;
    if (index>10) {
        locked = YES;
    }else{
        locked = NO;
    }
    return locked;
}
-(void)loadPage:(int)pageNum
{
    if((pageNum < 0) || (pageNum >= _pageCount))
    {
        NSLog(@"loadPage: invalid pagenumber %d for pagecount %d",pageNum,_pageCount);
        return;
    }
    
    NSLog(@"LoadPage %d color or pattern %d",pageNum,colororPattern);
    
    // replace the placeholder if necessary
    UIView *page = [_pages objectAtIndex:pageNum];
    if ((NSNull *)page == [NSNull null]) 
    {
        NSLog(@"About to allocate page num %d",pageNum);
        page = [self allocPageForPageNume:pageNum];
        [_pages replaceObjectAtIndex:pageNum withObject:page];
        [page release];
    }
    
    
    // add the controller's view to the scroll view
    if (nil == page.superview) 
    {
        NSLog(@"Adding page %d to scroll view",pageNum);
        CGRect frame = scrlView.frame;
        frame.origin.x = frame.size.width * pageNum;
        frame.origin.y = 0;
        page.frame = frame;
        [scrlView addSubview:page];
    }
    
    [self.superview.superview setNeedsDisplay];
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
