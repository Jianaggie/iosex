
#import <UIKit/UIKit.h>

//
@interface TouchImageView : UIImageView
{
	BOOL _down;
	id _target;
	SEL _action;
    
    UIImageView *overlay;
}

@property (nonatomic) BOOL down;

- (void)addTarget:(id)target action:(SEL)action;
- (void)setClickOverlayMask:(UIImage *)mask;

@end

@interface MultiLayerTouchImageView : TouchImageView
{
    UIImageView *background;
    UIImageView *maskLayer;
    UIView *shadowLayer;
    
    BOOL shadowBeAdded;
    BOOL backgroundBeAdded;
}

@property (nonatomic, readonly) UIImageView *background;
@property (nonatomic, readonly) UIImageView *maskLayer;
@property (nonatomic, readonly) UIView *shadowLayer;

@end
