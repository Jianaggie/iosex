//
//  TemplateCell.m
//  Homepwner
//
//  Created by lovocas on 13-11-13.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "TemplateCell.h"

@implementation TemplateCell

@synthesize tableview,controller;
-(void)relayMethod:(SEL) message sender:(id)sender
{
    NSString * selector = NSStringFromSelector(message);
    selector=[selector stringByAppendingString:@"atIndex:"];
    SEL method = NSSelectorFromString(selector);
    NSIndexPath * path = [[self tableview] indexPathForCell:self];
    if([[self controller]respondsToSelector:method])
    {
        
        [[self controller] performSelector:method withObject:sender withObject:path];
    }
}
@end
