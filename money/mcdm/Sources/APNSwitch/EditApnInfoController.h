//
//  EditApnInfoController.h
//  unuion03
//
//  Created by MagicStudio on 11-4-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApnInfo.h"
#define kNumberOfEditableRows    6
#define kdescnRowIndex           0
#define kapnRowIndex             1
#define kuserRowIndex            2
#define kpwdRowIndex             3
#define kipRowIndex              4
#define kportRowIndex            5
#define kstatusRowIndex          6
#define kLabelTag                4096


//#define kNumberOfEditableRowsAdd    6
//#define kdescnRowIndex           0
//#define kapnRowIndex             1
//#define kuserRowIndex            2
//#define kpwdRowIndex             3
//#define kipRowIndex              4
//#define kportRowIndex            5
//#define kstatusRowIndex          6


//编辑apn
@interface EditApnInfoController : UIViewController<UITextFieldDelegate> {
    ApnInfo *apninfo;//该对象 存储 主页面表格传来的数据
   
    
   // 表格相关
    NSArray *fieldLabels;
    NSMutableDictionary *tempValues;
    UITextField *textFieldBeingEdited;  
    UITableView *tableViews;
    NSString *editApnType;//编辑的是公网或专网
}
@property (nonatomic,retain)   ApnInfo *apninfo;
 

//表格相关
@property (nonatomic, retain) NSArray *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary *tempValues;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;
@property (nonatomic, retain) IBOutlet UITableView *tableViews;
@property (nonatomic,copy) NSString *editApnType;
-(IBAction)back;//返回 主页
//取消键盘
-(IBAction)backgroundTap:(id)sender;
//提交
-(IBAction)submitApnInfo;

//文本填写完成时调用
- (IBAction)textFieldDone:(id)sender;
-(void)goApnSetingView;
-(void)writeConfigContent;
@end
