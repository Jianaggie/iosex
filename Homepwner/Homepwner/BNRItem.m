//
//  BNRItem.m
//  Homepwner
//
//  Created by lovocas on 13-10-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
@synthesize itemName;
@synthesize containedItem,container,serialNumber,valueInDollars,dateCreated,imageKey;
-(void)setContainedItem:(BNRItem *)item
{
    self.containedItem = item;
    [containedItem setContainer:self];
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self itemName] forKey:@"itemName"];
  
    [aCoder encodeObject:[self serialNumber] forKey:@"serialNumber"];
    [aCoder encodeObject:[self dateCreated] forKey:@"dateCreated"];
    [aCoder encodeObject:[self imageKey] forKey:@"imageKey"];
    [aCoder encodeInt:[self valueInDollars] forKey:@"valueInDollars"];
    
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if(self){
    
        self.itemName =[aDecoder decodeObjectForKey:@"itemName"];
        self.serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        self.dateCreated =[aDecoder decodeObjectForKey:@"dateCreated"];
        self.imageKey = [aDecoder decodeObjectForKey:@"imageKey"];
        self.valueInDollars =[aDecoder decodeIntegerForKey:@"valueInDollars"];
    }
    return self;
}
-(id)initWithItemName:(NSString *)name valueInDollars:(int)value serielNumber:(NSString *)sNumber{
    self =[self init];
    if(self){
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated =[[NSDate alloc] init];
    }
    return self;
}

+(id)randomItem{
    NSArray * randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy",@"Rusty",@"Shiny",nil];
    NSArray * randomNounList = [NSArray arrayWithObjects:@"Bear",@"Spork",@"Mac", nil];
    NSInteger adjectiveIndex = rand()%[randomAdjectiveList count];
    NSInteger nounIndex =rand()%[randomNounList count];
    NSString * randomName =[NSString stringWithFormat:@"%@%@",[randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    int  randomValue = rand()%100;
    NSString * randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",'0'+random()%10,
                                     'A'+random()%26,
                                     '0'+random()%10,
                                     'A'+random()%26,
                                     '0'+random()%10];
                            BNRItem * newItem =[[self alloc]initWithItemName:randomName valueInDollars:randomValue serielNumber:randomSerialNumber];
                            return newItem;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@ (%@) worth %d",itemName,serialNumber,valueInDollars];
}
@end
