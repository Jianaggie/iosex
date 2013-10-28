//
//  NotificationDetailController.h
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskDelegate;

@interface NotificationDetailController : UIViewController <TaskDelegate>
{
    NSString *_notificationId;
    NSString *_surveyid;
}

- (id)initWithId:(NSString *)notificationId;

@end
