//
//  listViewController.h
//  Nerdfeed
//
//  Created by lovocas on 13-11-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSChannel.h"
#import  "predefine.h"
typedef enum
{
    listViewControllerRSSFeed,
    listViewControllerRSSApple
}listViewControllerRSSType;

@class webViewController;
@interface listViewController : UITableViewController <NSURLConnectionDataDelegate,NSXMLParserDelegate>
{
  //  NSURLConnection * conn;
    //NSMutableData * xmldata;
    listViewControllerRSSType  rssType;
}
@property (nonatomic,strong)RSChannel * channel;
@property (nonatomic,strong)webViewController * webView;
//@property (nonatomic,strong)UIBarButtonItem * button;
-(void)fetchEntries;
-(void)showInfo:(id)sender;
@end
@protocol listViewControllerDelegator <NSObject>

-(void)listViewController:(listViewController *)lvc handledObject:(id)object;

@end