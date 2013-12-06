//
//  BNRConnection.m
//  Nerdfeed
//
//  Created by lovocas on 13-12-3.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "BNRConnection.h"

@implementation BNRConnection
-(id)initWithURLrequest:(NSURLRequest *)request
{
    self =[super init];
    if(self){
        [self setRequest:request];
    }
    return self;
}
-(void)start
{
     xmldata =[[NSMutableData alloc]init];
     conn=[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:YES];
    if(sharedConnections == nil)
    {
        sharedConnections =[[NSMutableArray alloc]init];
        
    }
    [sharedConnections addObject:conn];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmldata appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id rootObject =nil;
    if(self.xmlRootObject)
    {
        //parse the data into xmlRootObject
        NSXMLParser * parse =[[NSXMLParser alloc]initWithData:xmldata];
        [parse setDelegate:self.xmlRootObject];
        [parse parse];
        rootObject =self.xmlRootObject;
    }
    else if (self.jasonObject)
    {
        NSDictionary * dic =[NSJSONSerialization JSONObjectWithData:xmldata options:0 error:nil];
        [self.jasonObject readFromDictionary:dic];
        rootObject = self.jasonObject;
    }
    if(self.completionBlock)
    {
        //self.completionBlock(self.xmlRootObject,nil);
        self.completionBlock(rootObject,nil);
    }
    [sharedConnections removeObject:conn];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(self.completionBlock)
    {
        self.completionBlock(nil,error);
    }
    [sharedConnections removeObject:conn];
}
@end
