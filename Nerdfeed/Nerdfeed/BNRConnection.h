//
//  BNRConnection.h
//  Nerdfeed
//
//  Created by lovocas on 13-12-3.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerialization.h"

static NSMutableArray * sharedConnections =Nil;
@interface BNRConnection : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
     NSURLConnection * conn;
     NSMutableData * xmldata;
}
@property (nonatomic,copy)NSURLRequest * request;
@property (nonatomic ,copy)void(^completionBlock)(id obj,NSError * error);
@property (nonatomic,strong)id<NSXMLParserDelegate> xmlRootObject;
@property (nonatomic,strong)id<JSONSerialization> jasonObject;
-(id)initWithURLrequest:(NSURLRequest *)request;
-(void)start;
@end
