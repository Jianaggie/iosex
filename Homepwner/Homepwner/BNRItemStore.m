//
//  BNRItemStore.m
//  Homepwner
//
//  Created by lovocas on 13-10-31.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "BNRItemStore.h"
#import  "BNRImageStore.h"

@implementation BNRItemStore
+ (BNRItemStore *)sharedStore{
    static BNRItemStore * sharedstore = nil;
    if(!sharedstore){
        sharedstore = [[super allocWithZone:nil]init];
    }
    return sharedstore;
}
+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
-(BOOL) saveChanges
{
    /*NSString * path= [self itemsArchivePath];
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];*/
    NSError * err =nil;
    BOOL successful = [contex save:&err];
    if(!successful)
    {
        NSLog(@"Error saving %@",[err localizedDescription]);
    }
    return  successful;
}
-(id)init
{
    self = [super init];
    if(self){
        /*allItems=[NSKeyedUnarchiver unarchiveObjectWithFile:[self itemsArchivePath]];
        if(!allItems)
        {
            allItems = [[NSMutableArray alloc]init];
        }*/
        model =[NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator * psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        NSString * path =[self itemsArchivePath];
        NSURL *url =[NSURL fileURLWithPath:path];
        NSError  * error =nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
            [NSException raise:@"open failed" format:@"Reason %@",[error localizedDescription]];
        }
        contex =[[NSManagedObjectContext alloc]init];
        [contex setPersistentStoreCoordinator:psc];
        [contex setUndoManager:nil];
        [self loadAllItems];
    }
    return self;
    
}
-(NSString *)itemsArchivePath
{
    NSArray * directories= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * domaindirector=[directories objectAtIndex:0];
    //return [domaindirector stringByAppendingPathComponent:@"items.archive"];
    return [domaindirector stringByAppendingPathComponent:@"store.data"];
   // return  domaindirector;
}
-(NSArray *) allItems{
    return allItems;
}
-(BNRItem *)createItem{
    //BNRItem * item=[BNRItem randomItem];
    double order =0;
    if([allItems count])
    {
        order =[allItems count]+1;
    }
    else
        order =1;
    BNRItem * p =[NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:contex];
    [p setOrderingValue:order];
    [allItems addObject:p];
    return p;
}
-(void)removeItem:(BNRItem *)item
{
    // remove the image
    [[BNRImageStore sharedstore]deleteImageforKey:[item imageKey]];
    [contex deleteObject:item];
    [allItems removeObjectIdenticalTo:item];
}
-(void)moveItemAtIndex:(int )from toIndex:(int) to
{
    if(from == to)
        return;
    BNRItem * p = [allItems objectAtIndex:from];
    [allItems removeObjectAtIndex:from];
    [allItems insertObject:p atIndex:to];
    double lowbounds = 0.0;
    if(to>0)
    {
        lowbounds=[[allItems objectAtIndex:to-1]orderingValue];
    }
    else
    {
        lowbounds =[[allItems objectAtIndex:1]orderingValue]-2.0;
    }
    double highbounds = 0.0;
    if(to<[allItems count]-1 )
    {
        highbounds = [[allItems objectAtIndex:to+1]orderingValue];
   }
   else
   {
       highbounds = [[allItems objectAtIndex:to-1]orderingValue]+2;
    }
    double value = (lowbounds +highbounds)/2;
    [p setOrderingValue:value];
                    
}
-(NSArray *)allAssetItems
{
    if(!allAssetItems){
    NSFetchRequest * request =[[NSFetchRequest alloc]init];
    NSEntityDescription * e =[NSEntityDescription entityForName:@"BNRAssetType" inManagedObjectContext:contex];
    [request setEntity:e];
    NSError * error;
    NSArray * array=[contex executeFetchRequest:request error:&error];
    if(!array)
    {
        [NSException raise:@"excute fail" format:@"reason is %@",[error localizedDescription] ];
    }
    allAssetItems = [array mutableCopy];
    }
    if(![allAssetItems count])
    {
        NSManagedObject * p =[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:contex];
        [p setValue:@"Furniture" forKey:@"lable"];
        [allAssetItems addObject:p];
        p =[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:contex];
        [p setValue:@"Jewery" forKey:@"lable"];
        [allAssetItems addObject:p];
         p =[NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:contex];
        [p setValue:@"Electronic" forKey:@"lable"];
        [allAssetItems addObject:p];
    }
    return  allAssetItems;
    
}
-(void)loadAllItems
{
    if (!allItems) {
        //set the items
        NSFetchRequest * request=[[NSFetchRequest alloc]init];
        NSEntityDescription * e =[[model entitiesByName]objectForKey:@"BNRItem"];
        [request setEntity:e];
        NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sort]];
        NSError * error;
        NSArray * result = [contex executeFetchRequest:request error:&error];
        if(!result)
        {
            [NSException raise:@"fetch fail" format:@"reason is %@",[error localizedDescription]];
        }
        allItems = [[NSMutableArray alloc]initWithArray:result];
    }
}
@end
