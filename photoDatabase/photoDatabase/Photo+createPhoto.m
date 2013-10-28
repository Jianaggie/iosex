//
//  Photo+createPhoto.m
//  photoDatabase
//
//  Created by lovocas on 13-6-24.
//  Copyright (c) 2013年 maggie. All rights reserved.
//


#import "Photo+createPhoto.h"



@implementation Photo (createPhoto)
+(Photo *)createPhoto:(NSDictionary *) photo inManagedObject:(NSManagedObjectContext *)context
{
    Photo*  photoEntity = nil;
    NSFetchRequest * request =[NSFetchRequest fetchRequestWithEntityName: @"Photo"];
    NSSortDescriptor * sort =[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.predicate =[NSPredicate predicateWithFormat:@"uniqueId =%@",[photo objectForKey:FLICKR_PHOTO_ID]];
    request.sortDescriptors =[NSArray arrayWithObject:sort];
    NSError * error =nil;
    NSArray * matches =[context executeFetchRequest:request error:&error];
    if(!matches||[matches count]>1){
        
    }else if([matches count] ==0){
        photoEntity=[NSEntityDescription insertNewObjectForEntityForName :@"Photo" inManagedObjectContext : context];
        photoEntity.title = [photo objectForKey: FLICKR_PHOTO_TITLE];
        photoEntity.subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photoEntity.uniqueId = [photo objectForKey:FLICKR_PHOTO_ID];
        photoEntity.imageurl = [[FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge] absoluteString];
        photoEntity.whotook = [Photographer createPhotographer:photo inManagedObject:context];

    }else if ([matches count] ==1){
        photoEntity = [matches lastObject];
    }
    return  photoEntity;
}
@end
