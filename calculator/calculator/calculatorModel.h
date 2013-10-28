//
//  calculatorModel.h
//  calculator
//
//  Created by lovocas on 13-5-14.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface calculatorModel : NSObject

@property (nonatomic,strong)NSMutableArray * stack;
@property (readonly) id program;
// push the number in the array
- (void) pushNumber :(NSNumber *) number;

// pop the number from the array
- (NSString *) popNumber ;


-(double )performOperation:(NSString *)operation;
+ (double)popOperationAndOperand:(id)program;

+ (double)runProgram:(id) program;



@end
