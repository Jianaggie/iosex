//
//  RSItem.m
//  Nerdfeed
//
//  Created by lovocas on 13-11-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "RSItem.h"

@implementation RSItem

@synthesize title,link,parentDelegate,publishedDate;
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
     NSLog( @"%@,find the element %@",self,elementName);
    if([elementName isEqualToString:@"title"])
    {
        currentString =[[NSMutableString alloc]init];
        [self setTitle:currentString];
    }
    else if([elementName isEqualToString:@"link"])
    {
        currentString =[[NSMutableString alloc]init];
        [self setLink:currentString];
    }
    else if ([elementName isEqualToString:@"pubDate"])
    {
        currentString =[[NSMutableString alloc]init];
        //[self setPublishedDate:currentString];
    }
}
-(BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[RSItem class]])
    {
        return [self.link isEqual:[object link] ];
    }
    return NO;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.link forKey:@"link"];
    [aCoder encodeObject:self.publishedDate forKey:@"publishDate"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self= [super init];
    if(self){
        self.link = [aDecoder decodeObjectForKey:@"link"];
        self.title =[aDecoder decodeObjectForKey:@"title"];
        self.publishedDate =[aDecoder decodeObjectForKey:@"publishDate"];
    }
    return  self;
}

-(void)readFromDictionary:(NSDictionary *)s
{
    self.title =[[s objectForKey:@"title"]objectForKey:@"label"];
    NSArray * links =[s objectForKey:@"link"];
    if([links count]>1)
    {
        NSDictionary * link =[[links objectAtIndex:1]objectForKey:@"attributes"];
        self.link =[link objectForKey:@"href"];
    }
}
-(NSDictionary *)getDicFromObject
{
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    NSMutableDictionary * title =[[NSMutableDictionary alloc]init];
    [title setObject:self.title forKey:@"label"];
    [dic setValue:title forKey:@"title"];
    
    NSMutableDictionary * attribute =[[NSMutableDictionary alloc]init];
    NSMutableDictionary * herf =[[NSMutableDictionary alloc]init];
    [herf setValue:self.link forKey:@"href"];

    [attribute setValue:herf forKey:@"attributes"];
        NSArray * links =[NSArray arrayWithObjects:@"",attribute, nil];
    [dic setValue:links forKey:@"link"];
    return dic;
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"pubDate"])
    {
        static NSDateFormatter *  formater = nil;
        if(!formater)
        {
            formater =[[NSDateFormatter alloc]init];
            [formater setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        }
        [self setPublishedDate:[formater dateFromString:currentString]];
    }
    currentString =nil;
    if([elementName isEqualToString:@"item"]||[elementName isEqualToString:@"entry"])
    {
        
        [parser setDelegate:self.parentDelegate];
    }
}
@end
