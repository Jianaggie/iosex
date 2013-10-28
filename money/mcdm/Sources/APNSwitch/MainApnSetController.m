//
//  MainApnSetController.m
//  unuion03
//
//  Created by easystudio on 11/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainApnSetController.h"


@implementation MainApnSetController
@synthesize uiS;
@synthesize uiimgView;
@synthesize mainScrollView;
@synthesize addapnview;
@synthesize editController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}



-(void)navaddApnInfo
{
    if (addapnview==nil) {
        addapnview=[[NetworkViewController alloc] init];
        
    }
     
    if ([uiS selectedSegmentIndex]==0) {
        addapnview.apnType=@"internetAPN";//设置 写入文件的apn类型
    }else{ 
       addapnview.apnType=@"intranetAPN";//设置 写入文件的apn类型
    }
    [addapnview viewWillAppear:YES];
    
//    [UIView beginAnimations:nil context:nil];UIModalTransitionStyleCoverVertical
//    [UIView setAnimationTransition:UIModalTransitionStyleCoverVertical forView:self.navigationController.view cache:YES];
//    [UIView setAnimationDuration:1.0];
    
    //[addapnview.navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController pushViewController:addapnview animated:YES];
    //[UIView commitAnimations];
   // [addapnview.navigationController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
     //[addapnview.navigationController setModalPresentationStyle:UIModalTransitionStyleCoverVertical];
     //[self.navigationController setModalPresentationStyle:UIModalTransitionStyleCoverVertical];
   // [self presentModalViewController:addapnview animated:NO];
    //   // unuion03AppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    // self.navigationController.title=@"新建APN信息";
    //[self. navigationController pushViewController:addapnview1 animated:YES];
    // [self. navigationController pushViewController:addapnview animated:YES];
    //[self.parentViewController navigationController
    //    if(aboutMeController==nil){
    //        aboutMeController=[[AboutMeController alloc]init];
    //    }
    
    //unuion03AppDelegate *delegate=[[UIApplication sharedApplication]delegate];
//    DefaultStartViewController *mainView=[[DefaultStartViewController alloc]init];
//    InternetViewController *internetView =[[InternetViewController alloc]init];
//    
//     
//    [mainView.navigationController pushViewController:addapnview animated:YES];
    
    //delegate.navigationController.navigationItem.backBarButtonItem.title=@"dfdf";
    //[delegate.navigationController pushViewController:addapnview animated:YES];
    //    self.navigationItem.title=@"APN设置";
    //    [self.navigationController pushViewController:aboutMeController animated:YES];
    
    
}
-(void)navEditApnInfo:(id*)apn{
    
    if (editController==nil) {
        editController=[[EditApnInfoController alloc] initWithNibName:@"EditApnInfoController" bundle:nil];
        
    }
    
    
   // EditApnInfoController *editController=[[EditApnInfoController alloc]init];
    
    if ([uiS selectedSegmentIndex]==0) {
        editController.editApnType=@"internetAPN";//设置 写入文件的apn类型
    }else{ 
        editController.editApnType=@"intranetAPN";//设置 写入文件的apn类型
    }
    
    editController.apninfo=apn;
    
    [editController viewDidAppear:YES];
    [self.navigationController pushViewController:editController animated:YES];
    //[editController release];

}


-(IBAction)toggleControls:(id)sender{
    if ([sender selectedSegmentIndex]==0) {
     //[self.view removeFromSuperview];
         
        if (internetView!=nil) {
             
            [internetView.view removeFromSuperview];
        }
        if (intranetView !=nil) {
            [intranetView.view removeFromSuperview];
        }
        internetView=[[InternetViewController alloc]initWithNibName:@"InternetViewController" bundle:nil];
        //s.accessibilityFrame=CGRectMake(100, 300, 200, 400);
         [internetView.view setFrame:CGRectMake(0, 52, 320, 420)];
        //NSLog(@"%@--------dddddd--", internetView.view);
        internetView.internetViewDelegate=self;//设置代理
        [self.view addSubview:internetView.view];
        //[uiimgView addSubview:internetView.view];
         [self.view sendSubviewToBack:internetView.view];
    }else{
        
        if (internetView!=nil) {
            [internetView.view removeFromSuperview];
        }
        if (intranetView !=nil) {
            [intranetView.view removeFromSuperview];
        } 

        intranetView=[[IntranetViewController alloc]initWithNibName:@"IntranetViewController" bundle:nil];
        //s.accessibilityFrame=CGRectMake(100, 300, 200, 400);
        [intranetView.view setFrame:CGRectMake(0, 52, 320, 420)];
        //[uiimgView addSubview:intranetView.view];
        intranetView.intrantViewDelegate=self;//设置代理
        [self.view addSubview:intranetView.view];
         [self.view sendSubviewToBack:intranetView.view];
        
    }
}
//-(void)reLoadTableView{
//    if ([uiS selectedSegmentIndex]==0) {
//        //[self.view removeFromSuperview];
//        NSLog(@"----------------reLoadTableView gongs---");
//        if (internetView!=nil) {
//            [internetView.view removeFromSuperview];
//        }
//        if (intranetView !=nil) {
//            [intranetView.view removeFromSuperview];
//        }
//        internetView=[[InternetViewController alloc]initWithNibName:@"InternetViewController" bundle:nil];
//        //s.accessibilityFrame=CGRectMake(100, 300, 200, 400);
//        [internetView.view setFrame:CGRectMake(0, 30, 320, 420)];
//        //NSLog(@"%@--------dddddd--", internetView.view);
//        internetView.internetViewDelegate=self;//设置代理
//        [self.view addSubview:internetView.view];
//        //[uiimgView addSubview:internetView.view];
//        [self.view sendSubviewToBack:internetView.view];
//    }else{
//        
//        NSLog(@"----------------reLoadTableView NEI--");
//        if (internetView!=nil) {
//            [internetView.view removeFromSuperview];
//        }
//        if (intranetView !=nil) {
//            [intranetView.view removeFromSuperview];
//        } 
//        
//        intranetView=[[IntranetViewController alloc]initWithNibName:@"IntranetViewController" bundle:nil];
//        //s.accessibilityFrame=CGRectMake(100, 300, 200, 400);
//        [intranetView.view setFrame:CGRectMake(0, 30, 320, 420)];
//        //[uiimgView addSubview:intranetView.view];
//        intranetView.intrantViewDelegate=self;//设置代理
//        [self.view addSubview:intranetView.view];
//        [self.view sendSubviewToBack:intranetView.view];
//        
//    }
//
//}


//删除表格的行
-(void)deleteTableRow{
    NSInteger i = uiS.selectedSegmentIndex;
    BOOL b=self.editing;
   //公网
    if (i==0) {
        if (internetView==nil) {
             internetView= [[InternetViewController alloc]init];
        }
        
        [internetView.tableViews setEditing:!b];
        self.editing=!b;
    //专网
    }else{
        if (intranetView==nil) {
            intranetView= [[IntranetViewController alloc]init];
        }
        
        [intranetView.tableViews setEditing:!b];
        self.editing=!b;
    }
    if (!self.editing) {
        self.navigationItem.rightBarButtonItem.title=@"删除";
    }else{
      self.navigationItem.rightBarButtonItem.title=@"完成";
    }
   // NSLog(@"deleteTableRowdeleteTableRowdeleteTableRow%i",uiS.selectedSegmentIndex);
}


- (void)dealloc
{
    [super dealloc];
    [uiS release];
    [internetView release];//外网
    [intranetView release];//内网
    [uiimgView release];
    [mainScrollView release];
    [editController release];
    
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated{ 
//    uiS.selectedSegmentIndex=1;
//    uiS.selectedSegmentIndex=0;
//    [uiS addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlStateSelected]; 
//    
//    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width * 1, mainScrollView.frame.size.height+280);
//    mainScrollView.scrollEnabled=true;
   // self.navigationItem.backBarButtonItem=
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
    self.navigationItem.rightBarButtonItem.action=@selector(deleteTableRow);
    
    if (!self.editing) {
        self.navigationItem.rightBarButtonItem.title=@"删除";
    }else{
        self.navigationItem.rightBarButtonItem.title=@"完成";
    }
    
    self.navigationItem.title=@"APN设置";
    //加一个 返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backimg= [UIImage imageNamed:@"BackIcon.png"];
    [leftbutton setImage:[UIImage imageNamed:@"BackIcon.png"] forState:UIControlStateNormal];
    leftbutton.frame=CGRectMake(0, 0, backimg.size.width, backimg.size.height);
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    [leftbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
//    //重新加载表格数据
//    if (internetView==nil) {
//        internetView=[[InternetViewController alloc] init];
//        [internetView readApnInfoForTable];
//        [internetView.tableViews reloadData];
//    }
//    if (intranetView==nil) {
//        intranetView=[[IntranetViewController alloc] init];
//        [intranetView readApnInfoForTable];
//        [intranetView.tableViews reloadData];
//    }
    
}
//返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
     
 
    [super viewDidLoad];
    //uiS.selectedSegmentIndex=1;
     uiS.selectedSegmentIndex=0;
    [uiS addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlStateSelected]; 
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width * 1, mainScrollView.frame.size.height+280);
    mainScrollView.scrollEnabled=true;
    
//    self.navigationItem.backBarButtonItem.title=@"返回";
//    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"dfd" style:UIBarButtonItemStylePlain target:self action:@selector(viewDidUnload)];
}
//-(void)loadView{
//   NSLog(@"------MAINapin set loadView---------");
//}
//设置默认值
-(void)setDefaultSegmentValue:(NSInteger)i{
     
    //默认公网
    if (i==0) {
        //uiS.selectedSegmentIndex=1;
        uiS.selectedSegmentIndex=0;
        [self toggleControls:uiS];
        // NSLog(@"setDefaultSegmentValuesetDefaultSegmentValue00000%i",uiS.selectedSegmentIndex);
        //[uiS addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlStateSelected]; 
    }else{
       
        uiS.selectedSegmentIndex=0;
        uiS.selectedSegmentIndex=1;
        [self toggleControls:uiS];
        //[uiS addTarget:self action:@selector(toggleControls:) forControlEvents:UIControlStateSelected]; 
    }
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
