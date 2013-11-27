//
//  Line.m
//  TouchTracker
//
//  Created by lovocas on 13-11-25.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "Line.h"

@implementation Line
@synthesize begin,end,containingArray;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self){
        NSValue* begin_temp =[aDecoder decodeObjectForKey:@"begin"];
        self.begin =[begin_temp CGPointValue];
        NSValue* end_temp =[aDecoder decodeObjectForKey:@"end"];
        self.end =[end_temp CGPointValue];

        
        
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSValue valueWithCGPoint:begin] forKey:@"begin"];
    [aCoder encodeObject:[NSValue valueWithCGPoint:end] forKey:@"end"];
}

@end
