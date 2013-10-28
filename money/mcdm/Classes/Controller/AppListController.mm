//
//  AppListController.m
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "AppListController.h"
#import "HelpCells.h"
#import "Task.h"
#import "MBProgressHUD.h"
#import "DataLoader.h"
#import "Toast+UIView.h"
#import "FocusHeaderViews.h"
#import "AppDetailController.h"
#import "AppDelegate.h"
#import "PullView.h"

@interface AppListController ()

@end

@implementation AppListController

- (id)initWithCatalog:(NSString *)catalog andSubCatalog:(NSString *)subCatalog
{
    self = [super init];
    if (self)
    {
        _catalog = [catalog retain];
        _subCatalog = [subCatalog retain];
    }
    return self;
}

- (void)dealloc
{
    [_catalog release];
    [_subCatalog release];
    
    [_items release];
    [_focusItems release];
    
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
    
	tableView.rowHeight = kNormalCellHeight;
	
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    [tableView release];
    
    _tableView = tableView;
    
    if (_catalog && _subCatalog)
    {
        NSDictionary *catalogDict = [[DataLoader loader].appsDictionary objectForKey:_catalog];
        _items = [[catalogDict objectForKey:_subCatalog] retain];
        [_tableView reloadData];
    }
    else
    {
        _pullView = [[[PullView alloc] initWithFrame:CGRectMake(0, -_tableView.bounds.size.height, _tableView.frame.size.width, _tableView.bounds.size.height) textColor:nil shadowMode:0 shadowColor:nil] autorelease];
        _pullView.delegate = self;
        [_tableView addSubview:_pullView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self onRefresh];
}

- (void)onRefresh
{
    // 如果加载全部，则动态加载
    if (!_catalog)
    {
        [[DataLoader loader] getAppList:self];
    }
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
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"App_Cell"];
	AppItemCell *cell = (AppItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[AppItemCell alloc] initWithReuse:cellIdentifier];
    }
    
    int row = [indexPath row];
	
	NSDictionary *item = [_items objectAtIndex:row];
    
    cell.textLabel.text = [item objectForKey:@"name"];
    cell.detailTextLabel.text = [item objectForKey:@"description"];
    
    [cell.iconView setUrl:[item objectForKey:@"icon"]];
	
	return cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    AppDetailController *controller = [[AppDetailController alloc] initWithInfo:info];
    controller.hidesBottomBarWhenPushed = YES;
    [[UIUtil::Delegate() getCurrentNavigationController] pushViewController:controller animated:YES];
    [controller release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)openObject:(NSNumber *)index
{
    NSDictionary *info = [_focusItems objectAtIndex:[index intValue]];
    AppDetailController *controller = [[AppDetailController alloc] initWithInfo:info];
    controller.hidesBottomBarWhenPushed = YES;
    [[UIUtil::Delegate() getCurrentNavigationController] pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Pull view methods

//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_pullView didScroll];
}

//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ([_pullView endDragging])
	{
		[self onRefresh];
	}
}

//
- (NSString *)pullView:(PullView *)pullView textForStamp:(PullViewState)state
{
	NSString *stamp = nil;
	if (pullView == _pullView)
	{
		if (state == PullViewStateError)
		{
			return @"载入数据失败，请检查网络可用。";
		}
		
        stamp = @"";
		//stamp = NSUtil::FormatDate(_channel.updateTime);
	}
	
	return stamp;
}

// TaskDelegate <NSObject>
- (void)taskStarted:(TaskType)type
{
    [_pullView beginLoading];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)taskFinished:(TaskType)type result:(id)result
{
    [_pullView finishLoading];
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([result isKindOfClass:[NSError class]])
    {
        MBProgressHUD *show = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        show.mode = MBProgressHUDModeText;
        show.labelText = [(NSError *)result localizedDescription];
        [show hide:YES afterDelay:2];
        
        //[self.view makeToast:[(NSError *)result localizedDescription] duration:0.5 position:@"center"];
    }
    else
    {
        [_items release];
        _items = [[NSMutableArray array] retain];
        
        {
            NSDictionary *catalogDict = [[DataLoader loader].appsDictionary objectForKey:@"carrier"];
            for (NSString *key in catalogDict.allKeys)
            {
                NSArray *appsArray = [catalogDict objectForKey:key];
                
                for (NSDictionary *item in appsArray)
                {
                    BOOL forced = [[item objectForKey:@"forced"] boolValue];
                    if (!forced)
                    {
                        [_items addObject:item];
                    }
                }
            }
        }
        
        {
            NSDictionary *catalogDict = [[DataLoader loader].appsDictionary objectForKey:@"company"];
            for (NSString *key in catalogDict.allKeys)
            {
                NSArray *appsArray = [catalogDict objectForKey:key];
                
                for (NSDictionary *item in appsArray)
                {
                    BOOL forced = [[item objectForKey:@"forced"] boolValue];
                    if (!forced)
                    {
                        [_items addObject:item];
                    }
                }
            }
        }
         
        [_focusItems release];
        NSArray *focusArray = [[DataLoader loader].appsDictionary objectForKey:@"focus"];
        _focusItems = [focusArray retain];
        if ([_focusItems count])
        {
            if (!_headerView)
            {
                // headerView
                CGFloat width = self.view.frame.size.width;
                CGFloat height = (140.f/320)*width;
                _headerView = [[[FocusHeaderAppView alloc] initWithFrame:CGRectMake(0, 0, width, height)] autorelease];
                _tableView.tableHeaderView = _headerView;
                _headerView.hidden = YES;
                _headerView.container = self;
            }
            
            _headerView.hidden = NO;
            [_headerView setNewsArray:_focusItems];
        }
        else
        {
            _tableView.tableHeaderView = nil;
            _headerView = nil;
        }
        
        [_tableView reloadData];
    }
}

@end
