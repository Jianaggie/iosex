//
//  TopTabbar.m
//  MCDM
//
//  Created by Fred on 12-12-29.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "TopTabbar.h"

#define kTopTabbarButtonStartTag 3000

@implementation TopTabbar

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.image = [UIImage imageNamed:@"TopbarBackground.png"];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    if (![titles count])
    {
        return;
    }
    
    [self removeSubviews];
    
    /*
    CGRect lineFrame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    UIImageView *line = [[UIImageView alloc] initWithFrame:lineFrame];
    line.image = [UIImage imageNamed:@"TopbarLine.png"];
    [self addSubview:line];
    [line release];*/
    
    CGRect itemFrame = self.frame;
    itemFrame.size.width = (self.frame.size.width) / [titles count];
    
    for (int i = 0; i < [titles count]; ++i)
    {
        NSString *title = [titles objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[@"#bfd2e9" toUIColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        CGRect frame = itemFrame;
        frame.origin.x += itemFrame.size.width*i;
        
        button.frame = frame;
        button.tag = kTopTabbarButtonStartTag+i;
        [self addSubview:button];
        
        [button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0)
        {
            _lastSelected = button;
            _lastSelected.selected = YES;
        }
    }
    
    _selectedMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopbarArrow.png"]];
    [self addSubview:_selectedMask];
    _selectedMask.center = CGPointMake(itemFrame.size.width/2, itemFrame.size.height-_selectedMask.frame.size.height/2-2);
    [_selectedMask release];
}

- (void)onButtonTapped:(UIButton *)sender
{
    if (sender == _lastSelected)
    {
        return;
    }
    
    _lastSelected.selected = NO;
    _lastSelected = sender;
    _lastSelected.selected = YES;
    
    [UIView beginAnimations:nil context:nil];
    //_selectedMask.center = _lastSelected.center;
    _selectedMask.center = CGPointMake(_lastSelected.center.x, _lastSelected.frame.size.height-_selectedMask.frame.size.height/2-2);
    [UIView commitAnimations];
    
    if ([_delegate respondsToSelector:@selector(onSelectionChanged:)])
    {
        [_delegate onSelectionChanged:sender.tag-kTopTabbarButtonStartTag];
    }
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
