//
//  Photo+createPhoto.h
//  photoDatabase
//
//  Created by lovocas on 13-6-24.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "Photo.h"
#import "FlickrFetcher.h"
#import "Photographer+createPhotographer.h"

@interface Photo (createPhoto)
+(Photo *)createPhoto:(NSDictionary *) photo inManagedObject:(NSManagedObjectContext *)context;
@end
