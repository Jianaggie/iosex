//
//  faceView.h
//  happiness
//
//  Created by lovocas on 13-5-19.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class faceView;
@protocol viewDataSource <NSObject>

-(float) setSmileness:(faceView *)sender ;
@end
@interface faceView : UIView
@property (nonatomic )CGFloat scale;
@property (nonatomic) id<viewDataSource> dataSourceDele;
- (void)pinch:(UIPinchGestureRecognizer *)recognizer;

@end
