
#import <UIKit/UIKit.h>

//
@class SelectController;
@protocol SelectControllerDelegate
- (BOOL)didSelect:(SelectController *)controller andSelect:(NSUInteger)select;
@end

//
@interface SelectController : UITableViewController 
{
	NSArray *_array;
	NSUInteger _selectedIndex;
	NSUInteger _tag;
	
	id<SelectControllerDelegate> _delegate;
}

@property(nonatomic) NSUInteger tag;
@property(nonatomic,assign) id<SelectControllerDelegate> delegate;
@property(nonatomic) NSUInteger selectedIndex;

- (id)initWithArray:(NSArray *)array andSelect:(NSUInteger)select;


@end
