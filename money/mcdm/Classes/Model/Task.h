//
//  Task.h
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    Task_GetConfigFiles,
    
    Task_GetNewsList,
    Task_GetNewsDetail,
    
    Task_GetNotificationList,
    Task_GetNotificationDetails,
    Task_GetAppList,
    Task_BackupPersonalContacts,
    Task_RestorePersonalContacts,
    Task_GetCompanyContacts,
    Task_DetectAndPostFlowData,
    Task_DetectAndPostDeviceInfo,
    
    Task_CheckLocalAndServerContactsInfo,//用来获取本地、远程数量
    Task_DetectNewVersion,
    
}TaskType;

@protocol TaskDelegate <NSObject>

- (void)taskStarted:(TaskType)type;

// NSError or data object.
- (void)taskFinished:(TaskType)type result:(id)result;

@end

@interface Task : NSOperation
{
    TaskType _type;
    NSURL* _url;
    NSDictionary *_params;
    NSString *_guid;
    
    id <TaskDelegate> _delegate;
    
    NSObject *_result;
}

@property (nonatomic, assign) id <TaskDelegate> delegate;
@property (nonatomic, readonly) TaskType type;
@property (nonatomic, retain) NSString *guid;

- (id)initWithTypeUrl:(TaskType)type url:(NSURL*) url;
- (id)initWithType:(TaskType)type params:(NSDictionary *)params;

@end
