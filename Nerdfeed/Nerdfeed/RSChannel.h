//
//  RSChannel.h
//  Nerdfeed
//
//  Created by lovocas on 13-11-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSItem.h"
#import "JSONSerialization.h"

@interface RSChannel : NSObject <NSXMLParserDelegate,JSONSerialization,NSCoding,NSCopying>
{
    NSMutableString * currentString;
}
@property (nonatomic ,strong )NSString * title;
@property (nonatomic ,strong)NSString * infoString;
@property (nonatomic ,strong,readonly )NSMutableArray * array;
@property (nonatomic ,weak )id parentDelegate;
-(void)trimItemsTitle;
-(void)addNewItemFromChannel:(RSChannel *)object;
@end
