//
//  PersonalContactsController.h
//  MCDM
//
//  Created by Fred on 13-1-8.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TaskDelegate;

@class ContactsProgressBar;

@interface PersonalContactsController : UIViewController <TaskDelegate, UIAlertViewDelegate>
{
    UILabel *_countInfoLabel;
    
    UIView *_personalView;
    
    ContactsProgressBar *_progressBar;
}

@end
