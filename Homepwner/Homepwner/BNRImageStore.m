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
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification  object:nil];
    }
    return self;
}
-(void)clearCache
{
    [dictionary removeAllObjects];
}
-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray* directory=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,true);
    NSString * document = [directory objectAtIndex:0];
    return [document stringByAppendingPathComponent:key];
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
    //save the image
    NSData * buff =UIImagePNGRepresentation(image);//n(image, 0.5);
    [buff writeToFile:[self imagePathForKey:key] atomically:YES];
    
}

-(UIImage*)imageForKey:(NSString *)key
{
    UIImage * image= [dictionary objectForKey:key];
    if(!image)
    {
        //get the image from the filesystem
        image =[UIImage imageWithContentsOfFile:[self imagePathForKey:key]];
        if(image)
            [self setImage:image forKey:key];
        else
            NSLog(@"load image fails");
    }
    return  image;
}

-(void)deleteImageforKey:(NSString *)key
{
    if(!key)
        return ;
    [dictionary removeObjectForKey:key];
    //delete the file from the filesystem
    [[NSFileManager defaultManager]removeItemAtPath:[self imagePathForKey:key] error:NULL];
}
@end
