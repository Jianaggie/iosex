//
//  DataLoader.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "DataLoader.h"
#import "ContactsDetector.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "ASIHTTPRequest.h"

#define kMaxTaskCount 10

static DataLoader *g_dataloader = nil;

@implementation DataLoader

@synthesize notificationArray=_notificationArray;
@synthesize appsDictionary=_appsDictionary;

+ (DataLoader *)loader
{
    if (!g_dataloader)
    {
        g_dataloader = [[DataLoader alloc] init];
    }
    
    return g_dataloader;
}

+ (void)releaseLoader
{
    [g_dataloader release];
    g_dataloader = nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _taskQueue = [[NSOperationQueue alloc] init];
        [_taskQueue setMaxConcurrentOperationCount:kMaxTaskCount];
        
        [self detectAndPostFlowData:nil];
        
        [ContactsDetector detector];
        
        _Log(@"BundlePath:%@", NSUtil::BundlePath());
    }
    
    return self;
}

- (void)dealloc
{
    [_appsDictionary release];
    [_notificationArray release];
    [_taskQueue release];
    [super dealloc];
}

//
#define kReadStatusPath	NSUtil::CacheSubPath(@"ReadStatus.plist")
static NSMutableArray *s_readStatus = nil;
+ (BOOL)hasReadNotification:(NSString *)guid
{
	if (s_readStatus == nil)
	{
		s_readStatus = [[NSMutableArray alloc] initWithContentsOfFile:kReadStatusPath];
		if (s_readStatus == nil) s_readStatus = [[NSMutableArray alloc] init];
	}
	return [s_readStatus containsObject:guid];
}

//
+ (void)setReadNotification:(NSString *)guid
{
	if (![DataLoader hasReadNotification:guid])
	{
		[s_readStatus addObject:guid];
		[s_readStatus writeToFile:kReadStatusPath atomically:YES];
	}
}

+ (NSString *)getCompanyConfigUrl
{
    // http://ip:port/mcdm/resource/sif?code=XXX&os=ios
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    // 这里不判断，因为肯定有server url才会去启动这个task

    NSString *code = NSUtil::SettingForKey(kCodeKey);
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/sif?code=%@&os=ios", serverUrl, code];
}

+ (NSString *)getOTAFileUrl
{
    // http://ip:port/mcdm/resource/dmc?code=XXX&os=ios
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    // 这里不判断，因为肯定有server url才会去启动这个task
    
    NSString *code = NSUtil::SettingForKey(kCodeKey);
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/dmc?code=%@&os=ios", serverUrl, code];
}

+ (NSString *)getEnrollOTAUrl:(NSString *)otaServer port:(NSString *)port code:(NSString *)code
{
    // http://ip:port/mcdm/resource/ota/startEnroll?code=XXX&os=ios
    
    if (![port length])
    {
        return [NSString stringWithFormat:@"https://%@/mcdm/resource/ota/startEnroll?code=%@&os=ios", otaServer, code];
    }
    
    return [NSString stringWithFormat:@"https://%@:%@/mcdm/resource/ota/startEnroll?code=%@&os=ios", otaServer, port, code];
}

+ (NSString *)getDeviceInfoPostUrl
{
    // http://ip:port/mcdm/resource/deviceInfo?udid=XXX
    
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/deviceinfo?os=ios&udid=%@", serverUrl, uuid];
}

+ (NSString *)getNewsListUrl:(int)start andCount:(int)count
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/informationList?udid=%@&start=%d&size=%d", serverUrl, uuid, start, count];
}

+ (NSString *)getNewsDetailUrl:(NSString *)newsId
{
    // http://ip:port/mcdm/resource/informationList?udid=XXX&id=XXX
    
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/informationList?udid=%@&id=%@", serverUrl, uuid, newsId];
}

+ (NSString *)getNotificationListUrl
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/notificationSurvey?udid=%@", serverUrl, uuid];
}

+ (NSString *)getNotificationDetailUrl:(NSString *)stringId
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/notificationSurvey?udid=%@&id=%@", serverUrl, uuid, stringId];
}

+ (NSString *)getAppListUrl
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/softwarelist?os=ios&udid=%@", serverUrl, uuid];
}

+ (NSString *)getSurveyUrl:(NSString *)stringId
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/survey/fillsurvey.seam?udid=%@&surveyuuid=%@", serverUrl, uuid, stringId];
}

+ (NSString *)getFlowDataPostUrl
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/traffic?os=ios&udid=%@", serverUrl, uuid];
}

+ (NSString *)getContactsVersionsUrl
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/addressbook?os=ios&udid=%@", serverUrl, uuid];
}

+ (NSString *)getContactLatestVersionInfoUrl
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/addressbook?os=ios&udid=%@&status", serverUrl, uuid];
}

+ (NSString *)getContactsDetailsUrl:(NSString *)version
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/addressbook?os=ios&udid=%@&version=%@", serverUrl, uuid, version];
}

+ (NSString *)getContactsChangeIdUrl
{
    NSString *serverUrl = NSUtil::SettingForKey(kServerKey);
    if (!serverUrl)
    {
        return nil;
    }
    
    NSString *uuid = NSUtil::GetUUID();
    
    return [NSString stringWithFormat:@"%@/mcdm/resource/addressbook?os=ios&udid=%@&type=update", serverUrl, uuid];
}

- (void)startTaskForResult:(TaskType)type params:(NSDictionary *)params delegate:(id <TaskDelegate>)delegate
{
    Task *task = [[Task alloc] initWithType:type params:params];
    task.delegate = delegate;
    [_taskQueue addOperation:[task autorelease]];
}

+ (void)detectAndPostDeviceInfo
{
    // {"carrierName":"","carrierInfo":"","isoCountryCode":"cn","mobileCountryCode":"cn","type":"CDMA","mobileNetworkCode":"03"}
    
    // 获取营运商信息
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    
    NSString *carrierName = @"";
    NSString *mobileCountryCode = @"";
    NSString *mobileNetworkCode = @"";
    NSString *isoCountryCode = @"";
    
    NSString *type = @"carrierInfo";

    if (carrier)
    {
        _Log(@"carrier:%@", [carrier description]);
        carrierName = carrier.carrierName;
        mobileCountryCode = carrier.mobileCountryCode;
        mobileNetworkCode = carrier.mobileNetworkCode;
        isoCountryCode = carrier.isoCountryCode;
    }
    
    NSString *postInfo = [NSString stringWithFormat:@"{\"carrierName\":\"%@\",\"isoCountryCode\":\"%@\",\"mobileCountryCode\":\"%@\",\"type\":\"%@\",\"mobileNetworkCode\":\"%@\"}", carrierName, isoCountryCode, mobileCountryCode, type, mobileNetworkCode];
    
    _Log(@"postInfo, %@", postInfo);
    
    [info release];
    
    NSString *url = [DataLoader getDeviceInfoPostUrl];
    if (!url)
    {
        return;
    }
    
    _Log(@"getDeviceInfoPostUrl, %@", url);
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    //postInfo = [postInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *requestData = [postInfo dataUsingEncoding:NSUTF8StringEncoding];
    [request appendPostData:requestData];
    [request setRequestMethod:@"POST"];
    
    [request startSynchronous];
    
    _Log(@"detectAndPostDeviceInfo responseStatusCode: %d", request.responseStatusCode);
    
    NSError *error = [request error];
    if (!error)
    {
        _Log(@"detectAndPostDeviceInfo success");
    }
    else
    {
        _Log(@"%@", [error localizedDescription]);
    }
    
    [request release];
}
-(void)StartTaskForResults:(id<TaskDelegate>)delegate url:(NSURL *)url tskType:(TaskType)tsktype
{
    Task *task = [[Task alloc] initWithTypeUrl:tsktype url:url];
    task.delegate = delegate;
    [_taskQueue addOperation:[task autorelease]];
}
- (void)getConfigFiles:(id <TaskDelegate>)delegate
{
    for (NSOperation *operation in _taskQueue.operations)
    {
        Task *task = (Task *)operation;
        if (task.type == Task_GetConfigFiles)
        {
            return;
        }
    }
    
    [self startTaskForResult:Task_GetConfigFiles params:nil delegate:delegate];
}

- (void)getNewsList:(id <TaskDelegate>)delegate start:(int)start andCount:(int)count
{
    for (NSOperation *operation in _taskQueue.operations)
    {
        Task *task = (Task *)operation;
        if (task.type == Task_GetNewsList)
        {
            return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:start] forKey:@"Start"];
    [params setObject:[NSNumber numberWithInt:count] forKey:@"Count"];
    
    [self startTaskForResult:Task_GetNewsList params:params delegate:delegate];
}

- (void)getNewsDetail:(id <TaskDelegate>)delegate andId:(NSString *)newsId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:newsId forKey:@"NewsId"];
    
    [self startTaskForResult:Task_GetNewsDetail params:params delegate:delegate];
}

- (void)getNotificationList:(id <TaskDelegate>)delegate
{
    for (NSOperation *operation in _taskQueue.operations)
    {
        Task *task = (Task *)operation;
        if (task.type == Task_GetNotificationList)
        {
            return;
        }
    }

    [self startTaskForResult:Task_GetNotificationList params:nil delegate:delegate];
}

- (void)getNotificationDetails:(id <TaskDelegate>)delegate andNotificationId:(NSString *)notificationId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:notificationId forKey:@"NotificationId"];
    
    [self startTaskForResult:Task_GetNotificationDetails params:params delegate:delegate];
}

- (void)getAppList:(id <TaskDelegate>)delegate
{
    [self startTaskForResult:Task_GetAppList params:nil delegate:delegate];
}

- (void)backupPersonalContacts:(id <TaskDelegate>)delegate
{
    [self startTaskForResult:Task_BackupPersonalContacts params:nil delegate:delegate];
}

- (void)restorePersonalContacts:(id <TaskDelegate>)delegate
{
    [self startTaskForResult:Task_RestorePersonalContacts params:nil delegate:delegate];
}

- (void)getCompanyContacts:(id <TaskDelegate>)delegate
{
    
}

- (void)detectAndPostFlowData:(id <TaskDelegate>)delegate
{
    for (NSOperation *operation in _taskQueue.operations)
    {
        Task *task = (Task *)operation;
        if (task.type == Task_DetectAndPostFlowData)
        {
            return;
        }
    }
    
    [self startTaskForResult:Task_DetectAndPostFlowData params:nil delegate:delegate];
}

- (void)detectAndPostDeviceInfo:(id <TaskDelegate>)delegate
{
    for (NSOperation *operation in _taskQueue.operations)
    {
        Task *task = (Task *)operation;
        if (task.type == Task_DetectAndPostDeviceInfo)
        {
            return;
        }
    }
    
    [self startTaskForResult:Task_DetectAndPostDeviceInfo params:nil delegate:delegate];
}

- (void)getLocalAndServerContactsCount:(id <TaskDelegate>)delegate
{
    for (NSOperation *operation in _taskQueue.operations)
    {
        Task *task = (Task *)operation;
        if (task.type == Task_CheckLocalAndServerContactsInfo || task.type == Task_BackupPersonalContacts || task.type == Task_RestorePersonalContacts)
        {
            return;
        }
    }
    
    [self startTaskForResult:Task_CheckLocalAndServerContactsInfo params:nil delegate:delegate];
}

- (void)closeTaskWithType:(TaskType)type
{
    for (Task *task in _taskQueue.operations)
    {
        if (task.type == type)
        {
            [task cancel];
        }
    }
}

@end
