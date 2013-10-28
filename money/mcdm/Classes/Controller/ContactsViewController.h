//
//  ContactsViewController.h
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@interface ContactsViewController : BaseController
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    
    NSArray *_controllers;
    UIView *_contentViewForController;
	UIViewController *_activeViewController;
}

@end
