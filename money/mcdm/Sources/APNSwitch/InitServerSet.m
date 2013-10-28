//
//  InitServerSet.m
//  unuion03
//
//  Created by MagicStudio on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
// 修改时间：2011年6月17日 内容 ：增加 内网字段
//

#import "InitServerSet.h"


@implementation InitServerSet
@synthesize number;
@synthesize interetAPN;
@synthesize interetUser;
@synthesize interetPwd;

@synthesize intrantAPN;
@synthesize intrantUser; 
@synthesize intrantPwd; 

-(void)dealloc{
    
    [interetAPN release];
    [interetUser release];
    [interetPwd release];
    
    [intrantAPN release];
    [intrantUser release];
    [intrantPwd release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:self.number forKey:kInitInfoNumberKey];
    [coder encodeObject:self.interetAPN forKey:kInitInfoInteretAPNKey];
    [coder encodeObject:self.interetUser forKey:kInitInfoInteretUserKey];
    [coder encodeObject:self.interetPwd forKey:kInitInfoInteretPwdKey]; 
    
    [coder encodeObject:self.intrantAPN   forKey:kInitInfoIntrantAPNKey];
    [coder encodeObject:self.intrantUser forKey:kInitInfoIntrantUserKey];
    [coder encodeObject:self.intrantPwd forKey:kInitInfoIntrantPwdKey];
   
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self == [super init])
    {
        self.number = [coder decodeIntForKey:kInitInfoNumberKey];
        
        self.interetAPN = [coder decodeObjectForKey:kInitInfoInteretAPNKey];
        self.interetUser=[coder decodeObjectForKey:kInitInfoInteretUserKey]; 
        self.interetPwd = [coder decodeObjectForKey:kInitInfoInteretPwdKey];
        
        self.intrantAPN = [coder decodeObjectForKey:kInitInfoIntrantAPNKey];
        self.intrantUser = [coder decodeObjectForKey:kInitInfoIntrantUserKey];
        self.intrantPwd = [coder decodeObjectForKey:kInitInfoIntrantPwdKey];
       
    }
    return self;
}

@end
