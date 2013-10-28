
#import "BCTabBar.h"

@class BCTabBarView;
@class MoreView;

@class CLLocationManager;
@protocol CLLocationManagerDelegate;

@interface BCTabBarController : UIViewController <BCTabBarDelegate, CLLocationManagerDelegate> {
	NSMutableArray *viewControllers;
	UIViewController *selectedViewController;
	BCTabBar *tabBar;
	BCTabBarView *tabBarView;
	BOOL visible;
	
	NSString *tabHighlightImg;
    
    MoreView *_moreView;
    
    CLLocationManager *_locationManager;
}

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) BCTabBar *tabBar;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) BCTabBarView *tabBarView;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, retain) NSString *tabHighlightImg;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
