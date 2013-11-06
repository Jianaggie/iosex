//
//  DetailViewController.m
//  Homepwner
//
//  Created by lovocas on 13-11-4.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "ImagePicker.h"
#import "BNRItemStore.h"

@implementation DetailViewController
@synthesize item,reloadBlock;
//@synthesize key;
-(void)save:(id) sender{
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:[self reloadBlock]];
}
-(void)cancle :(id) sender
{
    [[BNRItemStore sharedStore]removeItem:item];
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:[self reloadBlock]];
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    @throw [NSException exceptionWithName:@"wrong initializer" reason:@"please use method initForNewItem" userInfo:nil];
    return nil;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    UIColor * col;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        col=[UIColor colorWithRed: 0.875 green:0.88 blue:0.91 alpha:1];
    }
    else
        col = [UIColor groupTableViewBackgroundColor];
    [[self view]setBackgroundColor:col];
}

-(id)initForNewItem:(BOOL)isNew
{
   self= [super initWithNibName:@"DetailViewController" bundle:nil];
    if(self)
    {
        if(isNew)
        {
            UIBarButtonItem* done= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(save:)];
            [self navigationItem].rightBarButtonItem=done;
            UIBarButtonItem * cancle =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancle:)];
            [self navigationItem].leftBarButtonItem=cancle;
            
        }
    }
    return self;
    
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
    if ([Imagepopover isPopoverVisible]) {
        [Imagepopover dismissPopoverAnimated:YES];
        Imagepopover =nil;
        return;
        
    }
    ImagePicker * imagePicker =[[ImagePicker alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        Imagepopover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
        [Imagepopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
        
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

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"pop over controller is dismissed!");
    Imagepopover = nil;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(item.imageKey)
    {
        [[BNRImageStore sharedstore]deleteImageforKey:[item imageKey]];
    }
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    CFUUIDRef  newuniqueId = CFUUIDCreate(kCFAllocatorDefault);//create the unique id
    CFStringRef  newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newuniqueId);
    NSString * Imagekey = (__bridge NSString *) newUniqueIdString;//(_bridge NSString *)newUniqueIdString;
    //self.key = Imagekey;
    [item  setImageKey:Imagekey];
    CFRelease(newUniqueIdString);
    CFRelease(newuniqueId);
    [[BNRImageStore sharedstore]setImage:image forKey:[item imageKey]];
    [imageview setImage:image];
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:Nil];
    } else {
        [Imagepopover dismissPopoverAnimated:YES];
        Imagepopover = nil;
    }
    
}
@end
