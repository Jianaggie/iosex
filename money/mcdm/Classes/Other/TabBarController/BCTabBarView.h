@class BCTabBar;

@interface BCTabBarView : UIView {
	UIView *contentView;
	BCTabBar *tabBar;
	
	BOOL hiddenTabbar;
}

@property (nonatomic, assign) UIView *contentView;
@property (nonatomic, assign) BCTabBar *tabBar;
@property (nonatomic, assign) BOOL hiddenTabbar;


@end
