
#import "UIUtil.h"
#import "UICustomPageControl.h"
#import <QuartzCore/CALayer.h>

@implementation UICustomPageControl

@synthesize currentPage = _currentPage;
@synthesize numberOfPages = _numberOfPages;

//
- (id)initWithFrame:(CGRect)frame
{
	[super initWithFrame:frame];
	self.userInteractionEnabled = NO;
	self.opaque = NO;
	
	return self;
}

- (void)dealloc
{
	[_indicatorImageViews release];
	[super dealloc];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
	if (_currentPage == currentPage)
	{
		return;
	}
	
	if (_indicatorImageViews && [_indicatorImageViews count] > currentPage)
	{
		UIImageView *displayed = [_indicatorImageViews objectAtIndex:_currentPage];
		displayed.image = [UIImage imageNamed:@"PageUnchosed.png"];
		
		UIImageView *current = [_indicatorImageViews objectAtIndex:currentPage];
		current.image = [UIImage imageNamed:@"PageChosed.png"];
		
		_currentPage = currentPage;
	}
}

#define kCustomPageControlMaxPages 9

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
	if (numberOfPages == _numberOfPages || numberOfPages <= 1)
	{
		return;
	}
	
	_numberOfPages = numberOfPages > kCustomPageControlMaxPages ? 9 : numberOfPages;
	
	[self removeSubviews];
	
	if (!_indicatorImageViews) 
	{
		[_indicatorImageViews release];
	}

	_indicatorImageViews = [[NSMutableArray alloc] init];
	
	_gap = 5;
	
	CGRect imageFrame = self.frame;
	NSInteger imageHeight = imageFrame.size.height;
	NSInteger imageWidth = imageHeight;
	imageFrame.origin.x = (imageFrame.size.width - _numberOfPages*imageWidth - _gap*(_numberOfPages-1))/2;
	imageFrame.origin.y = 0;
	imageFrame.size.width = imageFrame.size.height;
	for (int i = 0; i < _numberOfPages; ++i)
	{
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
		imageView.image = [UIImage imageNamed:(i == _currentPage ? @"PageChosed.png" : @"PageUnchosed.png")];
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:imageView];
		[imageView release];
		
		[_indicatorImageViews addObject:imageView];
		
		UILabel *index = [[UILabel alloc] initWithFrame:imageFrame];
		index.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight 
		| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		index.textColor = [UIColor blackColor];
		index.font = [UIFont systemFontOfSize:12];
		index.textAlignment = UITextAlignmentCenter;
		index.backgroundColor = [UIColor clearColor];
		index.text = [NSString stringWithFormat:@"%d", i+1];
		[self addSubview:index];
		[index release];
		
		imageFrame.origin.x += imageFrame.size.width+_gap;
	}
}

@end


@interface SuperPageControl(_private)

- (void) updateDots;

@end


@implementation SuperPageControl

@synthesize colorOrImageForStateNormal;
@synthesize colorOrImageForStateHightlighted;

- (void) setColorOrImageForStateNormal:(id)object
{
    if (!object)
    {
        return;
    }
    
	[colorOrImageForStateNormal release];
	colorOrImageForStateNormal = [object retain];
	[self updateDots];
}

- (void) setColorOrImageForStateHightlighted:(id)object
{
    if (!object)
    {
        return;
    }
    
	[colorOrImageForStateHightlighted release];
	colorOrImageForStateHightlighted = [object retain];
	[self updateDots];
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

/*
- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	[self updateDots];
}*/

- (void) updateDots
{
    if (!colorOrImageForStateNormal)
    {
        colorOrImageForStateNormal = [[UIColor grayColor] retain];
    }
    
    if (!colorOrImageForStateHightlighted)
    {
        colorOrImageForStateHightlighted = [[UIColor whiteColor] retain];
    }
    
	if (colorOrImageForStateNormal || colorOrImageForStateHightlighted) 
    {
		NSArray *subView = self.subviews;
		
		for (int i = 0; i < [subView count]; i++) 
        {
			UIImageView *dot = [subView objectAtIndex:i];
            
            id param = self.currentPage == i ? colorOrImageForStateHightlighted : colorOrImageForStateNormal;
            
            if ([param isKindOfClass:[NSString class]])
            {
                dot.image = [UIImage imageWithContentsOfFile:param];
            }
            else if ([param isKindOfClass:[UIColor class]])
            {
                dot.image = nil;
                dot.backgroundColor = param;
                dot.layer.cornerRadius = 3.0f;
            }
		}
	}
}

- (void)dealloc 
{
	[colorOrImageForStateNormal release];
	colorOrImageForStateNormal = nil;
	[colorOrImageForStateHightlighted release];
	colorOrImageForStateHightlighted = nil;
    [super dealloc];
}


@end
