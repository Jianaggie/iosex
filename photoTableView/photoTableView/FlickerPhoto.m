//
//  FlickerPhoto.m
//  photoTableView
//
//  Created by lovocas on 13-6-4.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "FlickerPhoto.h"
#import "FlickrFetcher.h"
#import "mapViewController.h"
#import "photoAnnotation.h"
@interface FlickerPhoto() <mapViewControllDelegate>

@end

@implementation FlickerPhoto 

@synthesize  photo = _photo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSArray * )mapAnnotation
{
    NSMutableArray * annotations = [[NSMutableArray arrayWithCapacity:self.photo.count]init];
    for(NSDictionary * eachPhoto in self.photo){
        photoAnnotation * annotation =[photoAnnotation createPhotoAnnotation:eachPhoto];
        [annotations addObject:annotation];
        
    }
    return  [annotations copy];
}
-(void)updateSpiltDetail
{
    mapViewController * mVc ;
    id detailView = [self.splitViewController.viewControllers lastObject];
    if([detailView isKindOfClass :[mapViewController class]])
    {
        mVc = (mapViewController *)detailView;
        mVc.imagedelegate = self;
        mVc.annotationArray = [self mapAnnotation];
    }
    
}
-(UIImage *)mapViewController:(mapViewController *)sender imageforAnnotation:(id<MKAnnotation>)annotation
{
    photoAnnotation * pa = (photoAnnotation*)annotation;
    NSURL* url = [FlickrFetcher urlForPhoto:pa.photo format:FlickrPhotoFormatSquare];
    NSData *data =[NSData dataWithContentsOfURL:url];
   // NSLog(@"data is %@",data);
    return  data ?[UIImage imageWithData:data]:nil;
    
}
-(void)setPhoto:(NSArray *)photo{
    if(_photo!=photo){

            _photo=photo;
        [self updateSpiltDetail];
        [self.tableView reloadData];
        }
}
- (IBAction)refresh:(id)sender {

    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:spinner];
    dispatch_queue_t  download = dispatch_queue_create("download photo", NULL);
    dispatch_async(download, ^{
        
        NSArray * photo =[FlickrFetcher latestGeoreferencedPhotos] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem=sender;
            //self.photo= photo;
            [self setPhoto:photo];

        });
    });
    
    //dispatch_release(download);
    NSLog(@"HELLO");
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//load the photo
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.photo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"flicker photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary * fliker = [self.photo  objectAtIndex:indexPath.row];
    cell.textLabel.text =[fliker objectForKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [fliker objectForKey:FLICKR_PHOTO_OWNER];
                
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
