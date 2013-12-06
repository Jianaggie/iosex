//
//  BNRFeedStore.h
//  Nerdfeed
//
//  Created by lovocas on 13-12-3.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <CoreData/CoreData.h>
#import  "RSChannel.h"
#import  "RSItem.h"
#import "BNRConnection.h"
#import  "JSONSerialization.h"
@interface BNRFeedStore : NSObject
{
    NSManagedObjectContext * context;
    NSManagedObjectModel * model;
}
@property (nonatomic,strong)NSDate * topSongsCahceDate;

+(BNRFeedStore *)sharedStore;

-(void)fetchTopsongs:(int)count WithCompletion:(void(^)(RSChannel * channel,NSError * error))block;
-(RSChannel*)fetchRSSFeedWithCompletion:(void(^)(RSChannel * channel,NSError * error))block;
-(void)markItemAsRead:(RSItem *)item;
-(BOOL)hasItembeenRead:(RSItem * )item;
@end
