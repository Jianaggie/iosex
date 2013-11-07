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
    NSString * path= [self itemsArchivePath];
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}
-(id)init
{
    self = [super init];
    if(self){
        allItems=[NSKeyedUnarchiver unarchiveObjectWithFile:[self itemsArchivePath]];
        if(!allItems)
        {
            allItems = [[NSMutableArray alloc]init];
        }
    }
    return self;
    
}
-(NSString *)itemsArchivePath
{
    NSArray * directories= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * domaindirector=[directories objectAtIndex:0];
    return [domaindirector stringByAppendingPathComponent:@"items.archive"];
   // return  domaindirector;
}
-(NSArray *) allItems{
    return allItems;
}
-(BNRItem *)createItem{
    BNRItem * item=[BNRItem randomItem];
    [allItems addObject:item];
    return item;
}
-(void)removeItem:(BNRItem *)item
{
    // remove the image
    [[BNRImageStore sharedstore]deleteImageforKey:[item imageKey]];
    [allItems removeObjectIdenticalTo:item];
}
-(void)moveItemAtIndex:(int )from toIndex:(int) to
{
    if(from == to)
        return;
    BNRItem * p = [allItems objectAtIndex:from];
    [allItems removeObjectAtIndex:from];
    [allItems insertObject:p atIndex:to]; 
}
@end
