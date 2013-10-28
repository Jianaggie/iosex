//
//  AvertShowViewController.m
//  unuion03
//
//  Created by easystudio on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AvertShowViewController.h"


@implementation AvertShowViewController
@synthesize avertWebView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [avertWebView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//     NSString *text=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"------------------------数据%@",text);
//}

//- (void) loadView
//
//{
//    
//    self.view = avertWebView;
//    
//    [avertWebView release];
//    
//}


//加载 webView
-(void)loadAvertWebView{
//      NSURL *myurl=[NSURL URLWithString:@"yiapn://www.sina.com.cn"];
//       [[UIApplication sharedApplication] openURL:myurl];
    // webView = [[UIWebView alloc] initWithFrame:[[UIScreean mainScreen] applicationFrame]];
    
//[[UIScreen mainScreen] applicationFrame]
     avertWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0.1, 352.0, 325, 50)];
    [avertWebView setFrame:CGRectMake(0.1, 352.0, 325, 50)];
     [avertWebView setOpaque:NO];

    [avertWebView setBackgroundColor:[UIColor clearColor]];

    [avertWebView setDelegate:self];
    
    [avertWebView setScalesPageToFit:YES];
    //http://cyber-wise.com.cn:8007/pages/Ad/getAd.do
     NSString  *unionAvertHtmlURL=@"http://cyber-wise.com.cn:8007/pages/Ad/getAd.do";
   // NSString  *unionAvertHtmlURL=@"http://120.31.55.12:8007/pages/ApnSata/activeApn.do";
    NSURL *url = [[NSURL alloc]initWithString:unionAvertHtmlURL];
    //NSURLRequest *request =[[NSURLRequest alloc]initWithURL:url];
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
//    NSURLConnection *conn=[[NSURLConnection alloc]initWithRequest:request delegate:self];
//    [conn release];
     
    [avertWebView loadRequest:request];
    self.view = avertWebView;
    
    
    [UIView beginAnimations:@"movement" context:nil];
    //装载图片
    
    //动画  点击其他地方的时候不要动
    avertWebView.alpha=0;
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:avertWebView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:2.0f];
    [UIView setAnimationRepeatCount:50];
    [UIView setAnimationRepeatAutoreverses:YES];
    
    avertWebView.alpha=1;
    
    
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration: 2.0f];
//        [UIView setAnimationRepeatCount:50];
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:self.avertWebView cache:YES];
        
    
    [UIView commitAnimations];
    
//    [request release];
//    [url release];
    
    
//    NSString *pageSource = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    
//    NSLog(@"-----------neirong-----%@",pageSource);
    

    
    
//     NSString *path = [[NSBundle mainBundle]   pathForResource:@"avert" ofType:@"html"]; //得到文件的路径
//	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path]; //获得文件的句柄
//	NSData *data = [file readDataToEndOfFile];//得到xml文件 
//	[file closeFile];//获得后 关闭文件
//    
//    NSData* plistData = [file dataUsingEncoding:NSUTF8StringEncoding]; 
//    NSString *error; NSPropertyListFormat format; 
//    NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
//    //NSLog( @"plist is----------- %@", plist );
//    if(!plist){ NSLog(@"Error: %@",error); [error release];
//    }   
//    
//    
//    //保存到外网 
//    NSMutableString* aStr;
//    aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//    
//    
//    
//    NSString *resoucePath= [[NSBundle mainBundle]resourcePath];
//    NSString *filePath= [resoucePath stringByAppendingPathComponent:@"avert.html"];
//     NSString *htmlstring=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"neirong-------------%@",aStr);
//    
//    NSMutableString *newHTMLString = [aStr stringByAppendingString:@"<script language=\"javascript\">document.ontouchstart=function(){document.location=\"myweb:touch:start\";};document.ontouchend=function(){document.location=\"myweb:touch:end\";};document.ontouchmove=function(){document.location=\"myweb:touch:move\";}</script>"];
//                                  
//    
//        self.view = avertWebView;
//                                   
//                                   
//    
//  
//     [self.avertWebView loadHTMLString:newHTMLString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    
}
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
//    NSString *requestString=[[request URL] absoluteString];
//	NSArray *components = [requestString componentsSeparatedByString:@":"];
//	if([components count]>1 && [(NSString*)[components objectAtIndex:0] isEqualToString:@"myweb"]){
//        
//        if([(NSString*) [components objectAtIndex:1] isEqualToString:@"touch"])
//        {
//            NSLog(@"%@---------",[components objectAtIndex:2]);
//            
//                 NSURL *myurl=[NSURL URLWithString:@"http://www.sina.com.cn"];
//                 [[UIApplication sharedApplication] openURL:myurl];
//               
//        }
//        return NO;
//	}
//	return YES;
//}


-(void)loadAvertViewByThread{
    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc]init];
     [self performSelectorOnMainThread:@selector(loadAvertWebView) withObject:nil waitUntilDone:NO];
    
    //[self loadAvertWebView];
    [pool release];
    
}

 


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAvertWebView];
    
    // [NSThread detachNewThreadSelector:@selector(loadAvertViewByThread) toTarget:self withObject:nil];
   /* NSString  *unionAvertHtmlURL=@"www.baidu.com";
    NSURL *url = [[NSURL alloc]initWithString:unionAvertHtmlURL];
    NSURLRequest *request =[[NSURLRequest alloc]initWithURL:url];
    
    NSURLConnection *conn=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    [conn release];
    
     
    [request release];
    [url release];
    
    NSString *pageSource = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"-----------neirong2-----%@",pageSource);*/
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
