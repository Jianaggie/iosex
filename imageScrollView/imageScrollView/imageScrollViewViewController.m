//
//  imageScrollViewViewController.m
//  imageScrollView
//
//  Created by lovocas on 13-5-29.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "imageScrollViewViewController.h"

@interface imageScrollViewViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation imageScrollViewViewController 

@synthesize scrollView= _scrollView;
@synthesize imageView =_imageView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.scrollView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
