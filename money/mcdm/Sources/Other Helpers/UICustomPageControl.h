
#import <UIKit/UIKit.h>

@interface UICustomPageControl : UIControl 
{
@private
    NSMutableArray* _indicatorImageViews;
    NSInteger       _currentPage;
    NSInteger       _numberOfPages;
	
	NSInteger		_gap;
	
}

@property(nonatomic) NSInteger numberOfPages;
@property(nonatomic) NSInteger currentPage;

//
- (id)initWithFrame:(CGRect)frame;

@end


@interface SuperPageControl : UIPageControl 
{
	id colorOrImageForStateNormal;
	id colorOrImageForStateHightlighted;
}

@property (nonatomic, retain) id colorOrImageForStateNormal;
@property (nonatomic, retain) id colorOrImageForStateHightlighted;

@end