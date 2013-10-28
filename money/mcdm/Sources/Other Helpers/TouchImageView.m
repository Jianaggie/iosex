

#import "TouchImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TouchImageView
@synthesize down=_down;

#pragma mark Generic methods

// Constructor
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    
    if (self)
    {
        overlay = [[UIImageView alloc] initWithFrame:frame];
        overlay.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:[overlay autorelease]];
        overlay.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3f];
        overlay.hidden = YES;
        
        [self bringSubviewToFront:overlay];
    }

	return self;
}

// Destructor
//- (void)dealloc
//{
//   [super dealloc];
//}

//
- (void)addTarget:(id)target action:(SEL)action
{
	_target = target;
	_action = action;
	self.userInteractionEnabled = YES;
}

- (void)setClickOverlayMask:(UIImage *)mask
{
    if (!mask)
    {
        //self.down = YES;
        return;
    }
    
    overlay.image = mask;
    overlay.backgroundColor = [UIColor clearColor];
    self.down = NO;
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
	[super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    overlay.frame = frame;
}

// Set view frame.
//- (void)setFrame:(CGRect)frame
//{
//	[super setFrame:frame];
//}

//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_target)
	{
		if (_down)
		{
			[_target performSelector:_action withObject:self];
		}
		else
		{
			//self.alpha = 0.75;
            [self bringSubviewToFront:overlay];
            overlay.hidden = NO;
		}
	}
	else
	{
		[super touchesBegan:touches withEvent:event];
	}
}

//
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    BOOL inside = NO;
    if ((touchPoint.x <= self.frame.size.width && touchPoint.x >= 0) && (touchPoint.y <= self.frame.size.height && touchPoint.y >= 0))
    {
        inside = YES;
    }
    
    //self.alpha = 1;
    overlay.hidden = YES;
    
	if (_target && !_down && inside)
	{
		[_target performSelector:_action withObject:self];
	}
	else
	{
		[super touchesEnded:touches withEvent:event];
	}
}

//
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_target)
	{
		//self.alpha = 1;
        overlay.hidden = YES;
	}
	[super touchesCancelled:touches withEvent:event];
}


#pragma mark Event methods

@end

@implementation MultiLayerTouchImageView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (UIImageView *)background
{
    if (!background)
    {
        CGRect frame = self.frame;
        //frame.origin.x = frame.origin.y = 0;
        background = [[UIImageView alloc] initWithFrame:frame];
        background.contentMode = UIViewContentModeScaleAspectFill;
        background.clipsToBounds = YES;
        
        if (self.superview)
        {
            [self.superview addSubview:background];
            [self.superview sendSubviewToBack:background];
            backgroundBeAdded = YES;
        }
    }
    return background;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    //[self sendSubviewToBack:background];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    [maskLayer setHidden:hidden];
    [shadowLayer setHidden:hidden];
    [background setHidden:hidden];
}

- (UIImageView *)maskLayer
{
    if (!maskLayer)
    {
        CGRect frame = self.frame;
        frame.origin.x = frame.origin.y = 0;
        maskLayer = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        maskLayer.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:maskLayer];
        
        [self bringSubviewToFront:maskLayer];
    }
    
    return maskLayer;
}

- (UIView *)shadowLayer
{
    if (!shadowLayer)
    {
        CGRect frame = self.frame;
        shadowLayer = [[UIImageView alloc] initWithFrame:frame];
    }
    
    if (self.superview)
    {
        [self.superview addSubview:shadowLayer];
        [self.superview sendSubviewToBack:shadowLayer];
        shadowBeAdded = YES;
    }
    
    return shadowLayer;
}

//
- (void)didMoveToSuperview
{
    //[self sendSubviewToBack:background];
    
	if (self.superview)
	{
        if (background)
        {
            if (!backgroundBeAdded)
            {
                [self.superview addSubview:background];
                backgroundBeAdded = YES;
            }
            
            [self.superview sendSubviewToBack:background];
        }
        
        if (shadowLayer)
        {
            if (!shadowBeAdded)
            {
                [self.superview addSubview:shadowLayer];
                shadowBeAdded = YES;
            }
            
            [self.superview sendSubviewToBack:shadowLayer];
        }
	}
    
    [self bringSubviewToFront:maskLayer];
}

- (void)dealloc
{
    [background release];
    [shadowLayer release];
    [super dealloc];
}

- (void)reset
{
    CGRect frame = self.frame;
    
    background.frame = frame;
    
    if (shadowLayer)
    {
        shadowLayer.frame = frame;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:shadowLayer.bounds cornerRadius:shadowLayer.layer.cornerRadius];
        shadowLayer.layer.shadowPath = path.CGPath;
        shadowLayer.layer.shouldRasterize = YES;
    }
    
    frame.origin.x = frame.origin.y = 0;
    maskLayer.frame = frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self reset];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    
    background.center = self.center;
    shadowLayer.center = self.center;
}

@end
