//
//  DetailViewController.m
//  Homepwner
//
//  Created by lovocas on 13-11-4.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"



@implementation DetailViewController
@synthesize item;
//@synthesize key;

-(void)viewDidLoad{
    [super viewDidLoad];
    [[self view]setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [nameField setText:[item  itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d",[item valueInDollars]]];
    NSDateFormatter * dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [datelabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
    UIImage * image = [[BNRImageStore sharedstore]imageForKey:[item imageKey]];
    if(image)
       [imageview setImage:image];
    else
        [imageview setImage:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text]intValue]];
}
-(void)setItem:(BNRItem *)i
{
    item=i;
    [self.navigationItem setTitle:[item itemName]];
}
- (IBAction)takePicture:(id)sender {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:Nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(item.imageKey)
    {
        [[BNRImageStore sharedstore]deleteImageforKey:[item imageKey]];
    }
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CFUUIDRef  newuniqueId = CFUUIDCreate(kCFAllocatorDefault);//create the unique id
    CFStringRef  newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newuniqueId);
    NSString * Imagekey = (__bridge NSString *) newUniqueIdString;//(_bridge NSString *)newUniqueIdString;
    //self.key = Imagekey;
    [item  setImageKey:Imagekey];
    CFRelease(newUniqueIdString);
    CFRelease(newuniqueId);
    [[BNRImageStore sharedstore]setImage:image forKey:[item imageKey]];
    [imageview setImage:image];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
