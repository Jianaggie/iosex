//
//  ContactsDetector.h
//  MCDM
//
//  Created by Fred on 12-12-28.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIProgressDelegate.h"

@interface ContactsDetector : NSObject <ASIProgressDelegate>
{
    int _serverContactsCount;
    int _localContactsCount;
}

@property (nonatomic, readonly) int serverContactsCount;
@property (nonatomic, readonly) int localContactsCount;

+ (ContactsDetector *)detector;
+ (void)releaseDetector;

//+ (NSMutableArray *)parseAllLocalContacts;

// 返回 nil 或 error
- (id)checkChangesAndPost;
- (id)checkLocalAndServerContactsInfo;
- (id)restoreFromServer;

@end
