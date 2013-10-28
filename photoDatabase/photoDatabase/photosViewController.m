//
//  photosViewController.m
//  photoDatabase
//
//  Created by lovocas on 13-6-23.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "photosViewController.h"

@interface photosViewController ()

@end

@implementation photosViewController
@synthesize photographer=_photographer;
-(void)setupFetchedRequestResultsController
{
    NSFetchRequest * request =[NSFetchRequest fetchRequestWithEntityName: @"Photo"];
    NSSortDescriptor * sort =[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors =[NSArray arrayWithObject:sort];
    request.predicate =[NSPredicate predicateWithFormat:@"whotook.name =%@",self.photographer.name];
    
    self.fetchedResultsController= [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.photographer.managedObjectContext  sectionNameKeyPath:nil cacheName:nil];

}
-(void)setPhotographer:(Photographer *)photographer
{
    self.debug = YES;
    _photographer=photographer;
    self.title = photographer.name;
    [self setupFetchedRequestResultsController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Photo * photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    // Configure the cell...
    
    return cell;
}


@end
