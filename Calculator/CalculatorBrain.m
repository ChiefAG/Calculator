//
//  CalculatorBrain.m
//  Calculator
//
//  Created by John Jilek on 10/11/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *) operandStack
{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void)clearAll
{
    [self.operandStack removeAllObjects];
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandNumber = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandNumber];
}

- (double)popOperand
{
    NSNumber *operand = [self.operandStack lastObject];
    if (operand) [self.operandStack removeLastObject];
    return [operand doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0.0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        result = [self popOperand] / divisor;
    } else if( [operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if( [operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if( [operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
    } else if( [operation isEqualToString:@"log"]) {
        result = log10([self popOperand]);
    } else if( [operation isEqualToString:@"+/-"]) {
        result = [self popOperand] * -1;
    } else if ([operation isEqualToString:@"e"]) {
        result = exp([self popOperand]);
    } else if( [operation isEqualToString:@"π"]) {
        result = M_PI;
    }
    
    [self pushOperand:result];
    return result;
}

@end
