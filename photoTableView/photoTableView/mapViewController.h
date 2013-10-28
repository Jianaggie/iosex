//
//  mapViewController.h
//  photoTableView
//
//  Created by lovocas on 13-6-9.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
@class mapViewController;
@protocol mapViewControllDelegate <NSObject>

-(UIImage *)mapViewController:(mapViewController*) sender imageforAnnotation:(id< MKAnnotation>)annotation;



@end
@interface mapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic,strong) NSArray * annotationArray;
@property (nonatomic , weak) id<mapViewControllDelegate>  imagedelegate;
@end
