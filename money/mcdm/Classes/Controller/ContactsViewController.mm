//
//  ContactsViewController.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "ContactsViewController.h"
#import "PersonalContactsController.h"
#import "Contacts/CompanyContactsController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *controllers = [NSMutableArray array];
        
        // 个人通讯录
        {
            PersonalContactsController *controller = [[PersonalContactsController alloc] init];
            [controllers addObject:controller];
            [controller release];
        }
        
        // 企业通讯录
        {
            CompanyContactsViewController *controller = [[CompanyContactsViewController alloc] init];
            [controllers addObject:controller];
            [controller release];
        }
        
        _controllers = [controllers retain];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // 顶部分类条
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SegmentBackground.png"]];
    {
        UIImage *normal = [UIImage imageNamed:@"Left.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:normal forState:UIControlStateSelected];
        //[button setBackgroundImage:normal forState:UIControlStateHighlighted];
        [button setTitle:@"个人通迅录" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, normal.size.width, normal.size.height);
        
        [imageView addSubview:button];
        
        _leftButton = button;
        
        _leftButton.selected = YES;
        //_leftButton.enabled = NO;
    }
    {
        UIImage *normal = [UIImage imageNamed:@"Right.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:normal forState:UIControlStateSelected];
        //[button setBackgroundImage:normal forState:UIControlStateHighlighted];
        [button setTitle:@"企业通迅录" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(normal.size.width, 0, normal.size.width, normal.size.height);
        
        [imageView addSubview:button];
        _rightButton = button;
    }
    imageView.userInteractionEnabled = YES;
    self.navigationItem.titleView = [imageView autorelease];
    
    _contentViewForController = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	_contentViewForController.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentViewForController.backgroundColor = [UIColor clearColor];
	[self.view addSubview:_contentViewForController];
    [_contentViewForController release];
    
    [self.view sendSubviewToBack:_contentViewForController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[_controllers objectAtIndex:1] setNavigationController:self];
    [self onSelectionChanged:0];
}

- (void)onButtonTapped:(UIButton *)button
{
    if ((_leftButton == button && _leftButton.selected) || (_rightButton == button && _rightButton.selected))
    {
        return;
    }
    
    if (_leftButton == button)
    {
        _leftButton.selected = YES;
        //_leftButton.enabled = NO;
        
        _rightButton.selected = NO;
        //_rightButton.enabled = YES;
        
        [self onSelectionChanged:0];
    }
    else
    {
        _leftButton.selected = NO;
        //_leftButton.enabled = YES;
        
        _rightButton.selected = YES;
        //_rightButton.enabled = NO;
        
        [self onSelectionChanged:1];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)iconImageName
{
	return @"Contacts";
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
    finalFrame.size.height = self.view.frame.size.height;
    
    _activeViewController.view.frame = finalFrame;
    //_activeViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_contentViewForController addSubview:_activeViewController.view];
    [_activeViewController viewDidAppear:NO];
    
    //self.title = _activeViewController.title;
}

@end
