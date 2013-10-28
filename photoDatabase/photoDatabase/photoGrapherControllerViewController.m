//
//  photoGrapherControllerViewController.m
//  photoDatabase
//
//  Created by lovocas on 13-6-23.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "photoGrapherControllerViewController.h"

#import "Photo+createPhoto.h"
#import "Photographer.h"
#import "photosViewController.h"

@interface photoGrapherControllerViewController ()

@end

@implementation photoGrapherControllerViewController

@synthesize photoDatabaseDocument = _photoDatabaseDocument;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photographerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
         Photographer * photographer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photographer.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos",[photographer.photos count]];
    return cell;
}
-(void)setupFetchedResultController{

    NSFetchRequest * request =[NSFetchRequest fetchRequestWithEntityName: @"Photographer"];
    NSSortDescriptor * sort =[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors =[NSArray arrayWithObject:sort];

    self.fetchedResultsController= [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.photoDatabaseDocument.managedObjectContext  sectionNameKeyPath:nil cacheName:nil];
      
}
-(void)fetchFlicekerDataInDocument:(UIManagedDocument * )document {
    dispatch_queue_t fetchQ= dispatch_queue_create("flicker fetcher", NULL);
    dispatch_async(fetchQ, ^{
        //
        NSArray * photos = [FlickrFetcher latestGeoreferencedPhotos];
        [document.managedObjectContext performBlock:^{
            for(NSDictionary * fetchPhotoInfo in photos)
            {
                [Photo createPhoto:fetchPhotoInfo inManagedObject:document.managedObjectContext];
            }
        }];
        //dispatch_release(fetchQ);
 //NSPersistentStoreCoordinator
    });
    
   // dispatch_release(fetchQ);
    
       
}
-(void)useDocument{
    NSLog(@"database path is %@， the result is %d",[self.photoDatabaseDocument.fileURL path],[[NSFileManager defaultManager]fileExistsAtPath: [self.photoDatabaseDocument.fileURL path]]);
    if(![[NSFileManager defaultManager]fileExistsAtPath: [self.photoDatabaseDocument.fileURL path]])
    {
        [self.photoDatabaseDocument saveToURL:self.photoDatabaseDocument.fileURL forSaveOperation:UIDocumentSaveForCreating  completionHandler:^(BOOL success) {
            [self  setupFetchedResultController];
            [self fetchFlicekerDataInDocument:self.photoDatabaseDocument];
        }];
    }
    else if(self.photoDatabaseDocument.documentState == UIDocumentStateClosed){
        [self.photoDatabaseDocument openWithCompletionHandler:^(BOOL success) {
           [self  setupFetchedResultController];
           // [self fetchFlicekerDataInDocument:self.photoDatabaseDocument];
        }];
    }
    else if (self.photoDatabaseDocument.documentState == UIDocumentStateNormal){
        [self  setupFetchedResultController];
       //[self fetchFlicekerDataInDocument:self.photoDatabaseDocument];
    }
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.debug =YES;
    if(!self.photoDatabaseDocument){
    NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask ] lastObject];
    NSLog(@"photoDatabaseDocument is %@",[url absoluteString]);

   url = [url  URLByAppendingPathComponent:@"default photo Databases"];
    NSLog(@"photoDatabaseDocument is %@",[url absoluteString]);
        
    self.photoDatabaseDocument = [[UIManagedDocument alloc]initWithFileURL:url ];
    }
   // NSLog(@"photoDatabaseDocument is %@",[url absoluteString]);
    //self.tableView.delegate = self;
    
}
-(void)setPhotoDatabaseDocument:(UIManagedDocument *)photoDatabaseDocument
{
    if(_photoDatabaseDocument !=photoDatabaseDocument)
    {
        _photoDatabaseDocument = photoDatabaseDocument;
        [self useDocument];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath * indexpath = [self.tableView indexPathForCell:sender];
    Photographer * photographer = [self.fetchedResultsController objectAtIndexPath:indexpath];
    if([segue.destinationViewController respondsToSelector:@selector(setPhotographer:)]){
        [segue.destinationViewController  setPhotographer:photographer];
    }
}
@end
