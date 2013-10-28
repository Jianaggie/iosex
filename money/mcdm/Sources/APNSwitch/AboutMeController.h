//
//  AboutMeController.h
//  unuion03
//
// 操作说明类
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServer.h"

@interface AboutMeController : UIViewController {
    UIScrollView *scrollView;
    
    UILabel *labeltitle;
    UILabel *labeltitle2;
    UILabel *labeltitle3;
    UILabel *option1;
    UILabel *option2;
    UILabel *option3;
    UILabel *option4;
    UILabel *option5;
    UILabel *option6;
    UILabel *option7;
    UILabel *option8;
    UILabel *option9;
    
    
    UIImageView *img_option1;
    UIImageView *img_option2;
    UIImageView *img_option3;
    UIImageView *img_option4;
    UIImageView *img_option5;
    UIImageView *img_option6;
    UIImageView *img_option7;
    UIImageView *img_option8;

}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
////测试修改文件
//-(IBAction)updateConfigFile;
//
//-(IBAction)openInternetFile;//打开公网
//-(IBAction)openIntrantFile;//打开内网
//导航到zhuye
-(IBAction)backMainView;
@end
