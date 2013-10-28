//
//  AppsViewController.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "AppsViewController.h"
#import "TopTabbar.h"
#import "AppListController.h"
#import "AppCatalogController.h"

@interface AppsViewController ()

@end

@implementation AppsViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *controllers = [NSMutableArray array];
        
        // 全部
        {
            AppListController *controller = [[AppListController alloc] init];
            controller.title = @"全部";
            [controllers addObject:controller];
            [controller release];
        }
        
        // 推荐
        {
            AppCatalogController *controller = [[AppCatalogController alloc] initWithMainKey:@"carrier"];
            controller.title = @"推荐";
            [controllers addObject:controller];
            [controller release];
        }
        
        // 公司
        {
            AppCatalogController *controller = [[AppCatalogController alloc] initWithMainKey:@"company"];
            controller.title = @"企业";
            [controllers addObject:controller];
            [controller release];
        }
        
        _controllers = [controllers retain];
    }
    return self;
}

- (void)dealloc
{
    [_controllers release];
    [super dealloc];
}

- (NSString *)iconImageName
{
	return @"Apps";
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // top bar
    CGRect topTabbarFrame = CGRectMake(0, 0, self.view.frame.size.width, kTopTabbarHeight);
    TopTabbar *topTabbar = [[TopTabbar alloc] initWithFrame:topTabbarFrame];
    [self.view addSubview:topTabbar];
    topTabbar.delegate = self;
    [topTabbar release];
    
    NSMutableArray *titles = [NSMutableArray array];
    for (UIViewController *controller in _controllers)
    {
        [titles addObject:controller.title];
    }
    
    [topTabbar setTitles:titles];
    
    _contentViewForController = [[UIView alloc] initWithFrame:CGRectMake(0, kTopTabbarHeight, self.view.frame.size.width, self.view.frame.size.height)];
	_contentViewForController.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;// | UIViewAutoresizingFlexibleTopMargin;
    _contentViewForController.backgroundColor = [UIColor clearColor];
	[self.view addSubview:_contentViewForController];
    [_contentViewForController release];
    
    [self.view sendSubviewToBack:_contentViewForController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self onSelectionChanged:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    for (UIViewController * viewController in _controllers)
    {
        [viewController didReceiveMemoryWarning];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_activeViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_activeViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_activeViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_activeViewController viewDidDisappear:animated];
}

// TopTabbarDelegate
- (void)onSelectionChanged:(NSInteger)index
{
    if (![_controllers count])
    {
        return;
    }
    
    if (_activeViewController)
    {
        [_activeViewController viewWillDisappear:NO];
        [_activeViewController.view removeFromSuperview];
        [_activeViewController viewDidDisappear:NO];
    }
	
    _activeViewController = [_controllers objectAtIndex:index];
	
    [_activeViewController viewWillAppear:NO];
	
    CGRect finalFrame = _activeViewController.view.frame;
    finalFrame.origin.y = 0;
    finalFrame.size.height = self.view.frame.size.height-kTopTabbarHeight;
    
    _activeViewController.view.frame = finalFrame;
    //_activeViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_contentViewForController addSubview:_activeViewController.view];
    [_activeViewController viewDidAppear:NO];
    
    //self.title = _activeViewController.title;
}

@end
