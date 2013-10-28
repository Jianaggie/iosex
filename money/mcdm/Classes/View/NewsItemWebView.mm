//
//  NewsItemWebView.m
//  MCDM
//
//  Created by Fred on 13-1-12.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "NewsItemWebView.h"

@implementation NewsItemWebView

+ (UIScrollView *)getScrollViewOfWebView:(UIWebView *)webView
{
    UIScrollView *scrollView = nil;
    if (UIUtil::SystemVersion() >= 5.0)
    {
        scrollView = webView.scrollView;
    }
    else
    {
        for (UIView *subView in [webView subviews])
        {
            if ([subView isKindOfClass:[UIScrollView class]])
            {
                scrollView = (UIScrollView *)subView;
                break;
            }
        }
    }
    
    return scrollView;
}

- (id)initWithFrame:(CGRect)frame andItem:(NSDictionary *)item
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        
        _scrollView = [NewsItemWebView getScrollViewOfWebView:self];
        _scrollView.bounces = NO;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectZero];
        [_scrollView addSubview:topView];
        topView.backgroundColor = [UIColor whiteColor];
        [topView release];
        
        // Title
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        //titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.text = [item objectForKey:@"title"];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [topView addSubview:titleLabel];
        
        CGSize size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width - 20, 1000)];
        titleLabel.frame = CGRectMake(10, 10, self.frame.size.width - 20, size.height);
        
        // Author & Date
        UILabel *authorLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        //authorLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        authorLabel.text = [NSString stringWithFormat:@"%@  %@", [item objectForKey:@"publisher"], [item objectForKey:@"date"]];
        authorLabel.textColor = [UIColor darkGrayColor];
        authorLabel.backgroundColor = [UIColor clearColor];
        authorLabel.adjustsFontSizeToFitWidth = YES;
        [topView addSubview:authorLabel];
        
        authorLabel.frame = CGRectMake(10, 10 + titleLabel.frame.size.height, titleLabel.frame.size.width - 60, 30);
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellSepLine.png"]];
        line.contentMode = UIViewContentModeScaleToFill;
        [topView addSubview:[line autorelease]];
        
        line.frame = CGRectMake(10, authorLabel.frame.origin.y + authorLabel.frame.size.height, titleLabel.frame.size.width, 1);
        
        CGFloat headerHeight = CGRectGetMaxY(line.frame) + 10;
        
        // Image
        NSString *iconUrl = [item objectForKey:@"photosPath"];
        if ([iconUrl length])
        {
            DelayImageView *imageView = [[[DelayImageView alloc] initWithUrl:iconUrl frame:CGRectMake(0, 0, 320, 180)] autorelease];
            imageView.clipsToBounds = YES;
            [topView addSubview:imageView];
            
            CGFloat width = MIN(self.frame.size.width - 20, 320);
            CGFloat height = 160;//180;
            imageView.frame = CGRectMake((self.frame.size.width - width) / 2,
                                         authorLabel.frame.origin.y + authorLabel.frame.size.height + 10,
                                         width,
                                         height);
            
            headerHeight = CGRectGetMaxY(imageView.frame);
        }
        
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.top = headerHeight;
        _scrollView.contentInset = inset;
        
        CGRect topFrame = frame;
        topFrame.origin.x = 0;
        topFrame.size.height = headerHeight;
        topFrame.origin.y = -headerHeight;
        topView.frame = topFrame;
        
        NSString *html = [item objectForKey:@"bodys"];
        [self loadHTMLString:html baseURL:nil];
    }
    return self;
}

// UIWebViewDelegate <NSObject>
//
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (!_indicator)
    {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indicator];
        _indicator.center = self.center;
        [_indicator release];
    }
    
    [_indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicator stopAnimating];
    [_indicator removeFromSuperview];
    _indicator = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_indicator stopAnimating];
    [_indicator removeFromSuperview];
    _indicator = nil;
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
