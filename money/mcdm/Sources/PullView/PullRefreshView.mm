
#import "NSUtil.h"
#import "PullRefreshView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation PullRefreshView
@synthesize state=_state;

//
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		lastUpdatedLabel.textColor = TEXT_COLOR;
		//lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		//lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:lastUpdatedLabel];
		[lastUpdatedLabel release];
		
		NSString *lastUpdate = NSUtil::SettingForKey(@"PullRefreshView_LastRefresh");
		if (lastUpdate)
		{
			lastUpdatedLabel.text = lastUpdate;
		}
		else
		{
			[self setCurrentDate];
		}
		
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		statusLabel.textColor = TEXT_COLOR;
		//statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		//statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:statusLabel];
		[statusLabel release];

		arrowImage = [[CALayer alloc] init];
		arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		arrowImage.contentsGravity = kCAGravityResizeAspect;
		arrowImage.contents = (id)[UIImage imageNamed:@"PullDownArrow.png"].CGImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
		{
			arrowImage.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[[self layer] addSublayer:arrowImage];
		[arrowImage release];

		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
		[activityView release];
		
		[self setState:PullRefreshStateNormal];		
    }
    return self;
}

//
- (void)dealloc
{
	activityView = nil;
	statusLabel = nil;
	arrowImage = nil;
	lastUpdatedLabel = nil;
    [super dealloc];
}

//
/*- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawPath(context,  kCGPathFillStroke);
	[BORDER_COLOR setStroke];
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0.0f, self.bounds.size.height - 1);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - 1);
	CGContextStrokePath(context);
}*/

//
- (void)setCurrentDate
{
	lastUpdatedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last update: %@", nil), NSUtil::FormatDate()];
	NSUtil::SaveSettingForKey(@"PullRefreshView_LastRefresh", lastUpdatedLabel.text);
}

//
- (void)setState:(PullRefreshState)aState
{
	switch (aState)
	{
		case PullRefreshStatePulling:
		{
			statusLabel.text = NSLocalizedString(@"Release to update...", nil);
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
		}
			
		case PullRefreshStateNormal:			
		{
			if (_state == PullRefreshStatePulling)
			{
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			statusLabel.text = NSLocalizedString(@"Pull down to update...", nil);
			[activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = NO;
			arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			break;
		}
			
		case PullRefreshStateLoading:
		{
			statusLabel.text = NSLocalizedString(@"Updating...", nil);
			[activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			arrowImage.hidden = YES;
			[CATransaction commit];
			break;
		}
	}
	
	_state = aState;
}

@end
