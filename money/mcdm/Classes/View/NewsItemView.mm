
#import "AppDelegate.h"
#import "NewsItemView.h"


//
@implementation NewsItemView
@synthesize controller;

//
- (id)initWithItem:(NewsItem *)item frame:(CGRect)frame
{
	_item = [item retain];
	[super initWithFrame:frame];
	self.backgroundColor = [UIColor whiteColor];

	// Title
	titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	//titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	titleLabel.text = item.title;
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.numberOfLines = 0;
	[self addSubview:titleLabel];

	// Author & Date
	authorLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	//authorLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	authorLabel.text = [NSString stringWithFormat:@"%@  %@", item.source, item.pubDate];
	authorLabel.textColor = [UIColor darkGrayColor];
	authorLabel.backgroundColor = [UIColor clearColor];
	authorLabel.adjustsFontSizeToFitWidth = YES;
	[self addSubview:authorLabel];
    
    line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellSepLine.png"]];
    line.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:[line autorelease]];

	// Image
    if ([item.iconUrl length])
    {
        imageView = [[[DelayImageView alloc] initWithUrl:nil frame:CGRectMake(0, 0, 320, 180)] autorelease];
        imageView.image = [UIImage imageNamed:@"Photo.png"];
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
    }

	// Text
	contentLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	contentLabel.text = item.description;
	contentLabel.textColor = [UIColor blackColor];
	contentLabel.backgroundColor = [UIColor clearColor];
	contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:18];
	[self addSubview:contentLabel];

	return self;
}

- (void)dealloc
{
    [_item release];
    [super dealloc];
}

#pragma mark Touch image view methods

//
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGSize size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width - 20, 1000)];
	titleLabel.frame = CGRectMake(10, 10, self.frame.size.width - 20, size.height);
	
	authorLabel.frame = CGRectMake(10, 10 + titleLabel.frame.size.height, titleLabel.frame.size.width - 60, 30);
    
    line.frame = CGRectMake(10, authorLabel.frame.origin.y + authorLabel.frame.size.height, titleLabel.frame.size.width, 1);
	
    if (imageView)
	{
		CGFloat width = MIN(self.frame.size.width - 20, 320);
		CGFloat height = 160;//180;
		imageView.frame = CGRectMake((self.frame.size.width - width) / 2,
									 authorLabel.frame.origin.y + authorLabel.frame.size.height + 10,
									 width,
									 height);
	}
    
	size = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(self.frame.size.width - 20, 1000)];
	CGFloat y = imageView ? (imageView.frame.origin.y + imageView.frame.size.height + 10) : (authorLabel.frame.origin.y + authorLabel.frame.size.height + 10);
	contentLabel.frame = CGRectMake(10, y, self.frame.size.width - 20, size.height);
	self.contentSize = CGSizeMake(self.frame.size.width, contentLabel.frame.origin.y + contentLabel.frame.size.height + 10);
}

//
- (CGFloat)fontSize
{
	return contentLabel.font.pointSize;
}

//
- (void)setFontSize:(CGFloat)fontSize
{
	titleLabel.font = [UIFont boldSystemFontOfSize:18];
	authorLabel.font = [UIFont systemFontOfSize:14];
	contentLabel.font = [UIFont systemFontOfSize:fontSize];
	[self layoutSubviews];
}

@end
