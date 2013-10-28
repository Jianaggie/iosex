//
//  HelpCells.h
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

// 新闻，应用
#define kNormalCellHeight 69

@interface NewsItemCell : UITableViewCell
{
    UIImageView *seperatorLine;
    
    DelayImageView *iconView;
}

@property (nonatomic,readonly) UIImageView *seperatorLine;
@property (nonatomic,readonly) DelayImageView *iconView;

- (id)initWithReuse:(NSString *)reuse;
- (void)setSeperatorLineImage:(UIImage *)line;

@end

@interface AppItemCell : UITableViewCell
{
    UIImageView *seperatorLine;
    
    DelayImageView *iconView;
}

@property (nonatomic,readonly) UIImageView *seperatorLine;
@property (nonatomic,readonly) DelayImageView *iconView;

- (id)initWithReuse:(NSString *)reuse;
- (void)setSeperatorLineImage:(UIImage *)line;

@end

@interface AppCatalogItemCell : UITableViewCell
{
    UIImageView *seperatorLine;
    
    DelayImageView *iconView;
}

@property (nonatomic,readonly) UIImageView *seperatorLine;
@property (nonatomic,readonly) DelayImageView *iconView;

- (id)initWithReuse:(NSString *)reuse;
- (void)setSeperatorLineImage:(UIImage *)line;

@end

@interface NotificationCell : UITableViewCell
{
    UIImageView *seperatorLine;
}

@property (nonatomic,readonly) UIImageView *seperatorLine;

- (id)initWithReuse:(NSString *)reuse;
- (void)setSeperatorLineImage:(UIImage *)line;

@end