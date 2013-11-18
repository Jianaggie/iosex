//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by lovocas on 13-11-18.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "AssetTypePicker.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
@implementation AssetTypePicker
@synthesize item;
-(id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
    
   
}

-(id) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore]allAssetItems]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"UITableviewCell"];
    if(!cell)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableviewCell"];
        
    }
    NSManagedObject * assetItem = [[[BNRItemStore sharedStore]allAssetItems]objectAtIndex:[indexPath row]];
    [[cell textLabel]setText:[assetItem valueForKey:@"lable"]];
    if([item assetType]==assetItem)
        [cell  setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    if([item assetType] !=[[[BNRItemStore sharedStore]allAssetItems]objectAtIndex:[indexPath row]])
    {
        item.assetType=[[[BNRItemStore sharedStore]allAssetItems]objectAtIndex:[indexPath row]];
    }
    [self.navigationController  popViewControllerAnimated:YES];
    
}

@end
