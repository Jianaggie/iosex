//
//  NewsItem.h
//  MCDM
//
//  Created by Fred on 12-12-31.
//  Copyright (c) 2012年 Fred. All rights reserved.
//

#import <Foundation/Foundation.h>

//
@interface NewsItem: NSObject
{	
	NSString *guid;
	NSString *title;
    
    NSString *iconUrl;
	NSString *description;
    
    NSString *pubDate;
    NSString *source;
}

@property(nonatomic,retain) NSString *guid;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *iconUrl;
@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) NSString *pubDate;
@property(nonatomic,retain) NSString *source;

@end
