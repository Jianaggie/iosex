//
//  UIViewController+UIViewController_category.m
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "UIViewController+UIViewController_category.h"

@implementation UIViewController (UIViewController_category)

//
- (void)popSelf
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)iconImageName
{
	return nil;
}

@end
