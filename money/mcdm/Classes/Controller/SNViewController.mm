//
//  SNViewController.m
//  mcdm
//
//  Created by Cyber Wise on 13-1-6.
//  Copyright (c) 2013年 CyberWise. All rights reserved.
//

#import "SNViewController.h"
//#import "CommonUtils.h"
#import <QuartzCore/QuartzCore.h>
//#import "HomeViewController.h"
#import "AppDelegate.h"
#import "BCTabBarController.h"
@interface SNViewController (){
    UIImage* imgNavBar;
}
@end

@implementation SNViewController
@synthesize txtSN;
@synthesize bttnSN;
@synthesize cancleButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setParentVCtrlr:(HomeViewController*) vCtrlrHome
{
    parentVCtrlr = vCtrlrHome;
}

-(IBAction)pressSN:(id)sender{
    NSURL* launchUrl;
    NSString* sLaunchUrl;
    if (20 != txtSN.text.length) {
        //return;
    }
    NSString* serverAddrCA = [[NSBundle mainBundle] pathForResource:@"PList" ofType:@"plist"];
    NSDictionary* dicUrl = [NSDictionary dictionaryWithContentsOfFile:serverAddrCA];
    NSString* sUrl = [dicUrl objectForKey:@"Cert"];
    NSURL* urlURL = [NSURL URLWithString:sUrl];
    NSString* host = [NSString stringWithFormat:@"%@",[urlURL host]];
    NSString* port = [NSString stringWithFormat:@"%@",[urlURL port]];
    sLaunchUrl = [[NSString alloc] initWithFormat:@"mcdm://%@:%@?code=%@", host, port, txtSN.text];
    launchUrl = [[NSURL alloc] initWithString:sLaunchUrl];
    [UIUtil::Delegate() handleOpenURL:launchUrl];
    [self.navigationController.navigationBar setBackgroundImage:imgNavBar forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:NO];
    /*BCTabBarController* tabBCtrllr = (BCTabBarController*)UIUtil::Delegate().window.rootViewController;
    tabBCtrllr.tabBar.hidden = NO;
    [tabBCtrllr setSelectedViewController:[tabBCtrllr.viewControllers objectAtIndex:0]];*/
    /*NSString* filePath = NSUtil::DocumentsSubPath(kSettingsFile);
    //获得应用程序委托中建立的文件
    NSDictionary *webServerAddr = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    //由文件获取与服务器交互初始地址
    NSString *host = [webServerAddr objectForKey:@"host"];
    NSString *port = [webServerAddr objectForKey:@"port"];
    //[webServerAddr setValue:[NSString stringWithFormat:@"%s=%@", "code", txtSN.text] forKey:@"code"];
    NSString *serverInfoPath = [NSString stringWithFormat:@"mcdm/resource/sif"];
    NSString *os = [NSString stringWithFormat:@"os=ios"];
    NSString *serverInfoString=nil;
    if(port!=nil) {
        serverInfoString = [NSString stringWithFormat:@"http://%@:%@/%@?code=%@&%@",host,port,serverInfoPath, txtSN.text, os];  
    }
    else {
        serverInfoString = [NSString stringWithFormat:@"http://%@/%@?code=%@&%@",host,serverInfoPath, txtSN.text, os];
    }
    [parentVCtrlr startGettingInfo:serverInfoString];
    //[webServerAddr writeToFile:filePath  atomically:(YES)];
    [webServerAddr release];*/
}

-(IBAction)pressSNCancel{
    [self.navigationController.navigationBar setBackgroundImage:imgNavBar forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewDidLoad
{
    imgNavBar = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault].copy;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    float blueColor[] = {(71.0/255),(101.0/255),(157.0/255),1.0};
    float greenColor[] = {(137.0/255),(206.0/255),(21.0/255),1.0};
    CGColorSpaceRef devRGB = CGColorSpaceCreateDeviceRGB();
    CGColorRef cgGreenColor = CGColorCreate(devRGB,greenColor);
    CGColorRef cgBlueColor = CGColorCreate(devRGB,blueColor);
    bttnSN.layer.masksToBounds = YES;
    bttnSN.layer.cornerRadius = 3.0;
    bttnSN.layer.borderWidth = 1.0;
    bttnSN.layer.borderColor = cgGreenColor;
    bttnSN.layer.backgroundColor = cgGreenColor;
    
    cancleButton.layer.masksToBounds = YES;
    cancleButton.layer.cornerRadius = 3.0;
    cancleButton.layer.borderWidth = 1.0;
    cancleButton.layer.borderColor = cgBlueColor;
    cancleButton.layer.backgroundColor = cgBlueColor;
#if TARGET_IPHONE_SIMULATOR
#ifdef DEBUG
    txtSN.text = @"HIEvIL4NIdIeSrfZjH7L";
#endif
#endif
    txtSN.layer.masksToBounds = YES;
    txtSN.layer.cornerRadius = 3.0;
    txtSN.layer.borderWidth = 1.0;
    txtSN.layer.borderColor = cgBlueColor;
    CGColorSpaceRelease(devRGB);
    CGColorRelease(cgBlueColor);
    CGColorRelease(cgGreenColor);
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    txtSN = nil;
    bttnSN = nil;
}

-(void)dealloc{
    [super dealloc];
    [txtSN release];
    [bttnSN release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//UITextField取消键盘
-(IBAction)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

@end
