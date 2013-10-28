//
//  IntranetViewController.h
//  unuion03
//   内网APN
//  Created by easystudio on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NetworkViewController.h"
#import "ApnInfo.h"
#import "EditApnInfoController.h"
#import "InitInfoController.h"
#import "AboutMeController.h"
#import "AsyncSocket.h"
//#import "unuion03AppDelegate.h"
extern ApnInfo *reSendAPN;//重发对象

//内网apn操作
@interface IntranetViewController : UIViewController<NSStreamDelegate,UITableViewDataSource,UITableViewDataSource> {
    
    NetworkViewController *addapnview;
    NSMutableArray *apnInfoArray;//存储apn信息
    ApnInfo *editApninfo;//编辑对象
    EditApnInfoController *editApnInfoController;//编辑 页面对象
    InitInfoController *initInfoController;//初始化 服务器页面对象
    AboutMeController *aboutMeController;//关于我们页面对象
    NSMutableString *responseInfo;//=[[NSMutableString alloc] init];//服务器 响应 信息
    
    NSMutableArray *switchArray;//存储 开关按钮
    
    BOOL resendAPNcount;//限制重发的次数
    
    AsyncSocket *asyncSocket;//异步网络对象
    float	_recvDt;				//控制网络连接接收时间间隔
    bool	_isDisConnect;			//连接是否断开
    UIButton *addAPNbutton;//添加APN的按钮
    
    UITableView *tableViews;
}

@property (nonatomic,retain) IBOutlet  NetworkViewController *addapnview;
@property (nonatomic,retain) IBOutlet  EditApnInfoController *editApnInfoController;
@property (nonatomic,retain) IBOutlet  InitInfoController *initInfoController;
@property (nonatomic,retain) IBOutlet  AboutMeController *aboutMeController;

@property (nonatomic,retain)NSArray *apnInfoArray;
@property (nonatomic,retain)NSArray *switchArray;//存储 开关按钮
@property (nonatomic,retain) IBOutlet  UITableView   *tableViews;

@property (nonatomic,retain) id intrantViewDelegate;//代理对象
-(IBAction)addApnInfo;//添加apn
-(IBAction)initServerInfo;//初始化服务器信息
//当点击 开关按钮时 执行以下操作
-(void)switchChanged:(id)sender;
//-(void)connectionToserver:(NSString *)apn;//连接服务器
//读取 文件
-(NSString *)readFile:(NSString *)RfileName;
////写入文件 把apn信息
-(void)writeFile:(NSMutableString *)apnContent fileName:(NSString *)filename;

//读取apn信息 显示在表格中，保存规则——》descn α apn β user γ pwd λ status
-(void)readApnInfoForTable;//
-(void)disconnect;//清除 缓冲流
-(BOOL)checkInternet;//检测网络
 
//调用连接服务器异步
-(void)connectiontoserverbyasysocket:(NSString*)apn;
//定时器 发送apn
-(void)NstimerApn;
//打开网络并安装APN
-(void)openInternetFile:(id)sender;
//获取手机号码
//-(void)GetPhoneNumber;
@end