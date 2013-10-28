//
//  AppDelegate.m
//  MCDM
//
//  Created by Fred on 12-12-26.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "AppDelegate.h"
#import "BCTabBarController.h"
#import "Task.h"
#import "MBProgressHUD.h"
#import "DataLoader.h"
#import "ASIHTTPRequest.h"
#import "SNViewController.h"
#import "BCTabBarView.h"
#import "RootViewController.h"
#import "NewsViewController.h"
#import "CustomNavigationController.h"
@implementation AppDelegate
@synthesize window = _window;
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (UINavigationController *)getCurrentNavigationController
{
    BCTabBarController *controller = (BCTabBarController *)self.window.rootViewController;
    return (UINavigationController *)controller.selectedViewController;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *scheme = [url scheme];
    if (![scheme isEqualToString:@"mcdm"])
    {
        return NO;
    }
    
    NSDictionary *params = [[url absoluteString] parseUrlParams];
    _Log(@"params: %@", params);
    
    NSString *host = [url host];
    int port = [[url port] intValue];
    
    NSUtil::SetSettingForKey(kServerKey, port ? [NSString stringWithFormat:@"http://%@:%d", host, port] : [NSString stringWithFormat:@"http://%@", host]);
    
    NSUtil::SetSettingForKey(kCodeKey, [params objectForKey:@"code"]);
    NSUtil::SaveSettings();
    
    NSString *code = NSUtil::SettingForKey(kCodeKey);
    if ([code length])
    {
        [[DataLoader loader] getConfigFiles:self];
    }
    
    //[UIAlertView alertWithTitle:[NSString stringWithFormat:@"launchUrl:%@, /n host:%@ port:%d /n params:%@", launchUrl, [launchUrl host], [[launchUrl port] intValue], params]];
    //自动刷新资讯
    BCTabBarController* controller = (BCTabBarController *)_window.rootViewController;
    CustomNavigationController* navCtrllrSelected = (CustomNavigationController*)controller.selectedViewController;
    NewsViewController* _ViewControllerNews = (NewsViewController*)[navCtrllrSelected firstViewController];
    //[_ViewControllerNews onRefresh];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIUtil::ShowStatusBar(YES, NO);
    
    BCTabBarController *controller = [[BCTabBarController alloc] init];
    self.window.rootViewController = controller;
    [controller release];
    
    [self.window makeKeyAndVisible];
    
    NSURL *launchUrl = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
    if (launchUrl)
    {
        [self handleOpenURL:launchUrl];
    }
    else if(nil == NSUtil::SettingForKey(kCodeKey))
    {
        SNViewController* SNViewCtrlr = [[SNViewController alloc]initWithNibName:@"SNViewController" bundle:nil];
        SNViewCtrlr.title = @"激活";
        //SNViewCtrlr.navigationItem.hidesBackButton = YES;
        //[SNViewCtrlr setParentVCtrlr:self];
        //[controller setSelectedViewController:SNViewCtrlr];
        CustomNavigationController* navCtrllr = (CustomNavigationController*)controller.selectedViewController;
        navCtrllr.firstViewController = navCtrllr.topViewController;
        [navCtrllr pushViewController:SNViewCtrlr animated:NO];
        SNViewCtrlr.navigationItem.hidesBackButton = YES;
        SNViewCtrlr.navigationItem.leftBarButtonItem = nil;
    }
    
    // 因为服务器端只返回 200之类，没有返回具体的执行结果。所以客户端每次都注册。以便提交token
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                UIRemoteNotificationTypeBadge |
                                UIRemoteNotificationTypeSound)];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    BCTabBarController* controller = (BCTabBarController *)_window.rootViewController;
    CustomNavigationController* navCtrllrSelected = (CustomNavigationController*)controller.selectedViewController;
    RootViewController* _ViewControllerRoot = (RootViewController*)[navCtrllrSelected firstViewController];
    if ([_ViewControllerRoot respondsToSelector:@selector(applicationDidEnterBackground:)]) {
        [_ViewControllerRoot applicationDidEnterBackground:application];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[DataLoader loader] getNotificationList:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	[self postDeviceToken:deviceToken];
}

#define kTimeOut 30

//
- (void)postDeviceToken:(NSData *)deviceToken
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *url = [DataLoader getNotificationListUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
	request.timeOutSeconds = kTimeOut;
	request.requestMethod = @"POST";
    
    [request appendPostData:[[deviceToken description] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(onPostedDeviceTokenFailed:)];
    [request setDidFinishSelector:@selector(onPostedDeviceToken:)];
    [request startAsynchronous];
	
	[pool drain];
}

//
- (void)onPostedDeviceToken:(ASIHTTPRequest *)request
{
    
}

- (void)onPostedDeviceTokenFailed:(ASIHTTPRequest *)theRequest
{
	_Log(@"%@",[theRequest error]);
}

//
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    _Log(@"%@", [NSString stringWithFormat: @"Error: %@", err]);
}

//
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	_Log(@"didReceiveRemoteNotification: %@", userInfo);
	
    [[DataLoader loader] getNotificationList:nil];
    application.applicationIconBadgeNumber = 0;
}

// TaskDelegate <NSObject>
- (void)taskStarted:(TaskType)type
{
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    progress.labelText = @"正在下载配置文件";
}

// NSError or data object.
- (void)taskFinished:(TaskType)type result:(id)result
{
    [MBProgressHUD hideHUDForView:self.window animated:YES];
    
    NSUtil::SaveSettingForKey(kCodeKey, @"");
    
    if ([result isKindOfClass:[NSError class]])
    {
        MBProgressHUD *show = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        show.mode = MBProgressHUDModeText;
        show.labelText = @"下载配置文件失败，请关闭应用，重新加入系统";
        [show hide:YES afterDelay:3];
        
        //[self.view makeToast:[(NSError *)result localizedDescription] duration:0.5 position:@"center"];
    }
    else
    {
        
//        <plist version="1.0">
//        <dict>
//        <key>dmconfig</key>
//        <dict>
//		<key>dmserver</key>
//		<dict>
//        <key>address</key>
//        <string>cyber.gameco.com.cn</string>
//        <key>port</key>
//        <string>443</string>
//        </dict>
//		<key>activationCode</key>
//		<dict>
//        <key>code</key>
//        <string>S5YADNIgUSBdeJdUtkOD</string>
//		</dict>
//        </dict>
//        </dict>
//        </plist>
        
        NSDictionary *otaDict = [NSDictionary dictionaryWithContentsOfFile:kOTAInfoFile];
        NSDictionary *dmconfig = [otaDict objectForKey:@"dmconfig"];
        
        NSDictionary *dmserver = [dmconfig objectForKey:@"dmserver"];
        NSString *address = [dmserver objectForKey:@"address"];
        NSString *port = [dmserver objectForKey:@"port"];
        
        NSDictionary *activationCode = [dmconfig objectForKey:@"activationCode"];
        NSString *code = [activationCode objectForKey:@"code"];
        
        NSString *otaUrl = [DataLoader getEnrollOTAUrl:address port:port code:code];
        if (otaUrl)
        {
            _Log(@"enroll otaUrl:%@", otaUrl);
            
            UIUtil::OpenURL(otaUrl);
        }
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    _Log(@"handleOpenURL:%@", url);
    
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    _Log(@"openURL:%@", url);
    
    return [self handleOpenURL:url];
}

@end
