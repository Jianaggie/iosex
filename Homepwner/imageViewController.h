//
//  imageViewController.h
//  Homepwner
//
//  Created by lovocas on 13-11-13.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageViewController : UIViewController<UIScrollViewDelegate>
{
    __weak IBOutlet UIScrollView *scrollview;
    
    __weak IBOutlet UIImageView *imageview;
}
@property (nonatomic ,strong) UIImage * image;

@end
