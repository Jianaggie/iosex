//
//  FlowDataDetector.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "FlowDataDetector.h"

#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#include <sys/time.h>
//#include <ctype.h>
#include <sys/sysctl.h>
#include "MonthFlowData.h"

#import "ASIHTTPRequest.h"
#import "DataLoader.h"

#define kFlowDataFile NSUtil::DocumentsSubPath(@"flowdata.fd")
#define kYearFlowDataFile(year) NSUtil::DocumentsSubPath([NSString stringWithFormat:@"%@flowdata.xml", year])

#define kLastBaseWifiSent @"LastBaseWifiSent"
#define kLastBaseWifiReceived @"LastBaseWifiReceived"
#define kLastBaseWWANSent @"LastBaseWWANSent"
#define kLastBaseWWANReceived @"LastBaseWWANReceived"

static FlowDataDetector *g_detector = nil;

@implementation FlowDataDetector

@synthesize recordArray=_recordArray;

+ (FlowDataDetector *)detector
{
    if (!g_detector)
    {
        g_detector = [[FlowDataDetector alloc] init];
    }
    
    return g_detector;
}

+ (void)releaseDetector
{
    [g_detector release];
    g_detector = nil;
}

+ (NSString *)bytesToAvaiUnit:(int)bytes
{
    if(bytes < 1024)     // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

+ (NSString *)timestamp:(time_t)time
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
        [dateFormatter setTimeStyle:kCFDateFormatterFullStyle];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    
    return timestamp;
}
+ (time_t)uptime
{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    //time_t uptime = -1;
    
    (void)time(&now);
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        //uptime = now - boottime.tv_sec;
    }
    //return uptime;
    
    return boottime.tv_sec;
}
+ (NSDate *)bootTime
{
    time_t boot = [FlowDataDetector uptime];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:boot];
    
    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSProcessInfo processInfo].systemUptime];
    return date;
}
+ (MonthFlowData *)getCurrentTotalFlowData
{
    _Log(@"boot time: %@", [FlowDataDetector bootTime]);
    
    BOOL success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    MonthFlowData *currentTotal = [[[MonthFlowData alloc] init] autorelease];
    
    NSString *name = [[[NSString alloc] init] autorelease];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name = [NSString stringWithFormat:@"%s", cursor->ifa_name];
            
            _Log(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {                
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *)cursor->ifa_data;
                    
                    currentTotal.wifiSent += networkStatisc->ifi_obytes;
                    currentTotal.wifiReceived += networkStatisc->ifi_ibytes;
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *)cursor->ifa_data;
                    
                    currentTotal.WWANSent += networkStatisc->ifi_obytes;
                    currentTotal.WWANReceived += networkStatisc->ifi_ibytes;
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    _Log(@"WiFiSent %@\n", [FlowDataDetector bytesToAvaiUnit:currentTotal.wifiSent]);
    _Log(@"WiFiReceived %@\n", [FlowDataDetector bytesToAvaiUnit:currentTotal.wifiReceived]);
    
    _Log(@"WWANSent %@\n", [FlowDataDetector bytesToAvaiUnit:currentTotal.WWANSent]);
    _Log(@"WWANReceived %@\n", [FlowDataDetector bytesToAvaiUnit:currentTotal.WWANReceived]);
    
    return currentTotal;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _bootTime = [FlowDataDetector bootTime];
        
        NSFileManager* fileMan = [NSFileManager defaultManager];
        if([fileMan fileExistsAtPath:kFlowDataFile])
        {
            _lastSavedTime = NSUtil::ModifyDate(kFlowDataFile);
            _recordArray = [[NSKeyedUnarchiver unarchiveObjectWithFile:kFlowDataFile] retain];
        }
        else
        {
            _recordArray = [[NSMutableArray alloc] init];
        }
        
        if (_lastSavedTime && NSOrderedAscending != [_bootTime compare:_lastSavedTime])
        {
            NSUtil::SetSettingForKey(kLastBaseWifiSent, [NSNull null]);
            NSUtil::SetSettingForKey(kLastBaseWifiReceived, [NSNull null]);
            NSUtil::SetSettingForKey(kLastBaseWWANSent, [NSNull null]);
            NSUtil::SetSettingForKey(kLastBaseWWANReceived, [NSNull null]);
            NSUtil::SaveSettings();
        }
        else
        {
            _lastBaseWifiSent = [NSUtil::SettingForKey(kLastBaseWifiSent) unsignedIntValue];
            _lastBaseWifiReceived = [NSUtil::SettingForKey(kLastBaseWifiReceived) unsignedIntValue];
            _lastBaseWWANSent = [NSUtil::SettingForKey(kLastBaseWWANSent) unsignedIntValue];
            _lastBaseWWANReceived = [NSUtil::SettingForKey(kLastBaseWWANReceived) unsignedIntValue];
        }
    }
    
    return self;
}

- (void)sendBeginUpdateNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDetectFlowDataNotification object:nil userInfo:nil];
}

- (void)sendEndUpdateNotification
{
    NSDictionary *dict = [NSDictionary dictionary];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDetectFlowDataNotification object:nil userInfo:dict];
}

- (void)updateStates
{
    _Log(@"******updateStates begin**********");
    
    [self performSelectorOnMainThread:@selector(sendBeginUpdateNotification) withObject:nil waitUntilDone:NO];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"yyyy-MM";
    NSString *key = [formatter stringForObjectValue:date];
    //NSString *key = @"2012-10";
    
    MonthFlowData *currentTotal = [FlowDataDetector getCurrentTotalFlowData];
    
    if (![_recordArray count])
    {
        // 如果没有记录，加进去
        MonthFlowData *flowData = [[MonthFlowData alloc] init];
        flowData.key = key;
        flowData.wifiSent = currentTotal.wifiSent;
        flowData.wifiReceived = currentTotal.wifiReceived;
        flowData.WWANSent = currentTotal.WWANSent;
        flowData.WWANReceived = currentTotal.WWANReceived;
        
        [_recordArray addObject:flowData];
        
        [flowData release];
    }
    else
    {
        MonthFlowData *lastFlowData = [_recordArray objectAtIndex:0];
        if ([lastFlowData.key isEqualToString:key])
        {
            // 如果已有当前月的记录，修改它
            lastFlowData.wifiSent += currentTotal.wifiSent-_lastBaseWifiSent;
            lastFlowData.wifiReceived += currentTotal.wifiReceived-_lastBaseWifiReceived;
            lastFlowData.WWANSent += currentTotal.WWANSent-_lastBaseWWANSent;
            lastFlowData.WWANReceived += currentTotal.WWANReceived-_lastBaseWWANReceived;
        }
        else
        {
            // 否则加到第0个位置
            MonthFlowData *flowData = [[MonthFlowData alloc] init];
            flowData.key = key;
            flowData.wifiSent = currentTotal.wifiSent-_lastBaseWifiSent;
            flowData.wifiReceived = currentTotal.wifiReceived-_lastBaseWifiReceived;
            flowData.WWANSent = currentTotal.WWANSent-_lastBaseWWANSent;
            flowData.WWANReceived = currentTotal.WWANReceived-_lastBaseWWANReceived;
            
            [_recordArray insertObject:flowData atIndex:0];
            
            [flowData release];
        }
    }
    
    // 保存， 用来显示历史记录的
    if ([NSKeyedArchiver archiveRootObject:_recordArray toFile:kFlowDataFile])
    {
        _lastBaseWifiSent = currentTotal.wifiSent;
        _lastBaseWifiReceived = currentTotal.wifiReceived;
        _lastBaseWWANSent = currentTotal.WWANSent;
        _lastBaseWWANReceived = currentTotal.WWANReceived;
        
        NSUtil::SetSettingForKey(kLastBaseWifiSent, [NSNumber numberWithUnsignedInt:currentTotal.wifiSent]);
        NSUtil::SetSettingForKey(kLastBaseWifiReceived, [NSNumber numberWithUnsignedInt:currentTotal.wifiReceived]);
        NSUtil::SetSettingForKey(kLastBaseWWANSent, [NSNumber numberWithUnsignedInt:currentTotal.WWANSent]);
        NSUtil::SetSettingForKey(kLastBaseWWANReceived, [NSNumber numberWithUnsignedInt:currentTotal.WWANReceived]);
        NSUtil::SaveSettings();
        
        [self performSelectorOnMainThread:@selector(sendEndUpdateNotification) withObject:nil waitUntilDone:NO];
        _Log(@"******updateStates before post**********");
        
        if ([self saveItemToCurrentYear:key andFlowData:[_recordArray objectAtIndex:0]])
        {
            [self postToServer:key];
        }
    }
}

// 用来做提交的
- (BOOL)saveItemToCurrentYear:(NSString *)key andFlowData:(MonthFlowData *)flowData
{
    NSString *year = [key substringToIndex:4];
    
    NSString *flowFilePath = kYearFlowDataFile(year);
    
    NSMutableDictionary *dict = nil;
    
    NSFileManager* fileMan = [NSFileManager defaultManager];
    if([fileMan fileExistsAtPath:flowFilePath])
    {
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:flowFilePath];
    }
    else
    {
        dict = [NSMutableDictionary dictionary];
        [dict setObject:year forKey:@"year"];
    }
    
    // 使用 numberWithDouble 是因为服务器的格式需要
    NSString *month = [key substringFromIndex:5];
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithDouble:flowData.wifiReceived],
                                            [NSNumber numberWithDouble:flowData.wifiSent],
                                            [NSNumber numberWithDouble:flowData.WWANReceived],
                                            [NSNumber numberWithDouble:flowData.WWANSent], nil];
    
    [dict setObject:array forKey:month];
    
    return [dict writeToFile:flowFilePath atomically:YES];
}

- (void)postToServer:(NSString *)key
{
    NSString *year = [key substringToIndex:4];
    NSString *flowFilePath = kYearFlowDataFile(year);
    
    NSString *url = [DataLoader getFlowDataPostUrl];
    if (!url)
    {
        return;
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //构建可变字符串请求
    
    //将NSString类型转换成NSData类型，后面的参数为编码类型，这里是UTF-8
    NSData *requestData = [NSData dataWithContentsOfFile:flowFilePath];//[requestXML dataUsingEncoding:NSUTF8StringEncoding];
    
    //使用ASIHTTPRequest中的自定义请求参数的方法
    [request appendPostData:requestData];
    //设置请求方式
    [request setRequestMethod:@"POST"];
    
    //请求执行完会调用block中的代码
    [request setCompletionBlock:^{
        NSLog(@"Success");
        NSLog(@"%@",[request responseString]);
    }];
    
    //如果出现异常会执行block中的代码
    [request setFailedBlock:^{
        NSLog(@"Failed");
    }];
    
    [request startAsynchronous];
    
    [request release];
}

@end
