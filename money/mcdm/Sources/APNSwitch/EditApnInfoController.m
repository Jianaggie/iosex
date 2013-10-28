//
//  EditApnInfoController.m
//  unuion03
//
//  Created by MagicStudio on 11-4-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "EditApnInfoController.h"
#import "RegexKitLite.h"
#import "MainApnSetController.h"
#import "AppDelegate.h"
//编辑

@implementation EditApnInfoController
@synthesize apninfo;

 

//表格相关
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;
@synthesize tableViews;
@synthesize editApnType;
NSMutableString *editapnfileName;//保存 的文件名
NSMutableString *deleteCongFileName;//保存删除config文件名
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }

    return self;
}
//-(IBAction)back{
//    
//    // [self.navigationController pushViewController:editApnInfoController animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//}

//当点击 屏幕时 取消输入键盘
-(IBAction)backgroundTap:(id)sender
{
     
    
}
//写入文件 把apn信息
-(void)writeToFile:(NSMutableString *)apnContent{
    
    //  NSString *filename=@"unionApn";//
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    NSData *fileData;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    
    NSMutableString *data=[[NSMutableString alloc] initWithString:apnContent];
    fileData=[[data dataUsingEncoding:NSUTF8StringEncoding] retain];
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:editapnfileName] contents:fileData attributes:nil]; 

}
//编辑 信息之后 提交apn
-(IBAction)submitApnInfo{
     
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
                
                apninfo.apn = [tempValues objectForKey:key];
                 
                break;
            case kuserRowIndex:
                apninfo.user = [tempValues objectForKey:key];
                 
                break;
            case kpwdRowIndex:
                apninfo.pwd = [tempValues objectForKey:key];
                break;
            case kipRowIndex:
                apninfo.ip=[tempValues objectForKey:key];
                break;
            case kportRowIndex:
                apninfo.port=[tempValues objectForKey:key];
                 
               // break;
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
    if (apninfo.ip==nil ||[apninfo.ip isEqualToString:@""]) {
        apninfo.ip=@"";
    }
    if (apninfo.port==nil ||[apninfo.port isEqualToString:@""] ) {
        apninfo.port=@"0";
    }
 
    NSString *apnString=apninfo.apn;
    //验证 apn是否是中文
    BOOL isAPN= [apnString isMatchedByRegex:@"[\u4e00-\u9fa5]"];
    //验证 apn是否是中文
    if (isAPN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                        message:@"APN不能输入中文"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"   
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
   
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    //NSData *fileData;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    //删除原来的文件
    NSMutableString *deleteFileName;
    
    //设置删除的类型(公网、专网)
    if (editApnType !=nil && [editApnType isEqualToString:@"internetAPN"]  ) {
        
       // apnfileName=[NSMutableString stringWithString:@"internet_"];
        deleteFileName=[[NSMutableString alloc]initWithString:@"internet_"];
        
    }else if(editApnType !=nil && [editApnType isEqualToString:@"intranetAPN"]){
        //NSLog(@"shanchu专网文件内容－－－－－－－");
        deleteFileName=[[NSMutableString alloc]initWithString:@"apninfo_"];
        
    }
    
    if (deleteFileName!=nil) {
        [deleteFileName appendString:editapnfileName];
    }
     
    //删除APN存储文件
    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:deleteFileName]]==YES){
        [fm removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:deleteFileName] error:nil];
         
        
    }
    
    //删除的config文件
    if (deleteCongFileName!=nil) {
          [deleteCongFileName appendString:@".mobileconfig"];
    }
    
    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:deleteCongFileName]]==YES){
        [fm removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:deleteCongFileName] error:nil];
         
    }
    //删除的config文件 结束
    
    
    editapnfileName=nil;
    deleteCongFileName=nil;
    // guangzhouxiezhiαxiefeiapnβxiaopangγ5454545λon 
    // 存入文件 时 按照 如下顺序 并以 特殊自负分隔，(descn α apn β user γ pwd λ status)
    if(apninfo.apnDesc==nil)
        apninfo.apnDesc=@"";
    //把apn和描述 写入文件
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
    [apnContent appendString:@"NO"];//修改后状态变成不可用
    
    //新加的
    [apnContent appendString:@"μ"];
    [apnContent appendString:apninfo.ip];
    [apnContent appendString:@"ν"];
    [apnContent appendString:apninfo.port];
    //设置保存的名字 以便于区分是存放的apn或者其它信息
    if (editApnType !=nil && [editApnType isEqualToString:@"internetAPN"]  ) {
         
        editapnfileName=[NSMutableString stringWithString:@"internet_"];
    }else if(editApnType !=nil && [editApnType isEqualToString:@"intranetAPN"]){
         
        editapnfileName=[NSMutableString stringWithString:@"apninfo_"];
    }
    
    [editapnfileName appendString:apninfo.apn];
    [self writeToFile:apnContent];
    //写入config文件
    [self writeConfigContent];
    
    
    
//    //弹出提示
//    UIAlertView *alert;  
//    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:editapnfileName]]==YES){
//        alert=[[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                         message:@"保存成功"
//                                        delegate:self
//                               cancelButtonTitle:@"OK"   
//                               otherButtonTitles:nil];
//        [alert show];
//    }else{
//        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                          message:@"保存失败，请检查apn数据格式"
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alert show];    
//    } 
//    [alert release];
    [self goApnSetingView];
     
    
}
//将APN信息写入config
-(void)writeConfigContent{
    // 保存apn信息到config文件中 开始
    NSString *path = [[NSBundle mainBundle]   pathForResource:@"telemplateIntertnetApn" ofType:@"mobileconfig"]; //得到文件的路径
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path]; //获得文件的句柄
	NSData *data = [file readDataToEndOfFile];//得到xml文件 
	[file closeFile];//获得后 关闭文件
    
    
    NSData* plistData = [path dataUsingEncoding:NSUTF8StringEncoding]; 
    NSString *error; NSPropertyListFormat format; 
    NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    if(!plist){ NSLog(@"Error: %@",error); [error release];
    }   
    
    //保存到外网 
    NSMutableString* aStr;
    aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    // [aStr stringWithString:]; 
    
    aStr=  [NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"testapn" withString:apninfo.apn]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testuser" withString:apninfo.user]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testpwd" withString:apninfo.pwd]];
    aStr=[NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"InternetApn" withString:apninfo.apn]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"apnname" withString:@"描述文件描述"]];
    if (apninfo.ip==nil || [apninfo.ip isEqualToString:@""]) {
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
          
    };



}



//转到 APN主设置页面
-(void)goApnSetingView{
    [self.navigationController popViewControllerAnimated:YES];
    //return;
    MainApnSetController  *internetViewController=[[MainApnSetController alloc]initWithNibName:@"MainApnSetController"bundle:nil]; 
    //unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    //公网
    if (editApnType !=nil && [editApnType isEqualToString:@"internetAPN"]  ) {
         
        // self.navigationController.title=@"公网APN设置";
          [self.navigationController pushViewController:internetViewController animated:YES];
         
        //设置分段控件
        
        //[self.navigationController popViewControllerAnimated:YES];
        [internetViewController setDefaultSegmentValue:0];
        //[internetViewController reLoadTableView];
        
    }else{
        
        //self.navigationController.title=@"公网APN设置";
         [self.navigationController pushViewController:internetViewController animated:YES];
        //[self.navigationController popViewControllerAnimated:YES];
        //设置分段控件
        [internetViewController setDefaultSegmentValue:1];
    }
    [internetViewController viewWillAppear:YES];
    //[internetViewController viewDidLoad];
    [internetViewController release];
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // apninfo=[[ApnInfo alloc]init];
    //表格相关
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"描述:", @"APN:", @"用户:", @"密码:",@"代理服务器:",@"服务器端口:", nil];
    self.fieldLabels = array;
    [array release];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    self.tempValues = dict;
    [dict release];
    //表格相关
    //设置一个导航
    // self.navigationItem.rightBarButtonItem=self.editButtonItem;
    // self.navigationItem.backBarButtonItem
    self.navigationItem.title=@"编辑";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(submitApnInfo)];    
 
}

//表格相关
-(IBAction)textFieldDone:(id)sender {
     
    UITableViewCell *cell =
    (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= kNumberOfEditableRows)
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
    return kNumberOfEditableRows;
}
//显示详细界面，显示每行数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableViews.contentSize=CGSizeMake(self.tableViews.frame.size.width, self.tableViews.frame.size.height+100);
    //设置表格背景颜色，以清除边角
    [tableView setBackgroundColor:[UIColor clearColor]];    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //设置分组标题的字体
    //[tableView setSeparatorColor:[UIColor purpleColor]];
     [tableView setSeparatorColor:[UIColor blackColor]];
    
    static NSString *ApninfoCellIdentifier = @"ApninfoCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApninfoCellIdentifier];
    if (cell == nil) {        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ApninfoCellIdentifier] autorelease];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 80, 25)];
        label.textAlignment = UITextAlignmentLeft;
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:label];
        [label release];        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(85, 12, 220, 25)];
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
    }
    NSUInteger row = [indexPath row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
    UITextField *textField = nil;
    for (UIView *oneView in cell.contentView.subviews){
        if ([oneView isMemberOfClass:[UITextField class]])
            textField = (UITextField *)oneView;
    }
   // NSLog(@"-----------test tag%i",textField.tag);
    self.tableViews=tableView;
    
    label.text = [fieldLabels objectAtIndex:row];
    NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
    
    textField.autocorrectionType=UITextAutocorrectionTypeNo;
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    
    switch (row) {
        case kdescnRowIndex:
            
            textField.text = apninfo.apnDesc;
            //textField.placeholder=@"请输入APN描述";
            break;
        case kapnRowIndex:
 
            textField.text = apninfo.apn;
             
            textField.keyboardType=UIKeyboardTypeEmailAddress;
            textField.placeholder=@"请输入APN如:3gnet[必填]";
           // textField.autocorrectionType=UITextAutocorrectionTypeNo;
           // textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
            break;
        case kuserRowIndex:
            textField.text = apninfo.user;
            textField.keyboardType=UIKeyboardTypeEmailAddress;
            textField.placeholder=@"[可不填]";
           // textField.autocorrectionType=UITextAutocorrectionTypeNo;
           // textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
            break;
        case kpwdRowIndex:
            textField.text = apninfo.pwd;
            textField.keyboardType=UIKeyboardTypeEmailAddress;
            textField.placeholder=@"[可不填]";
            textField.secureTextEntry=TRUE;
           // textField.autocorrectionType=UITextAutocorrectionTypeNo;
           // textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
            break;
        case kipRowIndex:
            textField.text = apninfo.ip;
            //textField.keyboardType=UIKeyboardTypeDecimalPad;
            textField.keyboardType=UIKeyboardTypeEmailAddress;
			textField.placeholder=@"[可不填]";
            break;
        case kportRowIndex:
            if ([apninfo.port isEqualToString:@"0"]) {
                textField.text=@"";
            }else{
             textField.text=apninfo.port;
            }
            
            textField.keyboardType=UIKeyboardTypeNumberPad;
            textField.placeholder=@"[可不填]";
            break;
        default:
            break;
    }
    if (textFieldBeingEdited == textField)
        textFieldBeingEdited = nil;
    textField.tag = row;
//    //0623lcy
    NSNumber *tagAsNum = [[NSNumber alloc] initWithInt:textField.tag];
     if (textField.text==nil) {
         textField.text=@"";
     }
      
    [tempValues setObject:textField.text forKey:tagAsNum];
    
    [tagAsNum release];
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
    [tempValues setObject:textField.text forKey:tagAsNum];
    [tagAsNum release];
}

//表格相关结束


- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableViews reloadData];
    if (apninfo.apn==nil) {
        apninfo.apn=@"";
    }
    editapnfileName=[[NSMutableString alloc]initWithString:apninfo.apn];
    deleteCongFileName=[[NSMutableString alloc]initWithString:apninfo.apn];//config文件名
    
    //加一个 返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backimg= [UIImage imageNamed:@"BackIcon.png"];
    [leftbutton setImage:[UIImage imageNamed:@"BackIcon.png"] forState:UIControlStateNormal];
    leftbutton.frame=CGRectMake(0, 0, backimg.size.width, backimg.size.height);
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    [leftbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
}

//转到 APN主设置页面
-(void)back{
    MainApnSetController  *internetViewController=[[MainApnSetController alloc]initWithNibName:@"MainApnSetController"bundle:nil]; 
   // unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
    //公网
    if (editApnType !=nil && [editApnType isEqualToString:@"internetAPN"]  ) {
         
        // self.navigationController.title=@"公网APN设置";
       // [self.navigationController pushViewController:internetViewController animated:YES];
        
        //设置分段控件
        
         [self.navigationController popViewControllerAnimated:YES];
         [internetViewController setDefaultSegmentValue:0];
        //[internetViewController reLoadTableView];
        
    }else{
         
        //self.navigationController.title=@"公网APN设置";
        //[self.navigationController pushViewController:internetViewController animated:YES];
         [self.navigationController popViewControllerAnimated:YES];
        //设置分段控件
        [internetViewController setDefaultSegmentValue:1];
    }
    [internetViewController viewWillAppear:YES];
    //[internetViewController viewDidLoad];
    [internetViewController release];
}

//-(void)loadView{
//    [super loadView];
//    
//    [self.tableViews reloadData];
//    if (apninfo.apn==nil) {
//        apninfo.apn=@"";
//    }
//    editapnfileName=[[NSMutableString alloc]initWithString:apninfo.apn];
//    NSLog(@"-----------loadView------------------%@",editapnfileName);
//    deleteCongFileName=[[NSMutableString alloc]initWithString:apninfo.apn];//config文件名
//    
//    //加一个 返回按钮
//    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *backimg= [UIImage imageNamed:@"back.png"];
//    [leftbutton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    leftbutton.frame=CGRectMake(0, 0, backimg.size.width, backimg.size.height);
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
//    [leftbutton addTarget:self action:@selector(goApnSetingView) forControlEvents:UIControlEventTouchDown];
//}

- (void)dealloc
{
    [super dealloc];
    [apninfo release];
    [textFieldBeingEdited release];
    [tempValues release];
    [editapnfileName release];
    [fieldLabels release]; 
    [tableViews release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


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
