//
//  BaseController.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "BaseController.h"
#import "MessageView.h"
#import "NotificationListController.h"

@interface BaseController ()

@end

@implementation BaseController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    MessageView *messageView = [MessageView messageView];
    [messageView.button addTarget:self action:@selector(onMessage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:messageView];
    self.navigationItem.rightBarButtonItem = [barItem autorelease];
}

- (void)onMessage
{
    NotificationListController *controller = [[NotificationListController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
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

- (void)onRefresh
{
    
}

@end
