//
//  ProgressBar.m
//  MCDM
//
//  Created by Fred on 13-1-26.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "ContactsProgressBar.h"
#import <QuartzCore/QuartzCore.h>
#import "Defines.h"

@implementation ContactsProgressBar

- (id)initProgressBar:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 60)];
    if (self)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel sizeToFit];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        [titleLabel release];
        titleLabel.center = CGPointMake(100, 4);
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_activityIndicator];
        _activityIndicator.center = CGPointMake(100, 30);
        [_activityIndicator release];
        [_activityIndicator startAnimating];
        
        _max = 100.f;
        
        UIView *progressBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 200, 15)];
        
        progressBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        progressBackground.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:progressBackground];
        [progressBackground release];
        
        _indicator = [[UIImageView alloc] initWithFrame:CGRectZero];
        _indicator.backgroundColor = [@"#0e1527" toUIColor];
        
        [progressBackground addSubview:[_indicator autorelease]];
    }
    return self;
}

- (void)setProgress:(float)progress
{
    CGRect frame = CGRectMake(0, 0, 200, 15);
    
    frame.size.width *= progress;
    _indicator.frame = frame;
}

// for ASIProgressDelegate
- (void)setDoubleValue:(double)newProgress
{
    [self setProgress:newProgress/_max];
}

- (void)setMaxValue:(double)newMax
{
    _max = newMax;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProgressChanged:) name:kContactProgressNotification object:nil];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kContactProgressNotification object:nil];
}

- (void)onProgressChanged:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    [self setDoubleValue:[[dict objectForKey:kContactProgressKey] intValue]];
}

@end
