//
//  CustomNavigationController.h
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+UIViewController_category.h"

@interface CustomNavigationController : UINavigationController <UINavigationControllerDelegate>
@property(nonatomic,retain) UIViewController *firstViewController; // The first view controller on the stack.
@end
