//
//  Photo.h
//  photoDatabase
//
//  Created by lovocas on 13-6-24.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * imageurl;
@property (nonatomic, retain) Photographer *whotook;

@end
