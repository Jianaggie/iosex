//
//  DataParser.h
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsItem;

@interface DataParser : NSObject

@end


//
@interface NewsItemParser: NSXMLParser <NSXMLParserDelegate>
{
	NewsItem *_item;
	NSMutableString *_text;
	NSMutableArray *_items;
}

- (NSArray *)parseAsArray;

@end