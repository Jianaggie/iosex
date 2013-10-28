//
//  SysInfo.h
//  unuion03
//
//  Created by easystudio on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>
#define KsysInfoNumberKey @"SysInfoNumber"
#define KsysInfoCurrentApnKey @"CurrentAPN"
#define KsysInfoDeviceNameKey @"DeviceName"
#define ksysInfoDeviceModelKey @"DeviceModel"
#define ksysInfoSystemNameKey @"SystemName"
#define ksysInfoSystemVersionKey @"SystemVersion"
#define ksysInfoiphoneUdidKey @"IphoneUdid"
#define ksysInfoIpAddressKey @"IpAddress"
#define ksysInfoMacAddressKey @"MacAddress"


//系统信息属性类

@interface SysInfo : NSObject<NSCoding> {
    int number;
    //共8个NSString属性
    NSString *currentAPN;
    NSString *deviceName;
    NSString *deviceModel;
    NSString *systemName;
    NSString *systemVersion;
    NSString *iphoneUdid;
    NSString *ipAddres;
    NSString *macAddress;
    
}
@property int number;
@property(nonatomic,copy) NSString *currentAPN;
@property(nonatomic,copy) NSString *deviceName;
@property(nonatomic,copy) NSString *deviceModel;
@property(nonatomic,copy) NSString *systemName;
@property(nonatomic,copy) NSString *systemVersion;
@property(nonatomic,copy) NSString *iphoneUdid;
@property(nonatomic,copy) NSString *ipAddres;
@property(nonatomic,copy) NSString *macAddress;
 
@end
