//
//  BNRItem.h
//  Homepwner
//
//  Created by lovocas on 13-11-18.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BNRItem : NSManagedObject

@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, strong) UIImage * thumbnail;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic) int32_t valueInDollar;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSManagedObject *assetType;
-(void)setThumbnailDataFromImg:(UIImage *)image;
@end
