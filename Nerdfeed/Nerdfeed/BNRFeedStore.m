//
//  BNRFeedStore.m
//  Nerdfeed
//
//  Created by lovocas on 13-12-3.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "BNRFeedStore.h"

@implementation BNRFeedStore
@synthesize topSongsCahceDate;
-(id)init
{
    self =[super init];
    if(self)
    {
        model =[NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator * psc =[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        NSString * path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        path =[path stringByAppendingString:@"feed.db"];
        NSURL * url =[NSURL fileURLWithPath:path];
        NSError * error =nil;
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
        {
            [NSException raise:@"open failed" format:@"raise error :%@",[error localizedDescription]];
        }
        context =[[NSManagedObjectContext alloc]init];
        [context setPersistentStoreCoordinator:psc];
        [context setUndoManager:nil];
    }
    return self;
}
-(void)markItemAsRead:(RSItem *)item
{
    if([self hasItembeenRead:item])
        return;
    NSManagedObject * entity =[NSEntityDescription  insertNewObjectForEntityForName:@"Link" inManagedObjectContext:context];
    [entity setValue:[item link ] forKey:@"urlString"];
    [context save:nil];
}
-(BOOL)hasItembeenRead:(RSItem *)item
{
    //fetch from core data
    NSFetchRequest  * req =[[NSFetchRequest alloc]initWithEntityName:@"Link"];
    NSPredicate * predict =[NSPredicate  predicateWithFormat:@"urlString like %@",[item link]];
    [req setPredicate:predict];
    NSArray * array =[context executeFetchRequest:req error:nil];
   if([array count]>0)
       return YES;
    return NO;
}
-(NSDate *)topSongsCahceDate
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"topSongsCacheDate"];
}
-(void)setTopSongsCahceDate:(NSDate *)topSongsCahceDate
{
    [[NSUserDefaults standardUserDefaults]setObject:topSongsCahceDate forKey:@"topSongsCacheDate"];
}
+(BNRFeedStore*)sharedStore
{
    static BNRFeedStore * feedstore =nil;
    if(feedstore ==nil)
    {
        feedstore =[[BNRFeedStore alloc]init];
    }
    return feedstore;
}
-(RSChannel*)fetchRSSFeedWithCompletion:(void (^)(RSChannel *, NSError *))block
{
    NSURL * url =[NSURL URLWithString:
                  @"http://forums.bignerdranch.com/smartfeed.php?"
                  @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    NSURLRequest * req=[[NSURLRequest alloc]initWithURL:url];
    BNRConnection * conn =[[BNRConnection alloc]initWithURLrequest:req];
    NSString * path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path =[path stringByAppendingString:@"feed.stroe"];
    RSChannel * channel =[[RSChannel alloc]init];
    //RSChannel * cacheChannel =[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    RSChannel * cacheChannel =[[RSChannel alloc]init];
    NSData * data_pre=[NSData dataWithContentsOfFile:path];
    if(data_pre)
    [cacheChannel readFromDictionary:[NSJSONSerialization JSONObjectWithData:data_pre options:0 error:nil]];
    if(!cacheChannel)
        cacheChannel =[[RSChannel alloc]init];
    RSChannel *copyChannel =[cacheChannel copyWithZone:nil];
    [conn setCompletionBlock:^(id object,NSError * error)
     {
         if(!error){
             [copyChannel addNewItemFromChannel:object];
             //[NSKeyedArchiver archiveRootObject:copyChannel toFile:path];
             NSData * data=[NSJSONSerialization dataWithJSONObject:[copyChannel getDicFromObject] options:0 error:nil];
             [data writeToFile:path atomically:YES];
         }
         block(copyChannel,error);
         
     }];
    //block(cacheChannel,nil);
    [conn setXmlRootObject:channel];
    //[conn setCompletionBlock:block];
    [conn start];
    return cacheChannel;
    
}
-(void)fetchTopsongs:(int)count WithCompletion:(void(^)(RSChannel * channel,NSError * error))block
{
    NSString * path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path =[path stringByAppendingString:@"apple.store"];
    NSDate *date_old =self.topSongsCahceDate;
    if (date_old) {
        NSTimeInterval  internal =[date_old timeIntervalSinceNow];
        if (internal>-300) {
            RSChannel * channel =[NSKeyedUnarchiver unarchiveObjectWithFile:path];
            if(channel){
            block(channel,nil);
            return;
            }
        }
    }
    
    NSString * string =[NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topsongs/limit=%d/json",count];
    NSURL * url =[NSURL URLWithString:string];
    NSURLRequest * req=[[NSURLRequest alloc]initWithURL:url];
    RSChannel * channel =[[RSChannel alloc]init];
    BNRConnection * conn =[[BNRConnection alloc]initWithURLrequest:req];
    [conn setJasonObject:channel];
    [conn setCompletionBlock:^(id object,NSError * error ){
        if(!error)
        {
            self.topSongsCahceDate =[NSDate date];
            [NSKeyedArchiver archiveRootObject:object toFile:path];
        }
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            block(object,error);
        }];
    }];
    [conn start];
}
@end
