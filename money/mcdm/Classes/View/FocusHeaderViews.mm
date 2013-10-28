//
//  FocusHeaderImageNewsView.m
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "FocusHeaderViews.h"
#import "TouchImageView.h"
#import "NewsItem.h"

@implementation FocusHeaderImageNewsView

@synthesize newsArray;
@synthesize container;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		CGRect frame = self.frame;
		frame.origin.y = 0;
		_scrollView = [[PageControlScrollView alloc] initWithFrame:frame];
		_scrollView.delegate2 = self;
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor lightGrayColor];
		
		[self addSubview:_scrollView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc
{
	self.newsArray = nil;
	
	container = nil;
	_scrollView.delegate2 = nil;
	
	[_scrollView release];
	_scrollView = nil;
    [super dealloc];
}

- (void)setNewsArray:(NSArray *)array
{
	[newsArray release];
    
    if (!array)
    {
        return;
    }
    
	newsArray = [array retain];
    
    if (_scrollView.numberOfPages == 0)
    {
        _scrollView.numberOfPages = [newsArray count];
        _scrollView.currentPage = 0;
    }
    else if (_scrollView.numberOfPages && [newsArray count])
    {
        _scrollView.numberOfPages = [newsArray count];
        [_scrollView refreshCurrentPage];
    }
	
	//((PageControlScrollView *)_scrollView).pageCtrl.hidden = ([newsArray count] == 1);
    ((PageControlScrollView *)_scrollView).pageCtrl.hidesForSinglePage = YES;
    ((PageControlScrollView *)_scrollView).pageCtrl.enabled = NO;
    [(PageControlScrollView *)_scrollView alignDotsToRight];

//    ((PageControlScrollView *)_scrollView).pageCtrl.colorOrImageForStateNormal = [ConfigReader readColorOrImageProperty:_uiSkinParams withName:@"dotBackgroundNormal"];
//    
//    ((PageControlScrollView *)_scrollView).pageCtrl.colorOrImageForStateHightlighted = [ConfigReader readColorOrImageProperty:_uiSkinParams withName:@"dotBackgroundSelected"];
}

//
- (UIView *)scrollView:(PredictScrollView *)scrollView viewForPage:(NSUInteger)index inFrame:(CGRect)frame
{
	NSDictionary *item = [newsArray objectAtIndex:index];
    
    // if no xib, create it by code.
    {
        // Create page view for image content
        DelayImageView *view  = [[DelayImageView alloc] initWithFrame:frame];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        
        //UIImage *image = [UIImage imageNamed:@"NewsHeader.png"];
        
        NSString *iconUrl = [item objectForKey:@"photosPath"];
        if ([iconUrl length])
        {
            [view setUrl:iconUrl];
        }
        else
        {
            view.image = [UIImage imageNamed:@"NewsHeader.png"];
        }
                
        //[view setImage:image];
        [view addTarget:self action:@selector(openObject)];
        
#define kPad 0
        
        // Calculate text area
        CGFloat width = frame.size.width - kPad;
        
        CGFloat height = 32;
        
        // Create trransparent area
        TouchImageView *area = [[TouchImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - height, frame.size.width, height)];
        area.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        area.image = [UIImage imageNamed:@"DescFrame.png"];
        //[area addTarget:self action:@selector(openObject)];
        [view addSubview:area];
        [area release];
        
        // Create text label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kPad / 2, 0, width, height)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16.f];
        label.text = [item objectForKey:@"title"];
        label.lineBreakMode = UILineBreakModeWordWrap;
        [area addSubview:label];
        [label release];
        
        // background color.
        UIColor *focusNewsTitleViewBackgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
        label.backgroundColor = focusNewsTitleViewBackgroundColor;
        
        // text color.
        label.textColor = [UIColor whiteColor];
        
        return [view autorelease];
    }
}

//
- (void)scrollView:(PredictScrollView *)scrollView scrollToPage:(NSUInteger)index
{
}

//
- (void)openObject
{
	if (container && [container respondsToSelector:@selector(openObject:)])
	{
		[container performSelector:@selector(openObject:) withObject:[NSNumber numberWithInt:_scrollView.currentPage]];
	}
}

@end


@implementation FocusHeaderAppView

@synthesize newsArray;
@synthesize container;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		CGRect frame = self.frame;
		frame.origin.y = 0;
		_scrollView = [[PageControlScrollView alloc] initWithFrame:frame];
		_scrollView.delegate2 = self;
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor lightGrayColor];
		
		[self addSubview:_scrollView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc
{
	self.newsArray = nil;
	
	container = nil;
	_scrollView.delegate2 = nil;
	
	[_scrollView release];
	_scrollView = nil;
    [super dealloc];
}

- (void)setNewsArray:(NSArray *)array
{
	[_array release];
    
    if (!array)
    {
        return;
    }
    
	_array = [array retain];
    
    if (_scrollView.numberOfPages == 0)
    {
        _scrollView.numberOfPages = [_array count];
        _scrollView.currentPage = 0;
    }
    else if (_scrollView.numberOfPages && [_array count])
    {
        _scrollView.numberOfPages = [_array count];
        [_scrollView refreshCurrentPage];
    }
	
	//((PageControlScrollView *)_scrollView).pageCtrl.hidden = ([newsArray count] == 1);
    ((PageControlScrollView *)_scrollView).pageCtrl.hidesForSinglePage = YES;
    ((PageControlScrollView *)_scrollView).pageCtrl.enabled = NO;
    //[(PageControlScrollView *)_scrollView alignDotsToRight];
}

//
- (UIView *)scrollView:(PredictScrollView *)scrollView viewForPage:(NSUInteger)index inFrame:(CGRect)frame
{
	NSDictionary *item = [_array objectAtIndex:index];
    
    // if no xib, create it by code.
    {
        // Create page view for image content
        DelayImageView *view  = [[DelayImageView alloc] initWithFrame:frame];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        
        //UIImage *image = [UIImage imageNamed:@"AppHeader.png"];
        //[view setImage:image];
        
        NSArray *screenShotUrls = [item objectForKey:@"screenShotUrls"];
        if ([screenShotUrls count])
        {
            view.url = [screenShotUrls objectAtIndex:0];
        }
        
        [view addTarget:self action:@selector(openObject)];
        
#define kPad 0
        
        /*
        // Calculate text area
        CGFloat width = frame.size.width - kPad;
        
        CGFloat height = 32;
        
        // Create trransparent area
        TouchImageView *area = [[TouchImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - height, frame.size.width, height)];
        area.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        area.image = [UIImage imageNamed:@"DescFrame.png"];
        //[area addTarget:self action:@selector(openObject)];
        [view addSubview:area];
        [area release];
        
        // Create text label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kPad / 2, 0, width, height)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16.f];
        label.text = [NSString stringWithFormat:@"  %@", [item objectForKey:@"name"]];
        label.lineBreakMode = UILineBreakModeWordWrap;
        [area addSubview:label];
        [label release];
        
        // background color.
        UIColor *focusNewsTitleViewBackgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3];
        label.backgroundColor = focusNewsTitleViewBackgroundColor;
        
        // text color.
        label.textColor = [UIColor whiteColor];*/
        
        return [view autorelease];
    }
}

//
- (void)scrollView:(PredictScrollView *)scrollView scrollToPage:(NSUInteger)index
{
}

//
- (void)openObject
{
	if (container && [container respondsToSelector:@selector(openObject:)])
	{
		[container performSelector:@selector(openObject:) withObject:[NSNumber numberWithInt:_scrollView.currentPage]];
	}
}

@end
