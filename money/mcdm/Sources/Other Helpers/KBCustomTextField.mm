

#import "KBCustomTextField.h"


@implementation KBCustomTextField
@synthesize kbDelegate=_kbDelegate;

//
- (BOOL)becomeFirstResponder
{
	BOOL ret = [super becomeFirstResponder];
	
	if (_kbDelegate)
	{
		[_kbDelegate keyboardShow:self];
	}
	else
	{
		[self modifyKeyView:@"NumberPad-Empty" display:@"." represent:@"." interaction:@"String"];
	}
	return ret;
}

//
- (BOOL)resignFirstResponder
{
	BOOL ret = [super resignFirstResponder];
	
	if (_kbDelegate)
	{
		[_kbDelegate keyboardHide:self];
	}
	else
	{
		[self modifyKeyView:@"NumberPad-Empty" display:nil represent:nil interaction:@"None"];
	}
	
	return ret;
}

//
- (void)logKeyView:(UIKBKeyView *)view
{
	NSLog(@"\tname=%@"
		  @"\trepresentedString=%@"
		  @"\tdisplayString=%@"
		  @"\tdisplayType=%@"
		  @"\tinteractionType=%@"
		  //@"\tvariantType=%@"
		  //@"\tvisible=%u"
		  //@"\tdisplayTypeHint=%d"
		  @"\tdisplayRowHint=%@"
		  //@"\toverrideDisplayString=%@"
		  //@"\tdisabled=%d"
		  //@"\thidden=%d\n"
		  
		  ,view.key.name
		  ,view.key.representedString
		  ,view.key.displayString
		  ,view.key.displayType
		  ,view.key.interactionType
		  //,view.key.variantType
		  //,view.key.visible
		  //,view.key.displayTypeHint
		  ,view.key.displayRowHint
		  //,view.key.overrideDisplayString
		  //,view.key.disabled
		  //,view.key.hidden
		  );
}

//
- (UIKBKeyView *)findKeyView:(NSString *)name inView:(UIView *)view
{
	for (UIKBKeyView *subview in view.subviews)
	{
		NSString *className = NSStringFromClass([subview class]);

//#define _LOG_KEY_VIEW
#ifdef _LOG_KEY_VIEW
		NSLog(@"Found View: %@\n", className);
		if ([className isEqualToString:@"UIKBKeyView"])
		{
			[self logKeyView:subview];
		}
#else
		if ([className isEqualToString:@"UIKBKeyView"])
		{
			if ((name == nil) || [subview.key.name isEqualToString:name])
			{
				return subview;
			}
		}
#endif
		else if (UIKBKeyView *subview2 = [self findKeyView:name inView:subview])
		{
			return subview2;
		}
	}
	return nil;
}

//
- (UIKBKeyView *)findKeyView:(NSString *)name
{
	UIWindow* window = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	return [self findKeyView:name inView:window];
}

//
- (UIKBKeyView *)modifyKeyView:(NSString *)name display:(NSString *)display represent:(NSString *)represent interaction:(NSString *)type
{
	UIKBKeyView *view = [self findKeyView:name];
	if (view)
	{	
		view.key.representedString = represent;
		view.key.displayString = display;
		view.key.interactionType = type;
		[view setNeedsDisplay];
	}
	return view;
}

//
- (UIKBKeyView *)addCustomButton:(NSString *)name title:(NSString *)title target:(id)target action:(SEL)action
{
	UIKBKeyView *view = [self findKeyView:name];
	if (view)
	{
		UIButton *button = [[UIButton alloc] initWithFrame:view.frame];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
		[button setTitle:title forState:UIControlStateNormal];
		[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
		[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		button.showsTouchWhenHighlighted = YES;
		[view.superview addSubview:button];
		view.tag = (NSInteger)button;
		[button release];
	}
	return view;
}

//
- (UIKBKeyView *)delCustomButton:(NSString *)name
{
	UIKBKeyView *view = [self findKeyView:name];
	if (view)
	{
		[(UIButton *)view.tag removeFromSuperview];
		view.tag = 0;
	}
	return view;
}

@end
