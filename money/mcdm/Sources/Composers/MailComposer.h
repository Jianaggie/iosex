

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


//
@interface MailComposer : MFMailComposeViewController <MFMailComposeViewControllerDelegate>
{
}
@end


//
@interface UIViewController (MailComposer)

- (BOOL)composeMail:(NSString *)to subject:(NSString *)subject body:(NSString *)body;

// just for attachment of jpgs now.
- (BOOL)composeMail:(NSString *)to subject:(NSString *)subject body:(NSString *)body attached:(NSData *)data;

@end
