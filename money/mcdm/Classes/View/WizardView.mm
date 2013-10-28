
#import "AppDelegate.h"
#import "WizardView.h"
#import "GBDeviceInfo.h"
#import "TouchImageView.h"
#import "Defines.h"
//
@implementation WizardView

//
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	self.backgroundColor = UIColor.blackColor;
	
	_images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:(NSUtil::BundleSubPath([GBDeviceInfo deviceDetails].display == GBDeviceDisplayiPhone4Inch?@"WizardImages_IP5":@"WizardImages")) error:nil];
	_images = [[_images sortedArrayUsingSelector:@selector(compare:)] retain];
	
	self.delegate2 = self;
	self.numberOfPages = _images.count;
	self.currentPage = 0;
	
	UIUtil::ShowStatusBar(NO);
	
	return self;
}

//
- (void)dealloc
{
	[_images release];
	[super dealloc];
}

//
- (UIView *)scrollView:(PredictScrollView *)scrollView viewForPage:(NSUInteger)index inFrame:(CGRect)frame
{
	TouchImageView *imageView = [[[TouchImageView alloc] initWithFrame:frame] autorelease];
	imageView.userInteractionEnabled = YES;
	imageView.backgroundColor = [UIColor lightGrayColor];
	//imageView.contentMode = UIViewContentModeBottom;
	imageView.clipsToBounds = YES;
	
	if (index == _images.count - 1)
	{
		[imageView addTarget:self action:@selector(finishWizard)];
	}

	NSString *image = [_images objectAtIndex:index];
	NSString *path = [NSUtil::BundleSubPath([GBDeviceInfo deviceDetails].display == GBDeviceDisplayiPhone4Inch?@"WizardImages_IP5":@"WizardImages") stringByAppendingPathComponent:image];
	imageView.image	= [UIImage imageWithContentsOfFile:path];
	
	return imageView;
}

//
- (void)scrollView:(PredictScrollView *)scrollView scrollToPage:(NSUInteger)index
{
}

//
- (void)finishWizard
{
	UIUtil::ShowStatusBar(YES);
	NSUtil::SaveSettingForKey(kWizardDone, [NSNumber numberWithBool:YES]);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
	self.alpha = 0;
	[UIView commitAnimations];
}

@end 
