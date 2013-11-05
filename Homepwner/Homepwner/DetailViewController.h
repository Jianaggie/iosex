//
//  DetailViewController.h
//  Homepwner
//
//  Created by lovocas on 13-11-4.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRImageStore.h"
@class BNRItem;
@interface DetailViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *datelabel;
    __weak IBOutlet UIImageView *imageview;
}
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
@property (weak ,nonatomic)BNRItem * item;
//@property (nonatomic,weak) NSString * key;
@end

