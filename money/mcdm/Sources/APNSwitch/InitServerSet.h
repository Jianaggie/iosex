//
//  InitServerSet.h
//  unuion03
//
//  Created by MagicStudio on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//修改时间：2011年6月17日 内容 ：增加 内网字段

#import <Foundation/Foundation.h>

#define kInitInfoNumberKey      @"InitServerInfo"
#define kInitInfoInteretAPNKey      @"InteretAPN"//公网APN
#define kInitInfoInteretUserKey    @"InteretUser"//公网user
#define kInitInfoInteretPwdKey        @"InteretPwd"//公网pwd

#define kInitInfoIntrantAPNKey       @"IntrantAPN"//内网apn
#define kInitInfoIntrantUserKey     @"IntrantUser"//内网user
#define kInitInfoIntrantPwdKey     @"IntrantPwd"//内网pwd

//
//#define kInitInfoNumberKey      @"InitServerInfo"
//#define kInitInfoServerIpKey      @"ServerIp"//公网服务器ip
//#define kInitInfoServerportKey    @"Serverport"//端口
//#define kInitInfoReCountKey        @"ReCount"//重发次数
//#define kInitInfoReTimesKey       @"ReTimes"//重发间隔时间
//#define kInitInfoIntrantIpKey     @"IntrantIp"//内网ip

@interface InitServerSet : NSObject<NSCoding> {
    int         number;
    
    NSString    *interetAPN;//公网APN
    NSString    *interetUser;//公网user
    NSString    *interetPwd;//公网pwd
    
    NSString    *intrantAPN; //内网apn
    NSString    *intrantUser;//内网user
    NSString    *intrantPwd;//内网pwd
    
}
@property int number;

@property (nonatomic, copy) NSString  *interetAPN;
@property (nonatomic, copy) NSString  *interetUser;
@property (nonatomic, copy) NSString  *interetPwd;
@property (nonatomic, copy) NSString  *intrantAPN;
@property (nonatomic, copy) NSString  *intrantUser;
@property (nonatomic, copy) NSString  *intrantPwd;

@end
