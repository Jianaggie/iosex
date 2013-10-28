//  InitInfoController.m
//  保存 服务器 信息
//
//  Created by MagicStudio on 11-4-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//  update date  2011－08－18

#import "InitInfoController.h"
#import "Reachability.h"
#import "RegexKitLite.h"
@implementation InitInfoController

 //表格相隔
@synthesize initInfo;
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;
@synthesize tableViews;
NSString *serverInfoFile=@"serverInfoFile";//保存初始化文件的名字
int row2=3;//表格第二分区行号
bool isReConn;//是否重连接
int countConn;//记录连接的次数
int limitButtonClick=0;//限制点击（0,初始化 ,1,正在连接,2,已经有返回结果）

int clickButtonTag;//记录点击按钮的tag
 

//每次打开当前页面时执行 将用户填写的apn和端口信息读取出来
-(void)viewWillAppear:(BOOL)animated{
    row2=3;//表格第二分区行号
    
    initInfo= [[InitServerSet alloc]init];
    //读取文件 并把apn和描述 显示在相应的界面上
    NSString *data=[self readFile:serverInfoFile];
    if(data !=nil){
         
        //截取  
        NSString *fix=@"α";
        NSString *fix1=@"β";
        NSString *fix2=@"γ";
       // NSString  *fix3=@"λ";
        
        NSString *interetAPN;
        NSString *interetUser;
        NSString *intrantAPN;
        NSString *intrantUser;
       // NSString *intrant;//内网ip
        NSRange  subRange=[data rangeOfString:fix];
        NSRange subRange1=[data rangeOfString:fix1];
        NSRange subRange2=[data rangeOfString:fix2];
       // NSRange subRange3=[data rangeOfString:fix3];
        
        interetAPN=[[data substringFromIndex:0] substringToIndex:subRange.location];
        interetUser=[[data substringFromIndex:subRange.location+1] substringToIndex:subRange1.location-1-subRange.location];
        intrantAPN=[[data substringFromIndex:subRange1.location+1] substringToIndex:subRange2.location-1-subRange1.location];
        intrantUser=[data substringFromIndex:subRange2.location+1];
        //intrant=[data substringFromIndex:subRange3.location+1];//内网ip

        initInfo.interetAPN= interetAPN;
        initInfo.interetUser =interetUser;
        //initInfo.interetPwd =recount;
        
        initInfo.intrantAPN =intrantAPN;
        initInfo.intrantUser=intrantUser;
        //NSLog(@"_____________________________%@",initInfo.interetAPN);
       
    } 
    //[self.tableViews reloadData];
    if (textFieldBeingEdited!=nil) {
         [textFieldBeingEdited resignFirstResponder];
    }
    
    
}
 

- (void)viewDidLoad
{
    [super viewDidLoad];
    keyboardShown = NO;
     currentConnPort=[[NSMutableString alloc]initWithString:@""];//当前ip
     currentConnIP=[[NSMutableString alloc]initWithString:@""];//当前端口
   // limitButtonClick=[[NSMutableString alloc]initWithString:@""];//限制按钮点击
    self.navigationItem.title=@"APN参数设置";
    
//    //下面判断联通默认apn文件是否存在
//    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
//    NSFileManager *fm=[ NSFileManager defaultManager];
//    NSString *filename=@"apninfo_3gnet";
//    
//    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:filename]]==NO){
//        
//        [self writeUnionNetAPN];
//    } 
//    
//    [fm release];
    
    
    //新改表格
    NSArray *array = [[NSArray alloc] initWithObjects:@"APN",@"用户名", @"密码", @"APN1:", @"用户名1:",@"密码1:", nil];
    self.fieldLabels = array;
    [array release];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    self.tempValues = dict;
    [dict release];
    //结束
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(saveServerInfo)];
    
    
    
    //[self.navigationItem setHidesBackButton:YES];
//     UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
//     barButtonItem.title = @"APN设置";
      //self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"APN设置" style:UIBarButtonSystemItemUndo target:self action:@selector(saveServerInfo)];
    // UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    // barButtonItem.title = @"APN设置";
    // self.navigationItem.backBarButtonItem = barButtonItem;
//    [barButtonItem release];
 //[self.navigationItem.backBarButtonItem setTitle:@"APN设置"];
    
    //self.navigationItem.backBarButtonItem.title = @"APN设置";

   // testasyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
    //self.tableViews
      
}

//第一次初始化  写入 联通默认的APN信息
-(void)writeUnionNetAPN{
    
    //把apn和描述 写入文件
    NSMutableString *apnContent=[NSMutableString stringWithString:@"中国联通APN"];
    [apnContent appendString:@"α"];
    [apnContent appendString:@"3gnet"];
    [apnContent appendString:@"β"];
    [apnContent appendString:@""];
    [apnContent appendString:@"γ"];
    [apnContent appendString:@""];
    [apnContent appendString:@"λ"];
    [apnContent appendString:@"YES"];//默认状态可用
    //设置保存的名字 以便于区分是存放的apn或者其它信息
    NSMutableString  *apnfileName=[NSMutableString stringWithString:@"apninfo_"];
    [apnfileName appendString:@"3gnet"];
    
    //写入文件
    [self writeApnFile:apnContent fileName:apnfileName];
    
}


//保存 服务器文件信息
-(IBAction)saveServerInfo{
    
    if (textFieldBeingEdited != nil){
        NSNumber *tagAsNum= [[NSNumber alloc] initWithInt:textFieldBeingEdited.tag];
        [tempValues setObject:textFieldBeingEdited.text forKey: tagAsNum];
        [tagAsNum release];        
    }
    for (NSNumber *key in [tempValues allKeys]){
        switch ([key intValue]) {
            case kServerInteretAPNRowIndex:
               initInfo.interetAPN =[tempValues objectForKey:key];

                break;
                //内网ip
            case kServerInteretUserRowIndex:
                initInfo.interetUser=[tempValues objectForKey:key];
                break;
            case kServerInteretPwdRowIndex:
                initInfo.interetPwd = [tempValues objectForKey:key];
                break;
            case kServerIntrantAPNRowIndex:
                initInfo.intrantAPN = [tempValues objectForKey:key];
                break;
            case kServerIntrantUserRowIndex:
                initInfo.intrantUser = [tempValues objectForKey:key];
                break;
            case kServerIntrantPwdRowIndex:
                initInfo.intrantPwd = [tempValues objectForKey:key];
                break;
            default:
                break;
        }
    }
    if (initInfo.interetAPN==NULL) {
        initInfo.interetAPN=@"";
    }
    if (initInfo.interetUser==NULL) {
        initInfo.interetUser=@"";
    }
    if (initInfo.interetPwd==NULL) {
        initInfo.interetPwd=@"";
    }
    
    if (initInfo.intrantAPN==NULL) {
        initInfo.intrantAPN=@"";
    }
    if (initInfo.intrantUser==NULL) {
        initInfo.intrantUser=@"";
    }
    if (initInfo.intrantPwd==NULL) {
        initInfo.intrantPwd=@"";
    }
    
    initInfo.interetAPN=[initInfo.interetAPN stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    initInfo.interetUser=[initInfo.interetUser stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    initInfo.interetPwd=[initInfo.interetPwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    initInfo.intrantAPN=[initInfo.intrantAPN stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    initInfo.intrantUser=[initInfo.intrantUser stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    initInfo.intrantPwd=[initInfo.intrantPwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
         //判断 公网apn 是否填写
         if([initInfo.interetAPN length]==0){
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                             message:@"请填写公网APN"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"   
                                                   otherButtonTitles:nil];
             [alert show];
             [alert release];
            
             return;
        }
        //验证内网apn
          
         if ([initInfo.intrantAPN length]==0) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                             message:@"请填写内网APN"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"   
                                                  otherButtonTitles:nil];
             [alert show];
             [alert release];
             
             return;
          }

    
    
    
    
    
    
//    NSLog(@"---------initInfo.interetAPN--------------%@",initInfo.interetAPN);
//     NSLog(@"---------initInfo.interetUser--------------%@",initInfo.interetUser);
//     NSLog(@"---------initInfo.interetPwd--------------%@",initInfo.interetPwd);
//    
//     NSLog(@"---------initInfo.intrantAPN--------------%@",initInfo.intrantAPN);
//     NSLog(@"---------initInfo.intrantUser--------------%@",initInfo.intrantUser);
//     NSLog(@"---------initInfo.intrantPwd--------------%@",initInfo.intrantPwd);
    
    
    NSString *path = [[NSBundle mainBundle]   pathForResource:@"IntertnetApn" ofType:@"mobileconfig"]; //得到文件的路径
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path]; //获得文件的句柄
	NSData *data = [file readDataToEndOfFile];//得到xml文件 
	[file closeFile];//获得后 关闭文件
//	
//	//这里用的是NSXMLParser解析器  还有其他的解析器 还没去用过 有懂的话 我还需要请教各位
//	//开始解析
//	NSXMLParser* xmlRead = [[NSXMLParser alloc] initWithData:data];//初始化NSXMLParser对象  可以这样理解 xmlRead是个解析器对象 
//	//这个解析器对象可以调用解析器的代理方法  不知道我这样理解错没错  不过也没关系 下面那个设置代理的时候 必须要用NSXMLParser对象就行了
//	
//	[data release]; 
//	
//	[xmlRead setDelegate:self];//设置NSXMLParser对象的解析方法代理  这个很重要 不然他不会调用代理方法 
//	[xmlRead parse];//调用代理解析NSXMLParser对象，看解析是否成功 
//	
//	//为了得到提示信息 看是否成功
//	BOOL flag =[xmlRead parse];
//	if (flag) {
//		NSLog(@"获取指定路径的xml文件成功");
//	} else {
//		NSLog(@"获取指定路径的xml文件失败");
//	}
//    
    
    
    NSData* plistData = [path dataUsingEncoding:NSUTF8StringEncoding]; 
    NSString *error; NSPropertyListFormat format; 
    NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    //NSLog( @"plist is----------- %@", plist );
    if(!plist){ NSLog(@"Error: %@",error); [error release];
    }   
    
    //保存到外网 
    NSMutableString* aStr;
    aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
   // [aStr stringWithString:]; 
    
    aStr=  [NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"testapn" withString:initInfo.interetAPN]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testuser" withString:initInfo.interetUser]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"testpwd" withString:initInfo.interetPwd]];
    aStr=[NSString stringWithString: [aStr stringByReplacingOccurrencesOfString:@"InternetApn" withString:@"InternetApn"]];
    aStr= [NSString stringWithString:[aStr stringByReplacingOccurrencesOfString:@"apnname" withString:@"描述文件描述"]];
    
    
    
    //保存到内网 
    NSMutableString* aStr2;
    aStr2 = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    aStr2= [NSString stringWithString:[aStr2 stringByReplacingOccurrencesOfString:@"testapn" withString:initInfo.intrantAPN]];
    aStr2= [NSString stringWithString:[aStr2 stringByReplacingOccurrencesOfString:@"testuser" withString:initInfo.intrantUser]];
    aStr2=[NSString stringWithString: [aStr2 stringByReplacingOccurrencesOfString:@"testpwd" withString:initInfo.intrantPwd]];
    aStr2= [NSString stringWithString:[aStr2 stringByReplacingOccurrencesOfString:@"InternetApn" withString:@"IntrantApn"]];
    aStr2= [NSString stringWithString:[aStr2 stringByReplacingOccurrencesOfString:@"apnname" withString:@"描述文件描述"]];
    
    
    //NSLog(@"--------------内容-b-----------%@",aStr2);
   
    // 写入文件
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    //    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:fileName] contents:fileData attributes:nil]; 
    
    // NSMutableString *datacontent=[[NSMutableString alloc] initWithString:aStr];
    NSData *fileData;
    fileData=[[aStr dataUsingEncoding:NSUTF8StringEncoding] retain];
    // [fm createFileAtPath:path contents:fileData attributes:nil]; 
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:@"InternetApn.mobileconfig"] contents:fileData attributes:nil];
    if ([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:@"InternetApn.mobileconfig"]]) {
       // NSLog(@"-------------InternetApn.mobileconfig---存在");
    };
    
    NSData *fileData2;
    fileData2=[[aStr2 dataUsingEncoding:NSUTF8StringEncoding] retain];
    // [fm createFileAtPath:path contents:fileData attributes:nil]; 
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:@"IntrantApn.mobileconfig"] contents:fileData2 attributes:nil];
    if ([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:@"IntrantApn.mobileconfig"]]) {
        //NSLog(@"----------IntrantApn.mobileconfig------存在");
    };

    
//    [fm release];
//    [aStr release];
//    [aStr2 release];
//    [fileData release];
//    [fileData2 release];
//    
    
    
    
    
   // return;
    //判断 ip 、端口 是否填写  
//    if([initInfo.serverIp length]==0){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                                        message:@"请填写公网IP"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"   
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//       
//        return;
//    }
    //验证是否是合法ip
//    BOOL isValidServerIp= [initInfo.serverIp isMatchedByRegex:@"/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/g"];
//    
//    if (!isValidServerIp) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                                        message:@"请填写合法公网IP"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"   
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        
//        return;
//    }
    
//    //判断内网IP
//    if ([initInfo.intrantIp length]==0) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请填写内网IP" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        return;
//        
//        
//    }
     
//    //端口
//    if ([initInfo.serverport length]==0) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请填写端口" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        return;
//        
//        
//    }
   
    // guangzhouxiezhiαxiefeiapnβxiaopangγ5454545λon 
    // 存入文件 时 按照 如下顺序 并以 特殊自负分隔，(ip α port β reCount  γ   reTimes  λ intrantIp)
    //把服务器信息 写入文件
    NSMutableString *serverContent=[NSMutableString stringWithString:initInfo.interetAPN];
    [serverContent appendString:@"α"];
    
    if(initInfo.interetUser !=nil){
      [serverContent appendString:initInfo.interetUser];
    }
    
    [serverContent appendString:@"β"];
    if(initInfo.intrantAPN !=nil){
      [serverContent appendString:initInfo.intrantAPN];//内网APN
    }
    [serverContent appendString:@"γ"];
    if(initInfo.intrantUser !=nil){
       [serverContent appendString:initInfo.intrantUser];//内网用户
    }
    
//    [serverContent appendString:@"λ"];
//    //λ 内网ip
//    if (initInfo.intrantIp !=nil) {
//        [serverContent appendString:initInfo.intrantIp];
//    }
    //写入文件
    [self writeApnFile:serverContent fileName:serverInfoFile];
//    
//    
//    //提示保存成功
//    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
//    NSFileManager *fm=[ NSFileManager defaultManager];
//    
//    
//    //弹出提示
//    UIAlertView *alert;
//    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:serverInfoFile]]==YES){
//        alert=[[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                         message:@"保存成功"
//                                        delegate:self
//                               cancelButtonTitle:@"OK"   
//                               otherButtonTitles:nil];
//        [alert show];
//    }else{
//        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                          message:@"保存失败，请检查数据格式"
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alert show];    
//    }    
//    [alert release];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//新改界面表格开始

-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell =
    (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= kinitNumberOfEditableRows)
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
//
//-(CGFloat)tableView:(UITableView*)tableView  heightForRowAtIndexPath:(NSIndexPath*)indexPath{ 
//    
//    if (indexPath.section==1) {
//        return 80.0;
//    }else{
//     return  42.0;
//    }
//    
//};



//显示详细界面，显示每行数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.contentSize = CGSizeMake(tableView.frame.size.width * 1, tableView.frame.size.height);
    
    //设置表格背景颜色，以清除边角
    [tableView setBackgroundColor:[UIColor clearColor]];
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //设置分组标题的字体
    //[tableView setSeparatorColor:[UIColor purpleColor]];
    [tableView setSeparatorColor:[UIColor blackColor]];
    //[tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
     
    NSUInteger row = [indexPath row];//获取行数
   // NSLog(@"--------------------row-%d",row);
   
  
    //获取分区
    NSUInteger section=[indexPath section];
     
    
    static NSString *InitServerInfo = @"InitServerInfo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InitServerInfo];
    if (section==0) {
        
    
    if (cell == nil) {        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InitServerInfo] autorelease];
        //清除已有视图
        NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];	  
        for (UIView *subview in subviews) {    
            [subview removeFromSuperview];   
        }  
        [subviews release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 70, 25)];
        label.textAlignment = UITextAlignmentLeft;
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:16];
        [cell.contentView addSubview:label];
        [label release];        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(73, 10, 200, 25)];
        
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
    }
        //
   
        
    
    UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
    UITextField *textField = nil;
    for (UIView *oneView in cell.contentView.subviews){
        if ([oneView isMemberOfClass:[UITextField class]])
            textField = (UITextField *)oneView;
    }
    label.text = [fieldLabels objectAtIndex:row];
    NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
        textField.autocorrectionType=UITextAutocorrectionTypeNo;
        textField.autocapitalizationType=UITextAutocapitalizationTypeNone;        
    self.tableViews=tableView;
        if (row<=2) {
            switch (row) {
                    
                case kServerInteretAPNRowIndex:
                    
                    textField.text=@"";
                    if ([[tempValues allKeys] containsObject:rowAsNum]){
                        
                        textField.text = [tempValues objectForKey:rowAsNum];
                    }
                    else{
                        
                        
                        textField.text = initInfo.interetAPN;
                        
                    }
                    textField.keyboardType=UIKeyboardTypeEmailAddress;
                    textField.placeholder=@"请输入APN[必填]";
                    
                    
                    break;
                    //Intranet 内网ip
                case kServerInteretUserRowIndex:
                    textField.text=@"";
                    if ([[tempValues allKeys] containsObject:rowAsNum])
                        textField.text = [tempValues objectForKey:rowAsNum];
                    
                    else
                        textField.text = initInfo.interetUser;
                    textField.keyboardType=UIKeyboardTypeEmailAddress;
                    textField.placeholder=@"请输入用户名[可不填]";
                    
                    
                    break;
                    //port
                case kServerInteretPwdRowIndex:
                    textField.text=@"";
                    if ([[tempValues allKeys] containsObject:rowAsNum])
                        textField.text = [tempValues objectForKey:rowAsNum];
                    else
                        textField.text = initInfo.interetPwd;
                    textField.keyboardType=UIKeyboardTypeEmailAddress;
                    textField.placeholder=@"请输入密码[可不填]";
                    break;
                    //recount
                    
            }

        }
       if (textFieldBeingEdited == textField)
        textFieldBeingEdited = nil;
    
    textField.tag = row;
    [rowAsNum release];
    }
    else{
        if (row2>5) {
            row2=-3 ;
        }
        //NSUInteger row = [indexPath row];//获取行数
         //NSLog(@"-------------------section2-row-%d",row);
        if (cell == nil) {        
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InitServerInfo] autorelease];
//           // 清除视图
//            NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];	  
//            for (UIView *subview in subviews) {    
//                [subview removeFromSuperview];   
//            }  
//            [subviews release];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 70, 25)];
            label.textAlignment = UITextAlignmentLeft;
            label.tag = kLabelTag;
            label.font = [UIFont boldSystemFontOfSize:16];
            [cell.contentView addSubview:label];
            [label release];        
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(73, 10, 200, 25)];
            
            textField.clearsOnBeginEditing = NO;
            [textField setDelegate:self];
            [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.contentView addSubview:textField];
        }
       
        
        UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
        UITextField *textField = nil;
        for (UIView *oneView in cell.contentView.subviews){
            if ([oneView isMemberOfClass:[UITextField class]])
                textField = (UITextField *)oneView;
        }
      //  NSNumber *rowAsNum1=0 ;
        //if (row2>2 && row2<6){
        label.text = [fieldLabels objectAtIndex:row];
        NSNumber *rowAsNum3  = [[NSNumber alloc] initWithInt:3];
        NSNumber *rowAsNum4  = [[NSNumber alloc] initWithInt:4];
        NSNumber *rowAsNum5  = [[NSNumber alloc] initWithInt:5];
        //}
        //if (row2>2 && row2<6) {
        textField.autocorrectionType=UITextAutocorrectionTypeNo;
        textField.autocapitalizationType=UITextAutocapitalizationTypeNone;    
            switch (row) {
                    
                case 0:
                  //  NSLog(@"kServerIntrantAP------------tAPNRowIndex");
                    textField.text=@"";
                    if ([[tempValues allKeys] containsObject:rowAsNum3])
                        textField.text = [tempValues objectForKey:rowAsNum3];
                    else
                        textField.text = initInfo.intrantAPN;
                    textField.keyboardType=UIKeyboardTypeEmailAddress;
                    textField.placeholder=@"请输入APN[必填]";
                    textField.tag=3;
                    break;
                    //retimes
                case 1:
                    textField.text=@"";
                    if ([[tempValues allKeys] containsObject:rowAsNum4])
                        textField.text = [tempValues objectForKey:rowAsNum4];
                    else
                        textField.text = initInfo.intrantUser;
                    textField.keyboardType=UIKeyboardTypeEmailAddress;
                    textField.placeholder=@"请输入用户名[可不填]";
                     textField.tag=4;//
                    break;
                case 2:
                    textField.text=@"";
                    if ([[tempValues allKeys] containsObject:rowAsNum5])
                         
                        textField.text = [tempValues objectForKey:rowAsNum5];
                    else
                        textField.text = initInfo.intrantPwd;
                    textField.keyboardType=UIKeyboardTypeEmailAddress;
                    textField.placeholder=@"请输入密码[可不填]";
                     textField.tag=5;//
                    break;
                    
                    
                default:
                    break;
            }

       // }
        if (textFieldBeingEdited == textField)
        textFieldBeingEdited = nil;
        
        //textField.tag = row;
        row2=row2+1;
        //rowAsNum=0;
    }
    //设置表格的高度
    tableView.contentSize = CGSizeMake(tableView.frame.size.width * 1, tableView.frame.size.height+205);
    return cell;
}

//获取表格的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else{
        //[tableView  setRowHeight:80.0];
        return 3;
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [textFieldBeingEdited resignFirstResponder];
    return nil;
}
//新加的
//返回分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
//返回分区的标题
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    if (section==0) {
//        return @"服务器参数设置";
//    }else{
//      return @"验证连接";
//    }
//}
//返回 分组标题的高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 42.0;
}
//返回分区的标题  修改字体
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //[tableView setBackgroundColor:[UIColor clearColor]];
    //[tableView setSectionHeaderHeight:30.0];
    UILabel        *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor = [UIColor lightGrayColor];
	titleLabel.highlightedTextColor = [UIColor whiteColor];
    //titleLabel.textColor=[UIColor purpleColor];//purpleColor
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.frame = CGRectMake(150.0, 100.0, 100.0, 44.0);

    if (section==0) {
        titleLabel.text=@"    公网设置";
    }
    else if(section==1){
        titleLabel.text=@"    内网设置";
    }
    return [titleLabel autorelease];
}




//新加的

//初始化
- (id)init
{
//	if(self == [super init])
//	{
//		testasyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
//        
//	}
	return self;
}
////检测 当前 网络
//-(BOOL)checkInternet{
//    // Reachability *r=[Reachability re
//    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus==NotReachable)&&([Reachability reachabilityForLocalWiFi].currentReachabilityStatus==NotReachable)   ) {
//        return NO;
//    }
//    return YES;
//}


////异步连接服务器
//-(IBAction)asynSocketConn:(id)sender{
//    
//    countConn=0;//设置连接的次数为0
//    
//    //检测 当前网络 如果没得 网络 直接返回
//    if([self checkInternet]==0){
//        UIAlertView *alert1;
//        //  NSLog(@"进入无网络判断");
//        alert1= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                          message:@"当前无可用的网络，请检查手机网络配置"
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alert1 show]; 
//        [alert1 release];
//        return;
//    }
//    //当点击按酒后取消键盘
//    if (textFieldBeingEdited!=nil) {
//        [textFieldBeingEdited resignFirstResponder];
//    }
//    
//    UIButton *button =sender;
//    int tag=button.tag;
//    clickButtonTag=tag;//把当前点击按钮的tag赋给clickButtonTag
//   // NSLog(@"-------clickButtonTag------tag %i",tag);
//    //获取 iphone 唯一的uuid
//    
////    NSString *ipPortData=[self readFile:@"serverInfoFile"];
////    UIAlertView *alert;
////    if([ipPortData length]==0){
////        alert= [[UIAlertView alloc] initWithTitle:@"提示信息" 
////                                          message:@"请初始化服务器信息..."
////                                         delegate:self
////                                cancelButtonTitle:@"OK"   
////                                otherButtonTitles:nil];
////        [alert show]; 
////        [alert release];      
////        return;
////    }
//    //132.145.65.88α9014β1γ5λ192.168.1.100  (新初始化信息结构)
//    //截取  
////    NSString *fix=@"α";
////    NSString *fix1=@"β";
////    NSString *fix2=@"λ";
//    //从文件中读取ip和端口
//    NSString *ip=@"";  //外网ip
//    NSString *intrantIp=@"";//内网IP
//    NSString *port=@"";//端口
//    
////    NSRange  subRange=[ipPortData rangeOfString:fix];
////    NSRange subRange1=[ipPortData rangeOfString:fix1];
////    NSRange subRange2=[ipPortData rangeOfString:fix2];
////    //外网ip
////    ip=[[ipPortData substringFromIndex:0] substringToIndex:subRange.location];
////    //内网ip
////    intrantIp=[ipPortData substringFromIndex:subRange2.location+1];
////    //端口
////    port=[[ipPortData substringFromIndex:subRange.location+1] substringToIndex:subRange1.location-1-subRange.location];
//    if (initInfo !=nil) {
//        ip=initInfo.serverIp;
//        intrantIp=initInfo.intrantIp;
//        port=initInfo.serverport;
//    }
//   
//    if (textFieldBeingEdited != nil){
//        NSNumber *tagAsNum= [[NSNumber alloc] initWithInt:textFieldBeingEdited.tag];
//        [tempValues setObject:textFieldBeingEdited.text forKey: tagAsNum];
//        [tagAsNum release];        
//    }
//     
//    for (NSNumber *key in [tempValues allKeys]){
//        switch ([key intValue]) {
//            case (kServerIpRowIndex):
//                if ([[tempValues allKeys] containsObject:key]) {
//                    ip =[[tempValues objectForKey:key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
//                } 
//                
//                break;
//                //内网ip
//            case kServerIntranetRowIndex:
//                if ([[tempValues allKeys] containsObject:key]) {
//                intrantIp=[[tempValues objectForKey:key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                }
//                    
//                break;
//                //端口
//            case kServerPortRowIndex:
//                if ([[tempValues allKeys] containsObject:key]) {
//                    port = [[tempValues objectForKey:key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                }
//                break;
//            case kServerRecountRowIndex:
//               // initInfo.reCount = [tempValues objectForKey:key];
//                break;
//            case kServerReTimesRowIndex:
//               // initInfo.reTimes = [tempValues objectForKey:key];
//                break;
//            default:
//                break;
//        }
//    }
//
// 
//    
//    //ip判断
//    if([ip length]==0 || ip==nil){
//        UIAlertView *alertip;
//        alertip= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                          message:@"公网地址不能为空"
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alertip show]; 
//        [alertip release];  
//        return;
//    }
//    //内网ip
//    if([intrantIp length]==0 || intrantIp==nil){
//         UIAlertView *alertintrantIp;
//         alertintrantIp= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                          message:@"内网地址不能为空"
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alertintrantIp show]; 
//        [alertintrantIp release];  
//        return;
//    }
//    //端口不能空
//    if([port length]==0 || port==nil){
//        UIAlertView *alertport;
//        alertport= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                                   message:@"端口不能为空"
//                                                  delegate:self
//                                         cancelButtonTitle:@"OK"   
//                                         otherButtonTitles:nil];
//        [alertport show]; 
//        [alertport release];  
//        return;
//    }
//
//    currentConnIP=nil;
//    currentConnPort=nil;
//    currentConnIP=[[NSMutableString alloc]init];
//    currentConnPort=[[NSMutableString alloc]init];
//    
//    [currentConnPort appendString:port];
//   // NSLog(@"---------------currentConnPort%@",currentConnPort);
//    
//    //当状态为正在连接时 返回
//    if (limitButtonClick==1) {
//        //limitButtonClick=1;
//        UIAlertView *alertc;
//        alertc= [[UIAlertView alloc] initWithTitle:@"提示信息" 
//                                              message:@"上一次连接未完成,请稍候...."
//                                             delegate:self
//                                    cancelButtonTitle:@"OK"   
//                                    otherButtonTitles:nil];
//        [alertc show]; 
//        [alertc release];  
//        return;
//    }    
//    
//    
//    NSError *err = nil;
//    //softxie
//    //connecting 
//    limitButtonClick = 1;//正在连接(标记按钮点击状态、防止连续点击)
//    
//    if (tag==0) {
//      
//      // currentConnIP=  [NSMutableString stringWithString:ip];
//        [currentConnIP appendString:ip];
//       // [currentConnIP initWithString: ip];
//       // NSLog(@"---------------连接外网%@",ip);
//      // NSLog(@"---------------连接外网端口%@",port);
//        [testasyncSocket connectToHost:ip onPort:[port integerValue] withTimeout:4.0  error:&err];
//    }else{
//                //[currentConnIP initWithString:intrantIp];
//       // currentConnIP=  [NSMutableString stringWithString:intrantIp];
//        [currentConnIP appendString:intrantIp];
//      //  NSLog(@"---------------连接内网%@",intrantIp);
//      //  NSLog(@"---------------连接内网网端口%@",port);
//        [testasyncSocket connectToHost:intrantIp onPort:[port integerValue] withTimeout:4.0  error:&err];
//    }
//   // NSLog(@"---------------currentConnIP%@",currentConnIP);
//}
//
//当连接上服务器时调用
//- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port 
//{ 
//    
//    //处理用户随便输入的ip 如:11.22?.45,56 手机会转换成如下IP
//    NSString *validIP=@"220.250.64.24";
//    if([host isEqualToString:validIP]){
//        UIAlertView *
//        alert= [[UIAlertView alloc] initWithTitle:@"服务器无法连接" 
//                                          message:@"请填写正确的服务器ip及端口"
//                                         delegate:self
//                                cancelButtonTitle:@"OK"   
//                                otherButtonTitles:nil];
//        [alert show]; 
//        [alert release];
//        
//        [sock disconnect];
// 
//        return;
//    }
//    limitButtonClick =2;//控制 点击 
//    
//  //  NSMutableString *sendContent=[NSMutableString stringWithString:@"ceshi" ]; 
// 
//    // NSData* aData = [sendContent dataUsingEncoding: NSUTF8StringEncoding];
//     //写入数据
//    //  [sock writeData:aData withTimeout:-1 tag:1];
//    //读取数据
//    //[sock readDataWithTimeout:-1 tag:0]; 
//    //NSLog(@"---------------------连接成功");
//    
//    isReConn=false;//设置重发为假 
//    NSString *alerinfo;
//    if (clickButtonTag==1) {
//        alerinfo=@"当前可访问内网";
//    }else{
//        alerinfo=@"当前可访问公网";
//    }
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接成功" 
//                                                    message:alerinfo
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK" 
//                                          otherButtonTitles:nil];
//    [alert show];
//    
//    [alert release];
//    [alerinfo release];
//    
//    if(sock!=nil){
//        [sock disconnect];
//    }
//    
//} 
//读取数据
//-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag 
//{ 
//    
//    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
//    //把响应信息赋给 全局变量
//   // responseInfo=[NSMutableString stringWithString:aStr];
//    
//    //如果 有正常的数据 
//    if([aStr length] >0){
//        limitButtonClick =2;//控制 点击 
//        isReConn=false;//设置重发为假 
//        NSString *alerinfo;
//        if (clickButtonTag==1) {
//            alerinfo=@"成功连接到内网";
//        }else{
//            alerinfo=@"成功连接到公网";
//        }
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接成功" 
//                                                        message:alerinfo
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK" 
//                                              otherButtonTitles:nil];
//        [alert show];
//        
//        [alert release];
//        [alerinfo release];
//        
//    }else{
//      isReConn=true;
//    }
//    
//    [aStr release]; 
//    if(sock!=nil){
//        [sock disconnect];
//    }
//    //[sock readDataWithTimeout:-1 tag:0];
//} 
//- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag 
//{ 
//    // NSLog(@"onSocket:%p didSecure:YES", sock); 
//} 

////处理重发
//- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err 
//{ 
//       limitButtonClick =2;//控制 点击 
//        isReConn=true;
//        NSError *err1=nil;
//        countConn++;//错误次数
//       
//        if (isReConn) {
//            
//             isReConn=false;
//              [testasyncSocket connectToHost:currentConnIP onPort:[currentConnPort integerValue] withTimeout:4.0  error:&err1];
//           
// 
//        }
//     
//      //if(countConn>1){
//        countConn=0;
//    
//       NSString *alerinfo;
//       if (clickButtonTag==1) {
//          alerinfo=@"内网无法连接";
//       }else{
//          alerinfo=@"公网无法连接";
//       }
//        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: alerinfo
//                                                         message:@"请检查IP和端口及服务器监听是否开启" 
//                                                        delegate:self
//                                               cancelButtonTitle:@"OK" 
//                                               otherButtonTitles:nil];
//        [alert1 show];
//        [alert1 release];
//        [alerinfo release];
//    // }
//     if(sock!=nil){
//        [sock disconnect];
//     }
//    //调用重发
//} 
//

//- (void)onSocketDidDisconnect:(AsyncSocket *)sock 
//{ 
//    limitButtonClick=2;
//    if(sock!=nil){
//        [sock disconnect];
//    }
//    
//    //断开连接了 
//    
//} 


- (void)textFieldDidBeginEditing:(UITextField *)textField{
   // NSLog(@"textFieldDidBeginEditing-------");
    
    self.textFieldBeingEdited = textField;
    activeField = textField;//当前 编辑对象
//    if (textField!=nil) {
//     if (textField.tag==0 || textField.tag==1) {
//        NSTimeInterval animationduation = 0.30f;
//        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//        [UIView setAnimationDuration:animationduation];
//        float width = self.view.frame.size.width;
//        float height = self.view.frame.size.height;
//        CGRect rect = CGRectMake(0.0f, 0, width, height);
//        self.view.frame = rect;
//        [UIView commitAnimations];  
//     }
//        //当点击第二行时往上移
//     if (textField.tag==2) {
//         NSTimeInterval animationduation = 0.30f;
//         [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//         [UIView setAnimationDuration:animationduation];
//         float width = self.view.frame.size.width;
//         float height = self.view.frame.size.height;
//         CGRect rect = CGRectMake(0.0f, -25, width, height);
//         self.view.frame = rect;
//         [UIView commitAnimations]; 
//      } 
//    }
   
 
}




- (void)textFieldDidEndEditing:(UITextField *)textField{
   // NSLog(@"textFieldDidEndEditing-------");
    NSNumber *tagAsNum = [[NSNumber alloc] initWithInt:textField.tag];
    [tempValues setObject:textField.text forKey:tagAsNum];
    
    
    //如果等于最后一个
    //[tableView setContentOffset:CGPointMake(0,0) animated:YES];
//    if (textField!=nil) {
//        if (textField.tag==2||textField.tag==3) {
//            NSTimeInterval animationduation = 0.30f;
//            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//            [UIView setAnimationDuration:animationduation];
//            float width = self.view.frame.size.width;
//            float height = self.view.frame.size.height;
//            CGRect rect = CGRectMake(0.0f, -25, width, height);
//            self.view.frame = rect;
//            [UIView commitAnimations];  
//        }
//    }
//   
       
    
    [tagAsNum release];
     
     activeField = nil;//当前 编辑对象
    
     
}
//新改界面表格结束

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
    
    [fm release];
    return apnContent;
    
}
//
////取消输入键盘
//-(IBAction)backgroundTap:(id)sender{
////    [serverip resignFirstResponder];
////    [serverport resignFirstResponder];
////    [reCount resignFirstResponder];
////    [reTimes resignFirstResponder];
//
//}

////写入文件 把连接的服务器信息
-(void)writeApnFile:(NSMutableString *)apnContent fileName:(NSString *)fileName{
    //  NSString *filename=@"unionApn";//
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    NSData *fileData;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    NSMutableString *data=[[NSMutableString alloc] initWithString:apnContent];
    
    fileData=[[data dataUsingEncoding:NSUTF8StringEncoding] retain];
  
    [fm createFileAtPath:[documentsDirectory stringByAppendingPathComponent:fileName] contents:fileData attributes:nil]; 
 
}

- (void)dealloc
{
    [super dealloc];
    [serverInfoFile release];
    [textFieldBeingEdited release];
    [tempValues release];
    [initInfo release];
    [fieldLabels release];  
    [tableViews release];
   // [testasyncSocket release];
    [currentConnIP release];
    [currentConnPort release];
    [activeField release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // NSLog(@"registe");
        // [self registerForKeyboardNotifications];//注册键盘事件
    }
    return self;
}
////键盘事件
//- (void)registerForKeyboardNotifications 
//{ 
//   
//            [[NSNotificationCenter defaultCenter] addObserver:self 
//             
//                                                     selector:@selector(keyboardWasShown:) 
//             
//                                                         name:UIKeyboardDidShowNotification object:nil];
//      
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self 
//     
//                                             selector:@selector(keyboardWasHidden:) 
//     
//                                                 name:UIKeyboardDidHideNotification object:nil]; 
//} 
// // 选中行进入编辑页面
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"----------------didSelectRowAtIndexPath----");
//    [[NSNotificationCenter defaultCenter] addObserver:self 
//     
//                                             selector:@selector(keyboardWasHidden:) 
//     
//                                                 name:UIKeyboardDidHideNotification object:nil]; 
//}
//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//NSLog(@"----------------accessoryButtonTappedForRowWithIndexPath----");
//}

////键盘显示
//- (void)keyboardWasShown:(NSNotification*)aNotification 
//{ 
//    
//    //NSLog(@"shown --the state of keyboardshown%i",keyboardShown); 
//    if (keyboardShown) 
//        return;
//    if(activeField!=nil){
//      if (activeField.tag==0) {
//        return;
//      }
//    }
//    
//   // NSLog(@"--------------tag %i",activeField.tag);
//   // NSLog(@"uprect by 30");
//    NSTimeInterval animationduation = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationduation];
//    float width = self.view.frame.size.width;
//    float height = self.view.frame.size.height;
//    CGRect rect = CGRectMake(0.0f, -25, width, height);
//    self.view.frame = rect;
//    [UIView commitAnimations];    
//    /*
//     int x_point=160;
//     int y_point=200;
//     NSLog(@"set the center of the tableview by x:%i y:%i",x_point,y_point);
//     self.view.center = CGPointMake(x_point, y_point);
//     */    
//    //NSLog(@"called keyboarddidshow");
//    NSDictionary* info = [aNotification userInfo];     
//    // Get the size of the keyboard. 
//    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey]; 
//    CGSize keyboardSize = [aValue CGRectValue].size;     
//    // Resize the scroll view (which is the root view of the window) 
//    CGRect viewFrame = [tableViews frame]; 
//    viewFrame.size.height -= keyboardSize.height; 
//    tableViews.frame = viewFrame;     
//    // Scroll the active text field into view. 
//    CGRect textFieldRect = [activeField frame]; 
//    [tableViews scrollRectToVisible:textFieldRect animated:YES];    
//    keyboardShown = YES; 
//} 
////键盘隐藏
//- (void)keyboardWasHidden:(NSNotification*)aNotification 
//{ 
//    //NSLog(@"off --the state of keyboardshown%i",keyboardShown);
//    if (!keyboardShown) {
//        return;
//    }    
//    //NSLog(@"downrect by 30");
//    NSTimeInterval animationduation = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationduation];
//    float width = self.view.frame.size.width;
//    float height = self.view.frame.size.height;
//    CGRect rect = CGRectMake(0.0f, 0, width, height);
//    self.view.frame = rect;
//    [UIView commitAnimations];    
//    /*
//     int x_point=160;
//     int y_point=200;
//     NSLog(@"set the center of the tableview by x:%i y:%i",x_point,y_point);
//     self.view.center = CGPointMake(x_point, x_point);
//     */    
//    //NSLog(@"called keyboarddidhide");
//    NSDictionary* info = [aNotification userInfo];     
//    // Get the size of the keyboard. 
//    NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey]; 
//    CGSize keyboardSize = [aValue CGRectValue].size;     
//    // Reset the height of the scroll view to its original value 
//    CGRect viewFrame = [tableViews frame]; 
//    viewFrame.size.height += keyboardSize.height; 
//    tableViews.frame = viewFrame;     
//    keyboardShown = NO; 
//} 
//
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
