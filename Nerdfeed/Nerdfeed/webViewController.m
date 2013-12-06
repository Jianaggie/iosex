//
//  webViewController.m
//  Nerdfeed
//
//  Created by lovocas on 13-11-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "webViewController.h"

@implementation webViewController
-(id)init
{
    //self =[super initWithNibName:@"webView" bundle:nil];
    self =[super init];
    if (self) {
        /*UIBarButtonItem* left =[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goWebBack:)];
        UIBarButtonItem* right =[[UIBarButtonItem alloc]initWithTitle:@"Forward" style:UIBarButtonItemStylePlain target:self action:@selector(goWebForward:)];
        self.navigationItem.leftBarButtonItem=left;
        self.navigationItem.rightBarButtonItem =right;*/
       
        
    }
    
    return self;
}
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"list"];
    self.navigationItem.leftBarButtonItem =barButtonItem;
}
-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if(barButtonItem == self.navigationItem.leftBarButtonItem)
       [self.navigationItem setLeftBarButtonItem:nil];
}
-(void)listViewController:(listViewController *)lvc handledObject:(id)object
{
    RSItem * entry = object;
    if(![object isKindOfClass:[RSItem class] ])
    {
        return;
    }
    NSString * url=[object link];
    NSURL * reqUrl=[NSURL URLWithString:url];
    NSURLRequest * req =[NSURLRequest requestWithURL:reqUrl];
    
    //self.webView =wv;
    [self.webview loadRequest:req];
    [self.navigationItem setTitle:[entry title]];
}
-(BOOL)shouldAutorotate
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        return YES;
    return  NO;
}

/*-(IBAction)goWebBack:(id)sender
{
    [self.webview goBack];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.webview setContentMode:UIViewContentModeScaleAspectFit];
}
-(IBAction)goWebForward:(id)sender
{
    [self.webview goForward];
}*/
-(void)loadView
{
    [super loadView];
    CGRect frame =[[UIScreen mainScreen]applicationFrame];
    UIWebView * webv =[[UIWebView alloc]initWithFrame:frame];
    [webv setScalesPageToFit:YES];
    self.view =webv;
    //NSLog(@"hi");
    
}
-(UIWebView *)webview
{
    return (UIWebView *)self.view;
}



@end
