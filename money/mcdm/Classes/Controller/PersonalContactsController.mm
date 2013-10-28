//
//  PersonalContactsController.m
//  MCDM
//
//  Created by Fred on 13-1-8.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import "PersonalContactsController.h"
#import "ContactsDetector.h"
#import "Task.h"
#import "DataLoader.h"
#import "Toast+UIView.h"
#import "MBProgressHUD.h"
#import "ContactsProgressBar.h"

#define kBackupAlertTag 1000
#define kRestoreAlertTag 1001

@interface PersonalContactsController ()

@end

@implementation PersonalContactsController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _countInfoLabel = nil;
    _personalView = nil;
    _progressBar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[DataLoader loader] getLocalAndServerContactsCount:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addPersonalViewItems:(int)localCount andServerCount:(int)serverCount
{
    [_personalView removeFromSuperview];
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    //
    _personalView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:[_personalView autorelease]];
    
    CGFloat startY = 16;
    if (localCount)
    {
        UIImage *normal = [UIImage imageNamed:@"Backup.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:normal forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onBackup) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake((frame.size.width-normal.size.width)/2, startY, normal.size.width, normal.size.height);
        
        [_personalView addSubview:button];
        
        startY = CGRectGetMaxY(button.frame)+16;
    }
    
    if (serverCount)
    {
        UIImage *normal = [UIImage imageNamed:@"Restore.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:normal forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onRestore) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake((frame.size.width-normal.size.width)/2, startY, normal.size.width, normal.size.height);
        
        [_personalView addSubview:button];
        
        startY = CGRectGetMaxY(button.frame)+16;
    }
    
    {
        CGRect labelFrame = CGRectMake(16, startY-10, frame.size.width-32, 16);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = UITextAlignmentRight;
        label.text = [NSString stringWithFormat:@"本地:%d, 云端:%d", localCount, serverCount];
        [_personalView addSubview:[label autorelease]];
        _countInfoLabel = label;
    }
}

- (void)onBackup
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否备份通讯录？"
                                                          message:nil
                                                         delegate:nil
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定备份", nil];
    alertView.delegate = self;
    alertView.tag = kBackupAlertTag;
	[alertView show];
    [alertView autorelease];
}

- (void)onRestore
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否恢复通讯录？"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定恢复", nil];
    alertView.delegate = self;
    alertView.tag = kRestoreAlertTag;
	[alertView show];
    [alertView autorelease];
}

// UIAlertViewDelegate <NSObject>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex)
    {
        if (alertView.tag == kBackupAlertTag)
        {
            [[DataLoader loader] backupPersonalContacts:self];
        }
        else if (alertView.tag == kRestoreAlertTag)
        {
            [[DataLoader loader] restorePersonalContacts:self];
        }
    }
}

// TaskDelegate <NSObject>
- (void)taskStarted:(TaskType)type
{
    if (type == Task_BackupPersonalContacts)
    {
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //progress.labelText = @"正在备份...";
        
        _progressBar = [[[ContactsProgressBar alloc] initProgressBar:@"正在备份..."] autorelease];
        progress.customView = _progressBar;
        progress.mode = MBProgressHUDModeCustomView;
    }
    else if (type == Task_RestorePersonalContacts)
    {
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //progress.labelText = @"正在恢复...";
        
        _progressBar = [[[ContactsProgressBar alloc] initProgressBar:@"正在恢复..."] autorelease];
        progress.customView = _progressBar;
        progress.mode = MBProgressHUDModeCustomView;
    }
    else
    {
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progress.labelText = @"正在获取云端数量信息...";
    }
}

- (void)taskFinished:(TaskType)type result:(id)result
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if ([result isKindOfClass:[NSError class]])
    {
        MBProgressHUD *show = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        show.mode = MBProgressHUDModeText;
        show.detailsLabelText = [(NSError *)result localizedDescription];
        [show hide:YES afterDelay:1.5];
        //[self.view makeToast:[(NSError *)result localizedDescription] duration:0.5 position:@"center"];
    }
    else
    {
        if (type == Task_CheckLocalAndServerContactsInfo)
        {
            [self addPersonalViewItems:[ContactsDetector detector].localContactsCount andServerCount:[ContactsDetector detector].serverContactsCount];
        }
        else if (type == Task_BackupPersonalContacts || type == Task_RestorePersonalContacts)
        {
            _Log(@"Task_BackupPersonalContacts || type == Task_RestorePersonalContacts result:%@", result);
            
            [self addPersonalViewItems:[ContactsDetector detector].localContactsCount andServerCount:[ContactsDetector detector].serverContactsCount];
            
            if ([result isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *changesDict = (NSDictionary *)result;
                
                NSMutableString *temp = [[NSMutableString alloc] init];
                if (![[changesDict allKeys] count])
                {
                    [temp appendString:type == Task_BackupPersonalContacts ? @"备份已完成" : @"恢复已完成"];
                }
                else
                {
                    [temp appendString:type == Task_BackupPersonalContacts ? @"备份成功\n您的本地通讯录已全部备份到云端\n" : @"恢复成功\n您的云端通讯录已全部恢复到本地\n"];
                    
                    int newCount = [[changesDict objectForKey:kNewKey] intValue];
                    if (newCount)
                    {
                        [temp appendString:type == Task_BackupPersonalContacts ? @"云端" : @"本地"];
                        [temp appendFormat:@"新增:%d\n", newCount];
                    }
                    int updateCount = [[changesDict objectForKey:kUpdateKey] intValue];
                    if (updateCount)
                    {
                        [temp appendString:type == Task_BackupPersonalContacts ? @"云端" : @"本地"];
                        [temp appendFormat:@"更改:%d\n", updateCount];
                    }
                    int delCount = [[changesDict objectForKey:kDeleteKey] intValue];
                    if (delCount)
                    {
                        [temp appendString:type == Task_BackupPersonalContacts ? @"云端" : @"本地"];
                        [temp appendFormat:@"删除:%d\n", delCount];
                    }
                }
                
                MBProgressHUD *show = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                show.mode = MBProgressHUDModeText;
                show.detailsLabelText = temp;
                [show hide:YES afterDelay:3];
                
                [temp release];
            }
        }
    }
}

@end
