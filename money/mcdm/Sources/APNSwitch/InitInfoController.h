//
//  InitInfoController.h
//  初始化服务器信息类
//
//  Created by MagicStudio on 11-4-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitServerSet.h"
//#import "AsyncSocket.h"

#define kinitNumberOfEditableRows    6
#define kServerInteretAPNRowIndex        0
#define kServerInteretUserRowIndex  1 
#define kServerInteretPwdRowIndex      2
#define kServerIntrantAPNRowIndex   3
#define kServerIntrantUserRowIndex   4
#define kServerIntrantPwdRowIndex   5

 



//#define kButtonConnServerIndex   5//按钮
#define kLabelTag                    4096
//UITableViewController <UITextFieldDelegate> ,UITableViewDataSource,UITableViewDelegate
@interface InitInfoController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate> {

    //表格相关
    InitServerSet *initInfo;
    NSArray *fieldLabels;
    NSMutableDictionary *tempValues;
    UITextField *textFieldBeingEdited;  
    UITableView *tableViews;
    
   // AsyncSocket *testasyncSocket;//异步网络对象
    NSMutableString *currentConnIP;//当前连接的ip
    NSMutableString *currentConnPort;//端口
    
    bool keyboardShown;//键盘按下
    UITextField *activeField;// 当前便捷表格
   
}
-(IBAction)saveServerInfo;//保存服务器信息
//-(IBAction)backgroundTap:(id)sender;//取消输入键盘

//写入 联通默认的APN信息
//-(void)writeUnionNetAPN;
//把数据 写入文件
 -(void)writeApnFile:(NSMutableString *)apnContent fileName:(NSString *)fileName;
//读取 APN 参数
-(NSString *)readFile:(NSString *)RfileName;


//表格相关

@property (nonatomic, retain) InitServerSet *initInfo;
@property (nonatomic, retain) NSArray *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary *tempValues;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;
@property (nonatomic, retain) IBOutlet UITableView *tableViews;
//- (IBAction)cancel:(id)sender;
//- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;
//键盘事件
//- (void)registerForKeyboardNotifications;

@end
