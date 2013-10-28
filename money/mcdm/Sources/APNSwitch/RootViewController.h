//
//  RootViewController.h
//  unuion03
//
//  Created by MagicStudio on 11-4-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NetworkViewController.h"
#import "ApnInfo.h"
#import "EditApnInfoController.h"
#import "InitInfoController.h"
#import "AboutMeController.h"
#import "InternetViewController.h"
#import "IntranetViewController.h"
#import "MainApnSetController.h"
#import "AvertShowViewController.h"
#import "BaseController.h"
//#import "AsyncSocket.h"
//ApnInfo *reSendAPN;//重发对象
#define appWidth 320
#define appHeight 480
#define scrollViewHeight 300
#define pageCount 2

@interface RootViewController : BaseController <UITableViewDataSource, UITableViewDelegate, NSStreamDelegate,UIScrollViewDelegate,UIWebViewDelegate> {
    UITableView* _tableView;
    //http server相关
    HTTPServer* httpServer;
    UIBackgroundTaskIdentifier	bgTask;
    
    //    NetworkViewController *addapnview;
    NSMutableArray *apnInfoArray;//存储apn信息
    //    ApnInfo *editApninfo;//编辑对象
    //    EditApnInfoController *editApnInfoController;//编辑 页面对象
    
    //    NSMutableString *responseInfo;//=[[NSMutableString alloc] init];//服务器 响应 信息
    //    
    //    NSMutableArray *switchArray;//存储 开关按钮
    //    
    //    BOOL resendAPNcount;//限制重发的次数
    //    
    //    AsyncSocket *asyncSocket;//异步网络对象
    //    float	_recvDt;				//控制网络连接接收时间间隔
    //    bool	_isDisConnect;			//连接是否断开
    InitInfoController *initInfoController;//初始化 服务器页面对象
    SysInfoViewController* ViewControllerSysInfo; //设备系统信息页面对象
    InternetViewController *internetController;//公网页面对象
    IntranetViewController *intrantViewController;//内网页面对象
    MainApnSetController *mainAPNcontroller;
    // UIWebView  *webView;//加载 广告页
    UILabel *showapnSeting;//当前配置的哪个APN
    // NSString *currentAPNString;//当前APN显示变量
    
    
    //分页相关
    UIScrollView *scrollView;//用于分页
    NSMutableArray *pageViewArray;//分页视图数组
    int currentPage;
    UIPageControl *pageControl;
    RootViewController *rootVierControler;
    UIWebView *avertWebView;//加载广告的web
    AvertShowViewController *avertShowView;
}

//@property (nonatomic,retain) IBOutlet  NetworkViewController *addapnview;
//@property (nonatomic,retain) IBOutlet  EditApnInfoController *editApnInfoController;
@property (nonatomic,retain) IBOutlet  InitInfoController *initInfoController;
@property (nonatomic,retain) IBOutlet  AboutMeController *aboutMeController;
@property (nonatomic,retain) IBOutlet  InternetViewController *internetController;
@property (nonatomic,retain) IBOutlet  IntranetViewController *intrantViewController;
@property (nonatomic,retain) IBOutlet  MainApnSetController *mainAPNcontroller;
@property (nonatomic,retain) IBOutlet  UIPageControl *pageControl;
@property (nonatomic,retain) IBOutlet  UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UIWebView *avertWebView;
//@property (nonatomic,retain) IBOutlet  NSString *currentAPNString;
//@property (nonatomic,retain)NSArray *apnInfoArray;
//@property (nonatomic,retain)NSArray *switchArray;//存储 开关按钮
////@property (nonatomic,retain)NSMutableString *responseInfo;
////@property(nonatomic)float	recvDt;
////@property(nonatomic)bool	isDisConnect;
//-(IBAction)addApnInfo;//添加apn
//-(IBAction)initServerInfo;//初始化服务器信息
////当点击 开关按钮时 执行以下操作
//-(void)switchChanged:(id)sender;
////-(void)connectionToserver:(NSString *)apn;//连接服务器
////读取 文件
//-(NSString *)readFile:(NSString *)RfileName;
-(void)applicationDidEnterBackground:(UIApplication *)application;
-(void)openSafari:(NSString*) moblieconfigName; //打开浏览器
//写入文件 把apn信息
-(void)writeFile:(NSMutableString *)apnContent fileName:(NSString *)filename;
////用cfstream 链接服务器
////-(void) connectToServerUsingCFStream:(NSString *) urlStr portNo: (uint) portNo ;
//    
//
////读取apn信息 显示在表格中，保存规则——》descn α apn β user γ pwd λ status
-(void)readApnInfoForTable;//
//-(void)disconnect;//清除 缓冲流
//-(BOOL)checkInternet;//检测网络
//-(IBAction)exitApp;//退出 程序
////调用连接服务器异步
//-(void)connectiontoserverbyasysocket:(NSString*)apn;
////定时器 发送apn
//-(void)NstimerApn;
//打开内网    
-(void)openIntrantFile;
-(IBAction)openInternetFile;//打开公网apn页面
-(void)GetPhoneNumber;//获取手机号码
-(void)setCurrentAPN:(NSString*)APN;
//获取系统信息
-(IBAction)getIphoneOSInfo;
-(IBAction)gotoMainApnSeting:(id)sender;
//-(void)addViewToArray;//填充数组，用视图对象
-(void)readInternetApn;//
-(void)readIntrantApn;
-(IBAction)gotoMainApnSeting2:(int)i;
@end
