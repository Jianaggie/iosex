//
//  ApnInfo2.m
//  unuion03
//
//  Created by MagicStudio on 11-5-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ApnInfo.h"


@implementation ApnInfo
//该类用于保存 apn信息
@synthesize number;
@synthesize apn;
@synthesize apnDesc;
@synthesize user;
@synthesize pwd;
@synthesize status;
@synthesize ip;
@synthesize port;
//初始化apn
-(id)initApnInfo:(NSString *)newApn apnDesc:(NSString *)newApnDesc user:(NSString *)newUser pwd:(NSString *)newPwd status:(NSString *)newStatus ip:(NSString*)newip port:(NSString *)newport
{
    self=[super init];
    if(nil !=self){
        self.apn=newApn;
        self.apnDesc=newApnDesc;
        self.user=newUser;
        self.pwd=newPwd;
        self.status=newStatus;
        self.ip=newip;
        self.port=newport;
    }
    return self;
}

-(void)dealloc{
    [apn release];
    [apnDesc release];
    [user release];
    [pwd release];
    [status release];
    [ip release];
    [port release];
    [super dealloc];

}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:self.number forKey:kApnInfoNumberKey];
    [coder encodeObject:self.apnDesc forKey:kApnInfoapnDescKey];
    [coder encodeObject:self.apn forKey:kApnInfoapnKey];
    [coder encodeObject:self.user   forKey:kApnInfouserKey];
    [coder encodeObject:self.pwd forKey:kApnInfopwdKey];
    [coder encodeObject:self.status forKey:kApnInfostatusKey];
    [coder encodeObject:self.ip forKey:kApnInfoIpKey];
    [coder encodeObject:self.port forKey:kApnInfoPortKey];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self == [super init])
    {
        self.number = [coder decodeIntForKey:kApnInfoNumberKey];
        self.apnDesc = [coder decodeObjectForKey:kApnInfoapnDescKey];
        self.apn = [coder decodeObjectForKey:kApnInfoapnKey];
        self.user = [coder decodeObjectForKey:kApnInfouserKey];
        self.pwd = [coder decodeObjectForKey:kApnInfopwdKey];
        self.status = [coder decodeObjectForKey:kApnInfostatusKey];
        self.ip=[coder decodeObjectForKey:kApnInfoIpKey];
        self.port=[coder decodeObjectForKey:kApnInfoPortKey];
    }
    return self;
}
@end
