//
//  BNRImageStore.h
//  Homepwner
//
//  Created by lovocas on 13-11-5.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject{

    NSMutableDictionary * dictionary;
}
+(BNRImageStore *)sharedstore;
-(void)setImage:(UIImage *)image forKey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImageforKey:(NSString *)key;
-(void)clearCache;
@end
