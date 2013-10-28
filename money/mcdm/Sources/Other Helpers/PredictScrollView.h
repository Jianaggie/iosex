
#import <UIKit/UIKit.h>
#import "UICustomPageControl.h"

//
@class PredictScrollView;
@protocol PredictScrollViewDelegate <NSObject>
@required
- (UIView *)scrollView:(PredictScrollView *)scrollView viewForPage:(NSUInteger)index inFrame:(CGRect)frame;
- (void)scrollView:(PredictScrollView *)scrollView scrollToPage:(NSUInteger)index;

@optional
- (void)scrollViewWillBeginDragging;
- (void)scrollViewDidEndDecelerating;

@end


//
@interface PredictScrollView : UIScrollView <UIScrollViewDelegate>
{
	BOOL bIgnore;
	UIView **_pages;
	NSInteger _currentPage;
	NSUInteger _numberOfPages;
	id<PredictScrollViewDelegate> _delegate2;
    
    CGFloat _leftRightPad;
}

@property(nonatomic,readonly) UIView **pages;
@property(nonatomic,readonly) UIView *currentPageView;
@property(nonatomic,readonly) UIView *previousPageView;
@property(nonatomic,readonly) UIView *nextPageView;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,assign) NSUInteger numberOfPages;
@property(nonatomic,assign) id<PredictScrollViewDelegate> delegate2;

- (id)initWithFrame:(CGRect)frame leftRightPad:(CGFloat)pad;

// refresh, current, previous, next,
- (void)refreshCurrentPage;
- (void)scrollToNextOrPrevPage:(BOOL)next;

- (void)removeAllPages;

@end


//
@interface PageControlScrollView : PredictScrollView
{
	BOOL _hasParent;
	SuperPageControl *_pageCtrl;
}
@property(nonatomic,readonly) SuperPageControl *pageCtrl;

- (void)alignDotsToRight;
- (void)alignDotsToLeft;

@end
