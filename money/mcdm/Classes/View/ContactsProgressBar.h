//
//  ProgressBar.h
//  MCDM
//
//  Created by Fred on 13-1-26.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsProgressBar : UIView
{
    UIImageView *_indicator;
    
    UIActivityIndicatorView *_activityIndicator;
    
    // for ASIProgressDelegate
    double _max;
}

- (id)initProgressBar:(NSString *)title;
- (void)setProgress:(float)progress;

// for ASIProgressDelegate
- (void)setDoubleValue:(double)newProgress;
- (void)setMaxValue:(double)newMax;

@end
