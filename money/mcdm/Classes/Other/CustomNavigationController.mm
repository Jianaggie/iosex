//
//  CustomNavigationController.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "CustomNavigationController.h"
#import "BCTabBarController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface UINavigationBar (_)

@end

@implementation UINavigationBar (_)

- (void)didMoveToSuperview
{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:[UIImage imageNamed:@"Navibar.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    BCTabBarController *controller = (BCTabBarController *)UIUtil::Delegate().window.rootViewController;
    int selectIndex = controller.selectedIndex;
    if (selectIndex != 1)
    {
        self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.f].CGColor;
        self.layer.shadowOpacity = 0.9f;
        self.layer.shadowOffset = CGSizeMake(0, 0.4);
        CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, self.layer.bounds.size.height - 6, self.layer.bounds.size.width + 20, 5);
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
        self.layer.shouldRasterize = YES;
    }
    else
    {
        self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.f].CGColor;
    }
}

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"Navibar.png"] drawInRect:rect];
}

@end

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController
@synthesize firstViewController;

/*
- (void)setTitle:(NSString *)title
{
	UITabBarItem *barItem = [self.tabBarItem retain];
	self.tabBarItem = nil;
	[super setTitle:title];
	self.tabBarItem = barItem;
	[barItem release];
}*/

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	[super initWithRootViewController:rootViewController];
	if (self)
	{
		self.delegate = self;
	}
	
	return self;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
	//[UIUtil::Delegate().controller.rootController2 setTabBarHidden:NO animated:NO];
	return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	//_containerView.frame = [[UIScreen mainScreen] applicationFrame];
	//[UIUtil::Delegate().controller.rootController2 setTabBarHidden:YES animated:NO];
	
	if (self.viewControllers && [self.viewControllers count])
	{
		UIImage *backImg = [UIImage imageNamed:@"BackIcon.png"];
		if (backImg) //&& (YES != viewController.navigationItem.hidesBackButton)
		{
			UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backImg.size.width, backImg.size.height)];
			[backButton setImage:backImg forState:UIControlStateNormal];
			[backButton addTarget:viewController action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
            
            viewController.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[backButton autorelease]] autorelease];
		}
	}
	[super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!viewController.hidesBottomBarWhenPushed)
    {        
        [(BCTabBarController *)(UIUtil::Delegate().window.rootViewController) setTabBarHidden:NO animated:YES];
    }
    else
    {
        [(BCTabBarController *)(UIUtil::Delegate().window.rootViewController) setTabBarHidden:YES animated:YES];
    }
}

@end
