//
//  NetworkViewController.h
//  Network
//
//  Created by MagicStudio on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSStreamAdditions.h"
#import "ApnInfo.h"
#import "InitInfoController.h"
//#import "InternetViewController.h"

//新增 apn信息

#define kNumberOfEditableRowsAdd    6
#define kdescnRowIndex           0
#define kapnRowIndex             1
#define kuserRowIndex            2
#define kpwdRowIndex             3
#define kipRowIndex              4
#define kportRowIndex            5
#define kstatusRowIndex          6

#define kLabelTag                4096
@interface NetworkViewController :  UIViewController<UITextFieldDelegate>{
    
    InitInfoController *initInfoController;//初始化 服务器页面对象
    // InternetViewController *internetViewController;//公网apnview对象
    ApnInfo *apninfo;
    NSArray *fieldLabels;
    NSMutableDictionary *tempValues;
    UITextField *textFieldBeingEdited;  
    UITableView *tableViews;
    NSString   *apnType;//写入文件的类型(公网还是内网)

}

 

@property (nonatomic,retain) IBOutlet  InitInfoController *initInfoController;
//@property (nonatomic,retain) IBOutlet  InternetViewController *internetViewController;

//表格相关
@property (nonatomic,retain)   ApnInfo *apninfo;
@property (nonatomic, retain) NSArray *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary *tempValues;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;
@property (nonatomic, retain) IBOutlet UITableView *tableViews;

@property (nonatomic, copy) NSString  *apnType;

-(IBAction) btnSend;

-(IBAction)backgroundTap:(id)sender;
//读取 APN
-(NSString *)readFile:(NSString *)RfileName;

 
-(IBAction)initServerInfo;//转到服务器信息
//写入文件 把apn信息
-(void)writeFile:(NSMutableString *)apnContent;

//文本填写完成时调用
- (IBAction)textFieldDone:(id)sender;
//(void)internetView;//转到公网APN
-(void)goApnSetingView;//转到apn设置页面
-(void)back;
@end
