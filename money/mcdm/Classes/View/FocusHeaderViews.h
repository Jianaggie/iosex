//
//  FocusHeaderImageNewsView.h
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PredictScrollView.h"

@interface FocusHeaderImageNewsView : UIView <PredictScrollViewDelegate>
{
	NSArray *newsArray;
	PredictScrollView *_scrollView;
	
	UIViewController *container;
}

@property (nonatomic, retain) NSArray *newsArray;
@property (nonatomic, assign) UIViewController *container;

@end

@interface FocusHeaderAppView : UIView <PredictScrollViewDelegate>
{
	NSArray *_array;
	PredictScrollView *_scrollView;
	
	UIViewController *container;
}

@property (nonatomic, retain) NSArray *newsArray;
@property (nonatomic, assign) UIViewController *container;

@end
