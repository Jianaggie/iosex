//
//  SysInfoViewController.m
//  unuion03
//
//  Created by easystudio on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SysInfoViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"
@implementation SysInfoViewController
@synthesize navItem;
@synthesize sysInfoArray;
@synthesize tableViews;
@synthesize fieldLabels;
@synthesize filedLabelsSeion2;
@synthesize sysInfoSection2Array;
@synthesize delegate;

@synthesize currentAPNarray;
@synthesize fieldLabel0;
//@synthesize tempIP;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
     
    [super viewDidLoad];
   
     NSString  *currentAPN=[self readFile:CurrentAPNFileName];//从文件读取当前APN配置
    if (currentAPN==nil || [currentAPN isEqualToString:@""]) {
        currentAPN=@"暂无APN配置";
    }
     NSString  *deviveName=[[UIDevice currentDevice] name];//设备名称
     NSString*  model=[[UIDevice currentDevice] model];//设备类别
     NSString*  systemName=[[UIDevice currentDevice] systemName];//系统名称
     NSString*  systemVersion=[[UIDevice currentDevice] systemVersion];//系统版本
     NSString*  udid= [[UIDevice currentDevice] uniqueIdentifier];//udid
     ipAddress=[[NSMutableString alloc]init];//[self localIPAddress];//@"192.168.1.10";//
     NSString *macAddress=[self macaddress];
    //3g none  
    if ([[self internetStatus] isEqualToString:@"wifi"]) {
        [ipAddress setString:[self localWiFiIPAddress]];
    }else if([[self internetStatus] isEqualToString:@"3g"]){
//        unuion03AppDelegate *app    =  [[UIApplication sharedApplication] delegate];
//
//          // tempIP = [[NSMutableString alloc]init];
//        
//         //  [ipAddress setString:[self localIPAddress]];
         [ipAddress setString:[self readFile:@"sysipfile"]];
//         
//        NSLog(@"sys==========%@",app.tempIP);
        
          //[NSThread detachNewThreadSelector:@selector(setIPByThread) toTarget:self withObject:nil];
        
    }
    
     
    if (ipAddress==nil || ipAddress==NULL|| [ipAddress isEqualToString:@""]) {
        [ipAddress setString:@"无法获取IP,请检查网络"];
    }
    if (ipAddress==NULL || [ipAddress isEqualToString:@"(null)"]) {
        [ipAddress setString:@"无法获取IP,请检查网络"];
    }
    if ([ipAddress isEqualToString:@"fe80::1%lo0"]) { 
        [ipAddress setString:@"无法获取IP,请检查网络"];
    }
//    //第1分区
//    fieldLabel0=[[NSArray alloc]initWithObjects:@"当前APN", nil];
//    currentAPNarray=[[NSArray alloc]initWithObjects:currentAPN, nil];
    
     //表格行标题 第二分区
    fieldLabels=[[NSArray alloc]initWithObjects:@"设备名称",@"设备类别",@"系统名称",@"系统版本",@"设备序号", nil];
    //表格行内容
    sysInfoArray=[[NSMutableArray alloc]initWithObjects:deviveName,model, systemName,systemVersion,udid,nil];
     //第三分区
    filedLabelsSeion2=[[NSArray alloc]initWithObjects:@"当前APN",@"IP地址",@"MAC地址", nil];
    sysInfoSection2Array=[[NSArray alloc]initWithObjects:currentAPN,ipAddress, macAddress,nil];
    [self.tableViews reloadData];
    
    
//    [deviveName release];
//    [model release];
//    [systemName release];
//    [systemVersion release];
//    [udid release];
//    [ipAddress release];
//    [macAddress release];
    
    
}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//   // [self.tableViews scrollsToTop];
//    
////    //[twoView.view setFrame:CGRectMake(320, 20, 320, 480)];
////    self.tableViews = [[UITableView alloc] initWithFrame:CGRectMake(320, 20, 320, 480) style:UITableViewStyleGrouped];
////    self.tableViews.backgroundColor = [UIColor clearColor];
////    
////    self.tableViews.delegate = self;  
////    self.tableViews.dataSource = self;  
////    [self.tableViews removeFromSuperview];
////    [self.view addSubview:tableViews];
//   [self.tableViews reloadData];
//    
//    NSLog(@"viewDidAppearviewDidAppear----------Sys");
//}


//设置IP
-(void)setIPByThread{
    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc]init];
    //[self performSelectorOnMainThread:@selector(addaverImg) withObject:nil waitUntilDone:NO];
    
    [ipAddress setString:[self localIPAddress]];
    [pool release];
    
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    //加一个 返回按钮
    self.navigationItem.hidesBackButton = YES;
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backimg= [UIImage imageNamed:@"BackIcon.png"];
    [leftbutton setImage:[UIImage imageNamed:@"BackIcon.png"] forState:UIControlStateNormal];
    leftbutton.frame=CGRectMake(0, 0, backimg.size.width, backimg.size.height);
    navItem
    .leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    [leftbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
} 
-(void)back{
    //self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
//-(void)loadView{
//NSLog(@"loadViewloadViewloadView----------Sys");
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return [sysInfoArray count];
    }
    else {
        return [sysInfoSection2Array count];
    }
//    else{
//        return [sysInfoSection2Array count];
//    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{	
     
    UIView *label = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];	return label;
}

-(CGFloat)tableView:(UITableView*) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(nil == self.navigationController)
    {
        return 44.0;
    }
    else
    {
        return 42.0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

   // NSLog(@"--------cellForRowAtIndexPathcellForRowAtIndexPath----");
    self.tableViews.contentSize=CGSizeMake(self.tableViews.frame.size.width,self.tableViews.frame.size.height);
    //[self.tableViews setFrame:CGRectMake(0, 50, 320, 480)];
    //NSLog(@"tableview");
     UIImageView *backView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablebackImg.png"]];
     self.tableViews.backgroundView=backView;
    static NSString *SystemInfoTableIndetifier=@"SystemInfoTableIndetifier";
    //取出数据
    //SysInfo *sysInfo = [sysInfoArray objectAtIndex:indexPath.row];
    UITableViewCell *cell= [self.tableViews dequeueReusableCellWithIdentifier:SystemInfoTableIndetifier];
    if (cell==nil) {
        cell= [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SystemInfoTableIndetifier]autorelease];
        cell.backgroundColor=[UIColor whiteColor];
    }
    //cell.
    NSInteger currsecion=indexPath.section;
    NSInteger numberOfLines=0;
//    if (currsecion==0) {
//        cell.textLabel.text=[fieldLabel0 objectAtIndex:indexPath.row];
//        UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
//        
//        
//        cell.textLabel.font=font;
//        cell.detailTextLabel.text=[currentAPNarray objectAtIndex:indexPath.row];
//        cell.detailTextLabel.textAlignment=UITextAlignmentLeft;
//        cell.detailTextLabel.lineBreakMode=UILineBreakModeCharacterWrap;
//        cell.detailTextLabel.numberOfLines=numberOfLines;
//         cell.textLabel.textColor=[UIColor brownColor];
//        cell.detailTextLabel.textColor=[UIColor brownColor];
//        //cell.textColor.textColor=[UIColor colorWithCGColor:
//    }
    if (currsecion==1) {
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 300, 30)];
//        label.tag=indexPath.row;
        cell.textLabel.text=[fieldLabels objectAtIndex:indexPath.row];
         UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        
    
        cell.textLabel.font=font;
        cell.detailTextLabel.text=[sysInfoArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.textAlignment=UITextAlignmentLeft;
        cell.detailTextLabel.lineBreakMode=UILineBreakModeCharacterWrap;
        cell.detailTextLabel.numberOfLines=numberOfLines;
        //label.text=[sysInfoArray objectAtIndex:indexPath.row];
        //[cell.contentView addSubview:label];
        cell.textLabel.textColor=[UIColor darkGrayColor];
        
       // cell.detailTextLabel.textColor=[UIColor grayColor];
    }
    if (currsecion==0) {
        UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        cell.textLabel.font=font;
       
        cell.textLabel.text=[filedLabelsSeion2 objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=[sysInfoSection2Array objectAtIndex:indexPath.row];
        cell.detailTextLabel.textAlignment=UITextAlignmentLeft;
        cell.detailTextLabel.lineBreakMode=UILineBreakModeCharacterWrap;
        cell.textLabel.textColor=[UIColor darkGrayColor];
         cell.detailTextLabel.numberOfLines=numberOfLines;
        if (indexPath.row==0) {
            cell.textLabel.textColor=[UIColor colorWithRed:.8 green:.4 blue:.1 alpha:1];
           // cell.textLabel.alpha=0.1;
           // cell.detailTextLabel.textColor=[UIColor brownColor];
           cell.detailTextLabel.textColor= [UIColor colorWithRed:.8 green:.4 blue:.1 alpha:1]; 
            cell.detailTextLabel.font=font;
         
        }
         
    }
    
    return cell;
    
}
-(NSString*)internetStatus{
    if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)) {
         return @"wifi";
    }
    if (([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)) {
        return @"3g";
    }
    
    return @"none";
}
//+ (BOOL) IsEnableWIFI {
//    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
//}
//
//// 是否3G
//+ (BOOL) IsEnable3G {
//    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
//}



//获取mac地址
#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
      NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
   // NSString *outstring = [NSString stringWithFormat:@"%02x-%02x-%02x-%02x-%02x-%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}


//- (NSString *) localIPAddress
//{
//    char iphone_ip[255];
//    strcpy(iphone_ip,"127.0.0.1"); // if everything fails
//    NSHost* myhost =[NSHost currentHost];
//    if (myhost)
//    {
//        NSString *ad = [myhost address];
//        
//        if (ad)
//            
//            strcpy(iphone_ip,[ad cStringUsingEncoding:NSASCIIStringEncoding]);
//        
//    }
//    return [NSString stringWithFormat:@"%s",iphone_ip];
//    
//    
//} 

//- (NSString *) localIPAddress 
//{ 
////    struct hostent *host = gethostbyname([[self hostname] UTF8String]); 
////    if (!host) {herror("resolv"); return nil;} 
////    struct in_addr **list = (struct in_addr **)host->h_addr_list; 
////    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding]; 
//    InitAddresses();    
//   // FreeAddresses();
//    GetIPAddresses();     
//    GetHWAddresses();      
//    NSLog(@"[NSString stringWithFormat ip_names[1]]%s",ip_names[1]);
//    return [NSString stringWithFormat:@"%s", ip_names[1]];  
//} 


- (NSString *) localIPAddress
{
    NSURL *ipURL = [NSURL URLWithString:@"http://automation.whatismyip.com/n09230945.asp"];
    NSString *getIp = [NSString stringWithContentsOfURL:ipURL
                                               encoding:NSUTF8StringEncoding error:nil];
                    return   getIp;                                    
}
//获取3g状态下的 ip要改一下，在切换到专网后不能获取
//- (NSString *) localIPAddress
//{
//    char iphone_ip[255];
//    strcpy(iphone_ip,"127.0.0.1"); // if everything fails
//    NSHost* myhost =[NSHost currentHost];
//    if (myhost)
//    {
//        NSString *ad = [myhost address];
//        
//        if (ad)
//            
//            strcpy(iphone_ip,[ad cStringUsingEncoding:NSASCIIStringEncoding]);
//        
//    }
//    return [NSString stringWithFormat:@"%s",iphone_ip];
//    
//    
//} 




 
- (NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}






 




//读取 当前APN配置
-(NSString *)readFile:(NSString *)RfileName
{
    NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *documentsDirectory=[documentPath objectAtIndex:0];
    
    NSString *apnContent=nil;
    NSFileManager *fm=[ NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:RfileName]]==YES){
        apnContent=[NSString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:RfileName] encoding:NSUTF8StringEncoding error:nil];
    } else{
        apnContent=@"";
    }
    
    [fm release];
    return apnContent;
    
}


- (void)dealloc
{
    [super dealloc];
    [sysInfoArray release];
    [fieldLabels release];
    [sysInfoSection2Array release];
    [filedLabelsSeion2 release];
    [currentAPNarray release];
    [fieldLabel0 release];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
	[super viewWillDisappear:animated];
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
