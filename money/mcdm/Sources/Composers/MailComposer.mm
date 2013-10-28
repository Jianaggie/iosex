
#import "UIUtil.h"
#import "MailComposer.h"


@implementation MailComposer

#pragma mark Generic methods

// Constructor
- (id)init
{
	[super init];
	
	self.mailComposeDelegate = self;
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    /*
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    customLab.textAlignment = UITextAlignmentCenter;
    [customLab setText:NSLocalizedString(@"Slideshow options", nil)];
    customLab.backgroundColor = [UIColor clearColor];
    customLab.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    [customLab release];

    self.navigationItem.leftBarButtonItem = nil;*/
	return self;
}

// Destructor
//- (void)dealloc
//{
//	[super dealloc];
//}


#pragma mark Delegate methods

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissModalViewControllerAnimated:YES];
	
	if (result == MFMailComposeResultSent)
	{
		[UIAlertView alertWithTitle:NSLocalizedString(@"Send email successfully.", nil)];
	}
	else if (result == MFMailComposeResultFailed)
	{
		[UIAlertView alertWithTitle:NSLocalizedString(@"Failed to send email.", nil)];
	}
}

@end


@implementation UIViewController (MailComposer)

#pragma mark Composer methods

// Compose mail
- (BOOL)composeMail:(NSString *)to subject:(NSString *)subject body:(NSString *)body
{
	// Check for email account
	if ([MFMailComposeViewController canSendMail] == NO)
	{
		[UIAlertView alertWithTitle:NSLocalizedString(@"Please setup your email account first.", nil)];
		return NO;
	}
	
	// Display composer
	MailComposer *composer = [[MailComposer alloc] init];
	if (to) [composer setToRecipients:[NSArray arrayWithObject:to]];
	if (subject) [composer setSubject:subject];
	if (body) [composer setMessageBody:body isHTML:[body hasPrefix:@"<"]];
	[self presentModalViewController:composer animated:YES];
	[composer release];
	return YES;
}

- (BOOL)composeMail:(NSString *)to subject:(NSString *)subject body:(NSString *)body attached:(NSData *)data
{
    // Check for email account
	if ([MFMailComposeViewController canSendMail] == NO)
	{
		[UIAlertView alertWithTitle:NSLocalizedString(@"Please setup your email account first.", nil)];
		return NO;
	}
	
	// Display composer
	MailComposer *composer = [[MailComposer alloc] init];
	if (to) [composer setToRecipients:[NSArray arrayWithObject:to]];
	if (subject) [composer setSubject:subject];
	if (body) [composer setMessageBody:body isHTML:[body hasPrefix:@"<"]];
    if (data) [composer addAttachmentData:data mimeType:@"image/jpg" fileName:@"page.png"];
	[self presentModalViewController:composer animated:YES];
	[composer release];
	return YES;
}

@end

