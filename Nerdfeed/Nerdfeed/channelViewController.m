//
//  channelViewController.m
//  Nerdfeed
//
//  Created by lovocas on 13-11-29.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "channelViewController.h"

@implementation channelViewController

-(id)init
{
    self=[super init];
    if(self)
    {
      //  if([[UIDevice currentDevice]orientation]==UIInterfaceOrientationPortrait)
     //   {
       // listViewController * vc=(listViewController *)[[[self.splitViewController viewControllers]objectAtIndex:0]topViewController];
      //  self.navigationItem.leftBarButtonItem=vc.button;
      //  }
    }
    return self;
}

-(void)listViewController:(listViewController *)lvc handledObject:(id)object
{
    if(![object isKindOfClass:[object class]])
        return;
    channel=object;
    [self.tableView reloadData];
   
     
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"channelCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"channelCell"];
      
    }
    int index =[indexPath row];
    if (index == 0) {
        [[cell textLabel]setText:[channel title]];
    } else {
        [[cell textLabel]setText:[channel infoString]];
    }
    return cell;
}
-(BOOL)shouldAutorotate
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad )
    {
        return  YES;
    }
    return NO;
}
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"list"];
    self.navigationItem.leftBarButtonItem=barButtonItem;
}
-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if(barButtonItem == self.navigationItem.leftBarButtonItem)
    [self.navigationItem setLeftBarButtonItem:Nil];
}
@end
