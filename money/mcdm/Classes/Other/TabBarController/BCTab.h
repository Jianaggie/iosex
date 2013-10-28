
@interface BCTab : UIButton {
	UIImage *background;
	UIImage *rightBorder;
	
	NSString *tabTitle;
}

- (id)initWithIconImageName:(NSString *)imageName andHighlightImg:(NSString *)tabHighlightImg andTitle:(NSString *)title;

@end
