//
//  AboutController.m
//  MCDM
//
//  Created by Fred on 12-12-29.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@end

@implementation AboutController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    CGRect frame = self.view.frame;
    
    if (!self.hidesBottomBarWhenPushed)
    {
        frame.size.height -= TAB_BAR_HEIGHT;
    }
    UIImageView* imgVLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone4.jpg"]];
    imgVLogo.center = CGPointMake(frame.size.width / 2, frame.size.height / 2); //300
    [self.view addSubview:imgVLogo];
    [self.view sendSubviewToBack:imgVLogo];
    [imgVLogo release];
    imgVLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon@2x.png"]];
    imgVLogo.center = CGPointMake(frame.size.width / 2, 110);
    [self.view addSubview:imgVLogo];
    [imgVLogo release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:16.f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"移动终端管家 2.0";
    [label sizeToFit];
    label.center = CGPointMake(frame.size.width / 2, 210);
    [self.view addSubview:label];
    [label release];
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"中国联通广东省分公司";
    [label sizeToFit];
    label.center = CGPointMake(frame.size.width / 2, 270);

#ifndef NO_LOGO
    [self.view addSubview:label];
#endif
    
    [label release];
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"广州携智信息科技有限公司";
    [label sizeToFit];
    label.center = CGPointMake(frame.size.width / 2, 300);
    //[self.view addSubview:label];
    [label release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"关于";
    
    //self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:32.f/255 green:40.f/255 blue:70.f/255 alpha:1];//[@"#202a4a" toUIColor];
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

@end
