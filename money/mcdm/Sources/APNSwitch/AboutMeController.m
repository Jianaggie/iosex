//
//  AboutMeController.m
//  unuion03
//
//  Created by MagicStudio on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutMeController.h"
//#import "mcdmAppDelegate.h"

@implementation AboutMeController
@synthesize scrollView;
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
    [super dealloc];
    
         
     [labeltitle release];
     [labeltitle2 release];
     [labeltitle3 release];
     [option1 release];
     [option2 release];
     [option3 release];
     [option4 release];
     [option5 release];
     [option6 release];
     [option7 release];
     [option8 release];
     [option9 release];
     [img_option1 release];
     [img_option2 release];
     [img_option3 release];
     [img_option4 release];
     [img_option5 release];
     [img_option6 release];
     [img_option7 release];
     [img_option8 release];
     [scrollView release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//启动程序后，点击“公网”或“专网”即可进行具体操作。
//1、添加APN，点击左上角的“＋”图标进入。APN(必填项),其它几项都可不填，如描述、用户、密码；
//2、删除，点击右上角的Edit按钮即进入删除页面，点击 “删除”即可；
//3、点击表格行后面Switch按钮后，界面上会出现一个安装页面，你点击“安装”
//就可以切换APN了；
//
//
//常见问题，如果在安装描述文件的时候提示：“只能安装一个APN设置”，请在“设置”->通用－>描述文件->配置文件中找到以前配置的APN文件，点击“移除”即可。


-(void)viewDidLoad{
//      self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backMainView)];
    
    //加一个 返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backimg= [UIImage imageNamed:@"BackIcon.png"];
    [leftbutton setImage:[UIImage imageNamed:@"BackIcon.png"] forState:UIControlStateNormal];
    leftbutton.frame=CGRectMake(0, 0, backimg.size.width, backimg.size.height);
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    [leftbutton addTarget:self action:@selector(backMainView) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.title=@"操作说明";
    // self.navigationController.navigationBar.tintColor=[UIColor redColor];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 1, scrollView.frame.size.height+2360);
    scrollView.scrollEnabled=true;
    //标题1
    labeltitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 250, 50)];
    
    
    //[labeltest removeFromSuperview];
    [labeltitle setBackgroundColor:[UIColor clearColor]];
    [labeltitle setTextColor:[UIColor whiteColor]];
    
    labeltitle.textAlignment = UITextAlignmentCenter;
    // labeltest.lineBreakMode=[UI
    
    labeltitle.font = [UIFont boldSystemFontOfSize:23];
    labeltitle.text=@"中国联通广东分公司";
    labeltitle.numberOfLines=0;//自动换行
    labeltitle.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:labeltitle]; 
    
    //标题2
    labeltitle2 = [[UILabel alloc] initWithFrame:CGRectMake(25,90, 250, 50)];
    //[labeltest removeFromSuperview];
    [labeltitle2 setBackgroundColor:[UIColor clearColor]];
    [labeltitle2 setTextColor:[UIColor whiteColor]];
    
    labeltitle2.textAlignment = UITextAlignmentCenter;
    // labeltest.lineBreakMode=[UI
    
    labeltitle2.font = [UIFont systemFontOfSize:17];
    labeltitle2.text=@"易APN—使用说明";
    labeltitle2.numberOfLines=0;//自动换行
    labeltitle2.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:labeltitle2]; 
    
    //标题3
    labeltitle3 = [[UILabel alloc] initWithFrame:CGRectMake(10,100, 300, 200)];
    //[labeltest removeFromSuperview];
    [labeltitle3 setBackgroundColor:[UIColor clearColor]];
    [labeltitle3 setTextColor:[UIColor whiteColor]];
    
    labeltitle3.textAlignment = UITextAlignmentLeft;
    // labeltest.lineBreakMode=[UI
    
    labeltitle3.font = [UIFont systemFontOfSize:17];
    labeltitle3.text=@"该产品属于广东联通“企业移动终端管家”产品系列下的一个子产品，它可以让您很快捷地在多个APN之间进行切换，免去了每次通过连接电脑修改APN的繁琐工作。以下是该程序的具体使用步骤：";
    labeltitle3.numberOfLines=0;//自动换行
    labeltitle3.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:labeltitle3]; 
    
    
    //操作1
    option1 = [[UILabel alloc] initWithFrame:CGRectMake(10,240, 300, 100)];
    //[labeltest removeFromSuperview];
    [option1 setBackgroundColor:[UIColor clearColor]];
    [option1 setTextColor:[UIColor whiteColor]];
    option1.textAlignment = UITextAlignmentLeft;
    option1.font = [UIFont systemFontOfSize:17];
    option1.text=@"1、启动程序后，用手指向左滑动可以查看设备信息，点击主页中间部分（齿轮）即可进行具体操作；";
    option1.numberOfLines=0;//自动换行
    option1.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:option1]; 
    
    //操作1_图片1
    UIImage *imgleftSeting=[UIImage imageNamed:@"mainOption.png"];
    img_option1 =[ [UIImageView alloc] initWithImage:imgleftSeting] ;
    //img_option1 =[UIImage imageNamed:@"internet_button.png"] ;
    [img_option1 setFrame:CGRectMake(40.0,325.0, imgleftSeting.size.width-20, imgleftSeting.size.height)];
    [self.scrollView   addSubview:img_option1];
    
//    2、参数配置页面中包括公网和专网两部分，在公网设置中，填入公网APN(如联通3gnet或联通3gwap),填入相应的用户名和密码，如无用户名和密码，可留空；同理，在专网设置中，分别填入专有APN、用户名及密码，如无用户名和密码，可留空。点击完成按钮即完成设置(见下图)；
    
    
    //操作2
    option2 = [[UILabel alloc] initWithFrame:CGRectMake(10,380, 300, 120)];
    //[labeltest removeFromSuperview];
    [option2 setBackgroundColor:[UIColor clearColor]];
    [option2 setTextColor:[UIColor whiteColor]];
    option2.textAlignment = UITextAlignmentLeft;
    option2.font = [UIFont systemFontOfSize:17];
    option2.text=@"2、进入“APN设置”页面后，点击APN设置下方的“公网”或“专网”按钮分别显示相应的apn列表界面(见下图)，然后点击列表下方的“新建APN”图标分别增加公网、专网APN；";
    option2.numberOfLines=0;//自动换行
    option2.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:option2]; 
    //操作2_图片2
    UIImage *newAPNBtn=[UIImage imageNamed:@"newAPNBtn.png"];
    img_option2 =[ [UIImageView alloc] initWithImage:newAPNBtn] ;
    //img_option1 =[UIImage imageNamed:@"internet_button.png"] ;
    [img_option2 setFrame:CGRectMake(10.0,495.0, newAPNBtn.size.width-20, newAPNBtn.size.height)];
    [self.scrollView   addSubview:img_option2];
    
    
    //操作3
    option3 = [[UILabel alloc] initWithFrame:CGRectMake(10,790, 300, 120)];
    //[labeltest removeFromSuperview];
    [option3 setBackgroundColor:[UIColor clearColor]];
    [option3 setTextColor:[UIColor whiteColor]];
    option3.textAlignment = UITextAlignmentLeft;
    option3.font = [UIFont systemFontOfSize:17];
    option3.text=@"3、新建APN,填入APN描述、APN(如联通3gnet或联通3gwap)、用户名、密码、代理服务器、服务器端口，如无用户名、密码、代理服务器、服务器端口，可留空。然后点击“完成”即可；";
    option3.numberOfLines=0;//自动换行
    option3.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:option3]; 
    
    //操作3_图片3
    UIImage *imgnewAPNDetail=[UIImage imageNamed:@"newAPNDetail.png"];
    img_option3 =[ [UIImageView alloc] initWithImage:imgnewAPNDetail] ;
    //img_option1 =[UIImage imageNamed:@"internet_button.png"] ;
    [img_option3 setFrame:CGRectMake(10.0,910.0, imgnewAPNDetail.size.width-20, imgnewAPNDetail.size.height)];
    [self.scrollView   addSubview:img_option3];
    
    
    
    //操作4
    option4 = [[UILabel alloc] initWithFrame:CGRectMake(10,1240, 305, 180)];
    //[labeltest removeFromSuperview];
    [option4 setBackgroundColor:[UIColor clearColor]];
    [option4 setTextColor:[UIColor whiteColor]];
    option4.textAlignment = UITextAlignmentLeft;
    option4.font = [UIFont systemFontOfSize:17];
    option4.text=@"4、在公网、专网apn列表，点击表格行后面Switch按钮切换APN（这里同时也设置了默认的公网、专网APN,下次直接点击主页的公网或专网按钮就切换到您默认的apn），点击右上角的“删除”按钮还可以删除您所新建的APN,点击表格行时，可以对当前行的APN数据进行修改，填写方法和新建APN一样；";
    option4.numberOfLines=0;//自动换行
    option4.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:option4]; 
    //操作4_图片4
    UIImage *imgSwitchButton=[UIImage imageNamed:@"apnSwith.png"];
    img_option4 =[ [UIImageView alloc] initWithImage:imgSwitchButton] ;
    [img_option4 setFrame:CGRectMake(10.0,1420.0, imgSwitchButton.size.width-20, imgSwitchButton.size.height)];
    [self.scrollView   addSubview:img_option4];
    
    
    //操作5
    option5 = [[UILabel alloc] initWithFrame:CGRectMake(10,1635, 300, 100)];
    //[labeltest removeFromSuperview];
    [option5 setBackgroundColor:[UIColor clearColor]];
    [option5 setTextColor:[UIColor whiteColor]];
    option5.textAlignment = UITextAlignmentLeft;
    option5.font = [UIFont systemFontOfSize:17];
    option5.text=@"5、点击Switch按钮后，程序自动切换到安装描述文件页面，点击安装按钮即可完成切换；";
    option5.numberOfLines=0;//自动换行
    option5.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:option5]; 
    //操作5_图片5
    UIImage *imgSetingapn=[UIImage imageNamed:@"setingAPN.png"];
    img_option5 =[ [UIImageView alloc] initWithImage:imgSetingapn] ;
    [img_option5 setFrame:CGRectMake(10.0,1720.0, imgSetingapn.size.width-20, imgSetingapn.size.height)];
    [self.scrollView   addSubview:img_option5];
    
    //操作6
    option6 = [[UILabel alloc] initWithFrame:CGRectMake(10,2000, 300, 100)];
    //[labeltest removeFromSuperview];
    [option6 setBackgroundColor:[UIColor clearColor]];
    [option6 setTextColor:[UIColor whiteColor]];
    option6.textAlignment = UITextAlignmentLeft;
    option6.font = [UIFont systemFontOfSize:17];
    option6.text=@"6、如果您经过上述操作分别设置了公网、专网APN,那么您以后就可以直接点击主页的公网、专网按钮切换到相应的APN了；";
    option6.numberOfLines=0;//自动换行
    option6.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:option6]; 
    
    //操作6_图片6
    UIImage *mainOptionSeting=[UIImage imageNamed:@"mainOption.png"];
    img_option6=[ [UIImageView alloc] initWithImage:mainOptionSeting] ;
    [img_option6 setFrame:CGRectMake(30.0,2100.0, mainOptionSeting.size.width-20, mainOptionSeting.size.height)];
    [self.scrollView   addSubview:img_option6];
    
    //操作8
    option7 = [[UILabel alloc] initWithFrame:CGRectMake(10,2110, 300, 200)];
    //[labeltest removeFromSuperview];
    [option7 setBackgroundColor:[UIColor clearColor]];
    [option7 setTextColor:[UIColor whiteColor]];
    option7.textAlignment = UITextAlignmentLeft;
    option7.font = [UIFont systemFontOfSize:17];
    option7.text=@"7、常见问题1，如果在安装描述文件的时候提示：“只能安装一个APN设置”，请在“设置”->通用->描述文件->配置文件中找到以前配置的APN文件，点击“移除”即可；";
    option7.numberOfLines=0;//自动换行
    option7.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:option7]; 
    
    //操作8
    option8 = [[UILabel alloc] initWithFrame:CGRectMake(10,2255, 300, 100)];
    //[labeltest removeFromSuperview];
    [option8 setBackgroundColor:[UIColor clearColor]];
    [option8 setTextColor:[UIColor whiteColor]];
    option8.textAlignment = UITextAlignmentLeft;
    option8.font = [UIFont systemFontOfSize:17];
    option8.text=@"8、常见问题2，如果在安装的时候出现以下界面，请检查您新建APN的时候填写的代理服务器和端口是否正确；";
    option8.numberOfLines=0;//自动换行
    option8.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:option8]; 
    
    //操作8_图片8
    UIImage *error_htpp=[UIImage imageNamed:@"error_http_web.png"];
    img_option7=[ [UIImageView alloc] initWithImage:error_htpp] ;
    [img_option7 setFrame:CGRectMake(30.0,2345.0, error_htpp.size.width-20, error_htpp.size.height)];
    [self.scrollView   addSubview:img_option7];
    
    
    //操作9
    option9 = [[UILabel alloc] initWithFrame:CGRectMake(10,2520, 300, 100)];
    //[labeltest removeFromSuperview];
    [option9 setBackgroundColor:[UIColor clearColor]];
    [option9 setTextColor:[UIColor whiteColor]];
    option9.textAlignment = UITextAlignmentLeft;
    option9.font = [UIFont systemFontOfSize:17];
    option9.text=@"9、常见问题3，如果在切换APN的时候出现以下界面，请按照第7点移除您所安装的APN即可。";
    option9.numberOfLines=0;//自动换行
    option9.lineBreakMode = UILineBreakModeWordWrap;
    [scrollView addSubview:option9]; 
    
    //操作9_图片9
    UIImage *error3=[UIImage imageNamed:@"error3.png"];
    img_option8=[ [UIImageView alloc] initWithImage:error3] ;
    [img_option8 setFrame:CGRectMake(20.0,2605.0, error3.size.width-40, error_htpp.size.height)];
    [self.scrollView   addSubview:img_option8];
    
     
    
    [labeltitle release];
    [labeltitle2 release];
    [labeltitle3 release];
    [option1 release];
    [option2 release];
    [option3 release];
    [option4 release];
    [option5 release];
    [option6 release];
    [option7 release];
    [option8 release];
    [option9 release];
    [img_option1 release];
    [img_option2 release];
    [img_option3 release];
    [img_option4 release];
    [img_option5 release];
    [img_option6 release];
    [img_option7 release];
    [img_option8 release];
    
}
//导航到zhuye
-(IBAction)backMainView{
    
//   // [self dismissModalViewControllerAnimated:YES];
//    //动画 
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:1];
//    //shezhi
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
//    
//    [UIView commitAnimations];
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView =nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
