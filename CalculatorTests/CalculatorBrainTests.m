//
//  CalculatorBrainTests.m
//  Calculator
//
//  Created by John Jilek on 10/20/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import "CalculatorBrainTests.h"
#import "CalculatorBrain.h"

@implementation CalculatorBrainTests

CalculatorBrain *subject;

- (void)setUp
{
    [super setUp];
    subject = [[CalculatorBrain alloc] init];
    STAssertNotNil(subject, @"Failed to initialize the subject CalculatorBrain");
}

- (void)testCanPerformOperationAddition
{
    [subject pushOperand:55.0];
    [subject pushOperand:5.0];
    double result = [subject performOperation:@"+"];
    STAssertEquals(60.0, result, @"Addition operation failed");
}

- (void)testCanPerformSubtraction
{
    [subject pushOperand:55];
    [subject pushOperand:5];
    double result = [subject performOperation:@"-"];
    STAssertEquals(50.0, result, @"Subtraction operation failed");
}

- (void)testCanPerformMultiplication
{
    [subject pushOperand:55];
    [subject pushOperand:5];
    double result = [subject performOperation:@"*"];
    STAssertEquals(275.0, result, @"Multiplication operation failed");
}

- (void)testCanPerformDivision
{
    [subject pushOperand:55];
    [subject pushOperand:5];
    double result = [subject performOperation:@"/"];
    STAssertEquals(11.0, result, @"Division operation failed");
}

@end
