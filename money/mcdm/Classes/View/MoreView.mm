//
//  MoreView.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "MoreView.h"

@implementation MoreView

@synthesize aboutButton=_aboutButton, settingButton=_settingButton, apnButton=_apnButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3f];
        
        CGFloat startY = frame.size.height-34-34-42;
        CGFloat startX = frame.size.width-114-10;
        
        // 关于
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"AboutCell.png"] forState:UIControlStateNormal];
            CGRect buttonFrame = CGRectMake(startX, startY, 114, 34);
            button.frame = buttonFrame;
            [self addSubview:button];
            
            startY += 34;
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"About.png"]];
            icon.center = CGPointMake(30, 17);
            [button addSubview:[icon autorelease]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = @"关于";
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            [label sizeToFit];
            label.center = CGPointMake(65, 17);
            [button addSubview:[label autorelease]];
            
            _aboutButton = button;
        }
        
        /*/ apn
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"AboutCell.png"] forState:UIControlStateNormal];
            CGRect buttonFrame = CGRectMake(startX, startY, 114, 34);
            button.frame = buttonFrame;
            [self addSubview:button];
            
            startY += 34;
            
            // ForAPN:图标可以在这里换掉
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-Small.png"]];
            icon.center = CGPointMake(30, 17);
            [button addSubview:[icon autorelease]];
            
            // ForAPN:这里可以修改菜单中的名字
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = @"易APN";
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            [label sizeToFit];
            label.center = CGPointMake(65, 17);
            [button addSubview:[label autorelease]];
            
            _apnButton = button;
        }*/
        
        // 设置
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"SettingCell.png"] forState:UIControlStateNormal];
            CGRect buttonFrame = CGRectMake(startX, startY, 114, 42);
            
            button.frame = buttonFrame;
            [self addSubview:button];
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Setting.png"]];
            icon.center = CGPointMake(30, 17);
            [button addSubview:[icon autorelease]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = @"设置";
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            [label sizeToFit];
            label.center = CGPointMake(65, 17);
            [button addSubview:[label autorelease]];
            
            _settingButton = button;
        }
        
        {
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY-34, 114, 1)];
            lineView.image = [UIImage imageNamed:@"AboutLine.png"];
            [self addSubview:[lineView autorelease]];
        }
        
        {
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, 114, 1)];
            lineView.image = [UIImage imageNamed:@"AboutLine.png"];
            [self addSubview:[lineView autorelease]];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
