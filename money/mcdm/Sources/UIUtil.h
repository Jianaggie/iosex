

#import <UIKit/UIKit.h>
#import "NSUtil.h"


//
@interface UIImage (ImageEx)
+ (id)imageWithContentsOfFile:(NSString *)path scaleTo:(CGSize)size;
+ (UIImage *)imageClipWithColor:(UIImage *)image color:(UIColor *)color;

- (UIImage *)imageFitInLeftTop:(CGSize)size;

- (UIImage *)imageWithBackgroundColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color overColor:(UIColor *)overColor andSize:(CGSize)size;

@end


//
@interface UIView (ViewEx)
- (void)removeSubviews;
@end


//
@protocol AlertViewExDelegate
@required
- (void)doTask:(UIAlertView *)alertView;
@end

//
@interface UIAlertView (AlertViewEx)

//
+ (id)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;
+ (id)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (id)alertWithTitle:(NSString *)title;
+ (id)alertWithTask:(id/*<AlertViewExDelegate>*/)delegate title:(NSString *)title;

//
- (void)showActivityIndicator:(BOOL)show;
- (void)dismissOnMainThread;
- (void)dismiss;

@end


//
@interface UIBarButtonItem (BarButtonItemEx)
+ (id)barItemWithView:(UIView *)view;
+ (id)barItemWithImage:(NSString *)path;
@end

//
@interface UITabBarController (TabBarControllerEx)
- (UIViewController *)currentViewController;
@end

@interface UIApplication (AppDimensions)

+ (CGSize)currentSize;
+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation;

@end

//
@interface UIViewController (ViewControllerEx)
- (void)presentModalNavigationController:(UIViewController *)controller animated:(BOOL)animated;
@end


//
@class AppDelegate;
namespace UIUtil
{
#pragma mark Device methods
	
	// 
	NS_INLINE UIDevice *Device()
	{
		return [UIDevice currentDevice];
	}
	
	// 
	NS_INLINE float SystemVersion()
	{
		return [[Device() systemVersion] floatValue];
	}
	
	//
	NS_INLINE BOOL IsPad()
	{
		return (SystemVersion() < 3.2) ? NO : ([Device() userInterfaceIdiom] == UIUserInterfaceIdiomPad);
	}
	
	//
	NS_INLINE UIScreen *Screen()
	{
		return [UIScreen mainScreen];
	}
	
	//
	NS_INLINE CGRect AppFrame()
	{
		return Screen().applicationFrame;
	}
	
	//
	NS_INLINE CGSize ScreenSize()
	{
		CGRect frame = AppFrame();
		return CGSizeMake(frame.size.width, frame.size.height + frame.origin.y);
	}
	
	//
	NS_INLINE CGRect ScreenFrame()
	{
		CGRect frame = AppFrame();
		frame.size.height += frame.origin.y;
		frame.origin.y = 0;
		return frame;
	}
	
	
#pragma mark Application methods
	
	// 
	NS_INLINE UIApplication *Application()
	{
		return [UIApplication sharedApplication];
	}
	
	//
	NS_INLINE AppDelegate *Delegate()
	{
		return (AppDelegate *)Application().delegate;
	}
	
	//
	NS_INLINE BOOL OpenURL(NSString *url)
	{
		return [Application() openURL:[NSURL URLWithString:url]];
	}
	
	//
	NS_INLINE UIWindow *KeyWindow()
	{
		return Application().keyWindow;
	}
	
	//
	NS_INLINE BOOL IsLandscape(UIInterfaceOrientation orientation)
	{
		return (orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight);
	}
	
	//
	NS_INLINE BOOL IsWindowLandscape()
	{
		CGSize size = KeyWindow().frame.size;
		return size.width > size.height;
	}
	
	//
	NS_INLINE void ShowStatusBar(BOOL show = YES, BOOL animated = YES)
	{
#ifdef __IPHONE_3_2
		if ([Application() respondsToSelector:@selector(setStatusBarHidden:withAnimation:)])
		{
			[Application() setStatusBarHidden:!show withAnimation:animated ? UIStatusBarAnimationSlide : UIStatusBarAnimationNone];
		}
		else
#endif
		{
			[Application() setStatusBarHidden:!show/* animated:animated*/];
		}
	}
	

	//
	NS_INLINE void ShowNetworkIndicator(BOOL show = YES)
	{
		Application().networkActivityIndicatorVisible = show;
	}
	
#pragma mark Debug methods
	
	// Print controller and sub-controllers
	void PrintController(UIViewController *controller, NSUInteger indent = 0);
	
	// Print view and subviews
	void PrintView(UIView *view, NSUInteger indent = 0);
};