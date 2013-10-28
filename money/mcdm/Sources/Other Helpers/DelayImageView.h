
#import <UIKit/UIKit.h>


//
@interface DelayImageView: UIImageView
{
	BOOL _force;
	NSString *_url;
	UIActivityIndicatorView *_activityView;
    
    BOOL _down;
	id _target;
	SEL _action;
    
    UIImageView *_overlay;
}

- (id)initWithUrl:(NSString *)url frame:(CGRect)frame;
- (void)addTarget:(id)target action:(SEL)action;

@property(nonatomic, retain)NSIndexPath *indexPath;
@property (nonatomic, retain) NSString *url;
@end
