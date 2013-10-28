#import "BCTab.h"

@interface BCTab ()
@property (nonatomic, retain) UIImage *rightBorder;
@property (nonatomic, retain) UIImage *background;
@property (nonatomic, retain) NSString *tabTitle;
@end

@implementation BCTab
@synthesize rightBorder, background, tabTitle;

- (id)initWithIconImageName:(NSString *)imageName andHighlightImg:(NSString *)tabHighlightImg andTitle:(NSString *)title {
	if (self = [super init]) {
		self.adjustsImageWhenHighlighted = NO;
		//self.background = [UIImage imageNamed:@"BCTabBarController.bundle/tab-background.png"];
		//self.rightBorder = [UIImage imageNamed:@"BCTabBarController.bundle/tab-right-border.png"];
		self.background = [UIImage imageNamed:tabHighlightImg];
		self.backgroundColor = [UIColor clearColor];
		
        NSString *normal = [NSString stringWithFormat:@"%@.png", imageName];
        NSString *selected = [NSString stringWithFormat:@"%@_selected.png", imageName];
        
		[self setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		self.tabTitle = title;
		
		self.imageView.alpha = 0.5;
	}
	return self;
}

- (void)dealloc {
	self.rightBorder = nil;
	self.background = nil;
	self.tabTitle = nil;
	[super dealloc];
}

- (void)setHighlighted:(BOOL)aBool {
	// no highlight state
}

- (void)drawRect:(CGRect)rect {
	if (self.selected) {
		/*
		[background drawAtPoint:CGPointMake(0, 2)];
		[rightBorder drawAtPoint:CGPointMake(self.bounds.size.width - rightBorder.size.width, 2)];
		CGContextRef c = UIGraphicsGetCurrentContext();
		[RGBCOLOR(24, 24, 24) set]; 
		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
		[RGBCOLOR(14, 14, 14) set];		
		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
		CGContextFillRect(c, CGRectMake(self.bounds.size.width - 0.5, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
		 */
		
		//[background drawAtPoint:CGPointMake(floor((self.bounds.size.width-background.size.width)/2), 2)];
		//[background drawInRect:CGRectMake(6, 2, self.bounds.size.width-12, self.bounds.size.height-4)];
		[background drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
	}
	
	[self.selected ? [UIColor whiteColor] : [UIColor grayColor] set];
	[tabTitle drawInRect:CGRectMake(2, self.bounds.size.height-16, self.bounds.size.width-4, 15)
			 withFont:[UIFont systemFontOfSize:11]
		lineBreakMode:UILineBreakModeWordWrap 
			alignment:UITextAlignmentCenter];
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	/*
	UIEdgeInsets imageInsets = UIEdgeInsetsMake(floor((self.bounds.size.height / 2) -
												(self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
												(self.imageView.image.size.width / 2)),
												floor((self.bounds.size.height / 2) -
												(self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
												(self.imageView.image.size.width / 2)));
	self.imageEdgeInsets = imageInsets;*/
	
	UIEdgeInsets imageInsets = UIEdgeInsetsMake(5, 7, 15, 7);
	self.imageEdgeInsets = imageInsets;
	
	UIEdgeInsets titleInsets = UIEdgeInsetsMake(32, -self.bounds.size.width, 4, 0);
	self.titleEdgeInsets = titleInsets;
}

@end
