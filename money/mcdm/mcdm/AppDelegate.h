//
//  AppDelegate.h
//  MCDM
//
//  Created by Fred on 12-12-26.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskDelegate;

@interface AppDelegate : UIResponder <UIApplicationDelegate, TaskDelegate>

@property (strong, nonatomic) UIWindow *window;

- (UINavigationController *)getCurrentNavigationController;
- (BOOL)handleOpenURL:(NSURL *)url;

@end
