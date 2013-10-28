//
//  NotificationListController.m
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "NotificationListController.h"
#import "DataLoader.h"
#import "HelpCells.h"
#import "NotificationDetailController.h"

@interface NotificationListController ()

@end

@implementation NotificationListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    if (_readNotification)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetNotificationListNotification object:nil userInfo:nil];
    }
    
    [super dealloc];
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	tableView.rowHeight = 60;
	
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    [tableView release];
    
    _tableView = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"通知公告";
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataLoader loader].notificationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"NotificationCell"];
	NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[NotificationCell alloc] initWithReuse:cellIdentifier];
    }
    
    int row = [indexPath row];
	
	NSDictionary *item = [[DataLoader loader].notificationArray objectAtIndex:row];
    
    cell.textLabel.text = [item objectForKey:@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"发布者：%@ 时间：%@", [item objectForKey:@"origin"], [item objectForKey:@"date"]];
    
    cell.imageView.image = [DataLoader hasReadNotification:[item objectForKey:@"id"]] ? [UIImage imageNamed:@"Read.png"] : [UIImage imageNamed:@"Unread.png"];
	
	return cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [[DataLoader loader].notificationArray objectAtIndex:[indexPath row]];
    
    NotificationDetailController *controller = [[NotificationDetailController alloc] initWithId:[item objectForKey:@"id"]];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    _readNotification = YES;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
