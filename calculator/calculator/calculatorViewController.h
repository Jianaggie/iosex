//
//  calculatorViewController.h
//  calculator
//
//  Created by lovocas on 13-5-9.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calculatorModel.h"

@interface calculatorViewController : UIViewController


@property (nonatomic,weak) IBOutlet UILabel *display;
@property (nonatomic,strong) calculatorModel *model;
@end
