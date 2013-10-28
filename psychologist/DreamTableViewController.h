//
//  DreamTableViewController.h
//  psychologist
//
//  Created by lovocas on 13-5-31.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DreamTableViewController;

@protocol showFaceDelegate
-(void)showHappiness:(int)happiness Face:(DreamTableViewController *)sender;

@end

@interface DreamTableViewController : UITableViewController
@property (nonatomic,strong) NSArray* dreamlist;
@property (nonatomic,weak) id<showFaceDelegate>  dreamdelegate;

@end
