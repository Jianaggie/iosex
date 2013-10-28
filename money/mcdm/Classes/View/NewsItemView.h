

#import <UIKit/UIKit.h>
#import "NewsItem.h"

//
@interface NewsItemView : UIScrollView// <TouchViewDelegate>
{
	NewsItem *_item;
	UILabel *titleLabel;
	UILabel *authorLabel;
    UIImageView *line;
	DelayImageView *imageView;
	UILabel *contentLabel;
	
	//TouchDelayImageView *logo;
	
	UIViewController *controller;
}

@property(nonatomic,assign) CGFloat fontSize;
@property(nonatomic,assign) UIViewController *controller;

- (id)initWithItem:(NewsItem *)item frame:(CGRect)frame;

@end
