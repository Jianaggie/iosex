//
//  TableViewController.h
//  Tableview
//
//  Created by wang doublejie on 12-4-8.
//  Copyright (c) 2012年 东王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullView.h"

@class PullView;

@interface CompanyContactsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, PullViewDelegate>
{
    PullView *_pullView;
    NSArray *listarray;
    NSArray *secLabelArray;
    NSMutableDictionary *arrayDict;
    NSArray *arrayDictKey;
    UITableView* tableView;
}
//@property (nonatomic, retain)UISegmentedControl* tableControllSeg;
@property (nonatomic,retain)NSArray *listarray;
@property (nonatomic,retain)NSArray *secLabelArray;
@property (nonatomic,retain)NSMutableDictionary *arrayDict;
@property (nonatomic,retain)NSArray *arrayDictKey;
@property (nonatomic,retain)UITableView* tableView;
-(void)setNavigationController:(UIViewController*)VCtrllr;
-(void)GetContactFromSvr;
@end
