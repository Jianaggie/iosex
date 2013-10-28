//
//  happinessViewController.h
//  happiness
//
//  Created by lovocas on 13-5-19.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "faceView.h"
#import "spiltBarButtonItemPresenter.h"
@interface happinessViewController : UIViewController 

@property (nonatomic) int happiness;
@property (weak, nonatomic) IBOutlet faceView* faceview;
@property(nonatomic,weak) UIBarButtonItem * spiltBarButtonItem;

- (void)handlerPanGesture:(UIPanGestureRecognizer *)recognizer;

- (IBAction)addToMyDream:(id)sender;
@end
