//
//  ViewController.m
//  hello
//
//  Created by lovocas on 13-5-7.
//  Copyright (c) 2013年 lovocas. All rights reserved.
//2

#import "ViewController.h"


@implementation ViewController
@synthesize display = _display;

- (IBAction)digitPressed:(UIButton *)sender {
    NSLog(@"dddddd");
    //check the 
    NSString *digits;
    if ([@"0" isEqualToString:self.display.text]) {
        digits = @"";
    }
    else {
        digits = self.display.text;
    }
    self.display.text = [digits stringByAppendingString:sender.currentTitle];
//    
//    NSString *digit =  [sender currentTitle];
//    
//    
//    UILabel *myDisplay = self.display; //[self display]
//    NSLog(@"digit pressed = %@", digit);
//    NSString *currentText = myDisplay.text;
//    NSString *newText = [currentText stringByAppendingString:digit];
////    [myDisplay setText:newText];
//    myDisplay.text = newText;
}


@end
