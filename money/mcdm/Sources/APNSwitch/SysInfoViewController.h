//
//  SysInfoViewController.h
//  unuion03
//
//  Created by easystudio on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysInfo.h"

#include <sys/socket.h>  
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#include <arpa/inet.h>
#include <netdb.h>

#include <net/if.h>

#include <ifaddrs.h>
#import <dlfcn.h>
#import "IPAdress.h"
#define CurrentAPNFileName  @"CurrentAPNFileName"  //存储当前APN配置的文件名称
#define InternetAPNFileContent @"公网"
#define intrantAPNFileContent @"专网"
//#import "wwanconnect.h//frome apple 你可能没有哦

#import <SystemConfiguration/SystemConfiguration.h>

//系统信息数据显示控制类
@interface SysInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *sysInfoArray;//存储系统信息
    UITableView *tableViews;
    NSMutableArray *fieldLabels;//表格行标题
    
    NSMutableArray *sysInfoSection2Array;
    NSMutableArray *filedLabelsSeion2;
    //表格第1分区
    NSMutableArray *fieldLabel0;//存储当前APN
    NSMutableArray *currentAPNarray;
    NSMutableString *ipAddress;
   // NSMutableString *tempIP;
    //id *delegate;
}
@property(nonatomic,retain) IBOutlet UINavigationItem* navItem;
@property(nonatomic,retain) NSArray *sysInfoArray;
@property(nonatomic,retain) IBOutlet UITableView *tableViews;
@property(nonatomic,retain) NSArray *fieldLabels;

@property(nonatomic,retain) NSMutableArray *sysInfoSection2Array;
@property(nonatomic,retain) NSMutableArray *filedLabelsSeion2;

@property(nonatomic,retain) NSMutableArray *fieldLabel0;
@property(nonatomic,retain) NSMutableArray *currentAPNarray;

@property(nonatomic,retain) IBOutlet id delegate;
//@property(nonatomic,retain)  NSMutableString *tempIP;
//方法定义 
- (NSString *) macaddress;//获取mac地址
- (NSString *) localIPAddress;//获取IP
- (NSString *)readFile:(NSString *)RfileName;//读取文件
-(NSString*)internetStatus;
- (NSString *) localWiFiIPAddress;
@end
