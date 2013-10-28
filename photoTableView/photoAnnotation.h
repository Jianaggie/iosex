//
//  photoAnnotation.h
//  photoTableView
//
//  Created by lovocas on 13-6-11.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mapkit/Mapkit.h"

@interface photoAnnotation : NSObject<MKAnnotation>
@property (nonatomic,strong) NSDictionary * photo;

+(photoAnnotation *)createPhotoAnnotation:(NSDictionary *)photo;


@end
