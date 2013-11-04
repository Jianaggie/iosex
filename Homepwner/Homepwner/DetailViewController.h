//
//  DetailViewController.h
//  Homepwner
//
//  Created by lovocas on 13-11-4.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;
@interface DetailViewController : UIViewController
{
    
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *datelabel;
}
@property (weak ,nonatomic)BNRItem * item;
@end
