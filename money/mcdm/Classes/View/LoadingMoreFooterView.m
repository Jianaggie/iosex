//
//  LoadingMoreFooterView.m
//  Miu Ptt
//
//  Created by Xingzhi Cheng on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingMoreFooterView.h"

@interface LoadingMoreFooterView()
@property(nonatomic, retain) UILabel * textLabel;
@property(nonatomic, retain) UIActivityIndicatorView * activityView;
@property(nonatomic, readwrite) CGRect savedFrame;
@end

@implementation LoadingMoreFooterView
@synthesize textLabel = _textLabel;
@synthesize activityView = _activityView;
@synthesize showActivityIndicator = _showActivityIndicator;
@synthesize refreshing = _refreshing;
@synthesize enabled = _enabled;
@synthesize savedFrame = _savedFrame;


- (void) dealloc {
    self.textLabel = nil;
    self.activityView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showActivityIndicator = NO;
        self.enabled = YES;
        self.refreshing = NO;
        self.backgroundColor = [UIColor clearColor];
        self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.text = @"没有更多了";
        self.textLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.textLabel];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        _activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        self.activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height / 2);
        self.activityView.hidesWhenStopped = YES;
        [self addSubview:self.activityView];

    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    self.savedFrame = frame;
    [super setFrame:frame];
}

- (void) setTextAlignment:(UITextAlignment)textAlignment {
    self.textLabel.textAlignment = textAlignment;
}

- (UITextAlignment) textAlignment {
    return self.textAlignment;
}

- (void) setShowActivityIndicator:(BOOL)showActivityIndicator {
    _showActivityIndicator = showActivityIndicator;
    if (showActivityIndicator )
    {
     [self.activityView startAnimating];
    }
    else if (!showActivityIndicator)
    {
        [self.activityView stopAnimating];
    }
}

- (void) setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (enabled)
    {
        [super setFrame:self.savedFrame];
        [self.activityView startAnimating];
        self.textLabel.hidden = YES;
    }
    else {
        [super setFrame:CGRectZero];
        [self.activityView stopAnimating];
        self.textLabel.hidden = NO;

    }
}

@end
