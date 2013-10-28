//
//  Task.m
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "Task.h"
#import "Defines.h"
#import "ASIHTTPRequest.h"
#import "DataLoader.h"
#import "FlowDataDetector.h"
#import "ContactsDetector.h"
#import "MBProgressHUD.h"
@interface TaskHelper : NSObject
+(id)GetWorkResults:(NSURL*) url;
+ (id)getMethodResult:(TaskType)type params:(NSDictionary *)params;

@end

@implementation TaskHelper
+(id)GetResult:(TaskType)type url:(NSURL*) url
{
    id <NSObject> result = nil;
    result = [TaskHelper GetWorkResults:url];
    return result;
}
+ (id)getMethodResult:(TaskType)type params:(NSDictionary *)params
{
    id <NSObject> result = nil;
    
    switch (type)
    {
        case Task_GetConfigFiles:
        {
            result = [TaskHelper getConfigFiles];
            break;
        }
            
        case Task_GetNewsList:
        {
            int start = [[params objectForKey:@"Start"] intValue];
            int count = [[params objectForKey:@"Count"] intValue];
            
            result = [TaskHelper loadMcdmNewsItem:start andCount:count];
            break;
        }
            
        case Task_GetNewsDetail:
        {
            result = [TaskHelper loadMcdmNewsDetail:[params objectForKey:@"NewsId"]];
            break;
        }
            
        case Task_GetNotificationList:
        {
            result = [TaskHelper getNotificationList];
            if ([result isKindOfClass:[NSArray class]])
            {
                [DataLoader loader].notificationArray = (NSArray *)result;
            }
            
            break;
        }
            
        case Task_GetNotificationDetails:
        {
            NSString *stringId = [params objectForKey:@"NotificationId"];
            result = [TaskHelper getNotificationDetail:stringId];
            
            break;
        }
            
        case Task_GetAppList:
        {
            result = [TaskHelper getAppList];
            if ([result isKindOfClass:[NSDictionary class]])
            {
                [DataLoader loader].appsDictionary = (NSDictionary *)result;
            }
            break;
        }
            
        case Task_DetectAndPostFlowData:
        {
            [[FlowDataDetector detector] updateStates];
            break;
        }
            
        case Task_DetectAndPostDeviceInfo:
        {
            [DataLoader detectAndPostDeviceInfo];
            break;
        }
            
        case Task_CheckLocalAndServerContactsInfo:
        {
            result = [[ContactsDetector detector] checkLocalAndServerContactsInfo];
            break;
        }
            
        case Task_BackupPersonalContacts:
        {
            result = [[ContactsDetector detector] checkChangesAndPost];
            break;
        }
            
        case Task_RestorePersonalContacts:
        {
            result = [[ContactsDetector detector] restoreFromServer];
            break;
        }
            
        default:
            break;
    }
    
    return result;
}
+(id)GetWorkResults:(NSURL*) url;
{
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	[ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
	request.timeOutSeconds = kTimeOut;
	request.requestMethod = @"GET";
    
    [request startSynchronous];
    
    id <NSObject> result = nil;
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];
        NSArray *array = NSUtil::arrayWithContentsOfData(responseData);
        result = array;
        if (nil == result) {
            NSDictionary* dct = NSUtil::dictionaryWithContentsOfData(responseData);
            result = dct;
        }
    }
    else
    {
        result = error;
    }
    
    [request release];
    
    return result;
}
+ (id)getConfigFiles
{
    id <NSObject> result = nil;
    
    // 下载公司信息文件
    {
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[DataLoader getCompanyConfigUrl]]];
        [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
        request.timeOutSeconds = kTimeOut;
        request.requestMethod = @"GET";
        
        [request startSynchronous];
        
        NSError *error = [request error];
        if (!error)
        {
            NSData *responseData = [request responseData];
            
            NSDictionary * dict = NSUtil::dictionaryWithContentsOfData(responseData);
            
            _Log(@"config file:\n%@", dict);
            
            [dict writeToFile:kCompanyInfoFile atomically:YES];
        }
        else
        {
            result = error;
        }
        
        [request release];
    }
    
    // 获取OTA信息文件
    {
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[DataLoader getOTAFileUrl]]];
        [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
        request.timeOutSeconds = kTimeOut;
        request.requestMethod = @"GET";
        
        [request startSynchronous];
        
        NSError *error = [request error];
        if (!error)
        {
            NSData *responseData = [request responseData];
            
            NSDictionary * dict = NSUtil::dictionaryWithContentsOfData(responseData);
            
            _Log(@"ota file:\n%@", dict);
            
            [dict writeToFile:kOTAInfoFile atomically:YES];
        }
        else
        {
            result = error;
        }
        
        [request release];
    }
    
    return result;
}
+ (id)loadMcdmNewsItem:(int)start andCount:(int)count
{
    NSString *url = [DataLoader getNewsListUrl:start andCount:count];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
	request.timeOutSeconds = kTimeOut;
	request.requestMethod = @"GET";
    
    [request startSynchronous];
    
    id <NSObject> result = nil;
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];
        NSArray *array = NSUtil::arrayWithContentsOfData(responseData);
        result = array;
    }
    else
    {
        result = error;
    }
    
    [request release];
    
    return result;
}

+ (id)loadMcdmNewsDetail:(NSString *)newsId
{
    NSString *url = [DataLoader getNewsDetailUrl:newsId];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
	request.timeOutSeconds = kTimeOut;
	request.requestMethod = @"GET";
    
    [request startSynchronous];
    
    id <NSObject> result = nil;
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];
        NSDictionary *dict = NSUtil::dictionaryWithContentsOfData(responseData);
        result = dict;
    }
    else
    {
        result = error;
    }
    
    [request release];
    
    return result;
}

+ (id)getNotificationList
{
    NSString *url = [DataLoader getNotificationListUrl];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
	request.timeOutSeconds = kTimeOut;
	request.requestMethod = @"GET";
    
    [request startSynchronous];
    
    id <NSObject> result = nil;
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];
        NSArray *array = NSUtil::arrayWithContentsOfData(responseData);
        result = array;
    }
    else
    {
        result = error;
    }
    
    [request release];
    
    return result;
}

+ (id)getNotificationDetail:(NSString *)stringId
{
    NSString *url = [DataLoader getNotificationDetailUrl:stringId];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
	request.timeOutSeconds = kTimeOut;
	request.requestMethod = @"GET";
    
    [request startSynchronous];
    
    id <NSObject> result = nil;
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];
        
        NSDictionary * dict = NSUtil::dictionaryWithContentsOfData(responseData);
        
        result = dict;
    }
    else
    {
        result = error;
    }
    
    [request release];
    
    return result;
}

+ (id)getAppList
{
    NSString *url = [DataLoader getAppListUrl];
    if (!url)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kNoServerUrlErrorInfo, NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:dict];
        return error;
    }
    
    _Log(@"getAppList:%@", url);
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
	request.timeOutSeconds = kTimeOut;
	request.requestMethod = @"GET";
    
    [request startSynchronous];
    
    id <NSObject> result = nil;
    NSError *error = [request error];
    if (!error)
    {
        NSData *responseData = [request responseData];
        
        NSDictionary * dict = NSUtil::dictionaryWithContentsOfData(responseData);
        
        result = dict;
    }
    else
    {
        result = error;
    }
    
    [request release];
    
    return result;
}

@end

@implementation Task

@synthesize delegate=_delegate, type=_type, guid=_guid;
- (id)initWithTypeUrl:(TaskType)type url:(NSURL*) url
{
    self = [super init];
    if (self)
    {
        _url = [url retain];
        _type = type;
    }
    return self;
}
- (id)initWithType:(TaskType)type params:(NSDictionary *)params;
{
    self = [super init];
    if (self)
    {
        _url = nil;
        _params = [params retain];
        _type = type;
    }
    
    return self;
}

- (void)dealloc
{
    [_params release];
    [_guid release];
    [_result release];
    [super dealloc];
}

- (void)main
{
    [self performSelectorOnMainThread:@selector(taskStarted) withObject:nil waitUntilDone:NO];
    
    if ([self isCancelled])
    {
        return;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (nil == _url) {
        _result = [[TaskHelper getMethodResult:_type params:_params] retain];
    }
    else
    {
        _result = [[TaskHelper GetResult:_type url:_url] retain];
    }
    [pool drain];
    
    [self performSelectorOnMainThread:@selector(taskFinished) withObject:nil waitUntilDone:NO];
}

- (void)cancel
{
    _delegate = nil;
    
    _Log(@"Task is canceled!");
    
    [super cancel];
}

// help functions.
- (void)taskStarted
{
    if (_delegate && [_delegate respondsToSelector:@selector(taskStarted:)])
    {
        [_delegate taskStarted:_type];
    }
    else if(nil != _url)
    {
        UIViewController* VCtrllr = (UIViewController*)_delegate;
        [MBProgressHUD showHUDAddedTo:VCtrllr.view animated:YES];
    }
}

- (void)taskFinished
{
    if (nil != _url) {
        UIViewController* VCtrllr = (UIViewController*)_delegate;
        [MBProgressHUD hideHUDForView:VCtrllr.view animated:YES];
    }
    if (_type == Task_GetNotificationList)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetNotificationListNotification object:nil userInfo:nil];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(taskFinished: result:)])
    {
        [_delegate taskFinished:_type result:_result];
    }
}

@end