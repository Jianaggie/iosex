//
//  BNRItemStore.h
//  Homepwner
//
//  Created by lovocas on 13-10-31.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import <CoreData/CoreData.h>

@interface BNRItemStore : NSObject
{
    NSMutableArray * allItems;
    NSMutableArray * allAssetItems;
    NSManagedObjectContext * contex;
    NSManagedObjectModel * model;
}
+ (BNRItemStore *)sharedStore;
- (NSArray *)allItems;
- (NSArray * )allAssetItems;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
-(void)moveItemAtIndex:(int )from toIndex:(int) to;
-(BOOL) saveChanges;
-(void)loadAllItems;
@end
