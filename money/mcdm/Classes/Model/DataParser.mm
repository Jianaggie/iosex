//
//  DataParser.m
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "DataParser.h"
#import "NewsItem.h"

@implementation DataParser

@end

@implementation NewsItemParser

//
- (NSArray *)parseAsArray
{
	_items = [NSMutableArray arrayWithCapacity:0];

	[self setDelegate:self];
	[super parse];

	return _items;
}

//
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[_text appendString:string];
}

//
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"item"])
	{
		_item = [[NewsItem alloc] init];
	}
	else
	{
		[_text release];
		_text = [[NSMutableString alloc] init];
	}
}

//
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{	
	if ([elementName isEqualToString:@"item"])
	{
		[_items addObject:_item];
		[_item release];
		_item = nil;
		return;
	}
	if ([elementName isEqualToString:@"title"])
	{
        if (_item)
        {
            // TODO: 只是给新浪rss使用。
            NSRange range = [_text rangeOfString:@"["];
            NSRange rangeEnd = [_text rangeOfString:@")"];
            NSRange readRange = NSMakeRange(range.location, rangeEnd.location-range.location+1);
            _item.title = [_text substringWithRange:readRange];
        }
	}
	else if ([elementName isEqualToString:@"description"])
	{
        // TODO: 只是给新浪rss使用。
        if (_item)
        {
            _item.description = [_text stringByReplacingOccurrencesOfString:@"\n\t" withString:@""];
            _item.description = [_item.description substringFromIndex:5];
        }
	}
	else if ([elementName isEqualToString:@"author"])
	{
		_item.source = _text;
	}
	else if ([elementName isEqualToString:@"pubDate"])
	{
		_item.pubDate = _text;//NSUtil::FormatDate(_text/*, @"EEE, dd MMM yyyy HH:mm:ss Z", _locale*/);
	}
    else if ([elementName isEqualToString:@"link"])
    {
        _item.iconUrl = _text;
    }
    
	[_text release];
	_text = nil;
}

@end