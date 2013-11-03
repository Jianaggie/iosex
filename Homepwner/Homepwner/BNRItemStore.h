//
//  BNRItemStore.h
//  Homepwner
//
//  Created by lovocas on 13-10-31.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

@interface BNRItemStore : NSObject
{
    NSMutableArray * allItems;
}
+ (BNRItemStore *)sharedStore;
- (NSArray *)allItems;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
-(void)moveItemAtIndex:(int )from toIndex:(int) to;
@end
