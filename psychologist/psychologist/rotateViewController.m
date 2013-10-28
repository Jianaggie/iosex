//
//  rotateViewController.m
//  psychologist
//
//  Created by lovocas on 13-5-26.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "rotateViewController.h"
#import "happinessViewController.h"
@interface rotateViewController ()

@end

@implementation rotateViewController
-(void)awakeFromNib{
    [super awakeFromNib];
    [self splitViewController] .delegate =self;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
-(happinessViewController *) detailedControlComfortProtocol{
    id hvc = [self.splitViewController.viewControllers lastObject];
    if(![hvc isKindOfClass:[happinessViewController class]])
        hvc = nil;
    return  hvc;
    
}
-(BOOL)splitViewController:(UISplitViewController *)svc
    shouldHideViewController:(UIViewController *)vc
             inOrientation:(UIInterfaceOrientation)orientation{
    return ([self detailedControlComfortProtocol]!= nil)? UIInterfaceOrientationIsPortrait(orientation) : NO;
}
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    if([self detailedControlComfortProtocol]){
        [self detailedControlComfortProtocol].spiltBarButtonItem.title= self.title;
        [self detailedControlComfortProtocol].spiltBarButtonItem = barButtonItem;
}
    //set the barbutton
}
-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    //set the barbuttonItem
   if([self detailedControlComfortProtocol]){
        [self detailedControlComfortProtocol].spiltBarButtonItem = nil;
    }

}
@end
