//
//  InternetViewController.m
//  unuion03
//  公网操作类
//  Created by easystudio on 10/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InternetViewController.h"


//#import "unionApnViewController.h"
#import "NetworkViewController.h"
#import "ApnInfo.h"
#import "AppDelegate.h"
//#import "UdidDevice.h"
#import "Reachability.h"
#include "sys/param.h"
#include "sys/mount.h"

//网络连接相关
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "RootViewController.h"
#import "UIUtil.h"
@implementation InternetViewController

@synthesize addapnview;
@synthesize apnInfoArray;
@synthesize editApnInfoController;
@synthesize initInfoController;
@synthesize switchArray;
@synthesize aboutMeController;
@synthesize tableViews;
@synthesize internetViewDelegate;
//@synthesize defaultStartDelegate;
//@synthesize responseInfo;
ApnInfo *reSendAPN; //重发对象
NSMutableData *data;
NSInputStream *iStream;
NSOutputStream *oStream;
CFReadStreamRef readStream = NULL;
CFWriteStreamRef writeStream = NULL;


//struct sigaction act; // 描述信号行为的变量
//struct timeval tv; // 描述时间的结构体变量
//struct sockaddr_in zeroAddress;
int count;//重发apn次数
int errorCount;//错误次数

int sendApnContentLength;//发送数据 的长度

//页面每次加载时 调用
- (void)viewWillAppear:(BOOL)animated
{

    count=0;
    [super viewWillAppear:animated];
    if (editApninfo) {
        NSIndexPath *updatePath=[NSIndexPath indexPathForRow:[apnInfoArray indexOfObject:editApninfo] inSection:0];
        NSArray *updatePaths=[NSArray arrayWithObject:updatePath];
        [self.tableViews reloadRowsAtIndexPaths:updatePaths withRowAnimation:UITableViewRowAnimationFade];
        editApninfo=nil;
        
    }
    //读取所有文件
    [self readApnInfoForTable];
    [self.tableViews reloadData];

}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

//添加apn到文件里
-(IBAction)addApnInfo
{
    [internetViewDelegate performSelector:@selector(navaddApnInfo) withObject:nil];
//      if (addapnview==nil) {
//         addapnview=[[NetworkViewController alloc] init];
//         
//      }
//     NSLog(@"internet add2-----------------------");
//     addapnview.apnType=@"internetAPN";//设置 写入文件的apn类型
////   // unuion03AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
//     // self.navigationController.title=@"新建APN信息";
//    //[self. navigationController pushViewController:addapnview1 animated:YES];
//   // [self. navigationController pushViewController:addapnview animated:YES];
//    //[self.parentViewController navigationController
////    if(aboutMeController==nil){
////        aboutMeController=[[AboutMeController alloc]init];
////    }
//    
// //unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
//    DefaultStartViewController *mainView=[[DefaultStartViewController alloc]init];
//    InternetViewController *internetView =[[InternetViewController alloc]init];
//    
//    mainView.mainNavDelegate=internetView;
//    [mainView.navigationController pushViewController:addapnview animated:YES];
//    
// //delegate.navigationController.navigationItem.backBarButtonItem.title=@"dfdf";
// //[delegate.navigationController pushViewController:addapnview animated:YES];
////    self.navigationItem.title=@"APN设置";
////    [self.navigationController pushViewController:aboutMeController animated:YES];
//    
    
}

//导航到初始化 服务器信息
-(IBAction)initServerInfo{
    if(initInfoController==nil){
        initInfoController=[[InitInfoController alloc]initWithNibName:@"InitInfoController"bundle:nil];
    }
    
    AppDelegate* delegate = UIUtil::Delegate();
    self.navigationController.title=@"初始化服务器信息";
    [delegate.getCurrentNavigationController pushViewController:initInfoController animated:YES];
}

//导航到关于我们
-(IBAction)aboutMeView{
    
    if(aboutMeController==nil){
        aboutMeController=[[AboutMeController alloc]initWithNibName:@"AboutMeController"bundle:nil];
    }
    //unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    self.navigationController.title=@"关于我们";
    
    // [delegate.navigationController pushViewController:aboutMeController animated:YES];
    //以模式窗口弹出
    [self presentModalViewController:aboutMeController animated:YES];
    
}

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

//获取表格的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
         return [apnInfoArray count];
    }else{
        return 1;
    }
    
    
}

//返回表格的分区 （2011 年10月 12日）
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

////显示 分组 的标题
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    [tableView setSectionHeaderHeight:30.0];
//    UILabel        *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
//    titleLabel.backgroundColor=[UIColor clearColor];
//    titleLabel.textColor = [UIColor lightGrayColor];
//	titleLabel.highlightedTextColor = [UIColor whiteColor];
//    //titleLabel.textColor=[UIColor purpleColor];//purpleColor
//    titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    titleLabel.frame = CGRectMake(250.0, 100.0, 100.0, 44.0);
//    
//    if (section==0) {
//        titleLabel.text=@"    公网APN";
//    }
//    else if(section==1){
//        titleLabel.text=@"    内网APN";
//    }
//    return [titleLabel autorelease];
//
//}


//返回表格的高度
-(CGFloat)tableView:(UITableView*)tableView  heightForRowAtIndexPath:(NSIndexPath*)indexPath{ 
    if (indexPath.section==0) {
         return 60.0;
    }else{
      return 48.0;
    }
   
};


//加载表格数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setSectionHeaderHeight:5.0];
   // NSLog(@"--------//加载表格数据//加载表格数据------------");
    //self.tableView=tableView;
//    self.tableViews.contentSize = CGSizeMake(self.tableViews.frame.size.width +40, self.tableViews.frame.size.height);
//    //屏蔽滚动条
//    if (indexPath.row>=6) {
//        NSLog(@"indexPath.rowindexPath.rowindexPath.row");
//        self.tableViews.contentSize = CGSizeMake(self.tableViews.frame.size.width +40, self.tableViews.frame.size.height+150);
//       
//    }
      self.tableViews.scrollEnabled=TRUE;
     
    //NSLog(@"tableViewtableView-----%f",self.tableViews.contentSize);
    //UIImageView *backview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablebackImg.png"]];
    UIImageView *backview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablebackImg.png"]];
    self.tableViews.backgroundView=backview;
    [backview release];
    
    static NSString *SimpleTableIdentifier=@"SimpleTableIdentifier";
    
    // CustomCell *cell1= [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    UITableViewCell *cell=[self.tableViews  dequeueReusableCellWithIdentifier:SimpleTableIdentifier ];
    
    if(cell == nil){
        //把行的值赋给 editApninfo 当点击开关时处理 数据信息
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        // [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [cell setBackgroundColor:[UIColor whiteColor]];
        // [cell setTheImage:[UIImage imageNamed:[NSString stringWithFormat:@"button_up.png", indexPath.row]]];
    }
    
    //添加switch按钮
    if (indexPath.section==0) {
    ApnInfo *apnInfo=[apnInfoArray objectAtIndex:indexPath.row];
    //UISwitch *switchView=[[UISwitch alloc] initWithFrame:CGRectZero];
    UISwitch *switchView=[[UISwitch alloc] initWithFrame:CGRectMake(100.0, 10.0, 200.0, 200.0)];
    [switchView setFrame:CGRectMake(100.0, 10.0, 400.0, 400.0)];
    cell.accessoryView=switchView;
    BOOL isSetOn=[apnInfo.status isEqualToString:@"YES"]?true:false;
    [switchView setOn:isSetOn animated:NO];
    [switchView addTarget:self action:@selector(openInternetFile:) forControlEvents:UIControlEventValueChanged ];
    switchView.tag=indexPath.row;
    if([switchArray count] <[apnInfoArray count]){
        [switchArray addObject:switchView];
    }
    [switchView release];
    cell.textLabel.text=apnInfo.apnDesc;
    
    cell.detailTextLabel.text=apnInfo.apn;
    UIImage *cellImgView = [UIImage imageNamed:@"InternetTableRowImg"];
    
    // UIImage *cellImgView=[[UIImage alloc] initWithImage:[UIImage imageNamed:@"about.png"]];
    cell.imageView.image =cellImgView;
        
    }
    
    if (indexPath.section==1) {
         
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //加一个 添加apn按钮
    if (addAPNbutton !=nil) {
        [addAPNbutton removeFromSuperview];
    }
         
    addAPNbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //图片
    UIImage *addImage = [UIImage imageNamed:@"addAPNimg.png"];
    [addAPNbutton   setImage:addImage forState:UIControlStateNormal];
    //[addAPNbutton setBackgroundImage:addImage forState:UIControlStateNormal];
    addAPNbutton.frame = CGRectMake(100.0, 10,120,30);
    //[button setBackgroundImage:backImage forState:UIControlStateNormal];
    [addAPNbutton setTitle:@" 新建APN" forState:UIControlStateNormal];
    [addAPNbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [addAPNbutton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [cell.contentView addSubview:addAPNbutton];
    //[addImage release];
    
    //转到 添加APN的页面
     [addAPNbutton addTarget:self action:@selector(addApnInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
//返回主页
-(IBAction)backMainView{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft  forView:self.navigationController.view cache:YES];
    //返回根控制器
    [self.navigationController popToRootViewControllerAnimated:YES];
    [UIView commitAnimations];
}
//动画 广告 效果

-(void)beginAnimations{
    NSURL *adverimgURL=[NSURL URLWithString:@"http://192.168.1.111:8080/testPhoneNumber/unionAvert.PNG"];
    NSData *adverimgData= [NSData dataWithContentsOfURL:adverimgURL];
    
    // UIImage *unionAdvertImgview = [UIImage imageWithData:adverimgData];
    UIImageView *unionAdvertImgview2=[[UIImageView alloc] initWithImage:[UIImage imageWithData:adverimgData]];
    
    //UIImage *unionAdvertImgview = [UIImage imageNamed:@""];
    [UIView beginAnimations:@"movement" context:nil];
    
    CGPoint center=unionAdvertImgview2.center;
    if (center.y>80.0f) {
        center.y-=290.0f;
        unionAdvertImgview2.center=center;
    }else{
        center.y+=295.0f;
        unionAdvertImgview2.center=center;
    }
    
    [UIView commitAnimations];
}

//打开浏览器
-(void)openInternetFile:(id)sender{
    UISwitch *switchControl=sender;
  
    @try{
        //把行的值赋给 editApninfo 当点击开关时处理 数据信息
        editApninfo=[apnInfoArray objectAtIndex:switchControl.tag];
    }@catch(NSException *e){
        UIAlertView *
        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                          message:@"请检查您填写的apn"
                                         delegate:self
                                cancelButtonTitle:@"OK"   
                                otherButtonTitles:nil];
        [alert show]; 
        [alert release];
    }
    
    NSMutableString *apnConfigName=[[NSMutableString alloc] initWithString:editApninfo.apn];
    [ apnConfigName appendString:@".mobileconfig"];
    
    // 判断初始化文件是否存在
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    
    if (![fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:apnConfigName]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                        message:@"当前apn已被删除"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"   
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        //导航到初始化页面
        //[self initServerInfo]; 
        return;
        
    } 
    
    
    //读取文件内容 ，当用户修改状态后再写回去internet_
    //获取当前点击开关那行的文件名
    NSMutableString *fileName=[NSMutableString stringWithString:@"internet_"];
    [fileName appendString:editApninfo.apn];
    
    NSString *data=[self readFile:fileName];
    
    //截取字符串 μ
    NSMutableString *fix=[NSMutableString stringWithString:@"λ"];
    NSMutableString *fix2= [NSMutableString stringWithString:@"μ"];
    
    NSRange subRange=[data rangeOfString:fix];
    NSRange subRange2=[data rangeOfString:fix2];
    //处理其它的文件 apn数据状态
    NSArray *ortherfileNames;
    ortherfileNames=[self getDirectory];//获取所有的文件名 广州挟制α127.0.0.1βliangchunγ875544
    //apnInfoArray=[[NSMutableArray alloc]init];
    if(switchControl.on){
        if([ortherfileNames count]>0){
            for(int i=0;i<[ortherfileNames count];i++){
                if([[ortherfileNames objectAtIndex:i] hasPrefix:@"internet_"]){
                    // data=  [netWork readFile:[fileName objectAtIndex:i]];
                    NSString *data=[self readFile:[ortherfileNames objectAtIndex:i]];
                    NSRange subRange=[data rangeOfString:fix];
                    NSRange subRange2=[data rangeOfString:fix2];
                    //读取 原有的数据
                    NSString *leftData=[[data substringFromIndex:0] substringToIndex:subRange.location ];
                    //拼装内容 重新写入文件
                    NSMutableString *apnContent=[NSMutableString stringWithString:leftData];
                    [apnContent appendString:@"λ"];
                    [apnContent appendString:switchControl.on?@"NO":@"YES"];
                    
                    NSString *rightData=[data substringFromIndex:subRange2.location];
                    [apnContent appendString:rightData];
                    [self writeFile:apnContent fileName:[ortherfileNames objectAtIndex:i]];
                    
                }
                
//                if([[ortherfileNames objectAtIndex:i] hasPrefix:@"apninfo_"]){
//                    // data=  [netWork readFile:[fileName objectAtIndex:i]];
//                    NSString *data=[self readFile:[ortherfileNames objectAtIndex:i]];
//                    NSRange subRange=[data rangeOfString:fix];
//                    NSRange subRange2=[data rangeOfString:fix2];
//                    //读取 原有的数据
//                    NSString *leftData=[[data substringFromIndex:0] substringToIndex:subRange.location ];
//                    //拼装内容 重新写入文件
//                    NSMutableString *apnContent=[NSMutableString stringWithString:leftData];
//                    [apnContent appendString:@"λ"];
//                    [apnContent appendString:@"NO"];
//                    
//                    NSString *rightData=[data substringFromIndex:subRange2.location];
//                    [apnContent appendString:rightData];
//                    
//                    [self writeFile:apnContent fileName:[ortherfileNames objectAtIndex:i]];
//                    
//                }
            }
        }
    }
    //读取 原有的数据
    NSString *leftData=[[data substringFromIndex:0] substringToIndex:subRange.location ];
    //拼装内容 重新写入文件
    NSMutableString *apnContent=[NSMutableString stringWithString:leftData];
    [apnContent appendString:@"λ"];
    [apnContent appendString:switchControl.on?@"YES":@"NO"];
    
     NSString *rightData=[data substringFromIndex:subRange2.location];
    [apnContent appendString:rightData];
     
    [self writeFile:apnContent fileName:fileName];
    
    //重新加载 数据
    [self readApnInfoForTable];
    [self.tableViews reloadData];
    //如果 切换按钮为NO
    if(!switchControl.on)
        return;
    
    //将当前切换的APN写入文件，
    //InternetAPNFileContent、 CurrentAPNFileName 定义在 SysInfoViewController.h 头部
    NSMutableString *currentApnFileContent=[[NSMutableString alloc]initWithString:InternetAPNFileContent];
    if (editApninfo.apnDesc !=nil && ![editApninfo.apnDesc isEqualToString:@""]) {
        [currentApnFileContent appendFormat:@"(%@)",editApninfo.apnDesc];
    }
     
    [self writeFile:currentApnFileContent fileName:CurrentAPNFileName];
    [currentApnFileContent release];
    
    // SysInfoViewController *sysController=[[SysInfoViewController alloc]initWithNibName:@"SysInfoViewController" bundle:nil];
     //[sysController viewDidLoad];
    //[sysController viewDidAppear:YES];
   // [sysController release];
    
    //mcdmAppDelegate* appDelegaet = [[mcdmAppDelegate alloc]init];
    RootViewController* ViewControllerRoot = [[RootViewController alloc]init];
    //[appDelegaet addControl];
    //重新添加 视图
    //[appDelegaet creatPosterViews];
    //切换APN
    [ViewControllerRoot openSafari:apnConfigName];//打开页面
    [ViewControllerRoot release];
    [editApninfo release];
}

//当点击 开关按钮时 发动信息到服务器
-(void)switchChanged:(id)sender{
    UISwitch *switchControl=sender;
    @try{
        //把行的值赋给 editApninfo 当点击开关时处理 数据信息
        editApninfo=[apnInfoArray objectAtIndex:switchControl.tag];
    }@catch(NSException *e){
        UIAlertView *
        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                          message:@"请检查您填写的apn"
                                         delegate:self
                                cancelButtonTitle:@"OK"   
                                otherButtonTitles:nil];
        [alert show]; 
        [alert release];
    }
    
    //重发对象
    reSendAPN=[apnInfoArray objectAtIndex:switchControl.tag];
    //连接服务器 并传输数据
    resendAPNcount=NO;
    if(switchControl.on){
        count=0;
        errorCount=0;
        UIAlertView *alert;
        //检测 当前网络 如果没得 网络 直接返回
        if([self checkInternet]==0){
            //  NSLog(@"进入无网络判断");
            alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                              message:@"当前无可用的网络，请检查手机网络配置"
                                             delegate:self
                                    cancelButtonTitle:@"OK"   
                                    otherButtonTitles:nil];
            [alert show]; 
            [switchControl setOn:NO animated:NO];
            return;
        }
        //防止 反复重发
        resendAPNcount=YES;
        //连接服务器
        //[self connectionToserver:editApninfo.apn];
        //调用连接 服务器
        [self connectiontoserverbyasysocket:editApninfo.apn];
    }
    //读取文件内容 ，当用户修改状态后再写回去
    //获取当前点击开关那行的文件名
    NSMutableString *fileName=[NSMutableString stringWithString:@"internet_"];
    [fileName appendString:editApninfo.apn];
    
    NSString *data=[self readFile:fileName];
    
    NSMutableString *fix=[NSMutableString stringWithString:@"λ"];
    
    NSRange subRange=[data rangeOfString:fix];
    //处理其它的文件 apn数据状态
    NSArray *ortherfileNames;
    ortherfileNames=[self getDirectory];//获取所有的文件名 广州挟制α127.0.0.1βliangchunγ875544
    //apnInfoArray=[[NSMutableArray alloc]init];
    if(switchControl.on){
        if([ortherfileNames count]>0){
            for(int i=0;i<[ortherfileNames count];i++){
                if([[ortherfileNames objectAtIndex:i] hasPrefix:@"internet_"]){
                    // data=  [netWork readFile:[fileName objectAtIndex:i]];
                    NSString *data=[self readFile:[ortherfileNames objectAtIndex:i]];
                    NSRange subRange=[data rangeOfString:fix];
                    //读取 原有的数据
                    NSString *leftData=[[data substringFromIndex:0] substringToIndex:subRange.location ];
                    //拼装内容 重新写入文件
                    NSMutableString *apnContent=[NSMutableString stringWithString:leftData];
                    [apnContent appendString:@"λ"];
                    [apnContent appendString:switchControl.on?@"NO":@"YES"];
                    [self writeFile:apnContent fileName:[ortherfileNames objectAtIndex:i]];
                    
                }
            }
        }
    }
    //读取 原有的数据
    NSString *leftData=[[data substringFromIndex:0] substringToIndex:subRange.location ];
    //拼装内容 重新写入文件
    NSMutableString *apnContent=[NSMutableString stringWithString:leftData];
    [apnContent appendString:@"λ"];
    [apnContent appendString:switchControl.on?@"YES":@"NO"];
    [self writeFile:apnContent fileName:fileName];
    
    
    //重新加载 数据
    [self readApnInfoForTable];
    [self.tableViews reloadData];
    
    [editApninfo release];
    
}
//检测 当前 网络
-(BOOL)checkInternet{
    // Reachability *r=[Reachability re
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus==NotReachable)&&([Reachability reachabilityForLocalWiFi].currentReachabilityStatus==NotReachable)   ) {
        return NO;
    }
    return YES;
}


//把apn信息写入缓冲流
//-(void) writeToServer:(const uint16_t *) buf {
//    //[oStream write:buf maxLength:strlen((char *)buf)];    
//    [oStream write:buf maxLength:sendApnContentLength]; 
//    
//}

//异步连接服务器
-(void)connectiontoserverbyasysocket:(NSString*)apn{
    //获取 iphone 唯一的uuid
    
    NSString *ipPortData=[self readFile:@"serverInfoFile"];
    UIAlertView *alert;
    if([ipPortData length]==0){
        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                          message:@"请初始化服务器信息..."
                                         delegate:self
                                cancelButtonTitle:@"OK"   
                                otherButtonTitles:nil];
        [alert show]; 
        [alert release];
        //导航到初始化页面
        [self initServerInfo];        
        return;
    }
    //132.145.65.88α9014β1γ5λ192.168.1.100  (新初始化信息结构)
    //截取  
    NSString *fix=@"α";
    NSString *fix1=@"β";
    NSString *fix2=@"λ";
    //从文件中读取ip和端口
    NSString *ip;  //外网ip
    NSString *intrantIp;//内网IP
    NSString *port;//端口
    
    NSRange  subRange=[ipPortData rangeOfString:fix];
    NSRange subRange1=[ipPortData rangeOfString:fix1];
    NSRange subRange2=[ipPortData rangeOfString:fix2];
    //外网ip
    ip=[[ipPortData substringFromIndex:0] substringToIndex:subRange.location];
    //内网ip
    intrantIp=[ipPortData substringFromIndex:subRange2.location+1];
    //端口
    port=[[ipPortData substringFromIndex:subRange.location+1] substringToIndex:subRange1.location-1-subRange.location];
    
    NSError *err = nil;
    if ([editApninfo.apn isEqualToString:@"3gnet"] || [editApninfo.apn isEqualToString:@"3gwap"]) {
        
        [asyncSocket connectToHost:intrantIp onPort:[port integerValue] withTimeout:4.0  error:&err];
    }else{
        
        [asyncSocket connectToHost:ip onPort:[port integerValue] withTimeout:4.0  error:&err];
    }
}

//当连接上服务器时调用
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port 
{ 
    //处理用户随便输入的ip 如:11.22?.45,56 手机会转换成如下IP
    NSString *validIP=@"220.250.64.24";
    if([host isEqualToString:validIP]){
        UIAlertView *
        alert= [[UIAlertView alloc] initWithTitle:@"服务器无法连接" 
                                          message:@"请填写正确的服务器ip及端口"
                                         delegate:self
                                cancelButtonTitle:@"OK"   
                                otherButtonTitles:nil];
        [alert show]; 
        [alert release];
        
        [sock disconnect];
        if(initInfoController==nil){
            //导航到初始化页面
            [self initServerInfo]; 
        }
        return;
    }
    
    //获取设备的udid
    UIDevice *device=[UIDevice currentDevice];
    NSString *uniqueID=[device uniqueIdentifier];
    
    NSMutableString *sendContent=[NSMutableString stringWithString:uniqueID ]; 
    [sendContent appendString:@";"];
    if ([editApninfo.apn length]>0) {
        [sendContent appendString:editApninfo.apn];
    }
    
    [sendContent appendString:@";"];  
    
    //获取发送内容的长度    
    sendApnContentLength=[sendContent length];
    NSData* aData = [sendContent dataUsingEncoding: NSUTF8StringEncoding];
    //写入数据
    [sock writeData:aData withTimeout:-1 tag:1];
    //读取数据
    
    [sock readDataWithTimeout:-1 tag:0]; 
    
    
} 
//读取数据
-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag 
{ 
    
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
    //把响应信息赋给 全局变量
    responseInfo=[NSMutableString stringWithString:aStr];
    
    //如果 有正常的数据 
    if([responseInfo length] >0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功发送APN数据" 
                                                        message:@"服务器已收到APN数据,请等待修改APN。"
                                                       delegate:self
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        
        [alert release];
        
    }
    
    [aStr release]; 
    if(sock!=nil){
        [sock disconnect];
    }
    //[sock readDataWithTimeout:-1 tag:0];
} 
- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag 
{ 
    // NSLog(@"onSocket:%p didSecure:YES", sock); 
} 

//处理重发
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err 
{ 
    
    responseInfo=[NSMutableString stringWithString:@"novalue"];
    
    if ([responseInfo length]<=0 || [responseInfo isEqualToString:@"novalue"]) {
        //responseInfo=[[NSMutableString alloc] initWithString:@"novalue"];
        if (resendAPNcount == YES ) {  
            [self NstimerApn];
            
            resendAPNcount=NO;
        }
        errorCount++;//错误次数
        if ((errorCount-1)==count || errorCount ==2) {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"服务器无法连接"
                                                             message:@"请检查IP和端口及服务器监听是否开启" 
                                                            delegate:self
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil];
            [alert1 show];
            [alert1 release];
            if(initInfoController==nil){
                //导航到初始化页面
                [self initServerInfo]; 
            }
        }
    }
    if(sock!=nil){
        [sock disconnect];
    }
    //调用重发
} 
- (void)onSocketDidDisconnect:(AsyncSocket *)sock 
{ 
    //断开连接了 
    
} 

//点击 手机的 返回 主页面按钮时调用
- (void)applicationDidEnterBackground:(UIApplication *)application
{  
    // [self disconnect];
    count=0;
    errorCount=0;
}
//关闭输入输出流
-(void) disconnect {
    
    [iStream close];
    
    [oStream close];
    
}


//定时发送apn
- (void) handleTimerSendApn: (NSTimer *) timer{
    //连接服务器
    //[self connectionToserver:reSendAPN.apn];
    [self connectiontoserverbyasysocket:reSendAPN.apn];
}

//执行apn 发送
-(void)NstimerApn{
    
    if (responseInfo==nil) {
        responseInfo=[[NSMutableString alloc] init];
    }
    //当服务器 开后又停止
    //当 服务器返回信息为空时 处理重发
    if ([responseInfo length]<=0 || [responseInfo isEqualToString:@"novalue"]) {
        NSString *ipPortData=[self readFile:@"serverInfoFile"];
        UIAlertView *alert;
        if([ipPortData length]==0){
            alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                              message:@"请初始化服务器信息..."
                                             delegate:self
                                    cancelButtonTitle:@"OK"   
                                    otherButtonTitles:nil];
            [alert show]; 
            //导航到初始化页面
            [self initServerInfo];
            
            return;
        }
        
        //截取  
        // 132.145.65.88 α 9014 β 1 γ 5 λ 192.168.1.100 （新初始化文件的结构）
        NSString *fix1=@"β";
        NSString *fix2=@"γ";
        NSString *fix3=@"λ";
        
        NSString *recount;//重发次数
        NSString *retime;//重发间隔时间
        NSRange subRange1=[ipPortData rangeOfString:fix1];
        NSRange subRange2=[ipPortData rangeOfString:fix2];
        NSRange subRange3=[ipPortData rangeOfString:fix3];
        //获取 文件中的 重发次数和 重发间隔时间
        recount=[[ipPortData substringFromIndex:subRange1.location+1] substringToIndex:subRange2.location-1-subRange1.location];
        retime=[[ipPortData substringFromIndex:subRange2.location+1] substringToIndex:subRange3.location-1-subRange2.location];
        
        count=[recount intValue];//次数
        
        if(count>5)
            count=5;
        int times=[retime intValue];//间隔时间
        if(times==0 || times>5)
            times=2;
        
        if(count>0){
            NSTimer *timer;
            for(int i=0;i<1;i++){
                if ([responseInfo length]<=0 || [responseInfo isEqualToString:@"novalue"]) {
                    
                    timer = [NSTimer scheduledTimerWithTimeInterval: times
                                                             target: self
                                                           selector: @selector(handleTimerSendApn:)
                                                           userInfo: nil
                                                            repeats: NO];
                    
                }
                
                
            }
        }
        
        
    }
    
}


//读取 APN
-(NSString *)readFile:(NSString *)RfileName
{
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    
    NSString *apnContent=nil;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:RfileName]]==YES){
        apnContent=[NSString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:RfileName] encoding:NSUTF8StringEncoding error:nil];
    } else{
        apnContent=@"";
    }
    
    [fm release];
    return apnContent;
    
}

////写入文件
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



//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApnInfo *deleteApninfo;//编辑对象
    deleteApninfo=[apnInfoArray objectAtIndex:indexPath.row];
    //editApnInfoController.apninfo=editApninfo;
    if(editingStyle==UITableViewCellEditingStyleDelete){
        [apnInfoArray removeObjectAtIndex:indexPath.row];
        [self.tableViews deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //NSData *fileData;
    NSFileManager *fm=[ NSFileManager defaultManager];
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    
    //删除原来的文件
    NSMutableString *deleteFileName;
    deleteFileName=[[NSMutableString alloc]initWithString:@"internet_"];
    [deleteFileName appendString:deleteApninfo.apn];
    
    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:deleteFileName]]==YES){
        [fm removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:deleteFileName] error:nil];
        
    }
    
    //删除的config文件
    NSMutableString *deleteConfigName;
    deleteConfigName=[[NSMutableString alloc]initWithString:deleteApninfo.apn];
    
    [deleteConfigName appendString:@".mobileconfig"];
    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:deleteConfigName]]==YES){
        [fm removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:deleteConfigName] error:nil];
        
    }
    //删除的config文件 结束
    
    
    //update 2011-6-29
    [self.tableViews reloadData];
    // [self tableView reloadData];
    
}
//当 当前行是 3gnet 或 3gwap 不显示删除按钮
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ApnInfo *deleteApninfo;//编辑对象
    deleteApninfo=[apnInfoArray objectAtIndex:indexPath.row];
    //
    if([deleteApninfo.apn isEqualToString:@"3gnet" ] || [deleteApninfo.apn isEqualToString:@"3gwap" ]){
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return YES;
    }else{
        return NO;
    }
    
}

// 选中行进入编辑页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        return;
    }
    if (editApnInfoController==nil) {
        editApnInfoController=[[EditApnInfoController alloc] initWithNibName:@"EditApnInfoController" bundle:nil];
    }
    // editApnInfoController.title==@"添加apn信息";
    
    editApninfo=[apnInfoArray objectAtIndex:indexPath.row];
    editApnInfoController.apninfo=editApninfo;
    editApnInfoController.editApnType=@"internetAPN";//设置编辑的类型
    //unuion03AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
//[delegate.navigationController pushViewController:editApnInfoController animated:YES];
    [internetViewDelegate performSelector:@selector(navEditApnInfo:) withObject:editApninfo];
   //  [internetViewDelegate performSelector:@selector(navaddApnInfo) withObject:nil];
}


//读取apn信息 显示在表格中，保存规则——》descn α apn β user γ pwd λ status
-(void)readApnInfoForTable{
    //截取  μ ν
    NSString *data;
    NSMutableString *fix1=[NSMutableString stringWithString: @"α"];
    NSMutableString *fix2=[NSMutableString stringWithString:@"β"];
    NSMutableString *fix3=[NSMutableString stringWithString:@"γ"];
    NSMutableString *fix4=[NSMutableString stringWithString:@"λ"];
    NSMutableString *fix5=[NSMutableString stringWithString:@"μ"];
    NSMutableString *fix6=[NSMutableString stringWithString:@"ν"];
    
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
                NSRange subRange3=[data rangeOfString:fix3];
                NSRange subRange4=[data rangeOfString:fix4];
                NSRange subRange5=[data rangeOfString:fix5];
                NSRange subRange6=[data rangeOfString:fix6];
                NSString *apndesc=[[data substringFromIndex:0] substringToIndex:subRange1.location];
                NSString *apnname=[[data substringFromIndex:subRange1.location+1] substringToIndex:subRange2.location-1-subRange1.location];
                
                NSString *username=[[data substringFromIndex:subRange2.location+1] substringToIndex:subRange3.location-subRange2.location-1];
                
                NSString *pwd=[[data substringFromIndex:subRange3.location+1] substringToIndex:
                               subRange4.location-subRange3.location-1    ];
                NSString *status=[[data substringFromIndex:subRange4.location+1] substringToIndex:subRange5.location-subRange4.location-1 ];
                NSString *ip=[[data substringFromIndex:subRange5.location+1] substringToIndex:subRange6.location-subRange5.location-1];
                NSString *port = [data substringFromIndex:subRange6.location+1];
                
                //存储APN数据的类
                ApnInfo *apninfo=[[ApnInfo alloc] init];
                //存入apn类
                apninfo.apnDesc=apndesc;
                apninfo.apn=apnname;
                apninfo.user=username;
                apninfo.pwd=pwd;
                apninfo.status=status;
                apninfo.ip=ip;
                apninfo.port=port;
//                NSLog(@"----------apnDesc-------%@",apninfo.apnDesc);
//                NSLog(@"------------apninfo.apn------%@",apninfo.apn);
//                NSLog(@"-------------apninfo.user-----%@",apninfo.user);
//                NSLog(@"-------------apninfo.pwd-----%@",apninfo.pwd);
//                NSLog(@"-------------apninfo.status-----%@",apninfo.status);
//                NSLog(@"---------------apninfo.ip---%@",apninfo.ip);
//                 NSLog(@"---------------apninfo.port---%@",apninfo.port);
//                
                [apnInfoArray addObject:apninfo];
            }
        }
    }
}

//第一次初始化  写入 联通默认的3gnet APN信息
-(void)writeUnionNetAPN{
    
    //把apn和描述 写入文件   μ ν
    NSMutableString *apnContent=[NSMutableString stringWithString:@"联通3G-3gnet"];
    [apnContent appendString:@"α"];
    [apnContent appendString:@"3gnet"];
    [apnContent appendString:@"β"];
    [apnContent appendString:@""];
    [apnContent appendString:@"γ"];
    [apnContent appendString:@""];
    [apnContent appendString:@"λ"];
    [apnContent appendString:@"NO"];//默认状态可用
    [apnContent appendString:@"μ"];
    [apnContent appendString:@""];
    [apnContent appendString:@"ν"];
    [apnContent appendString:@"0"];
    //设置保存的名字 以便于区分是存放的apn或者其它信息
    NSMutableString  *apnfileName=[NSMutableString stringWithString:@"internet_"];
    [apnfileName appendString:@"3gnet"];
    
    //写入文件
    [self writeFile:apnContent fileName:apnfileName];
    
    
    // 保存apn信息到config文件中 开始
    NSString *path = [[NSBundle mainBundle]   pathForResource:@"telemplateIntertnetApn" ofType:@"mobileconfig"]; //得到文件的路径
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path]; //获得文件的句柄
	NSData *data = [file readDataToEndOfFile];//得到xml文件 
	[file closeFile];//获得后 关闭文件
    
    
    NSData* plistData = [path dataUsingEncoding:NSUTF8StringEncoding]; 
    NSString *error; NSPropertyListFormat format; 
    NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    //NSLog( @"plist is----------- %@", plist );
    if(!plist){ NSLog(@"Error: %@",error); [error release];
    }   
    
    //保存到外网 
    NSMutableString* aStr;
    aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    // [aStr stringWithString:]; 
    
    aStr=  [NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"testapn" withString:@"3gnet"]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testuser" withString:@""]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testpwd" withString:@""]];
    aStr=[NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"InternetApn" withString:@"3gnet"]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"apnname" withString:@"描述文件描述"]];
    
    //aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testip" withString:@""]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"<key>proxy</key>" withString:@""]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"<string>testip</string>" withString:@""]];
        
    aStr = [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testport" withString:@"0"]];
    
    // 写入文件
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    
    NSData *fileData;
    fileData=[[aStr dataUsingEncoding:NSUTF8StringEncoding] retain];
    NSMutableString *apnconfigname=[[NSMutableString alloc]initWithString:@"3gnet"];
    [apnconfigname appendString:@".mobileconfig"];
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:apnconfigname] contents:fileData attributes:nil];
    //判断文件是否存在
//    if ([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:apnconfigname]]) {
//        // NSLog(@"-------------InternetApn.mobileconfig---存在");
//    };
    
    
}


//第一次初始化  写入 联通默认的3gwap信息
-(void)writeUnionWapAPN{
    
    //把apn和描述 写入文件
    NSMutableString *apnContent=[NSMutableString stringWithString:@"联通3G-3gwap"];
    [apnContent appendString:@"α"];
    [apnContent appendString:@"3gwap"];
    [apnContent appendString:@"β"];
    [apnContent appendString:@""];
    [apnContent appendString:@"γ"];
    [apnContent appendString:@""];
    [apnContent appendString:@"λ"];
    [apnContent appendString:@"NO"];//默认状态可用
    [apnContent appendString:@"μ"];
    [apnContent appendString:@""];
    [apnContent appendString:@"ν"];
    [apnContent appendString:@"0"];
    //设置保存的名字 以便于区分是存放的apn或者其它信息
    NSMutableString  *apnfileName=[NSMutableString stringWithString:@"internet_"];
    [apnfileName appendString:@"3gwap"];
    
    //写入文件
    [self writeFile:apnContent fileName:apnfileName];
    
    // 保存apn信息到config文件中 开始
    NSString *path = [[NSBundle mainBundle]   pathForResource:@"telemplateIntertnetApn" ofType:@"mobileconfig"]; //得到文件的路径
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path]; //获得文件的句柄
	NSData *data = [file readDataToEndOfFile];//得到xml文件 
	[file closeFile];//获得后 关闭文件
    
    
    NSData* plistData = [path dataUsingEncoding:NSUTF8StringEncoding]; 
    NSString *error; NSPropertyListFormat format; 
    NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    if(!plist){ NSLog(@"Error: %@",error); [error release];
    }   
    
    //保存到外网 
    NSMutableString* aStr;
    aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    // [aStr stringWithString:]; 
    
    aStr=  [NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"testapn" withString:@"3gwap"]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testuser" withString:@""]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testpwd" withString:@""]];
    aStr=[NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"InternetApn" withString:@"3gwap"]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"apnname" withString:@"描述文件描述"]];
    //aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testip" withString:@""]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"<key>proxy</key>" withString:@""]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"<string>testip</string>" withString:@""]];
    
    aStr = [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testport" withString:@"0"]];
    
 
    // 写入文件
    NSFileManager *fm=[ NSFileManager defaultManager];
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    
    NSData *fileData;
    fileData=[[aStr dataUsingEncoding:NSUTF8StringEncoding] retain];
    NSMutableString *apnconfigname=[[NSMutableString alloc]initWithString:@"3gwap"];
    [apnconfigname appendString:@".mobileconfig"];
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:apnconfigname] contents:fileData attributes:nil];
    //判断文件是否存在
//    if ([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:apnconfigname]]) {
//        // NSLog(@"-------------InternetApn.mobileconfig---存在");
//    };
    
    
}

//当页面第一次加载的时候调用
-(void)viewDidLoad
{
    asyncSocket = [[AsyncSocket alloc] initWithDelegate:self]; 
    //end add by xiefei 20110614
    
    switchArray=[[NSMutableArray alloc]init];//初始化 存储开关按钮的 数组
    // NSString * CTSIMSupportCopyMobileSubscriberIdentity();
    
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
    //[self.tableViews setEditing:YES];
    //self.editButtonItem.target=self.tableViews;
    
    self.navigationItem.title=@"公网APN设置";
    //self.navigationItem.rightBarButtonItem.title=@"删除";
    
    [super viewDidLoad];
    
    //下面判断联通默认apn文件是否存在
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    NSFileManager *fm=[ NSFileManager defaultManager];
    NSString *filename=@"internet_3gnet";
    
    NSString *filename2=@"internet_3gwap";
    //添加3gnet信息
    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:filename]]==NO){
        
        [self writeUnionNetAPN];
    } 
    //添加 3gwap信息
    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:filename2]]==NO){
        
        [self writeUnionWapAPN];
    } 
    
    [fm release];
    
    
    //添加apn 按钮
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addApnInfo)];
    
    
//    //添加APN
//    if (addAPNbutton ==nil) {
//        // [addAPNbutton removeFromSuperview];
//        
//        addAPNbutton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        //图片
//        //UIImage *backImage = [UIImage imageNamed:@"back.png"];
//        //NSLog(@"---------表格高度--------%f",self.tableViews.contentSize.height);
//        addAPNbutton.frame = CGRectMake(120.0, 10,120,20);
//        //[button setBackgroundImage:backImage forState:UIControlStateNormal];
//        
//        [addAPNbutton setBackgroundColor:[UIColor clearColor]];
//        [addAPNbutton setTitle:@"新建APN" forState:UIControlStateNormal];
//        [addAPNbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [ self.view addSubview:addAPNbutton];
//        
//        //转到 添加APN的页面
//        [addAPNbutton addTarget:self action:@selector(addApnInfo) forControlEvents:UIControlEventTouchUpInside];
//    }

    
    //开一个新的线程  调用 添加广告 的方法
    //[NSThread detachNewThreadSelector:@selector(startThreaddownImg) toTarget:self withObject:nil];
    //调用 下载图片的方法
    //[self downLoadImgFromServer];
    // [self addaverImg];
    
    
    if (editApninfo) {
        NSIndexPath *updatePath=[NSIndexPath indexPathForRow:[apnInfoArray indexOfObject:editApninfo] inSection:0];
        NSArray *updatePaths=[NSArray arrayWithObject:updatePath];
        [self.tableViews reloadRowsAtIndexPaths:updatePaths withRowAnimation:UITableViewRowAnimationFade];
        editApninfo=nil;
        
    }
    //读取所有文件
    [self readApnInfoForTable];
    [self.tableViews reloadData];
    
    
}

////调用下载图片的方法
//-(void)startThreaddownImg{
//    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc]init];
//    [self downLoadImgFromServer];
//    [pool release];
//}



//下载的方式实现
//-(void)addaverImg{
//    NSString *httpPath=@"http://cyber-wise.vicp.net:8080";
//    NSString *filename=@"unionAvert.PNG";
//    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
//    //NSData *fileData;
//   // NSFileManager *fm=[ NSFileManager defaultManager];
//   UIImage  *downloadPath = [[documentsDirectory stringByAppendingPathComponent:httpPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename] ];
//    
//    UIImage *unionAdvertImgview=[UIImage imageWithContentsOfFile:downloadPath];
//    NSLog(@"downloadPath--------:%@",downloadPath);
//    
//    
//    //广告按钮
//    UIButton *unionAdvertbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    unionAdvertbutton.frame=CGRectMake(0.0, 380.0,480,48);
//    [unionAdvertbutton setBackgroundImage:unionAdvertImgview forState:UIControlStateNormal  ];
//    
//    // [ self.tableView addSubview:button];
//    [ self.view addSubview:unionAdvertbutton];
//    //转至广告页面
//    [unionAdvertbutton addTarget:self action:@selector(aboutMeView) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//}



- (id)init
{
	if(self == [super init])
	{
		asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
        
	}
	return self;
}


-(void)applicationDidFinishLaunching:(UIApplication *)application
{
    
}
- (void)viewDidUnload
{
    self.apnInfoArray=nil;
    [super viewDidUnload];
    self.switchArray=nil;
    
    [self disconnect];
    asyncSocket=nil;
    responseInfo=nil;
    readStream =nil;
    writeStream =nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc
{
    [apnInfoArray release];
    [editApninfo release];
    [switchArray release];
    
    //[iStream release];
    //[oStream release];
    // [data release];
    [responseInfo release];
    [reSendAPN release];
    [asyncSocket release]; 
    
    [addapnview release];
    [aboutMeController release];
    [initInfoController release];
    [editApnInfoController release];  
    [addAPNbutton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

@end
