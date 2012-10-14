//
//  CalculatorBrain.h
//  Calculator
//
//  Created by John Jilek on 10/11/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

- (void)clearAll;
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;

@end
