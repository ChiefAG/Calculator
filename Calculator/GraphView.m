//
//  GraphView.m
//  Calculator
//
//  Created by John Jilek on 12/3/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

#define DEFAULT_SCALE 10.0

@synthesize datasource = _datasource;
@synthesize scale = _scale;
@synthesize origin = _origin;

- (CGFloat)scale
{
    if (!_scale) _scale = DEFAULT_SCALE;
    return _scale;
}

- (void)setScale:(CGFloat)scale
{
    if (scale == _scale) return;
    _scale = scale;
    
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGPoint)origin
{
    if (!_origin.x && ! _origin.y) {
        CGRect bounds = self.graphBounds;
        _origin.x = (bounds.origin.x + bounds.size.width / 2.0);
        _origin.y = (bounds.origin.y + bounds.size.height / 2.0);
    }
    return _origin;
    
}

- (void)setOrigin:(CGPoint)origin
{
    _origin = origin;
    
    [self setNeedsDisplay];
}

- (CGRect)graphBounds
{
    return self.bounds;
}

- (CGPoint)convertToGraphCoordinate:(CGPoint)coordinate
{
    CGPoint graphCoordinate;
    graphCoordinate.x = (coordinate.x - self.origin.x) / self.scale;
    graphCoordinate.y = (self.origin.y - coordinate.y) / self.scale;
    
    return graphCoordinate;
}

- (CGPoint)convertToViewCoordinate:(CGPoint)coordinate
{
    CGPoint viewCoordinate;
    viewCoordinate.x = (coordinate.x * self.scale) + self.origin.x;
    viewCoordinate.y = self.origin.y - (coordinate.y * self.scale);
    
    return viewCoordinate;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the axis width and color
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] setStroke];
    
    // draw axis
    [AxesDrawer drawAxesInRect:self.graphBounds originAtPoint:self.origin scale:self.scale];
    
    CGFloat startingX = self.graphBounds.origin.x;
    CGFloat endingX = self.graphBounds.origin.x + self.graphBounds.size.width;
    CGFloat increment = 1/self.contentScaleFactor;
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor yellowColor] setStroke];

    CGContextBeginPath(context);
    BOOL initialPoint = YES;
    for (CGFloat x = startingX; x <= endingX; x += increment) {
        CGPoint coordinate;
        coordinate.x = x;
        coordinate = [self convertToGraphCoordinate:coordinate];
        coordinate.y = [self.datasource yValueFor:coordinate.x inView:self];
        coordinate = [self convertToViewCoordinate:coordinate];
        coordinate.x = x;
        
        if (coordinate.y == NAN || coordinate.y == INFINITY || coordinate.y == -INFINITY) {
            continue;
        }
        
        if(initialPoint) {
            initialPoint = NO;
            CGContextMoveToPoint(context, coordinate.x, coordinate.y);
        }
        
        CGContextAddLineToPoint(context, coordinate.x, coordinate.y);
    }
    
    CGContextStrokePath(context);
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        self.scale *= gesture.scale;
        gesture.scale = 1.0;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gesture translationInView:self];
        
        CGPoint origin;
        origin.x = self.origin.x + translation.x;
        origin.y = self.origin.y + translation.y;
        
        self.origin = origin;
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.origin = [gesture locationOfTouch:0 inView:self];
    }
}

@end
