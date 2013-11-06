        //
//  ItemsViewController.m
//  Homepwner
//
//  Created by lovocas on 13-10-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "ItemsViewController.h"
#import "NavigationController.h"

@implementation ItemsViewController

//@synthesize  headerView=_headerView;
-(id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        [self.navigationItem setTitle:@"Homepwner"];
       /* for(int i =0 ;i<5;i++)
        {
            [[BNRItemStore sharedStore]createItem];
        }*/
        UIBarButtonItem * barButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        [self.navigationItem setRightBarButtonItem:barButtonItem ];
        [self.navigationItem setLeftBarButtonItem:[self editButtonItem]];
    }
   
    return self;
}
/*
-(UIView *)headerView
{
    if(!_headerView)
    {
        [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerView;
}*/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController * detailviewController = [[DetailViewController alloc]initForNewItem:NO];
     [detailviewController setItem:[[[BNRItemStore sharedStore]allItems] objectAtIndex:[indexPath row]]];
    [[self navigationController] pushViewController:detailviewController animated:YES];
   
}


-(void)addNewItem:(id)sender{
    BNRItem * item =[[BNRItemStore sharedStore]createItem ];
   /* int lastrow = [[[BNRItemStore sharedStore]allItems] indexOfObject:item];
    NSIndexPath * ip= [NSIndexPath indexPathForRow:lastrow inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];*/
    DetailViewController * detailcontroller = [[DetailViewController alloc]initForNewItem:YES];
    [detailcontroller setItem:item];
    
    [detailcontroller setReloadBlock:^{[[self tableView]reloadData];}];
     
     NavigationController *nav = [[NavigationController alloc]initWithRootViewController:detailcontroller];
    //[nav setModalPresentationStyle:UIModalPresentationFormSheet];
    //[nav setModalPresentationStyle:UIModalPresentationCurrentContext];
    //[nav setDefinesPresentationContext:YES];
    [nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    //[nav setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        BNRItem * item = [[[BNRItemStore sharedStore]allItems] objectAtIndex:[indexPath row]];
        [[BNRItemStore sharedStore]removeItem:item];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{

    [[BNRItemStore sharedStore]moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  [self.headerView bounds].size.height;
}*/
/*-(void)viewDidAppear:(BOOL)animated{
    UIImage *image = [UIImage imageNamed:@"mypic2.jpg"];
    UIImageView *backgroundview = [[UIImageView alloc]initWithImage:image];
    [self.tableView setBackgroundView:backgroundview];
}
*/
-(id) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

/*-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray * temp = [[NSArray alloc]initWithObjects:@">50",@"<50" ,nil];
    return temp;
}
*/
/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
*/
/*
-(void)toggleEditingMode:(id)sender
{
    if([self isEditing]){
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    }
    else{
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
        
}
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    int count=0;
    for(int i=0;i<5;i++)
        if([[[[BNRItemStore sharedStore]allItems] objectAtIndex:i] valueInDollars]>50)
            count++;
    if(section ==0)
    {
        return count+1;
    }
    else
        return  5-count+1;
     */
    return [[[BNRItemStore sharedStore]allItems]count];
}
/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section1 = [self tableView:tableView numberOfRowsInSection:[indexPath section]];
    if([indexPath row] < section1-1)
        return 60;
    else
        return 44;
}*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a cell
    //set the cell textlabel
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableviewcell"];
    if(!cell){
          cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableviewcell"];
    }
   /* int section1=-1;
    int section2=-1;
    int index = [indexPath row];
    BNRItem * item;
    if([indexPath section]==0){
        for(int i=0;i<5;i++){
            if([[[[BNRItemStore sharedStore]allItems] objectAtIndex:i] valueInDollars]>50)
                section1++;
            if(section1 == index){
                item =[[[BNRItemStore sharedStore]allItems] objectAtIndex:i];
                break;
            }
        }
         
    }
    else{
        for(int i=0;i<5;i++){
            if([[[[BNRItemStore sharedStore]allItems] objectAtIndex:i] valueInDollars]<50)
                section2++;
            if(section2 == index){
                item =[[[BNRItemStore sharedStore]allItems] objectAtIndex:i];
                break;
                
            }
        }

    }
        
if(item){
        [cell.textLabel setText:[item description]];
        [cell.textLabel setFont:[UIFont fontWithName:@"big" size:40] ];
}
else{
        [cell.textLabel setText:@"no more items!"];
        [cell.textLabel setFont:[UIFont fontWithName:@"small" size:20] ];
}*/
    BNRItem * item;
            item =[[[BNRItemStore sharedStore]allItems] objectAtIndex:[indexPath row] ];
    if(item)
        [cell.textLabel setText:[item description]];

    return  cell;
    
}
 

@end
