//
//  RootViewController.m
//  主界面
//
//  Created by MagicStudio on 11-4-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "RootViewController.h"
//#import "unionApnViewController.h"
//#import "NetworkViewController.h"
#import "ApnInfo.h"
#import "AppDelegate.h"
//#import "UdidDevice.h"
#import "Reachability.h"
#include "sys/param.h"
#include "sys/mount.h"
#import "UIUtil.h"
//网络连接相关
#import "DDLog.h"
#import "DDTTYLogger.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
@interface RootViewController()
{
    int count;
}
@end
//文件路径
//#define PACKAGE_FILE_PATH(FILE_NAME) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:FILE_NAME]	
@implementation RootViewController
//@synthesize addapnview;
//@synthesize apnInfoArray;
//@synthesize editApnInfoController;
//@synthesize switchArray;
@synthesize aboutMeController;
@synthesize initInfoController;
@synthesize internetController;
@synthesize intrantViewController;
@synthesize mainAPNcontroller;
@synthesize pageControl;
@synthesize scrollView;
@synthesize avertWebView;
//@synthesize currentAPNString;
//@synthesize responseInfo;
//NSMutableData *data;
//NSInputStream *iStream;
//NSOutputStream *oStream;
//CFReadStreamRef readStream = NULL;
//CFWriteStreamRef writeStream = NULL;

//
////struct sigaction act; // 描述信号行为的变量
////struct timeval tv; // 描述时间的结构体变量
////struct sockaddr_in zeroAddress;
//int count;//重发apn次数
//int errorCount;//错误次数
//
//int sendApnContentLength;//发送数据 的长度
NSInteger changePort=32345;
// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
//广告相关
//存储 下砸的图片名字
NSString *unionAvertImgName=@"unionAvert.png";
//下载图片的路径
NSString *unionAvertImgURL=@"http://cyber-wise.vicp.net:8080";
//联通广告页面链接
NSString  *unionAvertHtmlURL=@"http://cyber-wise.com.cn:8007/pages/Ad/getAd.do";
//每次进入页面时调用
- (void)viewWillAppear:(BOOL)animated
{
    //self.navigationItem.title=@"企业移动终端管家";
    //self.navigationController.navigationItem.title=@"企业移动终端管家";
    //从线程中调用下载的方法
   // [NSThread detachNewThreadSelector:@selector(downLoadImgFromServer) toTarget:self withObject:nil];
   // avertWebView= [[UIWebView alloc]initWithFrame:CGRectMake(0, 460, 320, 50)];
//    [self.view addSubview:avertWebView];
//    [self loadAvertWebView];
}
- (NSString *)iconImageName
{
	return @"Icon-Small";
}
-(void)setNvItm:(UINavigationItem*)navigationItem
{
    //nvItm = navigationItem;
}

-(void)startServer{
    
    UIApplication *app = [UIApplication sharedApplication];
	NSArray *oldNotifications = [app scheduledLocalNotifications];
	
	// Clear out the old notification before scheduling a new one.
	if (0 < [oldNotifications count]) {
		
		[app cancelAllLocalNotifications];
	}
    
    
    //NSLog(@"-----------startServerstartServerstartServer-----------");
	// Configure our logging framework.
	// To keep things simple and fast, we're just going to log to the Xcode console.
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	
	// Create server using our custom MyHTTPServer class
	httpServer = [[HTTPServer alloc] init];
	
	// Tell the server to broadcast its presence via Bonjour.
	// This allows browsers such as Safari to automatically discover our service.
	[httpServer setType:@"_http._tcp."];
	
	// Normally there's no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for easy testing you may want force a certain port so you can just hit the refresh button.
    //changePort=12345;
	[httpServer setPort:changePort];
    //NSLog(@"%i-----------------------",changePort);
	
	// Serve files from our embedded Web folder
	//NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
	
    
    //NSFileManager *fm=[ NSFileManager defaultManager];
    
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
	//DDLogInfo(@"Setting document root: %@", documentsDirectory);
	[httpServer setDocumentRoot:documentsDirectory];
	
	// Start the server (and check for problems)
	
	NSError *error;
	if(![httpServer start:&error])
	{
		DDLogError(@"Error starting HTTP Server: %@", error);
	}
    
    //changePort=changePort+2;
}

//实现程序可以在后台运行（解决当切换到safari时 后台http server不能启动的问题）
- (void)applicationDidEnterBackground:(UIApplication *)application { 
    //NSLog(@"DFDFDF---------");
    //重新加载 分页
    //[self addControl];//调用 添加分页控件
    //[self creatPosterViews];
    
    
    UIApplication* app = [UIApplication sharedApplication]; 
    bgTask = [app beginBackgroundTaskWithExpirationHandler: ^{ 
        dispatch_async(dispatch_get_main_queue(), ^{ 
            [app endBackgroundTask:self->bgTask]; 
            self->bgTask = UIBackgroundTaskInvalid; 
        }); 
    }]; 
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 
                                             0), ^{ 
        if ([app backgroundTimeRemaining] > 1.0) { 
            
            count=count+1;
            //            if ([httpServer) {
            //                <#statements#>
            //            }
            //             if (![httpServer isRunning]) {
            //                 NSLog(@"---------applicationDidEnterBackground-----httpServer isRunning");
            //                 [httpServer republishBonjour];
            //                // [self startServer];
            //             }else{
            //                  NSLog(@"---------applicationDidEnterBackground-----httpServer startServer");
            //  [httpServer stop];
            [self startServer];
            //    }
            
            //[application endBackgroundTask:self->bgTask];
            //self->bgTask = UIBackgroundTaskInvalid;
            //  HTTPServer *httserver=[[HTTPServer alloc]init];
            //  [httpServer stop];
            // [self startServer];
            
            // allow things to process 
            // wait for end of process, then shut down http server 
            
        } 
        // changePort=changePort+2;//// 此处修改过 2011。 9。 15 下午 5:30
        
    }); 
    
    
    
}

//打开页面
-(void)openSafari:(NSString *)moblieconfigName{
    
    // 2011年 9月 13 日
    //    HTTPServer  *httpServer1=[[HTTPServer alloc]init];
    //    if ([httpServer1 stop]) {
    //        NSLog(@"------------------------stop");
    //        [self startServer];
    //    }
    // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    
    
    [self startServer];
    
    
    NSMutableString *url=[NSMutableString stringWithString:@"http://127.0.0.1:"];
    [url appendString: [NSString stringWithFormat:@"%d", changePort]];// 此处修改过 2011。 9。 15
    [url appendString:@"/"];
    [url appendString:moblieconfigName];
    //[NSThread sleepForTimeInterval:2];
    
    //    NSMutableString *url2=[NSMutableString stringWithString:@"http://127.0.0.1:"];
    //    [url2 appendString: [NSString stringWithFormat:@"%d", changePort  ]];// 此处修改过 2011。 9。 15
    //    [url2 appendString:@"/"];
    //    [url2 appendString:moblieconfigName];
    //NSLog(@"访问路径－－－－－－－－－－－－－%@",url);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; 
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url2]]; 
    changePort=changePort+2;//此处放到下面去了 applicationDidEnterBackground 2011 9 14修改过
    //[pool release];
}

//加载 webView
-(void)loadAvertWebView{
    NSURL *url = [[NSURL alloc]initWithString:unionAvertHtmlURL];
    NSURLRequest *request =[[NSURLRequest alloc]initWithURL:url];
    [avertWebView loadRequest:request];
    [request release];
    [url release];
 
}
 

////把需要分页的视图加入数组
//-(void)addViewToArray{
//    pageViewArray= [[NSMutableArray alloc]init];
//    
//    if(aboutMeController==nil){
//       aboutMeController=[[AboutMeController alloc]initWithNibName:@"AboutMeController"bundle:nil];
//        
//    }
//    rootVierControler= [[RootViewController alloc]init];
//    [pageViewArray addObject:aboutMeController];
//    [pageViewArray addObject:rootVierControler];
//    
//    
//    
//    
//   // scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, appWidth, scrollViewHeight)];
//	scrollView.contentSize = CGSizeMake(appWidth*2, scrollViewHeight);
//	scrollView.contentOffset = CGPointMake(appWidth, 0);
//	scrollView.pagingEnabled = YES;
//	//imageScrollView.backgroundColor = [UIColor blackColor];
//	scrollView.delegate = self;
//    
//	rootVierControler.view.frame = CGRectMake(0, 0, 320, 300);
//	aboutMeController.view.frame = CGRectMake(320, 0, 320, 300);
//	//rightImageView = [[UIImageView alloc]initWithFrame: CGRectMake(320*2, 0, 320, 300)];
//	 
////	leftImageView.image = [imageArray objectAtIndex: [imageArray count]-1];
////	middleImageView.image = [imageArray objectAtIndex: 0];
////	middleImageView.tag = 0;
////	rightImageView.image = [imageArray objectAtIndex: 1];
//    
//	
//	//[scrollView addSubview:rootVierControler.view];
//	[scrollView addSubview:aboutMeController.view];
//	//[self.view addSubview: imageScrollView]; 
//	
//	//pageControl = [[UIPageControl alloc]initWithFrame: CGRectMake(0, 300, 320, 480-320)];
//	pageControl.backgroundColor = [UIColor redColor];
//	pageControl.numberOfPages = pageCount;
//	//[self.view addSubview:pageControl];
//    
//    
// 
//}





//从服务器下载图片
-(void)downLoadImgFromServer{
    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc]init];
    // unionAvertImgName 
    NSURL *adverimgURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",unionAvertImgURL,unionAvertImgName]];
    //  NSURL *adverimgURL=[NSURL URLWithString:@"http://cyber-wise.vicp.net:8080/unionAvert.PNG"];
    NSData *adverimgData= [NSData dataWithContentsOfURL:adverimgURL];
    //UIImageView *unionAdvertImgview=[[UIImageView alloc] initWithImage:[UIImage imageWithData:adverimgData]];
    if ([adverimgData length]==0) {
        
        return;
    }
    
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    //NSData *fileData;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:unionAvertImgName] contents:adverimgData attributes:nil]; 
    //在主线程中调用显示 广告图片的方法
    if ([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:unionAvertImgName]]) {
        
        [self performSelectorOnMainThread:@selector(addaverImg) withObject:nil waitUntilDone:NO];
    } 
    //    
    //    [fm release];
    //    [documentsDirectory release];
    //     
    //    [documentPath release];
    [pool release];
}

//添加广告(显示 doecuemnt下面的广告图片 )
-(void)addaverImg{
    
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    //NSData *fileData;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    NSString *avertImgUrl= [documentsDirectory stringByAppendingPathComponent:unionAvertImgName] ;
    //当 图片不存在的时候
    if ([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:unionAvertImgName]]==NO) {
        return;
    }
    
    
    [UIView beginAnimations:@"movement" context:nil];
    //装载图片
    UIImageView *unionAdvertImgview=[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:avertImgUrl]];
    //动画  点击其他地方的时候不要动
    unionAdvertImgview.alpha=0;
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:unionAdvertImgview cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:2.0f];
    [UIView setAnimationRepeatCount:50];
    [UIView setAnimationRepeatAutoreverses:YES];
    
    unionAdvertImgview.alpha=1;
    [UIView commitAnimations];
    
    //    //反转动画
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration: 1];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:unionAdvertImgview cache:YES];
    
    
    //广告按钮
    UIButton *unionAdvertbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    unionAdvertbutton.frame=CGRectMake(0.0, 368.0,480,48);
    //[unionAdvertbutton setBackgroundImage:unionAdvertImgview2 forState:UIControlStateNormal  ];
    
    [unionAdvertbutton addSubview:unionAdvertImgview];
    
    // [ self.tableView addSubview:button];
    [ self.view addSubview:unionAdvertbutton];
    
    //    [fm release];
    //    [documentsDirectory release];
    //    [avertImgUrl release];
    //    [documentPath release];
    //转至广告页面
    [unionAdvertbutton addTarget:self action:@selector(showAvertHtml) forControlEvents:UIControlEventTouchUpInside];
    
}
//用sfaria打开广告页面
-(void)showAvertHtml{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:unionAvertHtmlURL]];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

////添加apn
//-(IBAction)addApnInfo
//{
//    NSString * initdata=[self readFile:@"serverInfoFile"];
//    //InitInfoController  *initconter=[[InitInfoController alloc]init];
//    UIAlertView *alert;
//    //导航到初始化 页面 如果没有初始化
//    if([initdata length]==0){
//        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                          message:@"请初始化服务器信息..."
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alert show]; 
//        [alert release];
//        [self initServerInfo]; 
//        
//        return;
//    }
//    
//    //NSLog(@"调用添加");
//    if (addapnview==nil) {
//        addapnview=[[NetworkViewController alloc] initWithNibName:@"NetworkViewController" bundle:nil];
//        
//    }
//    
//    unuion03AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
//    // self.navigationController.title=@"新建APN信息";
//    [delegate.navigationController pushViewController:addapnview animated:YES];
//    
//    
//}

//导航到初始化 服务器信息
-(IBAction)initServerInfo{
    if(initInfoController==nil){
        initInfoController=[[InitInfoController alloc]initWithNibName:@"InitInfoController"bundle:nil];
    }
    
//    unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
//    //self.navigationController.title=@"APN参数设置";
//    self.navigationItem.title=@"APN设置";
//    [delegate.navigationController pushViewController:initInfoController animated:YES];
    
}

////导航到关于我们
//-(IBAction)aboutMeView{
//    if(aboutMeController==nil){
//        aboutMeController=[[AboutMeController alloc]initWithNibName:@"AboutMeController"bundle:nil];
//    }
//    unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
//    self.navigationController.title=@"关于我们";
//    self.navigationItem.title=@"APN设置";
//    [delegate.navigationController pushViewController:aboutMeController animated:YES];
//    
//    
//}

//读取文件目录，并列出所有 目录下的文件
-(NSArray *)getDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表 
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    
    NSString *documentDir = [documentPaths objectAtIndex:0]; 
    NSError *error = nil; 
    NSArray *fileList = [[NSArray alloc] init]; 
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组 
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    return fileList;
}

//获取表格的分区
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
//返回表格的高度
-(CGFloat)tableView:(UITableView*)tableView  heightForRowAtIndexPath:(NSIndexPath*)indexPath{ 
    UIImage *buttonUpImage = [UIImage imageNamed:@"button_left.png"];
    if (0 == [indexPath section]) {
        return buttonUpImage.size.height / 4;
    }
    return buttonUpImage.size.height / 2;
};

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    [tableView setBackgroundColor:[UIColor clearColor]];
//    //[tableView setSectionHeaderHeight:30.0];
//    UILabel        *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
////    titleLabel.backgroundColor=[UIColor clearColor];
////    titleLabel.textColor = [UIColor lightGrayColor];
////	titleLabel.highlightedTextColor = [UIColor whiteColor];
////    //titleLabel.textColor=[UIColor purpleColor];//purpleColor
////    titleLabel.font = [UIFont boldSystemFontOfSize:18];
////    titleLabel.frame = CGRectMake(150.0, 10.0, 100.0, 44.0);
//    
//     
//        titleLabel.text=@"";
//    
//    return [titleLabel autorelease];
//}

//加载表格数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self->_tableView setScrollEnabled:FALSE];
    self->_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self->_tableView.backgroundColor = [UIColor clearColor];
    //tableView.frame=CGRectMake(100.0, 60, tableView.frame.size.height,  tableView.frame.size.width);
    UIImageView *backview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainbackImg.png"]];
    //self->_tableView.backgroundView=backview;
    static NSString *SimpleTableIdentifier=@"SimpleTableIdentifier";
    UITableViewCell *cell=[self->_tableView  dequeueReusableCellWithIdentifier:SimpleTableIdentifier ];
    NSUInteger row = [indexPath row];//获取行数
    CGRect rctFrame = self->_tableView.frame;
    CGSize szSize = rctFrame.size;
    //NSUInteger test = tableView.superview.frame;
    if(cell == nil){
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleTableIdentifier] autorelease];
        
        UIView* view = [[[UIView alloc] init] autorelease];
        [cell setBackgroundView:view];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        int iRowBttn;
        iRowBttn = 3;
        if (0 == UIUtil::IsPad()) {
            int szNavBarSize;
            szNavBarSize = self.navigationController.navigationBar.frame.size.height;
            iRowBttn = (szSize.height + szNavBarSize) / 100 - 3;
        }
        if(iRowBttn == row) {
            //[tableView setRowHeight:80.0];
            
            //加按钮//           
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
            //图片 CGRectZero
            UIImage *buttonUpImage = [UIImage imageNamed:@"button_left.png"];
             
            button.frame = CGRectMake(28.0 + szSize.width / 2 - 160, 5.0,100,160);
            [button setBackgroundImage:buttonUpImage forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize: 23 ];
            button.titleLabel.textColor=[UIColor blueColor];
            // [button1 titleLabel
            
            button.tag=1;
            [button addTarget:self action:@selector(readInternetApn) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview :button];      
        
            //中间按钮
            UIButton *midButton = [UIButton buttonWithType:UIButtonTypeCustom];
            midButton.tag=0;
             UIImage *midButtonImage = [UIImage imageNamed:@"button_middle.png"];
             [midButton setBackgroundImage:midButtonImage forState:UIControlStateNormal];
            //midButton.titleLabel.text=@"APNshezhi";
            midButton.frame = CGRectMake(125.0 + szSize.width / 2 - 160, 55.0, 80, 60);
            //[self.view addSubview:midButton];
             [cell.contentView addSubview :midButton];
            [midButton addTarget:self action:@selector(gotoMainApnSeting:) forControlEvents:UIControlEventTouchUpInside];
            
            //右边按钮
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.tag=2;
            UIImage *rightButtonImage = [UIImage imageNamed:@"button_right.png"];
            rightButton.titleLabel.textColor=[UIColor blueColor];
            [rightButton setBackgroundImage:rightButtonImage forState:UIControlStateNormal];
            //midButton.titleLabel.text=@"APNshezhi";
            rightButton.frame = CGRectMake(202.0 + szSize.width / 2 - 160, 5.0, 100, 160);
            //[self.view addSubview:midButton];
            [cell.contentView addSubview :rightButton];
            [rightButton addTarget:self action:@selector(readIntrantApn) forControlEvents:UIControlEventTouchUpInside];
            
//            //加按钮//           
//            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//            //图片
//            UIImage *buttonUpImage1 = [UIImage imageNamed:@"intranet_button.png"];
//            // UIImage *buttonDownImage1 = [UIImage imageNamed:@"button_down.png"];
//            
//            button1.frame = CGRectMake(165.0, 5.0, 130, 60);
//            
//            //        
//            [button1 setBackgroundImage:buttonUpImage1 forState:UIControlStateNormal];
//            //        [button1 setBackgroundImage:buttonDownImage1 forState:UIControlStateHighlighted];
//            // [button1 setTitle:@"内网"  forState:UIControlStateNormal];
//            
//            button1.titleLabel.font = [UIFont boldSystemFontOfSize: 23 ];
//            button1.titleLabel.textColor=[UIColor blueColor];
//            button1.tag=1;
//            [button1 addTarget:self action:@selector(openIntrantFile) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview :button1];
            
            // cell.accessoryView=  button1;
        }
        
        
//        //加一个 帮助信息按钮
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
//        //图片
//        // UIImage *buttonUpImage = [UIImage imageNamed:@"about.png"];
//        // UIImage *buttonDownImage = [UIImage imageNamed:@"button_down.png"];
//        
//        button.frame = CGRectMake(263.0, 317.0,20,20);
//        
//        [ self.tableView addSubview:button];
//        //转到帮助页面
//        [button addTarget:self action:@selector(aboutMeView) forControlEvents:UIControlEventTouchUpInside];
        
//        
//        [self.tableView addSubview:avertWebView];
//        [self loadAvertWebView];
    }
    
    return cell;
}
//转到APN设置
-(IBAction)gotoMainApnSeting:(id)sender{
   
    UIButton *btn = sender;
    
    if(mainAPNcontroller==nil){
        mainAPNcontroller=[[MainApnSetController alloc]init];
    }
    [mainAPNcontroller viewWillAppear:YES];
    //[mainAPNcontroller viewDidLoad];
    if (btn.tag==0) {
          
        [mainAPNcontroller setDefaultSegmentValue:0];
    }
    if (btn.tag==2) {
        
        [mainAPNcontroller setDefaultSegmentValue:1];
    }
    
    
   // self.navigationItem.title=@"APN设置";
    [self.navigationController pushViewController:mainAPNcontroller animated:YES];
}

//导航到设备系统信息
-(IBAction)aboutMeView{
    //self.navigationController.navigationBarHidden = YES;
    if(ViewControllerSysInfo==nil){
        ViewControllerSysInfo=[[SysInfoViewController alloc]initWithNibName:@"SysInfoViewController"bundle:nil];
    }
  //  unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    ViewControllerSysInfo.title = @"关于我们";
    //ViewControllerSysInfo.navigationItem.hidesBackButton = YES;
    //self.navigationItem.hidesBackButton = YES;
    
  //  [self setTransform:CGAffineTransformMake(-1,0,0,1,self.frame.size.width,0)]]; 
    [self.navigationController pushViewController:ViewControllerSysInfo animated:YES];
    //[aboutMeController release];
     //  [self presentModalViewController:aboutMeController animated:YES]; //以模式窗体的形式弹出
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration: 1];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:self.navigationController.view cache:YES];
//    
//    [[self navigationController] pushViewController:aboutMeController animated:NO];
//    //[self presentModalViewController:aboutMeController animated:NO];
//    [UIView commitAnimations];
    
    
    
}
//打开公网
-(IBAction)openInternetFile{
    
    SysInfoViewController *sysView=[[SysInfoViewController alloc]init];
    [ self.navigationController pushViewController:sysView animated:YES];

//    if(internetController==nil){
//        internetController=[[InternetViewController alloc]initWithNibName:@"InternetViewController"bundle:nil];
//    }
//    unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
//    self.navigationController.title=@"公网APN设置";
//    //self.navigationItem.title=@"APN设置";
//    
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration: 1];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:self.navigationController.view cache:YES];
//    [delegate.navigationController pushViewController:internetController animated:YES];
//    // [[self navigationController] pushViewController:aboutMeController animated:NO];
//    //[self presentModalViewController:aboutMeController animated:NO];
//    [UIView commitAnimations];
    //设置当前APN
    // [self setCurrentAPN:@"当前APN配置:公网"];
    
}

//打开内网    
-(void)openIntrantFile{
    
    
    if(intrantViewController==nil){
        intrantViewController=[[IntranetViewController alloc]initWithNibName:@"IntranetViewController"bundle:nil];
    }
//    unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
//    self.navigationController.title=@"内网APN设置";
//    //self.navigationItem.title=@"APN设置";
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:1];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
//    [delegate.navigationController pushViewController:intrantViewController animated:YES];
//    [UIView commitAnimations];
    
    //设置当前APN
    //[self setCurrentAPN:@"当前APN配置:专网"];
}


////当点击 开关按钮时 发动信息到服务器
//-(void)switchChanged:(id)sender{
//    UISwitch *switchControl=sender;
//    @try{
//        //把行的值赋给 editApninfo 当点击开关时处理 数据信息
//        editApninfo=[apnInfoArray objectAtIndex:switchControl.tag];
//    }@catch(NSException *e){
//        UIAlertView *
//        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                          message:@"请检查您填写的apn"
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alert show]; 
//        [alert release];
//    }
//    
//    //重发对象
//    reSendAPN=[apnInfoArray objectAtIndex:switchControl.tag];
//    //连接服务器 并传输数据
//    resendAPNcount=NO;
//    if(switchControl.on){
//        count=0;
//        errorCount=0;
//        UIAlertView *alert;
//        //检测 当前网络 如果没得 网络 直接返回
//        if([self checkInternet]==0){
//            //  NSLog(@"进入无网络判断");
//            alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                              message:@"当前无可用的网络，请检查手机网络配置"
//                                             delegate:self
//                                    cancelButtonTitle:@"OK"   
//                                    otherButtonTitles:nil];
//            [alert show]; 
//            [switchControl setOn:NO animated:NO];
//            return;
//        }
//        //防止 反复重发
//        resendAPNcount=YES;
//        //连接服务器
//        //[self connectionToserver:editApninfo.apn];
//        //调用连接 服务器
//        [self connectiontoserverbyasysocket:editApninfo.apn];
//    }
//    //读取文件内容 ，当用户修改状态后再写回去
//    //获取当前点击开关那行的文件名
//    NSMutableString *fileName=[NSMutableString stringWithString:@"apninfo_"];
//    [fileName appendString:editApninfo.apn];
//    
//    NSString *data=[self readFile:fileName];
//    
//    NSMutableString *fix=[NSMutableString stringWithString:@"λ"];
//    
//    NSRange subRange=[data rangeOfString:fix];
//    //处理其它的文件 apn数据状态
//    NSArray *ortherfileNames;
//    ortherfileNames=[self getDirectory];//获取所有的文件名 广州挟制α127.0.0.1βliangchunγ875544
//    //apnInfoArray=[[NSMutableArray alloc]init];
//    if(switchControl.on){
//        if([ortherfileNames count]>0){
//            for(int i=0;i<[ortherfileNames count];i++){
//                if([[ortherfileNames objectAtIndex:i] hasPrefix:@"apninfo_"]){
//                    // data=  [netWork readFile:[fileName objectAtIndex:i]];
//                    NSString *data=[self readFile:[ortherfileNames objectAtIndex:i]];
//                    NSRange subRange=[data rangeOfString:fix];
//                    //读取 原有的数据
//                    NSString *leftData=[[data substringFromIndex:0] substringToIndex:subRange.location ];
//                    //拼装内容 重新写入文件
//                    NSMutableString *apnContent=[NSMutableString stringWithString:leftData];
//                    [apnContent appendString:@"λ"];
//                    [apnContent appendString:switchControl.on?@"NO":@"YES"];
//                    [self writeFile:apnContent fileName:[ortherfileNames objectAtIndex:i]];
//                    
//                }
//            }
//        }
//    }
//    //读取 原有的数据
//    NSString *leftData=[[data substringFromIndex:0] substringToIndex:subRange.location ];
//    //拼装内容 重新写入文件
//    NSMutableString *apnContent=[NSMutableString stringWithString:leftData];
//    [apnContent appendString:@"λ"];
//    [apnContent appendString:switchControl.on?@"YES":@"NO"];
//    [self writeFile:apnContent fileName:fileName];
//    
//    
//    //重新加载 数据
//    [self readApnInfoForTable];
//    [self.tableView reloadData];
//    
//    [editApninfo release];
//    
//}
//检测 当前 网络
//-(BOOL)checkInternet{
//    // Reachability *r=[Reachability re
//    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus==NotReachable)&&([Reachability reachabilityForLocalWiFi].currentReachabilityStatus==NotReachable)   ) {
//        return NO;
//    }
//    return YES;
//}


//把apn信息写入缓冲流
//-(void) writeToServer:(const uint16_t *) buf {
//    //[oStream write:buf maxLength:strlen((char *)buf)];    
//    [oStream write:buf maxLength:sendApnContentLength]; 
//    
//}

////异步连接服务器
//-(void)connectiontoserverbyasysocket:(NSString*)apn{
//    //获取 iphone 唯一的uuid
//    
//    NSString *ipPortData=[self readFile:@"serverInfoFile"];
//    UIAlertView *alert;
//    if([ipPortData length]==0){
//        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                          message:@"请初始化服务器信息..."
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alert show]; 
//        [alert release];
//        //导航到初始化页面
//        [self initServerInfo];        
//        return;
//    }
//    //132.145.65.88α9014β1γ5λ192.168.1.100  (新初始化信息结构)
//    //截取  
//    NSString *fix=@"α";
//    NSString *fix1=@"β";
//    NSString *fix2=@"λ";
//    //从文件中读取ip和端口
//    NSString *ip;  //外网ip
//    NSString *intrantIp;//内网IP
//    NSString *port;//端口
//    
//    NSRange  subRange=[ipPortData rangeOfString:fix];
//    NSRange subRange1=[ipPortData rangeOfString:fix1];
//    NSRange subRange2=[ipPortData rangeOfString:fix2];
//    //外网ip
//    ip=[[ipPortData substringFromIndex:0] substringToIndex:subRange.location];
//    //内网ip
//    intrantIp=[ipPortData substringFromIndex:subRange2.location+1];
//    //端口
//    port=[[ipPortData substringFromIndex:subRange.location+1] substringToIndex:subRange1.location-1-subRange.location];
//    
//    NSError *err = nil;
//    if ([editApninfo.apn isEqualToString:@"3gnet"] || [editApninfo.apn isEqualToString:@"3gwap"]) {
//        // NSLog(@"---------------连接内网%@",intrantIp);
//        [asyncSocket connectToHost:intrantIp onPort:[port integerValue] withTimeout:4.0  error:&err];
//    }else{
//        // NSLog(@"---------------连接外网%@",ip);
//        [asyncSocket connectToHost:ip onPort:[port integerValue] withTimeout:4.0  error:&err];
//    }
//}
//
//当连接上服务器时调用
//- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port 
//{ 
//    //处理用户随便输入的ip 如:11.22?.45,56 手机会转换成如下IP
//    NSString *validIP=@"220.250.64.24";
//    if([host isEqualToString:validIP]){
//        UIAlertView *
//        alert= [[UIAlertView alloc] initWithTitle:@"服务器无法连接" 
//                                          message:@"请填写正确的服务器ip及端口"
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alert show]; 
//        [alert release];
//        
//        [sock disconnect];
//        if(initInfoController==nil){
//            //导航到初始化页面
//            [self initServerInfo]; 
//        }
//        return;
//    }
//    
//    //获取设备的udid
//    UIDevice *device=[UIDevice currentDevice];
//    NSString *uniqueID=[device uniqueIdentifier];
//    
//    NSMutableString *sendContent=[NSMutableString stringWithString:uniqueID ]; 
//    [sendContent appendString:@";"];
//    if ([editApninfo.apn length]>0) {
//        [sendContent appendString:editApninfo.apn];
//    }
//    
//    [sendContent appendString:@";"];  
//    
//    //获取发送内容的长度    
//    sendApnContentLength=[sendContent length];
//    NSData* aData = [sendContent dataUsingEncoding: NSUTF8StringEncoding];
//    //写入数据
//    [sock writeData:aData withTimeout:-1 tag:1];
//    //读取数据
//    
//    [sock readDataWithTimeout:-1 tag:0]; 
//    // NSLog(@"-----------------------连接成功-----读取数据%@",responseInfo);
//    
//} 
//读取数据
//-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag 
//{ 
//    
//    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
//    //把响应信息赋给 全局变量
//    responseInfo=[NSMutableString stringWithString:aStr];
//    
//    //如果 有正常的数据 
//    if([responseInfo length] >0){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功发送APN数据" 
//                                                        message:@"服务器已收到APN数据,请等待修改APN。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK" 
//                                              otherButtonTitles:nil];
//        [alert show];
//        
//        [alert release];
//        
//    }
//    
//    [aStr release]; 
//    if(sock!=nil){
//        [sock disconnect];
//    }
//    //[sock readDataWithTimeout:-1 tag:0];
//} 
//- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag 
//{ 
//    // NSLog(@"onSocket:%p didSecure:YES", sock); 
//} 
//
//处理重发
//- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err 
//{ 
//    
//    responseInfo=[NSMutableString stringWithString:@"novalue"];
//    
//    if ([responseInfo length]<=0 || [responseInfo isEqualToString:@"novalue"]) {
//        //responseInfo=[[NSMutableString alloc] initWithString:@"novalue"];
//        if (resendAPNcount == YES ) {  
//            [self NstimerApn];
//            
//            resendAPNcount=NO;
//        }
//        errorCount++;//错误次数
//        if ((errorCount-1)==count || errorCount ==2) {
//            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"服务器无法连接"
//                                                             message:@"请检查IP和端口及服务器监听是否开启" 
//                                                            delegate:self
//                                                   cancelButtonTitle:@"OK" 
//                                                   otherButtonTitles:nil];
//            [alert1 show];
//            [alert1 release];
//            if(initInfoController==nil){
//                //导航到初始化页面
//                [self initServerInfo]; 
//            }
//        }
//    }
//    if(sock!=nil){
//        [sock disconnect];
//    }
//    //调用重发
//} 
//- (void)onSocketDidDisconnect:(AsyncSocket *)sock 
//{ 
//    //断开连接了 
//    // NSLog(@"------------连接断开------------------"); 
//} 

//连接服务器 (cfstream)
//-(void)connectionToserver:(NSString *)apn{
//    
//    //获取 iphone 唯一的uuid
//    UIDevice *device=[UIDevice currentDevice];
//    NSString *uniqueID=[device uniqueIdentifier];
//    
//    NSString *ipPortData=[self readFile:@"serverInfoFile"];
//    UIAlertView *alert;
//    if([ipPortData length]==0){
//        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                          message:@"请初始化服务器信息..."
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alert show]; 
//        [alert release];
//        //导航到初始化页面
//        [self initServerInfo];
//        
//        return;
//    }
// 
//    
//    //截取  
//    NSString *fix=@"α";
//    NSString *fix1=@"β";
//    NSString *fix2=@"λ";
//    //从文件中读取ip和端口
//    NSString *ip;  //外网ip
//    NSString *intrantIp;//内网IP
//    NSString *port;//端口
//    
//    NSRange  subRange=[ipPortData rangeOfString:fix];
//    NSRange subRange1=[ipPortData rangeOfString:fix1];
//    NSRange subRange2=[ipPortData rangeOfString:fix2];
//    //外网ip
//    ip=[[ipPortData substringFromIndex:0] substringToIndex:subRange.location];
//    //内网ip
//    intrantIp=[ipPortData substringFromIndex:subRange2.location+1];
//    //端口
//    port=[[ipPortData substringFromIndex:subRange.location+1] substringToIndex:subRange1.location-1-subRange.location];
//    
//    //当用户连接到外网时
//    if ([editApninfo.apn isEqualToString:@"3gnet"] || [editApninfo.apn isEqualToString:@"3gwap"]) {
//        [self connectToServerUsingCFStream:intrantIp portNo:[port integerValue]];
//    }
//    
//    //调用连接服务器的方法 218.107.54.247
//    [self connectToServerUsingCFStream:ip portNo:[port integerValue]];
//    
//    NSMutableString *sendContent=[NSMutableString stringWithString:uniqueID ]; 
//    [sendContent appendString:@";"];
//    if ([apn length]>0) {
//        [sendContent appendString:apn];
//    }
//    
//    [sendContent appendString:@";"];
//    //获取发送内容的长度
//    
//    sendApnContentLength=[sendContent length];
//    
//    const uint16_t *str =
//    (uint16_t *) [sendContent cStringUsingEncoding:NSASCIIStringEncoding];
//    //写入缓冲流
//    [self writeToServer:str];
//    
//}

////用cfstream 链接服务器
//-(void) connectToServerUsingCFStream:(NSString *) urlStr portNo: (uint) portNo {
//    if (![urlStr isEqualToString:@""]) {
//        NSURL *website = [NSURL URLWithString:urlStr];
//        if (!website) {
//            //NSLog(@"is not a valid URL");
//            return;
//        } 
//    }
//    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
//                                       (CFStringRef) urlStr,
//                                       portNo,
//                                       &readStream,
//                                       &writeStream);
//    if (readStream && writeStream) {
//        CFReadStreamSetProperty(readStream,
//                                kCFStreamPropertyShouldCloseNativeSocket,
//                                kCFBooleanTrue);
//        CFWriteStreamSetProperty(writeStream,
//                                 kCFStreamPropertyShouldCloseNativeSocket,
//                                 kCFBooleanTrue);
//        iStream = (NSInputStream *)readStream;
//        [iStream retain];
//        [iStream setDelegate:self];
//        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
//                           forMode:NSDefaultRunLoopMode];
//        [iStream open];
//        oStream = (NSOutputStream *)writeStream;
//        [oStream retain];
//        [oStream setDelegate:self];
//        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
//                           forMode:NSDefaultRunLoopMode];
//        [oStream open];   
//        
//        
//        
//    }
//    
//}

////链接服务器
//-(void) connectToServerUsingStream:(NSString *)urlStr
//                            portNo: (uint) portNo {
//    if (![urlStr isEqualToString:@""]) {
//        NSURL *website = [NSURL URLWithString:urlStr];
//        if (!website) {
//           // NSLog(@" is not a valid URL");
//            return;
//        } else {
//            
//            [NSStream getStreamsToHostNamed:urlStr
//                                       port:portNo
//                                inputStream:&iStream
//                               outputStream:&oStream];  
//            
//            [iStream retain];
//            [oStream retain];
//            [iStream setDelegate:self];
//            [oStream setDelegate:self];
//            
//            [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
//                               forMode:NSDefaultRunLoopMode];
//            [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
//                               forMode:NSDefaultRunLoopMode];
//            [oStream open];
//            [iStream open];            
//        }
//    }    
//}
////点击 手机的 返回 主页面按钮时调用
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{  
//    // [self disconnect];
//    count=0;
//    errorCount=0;
//}
////关闭输入输出流
//-(void) disconnect {
//    
//    [iStream close];
//    
//    [oStream close];
//    
//}


////定时发送apn
//- (void) handleTimerSendApn: (NSTimer *) timer{
//    //连接服务器
//    //[self connectionToserver:reSendAPN.apn];
//    [self connectiontoserverbyasysocket:reSendAPN.apn];
//}

////执行apn 发送
//-(void)NstimerApn{
//    
//    if (responseInfo==nil) {
//        responseInfo=[[NSMutableString alloc] init];
//    }
//    //当服务器 开后又停止
//    //当 服务器返回信息为空时 处理重发
//    if ([responseInfo length]<=0 || [responseInfo isEqualToString:@"novalue"]) {
//        NSString *ipPortData=[self readFile:@"serverInfoFile"];
//        UIAlertView *alert;
//        if([ipPortData length]==0){
//            alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                              message:@"请初始化服务器信息..."
//                                             delegate:self
//                                    cancelButtonTitle:@"OK"   
//                                    otherButtonTitles:nil];
//            [alert show]; 
//            //导航到初始化页面
//            [self initServerInfo];
//            
//            return;
//        }
//        
//        //截取  
//        // 132.145.65.88 α 9014 β 1 γ 5 λ 192.168.1.100 （新初始化文件的结构）
//        NSString *fix1=@"β";
//        NSString *fix2=@"γ";
//        NSString *fix3=@"λ";
//        
//        NSString *recount;//重发次数
//        NSString *retime;//重发间隔时间
//        NSRange subRange1=[ipPortData rangeOfString:fix1];
//        NSRange subRange2=[ipPortData rangeOfString:fix2];
//        NSRange subRange3=[ipPortData rangeOfString:fix3];
//        //获取 文件中的 重发次数和 重发间隔时间
//        recount=[[ipPortData substringFromIndex:subRange1.location+1] substringToIndex:subRange2.location-1-subRange1.location];
//        retime=[[ipPortData substringFromIndex:subRange2.location+1] substringToIndex:subRange3.location-1-subRange2.location];
//        // NSLog(@"重发次数－－－－－－%@",recount);
//        // NSLog(@"重发间隔---------%@",retime);
//        
//        count=[recount intValue];//次数
//        
//        if(count>5)
//            count=5;
//        int times=[retime intValue];//间隔时间
//        if(times==0 || times>5)
//            times=2;
//        
//        if(count>0){
//            NSTimer *timer;
//            for(int i=0;i<1;i++){
//                if ([responseInfo length]<=0 || [responseInfo isEqualToString:@"novalue"]) {
//                    //NSLog(@"----------重发-responseInfo-----------%@",responseInfo);
//                    // NSLog(@"----------重发------------%d",i);
//                    timer = [NSTimer scheduledTimerWithTimeInterval: times
//                                                             target: self
//                                                           selector: @selector(handleTimerSendApn:)
//                                                           userInfo: nil
//                                                            repeats: NO];
//                    
//                }
//                
//                
//            }
//        }
//        
//        
//    }
//    
//}
//


//当有输入流产生时，响应服务器
//-(void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
//    switch(eventCode) {
//        case NSStreamEventHasBytesAvailable:
//        {
//            if (data == nil) {
//                data = [[NSMutableData alloc] init];
//            }
//            
//            @try {
//                uint16_t buf[1024];
//                unsigned   int len = 0;
//                
//                
//                len = [(NSInputStream *)stream read:buf maxLength:1024];
//                if(len>=1 && len <100) 
//                    
//                {    
//
//
//                    [data appendBytes:(const void *)buf length:len];
//     
//                    int bytesRead;
//                    bytesRead += len;
//                }
//            }
//            @catch (NSException *exception) {
//                [self disconnect];
//                
//            }
//            
//            NSString *str = [[NSString alloc] initWithData:data
//                                                  encoding:NSUTF8StringEncoding];
//            responseInfo=[NSMutableString stringWithString:str];//把响应信息赋给 全局变量
//            //NSLog(@"服务器数据 %@",responseInfo);
//            //如果 有正常的数据 
//            if([str length] >0){
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功发送APN" 
//                                                                message:@"服务器已收到APN数据，等待修改..."
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK" 
//                                                      otherButtonTitles:nil];
//                [alert show];
//                [alert release];
//            }
//            
//            [str release];
//            [data release];
//            data = nil;
//            [self disconnect];
//            
//        } 
//            break;
//        case NSStreamEventEndEncountered://连接断开或结束
//        {
//            //NSLog(@"----//连接断开或结束");
//            [self disconnect];
//            
//        }
//            break;
//        case NSStreamEventErrorOccurred://无法连接或断开连接
//        {
//            
//            responseInfo=[[NSMutableString alloc] initWithString:@"novalue"];
//            if (resendAPNcount == 1 ) {  
//                [self NstimerApn];
//                
//                resendAPNcount=NO;
//            }
//            errorCount++;//错误次数
//           // NSLog(@"NSStreamEventErrorOccurrederrorCount－－－－－－－－－－－－－%d",errorCount);
//            //NSLog(@"NSStreamEventErrorOccurredcount－－－－－－－－－－－－－%d",count);
//            if ((errorCount-1)==count) {
//                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"错误消息"
//                                                                 message:@"服务器无法连接,请检查..." 
//                                                                delegate:self
//                                                       cancelButtonTitle:@"OK" 
//                                                       otherButtonTitles:nil];
//                [alert1 show];
//                [alert1 release];
//            }
//            
//            
//            //调用重发
//            //  int count=[resendAPNcount.  ];
//           // NSLog(@"resendAPNcount---%d",resendAPNcount);
//            
//            [self disconnect];
//            
//        }
//            break;
//            
//        case NSStreamEventOpenCompleted:
//        {
//            
//            
//        }
//        break;
//        case NSStreamEventNone:
//        {
//            [self disconnect];
//            
//        }
//            
//        break;
//            
//    }
//}


////读取 APN
//-(NSString *)readFile:(NSString *)RfileName
//{
//    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
//    
//    NSString *apnContent=nil;
//    NSFileManager *fm=[ NSFileManager defaultManager];
//    
//    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:RfileName]]==YES){
//        apnContent=[NSString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:RfileName] encoding:NSUTF8StringEncoding error:nil];
//    } else{
//        apnContent=@"";
//    }
//    
//    [fm release];
//    return apnContent;
//    
//}


////写入文件 把apn信息
-(void)writeFile:(NSMutableString *)apnContent fileName:(NSString *)filename{
    
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    NSData *fileData;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    NSMutableString *data=[[NSMutableString alloc] initWithString:apnContent];
    
    fileData=[[data dataUsingEncoding:NSUTF8StringEncoding] retain];
    
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:filename] contents:fileData attributes:nil]; 
    
}


//-(UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellAccessoryDetailDisclosureButton;
//}

//导航 点击箭头进入编辑界面

//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//    if (editApnInfoController==nil) {
//        editApnInfoController=[[EditApnInfoController alloc] initWithNibName:@"NetworkViewController" bundle:nil];
//    }
//    editApnInfoController.title==@"添加apn信息";
//    
//    editApninfo=[apnInfoArray objectAtIndex:indexPath.row];
//    editApnInfoController.apninfo=editApninfo;
//    
//    NSLog(@"----apnDesc",editApnInfoController.apninfo.apnDesc);
//    NSLog(@"----apn",editApnInfoController.apninfo.apn);
//    NSLog(@"----user",editApnInfoController.apninfo.user);
//    NSLog(@"----pwd",editApnInfoController.apninfo.pwd);
//    NSLog(@"-------status",editApnInfoController.apninfo.status);
//    unuion03AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
//    
//    [delegate.navigationController pushViewController:editApnInfoController animated:YES];
//}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

////删除
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    ApnInfo *deleteApninfo;//编辑对象
//    deleteApninfo=[apnInfoArray objectAtIndex:indexPath.row];
//    //editApnInfoController.apninfo=editApninfo;
//    if(editingStyle==UITableViewCellEditingStyleDelete){
//        [apnInfoArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    
//    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    //NSData *fileData;
//    NSFileManager *fm=[ NSFileManager defaultManager];
//    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
//    
//    //删除原来的文件
//    NSMutableString *deleteFileName;
//    deleteFileName=[[NSMutableString alloc]initWithString:@"apninfo_"];
//    [deleteFileName appendString:deleteApninfo.apn];
//    
//    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:deleteFileName]]==YES){
//        [fm removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:deleteFileName] error:nil];
//        
//    }
//    //update 2011-6-29
//    [self.tableView reloadData];
//   // [self tableView reloadData];
//    
//}
////当 当前行是 联通apn 不显示删除按钮
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ApnInfo *deleteApninfo;//编辑对象
//    deleteApninfo=[apnInfoArray objectAtIndex:indexPath.row];
//    //
//    if([deleteApninfo.apn isEqualToString:@"3gnet" ]){
//        return UITableViewCellEditingStyleNone;
//    }
//    
//    return UITableViewCellEditingStyleDelete;
//}


//// 选中行进入编辑页面
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editApnInfoController==nil) {
//        editApnInfoController=[[EditApnInfoController alloc] initWithNibName:@"EditApnInfoController" bundle:nil];
//    }
//    // editApnInfoController.title==@"添加apn信息";
//    
//    editApninfo=[apnInfoArray objectAtIndex:indexPath.row];
//    editApnInfoController.apninfo=editApninfo;
//    
//    
//    
//    unuion03AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
//    
//    [delegate.navigationController pushViewController:editApnInfoController animated:YES];
//    
//}
//

//读取apn信息 显示在表格中，保存规则——》descn α apn β user γ pwd λ status
-(void)readApnInfoForTable{
    //截取  
    NSString *data;
    NSMutableString *fix1=[NSMutableString stringWithString: @"α"];
    NSMutableString *fix2=[NSMutableString stringWithString:@"β"];
   // NSMutableString *fix3=[NSMutableString stringWithString:@"γ"];
    NSMutableString *fix4=[NSMutableString stringWithString:@"λ"];
    
    
    NetworkViewController *netWork=[[NetworkViewController alloc]init];
    NSArray *fileName;
    fileName=[self getDirectory];//获取所有的文件名 广州挟制α127.0.0.1βliangchunγ875544
    apnInfoArray=[[NSMutableArray alloc]init];
    if([fileName count]>0){
        for(int i=0;i<[fileName count];i++){
            if([[fileName objectAtIndex:i] hasPrefix:@"apninfo_"] || [[fileName objectAtIndex:i] hasPrefix:@"internet_"]){
                data=  [netWork readFile:[fileName objectAtIndex:i]];
                NSRange subRange1=[data rangeOfString:fix1];
                NSRange subRange2=[data rangeOfString:fix2];
               // NSRange subRange3=[data rangeOfString:fix3];
                NSRange subRange4=[data rangeOfString:fix4];
               // NSString *apndesc=[[data substringFromIndex:0] substringToIndex:subRange1.location];
                NSString *apnname=[[data substringFromIndex:subRange1.location+1] substringToIndex:subRange2.location-1-subRange1.location];
                
               // NSString *username=[[data substringFromIndex:subRange2.location+1] substringToIndex:subRange3.location-subRange2.location-1];
                
               // NSString *pwd=[[data substringFromIndex:subRange3.location+1] substringToIndex:
                 //              subRange4.location-subRange3.location-1    ];
                NSString *status=[data substringFromIndex:subRange4.location+1 ];
                
                //                ApnInfo *apninfo=[[ApnInfo alloc] init];
                //                //存入apn类
                //                apninfo.apnDesc=apndesc;
                //                apninfo.apn=apnname;
                //                apninfo.user=username;
                //                apninfo.pwd=pwd;
                //                apninfo.status=status;
                if (apnname!=nil) {
                    if ([apnname isEqualToString:@"3gwap"]||[apnname isEqualToString:@"3gnet"]) {
                        if ([status isEqualToString:@"YES"]) {
                            [self setCurrentAPN:@"当前APN配置:公网"];
                        }
                        
                    }else{
                        if ([status isEqualToString:@"YES"]) {
                            [self setCurrentAPN:@"当前APN配置:专网"];
                        }
                    }
                }
                
                //NSLog(@"----------%@-------apninfo.status----",apninfo.status);
                //  [apnInfoArray addObject:apninfo];
            }
        }
    }
}

//读取 公网默认APN
-(void)readInternetApn{
    NSString *setAPN=[[NSString alloc]init];
    NSString *currentAPNdesc=[[NSString alloc]init];
    //截取  
    NSString *data;
    NSMutableString *fix1=[NSMutableString stringWithString: @"α"];
    NSMutableString *fix2=[NSMutableString stringWithString:@"β"];
   // NSMutableString *fix3=[NSMutableString stringWithString:@"γ"];
    NSMutableString *fix4=[NSMutableString stringWithString:@"λ"];
    NSMutableString *fix5=[NSMutableString stringWithString:@"μ"];
    NetworkViewController *netWork=[[NetworkViewController alloc]init];
    NSArray *fileName;
    fileName=[self getDirectory];//获取所有的文件名 广州挟制α127.0.0.1βliangchunγ875544
    apnInfoArray=[[NSMutableArray alloc]init];
    if([fileName count]>0){
        for(int i=0;i<[fileName count];i++){
            if([[fileName objectAtIndex:i] hasPrefix:@"internet_"]){
                data=  [netWork readFile:[fileName objectAtIndex:i]];
                NSRange subRange1=[data rangeOfString:fix1];
                NSRange subRange2=[data rangeOfString:fix2];
                // NSRange subRange3=[data rangeOfString:fix3];
                NSRange subRange4=[data rangeOfString:fix4];
                NSRange subRange5=[data rangeOfString:fix5];
                NSString *apndesc=[[data substringFromIndex:0] substringToIndex:subRange1.location];
                NSString *apnname=[[data substringFromIndex:subRange1.location+1] substringToIndex:subRange2.location-1-subRange1.location];
                NSString *status=[[data substringFromIndex:subRange4.location+1] substringToIndex:subRange5.location-1-subRange4.location];
               
                if (apnname!=nil && ![apnname isEqualToString:@""]) {
                        if ([status isEqualToString:@"YES"]) {
                            setAPN=apnname;
                            currentAPNdesc= apndesc;
                        }
                      
                }
                
     
            }
        }
    }
    
    if (setAPN !=nil && ![setAPN isEqualToString:@""]) {
        NSMutableString *apnConfigName=[[NSMutableString alloc]initWithString:setAPN];
        [apnConfigName appendString:@".mobileconfig"];
        
        // 判断初始化文件是否存在
        NSFileManager *fm=[ NSFileManager defaultManager];
        NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
        //如果当前APN已被删除
        if (![fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:apnConfigName]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                            message:@"当前apn已被删除"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"   
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
            
        } 
         
        //将当前切换的APN写入文件，
        //InternetAPNFileContent、 CurrentAPNFileName 定义在 SysInfoViewController.h 头部
        NSMutableString *currentApnFileContent=[[NSMutableString alloc]initWithString:InternetAPNFileContent];
        if (currentAPNdesc !=nil && ![currentAPNdesc isEqualToString:@""]) {
            [currentApnFileContent appendFormat:@"(%@)",currentAPNdesc];
        }
        [self writeFile:currentApnFileContent fileName:CurrentAPNFileName];
        [currentApnFileContent release];
 
        
       
        //mcdmAppDelegate* appDelegaet=[[mcdmAppDelegate alloc]init];
        //切换APN
        [self openSafari:apnConfigName];//打开页面
        //[appDelegaet openSafari:apnConfigName];//打开页面
//        [appDelegaet release];
//        [apnConfigName release];
//        
//        [fm release];
//        [documentsDirectory release];
//        [documentPath release];
    }else{
    
        [self gotoMainApnSeting2:0];
         
    }
    
    // [setAPN release];
    
    
    
}


//读取 专网默认APN
-(void)readIntrantApn{
    NSString *setAPN=[[NSString alloc]init];
    NSString *currentAPNdesc=[[NSString alloc]init];
    //截取  
    NSString *data;
    NSMutableString *fix1=[NSMutableString stringWithString: @"α"];
    NSMutableString *fix2=[NSMutableString stringWithString:@"β"];
    //NSMutableString *fix3=[NSMutableString stringWithString:@"γ"];
    NSMutableString *fix4=[NSMutableString stringWithString:@"λ"];
    NSMutableString *fix5=[NSMutableString stringWithString:@"μ"];
    
    NetworkViewController *netWork=[[NetworkViewController alloc]init];
    NSArray *fileName;
    fileName=[self getDirectory];//获取所有的文件名 广州挟制α127.0.0.1βliangchunγ875544
    apnInfoArray=[[NSMutableArray alloc]init];
    if([fileName count]>0){
        for(int i=0;i<[fileName count];i++){
            if([[fileName objectAtIndex:i] hasPrefix:@"apninfo_"]){
                data=  [netWork readFile:[fileName objectAtIndex:i]];
                NSRange subRange1=[data rangeOfString:fix1];
                NSRange subRange2=[data rangeOfString:fix2];
                // NSRange subRange3=[data rangeOfString:fix3];
                NSRange subRange4=[data rangeOfString:fix4];
                NSRange subRange5=[data rangeOfString:fix5];
                  NSString *apndesc=[[data substringFromIndex:0] substringToIndex:subRange1.location];
                NSString *apnname=[[data substringFromIndex:subRange1.location+1] substringToIndex:subRange2.location-1-subRange1.location];
                
                // NSString *username=[[data substringFromIndex:subRange2.location+1] substringToIndex:subRange3.location-subRange2.location-1];
                
                // NSString *pwd=[[data substringFromIndex:subRange3.location+1] substringToIndex:
                //              subRange4.location-subRange3.location-1    ];
                NSString *status=[[data substringFromIndex:subRange4.location+1] substringToIndex:subRange5.location-1-subRange4.location ];
                
                //                ApnInfo *apninfo=[[ApnInfo alloc] init];
                //                //存入apn类
                //                apninfo.apnDesc=apndesc;
                //                apninfo.apn=apnname;
                //                apninfo.user=username;
                //                apninfo.pwd=pwd;
                //                apninfo.status=status;
                if (apnname!=nil && ![apnname isEqualToString:@""]) {
                        if ([status isEqualToString:@"YES"]) {
                            setAPN=apnname;
                            currentAPNdesc=apndesc;
                        }
                }
                
                
            }
        }
    }
   // NSLog(@"setAPNsetAPNsetAPNsetAPN====%@",setAPN);
    
    if (setAPN !=nil && ![setAPN isEqualToString:@""]) {
       //  NSLog(@"[appDelegaet openSafari:apnConfigName]111");
        
        
        
        NSMutableString *apnConfigName=[[NSMutableString alloc]initWithString:setAPN];
        [apnConfigName appendString:@".mobileconfig"];
        
        // 判断初始化文件是否存在
        NSFileManager *fm=[ NSFileManager defaultManager];
        NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
        //如果当前APN已被删除
        if (![fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:apnConfigName]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                            message:@"当前apn已被删除"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"   
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
            
        } 
          
         //把当前APN写入文件
        NSMutableString *currentApnFileContent=[[NSMutableString alloc]initWithString:intrantAPNFileContent];
        if (currentAPNdesc !=nil && ![currentAPNdesc isEqualToString:@""]) {
            [currentApnFileContent appendFormat:@"(%@)",currentAPNdesc];
        }
        [self writeFile:currentApnFileContent fileName:CurrentAPNFileName];
        [currentApnFileContent release];
        //[currentAPNdesc release];
        //mcdmAppDelegate* appDelegaet=[[mcdmAppDelegate alloc]init];
        //切换APN
        [self openSafari:apnConfigName];//打开页面
       
        //[appDelegaet release];
        //[apnConfigName release];
//        [fm release];
//        [documentsDirectory release];
//        [documentPath release];

        
    }else{
         
        [self gotoMainApnSeting2:1];
         
    }
    
    // [setAPN release];
    
    
    

}

//转到APN设置
-(IBAction)gotoMainApnSeting2:(int)i{
    
    
    if(mainAPNcontroller==nil){
        mainAPNcontroller=[[MainApnSetController alloc]init];
    }
    [mainAPNcontroller viewWillAppear:YES];
    //[mainAPNcontroller viewDidLoad];
    if (i==0) {
        [mainAPNcontroller setDefaultSegmentValue:0];
    }
    if (i==1) {
        
        [mainAPNcontroller setDefaultSegmentValue:1];
        //intranet show first time
        [mainAPNcontroller setDefaultSegmentValue:1];
        
    }
    

    // self.navigationItem.title=@"APN设置";
    [self.navigationController pushViewController:mainAPNcontroller animated:YES];
}


-(void)viewDidLoad
{
    //self.navigationController.navigationItem.title = @"企业移动终端管家";
    //self.tabBarController.navigationItem.title = @"企业移动终端管家";
    //self.tabBarController.navigationController.navigationItem.title = @"企业移动终端管家";
    // asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
    [super viewDidLoad];
    //加一个 系统信息按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    leftbutton.frame=CGRectMake(0, 0, 40, 30);
    //nvItm.rightBarButtonItem =
    //self.navigationItem.rightBarButtonItem =
    //[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    [leftbutton addTarget:self action:@selector(aboutMeView) forControlEvents:UIControlEventTouchDown];
    
//    //帮助信息按钮
//     UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//     [rightbutton setImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateNormal];
//     rightbutton.frame =CGRectMake(0, 0, 30, 30);
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightbutton];
//
//     [rightbutton addTarget:self action:@selector(aboutMeView) forControlEvents:UIControlEventTouchDown];
//    UIBarButtonItem *rightui=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"set.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(getIphoneOSInfo)];
//    self.navigationItem.rightBarButtonItem=rightui;
    //NSLog(@"----------------viewDidLoad");
    
//    avertWebView= [[UIWebView alloc]initWithFrame:CGRectMake(165.0, 255.0, 130, 60)];
//    [avertWebView setDelegate:self];
//    [self.tableView addSubview:avertWebView]; 
//    [self loadAvertWebView];
    
//    UIButton *buttontest = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    //图片
//    buttontest.frame = CGRectMake(165.0, 255.0, 130, 60);
//    buttontest.titleLabel.text=@"dfdfdfdfd";
//    [self.view addSubview:buttontest];
    if (avertShowView!=nil) {
        [avertShowView.view removeFromSuperview];
    }
     avertShowView=[[AvertShowViewController alloc]init];
    //960 150
    [avertShowView.view setFrame:CGRectMake(0.1, 352.0, 325, 100)];
    [self.view addSubview:avertShowView.view];
    
    //获取手机号码
    // [self  GetPhoneNumber];
    
      [NSThread detachNewThreadSelector:@selector(getNumberByThread) toTarget:self withObject:nil];
    CGRect frame = self.view.frame;
    
    if (!self.hidesBottomBarWhenPushed)
    {
        frame.size.height -= TAB_BAR_HEIGHT;
    }
    self->_tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
	self->_tableView.delegate = self;
	self->_tableView.dataSource = self;
	self->_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self->_tableView.backgroundColor = [UIColor clearColor];
    [self->_tableView setBackgroundView:nil];
    [self.view addSubview:self->_tableView];
    [self->_tableView release];
}
-(IBAction)getIphoneOSInfo{
  

}
//设置 当前用户点击的apn
-(void)setCurrentAPN:(NSString*)APN{
    if (showapnSeting==NULL || showapnSeting==nil) {
        showapnSeting = [[UILabel alloc] initWithFrame:CGRectMake(8, 150, 250, 20)];
    }
    
    [showapnSeting removeFromSuperview];
    [showapnSeting setBackgroundColor:[UIColor clearColor]];
    [showapnSeting setTextColor:[UIColor whiteColor]];
    
    showapnSeting.textAlignment = UITextAlignmentRight;
    
    showapnSeting.font = [UIFont systemFontOfSize:23];
    showapnSeting.text=@"";
    showapnSeting.text=APN;
    
    [self.view addSubview:showapnSeting];
    //[currentAPNlabel release]; 
    
}

//从服务器获取号码
-(void)getNumberByThread{
    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc]init];
     [self performSelectorOnMainThread:@selector(GetPhoneNumber) withObject:nil waitUntilDone:NO];
    //[self GetPhoneNumber];
    [pool release];
}


//请求 java后台 服务 取得手机号码
-(void)GetPhoneNumber{
     //  NSLog(@"------------------------调用手机号码");
    //获取设备的udid
   // UIDevice *device=[UIDevice currentDevice];
    //NSString *uniqueID=[device uniqueIdentifier];
    //在请求的时候 传递udid   
   // NSURL *url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://cyber-wise.com.cn:8007pages/ApnSata/activeApn.do?udid=%s",uniqueID]];  
    //NSURL *url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://120.31.55.12:8007/pages/ApnSata/activeApn.do"]];
   // NSURL *url=[[NSURL alloc]initWithString:@"www.baidu.com"];
    
    // NSURL *url2=[[NSURL alloc]initWithString:@"http://cyber-wise.com.cn/getNumber.action"];
    
    // NSURL *url=[[NSURL alloc]initWithString:urlparm];
     // NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
     //NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
     
     //NSURLConnection *conn=[[NSURLConnection alloc]initWithRequest:request delegate:self];
     
    // NSLog(@"%f时间－－－－",[request timeoutInterval]);
    
   // [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handtimeout) userInfo:nil repeats:NO];
    
    //[conn release];
    //[request release];
    
     
}
//-(void)handtimeout{
//  
//}

//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    //  NSString *text=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//       // NSLog(@"------------------------手机号码%@",text);
//}



- (id)init
{
    count = 0;
	return self;
}


-(void)applicationDidFinishLaunching:(UIApplication *)application
{
    
}
- (void)viewDidUnload
{
    // self.apnInfoArray=nil;
    [super viewDidUnload];
    //    self.switchArray=nil;
    //    
    //    [self disconnect];
    //    asyncSocket=nil;
    //    responseInfo=nil;
    //    readStream =nil;
    //    writeStream =nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc
{
    //    [apnInfoArray release];
    //    [editApninfo release];
    //    [switchArray release];
    //    
    //    [iStream release];
    //    [oStream release];
    //    [data release];
    //    [responseInfo release];
    //    [reSendAPN release];
    //    [asyncSocket release]; 
    //    
    //    [addapnview release];
    [ViewControllerSysInfo release];
    [initInfoController release];
    // [editApnInfoController release];
    [avertShowView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    
}

 
@end
