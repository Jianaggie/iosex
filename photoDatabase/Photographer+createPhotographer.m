//
//  Photographer+createPhotographer.m
//  photoDatabase
//
//  Created by lovocas on 13-6-24.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "Photographer+createPhotographer.h"


@implementation Photographer (createPhotographer)
+(Photographer *)createPhotographer:(NSDictionary *) photo inManagedObject:(NSManagedObjectContext *)context{
       
    
    Photographer*  photographer = nil;
    NSFetchRequest * request =[NSFetchRequest fetchRequestWithEntityName: @"Photographer"];
    NSSortDescriptor * sort =[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.predicate =[NSPredicate predicateWithFormat:@"name =%@",[photo objectForKey:FLICKR_PHOTO_OWNER]];

    request.sortDescriptors =[NSArray arrayWithObject:sort];
    NSError * error =nil;
    NSArray * matches =[context executeFetchRequest:request error:&error];
    if(!matches||[matches count]>1){
        
    }else if([matches count] ==0){
         photographer=[NSEntityDescription insertNewObjectForEntityForName :@"Photographer" inManagedObjectContext : context];
        photographer.name = [photo objectForKey: FLICKR_PHOTO_OWNER];

               
    }else if ([matches count] ==1){
        photographer = [matches lastObject];
    }
        return photographer;
}
@end
