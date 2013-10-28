
#import "UIViewController+UIViewController_category.h"
#import "NewsReader.h"
#import "NewsItemWebView.h"
#import "DataLoader.h"
#import "Task.h"
#import "MBProgressHUD.h"

@implementation NewsReader

#pragma mark Generic methods

//
- (id)initWithNewsId:(NSString *)newsId
{
    self = [super init];
    if (self)
    {
        _newsId = [newsId retain];
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

// Destructor
- (void)dealloc
{
    [[DataLoader loader] closeTaskWithType:Task_GetNewsDetail];
    
    [_newsItem release];
    [_newsId release];
	[super dealloc];
}


#pragma mark View methods

// Do additional setup after loading the view.
- (void)viewDidLoad
{
	[super viewDidLoad];
	    
    self.title = @"资讯";
    
    [[DataLoader loader] getNewsDetail:self andId:_newsId];
}

// Called after the view controller's view is released and set to nil.
- (void)viewDidUnload
{
	[super viewDidUnload];
}

// Override to allow rotation.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return YES;
//}

// Faster one-part variant, called from within a rotating animation block, for additional animations during rotation.
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//}

// Release any cached data, images, etc that aren't in use.
//- (void)didReceiveMemoryWarning
//{
//	[super didReceiveMemoryWarning];
//}

// TaskDelegate <NSObject>
- (void)taskStarted:(TaskType)type
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)taskFinished:(TaskType)type result:(id)result
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([result isKindOfClass:[NSError class]])
    {
        MBProgressHUD *show = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        show.mode = MBProgressHUDModeText;
        show.labelText = [(NSError *)result localizedDescription];
        [show hide:YES afterDelay:2];
        //[self.view makeToast:[(NSError *)result localizedDescription] duration:0.5 position:@"center"];
    }
    else
    {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            [_newsItem release];
            _newsItem = [result retain];
            
            [_itemView removeFromSuperview];
            
            _itemView = [[NewsItemWebView alloc] initWithFrame:self.view.frame andItem:_newsItem];
            _itemView.backgroundColor = [UIColor whiteColor];
            _itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:_itemView];
            [_itemView release];
        }
    }
}

@end
