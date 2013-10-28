//
//  ContactsSubViewController.m
//  mcdm
//
//  Created by Cyber Wise on 13-01-22.
//  Copyright (c) 2013年 Cyber Wise. All rights reserved.
//
#import "ContactsSubViewController.h"
//#import "URLOperation.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import "ContactsViewController.h"
#import "MBProgressHUD.h"
@interface ContactsSubViewController ()
@property(nonatomic, retain) IBOutlet UILabel* lblName;
@property(nonatomic, retain) IBOutlet UILabel* lblPhone;
@property(nonatomic, retain) IBOutlet UILabel* lblEmail;
@property(nonatomic, retain) IBOutlet UIButton* bttnPhone;
@property(nonatomic, retain) IBOutlet UIButton* bttnSMS;
@property(nonatomic, retain) IBOutlet UIButton* bttnSend;
@property(nonatomic, retain) IBOutlet UIButton* bttnAdd;
@end
@implementation ContactsSubViewController
@synthesize dictContact;
@synthesize lblName;
@synthesize lblPhone;
@synthesize lblEmail;
@synthesize bttnPhone;
@synthesize bttnSMS;
@synthesize bttnSend;
@synthesize bttnAdd;
-(IBAction)bttnPhone:(id)sender
{
    UIWebView* callWebview = [[UIWebView alloc] init];
    NSURL* telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", lblPhone.text]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
-(IBAction)bttnSMS:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", lblPhone.text]]];
}
-(IBAction)bttnSend:(id)sender
{
    MFMessageComposeViewController* controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if ([MFMessageComposeViewController canSendText]) {
        controller.body = [NSString stringWithFormat:@"姓名:%@;", lblName.text];
        if (YES != [lblPhone.text isEqualToString:@""]) {
            controller.body = [NSString stringWithFormat:@"%@\n号码:%@;", controller.body, lblPhone.text];
        }
        if (YES != [lblEmail.text isEqualToString:@""]) {
            controller.body = [NSString stringWithFormat:@"%@\n邮箱:%@;", controller.body, lblEmail.text];
        }
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)bttnAdd:(id)sender
{
    //ABAddressBookRef对象使用完需要进行释放
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef person = ABPersonCreate();
    ABRecordSetValue(person, kABPersonLastNameProperty, (CFStringRef)lblName.text, NULL);
    ABMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValue, (CFStringRef)lblPhone.text, kABPersonPhoneMainLabel, NULL);
    //设置Phone属性
    ABRecordSetValue(person, kABPersonPhoneProperty, multiValue, NULL);
    if (multiValue) {
        CFRelease(multiValue);
    }
    multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValue, (CFStringRef)lblEmail.text, kABWorkLabel, NULL);
    ABRecordSetValue(person, kABPersonEmailProperty, multiValue, NULL);
    if (multiValue) {
        CFRelease(multiValue);
    }
    //将新建的联系人添加到通讯录中
    ABAddressBookAddRecord(addressBook, person, NULL);
    //保存通讯录数据
    ABAddressBookSave(addressBook, NULL);
    //释放通讯录对象的引用
    if (addressBook) {
        CFRelease(addressBook);
    }
    MBProgressHUD *show = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    show.mode = MBProgressHUDModeText;
    show.labelText = @"添加联系人成功!";
    [show hide:YES afterDelay:2];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UIColor* colorGreen = [UIColor blueColor];
    [bttnPhone setTitleColor:colorGreen forState:UIControlStateHighlighted];
    [bttnSMS setTitleColor:colorGreen forState:UIControlStateHighlighted];
    [bttnSend setTitleColor:colorGreen forState:UIControlStateHighlighted];
    [bttnAdd setTitleColor:colorGreen forState:UIControlStateHighlighted];
    lblName.text = [dictContact objectForKey:NAME];
    lblPhone.text = [dictContact objectForKey:PHONE];
    lblEmail.text = [dictContact objectForKey:EMAIL];
    [lblName sizeToFit];
    [lblPhone sizeToFit];
    [lblEmail sizeToFit];
    if (NO != [lblPhone.text isEqualToString:@""])
    {
        bttnPhone.enabled = NO;
        bttnSMS.enabled = NO;
    }
    self.title = @"简介";
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    UIImageView *background= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background01.png"]];
    [background setFrame:self.view.frame];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    [background release];
    
    /*UIImage *buttonNormal = [[UIImage imageNamed:@"NavigationBarBackButtonNormal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    UIImage *buttonPressed = [[UIImage imageNamed:@"NavigationBarBackButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStyleDone 
                                                                  target: self 
                                                                  action: @selector(backBarButtonAction)];
    [backButton setBackgroundImage:buttonNormal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backButton setBackgroundImage:buttonPressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];*/

    [super viewDidLoad];
    
}

//返回上一层菜单
-(void)backBarButtonAction{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];   
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    UINavigationController* navigationController = self.navigationController;
    ContactsViewController* contactsViewController;
    [self.navigationController popViewControllerAnimated:NO];
    contactsViewController = (ContactsViewController*)[navigationController visibleViewController];
    contactsViewController.navigationItem.hidesBackButton = YES;
    [contactsViewController onSelectionChanged:1];
}

- (void)viewDidUnload
{
    dictContact = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    if(dictContact!=nil)
        [dictContact release];
    [super dealloc];
}
@end
