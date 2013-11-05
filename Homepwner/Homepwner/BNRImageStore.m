//
//  BNRImageStore.m
//  Homepwner
//
//  Created by lovocas on 13-11-5.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore


- (id)init
{
    self = [super init];
    if (self) {
        dictionary =[[NSMutableDictionary alloc]init];
    }
    return self;
}

+(BNRImageStore *)sharedstore
{
    static BNRImageStore * imageStore = nil;
    if(!imageStore){
       imageStore = [[super allocWithZone:nil]init];
    }
    
        return imageStore;
    
}

+(id)allocWithZone:(NSZone *)zone
{
    return [BNRImageStore sharedstore];
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [dictionary setObject:image forKey:key];
}

-(UIImage*)imageForKey:(NSString *)key
{
    return [dictionary objectForKey:key];
}

-(void)deleteImageforKey:(NSString *)key
{
    if(!key)
        return ;
    [dictionary removeObjectForKey:key];
}
@end
