//
//  AppDetailController.h
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PredictScrollViewDelegate;

@interface AppDetailController : UIViewController <PredictScrollViewDelegate>
{
    NSDictionary *_appInfo;
}

- (id)initWithInfo:(NSDictionary *)info;

@end
