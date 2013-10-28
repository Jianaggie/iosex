//
//  SNViewController.h
//  mcdm
//
//  Created by ustc mobile cloud lab on 12-6-18.
//  Copyright (c) 2012年 ustc. All rights reserved.
//

//#import <UIKit/UIKit.h>

@class HomeViewController;

@interface SNViewController : UIViewController{
    HomeViewController* parentVCtrlr;
    UITextField* txtSN;
}

-(IBAction)pressSN:(id)sender;
-(IBAction)textFieldDoneEditing:(id)sender;

-(void)setParentVCtrlr:(HomeViewController*) vCtrlrHome;

@property(nonatomic,retain) IBOutlet UITextField* txtSN;

@property(nonatomic,retain) IBOutlet UIButton* bttnSN;
@property(nonatomic, retain) IBOutlet UIButton* cancleButton;
@end
