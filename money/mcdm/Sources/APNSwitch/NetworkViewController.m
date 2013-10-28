//
//  NetworkViewController.m
//  
//该类处理 发送apn信息
//  Created by MagicStudio on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NetworkViewController.h"
#import "NSStreamAdditions.h"
#import "UtilNet.h"
#import <Foundation/NSFileManager.h>
#import <Foundation/NSDictionary.h>
#import "InitInfoController.h"
#import "AppDelegate.h"
#import "RegexKitLite.h"
#import "MainApnSetController.h"
//#import "InternetViewController.h"
//#import "IntranetViewController.h"

//#import "NetworkController.h"

//文件路径
//#define PACKAGE_FILE_PATH(FILE_NAME) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:FILE_NAME]	
//手机号码
//extern NSString *CTSettingCopyMyPhoneNumber();
@implementation NetworkViewController


@synthesize apninfo;
@synthesize initInfoController;

@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;
@synthesize tableViews;
@synthesize apnType;
//@synthesize internetViewController;
NSMutableString *gAPN; //全局APN
NSMutableString *apnfileName;//apn 保存的文件名

//当点击 屏幕时 取消输入键盘
-(IBAction)backgroundTap:(id)sender
{
    
    
}
// 点击 ok 发送
-(IBAction) btnSend {
    
    if (textFieldBeingEdited != nil){
        NSNumber *tagAsNum= [[NSNumber alloc] initWithInt:textFieldBeingEdited.tag];
        [tempValues setObject:textFieldBeingEdited.text forKey: tagAsNum];
        [tagAsNum release];        
    }
    
    for (NSNumber *key in [tempValues allKeys]){
        switch ([key intValue]) {
            case kdescnRowIndex:
                apninfo.apnDesc = [tempValues objectForKey:key];
                break;
            case kapnRowIndex:
                apninfo.apn=@"";
                apninfo.apn = [tempValues objectForKey:key];
                break;
            case kuserRowIndex:
                apninfo.user = [tempValues objectForKey:key];
                break;
            case kpwdRowIndex:
                apninfo.pwd = [tempValues objectForKey:key];
                break;
            case kipRowIndex:
                apninfo.ip = [tempValues objectForKey:key];
                break;
            case kportRowIndex:
                apninfo.port=[tempValues objectForKey:key];
            default:
                break;
        }
    }
    apninfo.apnDesc=[apninfo.apnDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([apninfo.apnDesc length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                        message:@"请填写描述"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"   
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;

    }
    
    //验证 apn是否是中文 
    BOOL isAPN= [apninfo.apn isMatchedByRegex:@"[\u4e00-\u9fa5]"];
    //判断 apn 是否填写
    //去除前后空格
    apninfo.apn= [apninfo.apn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
    if([apninfo.apn length]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                        message:@"请填写apn"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"   
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    //验证 apn是否是中文
    if (isAPN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                        message:@"APN不能输入中文"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"   
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
        
    }
    
    // guangzhouxiezhiαxiefeiapnβxiaopangγ5454545λon 
    // 存入文件 时 按照 如下顺序 并以 特殊自负分隔，(descn α apn β user γ pwd λ status)
    if (apninfo.apn==nil) {
        apninfo.apn=@"";
    }
    if (apninfo.apnDesc==nil) {
        apninfo.apnDesc=@"";
    }
    
    if (apninfo.user==nil) {
        apninfo.user=@"";
    }
    if (apninfo.pwd==nil) {
        apninfo.pwd=@"";
    }
    if (apninfo.ip==nil) {
        apninfo.ip=@"";
    }
    if (apninfo.port==nil) {
        apninfo.port=@"0";
    }
    // 保存apn信息到config文件中 开始
    NSString *path = [[NSBundle mainBundle]   pathForResource:@"telemplateIntertnetApn" ofType:@"mobileconfig"]; //得到文件的路径
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path]; //获得文件的句柄
	NSData *data = [file readDataToEndOfFile];//得到xml文件 
	[file closeFile];//获得后 关闭文件
    
    NSData* plistData = [path dataUsingEncoding:NSUTF8StringEncoding]; 
    NSString *error; NSPropertyListFormat format; 
    NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    //NSLog( @"plist is----------- %@", plist );
    if(!plist){ NSLog(@"Error: %@",error); [error release];
    }   
    
    
    //保存到外网 
    NSMutableString* aStr;
    aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    aStr=  [NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"testapn" withString:apninfo.apn]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testuser" withString:apninfo.user]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testpwd" withString:apninfo.pwd]];
    aStr=[NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"InternetApn" withString:apninfo.apn]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"apnname" withString:@"描述文件描述"]];
    
    if (apninfo.ip==nil || [apninfo.ip isEqualToString:@""]) {
        // NSLog(@"---代理服务器为空----");
        aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"<key>proxy</key>" withString:@""]];
        aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"<string>testip</string>" withString:@""]];
        
    }else{
        aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testip" withString:apninfo.ip]];
    }
    
    aStr = [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testport" withString:apninfo.port]];       
    
    // 写入文件
    NSFileManager *fm=[ NSFileManager defaultManager];
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    
    NSData *fileData;
    fileData=[[aStr dataUsingEncoding:NSUTF8StringEncoding] retain];
    NSMutableString *apnconfigname=[[NSMutableString alloc]initWithString:apninfo.apn];
    [apnconfigname appendString:@".mobileconfig"];
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:apnconfigname] contents:fileData attributes:nil];
    if ([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:apnconfigname]]) {
        // NSLog(@"-------------InternetApn.mobileconfig---存在");
    };
    
    // 保存apn信息到config文件中  结束
    
    
    
    //把apn和描述 写入文件 α β γ λ μ ν 
    NSMutableString *apnContent=[NSMutableString stringWithString:apninfo.apnDesc];
    
    [apnContent appendString:@"α"];
    [apnContent appendString:apninfo.apn];
    [apnContent appendString:@"β"];
    if (apninfo.user!=nil) {
        [apnContent appendString:apninfo.user];
    }
    [apnContent appendString:@"γ"];
    if (apninfo.pwd!=nil) {
        [apnContent appendString:apninfo.pwd];
    }
    [apnContent appendString:@"λ"];
    [apnContent appendString:@"NO"];//默认状态不可用
    //新加的
    [apnContent appendString:@"μ"];
    [apnContent appendString:apninfo.ip];
    [apnContent appendString:@"ν"];
    [apnContent appendString:apninfo.port];
    
    //设置保存的名字 以便于区分是存放的apn或者其它信息
    
    
    //添加公网APN
    if (apnType !=nil && [apnType isEqualToString:@"internetAPN"]  ) {
        
        apnfileName=[NSMutableString stringWithString:@"internet_"];
    }else if(apnType !=nil && [apnType isEqualToString:@"intranetAPN"]){
        
        apnfileName=[NSMutableString stringWithString:@"apninfo_"];
    }
    
    [apnfileName appendString:apninfo.apn];
    //写入文件
    [self writeFile:apnContent];
    
    
    //把apn的值 赋给全局 变量
    gAPN=[NSMutableString stringWithString:apninfo.apn];
    //获取 iphone 唯一的uuid
    UIDevice *device=[UIDevice currentDevice];
    NSString *uniqueID=[device uniqueIdentifier];
    NSString *iphonenumber=[[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    
    //NSLog(@"输出apn %@",gAPN);
    NSMutableString *cmdtext=[[NSMutableString alloc] initWithString:uniqueID];
    // [cmdtext appendString:uniqueID];
    [cmdtext appendString:@";"];
    
    //cmdtext=[[NSMutableString alloc] appendString:@"tAPNField.text"];
    [cmdtext appendString:apninfo.apn];
    if([iphonenumber length]>1){
        [cmdtext appendString:@";"];
        [cmdtext appendString:iphonenumber];
    }else{
        [cmdtext appendString:@";"];
        [cmdtext appendString:@"0"];
    }
    
    apninfo.apn= nil;
    apninfo.apnDesc=@"";
    apninfo.user=@"";
    apninfo.pwd=@"";
    
    
    //return;
    //[NSThread sleepForTimeInterval:3];//暂停线程
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //apninfo=nil;
    //转到apn设置 页面
    [self goApnSetingView];
    
    
    //    [fm release];
    //    [documentPath release];
    //    [documentsDirectory release];
    //    [fileData release];
    //     [apnconfigname release];
}
//转到 APN主设置页面
-(void)goApnSetingView{
    MainApnSetController  *internetViewController=[[MainApnSetController alloc]initWithNibName:@"MainApnSetController"bundle:nil]; 
    // unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    //公网
    if (apnType !=nil && [apnType isEqualToString:@"internetAPN"]  ) {
        
        // self.navigationController.title=@"公网APN设置";
        [self.navigationController pushViewController:internetViewController animated:YES];
        //返回上一页
        //[self.navigationController popViewControllerAnimated:YES];
        //设置分段控件
        [internetViewController setDefaultSegmentValue:0];
        
    }else{
        //self.navigationController.title=@"公网APN设置";
        [self.navigationController pushViewController:internetViewController animated:YES];
        // [self.navigationController popToViewController:internetViewController animated:YES];
        //[self.navigationController popViewControllerAnimated:YES];
        //设置分段控件
        [internetViewController setDefaultSegmentValue:1];
    }
    [internetViewController viewWillAppear:YES];
    
    [internetViewController release];
}

////导航到公网APN信息及内网apn
//-(void)internetView{
//    //导航到公网APN信息
//    if (apnType !=nil && [apnType isEqualToString:@"internetAPN"]  ) {
//       InternetViewController  *internetViewController=[[InternetViewController alloc]initWithNibName:@"InternetViewController"bundle:nil]; 
//     
//       unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
//       self.navigationController.title=@"公网APN设置";
//      [delegate.navigationController pushViewController:internetViewController animated:YES];
//      [internetViewController release];
//    }
//    //导航到内网APN信息
//    else{
//        IntranetViewController  *intranetViewController=[[IntranetViewController alloc]initWithNibName:@"IntranetViewController"bundle:nil]; 
//        
//        unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
//        self.navigationController.title=@"内网APN设置";
//        [delegate.navigationController pushViewController:intranetViewController animated:YES];
//        [intranetViewController release];
//    }
//}
//表格相关

-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell =
    (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= kNumberOfEditableRowsAdd)
        row = 0;
    NSUInteger newIndex[] = {0, row};
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    UITableViewCell *nextCell = [self.tableViews 
                                 cellForRowAtIndexPath:newPath];
    UITextField *nextField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView;
    }
    [nextField becomeFirstResponder];
}

//显示详细界面
//返回表格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfEditableRowsAdd;
}
//显示详细界面，显示每行数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableViews.contentSize=CGSizeMake(self.tableViews.frame.size.width,self.tableViews.frame.size.height+100);
    self.tableViews.scrollEnabled=TRUE;
    //设置表格背景颜色，以清除边角
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //设置分组标题的字体
    //[tableView setSeparatorColor:[UIColor purpleColor]];
    [tableView setSeparatorColor:[UIColor blackColor]];
    
    static NSString *ApninfoCellIdentifier = @"ApninfoCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApninfoCellIdentifier];
    //if (cell == nil) {        
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ApninfoCellIdentifier] autorelease];
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 80, 25)];
    label0.textAlignment = UITextAlignmentLeft;
    label0.tag = kLabelTag;
    label0.font = [UIFont boldSystemFontOfSize:14];
    [cell.contentView addSubview:label0];
    [label0 release];        
    
    UITextField *textField0 = [[UITextField alloc] initWithFrame:CGRectMake(85, 12, 220, 25)];
    textField0.clearsOnBeginEditing = NO;
    [textField0 setDelegate:self];
    [textField0 addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [cell.contentView addSubview:textField0];
    //}
    NSUInteger row = [indexPath row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
    UITextField *textField = nil;
    for (UIView *oneView in cell.contentView.subviews){
        if ([oneView isMemberOfClass:[UITextField class]])
            textField = (UITextField *)oneView;
    }
    self.tableViews=tableView;
    
    label.text = [fieldLabels objectAtIndex:row];
    NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
    
    textField.autocorrectionType=UITextAutocorrectionTypeNo;//设置自动纠错类型
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;//设置键盘自动大小写属性
    textField.returnKeyType = UIReturnKeyNext;//设置返回键类型
    NSNumber *tempKey ;
    switch (row) {
        case kdescnRowIndex:
            tempKey=[[NSNumber alloc] initWithInt:0];
            if ([tempValues objectForKey:tempKey]!=nil) {
                textField.text=[tempValues objectForKey:tempKey];
            }
            
            
            textField.placeholder=@"请输入描述如:联通APN";
            //textField.keyboardAppearance=UIKeyboardAppearanceAlert;
            // textField.autocorrectionType=UITextAutocorrectionTypeNo;
            break;
        case kapnRowIndex:
            tempKey=[[NSNumber alloc] initWithInt:1];
            if ([tempValues objectForKey:tempKey]!=nil) {
                textField.text=[tempValues objectForKey:tempKey];
            }
            
            textField.keyboardType=UIKeyboardTypeEmailAddress;
            textField.placeholder=@"请输入APN如:3gnet[必填]";
            // textField.autocorrectionType=UITextAutocorrectionTypeNo;
            break;
        case kuserRowIndex:
            tempKey=[[NSNumber alloc] initWithInt:2];
            if ([tempValues objectForKey:tempKey]!=nil) {
                textField.text=[tempValues objectForKey:tempKey];
            }
            
            textField.keyboardType=UIKeyboardTypeEmailAddress;
            textField.placeholder=@"[可不填]";
            //textField.autocorrectionType=UITextAutocorrectionTypeNo;
            break;
        case kpwdRowIndex:
            tempKey=[[NSNumber alloc] initWithInt:3];
            if ([tempValues objectForKey:tempKey]!=nil) {
                textField.text=[tempValues objectForKey:tempKey];
            }
            textField.keyboardType=UIKeyboardTypeEmailAddress;
            textField.placeholder=@"[可不填]";
            textField.secureTextEntry=YES;
            //textField.autocorrectionType=UITextAutocorrectionTypeNo;
            break;
            //ip
        case kipRowIndex:
            tempKey=[[NSNumber alloc] initWithInt:4];
            if ([tempValues objectForKey:tempKey]!=nil) {
                textField.text=[tempValues objectForKey:tempKey];
            }
            //textField.keyboardType=UIKeyboardTypeDecimalPad;
            textField.keyboardType=UIKeyboardTypeEmailAddress;
			textField.placeholder=@"[可不填]";
            //textField.secureTextEntry=YES;
            //textField.autocorrectionType=UITextAutocorrectionTypeNo;
            break;
            //端口
        case kportRowIndex:
            tempKey=[[NSNumber alloc] initWithInt:5];
            if ([tempValues objectForKey:tempKey]!=nil) {
                textField.text=[tempValues objectForKey:tempKey];
            }
            textField.keyboardType=UIKeyboardTypeNumberPad;
            textField.placeholder=@"[可不填]";
            //  textField.secureTextEntry=YES;
            //textField.autocorrectionType=UITextAutocorrectionTypeNo;
            break;
            
        default:
            break;
    }
    if (textFieldBeingEdited == textField)
        textFieldBeingEdited = nil;
    
    textField.tag = row;
    [rowAsNum release];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.textFieldBeingEdited = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSNumber *tagAsNum = [[NSNumber alloc] initWithInt:textField.tag];
    if (textField.text==nil) {
        textField.text=@"";
    }
    [tempValues setObject:textField.text forKey:tagAsNum];
    [tagAsNum release];
}

//表格相关结束

//读取 APN
-(NSString *)readFile:(NSString *)RfileName
{
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    
    NSString *apnContent=nil;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:RfileName]]==YES){
        apnContent=[NSString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:RfileName] encoding:NSUTF8StringEncoding error:nil];
    } 
    
    return apnContent;
    
}
//写入文件 把apn信息
-(void)writeFile:(NSMutableString *)apnContent{
    //  NSString *filename=@"unionApn";//
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    NSData *fileData;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    NSMutableString *data=[[NSMutableString alloc] initWithString:apnContent];
    
    fileData=[[data dataUsingEncoding:NSUTF8StringEncoding] retain];
    
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:apnfileName] contents:fileData attributes:nil]; 
    
}

//读取文件目录，并列出所有 目录下的文件
-(void)getDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表 
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentDir = [documentPaths objectAtIndex:0]; 
    NSError *error = nil; 
    NSArray *fileList = [[NSArray alloc] init]; 
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组 
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    NSMutableArray *dirArray = [[NSMutableArray alloc] init]; 
    BOOL isDir = NO; 
    //在上面那段程序中获得的fileList中列出文件夹名 
    for (NSString *file in fileList) { 
        NSString *path = [documentDir stringByAppendingPathComponent:file]; 
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)]; 
        if (isDir) { 
            [dirArray addObject:file]; 
        } 
        isDir = NO; 
    } 
    
}


//导航到初始化 服务器信息
-(IBAction)initServerInfo{
    if(initInfoController==nil){
        initInfoController=[[InitInfoController alloc]initWithNibName:@"InitInfoController"bundle:nil];
    }
//    unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
//    self.navigationController.title=@"初始化服务器信息";
//    [delegate.navigationController pushViewController:initInfoController animated:YES];
    
}
//-(void)viewDidLoad{
//NSLog(@"-----NetWorkViewController---viewDidLoad-------");
//}
- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setToolbarHidden:NO];
//    [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationController setModalPresentationStyle:UIModalTransitionStyleCoverVertical];
    [tempValues removeAllObjects];
    // tempValues =nil;
    // apninfo=nil;
    //apninfo=[[ApnInfo alloc]init];
    [self.tableViews reloadData]; 
    
    
    //加一个 返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backimg= [UIImage imageNamed:@"BackIcon.png"];
    [leftbutton setImage:[UIImage imageNamed:@"BackIcon.png"] forState:UIControlStateNormal];
    leftbutton.frame=CGRectMake(0, 0, backimg.size.width, backimg.size.height);
    //self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    [leftbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
}

-(void)back{
    MainApnSetController  *internetViewController=[[MainApnSetController alloc]initWithNibName:@"MainApnSetController"bundle:nil]; 
    // unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    //公网
    if (apnType !=nil && [apnType isEqualToString:@"internetAPN"]  ) {
        
        // self.navigationController.title=@"公网APN设置";
        // [self.navigationController pushViewController:internetViewController animated:YES];
        //返回上一页
        [self.navigationController popViewControllerAnimated:YES];
        //设置分段控件
        [internetViewController setDefaultSegmentValue:0];
        
    }else{
        //self.navigationController.title=@"公网APN设置";
        //[self.navigationController pushViewController:internetViewController animated:YES];
        //[self.navigationController popToViewController:internetViewController animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        //设置分段控件
        [internetViewController setDefaultSegmentValue:1];
    }
    [internetViewController viewWillAppear:YES];
    
    [internetViewController release];
}




-(void)viewDidLoad
{
    
    apninfo=[[ApnInfo alloc]init];
    //表格相关
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"描述:", @"APN:", @"用户:", @"密码:",@"代理服务器:",@"服务器端口:", nil];
    self.fieldLabels = array;
    [array release];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    self.tempValues = dict;
    [dict release];
    //表格相关
    [super viewDidLoad];
    self.navigationItem.title=@"新建APN";
    // NSString * initdata=[self readFile:@"serverInfoFile"];
    //InitInfoController  *initconter=[[InitInfoController alloc]init];
    //导航到初始化 页面
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(btnSend)]; 
    
    //请求协议变量 的初始化
    requestProtocol.bind_receiver=0;//发送命令与服务端做绑定
    requestProtocol.bind_transmitter=1;//发送命令与服务端建立通道
    requestProtocol.Unbind=2;//发送命令与服务端断开连接
    requestProtocol.submit_sm=3;//发送命令提交数据至服务端
    requestProtocol.Generic_nak=5;//表示消息有错误的响应
    
    
    
}

//把对象从内存中移除
- (void)dealloc
{
    
    //[apnfileName release];
    [gAPN release];
    [textFieldBeingEdited release];
    [tempValues release];
    [fieldLabels release]; 
    [apninfo release];
    [initInfoController release];
    [tableViews release];
    
    [super dealloc];
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end