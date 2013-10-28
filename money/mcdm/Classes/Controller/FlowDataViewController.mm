//
//  FlowDataViewController.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "FlowDataViewController.h"
#import "DataLoader.h"
#import "FlowDataDetector.h"
#import "MonthFlowData.h"
#import "MBProgressHUD.h"

#define kGroupBarHeight 35

@interface FlowDataViewController ()

@end

@implementation FlowDataViewController

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
    frame.origin.y = 0;
    
    if (!self.hidesBottomBarWhenPushed)
    {
        frame.size.height -= 49;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = [view autorelease];
    
    UIImage *image = [UIImage imageNamed:@"FlowRow0.png"];
	_tableView.rowHeight = image.size.height;
	
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDetectFlowData:) name:kDetectFlowDataNotification object:nil];
    
    [[DataLoader loader] detectAndPostFlowData:nil];
    
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDetectFlowDataNotification object:nil];
}

- (void)onDetectFlowData:(NSNotification *)notification
{
    if (!notification.userInfo)
    {
        _Log(@"onDetectFlowData start");
        
        MBProgressHUD *progress = [MBProgressHUD HUDForView:_tableView];
        if (!progress)
        {
            progress = [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
            progress.labelText = @"正在统计流量信息";
        }
    }
    else
    {
        _Log(@"onDetectFlowData end");
        [MBProgressHUD hideHUDForView:_tableView animated:YES];
        [_tableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)iconImageName
{
	return @"FlowData";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return kGroupBarHeight;
}

//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MonthFlowData *flowdata = [[FlowDataDetector detector].recordArray objectAtIndex:section];
	NSString *title = flowdata.key;
    
	CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, kGroupBarHeight);
	UIView *bar = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FlowGroupBar.png"]];
    CGRect lineFrame = line.frame;
    line.contentMode = UIViewContentModeScaleToFill;
    lineFrame.origin.x = UIUtil::IsPad() ? 43 : 9;
    lineFrame.size.width = frame.size.width - (UIUtil::IsPad() ? 86 : 18);
    line.frame = lineFrame;
    [bar addSubview:line];
    [line release];
    
	CGRect labelFrame = lineFrame;
	UILabel *label = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
	//label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	label.text = title;
    
    label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:16];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	
	[bar addSubview:label];
	return [bar autorelease];
}

// UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[FlowDataDetector detector].recordArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"flow_Cell"];
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    MonthFlowData *data = [[FlowDataDetector detector].recordArray objectAtIndex:section];
    
    NSString *title = @"";
    NSString *value = @"";
    UIImage *image = nil;
    
    switch (row)
    {
        case 0:
            title = @"WIFI下载";
            value = [FlowDataDetector bytesToAvaiUnit:data.wifiReceived];
            image = [UIImage imageNamed:@"wifidown.png"];
            break;
            
        case 1:
            title = @"WIFI上传";
            value = [FlowDataDetector bytesToAvaiUnit:data.wifiSent];
            image = [UIImage imageNamed:@"wifiup.png"];
            break;
            
        case 2:
            title = @"3G下载";
            value = [FlowDataDetector bytesToAvaiUnit:data.WWANReceived];
            image = [UIImage imageNamed:@"3gdown.png"];
            break;
            
        case 3:
            title = @"3G上传";
            value = [FlowDataDetector bytesToAvaiUnit:data.WWANSent];
            image = [UIImage imageNamed:@"3gup.png"];
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = value;
    cell.imageView.image = image;
    
	cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:(row%2) ? @"FlowRow1.png" : @"FlowRow0.png"]] autorelease];
	
	return cell;
}

@end
