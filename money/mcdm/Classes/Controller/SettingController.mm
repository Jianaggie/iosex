//
//  SettingController.m
//  MCDM
//
//  Created by Fred on 12-12-29.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "SettingController.h"
#import "WizardView.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "FlowDataViewController.h"
#import "CustomNavigationController.h"
#import "DataLoader.h"
#import "MBProgressHUD.h"
@interface SettingController ()

@end

@implementation SettingController

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
    
    self.view.backgroundColor = [UIColor clearColor];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    if (!self.hidesBottomBarWhenPushed)
    {
        frame.size.height -= 49;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	tableView.rowHeight = 40;
	
    tableView.backgroundColor = [UIColor clearColor];
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
	tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    [tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"设置";
    
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

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Settings_Cell"];
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    int row = [indexPath row];
	
    if (row == 0)
    {
        cell.textLabel.text = @"流量监控"; //APN设置";
    }
    else if (row == 1)
    {
        cell.textLabel.text = @"新手引导";
    }
    /*else if (row == 2)
    {
        cell.textLabel.text = @"意见反馈";
    }*/
    else if (row == 2)
    {
        cell.textLabel.text = @"检测新版本";
    }
    else if (3 == row)
    {
        cell.textLabel.text = @"系统信息";
    }
	return cell;
}

- (void)taskFinished:(TaskType)type result:(id)result
{
    if ([result isKindOfClass:[NSError class]])
    {
        MBProgressHUD *show = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        show.mode = MBProgressHUDModeText;
        show.labelText = [(NSError *)result localizedDescription];
        [show hide:YES afterDelay:2];
    }
    else
    {
        NSDictionary* dctPlist = [NSDictionary dictionaryWithDictionary:result];
        NSDictionary* dctItems0 = [[dctPlist objectForKey:@"items"] objectAtIndex:0];
        NSString* sVer = [[dctItems0 objectForKey:@"metadata"] objectForKey:@"bundle-version"];
        NSString* curVer = NSUtil::BundleVersion();
        if (NSOrderedAscending == [curVer compare:sVer])
        {
            NSString* sUrl = [[[dctItems0 objectForKey:@"assets"] objectAtIndex:0] objectForKey:@"url"];
            NSURL* url = [NSURL URLWithString:sUrl];
            sUrl = [url absoluteString];
            sUrl = [sUrl substringToIndex:sUrl.length - 3]; //ipa
            sUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@plist", sUrl];
            url = [NSURL URLWithString:sUrl];
            [UIUtil::Application() openURL:url];
        }
        else
        {
            MBProgressHUD *show = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            show.mode = MBProgressHUDModeText;
            show.labelText = @"目前为最新版本";
            [show hide:YES afterDelay:3];
        }
    }
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if ([indexPath row] == 0)
    {
        CGRect frame = ((AppDelegate *)UIUtil::Delegate()).window.frame;
		frame.origin.x = 0;
		frame.origin.y = 0;//20;
		frame.size.height -= frame.origin.y;
		RootViewController* controller = [[RootViewController alloc] init];
        controller.title = @"APN设置";
        
        CustomNavigationController *navigation = (CustomNavigationController*)self.navigationController;
        navigation.firstViewController = controller;
        [navigation pushViewController:controller animated:NO];
        [controller release];
    }*/
    if ([indexPath row] == 0)
    {
        CGRect frame = ((AppDelegate *)UIUtil::Delegate()).window.frame;
		frame.origin.x = 0;
		frame.origin.y = 0;//20;
		frame.size.height -= frame.origin.y;
        FlowDataViewController *controller = [[FlowDataViewController alloc] init];
        controller.title = @"流量监控";
        
        CustomNavigationController *navigation = (CustomNavigationController*)self.navigationController;
        [navigation pushViewController:controller animated:NO];
        [controller release];
    }
    else if ([indexPath row] == 1)
    {
        CGRect frame = ((AppDelegate *)UIUtil::Delegate()).window.frame;
		frame.origin.x = 0;
		frame.origin.y = 0;//20;
		frame.size.height -= frame.origin.y;
		WizardView *wizard = [[[WizardView alloc] initWithFrame:frame] autorelease];
		wizard.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[((AppDelegate *)UIUtil::Delegate()).window addSubview:wizard];
    }
    else if(2 == [indexPath row])
    {
        //NSString* sUuid = NSUtil::GetUUID();
        NSString* sUrl = NSUtil::SettingForKey(kServerKey);
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mcdm/clientapp/mcdm.plist", sUrl]];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@/mcdm/clientapp/mcdm.plist", sUrl]]];
        [[DataLoader loader] StartTaskForResults:self url:url tskType:Task_DetectNewVersion];
    }
    else if (3 == [indexPath row])
    {
        CGRect frame = ((AppDelegate *)UIUtil::Delegate()).window.frame;
		frame.origin.x = 0;
		frame.origin.y = 0;//20;
		frame.size.height -= frame.origin.y;
		SysInfoViewController* controller = [[SysInfoViewController alloc] init];
        controller.title = @"系统信息";
        
        CustomNavigationController *navigation = (CustomNavigationController*)self.navigationController;
        [navigation pushViewController:controller animated:NO];
        [controller release];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
