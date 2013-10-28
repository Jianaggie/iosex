//
//  photosViewController.h
//  photoDatabase
//
//  Created by lovocas on 13-6-23.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Photographer.h"
#import "Photo.h"

@interface photosViewController : CoreDataTableViewController
@property (nonatomic ,strong) Photographer * photographer ;
@end
