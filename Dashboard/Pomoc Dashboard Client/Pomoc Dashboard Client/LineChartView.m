//
//  ChartView.m
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 4/19/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "LineChartView.h"
#import "JBLineChartView.h"

// Color palette koped from https://kuler.adobe.com/retro-air-color-theme-3745716/

#define COLOR_BLACK [UIColor colorWithRed:0.251 green:0.251 blue:0.251 alpha:1.0];
#define COLOR_BLUE [UIColor colorWithRed:0.008 green:0.286 blue:0.349 alpha:1.0];
#define COLOR_TEAL [UIColor colorWithRed:0.012 green:0.494 blue:0.549 alpha:1.0];
#define COLOR_WHITE [UIColor colorWithRed:0.949 green:0.937 blue:0.863 alpha:1.0];
#define COLOR_RED [UIColor colorWithRed:0.949 green:0.298 blue:0.153 alpha:1.0];

@interface LineChartView() <JBLineChartViewDataSource, JBLineChartViewDelegate> {
    JBLineChartView *lineChartView;
    NSMutableDictionary *data;
}
@end


@implementation LineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lineChartView = [[JBLineChartView alloc] init];
        lineChartView.frame = self.frame;
        lineChartView.delegate = self;
        lineChartView.dataSource = self;
        lineChartView.backgroundColor = COLOR_WHITE;
        
        data = [[NSMutableDictionary alloc] init];
        
        [self initializeChart];
        [self showChart];
    }
    return self;
}

- (void)uploadFrame:(CGRect)frame animated:(BOOL)isAnimated
{
    self.frame = frame;
    lineChartView.frame = frame;
}

// Note Y values have to be >= 0 or the whole thing will complain
- (void)addDataX:(NSArray *)x_vals withY:(NSArray *)y_vals
{
    for (int i=0; i < [x_vals count]; i++) {
        [data setObject:y_vals[i] forKey:x_vals[i]];
    }
    [lineChartView reloadData];
}

- (void)addData:(NSDictionary *)newData {
    [data addEntriesFromDictionary:newData];
    [lineChartView reloadData];
    [self showChart];
}

- (void)initializeChart
{
    [self addSubview:lineChartView];
}

- (void)hideChart
{
    [lineChartView setHidden:YES];
}

- (void)showChart
{
    [lineChartView setHidden:NO];
}

# pragma mark - JBLineChartViewDataSource, JBLineChartViewDelegate methods for DATA

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [data count];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[data objectForKey:[NSNumber numberWithInteger:horizontalIndex]] floatValue];
}

# pragma mark - JBLineChart optional delegate methods for LINE

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return COLOR_RED;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 3.0;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleDashed;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}


# pragma mark - JBLineChart optional delegate methods for SELECTION

- (UIColor *)verticalSelectionColorForLineChartView:(JBLineChartView *)lineChartView
{
    return COLOR_TEAL;
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return COLOR_BLACK;
}

# pragma mark - JBLineChart optional delegate methods for DOTS

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 9.0;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    CGFloat color = (CGFloat)horizontalIndex / [data count];
    return [UIColor colorWithRed:color green:1/color blue:color alpha:1.0];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [UIColor yellowColor];
}

# pragma mark - JBLineChart optional delegate methods for GESTURES

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    // Update view
}

- (void)didUnselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    // Update view
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
