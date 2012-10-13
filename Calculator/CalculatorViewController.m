//
//  CalculatorViewController.m
//  Calculator
//
//  Created by John Jilek on 10/11/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize tape;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *) brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    
    NSUInteger decimalPointLocation = [self.display.text rangeOfString:@"."].location;
    if ([digit isEqualToString:@"."] && decimalPointLocation != NSNotFound) return;
    
    if ([digit isEqualToString:@"+/-"]) {
        // set the value's sign
        NSRange sign = [self.display.text rangeOfString:@"-"];
        if (sign.location == NSNotFound) {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        } else {
            self.display.text = [self.display.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        return;
    }
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {

    // treat the sign change as a digit press when user is entering numbers.
    if ([sender.currentTitle isEqualToString:@"+/-"] && userIsInTheMiddleOfEnteringANumber) {
        [self digitPressed:sender];
        return;
    }
    
    if (userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    [self addItemToTape:operation];
    [self addSymbolToTape];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearPressed
{
    [self.brain clearAll];
    self.display.text = @"0";
    self.tape.text = @"";
}

- (IBAction)backspacePressed {
    if ((self.display.text.length > 0) && userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text substringToIndex:(self.display.text.length - 1)];
    }
    if (self.display.text.length == 0)
    {
        self.display.text = @"0";
        userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self addItemToTape:self.display.text];
}

- (void)addItemToTape:(NSString *)item
{
    [self removeSymbolFromTape];
    if (self.tape.text.length != 0) {
        self.tape.text = [self.tape.text stringByAppendingString:@" "];
    }
    self.tape.text = [self.tape.text stringByAppendingString:item];
}

-(void)addSymbolToTape
{
    [self addItemToTape:@"="];
}

-(void)removeSymbolFromTape
{
    NSUInteger loc = [self.tape.text rangeOfString:@"="].location;
    if (loc != NSNotFound) {
        self.tape.text = [self.tape.text substringToIndex:loc];
    }
}
@end
