//
//  JSONSerialization.h
//  Nerdfeed
//
//  Created by lovocas on 13-12-3.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerialization <NSObject>

-(void)readFromDictionary:(NSDictionary *)s;
-(NSDictionary *)getDicFromObject;
@end
