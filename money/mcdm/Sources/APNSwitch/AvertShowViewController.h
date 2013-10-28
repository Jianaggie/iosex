//
//  AvertShowViewController.h
//  unuion03
//
//  Created by easystudio on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AvertShowViewController : UIViewController<UIWebViewDelegate> {
    UIWebView *avertWebView;//加载广告的web
}
@property (nonatomic,retain) IBOutlet UIWebView *avertWebView;
@end
