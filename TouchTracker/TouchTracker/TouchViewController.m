//
//  TouchViewController.m
//  TouchTracker
//
//  Created by lovocas on 13-11-25.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"
@implementation TouchViewController
@synthesize myview;
-(id)init{
    self =[super init];
    if(self)
    {
        self.myview=[[TouchDrawView alloc]initWithFrame:CGRectZero];
    }
    return self;
}

-(void)loadView
{
    [self setView:self.myview];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.myview saveChanges];
}
@end
