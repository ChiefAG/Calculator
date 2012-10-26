//
//  CalculatorBrain.m
//  Calculator
//
//  Created by John Jilek on 10/11/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *stack;
@end

@implementation CalculatorBrain

@synthesize program = _program;

@synthesize stack = _programStack;

- (id)program
{
    return [self.programStack copy];
}

- (NSMutableArray *) programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void)clearAll
{
    [self.programStack removeAllObjects];
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandNumber = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandNumber];
}

- (void)pushOperation:(NSString *)variable
{
    [self.programStack addObject:variable];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack doubleValue];
    } else {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] / divisor;
        } else if( [operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if( [operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if( [operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        } else if( [operation isEqualToString:@"log"]) {
            result = log10([self popOperandOffStack:stack]);
        } else if( [operation isEqualToString:@"+/-"]) {
            result = [self popOperandOffStack:stack] * -1;
        } else if ([operation isEqualToString:@"e"]) {
            result = exp([self popOperandOffStack:stack]);
        } else if( [operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    return [self runProgram:program usingVariables:nil];
}

+ (double)runProgram:(id)program usingVariables:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([ program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    // replace variables in stack with values
    for (int i = 0; i < [stack count]; i++) {
        id obj = [stack objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
            id val = [variableValues valueForKey:obj];
            if (!val) val = 0;
            [stack replaceObjectAtIndex:i withObject:val];
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    if (![program isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    NSArray *stack = [program copy];
    
    NSMutableArray *variables = [[NSMutableArray alloc] initWithCapacity:5];
    for (id obj in stack) {
        if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
            [variables addObject:obj];
        }
    }
    
    return [variables count] > 0 ? [NSSet setWithArray:variables] : nil;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *description;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
    } else {
        return @"";
    }
    
    // when topOfStack is a number, return it
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack description];
    }
    
    if ([topOfStack isKindOfClass:[NSString class]]) {
        if ([self isMultiOperandOperation:topOfStack])
        {
            NSString *operation = topOfStack;
            NSString *rightSide = [self descriptionOfTopOfStack:stack];
            NSString *leftSide = [self descriptionOfTopOfStack:stack];
            
            if ([leftSide rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"-+"]].length != 0)
            {
                leftSide = [NSString stringWithFormat:@"(%@)", leftSide];
            }
            if ([rightSide rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"-+"]].length != 0)
            {
                rightSide = [NSString stringWithFormat:@"(%@)", rightSide];
            }
            
            description = [NSString stringWithFormat:@"%@ %@ %@", leftSide, operation, rightSide];
        } else if ([self isSingleOperandOperation:topOfStack]) {
            NSString *val = [self descriptionOfTopOfStack:stack];
            description = [NSString stringWithFormat:@"%@(%@)", topOfStack, val];
        } else {
            description = topOfStack;
        }
    }
    
    return description;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSMutableArray *expressions = [[NSMutableArray alloc] init];
    
    while (stack.count > 0) {
        [expressions addObject:[self descriptionOfTopOfStack:stack]];
    }
    
    return [expressions componentsJoinedByString:@", "];
}

+ (BOOL)isOperation:(NSString *)variable
{
    NSSet *operations = [NSSet setWithObjects:@"π", @"e", nil];
    return [operations containsObject:variable] || [self isSingleOperandOperation:variable] || [self isMultiOperandOperation:variable];
}

+ (BOOL)isSingleOperandOperation:(NSString *)operation
{
    NSSet *operations = [NSSet setWithObjects:@"log", @"sqrt", @"cos", @"sin", nil];
    return [operations containsObject:operation];
}

+ (BOOL)isMultiOperandOperation:(NSString *)operation
{
    NSSet *operations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    return [operations containsObject:operation];
}
@end
