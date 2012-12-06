//
//  GraphView.h
//  Calculator
//
//  Created by John Jilek on 12/3/12.
//  Copyright (c) 2012 John Jilek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GraphView;

@protocol GraphViewDataSource <NSObject>

-(float)yValueFor:(float)value inView:(GraphView *)sender;
-(void)setScale:(CGFloat)scale inView:(GraphView *)sender;
-(void)setOrigin:(CGPoint)origin inView:(GraphView *)sender;

@end
@interface GraphView : UIView

@property (nonatomic, weak) id<GraphViewDataSource> datasource;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@end
