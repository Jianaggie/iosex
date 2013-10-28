//
//  MessageView.m
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "MessageView.h"
#import "DataLoader.h"

@implementation MessageView

@synthesize button=_button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {        
        UIImage *buttonImage = [UIImage imageNamed:@"Notification.png"];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:buttonImage forState:UIControlStateNormal];
        _button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        _button.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:_button];
        
        _numBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NumBackground.png"]];
        _numBackground.center = CGPointMake(CGRectGetMaxX(_button.frame), CGRectGetMinY(_button.frame));
        [self addSubview:[_numBackground autorelease]];
        _numBackground.hidden = YES;
        
        _notificationCountLabel = [[UILabel alloc] init];
        _notificationCountLabel.font = [UIFont boldSystemFontOfSize:8];
        _notificationCountLabel.textColor = [UIColor whiteColor];
        _notificationCountLabel.textAlignment = UITextAlignmentCenter;
        
        _notificationCountLabel.text = @"";
        [_notificationCountLabel sizeToFit];
        _notificationCountLabel.center = CGPointMake(_numBackground.center.x-1, _numBackground.center.y-1);
        _notificationCountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:[_notificationCountLabel autorelease]];
        
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

+ (id)messageView
{
    return [[[MessageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] autorelease];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self onGetNotificationList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetNotificationList) name:kGetNotificationListNotification object:nil];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGetNotificationListNotification object:nil];
}

- (void)onGetNotificationList
{
    _Log(@"onGetNotificationList");
    
    // TODO:
    int count = 0;//[[DataLoader loader].notificationArray count];
    for (NSDictionary *dict in [DataLoader loader].notificationArray)
    {
        NSString *stringId = [dict objectForKey:@"id"];
        if (![DataLoader hasReadNotification:stringId])
        {
            ++count;
        }
    }
    
    _notificationCountLabel.text = count ? [NSString stringWithFormat:@"%d", count] : @"";
    [_notificationCountLabel sizeToFit];
    _notificationCountLabel.center = CGPointMake(_numBackground.center.x-1, _numBackground.center.y-1);
    _numBackground.hidden = (count==0);
    
    [self setNeedsLayout];
}

@end
