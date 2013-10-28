//
//  TopTabbar.h
//  MCDM
//
//  Created by Fred on 12-12-29.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTopTabbarHeight 33

@protocol TopTabbarDelegate <NSObject>

- (void)onSelectionChanged:(NSInteger)index;

@end

@interface TopTabbar : UIImageView
{
    UIView *_selectedMask;
    UIButton *_lastSelected;
    
    id <TopTabbarDelegate> _delegate;
}

@property (nonatomic, assign) id <TopTabbarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)setTitles:(NSArray *)titles;

@end
