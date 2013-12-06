//
//  webViewController.h
//  Nerdfeed
//
//  Created by lovocas on 13-11-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "listViewController.h"

@interface webViewController : UIViewController <listViewControllerDelegator,UISplitViewControllerDelegate>
@property (nonatomic ,readonly)UIWebView * webview;
//@property (weak, nonatomic) IBOutlet UIWebView *webview;
//- (IBAction)goWebBack:(id)sender;
//- (IBAction)goWebForward:(id)sender;
@end
