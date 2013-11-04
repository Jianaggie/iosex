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
@end
