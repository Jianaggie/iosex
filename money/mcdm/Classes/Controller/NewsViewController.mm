//
//  NewsViewController.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "NewsViewController.h"
#import "HelpCells.h"
#import "NewsItem.h"
#import "Task.h"
#import "MBProgressHUD.h"
#import "DataLoader.h"
#import "Toast+UIView.h"
#import "FocusHeaderViews.h"
#import "NewsReader.h"
#import "PullView.h"
#import "LoadingMoreFooterView.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

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
    [_focusItems release];
    [_items release];
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	tableView.rowHeight = kNormalCellHeight;
	
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView = tableView;
    
    // headerView
    CGFloat width = frame.size.width;
    CGFloat height = (180.f/320)*width;
    _headerNewsView = [[[FocusHeaderImageNewsView alloc] initWithFrame:CGRectMake(0, 0, width, height)] autorelease];
    _tableView.tableHeaderView = _headerNewsView;
    _headerNewsView.hidden = YES;
    _headerNewsView.container = self;
    
    _pullView = [[[PullView alloc] initWithFrame:CGRectMake(0, -_tableView.bounds.size.height, _tableView.frame.size.width, _tableView.bounds.size.height) textColor:nil shadowMode:0 shadowColor:nil] autorelease];
    _pullView.delegate = self;
    [_tableView addSubview:_pullView];
    
    _tableView.delegate = self;
	_tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self onRefresh];
    //响应程序从后台转为前台的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRefreshFirst) name:UIApplicationDidBecomeActiveNotification object:nil];
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

- (NSString *)iconImageName
{
	return @"News";
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"News_Cell"];
	NewsItemCell *cell = (NewsItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[NewsItemCell alloc] initWithReuse:cellIdentifier];
    }
    
    int row = [indexPath row];
	
	NSDictionary *item = [_items objectAtIndex:row];
    
    cell.textLabel.text = [item objectForKey:@"title"];//item.title;
    cell.detailTextLabel.text = [item objectForKey:@"summary"];

    NSString *iconUrl = [item objectForKey:@"photosPath"];
    if ([iconUrl length])
    {
        [cell.iconView setUrl:iconUrl];
    }
    else
    {
        cell.iconView.image = [UIImage imageNamed:@"Icon.png"];
    }
	
	return cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [_items objectAtIndex:[indexPath row]];
    [self openItem:item];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)openItem:(NSDictionary *)item
{
    NewsReader *reader = [[NewsReader alloc] initWithNewsId:[item objectForKey:@"id"]];
    reader.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reader animated:YES];
    [reader release];
}

- (void)openObject:(NSNumber *)index
{
    int iIndex = [index intValue];
    NSDictionary *item = [_focusItems objectAtIndex:iIndex];
    [self openItem:item];
}

- (void)loadMoreData
{
    _isLoadMore = YES;
    [[DataLoader loader] getNewsList:self start:[_items count] andCount:kNewsCountPerPage];
}

#pragma mark -
#pragma mark Pull view methods

//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_pullView didScroll];
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if (y >= h-30 && _loadMoreFootView.enabled)
    {
        [self loadMoreData];
    }
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

- (void)onRefreshFirst
{
    if (0 == [_tableView numberOfRowsInSection:0]) {
        [self onRefresh];
    }
}

- (void)onRefresh
{
    _isLoadMore = NO;
    [[DataLoader loader] getNewsList:self start:0 andCount:kNewsCountPerPage];
}

// TaskDelegate <NSObject>
- (void)taskStarted:(TaskType)type
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (!_isLoadMore)
    {
        [_pullView beginLoading];
    }
}

- (void)taskFinished:(TaskType)type result:(id)result
{
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    if (!_isLoadMore)
    {
        [_pullView finishLoading];
    }
    
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
        if (!_isLoadMore)
        {
            [_items release];
            _items = [NSMutableArray arrayWithArray:result];
            [_items retain];
            
            if ([_items count])
            {
                [_focusItems release];
                _focusItems = [[NSMutableArray array] retain];
                for (NSDictionary *item in _items)
                {
                    NSString *recommend = [item objectForKey:@"recommend"];
                    if ([recommend isEqualToString:@"Yes"])
                    {
                        [_focusItems addObject:item];
                    }
                }
                
                _headerNewsView.hidden = NO;
                [_headerNewsView setNewsArray:_focusItems];
            }
            
            if (!_loadMoreFootView)
            {
                _loadMoreFootView = [[LoadingMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.f)];
                _tableView.tableFooterView = _loadMoreFootView;
                [_loadMoreFootView release];
                _loadMoreFootView.hidden = NO;
            }
            
            _loadMoreFootView.enabled = ([_items count] == kNewsCountPerPage);
            _loadMoreFootView.hidden = [_items count] == 0;
            
            [_tableView reloadData];
        }
        else
        {
            NSArray *array = result;
            if ([array count])
            {
                [_items addObjectsFromArray:array];
                
                if ([array count] < kNewsCountPerPage)
                {
                    _loadMoreFootView.enabled = NO;
                }
            }
            else
            {
                _loadMoreFootView.enabled = NO;
            }
            
            [_tableView reloadData];
        }
    }
}

@end
