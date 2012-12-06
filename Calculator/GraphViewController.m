//
//  GraphViewController.m
//  Calculator
//
//  Created by John Jilek on 12/3/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController () <GraphViewDataSource>

@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@end

@implementation GraphViewController

@synthesize program = _program;
@synthesize graphView = _graphView;
@synthesize toolbar = _toolbar;

- (void)setProgram:(id)program
{
    _program = program;
    self.title = [NSString stringWithFormat:@"y = %@", [CalculatorBrain descriptionOfProgram:self.program]];
    [self restoreUserDefaults];
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
    self.splitViewController.delegate = self;
    self.splitViewController.presentsWithGesture = NO;
}

-(BOOL)splitViewController:(UISplitViewController *)svc
  shouldHideViewController:(UIViewController *)vc
             inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Calculator";
    
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems insertObject:barButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems removeObjectAtIndex:0];
    self.toolbar.items = toolbarItems;
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
    
    [self restoreUserDefaults];
}

-(void)restoreUserDefaults
{
    if (!self.graphView) return;

    float scale = [[NSUserDefaults standardUserDefaults] floatForKey:@"scale"];
    float x = [[NSUserDefaults standardUserDefaults] floatForKey:@"x"];
    float y = [[NSUserDefaults standardUserDefaults] floatForKey:@"y"];

    if (scale) {
        self.graphView.scale = scale;
    }
    if (x && y) {
        CGPoint origin = CGPointMake(x, y);
        self.graphView.origin = origin;
    }
    
    [self.graphView setNeedsDisplay];
}

- (float)yValueFor:(float)value inView:(GraphView *)sender
{
    return [CalculatorBrain runProgram:self.program usingVariables:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:value] forKey:@"x"]];
}

- (void)setScale:(CGFloat)scale inView:(GraphView *)sender
{
    [[NSUserDefaults standardUserDefaults] setFloat:scale forKey:@"scale"];
}

- (void)setOrigin:(CGPoint)origin inView:(GraphView *)sender
{
    [[NSUserDefaults standardUserDefaults] setFloat:origin.x forKey:@"x"];
    [[NSUserDefaults standardUserDefaults] setFloat:origin.y forKey:@"y"];
}

@end
