//
//  calculatorViewController.m
//  calculator
//
//  Created by lovocas on 13-5-9.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "calculatorViewController.h"


@interface calculatorViewController ()


@end

@implementation calculatorViewController

@synthesize display = _display;
bool numberIsEnd  = YES;
@synthesize model = _model;

- (IBAction)NumberButtonDown:(UIButton *)sender {
    //get the number
    NSString *  number = sender.currentTitle;
    //append the nubmber to the title of lable
    if(!numberIsEnd)
    {
        _display.text = [_display.text stringByAppendingString:number];
    }
    else{
        _display.text = number;
        numberIsEnd = NO;
    }
    
}

-(calculatorModel *) model
{
    if(_model == nil){
        _model = [[calculatorModel alloc]init];
    }
    return _model;
}

- (IBAction)OperationButtonDown:(UIButton *)sender {
    if(!numberIsEnd)[self EnterButtonDown];
    double result= [self.model performOperation:sender.currentTitle];
    _display.text = [NSString stringWithFormat:@"%g",result ];
   
   // numberIsEnd = YES;

    
}

- (IBAction)EnterButtonDown {
    NSString * number = number = _display.text;
    
    NSLog(@"the number is %@",number);
    [self.model pushNumber:[NSNumber numberWithInt:[number intValue]]];
    numberIsEnd = YES;
}

/*- (IBAction)EnterButtonDown {
    
    NSString * number = _display.text;
    [self.model pushNumber: number];
    numberIsEnd = YES;
    
}*/

@end
 