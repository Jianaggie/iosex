//
//  NavigationController.m
//  Homepwner
//
//  Created by lovocas on 13-11-6.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

-(BOOL)shouldAutorotate
{
    if([[UIDevice currentDevice]userInterfaceIdiom ]==UIUserInterfaceIdiomPad)
        return YES;
    else
        return NO;
        //return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else
         return UIInterfaceOrientationMaskPortrait;
        //return UIInterfaceOrientationMaskAll;
    
}
@end
