//
//  服务器链接类
//  Network
//
//  Created by MagicStudio on 11-4-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSStreamAdditions.h"


@interface NSStream(MyAdditions)
 
//链接服务器 
+ (void)getStreamsToHostNamed:(NSString *)hostName
                         port:(NSInteger)port
                  inputStream:(NSInputStream **)inputStreamPtr
                 outputStream:(NSOutputStream **)outputStreamPtr;
@end