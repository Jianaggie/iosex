//
//  RSItem.h
//  Nerdfeed
//
//  Created by lovocas on 13-11-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerialization.h"
@interface RSItem : NSObject <NSXMLParserDelegate,JSONSerialization,NSCoding>
{
    NSMutableString * currentString;
}
@property (nonatomic ,strong)NSString * title;
@property (nonatomic ,strong)NSString * link;
@property (nonatomic,weak) id parentDelegate;
@property (nonatomic,strong)NSDate * publishedDate;
@end
