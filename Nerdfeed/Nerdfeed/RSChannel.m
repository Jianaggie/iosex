//
//  RSChannel.m
//  Nerdfeed
//
//  Created by lovocas on 13-11-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "RSChannel.h"

@implementation RSChannel
@synthesize  title,infoString,array,parentDelegate;
-(id)init
{
    self =[super init];
    if(self)
    {
        array =[[NSMutableArray alloc]init];
    }
    return self;
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
     NSLog( @"%@,find the element %@",self,elementName);
    if([elementName isEqualToString:@"title"])
    {
        currentString =[[NSMutableString alloc]init];
        [self setTitle:currentString];
    }
    else if([elementName isEqualToString:@"description"])
    {
        currentString =[[NSMutableString alloc]init];
        [self setInfoString:currentString];
    }
    else if([elementName isEqualToString:@"item"]||[elementName isEqualToString:@"entry"])
    {
        RSItem* item =[[RSItem alloc]init];
        [item setParentDelegate:self];
        [parser setDelegate:item];
        [self.array addObject:item];
       
    }
        
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.infoString forKey:@"description"];
    [aCoder encodeObject:self.array forKey:@"items"];
    
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if(self)
    {
        self.title =[aDecoder decodeObjectForKey:@"title"];
        self.infoString =[aDecoder decodeObjectForKey:@"description"];
        array =[aDecoder decodeObjectForKey:@"items"];
        
        
    }
    return self;
}

-(void)readFromDictionary:(NSDictionary *)s
{
    NSDictionary * feed =[s  objectForKey:@"feed"];
    self.title =[feed objectForKey:@"title"];
    NSArray * items =[feed objectForKey:@"entry"];
    for(NSDictionary * item in items)
    {
        RSItem * i =[[RSItem alloc]init];
        [i readFromDictionary:item];
        [self.array addObject:i];
    }
}
-(NSDictionary *)getDicFromObject
{
    NSMutableDictionary * dic =[[NSMutableDictionary alloc]init];
    NSMutableDictionary * feed =[[NSMutableDictionary alloc]init];
   
    [feed setValue:self.title forKey:@"title" ];
    

    NSMutableArray * items =[[NSMutableArray alloc]init];
    for(RSItem * i in self.array)
    {
        [items addObject:[i getDicFromObject]];
    }
    [feed setValue:items forKey:@"entry"];
    [dic setValue:feed forKey:@"feed" ];
    return dic;
}
-(id)copyWithZone:(NSZone *)zone
{
    RSChannel * channel =[[[self class]alloc]init];
    [channel setTitle:self.title];
    [channel setInfoString:self.infoString];
    channel->array =[array mutableCopy];
    return channel;
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
     NSLog( @"end the element %@",elementName);
    if([elementName isEqualToString:@"channel"])
    {
        currentString =nil;
        [parser setDelegate:self.parentDelegate];
        [self trimItemsTitle];
    }
}
-(void)addNewItemFromChannel:(RSChannel *)object
{
    for(RSItem * item in object.array)
    {
        if(![self.array containsObject:item])
            [self.array addObject:item];
    }
    [self.array sortUsingComparator:^NSComparisonResult(id object1,id object2){
        return [[object1 publishedDate] compare:[object2 publishedDate]];
    }];
}
-(void)trimItemsTitle
{
    // trim the item ,get the author
    NSRegularExpression * re =[[NSRegularExpression alloc]initWithPattern:@".*::(.*)::.*" options:0 error:nil];
   for(RSItem * item in array)
   {
       NSString * title =[item title];
       NSArray * mathes =[re matchesInString:title options:0 range:NSMakeRange(0, [title length])];
       if([mathes count]>0)
       {
           NSTextCheckingResult * r1 =[mathes objectAtIndex:0];
           NSRange  range =r1.range;
           NSLog(@"location is %d,length is %d",range.location,range.length);
           if([r1 numberOfRanges]==2)
           {
               NSRange r =[r1 rangeAtIndex:1];
               item.title=[title substringWithRange:r];
               
           }
       }
   }
}
@end
