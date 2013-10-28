//
//  NewsItem.m
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import "NewsItem.h"

//
@implementation NewsItem

@synthesize guid, title, iconUrl, description, pubDate, source;

//
- (void)dealloc
{
	[guid release];
	[title release];
	[iconUrl release];
	[description release];
    [pubDate release];
    [source release];
    
	[super dealloc];
}

@end