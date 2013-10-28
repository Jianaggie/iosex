//
//  FlowDataViewController.h
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface FlowDataViewController : BaseController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@end
