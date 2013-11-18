//
//  ItemsViewController.h
//  Homepwner
//
//  Created by lovocas on 13-10-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "DetailViewController.h"
@interface ItemsViewController : UITableViewController <UIPopoverControllerDelegate>
{
  //  @property (nonatomic,strong)IBOutlet  UIView * headerView;
    UIPopoverController * Imagepopover;
}
//-(UIView *)headerView;
-(IBAction)addNewItem:(id)sender;
-(void)showImage:(id)sender atIndex:(NSIndexPath*)path;
//-(IBAction)toggleEditingMode:(id)sender;
@end
