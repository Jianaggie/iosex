//
//  BNRItemStore.m
//  Homepwner
//
//  Created by lovocas on 13-10-31.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "BNRItemStore.h"

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
-(id)init
{
    self = [super init];
    if(self){
        if(!allItems)
        {
            allItems = [[NSMutableArray alloc]init];
        }
    }
    return self;
    
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
    [allItems removeObject:item];
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
