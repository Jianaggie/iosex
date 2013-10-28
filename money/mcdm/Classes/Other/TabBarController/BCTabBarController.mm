#import "BCTabBarController.h"
#import "BCTabBar.h"
#import "BCTab.h"
#import "UIViewController+UIViewController_category.h"
#import "BCTabBarView.h"
#import "RootViewController.h"
#import "CustomNavigationController.h"
#import "NewsViewController.h"
#import "AppsViewController.h"
#import "ContactsViewController.h"
#import "FlowDataViewController.h"

#import "MoreView.h"
#import "AboutController.h"
#import "SettingController.h"

#import "DataLoader.h"
#import "WizardView.h"
#import "AppDelegate.h"

#import <CoreLocation/CLLocationManagerDelegate.h>

@interface BCTabBarController ()

- (void)loadTabs;

@property (nonatomic, retain) UIImageView *selectedTab;

@end


@implementation BCTabBarController
@synthesize viewControllers, tabBar, selectedTab, selectedViewController, tabBarView, tabHighlightImg;

- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *controllers = [NSMutableArray array];
        
        // 终端资讯
        {
            NewsViewController *controller = [[NewsViewController alloc] init];
            controller.title = @"终端资讯";
            
            UINavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:[controller autorelease]];
            
            navigation.tabBarItem.title = @"终端资讯";//NSLocalizedString(@"More", nil);
            //navigation.tabBarItem.image = [UIImage imageWithContentsOfFile:NSUtil::BundleSubPath(@"More.png")];

            [controllers addObject:[navigation autorelease]];
        }
        
        // 应用推荐
        {
            AppsViewController *controller = [[AppsViewController alloc] init];
            controller.title = @"应用商店";
            
            UINavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:[controller autorelease]];
            
            navigation.tabBarItem.title = @"应用商店";//NSLocalizedString(@"More", nil);
            //navigation.tabBarItem.image = [UIImage imageWithContentsOfFile:NSUtil::BundleSubPath(@"More.png")];
            
            [controllers addObject:[navigation autorelease]];
        }
        
        // 通讯录
        {
            ContactsViewController *controller = [[ContactsViewController alloc] init];
            controller.title = @"通讯录";
            
            UINavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:[controller autorelease]];
            
            navigation.tabBarItem.title = @"通讯录";//NSLocalizedString(@"More", nil);
            //navigation.tabBarItem.image = [UIImage imageWithContentsOfFile:NSUtil::BundleSubPath(@"More.png")];
            
            [controllers addObject:[navigation autorelease]];
        }
        
        //APNSwitch
        {
            RootViewController* controller = [[RootViewController alloc] init];
            controller.title = @"APN设置";
            
            CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:[controller autorelease]];
            navigation.firstViewController = controller;
            navigation.tabBarItem.title = @"APN设置"; //NSLocalizedString(@"More", nil);
            //navigation.tabBarItem.image = [UIImage imageWithContentsOfFile:NSUtil::BundleSubPath(@"More.png")];
            
            [controllers addObject:[navigation autorelease]];
        }
        
        /*/ 流量监控
        {
            FlowDataViewController *controller = [[FlowDataViewController alloc] init];
            controller.title = @"流量监控";
            
            UINavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:[controller autorelease]];
            
            navigation.tabBarItem.title = @"流量监控";//NSLocalizedString(@"More", nil);
            //navigation.tabBarItem.image = [UIImage imageWithContentsOfFile:NSUtil::BundleSubPath(@"More.png")];
            
            [controllers addObject:[navigation autorelease]];
        }*/
        
        self.viewControllers = controllers;
        self.tabHighlightImg = @"TabSelectedMask.png";
        
        // 定位
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDistanceFilter:5000.0f];
        [_locationManager startUpdatingLocation];
    }
    
    return self;
}

- (void)loadView {
	self.tabBarView = [[[BCTabBarView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	self.view = self.tabBarView;

	self.tabBar = [[[BCTabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49,
															  self.view.bounds.size.width, 49)]
				   autorelease];
	self.tabBar.delegate = self;

	self.tabBarView.backgroundColor = [UIColor clearColor];
	self.tabBarView.tabBar = self.tabBar;
	[self loadTabs];
	
	UIViewController *tmp = selectedViewController;
	selectedViewController = nil;
	[self setSelectedViewController:tmp];
    
    [[DataLoader loader] getNotificationList:nil];
    
    [[DataLoader loader] detectAndPostDeviceInfo:nil];
}

- (void)showMoreView:(BOOL)show
{
    if (show && !_moreView)
    {
        _moreView = [[MoreView alloc] initWithFrame:CGRectMake(0, 0,
                                                             self.view.bounds.size.width, self.view.bounds.size.height-self.tabBar.frame.size.height)];
        
        [self.view addSubview:[_moreView autorelease]];
        
        _moreView.down = YES;
        
        [_moreView addTarget:self action:@selector(onMoreViewTapped)];
        [_moreView.aboutButton addTarget:self action:@selector(onAbout) forControlEvents:UIControlEventTouchUpInside];
        [_moreView.settingButton addTarget:self action:@selector(onSetting) forControlEvents:UIControlEventTouchUpInside];
        [_moreView.apnButton addTarget:self action:@selector(onAPN) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _moreView.hidden = !show;
}

- (void)onMoreViewTapped
{
    NSInteger index = [self.viewControllers indexOfObject:self.selectedViewController];
    [self tabBar:nil didSelectTabAtIndex:index];
}

- (void)onAbout
{
    AboutController *controller = [[AboutController alloc] init];
    controller.title = @"关于";
    
    UINavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:[controller autorelease]];
    
    UIViewController *oldSelected = nil;
    if ([self.viewControllers count] == 4)
    {
        [self.viewControllers addObject:navigation];
    }
    else
    {
        oldSelected = [self.selectedViewController retain];
        [self.viewControllers replaceObjectAtIndex:4 withObject:navigation];
        //self.selectedViewController = nil;
    }
    
    [navigation release];
    
    [self tabBar:self.tabBar didSelectTabAtIndex:4];
    
    [oldSelected release];
}

- (void)onAPN
{
    // ForAPN: 这里要自定义APN的controller，可以修改controller的名称.
    RootViewController* controller = [[RootViewController alloc] init];
    controller.title = @"易APN";
    
    CustomNavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:[controller autorelease]];
    navigation.firstViewController = controller;
    
    UIViewController *oldSelected = nil;
    if ([self.viewControllers count] == 4)
    {
        [self.viewControllers addObject:navigation];
    }
    else
    {
        oldSelected = [self.selectedViewController retain];
        [self.viewControllers replaceObjectAtIndex:4 withObject:navigation];
        //self.selectedViewController = nil;
    }
    
    [navigation release];
    
    [self tabBar:self.tabBar didSelectTabAtIndex:4];
    
    [oldSelected release];
}

- (void)onSetting
{
    SettingController *controller = [[SettingController alloc] init];
    controller.title = @"设置";
    
    UINavigationController *navigation = [[CustomNavigationController alloc] initWithRootViewController:[controller autorelease]];
    
    UIViewController *oldSelected = nil;
    if ([self.viewControllers count] == 4)
    {
        [self.viewControllers addObject:navigation];
    }
    else
    {
        oldSelected = [self.selectedViewController retain];
        [self.viewControllers replaceObjectAtIndex:4 withObject:navigation];
        //self.selectedViewController = nil;
    }
    
    [navigation release];
    
    [self tabBar:self.tabBar didSelectTabAtIndex:4];
    
    [oldSelected release];
}

- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index
{
    if ([self.viewControllers count] == 4 && index == 4)
    {
        [self showMoreView:YES];
        return;
    }
    else if (index == 4)
    {
        if (self.selectedIndex == 4)
        {
            [self showMoreView:_moreView.hidden];
        }
        else
        {
            [self showMoreView:NO];
        }
        
        UIViewController *vc = [self.viewControllers objectAtIndex:index];
        if (self.selectedViewController == vc) {
            if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
            }
        } else {
            self.selectedViewController = vc;
        }
        
        [self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:YES];
        
        return;
    }
    
    if ([self.viewControllers count] > index)
    {
        [self showMoreView:NO];
        
        UIViewController *vc = [self.viewControllers objectAtIndex:index];
        if (self.selectedViewController == vc) {
            if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
            }
        } else {
            self.selectedViewController = vc;
        }
        
        [self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:YES];
    }
    else
    {
        // TODO:
        
        [self showMoreView:YES];
        
        [self.tabBar setSelectedTab:[self.tabBar.tabs lastObject] animated:YES];
    }
}

- (void)setSelectedViewController:(UIViewController *)vc {
	UIViewController *oldVC = selectedViewController;
	if (selectedViewController != vc) {
		[selectedViewController release];
		selectedViewController = [vc retain];
		if (visible) {
			[oldVC viewWillDisappear:NO];
			[selectedViewController viewWillAppear:NO];
		}
		
        self.tabBarView.contentView = vc.view;
		if (visible) {
			[oldVC viewDidDisappear:NO];
			[selectedViewController viewDidAppear:NO];
		}
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.selectedViewController viewDidAppear:animated];
	visible = YES;
    
    BOOL done = [NSUtil::SettingForKey(kWizardDone) boolValue];
	if (!done)
	{
		CGRect frame = ((AppDelegate *)UIUtil::Delegate()).window.frame;
		frame.origin.x = 0;
		frame.origin.y = 0;//20;
		frame.size.height -= frame.origin.y;
		WizardView *wizard = [[[WizardView alloc] initWithFrame:frame] autorelease];
		wizard.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[((AppDelegate *)UIUtil::Delegate()).window addSubview:wizard];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.selectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.selectedViewController viewDidDisappear:animated];
	visible = NO;
}



- (NSUInteger)selectedIndex {
	return [self.viewControllers indexOfObject:self.selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	if (self.viewControllers.count > aSelectedIndex)
		self.selectedViewController = [self.viewControllers objectAtIndex:aSelectedIndex];
}

- (void)loadTabs 
{
	if (!self.viewControllers || !self.viewControllers.count) 
	{
		return;
	}
	
	NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
	for (UIViewController *vc in self.viewControllers) {
		[tabs addObject:[[[BCTab alloc] initWithIconImageName:[vc iconImageName] andHighlightImg:tabHighlightImg andTitle:vc.title] autorelease]];
	}
    
    // 更多
    [tabs addObject:[[[BCTab alloc] initWithIconImageName:@"More" andHighlightImg:tabHighlightImg andTitle:@"更多"] autorelease]];
    
	self.tabBar.tabs = tabs;
	[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:NO];
}

- (void)viewDidUnload
{
    NSLog(@"tabbar -- viewDidUnload");
    
	self.tabBar = nil;
	self.selectedTab = nil;
	self.tabHighlightImg = nil;
}

- (void)didReceiveMemoryWarning
{
    for (UIViewController *controller in self.viewControllers)
    {
        if (controller != self.selectedViewController)
        {
            [controller didReceiveMemoryWarning];
        }
    }
    
	[super didReceiveMemoryWarning];
}

- (void)setViewControllers:(NSArray *)array {
	if (array != viewControllers) {
		[viewControllers release];
		viewControllers = [array retain];
		
		if (viewControllers != nil) {
			[self loadTabs];
		}
	}
	
	self.selectedIndex = 0;
}

- (void)dealloc {
	self.viewControllers = nil;
	self.tabBar = nil;
	self.selectedTab = nil;
	self.tabBarView = nil;
	self.tabHighlightImg = nil;
    
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingHeading];
    [_locationManager release];
    
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
	self.tabBarView.hiddenTabbar = hidden;
    if (!self.tabBarView)
    {
        BCTabBarView *view = (BCTabBarView *)self.view;
        view.hiddenTabbar = hidden;
    }
    //NSLog(@"setTabBarHidden:%d", hidden);
}

// CLLocationManagerDelegate<NSObject>

/*
 *  locationManager:didUpdateToLocation:fromLocation:
 *
 *  Discussion:
 *    Invoked when a new location is available. oldLocation may be nil if there is no previous location
 *    available.
 */
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //
    _Log(@"locationManager, didUpdateToLocation");
    [[DataLoader loader] detectAndPostDeviceInfo:nil];
}

@end
