
#import <UIKit/UIKit.h>

@protocol TaskDelegate;

@class NewsItemWebView;

//
@interface NewsReader : UIViewController <TaskDelegate>
{
	NSDictionary *_newsItem;
    
    NSString *_newsId;
    
    NewsItemWebView *_itemView;
}

- (id)initWithNewsId:(NSString *)newsId;

@end
