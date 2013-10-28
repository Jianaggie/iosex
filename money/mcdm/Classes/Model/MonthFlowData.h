//
//  MonthFlowData.h
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthFlowData : NSObject <NSCoding>
{
    NSString *_key;
    
    uint _wifiSent;
    uint _wifiReceived;
    uint _WWANSent;
    uint _WWANReceived;
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) uint wifiSent;
@property (nonatomic, assign) uint wifiReceived;
@property (nonatomic, assign) uint WWANSent;
@property (nonatomic, assign) uint WWANReceived;

@end
