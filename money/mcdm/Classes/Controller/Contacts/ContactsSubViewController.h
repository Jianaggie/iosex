//
//  ContactsSubViewController.h
//  mcdm
//
//  Created by Cyber Wise on 13-01-22.
//  Copyright (c) 2013年 Cyber Wise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>

#define NAME     @"name"
#define PHONE     @"phone"
#define EMAIL     @"email"

@interface ContactsSubViewController : UIViewController<MFMessageComposeViewControllerDelegate>
@property(nonatomic, retain) NSDictionary* dictContact;
@end
