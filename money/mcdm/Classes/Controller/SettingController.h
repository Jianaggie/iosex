//
//  SettingController.h
//  MCDM
//
//  Created by Fred on 12-12-29.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskDelegate;
@interface SettingController : UIViewController <UITableViewDataSource, UITableViewDelegate, TaskDelegate>

@end
