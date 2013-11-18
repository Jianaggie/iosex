//
//  imageViewController.m
//  Homepwner
//
//  Created by lovocas on 13-11-13.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "imageViewController.h"

@interface imageViewController ()

@end

@implementation imageViewController
@synthesize image;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGSize sz =[[self image] size];
    [scrollview setContentSize:sz];
    [imageview setFrame:CGRectMake(0, 0, sz.width, sz.height)];
    [imageview setImage:image];
    
    
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageview;
}
@end
