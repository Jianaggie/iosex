
#import "PullView.h"

#define kDefaultColor [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]

@implementation PullView
@synthesize state=_state;
@synthesize delegate=_delegate;

//@synthesize arrowImage=_arrowImage;
@synthesize stampLabel=_stampLabel;
//@synthesize stateLabel=_stateLabel;
//@synthesize activityView=_activityView;

//
- (id)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor shadowMode:(int)shadowMode shadowColor:(UIColor *)shadowColor
{
	[super initWithFrame:frame];

	CGFloat height = frame.size.height;
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	//
	_stampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 30, self.frame.size.width, 20)];
	_stampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_stampLabel.font = [UIFont systemFontOfSize:12];
	_stampLabel.backgroundColor = [UIColor clearColor];
	_stampLabel.textAlignment = UITextAlignmentCenter;
    _stampLabel.textColor = textColor ? textColor : kDefaultColor;
	[self addSubview:_stampLabel];
	[_stampLabel release];
	
	//
	_stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 48, self.frame.size.width, 20)];
	_stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_stateLabel.font = [UIFont boldSystemFontOfSize:13];
	_stateLabel.textColor = textColor ? textColor : kDefaultColor;
    
	_stateLabel.backgroundColor = [UIColor clearColor];
	_stateLabel.textAlignment = UITextAlignmentCenter;
	[self addSubview:_stateLabel];
	[_stateLabel release];
    
    if (shadowMode)
    {
        _stampLabel.shadowColor = shadowColor;
        _stampLabel.shadowOffset = CGSizeMake(0.0f, shadowMode == 1 ? -1.f : 1.f);
        
        _stateLabel.shadowColor = shadowColor;
        _stateLabel.shadowOffset = CGSizeMake(0.0f, shadowMode == 1 ? -1.f : 1.f);
    }
    else
    {
        _stampLabel.shadowColor = [UIColor clearColor];
        _stateLabel.shadowColor = [UIColor clearColor];
    }
	
	//
	_arrowImage = [CALayer layer];
	_arrowImage.frame = CGRectMake(25, height - 65, 30, 55);
	_arrowImage.contentsGravity = kCAGravityResizeAspect;
	_arrowImage.contents = (id)[UIImage imageNamed:@"PullArrow.png"].CGImage;
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
	{
		_arrowImage.contentsScale = [[UIScreen mainScreen] scale];
	}
	[[self layer] addSublayer:_arrowImage];
	
	//
	_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_activityView.frame = CGRectMake(25, height - 40, 20, 20);
	[self addSubview:_activityView];
	[_activityView release];
	
	//self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
	self.state = PullViewStateNormal;
	
    return self;
}


//
- (void)setDelegate:(id <PullViewDelegate>)delegate
{
	_delegate = delegate;
	self.state = PullViewStateNormal;
}

//
- (void)updateStampLabel:(PullViewState)state
{
}

//
- (void)setState:(PullViewState)state
{
	NSString *statusText = [(id)_delegate respondsToSelector:@selector(pullView: textForState:)] ? [_delegate pullView:self textForState:state] : nil;
	
	switch (state)
	{
		case PullViewStateError:
		case PullViewStateNormal:
			if (_state == PullViewStatePulling)
			{
				[CATransaction begin];
				[CATransaction setAnimationDuration:0.2f];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}

			_stampLabel.text = [(id)_delegate respondsToSelector:@selector(pullView: textForStamp:)] ? [_delegate pullView:self textForStamp:state] : nil;
			_stampLabel.textColor = (state == PullViewStateError) ? [UIColor redColor] : _stampLabel.textColor;

			if (_state != PullViewStateError)
			{
				_stateLabel.text = statusText ? statusText : @"下拉可以更新…";
				[_activityView stopAnimating];

				[CATransaction begin];
				[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
				_arrowImage.hidden = NO;
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			break;
			
		case PullViewStatePulling:
			_stateLabel.text = statusText ? statusText : @"松开立即更新…";
			[CATransaction begin];
			[CATransaction setAnimationDuration:0.2f];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180, 0, 0, 1);
			[CATransaction commit];
			break;
			
		case PullViewStateLoading:
			_stateLabel.text = statusText ? statusText : @"加载中…";
			[_activityView startAnimating];
			
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			break;
			
		default:
			break;
	}
	_state = state;
}

//
- (void)didScroll
{
	if (_ignore)
	{
		return;
	}
	_ignore = YES;
	
	UIScrollView *scrollView = (UIScrollView *)self.superview;
	if (_state == PullViewStateLoading)
	{
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
	}
	else if (scrollView.isDragging)
	{
		if (_state == PullViewStatePulling)
		{
			if ((scrollView.contentOffset.y > -65) && (scrollView.contentOffset.y < 0))
			{
				self.state = PullViewStateNormal;
			}
		}
		else
		{
			if (_state == PullViewStateError)
			{
				self.state = PullViewStateNormal;
			}
			if (scrollView.contentOffset.y < -65)
			{
				self.state = PullViewStatePulling;
			}
		}
		
		if (scrollView.contentInset.top != 0)
		{
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
	
	_ignore = NO;
}

//
- (BOOL)endDragging
{
	UIScrollView *scrollView = (UIScrollView *)self.superview;
	return (scrollView.contentOffset.y <= -65) && (_state != PullViewStateLoading);
}

//
- (void)beginLoading
{
	UIScrollView *scrollView = (UIScrollView *)self.superview;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];

	_ignore = YES;
	scrollView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
	scrollView.contentOffset = CGPointMake(0, -60);
	_ignore = NO;

	[UIView commitAnimations];
	
	self.state = PullViewStateLoading;
}

//
- (void)fold
{
	UIScrollView *scrollView = (UIScrollView *)self.superview;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];

	_ignore = YES;
	scrollView.contentInset = UIEdgeInsetsZero;
	_ignore = NO;

	[UIView commitAnimations];
}

//
- (void)finishLoading
{
	[self fold];
	self.state = PullViewStateNormal;
}

//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self fold];
	[super touchesBegan:touches withEvent:event];
}

@end
