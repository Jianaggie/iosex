//
//  NewsViewController.h
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@protocol TaskDelegate;
@protocol PullViewDelegate;

@class FocusHeaderImageNewsView;
@class PullView;
@class LoadingMoreFooterView;

@interface NewsViewController : BaseController <UITableViewDataSource, UITableViewDelegate, TaskDelegate, PullViewDelegate>
{
    NSMutableArray *_items;
    NSMutableArray *_focusItems;
    UITableView *_tableView;
    
    FocusHeaderImageNewsView *_headerNewsView;
    PullView *_pullView;
    
    LoadingMoreFooterView *_loadMoreFootView;
    BOOL _isLoadMore;
}

@end
