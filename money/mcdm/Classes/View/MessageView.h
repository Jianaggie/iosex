//
//  MessageView.h
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView
{
    UIButton *_button;
    UILabel *_notificationCountLabel;
    UIImageView *_numBackground;
}

@property (nonatomic, readonly) UIButton *button;

+ (id)messageView;

@end
