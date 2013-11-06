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
@interface DetailViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>
{
    
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *datelabel;
    __weak IBOutlet UIImageView *imageview;
    UIPopoverController * Imagepopover;
}
- (IBAction)takePicture:(id)sender;
-(id)initForNewItem:(BOOL)isNew;
- (IBAction)backgroundTapped:(id)sender;
@property (weak ,nonatomic)BNRItem * item;
@property (nonatomic,copy)void(^reloadBlock) (void);
//@property (nonatomic,weak) NSString * key;
@end

