//
//  DataLoader.h
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface DataLoader : NSObject
{
    NSOperationQueue *_taskQueue;
    NSArray *_notificationArray;
    NSDictionary *_appsDictionary;
}

@property (nonatomic, retain) NSArray *notificationArray;
@property (nonatomic, retain) NSDictionary *appsDictionary;

+ (DataLoader *)loader;
+ (void)releaseLoader;

+ (BOOL)hasReadNotification:(NSString *)guid;
+ (void)setReadNotification:(NSString *)guid;

// api urls

+ (NSString *)getCompanyConfigUrl;
+ (NSString *)getOTAFileUrl;
+ (NSString *)getEnrollOTAUrl:(NSString *)otaServer port:(NSString *)port code:(NSString *)code;

+ (NSString *)getDeviceInfoPostUrl;
+ (NSString *)getNewsListUrl:(int)start andCount:(int)count;
+ (NSString *)getNewsDetailUrl:(NSString *)newsId;
+ (NSString *)getNotificationListUrl;
+ (NSString *)getNotificationDetailUrl:(NSString *)stringId;
+ (NSString *)getAppListUrl;
+ (NSString *)getSurveyUrl:(NSString *)stringId;
+ (NSString *)getFlowDataPostUrl;
+ (NSString *)getContactsVersionsUrl;
+ (NSString *)getContactLatestVersionInfoUrl;
+ (NSString *)getContactsDetailsUrl:(NSString *)version;
+ (NSString *)getContactsChangeIdUrl;

+ (void)detectAndPostDeviceInfo;

//+ ()
// 获取公司信息，OTA信息
- (void)getConfigFiles:(id <TaskDelegate>)delegate;

-(void)StartTaskForResults:(id<TaskDelegate>)delegate url:(NSURL *)url tskType:(TaskType)tsktype;
- (void)getNewsList:(id <TaskDelegate>)delegate start:(int)start andCount:(int)count;
- (void)getNewsDetail:(id <TaskDelegate>)delegate andId:(NSString *)newsId;
- (void)getNotificationList:(id <TaskDelegate>)delegate;
- (void)getNotificationDetails:(id <TaskDelegate>)delegate andNotificationId:(NSString *)notificationId;
- (void)getAppList:(id <TaskDelegate>)delegate;
- (void)backupPersonalContacts:(id <TaskDelegate>)delegate;
- (void)restorePersonalContacts:(id <TaskDelegate>)delegate;
- (void)getCompanyContacts:(id <TaskDelegate>)delegate;
- (void)detectAndPostFlowData:(id <TaskDelegate>)delegate;
- (void)detectAndPostDeviceInfo:(id <TaskDelegate>)delegate;

- (void)getLocalAndServerContactsCount:(id <TaskDelegate>)delegate;

// 关闭task
- (void)closeTaskWithType:(TaskType)type;

@end
