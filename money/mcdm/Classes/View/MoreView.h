//
//  MoreView.h
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

#import"TouchImageView.h"

@interface MoreView : TouchImageView
{
    UIButton *_aboutButton;
    UIButton *_settingButton;
    UIButton *_apnButton;
}

@property (nonatomic, readonly) UIButton *aboutButton;
@property (nonatomic, readonly) UIButton *settingButton;
@property (nonatomic, readonly) UIButton *apnButton;

@end
