//
//  ChartView.h
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 4/19/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineChartViewDelegate
- (void)didSelectPointAtKey:(NSNumber *)key value:(NSNumber *)value;
- (void)didUnselectPoint;
@end

@interface LineChartView : UIView
@property (weak, nonatomic) id<LineChartViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

- (void)addData:(NSDictionary *)newData withProperties:(NSDictionary *)prop;
- (void)hideChart;
- (void)showChart;

- (void)updateFrame:(CGRect)frame animated:(BOOL)isAnimated;

@end
