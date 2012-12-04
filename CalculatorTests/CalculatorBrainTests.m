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

- (void)testCanRunProgramWithVariables
{
    [subject pushOperand:55];
    [subject pushOperation:@"A"];

    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:5.0], @"A", nil];
    
    [subject pushOperation:@"+"];
    double result = [CalculatorBrain runProgram:[subject program] usingVariables:variables];
    STAssertEquals(60.0, result, @"Variable use failed");
}

- (void)testRunProgramWithSingleVariable
{
    double result = [subject performOperation:@"x"];
    STAssertEquals(0.0, result, @"result of single variable should be 0.0");
}

- (void)testDescriptionOfMultipleSeparatedByComma
{
    [subject pushOperand:3];
    [subject pushOperand:5];
    
    NSString *desc = [CalculatorBrain descriptionOfProgram:[subject program]];
    
    STAssertTrue([desc isEqualToString:@"5, 3"], @"Description of 5, 3 failed");
}

- (void)testDescriptionOfSimpleAddition
{
    [subject pushOperand:5];
    [subject pushOperand:3];
    [subject pushOperation:@"+"];
    
    NSString *desc = [CalculatorBrain descriptionOfProgram:[subject program]];
    
    STAssertTrue([desc isEqualToString:@"5 + 3"], @"Description of 5 + 3 failed");
}

- (void)testDescriptionOfLogOperation
{
    [subject pushOperand:5];
    [subject pushOperation:@"log"];
    
    NSString *desc = [CalculatorBrain descriptionOfProgram:[subject program]];
    
    STAssertTrue([desc isEqualToString:@"log(5)"], @"Description of log(5) failed");
}

- (void)testDescriptionOf2PiOperation
{
    [subject pushOperand:2];
    [subject pushOperation:@"π"];
    [subject pushOperation:@"*"];
    
    NSString *desc = [CalculatorBrain descriptionOfProgram:[subject program]];
    
    STAssertTrue([desc isEqualToString:@"2 * π"], @"Description of 2 * π failed");
}

- (void)testDescriptionOfSqrtSqrtThree
{
    [subject pushOperand:3];
    [subject pushOperation:@"sqrt"];
    [subject pushOperation:@"sqrt"];

    NSString *desc = [CalculatorBrain descriptionOfProgram:[subject program]];
    
    STAssertTrue([desc isEqualToString:@"sqrt(sqrt(3))"], @"Description of sqrt(sqrt(3)) failed");
}

- (void)testDescriptionOfSqrtOfOperation
{
    [subject pushOperand:5];
    [subject pushOperand:3];
    [subject pushOperation:@"+"];
    [subject pushOperation:@"sqrt"];
    
    NSString *desc = [CalculatorBrain descriptionOfProgram:[subject program]];
    
    STAssertTrue([desc isEqualToString:@"sqrt(5 + 3)"], @"Description of sqrt(5 + 3) failed");
}

- (void)testDescriptionOfSqrtOrderOfOperations
{
    [subject pushOperation:@"a"];
    [subject pushOperation:@"a"];
    [subject pushOperation:@"*"];
    [subject pushOperation:@"b"];
    [subject pushOperation:@"b"];
    [subject pushOperation:@"*"];
    [subject pushOperation:@"+"];
    [subject pushOperation:@"sqrt"];
    
    NSString *desc = [CalculatorBrain descriptionOfProgram:[subject program]];
    
    STAssertTrue([desc isEqualToString:@"sqrt(a * a + b * b)"], @"Description of sqrt(a * a + b * b) failed");
}

- (void)testDescriptionForOrderOfOperations
{
    [subject pushOperand:3];
    [subject pushOperand:5];
    [subject pushOperand:6];
    [subject pushOperand:7];
    [subject pushOperation:@"+"];
    [subject pushOperation:@"*"];
    [subject pushOperation:@"-"];
    
    NSString *desc = [CalculatorBrain descriptionOfProgram:[subject program]];
    
    STAssertTrue([desc isEqualToString:@"3 - (5 * (6 + 7))"], @"Description of 3 - (5 * (6 + 7)) failed");
}

- (void)testMultipleEntries
{
    [subject pushOperand:3];
    [subject pushOperand:5];
    [subject pushOperation:@"+"];
    [subject pushOperand:6];
    [subject pushOperand:7];
    [subject pushOperation:@"*"];
    [subject pushOperand:9];
    [subject pushOperation:@"sqrt"];
    
    NSString *desc = [CalculatorBrain descriptionOfProgram:[subject program]];
    
    STAssertTrue([desc isEqualToString:@"sqrt(9), 6 * 7, 3 + 5"], @"Description of sqrt(9), 6 * 7, 3 + 5 failed");
}

@end
