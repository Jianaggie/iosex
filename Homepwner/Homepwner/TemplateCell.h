//
//  TemplateCell.h
//  Homepwner
//
//  Created by lovocas on 13-11-13.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateCell : UITableViewCell
@property (nonatomic,weak) id controller;
@property(nonatomic,weak)UITableView * tableview;
-(void)relayMethod:(SEL) message sender:(id)sender;

@end
