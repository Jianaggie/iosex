//
//  photoGrapherControllerViewController.h
//  photoDatabase
//
//  Created by lovocas on 13-6-23.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface photoGrapherControllerViewController : CoreDataTableViewController
@property  (nonatomic,strong )UIManagedDocument * photoDatabaseDocument;
@end
