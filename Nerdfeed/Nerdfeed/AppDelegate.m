//
//  AppDelegate.m
//  Nerdfeed
//
//  Created by lovocas on 13-11-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "AppDelegate.h"
#import "listViewController.h"
#import "webViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    listViewController * lvc =[[listViewController alloc]initWithStyle:UITableViewStylePlain];
     webViewController * wv =[[webViewController alloc]init];
    [lvc setWebView:wv];
    UINavigationController * maseter= [[UINavigationController alloc]initWithRootViewController:lvc];
    if([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad )
    {
        //create the split view
        UINavigationController * detail=[[UINavigationController alloc]initWithRootViewController:wv];
        UISplitViewController  * splitView =[[UISplitViewController alloc]init];
        [splitView setDelegate:wv];
        [splitView setViewControllers:[NSArray arrayWithObjects:maseter,detail,nil]];
        [self.window setRootViewController:splitView];
    }
    if([[UIDevice currentDevice]userInterfaceIdiom ]==UIUserInterfaceIdiomPhone)
    {
        [self.window setRootViewController:maseter];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
