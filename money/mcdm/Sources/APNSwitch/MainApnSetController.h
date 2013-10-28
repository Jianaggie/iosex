//
//  MainApnSetController.h
//  unuion03
//
//  Created by easystudio on 11/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetViewController.h"
#import "IntranetViewController.h"
#import "NetworkViewController.h"
#import "EditApnInfoController.h"
 
@interface MainApnSetController : UIViewController {
    UISegmentedControl *uiS;
    InternetViewController *internetView;//外网
    IntranetViewController *intranetView;//内网
    UIImageView *uiimgView;
    UIScrollView *mainScrollView;
    EditApnInfoController *editController;
}

@property (nonatomic,retain) IBOutlet UISegmentedControl *uiS;
@property (nonatomic,retain) IBOutlet  UIImageView *uiimgView;
@property (nonatomic,retain) IBOutlet  UIScrollView *mainScrollView;
@property (nonatomic,retain) IBOutlet  NetworkViewController *addapnview;
@property (nonatomic,retain) IBOutlet  EditApnInfoController *editController;
-(IBAction)toggleControls:(id)sender;
-(void)setDefaultSegmentValue:(NSInteger)i;//设置默认值
-(void)deleteTableRow;//删除表格数据
-(IBAction)back;//返回
-(void)navaddApnInfo;//导航到添加APN页面
-(void)navEditApnInfo:(id*)apn;//导航到编辑页面
//-(void)reLoadTableView;//重新加载表格视图
@end
