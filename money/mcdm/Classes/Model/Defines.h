//
//  Defines.h
//  MCDM
//
//  Created by Fred on 12-12-28.
//  Copyright (c) 2012年 Fred. All rights reserved.
//
#define TAB_BAR_HEIGHT 49
#define kContactRecordIDKey @"200"
#define kContactOperationKey @"100"

#define kTimeOut 30

// 设置里面的server url 的key
#define kServerKey @"ServerUrl"

// 如果 setting里面的code不为空，则会启动 获取company及ota 文件 的任务
#define kCodeKey @"CodeKey"

#define kNoServerUrlErrorInfo @"没有服务器地址，请先加入系统"

#define kWizardDone @"WizardDone"

// 所有地址 移至 DataLoader
//#define kNotificationListUrl @"http://59.34.57.77:8080/mcdm/resource/notificationSurvey?udid=58401517f74214c2f7e4ae5090015fdba600d928"
//#define kNotificationDetailUrl(stringId) [NSString stringWithFormat:@"http://59.34.57.77:8080/", stringId]

//#define kAppListUrl @"http://59.34.57.77:8080/58401517f74214c2f7e4ae5090015fdba600d928"

//#define kSurveyUrl(stringId) [NSString stringWithFormat:@"http://59.34.57.77:8080/mcdm/survey/fillsurvey.seam?udid=58401517f74214c2f7e4ae5090015fdba600d928&surveyuuid=%@", stringId]

//#define kFlowDataPostUrl @"http://59.34.57.77:8080/mcdm/resource/traffic?os=ios&udid=58401517f74214c2f7e4ae5090015fdba600d928"

//#define kContactsVersionsUrl @"http://59.34.57.77:8080/mcdm/resource/addressbook?os=ios&udid=58401517f74214c2f7e4ae5090015fdba600d928"
//#define kContactsDetailsUrl(version) [NSString stringWithFormat:@"http://59.34.57.77:8080/mcdm/resource/addressbook?os=ios&udid=58401517f74214c2f7e4ae5090015fdba600d928&version=%@", version]

//#define kContactsChangeIdUrl @"http://59.34.57.77:8080/mcdm/resource/addressbook?os=ios&udid=58401517f74214c2f7e4ae5090015fdba600d928&type=update"

#define kCompanyInfoFile NSUtil::DocumentsSubPath(@"CompanyInfoFile.xml")
#define kOTAInfoFile NSUtil::DocumentsSubPath(@"OTAInfoFile.xml")

// 通知key
#define kGetNotificationListNotification @"GetNotificationListNotification"
#define kDetectFlowDataNotification @"kDetectFlowDataNotification"

#define kContactProgressNotification @"ContactProgressNotification"
#define kContactProgressKey @"ContactProgressKey"

#define kNewKey @"NEW"
#define kUpdateKey @"UPDATE"
#define kDeleteKey @"DELETE"

#define kNewsCountPerPage 20