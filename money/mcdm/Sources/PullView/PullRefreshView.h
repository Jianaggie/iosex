

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


//
typedef enum
{
	PullRefreshStatePulling,
	PullRefreshStateNormal,
	PullRefreshStateLoading,	
}
PullRefreshState;


//
@interface PullRefreshView : UIView
{
	PullRefreshState _state;
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	CALayer *arrowImage;
	UIActivityIndicatorView *activityView;
}

@property(nonatomic,assign) PullRefreshState state;

- (void)setCurrentDate;

@end
