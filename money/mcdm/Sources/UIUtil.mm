
#import "UIUtil.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark UIImage methods

@implementation UIImage (ImageEx)

// Load image and scale to specified size if needed
+ (id)imageWithContentsOfFile:(NSString *)path scaleTo:(CGSize)size
{
	UIImage *image = [UIImage imageWithContentsOfFile:path];
	
	if (size.width == 0)
	{
		if (image.size.height)
		{
			size.width = image.size.width * size.height / image.size.height;
		}
	}
	else if (size.height == 0)
	{
		if (image.size.width)
		{
			size.height = image.size.height * size.width / image.size.width;
		}
	}
	
	if ((size.width == image.size.width) && (size.height == image.size.height))
	{
		return image;
	}
	
	// Scale image
	//#define _SCALE_IMAGE_METHOD_1
#ifdef _SCALE_IMAGE_METHOD_1
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	if (alphaInfo == kCGImageAlphaNone)
	{
		alphaInfo = kCGImageAlphaNoneSkipLast;
	}
	CGFloat bytesPerRow = 4 * ((size.width > size.height) ? size.width : size.height);
	CGContextRef bitmap = CGBitmapContextCreate(NULL,
												size.width,
												size.height,
												8, //CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
												bytesPerRow, //4 * thumbRect.size.width,	// rowbytes
												CGImageGetColorSpace(imageRef),
												alphaInfo);
	
	// Draw into the context, this scales the image
	CGRect rect = {0, 0, size.width, size.height};
	CGContextDrawImage(bitmap, rect, imageRef);
	
	// Get an image from the context and a UIImage
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* scaledImage = [UIImage imageWithCGImage:ref];
	CGContextRelease(bitmap);
	CGImageRelease(ref);
#else
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
#endif
	
	return scaledImage;
}

+ (UIImage *)imageClipWithColor:(UIImage *)image color:(UIColor *)color
{
    if (!color || !image)
    {
        return image;
    }
    
    CGSize contextSize = image.size;
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextClipToMask(c, CGRectMake(0, 0, contextSize.width, contextSize.height),
                        [image CGImage]);
    
    CGContextSetFillColorWithColor(c, color.CGColor);
    CGContextFillRect(c, CGRectMake(0, 0, contextSize.width, contextSize.height));

    UIImage* selImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return selImage;
}

- (UIImage *)imageFitInLeftTop:(CGSize)size
{
    if (!size.width || !size.height)
    {
        return nil;
    }
    
    float s_x = size.width/self.size.width;
    float s_y = size.height/self.size.height;
    
    if (s_x <= 1.f && s_y <= 1.f)
    {
        //return self;
    }
    
    float scale = s_x > s_y ? s_x : s_y;
    return [UIImage imageWithCGImage:self.CGImage scale:1.f/scale orientation:self.imageOrientation];
}

- (UIImage *)imageWithBackgroundColor:(UIColor *)color
{
    if (!color)
    {
        color = [UIColor blackColor];
    }
    
    CGSize contextSize = self.size;
    
    UIGraphicsBeginImageContext(contextSize);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, color.CGColor);
    CGContextFillRect(c, CGRectMake(0, 0, contextSize.width, contextSize.height));
    
    [self drawInRect:CGRectMake(0, 0, contextSize.width, contextSize.height)];
    
    UIImage* selImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return selImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color overColor:(UIColor *)overColor andSize:(CGSize)size
{
    if (!color)
    {
        color = [UIColor clearColor];
    }
    
    CGSize contextSize = size;
    
    UIImage *image = [UIImage imageNamed:@"NavigationBar.png"];
    
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 1.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(c, color.CGColor);
    //CGContextFillRect(c, CGRectMake(0, 0, contextSize.width, contextSize.height));
    
    CGContextSetFillColorWithColor(c, overColor.CGColor);
    CGContextFillRect(c, CGRectMake(0, 0, contextSize.width, contextSize.height));
    
    [image drawInRect:CGRectMake(0, 0, contextSize.width, contextSize.height)];
    
    UIImage* selImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return selImage;
}

@end


#pragma mark UIImage methods

@implementation UIView (ViewEx)

//
- (void)removeSubviews
{
	while (self.subviews.count)
	{
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

@end


#pragma mark UIAlertView methods

@implementation UIAlertView (AlertViewEx)

//
+ (id)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message
													   delegate:delegate
											  cancelButtonTitle:cancelButtonTitle
											  otherButtonTitles:otherButtonTitles, nil/*TODO*/];
	[alertView show];
	return [alertView autorelease];
}

//
+ (id)alertWithTitle:(NSString *)title message:(NSString *)message
{
	return [self alertWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil];
}

//
+ (id)alertWithTitle:(NSString *)title
{
	return [self alertWithTitle:title message:nil];
}

//
+ (id)alertWithTask:(id/*<AlertViewExDelegate>*/)delegate title:(NSString *)title
{
	UIAlertView *alertView = [self alertWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[alertView showActivityIndicator:YES];
	[delegate performSelectorInBackground:@selector(doTask:) withObject:alertView];
	return alertView;
}

//
- (void)showActivityIndicator:(BOOL)show
{
	UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self viewWithTag:1924];
	if (show)
	{
		if (activityIndicator == nil)
		{
			activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			activityIndicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 40);
			activityIndicator.tag = 1924;
			activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
			[self addSubview:activityIndicator];
			[activityIndicator startAnimating];
			[activityIndicator release];
		}
	}
	else
	{
		[activityIndicator removeFromSuperview];
	}
}

//
- (void)dismissOnMainThread
{
	[self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
}

//
- (void)dismiss
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

@end


#pragma mark UITabBarController methods

@implementation UIBarButtonItem (UIBarButtonItemEx)

//
+ (id)barItemWithView:(UIView *)view
{
	return [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];	
}

//
+ (id)barItemWithImage:(NSString *)path
{
	UIImage *image = [UIImage imageWithContentsOfFile:path];
	UIImageView *view = [[[UIImageView alloc] initWithImage:image] autorelease];
	return [self barItemWithView:view];	
}

@end


#pragma mark UITabBarController methods

@implementation UITabBarController (TabBarControllerEx)

//
- (UIViewController *)currentViewController
{
	if (UIUtil::IsPad())
	{
		return self.selectedIndex < 7 ? self.selectedViewController : self.moreNavigationController;
	}
	else
	{
		return self.selectedIndex < 4 ? self.selectedViewController : self.moreNavigationController;
	}
}

@end


#pragma mark UIViewController methods

@implementation UIViewController (ViewControllerEx)

//
- (void)presentModalNavigationController:(UIViewController *)controller animated:(BOOL)animated
{
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
																				target:self
																				action:@selector(dismissModalViewControllerAnimated:)];
	controller.navigationItem.leftBarButtonItem = doneButton;
	[doneButton release];
	
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	navigation.modalTransitionStyle = controller.modalTransitionStyle;
	
#if (_TARGET_VERSION < 32)
	if ([navigation respondsToSelector:@selector(setModalPresentationStyle:)])
#endif
	{
		navigation.modalPresentationStyle = controller.modalPresentationStyle;
	}
    
    /*
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromRight];//从上推入
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
	
    [controller.view.layer addAnimation:animation forKey:nil];*/
    
	[self presentModalViewController:navigation animated:animated];
	[navigation release];
}

@end

@implementation UIApplication (AppDimensions)

+ (CGSize)currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

@end


#pragma mark Debug methods

//
void PrintIndentString(NSUInteger indent, NSString *str)
{
	NSString *log = @"";
	for (NSUInteger i = 0; i < indent; i++)
	{
		log = [log stringByAppendingString:@"\t"];
	}
	log = [log stringByAppendingString:str];
	//_Log(@"%@", log);
}

// Print controller and sub-controllers
void UIUtil::PrintController(UIViewController *controller, NSUInteger indent)
{
	PrintIndentString(indent, [NSString stringWithFormat:@"<Controller Description=\"%@\">", [controller description]]);

	if (controller.modalViewController)
	{
		PrintController(controller, indent + 1);
	}
	
	if ([controller isKindOfClass:[UINavigationController class]])
	{
		for (UIViewController *child in ((UINavigationController *)controller).viewControllers)
		{
			PrintController(child, indent + 1);
		}
	}
	else if ([controller isKindOfClass:[UITabBarController class]])
	{
		UITabBarController *tabBarController = (UITabBarController *)controller;
		for (UIViewController *child in tabBarController.viewControllers)
		{
			PrintController(child, indent + 1);
		}

		if (tabBarController.moreNavigationController)
		{
			PrintController(tabBarController.moreNavigationController, indent + 1);
		}
	}

	PrintIndentString(indent, @"</Controller>");
}

// Print view and subviews
void UIUtil::PrintView(UIView *view, NSUInteger indent)
{
	PrintIndentString(indent, [NSString stringWithFormat:@"<View Description=\"%@\">", [view description]]);
	
	for (UIView *child in view.subviews)
	{
		PrintView(child, indent + 1);
	}
	
	PrintIndentString(indent, @"</View>");
}
