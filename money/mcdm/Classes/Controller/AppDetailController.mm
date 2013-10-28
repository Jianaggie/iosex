//
//  AppDetailController.m
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "AppDetailController.h"
#import "PredictScrollView.h"

@interface AppDetailController ()

@end

@implementation AppDetailController

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self)
    {
        _appInfo = [info retain];
    }
    return self;
}

- (void)dealloc
{
    [_appInfo release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:[scrollView autorelease]];
    
    DelayImageView *iconView = [[DelayImageView alloc] initWithFrame:CGRectMake(0, 0, 57, 57)];
    iconView.url = [_appInfo objectForKey:@"icon"];
    iconView.center = CGPointMake(15+57/2, 15+57/2);
    [scrollView addSubview:[iconView autorelease]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = [_appInfo objectForKey:@"name"];
    [label sizeToFit];
    label.frame = CGRectMake(CGRectGetMaxX(iconView.frame)+5, CGRectGetMinY(iconView.frame), label.frame.size.width, label.frame.size.height);
    [scrollView addSubview:[label autorelease]];
    
    UIImage *normal = [UIImage imageNamed:@"Install.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setTitle:@"安装" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(onInstall) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, normal.size.width, normal.size.height);
    
    button.center = CGPointMake(self.view.frame.size.width-button.frame.size.width/2-16, CGRectGetMaxY(iconView.frame)-button.frame.size.height/2);
    [scrollView addSubview:button];
    
    CGFloat tempY = 0;
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"内容提要";
        [label sizeToFit];
        label.frame = CGRectMake(CGRectGetMinX(iconView.frame), CGRectGetMaxY(iconView.frame)+10, label.frame.size.width, label.frame.size.height);
        [scrollView addSubview:[label autorelease]];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectZero];
        desc.textColor = [UIColor blackColor];
        desc.font = [UIFont systemFontOfSize:16];
        desc.text = [_appInfo objectForKey:@"description"];
        desc.numberOfLines = 0;
        CGSize size = [desc.text sizeWithFont:desc.font constrainedToSize:CGSizeMake(self.view.frame.size.width - 20, 1000)];
        desc.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame), self.view.frame.size.width - 20, size.height);
        
        [scrollView addSubview:[desc autorelease]];
        
        tempY = CGRectGetMaxY(desc.frame);
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"软件截图";
        [label sizeToFit];
        label.frame = CGRectMake(CGRectGetMinX(iconView.frame), tempY+20, label.frame.size.width, label.frame.size.height);
        [scrollView addSubview:[label autorelease]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppBackground.png"]];
        imageView.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+10, imageView.frame.size.width, imageView.frame.size.height);
        
        if (UIUtil::IsPad())
        {
            imageView.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+10, 738, 985);
        }
        
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:[imageView autorelease]];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(imageView.frame)+10);
        
        NSArray *screenShotUrls = [_appInfo objectForKey:@"screenShotUrls"];
        if ([screenShotUrls count])
        {
            CGRect frame = imageView.frame;
            frame.origin.y = frame.origin.x = 0;
            
            frame = CGRectInset(frame, 10, 10);
            
            PredictScrollView *pages = [[PageControlScrollView alloc] initWithFrame:frame];
            pages.delegate2 = self;
            pages.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            pages.showsVerticalScrollIndicator = NO;
            pages.showsHorizontalScrollIndicator = NO;
            pages.bounces = NO;
            pages.backgroundColor = [UIColor clearColor];
            [imageView addSubview:pages];
            [pages release];
            
            pages.numberOfPages = [screenShotUrls count];
            pages.currentPage = 0;
                        
            ((PageControlScrollView *)pages).pageCtrl.hidesForSinglePage = YES;
            
            pages.center = CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2);
        }
    }
}

//
- (UIView *)scrollView:(PredictScrollView *)scrollView viewForPage:(NSUInteger)index inFrame:(CGRect)frame
{
    NSArray *screenShotUrls = [_appInfo objectForKey:@"screenShotUrls"];
	NSString *url = [screenShotUrls objectAtIndex:index];
    
    // if no xib, create it by code.
    {
        // Create page view for image content
        DelayImageView *view  = [[DelayImageView alloc] initWithFrame:frame];
        view.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleToFill;
        view.clipsToBounds = YES;
        
        view.url = url;
        
        return [view autorelease];
    }
}

//
- (void)scrollView:(PredictScrollView *)scrollView scrollToPage:(NSUInteger)index
{
}

- (void)onInstall
{
    UIUtil::OpenURL([_appInfo objectForKey:@"address"]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"应用简介";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
