//
//  ChartView.h
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 4/19/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineChartView : UIView

- (id)initWithFrame:(CGRect)frame;

- (void)addDataX:(NSArray *)x_vals withY:(NSArray *)y_vals;
- (void)addData:(NSDictionary *)newData;
- (void)hideChart;
- (void)showChart;

- (void)uploadFrame:(CGRect)frame animated:(BOOL)isAnimated;

@end
