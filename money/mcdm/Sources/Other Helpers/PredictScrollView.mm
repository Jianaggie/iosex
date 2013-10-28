
#import "PredictScrollView.h"
#import "UIUtil.h"

@implementation PredictScrollView
@synthesize pages=_pages;
@synthesize currentPage=_currentPage;
@synthesize numberOfPages=_numberOfPages;
@synthesize delegate2=_delegate2;

#pragma mark Generic methods

#define kPad 10

// Constructor
- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame leftRightPad:kPad];
}

- (id)initWithFrame:(CGRect)frame leftRightPad:(CGFloat)pad
{
    frame.origin.x = -(pad / 2);
	frame.size.width += pad;
    
    self = [super initWithFrame:frame];
    if (self)
    {
        _leftRightPad = pad;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
    }
	
	return self;
}

// Destructor
- (void)dealloc
{
	if (_pages) free(_pages);
    _pages = nil;
    
	[super dealloc];
}

// Remove cached pages
- (void)freePages:(BOOL)force
{	
	NSUInteger count = _numberOfPages;
	for (NSUInteger i = 0; i < count; ++i)
	{
		if (_pages[i]) 
		{
			if ((i != _currentPage) && (force || ((i != _currentPage - 1) && (i != _currentPage + 1))))
			{
				[_pages[i] removeFromSuperview];
				_pages[i] = nil;
			}
		}
	}
}

- (void)removeAllPages
{
    NSUInteger count = _numberOfPages;
	for (NSUInteger i = 0; i < count; ++i)
	{
		if (_pages[i])
        {
            [_pages[i] removeFromSuperview];
            _pages[i] = nil;
		}
	}
}

//
- (void)loadPage:(NSUInteger)index
{	
	if (index >= _numberOfPages) return;
	if (_pages[index]) return;

	CGRect frame = self.frame;
	frame.origin.y = 0;
	frame.origin.x = frame.size.width * index + (_leftRightPad / 2);
	frame.size.width -= _leftRightPad;

	_pages[index] = [_delegate2 scrollView:self viewForPage:index inFrame:frame];
	//_pages[index].autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _pages[index].autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[self addSubview:_pages[index]];
}

- (void)refreshCurrentPage
{
    if (_pages[_currentPage])
    {
        [_pages[_currentPage] removeFromSuperview];
        _pages[_currentPage] = nil;
    }
    
    if (_currentPage > 0 && _pages[_currentPage-1])
    {
        [_pages[_currentPage-1] removeFromSuperview];
        _pages[_currentPage-1] = nil;
    }
    
    if (_currentPage < _numberOfPages-1 && _pages[_currentPage+1])
    {
        [_pages[_currentPage+1] removeFromSuperview];
        _pages[_currentPage+1] = nil;
    }
    
    self.currentPage = self.currentPage;
}

- (void)scrollToNextOrPrevPage:(BOOL)next
{
    int currentPage = 0;
    if (next)
    {
        if (_currentPage < _numberOfPages-1)
        {
            currentPage = _currentPage+1;
        }
    }
    else
    {
        if (_currentPage > 0)
        {
            currentPage = _currentPage-1;
        }
    }
    
    if (currentPage >= _numberOfPages)
	{
		currentPage = 0;
	}
	if (_currentPage != currentPage)
	{
		[self setContentOffset:CGPointMake(self.frame.size.width * currentPage, 0) animated:YES];
	}
	else
	{
		[self loadPages];
	}
}

//
- (void)setPageFrames
{
    if (_pages)
    {
        if (_pages[_currentPage])
        {
            CGRect frame = _pages[_currentPage].frame;
            frame.size.height = self.frame.size.height;
            _pages[_currentPage].frame = frame;
        }
        
        if (_currentPage > 0 && _pages[_currentPage-1])
        {
            CGRect frame = _pages[_currentPage-1].frame;
            frame.size.height = self.frame.size.height;
            _pages[_currentPage-1].frame = frame;
        }

        if (_currentPage < _numberOfPages-1 && _pages[_currentPage+1])
        {
            CGRect frame = _pages[_currentPage+1].frame;
            frame.size.height = self.frame.size.height;
            _pages[_currentPage+1].frame = frame;
        }
    }
}

//
- (void)loadNearby
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self loadPage:_currentPage - 1];
	[self loadPage:_currentPage + 1];
	[pool release];
}

//
- (void)scheduledNearby
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(loadNearby) withObject:nil waitUntilDone:YES];
	[pool release];
}

//
- (void)loadPages
{
	if (_currentPage >= _numberOfPages || _currentPage < 0)
	{
		return;
	}
	
	[self freePages:NO];
	[self loadPage:_currentPage];
	[_delegate2 scrollView:self scrollToPage:_currentPage];

	[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(scheduledNearby) userInfo:nil repeats:NO];
}

//
- (void)setCurrentPage:(NSInteger)currentPage
{	
	if (currentPage >= _numberOfPages)
	{
		currentPage = 0;
	}
	if (_currentPage != currentPage)
	{
		self.contentOffset = CGPointMake(self.frame.size.width * currentPage, 0);
	}
	else
	{
		[self loadPages];
	}
}

//
- (void)setNumberOfPages:(NSUInteger)numberOfPages
{
	if (_numberOfPages) [self removeSubviews];
	_numberOfPages = numberOfPages;
	
	NSUInteger size = numberOfPages * sizeof(UIView *);
	_pages = (UIView **)realloc(_pages, size);
	memset(_pages, 0, size);
}


#pragma mark View methods

// Draws the image within the passed-in rectangle.
//- (void)drawRect:(CGRect)rect
//{
//	[super drawRect:rect];
//}

// Layout subviews.
- (void)layoutSubviews
{	
	bIgnore = YES;
	[super layoutSubviews];
	self.contentSize = CGSizeMake(self.frame.size.width * _numberOfPages, self.frame.size.height);
	bIgnore = NO;
}

// Set view frame.
- (void)setFrame:(CGRect)frame
{	
	bIgnore = YES;
	[super setFrame:frame];
	
    [self setPageFrames];
    
    self.contentOffset = CGPointMake(frame.size.width * _currentPage, 0);
    
	bIgnore = NO;
}


#pragma mark Scroll view methods

//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	if (bIgnore == NO)
	{
		CGFloat width = scrollView.frame.size.width;
		NSUInteger currentPage = floor((scrollView.contentOffset.x - width / 2) / width) + 1;	// TODO: Check for another expression
		if (_currentPage != currentPage)
		{
			_currentPage = currentPage;
			[self loadPages];
		}
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_delegate2 respondsToSelector:@selector(scrollViewWillBeginDragging)])
    {
        [_delegate2 scrollViewWillBeginDragging];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_delegate2 respondsToSelector:@selector(scrollViewDidEndDecelerating)])
    {
        [_delegate2 scrollViewDidEndDecelerating];
    }
}

- (UIView *)currentPageView
{
    if (_currentPage >= _numberOfPages || _currentPage < 0)
	{
		return nil;
	}
    
    return _pages[_currentPage];
}

- (UIView *)previousPageView
{
    if (_currentPage == 0)
	{
		return nil;
	}
    
    return _pages[_currentPage-1];
}

- (UIView *)nextPageView
{
    if (_currentPage == _numberOfPages-1)
	{
		return nil;
	}
    
    return _pages[_currentPage+1];
}

@end

//
@implementation PageControlScrollView
@synthesize pageCtrl=_pageCtrl;

//
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	frame.origin.y = frame.size.height - 20;
	frame.size.height = 20;
	_pageCtrl = [[SuperPageControl alloc] initWithFrame:frame];
	_pageCtrl.autoresizingMask = UIViewAutoresizingFlexibleWidth;// | UIViewAutoresizingFlexibleTopMargin;
	_pageCtrl.numberOfPages = 0;
	_pageCtrl.currentPage = 0;
    _pageCtrl.hidesForSinglePage = YES;
	[_pageCtrl addTarget:self action:@selector(setCurrentPage) forControlEvents:UIControlEventValueChanged];
	
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /*
    CGRect frame = _pageCtrl.frame;
    frame.origin.y = self.superview.frame.size.height - 20;
	_pageCtrl.frame = frame;*/
}

// YES for left, NO for right.
- (void)alignDotsTo:(BOOL)left
{
    if (_pageCtrl)
    {
        CGRect frame = _pageCtrl.frame;
        CGSize size = [_pageCtrl sizeForNumberOfPages:_pageCtrl.numberOfPages];
        
        if (left)
        {
            if (frame.size.width == self.frame.size.width)
            {
                return;
            }
            
            frame.size.width = size.width;
            frame.origin.x = 10;
            _pageCtrl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        }
        else
        {
            if (frame.origin.x)
            {
                return;
            }
            
            frame.origin.x = frame.size.width - size.width - 10;
            frame.size.width = size.width;
            _pageCtrl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        }
        
        _pageCtrl.frame = frame;
    }
}

- (void)alignDotsToRight
{
    [self alignDotsTo:NO];
}

- (void)alignDotsToLeft
{
    [self alignDotsTo:YES];
}

//
- (void)dealloc
{
	[_pageCtrl release];
	[super dealloc];
}

//
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	if (_hasParent)
	{
		[_pageCtrl removeFromSuperview];
		_hasParent = NO;
	}
}

//
- (void)didMoveToSuperview
{
	if (self.superview)
	{
		_hasParent = YES;
		[self.superview addSubview:_pageCtrl];
	}
}

//
- (void)setNumberOfPages:(NSUInteger)count
{
	[super setNumberOfPages:count];
	_pageCtrl.numberOfPages = count;
}

//
- (void)loadPages
{
	[super loadPages];
	_pageCtrl.currentPage = self.currentPage;
}

//
- (void)setCurrentPage
{
	self.currentPage = _pageCtrl.currentPage;
}

@end