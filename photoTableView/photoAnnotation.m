//
//  photoAnnotation.m
//  photoTableView
//
//  Created by lovocas on 13-6-11.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "photoAnnotation.h"
#import "FlickrFetcher.h"
@implementation photoAnnotation

@synthesize photo =_photo;

+(photoAnnotation *)createPhotoAnnotation:(NSDictionary *)photo
{
    photoAnnotation * annotation = [[photoAnnotation alloc]init];
    annotation.photo = photo;
    return annotation;
}
-(NSString * )title
{
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}
-(NSString *)subtitle
{
    return [self.photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
}
-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE]doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE]doubleValue];
    return coordinate;
    
}
@end
