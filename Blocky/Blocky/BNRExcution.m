//
//  BNRExcution.m
//  Blocky
//
//  Created by lovocas on 13-12-2.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "BNRExcution.h"

@implementation BNRExcution
@synthesize equation;
-(int)computeWithValue:(int)a andValue:(int)b
{
    if(!equation)
        return 0;
    return equation(a,b);
}
@end
