//
//  CalculatorViewController.h
//  Calculator
//
//  Created by John Jilek on 10/11/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *tape;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)enterPressed;
- (IBAction)clearPressed;
- (IBAction)backspacePressed;
- (IBAction)graphPressed;
@end
