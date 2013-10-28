//
//  NewsItemWebView.h
//  MCDM
//
//  Created by Fred on 13-1-12.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsItemWebView : UIWebView <UIWebViewDelegate>
{
    UIScrollView *_scrollView;
    UIActivityIndicatorView *_indicator;
}

- (id)initWithFrame:(CGRect)frame andItem:(NSDictionary *)item;

@end
