//
//  AppCatalogController.m
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "AppCatalogController.h"
#import "HelpCells.h"
#import "DataLoader.h"
#import "AppListController.h"
#import "AppDelegate.h"

@interface AppCatalogController ()

@end

@implementation AppCatalogController

//default(默认)，finance（财务），reference（参考），navigation（导航），tools（工具），health（健康），education（教育），travel（旅行），commerce（商业），guid（商品指南），social（社交），film（摄影与录像），life（生活），sports（体育），wealther（天气），books（图书），efficiency（效率），news（新闻），medical（医疗），music（音乐），games（游戏），entertainment（娱乐）

static NSDictionary *g_catalogsAndNames = [NSDictionary dictionaryWithObjectsAndKeys:
                                           @"默认", @"default",
                                           @"财务", @"finance",
                                           @"参考", @"reference",
                                           @"导航", @"navigation",
                                           @"工具", @"tools",
                                           @"健康", @"health",
                                           @"教育", @"education",
                                           @"旅行", @"travel",
                                           @"商业", @"commerce",
                                           @"商品指南", @"guid",
                                           @"社交", @"social",
                                           @"摄影与录像", @"film",
                                           @"生活", @"life",
                                           @"体育", @"sports",
                                           @"天气", @"wealther",
                                           @"图书", @"books",
                                           @"效率", @"efficiency",
                                           @"新闻", @"news",
                                           @"医疗", @"medical",
                                           @"音乐", @"music",
                                           @"游戏", @"games",
                                           @"娱乐", @"entertainment",nil];

- (id)initWithMainKey:(NSString *)key
{
    self = [super init];
    if (self) {
        
        _mainKey = [key retain];
    }
    return self;
}

- (void)dealloc
{
    [_mainKey release];
    [_catalogs release];
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    _appDict = [[DataLoader loader].appsDictionary objectForKey:_mainKey];
    
    [_catalogs release];
    _catalogs = [[_appDict allKeys] retain];
    [_tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_catalogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"AppCatalog_Cell"];
	AppCatalogItemCell *cell = (AppCatalogItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[AppCatalogItemCell alloc] initWithReuse:cellIdentifier];
    }
    
    int row = [indexPath row];
	
	NSString *catalog = [_catalogs objectAtIndex:row];
    
    NSString *name = [g_catalogsAndNames objectForKey:catalog];
    cell.textLabel.text = name ? name : catalog;
    
    NSString *icon = [[[_appDict objectForKey:catalog] objectAtIndex:0] objectForKey:@"icon"];
    [cell.iconView setUrl:icon];
	
	return cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *catalog = [_catalogs objectAtIndex:[indexPath row]];
    
    NSString *name = [g_catalogsAndNames objectForKey:catalog];
    
    AppListController *controller = [[AppListController alloc] initWithCatalog:_mainKey andSubCatalog:catalog];
    controller.title = name ? name : catalog;
    [[UIUtil::Delegate() getCurrentNavigationController] pushViewController:controller animated:YES];
    [controller release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
