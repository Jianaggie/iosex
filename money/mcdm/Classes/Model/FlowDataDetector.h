//
//  FlowDataDetector.h
//  MCDM
//
//  Created by Fred on 12-12-27.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowDataDetector : NSObject
{
    NSMutableArray *_recordArray;
    
    NSDate *_bootTime;
    
    NSDate *_lastSavedTime;
    
    uint _lastBaseWifiSent;
    uint _lastBaseWifiReceived;
    uint _lastBaseWWANSent;
    uint _lastBaseWWANReceived;
}

@property (nonatomic, readonly) NSArray *recordArray;

+ (FlowDataDetector *)detector;
+ (void)releaseDetector;

+ (NSString *)bytesToAvaiUnit:(int)bytes;

- (void)updateStates;

@end
