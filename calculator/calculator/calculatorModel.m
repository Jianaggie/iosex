//
//  calculatorModel.m
//  calculator
//
//  Created by lovocas on 13-5-14.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "calculatorModel.h"

@implementation calculatorModel
@synthesize  stack = _stack;
@synthesize   program =_program;

- (void)pushNumber:(NSNumber *)number{
    [self.stack addObject:number];
    NSLog(@"number %@ is inserted",number);
    
}


-(id)program{
    _program = [self.stack copy];
    return _program;
}

- (double )performOperation:(NSString *)operation {
    [self.stack addObject:(operation)];
    return [calculatorModel runProgram:[self program]];
    
}

+ (double)popOperationAndOperand:(id)program{
    id popData = [program lastObject];
    double result= 0;
    if(program) [program removeLastObject];
    if([popData isKindOfClass:[NSNumber class]])
        return [popData doubleValue];
    else if ([popData isKindOfClass:[NSString class]]){
        NSString * operation = (NSString *)popData;
        if([operation isEqualToString:@"+"])
        {
           result =[self popOperationAndOperand:program] + [self popOperationAndOperand:program] ;
            
        }else if([operation isEqualToString:@"-"])
        {
            double temp = [self popOperationAndOperand:program];
            result = [self popOperationAndOperand:program] - temp;
            
        }else if ([operation isEqualToString:@"*"])
        {
            result = [self popOperationAndOperand:program] * [self popOperationAndOperand:program];
            
        }else if([operation isEqualToString:@"/"])
        {
           double temp = [self popOperationAndOperand:program];
           if(temp) result = [self popOperationAndOperand:program] / temp;
        }
        
    }
    return result;
}

+ (double)runProgram:(id)program{
    NSMutableArray * copyStack = [program mutableCopy];
    return [calculatorModel popOperationAndOperand:copyStack];
    
}

- (NSMutableArray*) stack{

    if(_stack == nil){
        _stack= [[NSMutableArray alloc]init];
    }
    return _stack;
}
       
@end
