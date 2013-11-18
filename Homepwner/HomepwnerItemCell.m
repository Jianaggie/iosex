//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by lovocas on 13-11-7.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell
@synthesize thumbnailview,nameLable,serialnumberLable,valueLable;



- (IBAction)showImage:(id)sender {
    
    /*
    NSString * selector = NSStringFromSelector(_cmd);
    selector=[selector stringByAppendingString:@"atIndex:"];
    SEL method = NSSelectorFromString(selector);
     NSIndexPath * path = [[self tableview] indexPathForCell:self];
    if([[self controller]respondsToSelector:method])
    {
   
        [[self controller] performSelector:method withObject:sender withObject:path];
    }*/
    
    [self relayMethod:_cmd sender:sender];
}

@end
