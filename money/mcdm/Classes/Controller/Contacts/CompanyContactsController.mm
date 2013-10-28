//
//  CompanyContactsViewController.m
//  Tableview
//
//  Created by Cyber Wise on 13-01-22.
//  Copyright (c) 2013年 Cyber Wise. All rights reserved.
//
#import "CompanyContactsController.h"
//#import "CommonUtils.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ContactsSubViewController.h"
#import "GBDeviceInfo.h"
#import "NSUtil.h"
#import "PullView.h"
@interface CompanyContactsViewController ()
{
    UINavigationController* navigationController;
    NSDictionary* dic;
    CompanyContactsViewController* viewControllerSearch;
}
@property(nonatomic, retain) NSString* sSearch;
@end

@implementation CompanyContactsViewController
//@synthesize tableControllSeg;
@synthesize listarray;
@synthesize tableView;
@synthesize arrayDict;
@synthesize secLabelArray;
@synthesize arrayDictKey;
@synthesize sSearch;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sSearch = nil;
        //self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Find" style:UIBarButtonItemStyleDone target:self action:@selector(Find)] autorelease];
    }
    return self;
}
-(void)Find
{

}

#pragma mark -
#pragma mark Pull view methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_pullView didScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ([_pullView endDragging])
	{
		[self GetContactFromSvr];
	}
}

-(void)setNavigationController:(UIViewController *)VCtrllr
{
    navigationController = VCtrllr.navigationController;
}
//根据获得的列表初始化，并重新画界面
-(void)loadListData{
    int i;
    int size;
    arrayDictKey = [[arrayDict allKeys] sortedArrayUsingSelector:@selector(compare:)].copy;
    //NSMutableArray* mtbListArray = [[NSMutableArray alloc] init];
    for(NSString *key in arrayDictKey){
        NSArray *oneCategory = [arrayDict objectForKey:key];
        NSMutableArray* aNew = [[NSMutableArray alloc] init];
        NSDictionary* dicObj;
        size = [oneCategory count];
        for (i = 0; i < size; ++ i) {
            dicObj = [oneCategory objectAtIndex:i];
            [aNew addObject:[dicObj objectForKey:NAME]];
            //[mtbListArray addObject:key];
        }
        if (nil == sSearch) {
            [arrayDict setValue:aNew forKey:key];
        }
        else
        {
            arrayDict = [NSDictionary dictionaryWithObject:aNew forKey:@""];
        }
        [aNew release];
    }
    arrayDict = [arrayDict copy];
    [tableView reloadData];
    [tableView setShowsVerticalScrollIndicator:NO];
    tableView.showsVerticalScrollIndicator = NO;
    //tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (nil == sSearch) {
        int iHeight = [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [tableView.tableHeaderView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, iHeight)];
    }
    else
    {
        [tableView.tableHeaderView setFrame:CGRectMake(- 55, - 55, 0, 0)];
        tableView.tableHeaderView = nil;
    }
}
-(void)GetContactFromSvr{
    NSString *addressBookPath = @"mcdm/resource/addressBookList";
    NSString *udid = NSUtil::GetUUID(); //[self getUDID];
    NSString *filePath = NSUtil::DocumentsSubPath(kSettingsFile);
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
        NSString *sContactURLString;
#if TARGET_IPHONE_SIMULATOR
#ifdef DEBUG
        //udid = @"5073495ee44546a8dbfbe456ee285c27fb35622b";
        udid = @"331ad2a2265ed6e6380e3482006e1aafe99e4d50";
#endif
#endif
        if (nil == sSearch) {
            sContactURLString = [NSString stringWithFormat:@"%@/%@?udid=%@&start=0&size=6000", serverUrl,addressBookPath,udid];
        }
        else
        {
            sContactURLString = [NSString stringWithFormat:@"%@/%@?udid=%@&name=%@", serverUrl,addressBookPath,udid, sSearch];
            sContactURLString = [sContactURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        NSLog(@"addressBook list addr is %@", sContactURLString);
        NSUtil::startGettingInfo(sContactURLString, self);
    }
    else{
        //        NSString *msg = [NSString stringWithFormat:@"获取软件列表失败，请联系管理员!"];
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"失败" message:msg delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        //        [alert show];
        //        [alert release];
        NSString *msg = @"请先激活设备...";
        NSUtil::showMessageWithHUD(msg, self);
    }
}
//ASIHttpRequest，下载结束后处理数据
-(void)requestDone:(ASIHTTPRequest *)request{
    NSData *responseData = [request responseData];
    NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString *xmlString = [[NSString alloc] initWithData:responseData encoding:enc];
    if(nil == sSearch){
        @try {
            arrayDict = [xmlString propertyList];
            dic = arrayDict.copy;
        }
        @catch (NSException *exception) {
            [xmlString release];
            NSString *msg = @"服务器错误";
            NSUtil::showMessageWithHUD(msg, self);
            return ;
        }
    }
    else
    {
        @try {
            NSArray* aSearch = [xmlString propertyList];
            arrayDict = [NSDictionary dictionaryWithObject:aSearch forKey:@""];
            dic = [NSDictionary dictionaryWithObject:aSearch forKey:@""];
            dic = dic.copy;
        }
        @catch (NSException *exception) {
            [xmlString release];
            NSString *msg = @"服务器错误";
            NSUtil::showMessageWithHUD(msg, self);
            return;
        }
        self.title = @"搜索联系人";
    }
    [self loadListData];
    [xmlString release];
}
-(void)requestWentWrong:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"%@",error);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //viewControllerSearch = self;
    //navigationController.visibleViewController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    [self GetContactFromSvr];
    NSLog(@"arrayrow:%d",[[arrayDict objectForKey:[arrayDictKey objectAtIndex:1]] count]);
    //CGSize szSize = self.view.frame.size;
    if ([self isKindOfClass:([CompanyContactsViewController class])]) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        //frame.size.width *= 1.5;
        if (!self.hidesBottomBarWhenPushed)
        {
            frame.size.height -= TAB_BAR_HEIGHT;
        }
        tableView = [[UITableView alloc]initWithFrame:frame];
    }
    else
    {
        tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    }
    _pullView = [[[PullView alloc] initWithFrame:CGRectMake(0, - tableView.bounds.size.height, tableView.frame.size.width, tableView.bounds.size.height) textColor:nil shadowMode:0 shadowColor:nil] autorelease];
    _pullView.delegate = self;
    [tableView addSubview:_pullView];
    UISearchBar* SBarFind = [[UISearchBar alloc] init];
    tableView.tableHeaderView = SBarFind;
    tableView.sectionIndexMinimumDisplayRowCount = 1;
    [SBarFind setDelegate:self];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    [self.view sendSubviewToBack:tableView];
    [tableView setShowsVerticalScrollIndicator:NO];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tableView release];

	// Do any additional setup after loading the view.
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (nil == viewControllerSearch) {
        viewControllerSearch = [[CompanyContactsViewController alloc] init];
    }
    viewControllerSearch.sSearch = searchBar.text;
    if ([navigationController visibleViewController] == viewControllerSearch) {
        [viewControllerSearch GetContactFromSvr];
    }
    else
    {
        [viewControllerSearch GetContactFromSvr];
        [viewControllerSearch setNavigationController:navigationController.visibleViewController];
        [navigationController pushViewController:viewControllerSearch animated:YES];
    }
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [tableView resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{ 
    //* 出现几组
	//if(aTableView == self.tableView) return 27;
	return 1 + [arrayDict count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((nil != sSearch) && (0 == [indexPath section])) {
        return 0.0;
    }
    //这里控制值的大小
    return 50.0;  //控制行高
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{  
    //搜索时显示按索引第几组 UISearchBar
    NSInteger count = 1;
    NSLog(@"%@",title);
    for(NSString *character in arrayDictKey)
    {
        
        if([character isEqualToString:title])
        {
            
            return count;
        
        }
        
        count ++;
        
    }
    
    return count;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    /*if([listarray count]==0)
        
    {
        
        return @"";
        
    }*/
        
        //return [listarray objectAtIndex:section];   //*分组标签
    if (0 == section) {
        return @"";
    }
    return [arrayDictKey objectAtIndex:(section - 1)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    //return [self.listarray count];    //*每组要显示的行数
    //NSInteger i = [[listarray objectAtIndex:section] ]
    if (0 == section) {
        return 1;
    }
   NSInteger i = [[arrayDict objectForKey:[arrayDictKey objectAtIndex:(section - 1)]] count];
    return i;
}
/*-(UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{   
    //返回类型选择按钮  

    return UITableViewCellAccessoryDisclosureIndicator;   //每行右边的图标
}*/
- (UITableViewCell *)tableView:(UITableView *)tableview 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier"; 
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier: 
                             TableSampleIdentifier]; 
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:TableSampleIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSUInteger sectionMy = [indexPath section];
    if (0 == sectionMy) {
        return cell;
    }
    NSLog(@"sectionMy:%d",sectionMy);

    cell.textLabel.text = [[arrayDict objectForKey:[arrayDictKey objectAtIndex:(sectionMy - 1)]] objectAtIndex:row]; //每一行显示的文字
    
    NSString *str=  [NSString stringWithFormat: @"%d", row];
 
    UIImage *image = [UIImage imageNamed:str]; 
    cell.imageView.image = image; 
    UIImage *highLighedImage = [UIImage imageNamed:@"1.png"]; 
    
    cell.imageView.highlightedImage = highLighedImage; //选中一行时头部图片的改变
	return cell;
}
/*/划动cell是否出现del按钮
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
	return YES;  //是否需要删除图标
}*/
//编辑状态(不知道干什么用)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath
{   
 
	[self viewDidLoad];
}

//选中时执行的操作
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    if (0 == section) {
        return indexPath;
    }
    NSUInteger row = [indexPath row];
    ContactsSubViewController* contactsSubViewController = [ContactsSubViewController alloc];
    NSString *key = [arrayDictKey objectAtIndex:(section - 1)];
    contactsSubViewController.dictContact = [[NSDictionary alloc] initWithDictionary:[[dic objectForKey:key] objectAtIndex:row]];
    contactsSubViewController.title = key;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"推荐" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [backItem release];
    [navigationController pushViewController:contactsSubViewController animated:YES];
    [contactsSubViewController release];
    return indexPath;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.listarray = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
