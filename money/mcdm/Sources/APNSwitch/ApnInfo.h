//
//  ApnInfo2.h
//  unuion03
//
//  Created by MagicStudio on 11-5-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kApnInfoNumberKey      @"ApnInfo"
#define kApnInfoapnDescKey      @"apnDesc"//描述
#define kApnInfoapnKey         @"apn"//apn
#define kApnInfouserKey        @"user"//用户名
#define kApnInfopwdKey       @"pwd"//密码
#define kApnInfostatusKey       @"status"//状态 是否启用 
#define kApnInfoIpKey     @"ip"//代理ip
#define kApnInfoPortKey   @"port"//代理端口
@interface ApnInfo : NSObject<NSCoding>  {
    int number;
    NSString *apnDesc;//描述
    NSString *apn;//apny
    NSString *user;//用户名
    NSString *pwd;//密码
    NSString *status;//状态 是否启用  
    NSString *ip;//代理IP
    NSString *port;//代理端口
}
//初始化
-(id)initApnInfo:(NSString *)newApn apnDesc:(NSString *)newApnDesc user:(NSString *)newUser pwd:(NSString *)newPwd status:(NSString *)newStatus ip:(NSString*)newip port:(NSString *)newport ;
@property int number;
@property(nonatomic,copy) NSString *apn;
@property(nonatomic,copy) NSString *apnDesc;
@property(nonatomic,copy) NSString *user;
@property(nonatomic,copy) NSString *pwd;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *ip;
@property(nonatomic,copy) NSString *port;
@end
