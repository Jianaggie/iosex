
#import "DelayImageView.h"
#import "NSUtil.h"

//
@implementation DelayImageView
@synthesize url=_url;
@synthesize indexPath = _indexPath;

- (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* strPath = [paths objectAtIndex:0];
    
    NSString *path = [NSString stringWithFormat:@"%@/ImageCache/", strPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *realCacheFile = [NSString stringWithFormat:@"%@%@", path, NSUtil::CalculateMD5(_url)];
    
    return realCacheFile;
}

//
- (void)stopAnimating
{
	[_activityView stopAnimating];
	[_activityView removeFromSuperview];
	[_activityView release];
	_activityView = nil;
}

//
- (void)startAnimating
{
	[self stopAnimating];
    
	_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_activityView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	_activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	[self addSubview:_activityView];
	[_activityView startAnimating];
}

//
- (void)downloading
{
    NSString *path = [self cachePath];
    if (NSUtil::IsFileExist(path))
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        [self performSelectorOnMainThread:@selector(downloaded:) withObject:data waitUntilDone:YES];
    }
    else
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSError *error = nil;
        NSString *url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL:URL options:0 error:&error];
        if (!error)
        {
            [data writeToFile:path atomically:YES];
            self.image = [UIImage imageWithData:data];
        }
        else
        {
            _Log(@"DelayImageView download image failed!!, %@, %@", _url, [error localizedDescription]);
            self.backgroundColor = [UIColor lightGrayColor];
        }
        
        [self performSelectorOnMainThread:@selector(downloaded:) withObject:data waitUntilDone:YES];
        [pool drain];
    }
}

//
- (void)downloaded:(NSData *)data
{
	self.image = [UIImage imageWithData:data];
	if (self.image || _force)
	{
		[self stopAnimating];
	}
	else
	{
		_force = YES;
		[self performSelectorInBackground:@selector(downloading) withObject:nil];
	}
}

//
- (void)setUrl:(NSString *)url
{
	[_url release];
    
	_force = NO;
	self.image = nil;
	if (url)
	{
		_url = [url retain];
		
		NSString *path = [self cachePath];
		if (NSUtil::IsFileExist(path))
		{
			self.image = [UIImage imageWithContentsOfFile:path];
			return;
		}
		
		[self startAnimating];
		[self performSelectorInBackground:@selector(downloading) withObject:nil];
	}
	else
	{
		_url = nil;
	}
}

//
/*- (void)setImage:(UIImage *)image
 {
 [super setImage:image];
 if (image)
 {
 CGFloat alpha = self.alpha;
 self.alpha = 0;
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDuration:0.5];
 self.alpha = alpha;
 [UIView commitAnimations];
 }
 }*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _overlay = [[UIImageView alloc] initWithFrame:frame];
        _overlay.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:[_overlay autorelease]];
        _overlay.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3f];
        _overlay.hidden = YES;
        
        [self bringSubviewToFront:_overlay];
        
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
	
	return self;
}

//
- (id)initWithUrl:(NSString *)url frame:(CGRect)frame
{
	self = [self initWithFrame:frame];
    if (self)
    {
        self.url = url;
    }
	
	return self;
}

//
- (void)dealloc
{
	[_url release];
    // [_indexPath release];
	[super dealloc];
}

// Layout subviews.
- (void)layoutSubviews
{
	[super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _overlay.frame = frame;
}

//
- (void)addTarget:(id)target action:(SEL)action
{
	_target = target;
	_action = action;
	self.userInteractionEnabled = YES;
}

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
            [self bringSubviewToFront:_overlay];
            _overlay.hidden = NO;
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
    _overlay.hidden = YES;
    
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
        _overlay.hidden = YES;
	}
	[super touchesCancelled:touches withEvent:event];
}

@end
