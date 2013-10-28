//
//  hyposisterAppDelegate.m
//  hyposister
//
//  Created by lovocas on 13-7-23.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "hyposisterAppDelegate.h"
#import "hyposister.h"

@implementation hyposisterAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    CGRect screenRect = [[self window]bounds];
    UIScrollView * scrollview= [[UIScrollView alloc ] initWithFrame:screenRect];
    [scrollview setPagingEnabled:YES];
    [[self window]addSubview:scrollview];
    
    CGRect viewFrame2 = CGRectMake(0, 0, screenRect.size.width+50, screenRect.size.height);
    hyposister * view2 = [[hyposister alloc] initWithFrame:viewFrame2];
    CGSize contentsize = screenRect.size;
    contentsize.width*=2;
    [scrollview setContentSize:contentsize];
    [scrollview addSubview:view2];

    CGRect viewFrame3 = CGRectMake(screenRect.size.width+50, 0, screenRect.size.width-50,screenRect.size.height);
    hyposister * view3 = [[hyposister alloc] initWithFrame:viewFrame3];
    
    [scrollview addSubview:view3];
    bool success=[view2 becomeFirstResponder];
    if(success){
        NSLog(@"view become first responder success");
    
    }
    else{
        NSLog(@"view become first responder fail");
    }
 
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
/*
- (id)init
{
    self = [super init];
    if (self) {
        <#initializations#>
    }
    return self;
}*/



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
