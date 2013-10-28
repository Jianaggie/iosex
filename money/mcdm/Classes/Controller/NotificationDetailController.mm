//
//  NotificationDetailController.m
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "NotificationDetailController.h"
#import "DataLoader.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
#import "NewsItemView.h"
#import "NewsItem.h"

@interface NotificationDetailController ()

@end

@implementation NotificationDetailController

- (id)initWithId:(NSString *)notificationId
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        _notificationId = [notificationId retain];
    }
    return self;
}

- (void)dealloc
{
    [[DataLoader loader] closeTaskWithType:Task_GetNotificationDetails];
    
    [_surveyid release];
    [_notificationId release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"通知公告";
    
    [[DataLoader loader] getNotificationDetails:self andNotificationId:_notificationId];
    [DataLoader setReadNotification:_notificationId];
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

// TaskDelegate <NSObject>
- (void)taskStarted:(TaskType)type
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)taskFinished:(TaskType)type result:(id)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([result isKindOfClass:[NSError class]])
    {
        MBProgressHUD *show = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        show.mode = MBProgressHUDModeText;
        show.labelText = [(NSError *)result localizedDescription];
        [show hide:YES afterDelay:2];
        //[self.view makeToast:[(NSError *)result localizedDescription] duration:0.5 position:@"center"];
    }
    else
    {
        [self.view removeSubviews];
        
        NSDictionary *dict = (NSDictionary *)result;
        
        NewsItem *item = [[NewsItem alloc] init];
        item.title = [dict objectForKey:@"title"];
        item.description = [dict objectForKey:@"body"];
        item.source = [dict objectForKey:@"origin"];
        item.pubDate = [dict objectForKey:@"date"];
        item.iconUrl = nil;
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        NewsItemView *view = [[NewsItemView alloc] initWithItem:item frame:frame];
        view.fontSize = 14.f;
        [self.view addSubview:view];
        [view release];
        
        [_surveyid release];
        _surveyid = [[dict objectForKey:@"surveyid"] retain];
        if ([_surveyid length])
        {
            UIImage *normal = [UIImage imageNamed:@"Test.png"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:normal forState:UIControlStateNormal];
            [button setTitle:@"开始调查" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(onTest) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, normal.size.width, normal.size.height);
            
            button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-60);
            [self.view addSubview:button];
        }
    }
}

- (void)onTest
{
    NSString *url = [DataLoader getSurveyUrl:_surveyid];
    
    if (url)
    {
        UIUtil::OpenURL(url);
    }
}

@end
