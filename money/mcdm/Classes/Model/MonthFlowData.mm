//
//  MonthFlowData.m
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "MonthFlowData.h"

@implementation MonthFlowData

@synthesize key=_key, wifiSent=_wifiSent, wifiReceived=_wifiReceived, WWANSent=_WWANSent, WWANReceived=_WWANReceived;

- (void)dealloc
{
    [_key release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_key forKey:@"key"];
    
    [aCoder encodeObject:[NSNumber numberWithUnsignedInt:_wifiSent] forKey:@"wifiSent"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInt:_wifiReceived] forKey:@"wifiReceived"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInt:_WWANSent] forKey:@"WWANSent"];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInt:_WWANReceived] forKey:@"WWANReceived"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _key = [[aDecoder decodeObjectForKey:@"key"] retain];
        _wifiSent = [[aDecoder decodeObjectForKey:@"wifiSent"] unsignedIntValue];
        _wifiReceived = [[aDecoder decodeObjectForKey:@"wifiReceived"] unsignedIntValue];
        _WWANSent = [[aDecoder decodeObjectForKey:@"WWANSent"] unsignedIntValue];
        _WWANReceived = [[aDecoder decodeObjectForKey:@"WWANReceived"] unsignedIntValue];
    }
    
    return self;
}

@end
