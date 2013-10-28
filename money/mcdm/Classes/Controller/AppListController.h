//
//  AppListController.h
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskDelegate;
@class FocusHeaderAppView;

@protocol PullViewDelegate;
@class PullView;

@interface AppListController : UIViewController <UITableViewDataSource, UITableViewDelegate, TaskDelegate, PullViewDelegate>
{
    NSMutableArray *_items;
    NSArray *_focusItems;
    UITableView *_tableView;
    
    FocusHeaderAppView *_headerView;
    
    NSString *_catalog;
    NSString *_subCatalog;
    
    PullView *_pullView;
}

- (id)initWithCatalog:(NSString *)catalog andSubCatalog:(NSString *)subCatalog;

@end
