//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by lovocas on 13-11-7.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "TemplateCell.h"
@interface HomepwnerItemCell : TemplateCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailview;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *valueLable;

@property (weak, nonatomic) IBOutlet UILabel *serialnumberLable;
//@property (weak, nonatomic) id controller;
//@property (weak, nonatomic) UITableView * tableview;

- (IBAction)showImage:(id)sender;

@end

