#import "BCTabBarView.h"
#import "BCTabBar.h"

@implementation BCTabBarView
@synthesize tabBar, contentView, hiddenTabbar;

- (void)setTabBar:(BCTabBar *)aTabBar {
	[tabBar removeFromSuperview];
	[tabBar release];
	tabBar = aTabBar;
	[self addSubview:tabBar];
}

- (void)setContentView:(UIView *)aContentView {
	[contentView removeFromSuperview];
	contentView = aContentView;
	contentView.frame = CGRectMake(0, 0, self.bounds.size.width, 
										self.bounds.size.height - self.tabBar.bounds.size.height);

	[self addSubview:contentView];
	[self sendSubviewToBack:contentView];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = contentView.frame;
	f.size.height = self.bounds.size.height;
	//f.size.height = self.hiddenTabbar ? self.bounds.size.height : (self.bounds.size.height - self.tabBar.bounds.size.height);
	contentView.frame = f;
	[contentView layoutSubviews];
}

- (void)drawRect:(CGRect)rect 
{
	return;
	
	CGContextRef c = UIGraphicsGetCurrentContext();
	[[UIColor colorWithRed:(230)/255.0 green:(230)/255.0 blue:(230)/255.0 alpha:1] set];
	CGContextFillRect(c, self.bounds);
}

- (void)setHiddenTabbar:(BOOL)hidden
{
    hiddenTabbar = hidden;
    //self.tabBar.hidden = hidden;
    
    if (hidden)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        //[UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
        
        self.tabBar.alpha = 0.f;
        
        [UIView commitAnimations];
    }
    else
	{
		self.tabBar.alpha = 1.f;
	}

    [self setNeedsLayout];
}

@end
