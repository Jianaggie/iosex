//
//  BNRItem.h
//  Homepwner
//
//  Created by lovocas on 13-10-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

@property (nonatomic,strong) BNRItem * containedItem;
@property (nonatomic,weak) BNRItem * container;
@property (nonatomic,copy)  NSString * itemName;
@property (nonatomic,copy) NSString * serialNumber;
@property (nonatomic) int  valueInDollars;
@property (nonatomic) NSDate * dateCreated;
@property(nonatomic,strong) NSString * imageKey;

-(id)initWithItemName:(NSString *)name
        valueInDollars:(int) value
         serielNumber:(NSString *)sNumber;

-(void)setContainedItem:(BNRItem *)item;
+(id)randomItem;
-(NSString *)description;
@end
