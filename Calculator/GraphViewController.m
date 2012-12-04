//
//  GraphViewController.m
//  Calculator
//
//  Created by John Jilek on 12/3/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController ()

@property (nonatomic, weak) IBOutlet GraphView *graphView;

@end

@implementation GraphViewController

@synthesize program = _program;
@synthesize graphView = _graphView;

- (void)setProgram:(id)program
{
    _program = program;
    [self.graphView setNeedsDisplay];
    self.title = [CalculatorBrain descriptionOfProgram:self.program];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.datasource = self;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    recognizer.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:recognizer];
    
    [self.graphView setNeedsDisplay];
}

- (float)yValueFor:(float)value inView:(GraphView *)sender
{
    return [CalculatorBrain runProgram:self.program usingVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:value] forKey:@"x"]];
}

@end
