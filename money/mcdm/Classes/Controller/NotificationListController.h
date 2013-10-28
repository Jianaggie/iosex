//
//  NotificationListController.h
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationListController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    
    BOOL _readNotification;
}

@end
