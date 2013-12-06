//
//  BNRExcution.h
//  Blocky
//
//  Created by lovocas on 13-12-2.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRExcution : NSObject
{
   // int(^equation)(int,int);
}
@property (nonatomic,copy)int(^equation)(int,int);
//-(void)setEquation:(int(^)(int,int)) block;
-(int)computeWithValue:(int) a andValue:(int)b;

@end
