//
//  CalculatorViewController.m
//  Calculator
//
//  Created by John Jilek on 10/11/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

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

-(GraphViewController *)graphViewController
{
    return [self.splitViewController.viewControllers lastObject];
}

- (IBAction)graphPressed
{
    if ([self graphViewController]) {
        [[self graphViewController] setProgram:self.brain.program];
    } else {
        [self performSegueWithIdentifier:@"ShowGraph" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setProgram:self.brain.program];
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

- (IBAction)operationPressed:(UIButton *)sender
{

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
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.tape.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)clearPressed
{
    [self.brain clearAll];
    self.display.text = @"0";
    self.tape.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
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
}
@end
