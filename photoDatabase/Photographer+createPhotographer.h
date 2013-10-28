//
//  Photographer+createPhotographer.h
//  photoDatabase
//
//  Created by lovocas on 13-6-24.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "Photographer.h"
#import "FlickrFetcher.h"

@interface Photographer (createPhotographer)
+(Photographer *)createPhotographer:(NSDictionary *) photo inManagedObject:(NSManagedObjectContext *)context;
@end
