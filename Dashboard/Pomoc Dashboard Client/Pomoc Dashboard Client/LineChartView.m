//
//  ChartView.m
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 4/19/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "LineChartView.h"
#import "JBLineChartView.h"
#import "JBChartTooltipView.h"
#import "JBChartTooltipTipView.h"
#import "Axis.h"

// Color palette koped from https://kuler.adobe.com/retro-air-color-theme-3745716/

#define COLOR_BLACK [UIColor colorWithRed:0.251 green:0.251 blue:0.251 alpha:1.0];
#define COLOR_BLUE [UIColor colorWithRed:0.008 green:0.286 blue:0.349 alpha:1.0];
#define COLOR_TEAL [UIColor colorWithRed:0.012 green:0.494 blue:0.549 alpha:1.0];
#define COLOR_WHITE [UIColor colorWithRed:0.949 green:0.937 blue:0.863 alpha:1.0];
#define COLOR_RED [UIColor colorWithRed:0.949 green:0.298 blue:0.153 alpha:1.0];

@interface LineChartView() <JBLineChartViewDataSource, JBLineChartViewDelegate> {
    JBLineChartView *lineChartView;
    NSMutableArray *chartData;
    NSMutableArray *chartProp;
    
    // Tool tip
    JBChartTooltipView *tooltipView;
    JBChartTooltipTipView *tooltipTipView;
    
    // Axis
    Axis *xAxis;
}
@end


@implementation LineChartView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        chartData = [[NSMutableArray alloc] init];
        chartProp = [[NSMutableArray alloc] init];
        
        [self initializeChart:frame];
        [self showChart];
    }
    return self;
}

- (void)updateFrame:(CGRect)frame animated:(BOOL)animated {
    // TODO: Removed unused parameter: animated
    self.frame = frame;
    lineChartView.frame = frame;
}

// Note Y values have to be >= 0 or the whole thing will complain
- (void)addDataX:(NSArray *)xValues withY:(NSArray *)yValues
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [xValues count]; i++) {
        [data setObject:yValues[i] forKey:xValues[i]];
    }
    [chartData addObject:data];
    [lineChartView reloadData];
}

- (void)addData:(NSDictionary *)newData {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data addEntriesFromDictionary:newData];
    [chartData addObject:data];
}

- (void)addData:(NSDictionary *)newData withProperties:(NSDictionary *)prop {
    [chartProp addObject:prop];
    [self addData:newData];
    [xAxis setData:[((NSDictionary *)chartData[0]) allValues]];
    [lineChartView reloadData];
}

- (void)initializeChart:(CGRect)frame {
    float xAxisHeight = 30;
    CGRect f = self.frame;
    
    CGRect chartFrame = CGRectMake(f.origin.x,
                                   f.origin.y,
                                   f.size.width,
                                   f.size.height - xAxisHeight);
    CGRect xAxisFrame = CGRectMake(f.origin.x,
                                   f.size.height - xAxisHeight + f.origin.y,
                                   f.size.width,
                                   xAxisHeight);
    
    lineChartView = [[JBLineChartView alloc] init];
    lineChartView.frame = chartFrame;
    lineChartView.delegate = self;
    lineChartView.dataSource = self;
    lineChartView.backgroundColor = [UIColor clearColor];
    [self addSubview:lineChartView];
    
    xAxis = [[Axis alloc] initWithFrame:xAxisFrame];
    xAxis.backgroundColor = [UIColor clearColor];
    [self addSubview:xAxis];
 
    tooltipView = [[JBChartTooltipView alloc] init];
    tooltipView.alpha = 0;
    [self addSubview:tooltipView];
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

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return [chartData count];
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView
numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    return [chartData[lineIndex] count];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView
verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
             atLineIndex:(NSUInteger)lineIndex {
    NSMutableArray *keys= [NSMutableArray arrayWithArray:[chartData[lineIndex] allKeys]];
    [keys sortUsingSelector:@selector(compare:)];
    
    NSNumber *idx = keys[horizontalIndex];
    return [[chartData[lineIndex] objectForKey:idx] floatValue];
}

# pragma mark - JBLineChart optional delegate methods for LINE

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    if ([chartProp count] > lineIndex && chartProp[lineIndex][@"line_color"]) {
        return chartProp[lineIndex][@"line_color"];
    }
    return COLOR_RED;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    if ([chartProp count] > lineIndex && chartProp[lineIndex][@"line_width"]) {
        return [chartProp[lineIndex][@"line_width"] floatValue];
    }
    return 6.0;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView
              lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
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
    return 3;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return COLOR_BLACK;
}

# pragma mark - JBLineChart optional delegate methods for DOTS

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return NO;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 9.0;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return COLOR_RED;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return COLOR_BLACK;
}

# pragma mark - JBLineChart optional delegate methods for GESTURES

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    // Update view
    NSMutableArray *keys= [NSMutableArray arrayWithArray:[chartData[lineIndex] allKeys]];
    [keys sortUsingSelector:@selector(compare:)];

    NSNumber *idx = keys[horizontalIndex];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[idx doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:date];
    NSNumber *valueNumber = [chartData[lineIndex] objectForKey:idx];
    NSString *valueString = [valueNumber stringValue];
    
    NSString *formatText = lineIndex == 0 ? @"Time: %@\nOnline: %@" : @"Time: %@\nCreated: %@";
    NSString *labelText = [NSString stringWithFormat:formatText, dateString, valueString];
    
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    //[tooltipView setText:[dateString uppercaseString]];
    [tooltipView setText:labelText];
    
    [self.delegate didSelectPointAtKey:idx value:valueNumber];
}


- (void)didUnselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    // Update view
    tooltipView.alpha = 0;
    [self.delegate didUnselectPoint];
}

- (void)setTooltipVisible:(BOOL)isVisible animated:(BOOL)isAnimated atTouchPoint:(CGPoint)touchPoint
{
    
    dispatch_block_t adjustTooltipPosition = ^{
        CGPoint originalTouchPoint = [self convertPoint:touchPoint fromView:self];
        CGPoint convertedTouchPoint = originalTouchPoint; // modified
        
        // Clamp x values
        CGFloat minChartX = self.frame.origin.x + ceil(tooltipView.frame.size.width * 0.5);
        CGFloat maxChartX = self.frame.origin.x + self.frame.size.width - ceil(tooltipView.frame.size.width * 0.5);
        convertedTouchPoint.x = MAX(convertedTouchPoint.x, minChartX);
        convertedTouchPoint.x = MIN(convertedTouchPoint.x, maxChartX);
        
        tooltipView.frame = CGRectMake(convertedTouchPoint.x - ceil(tooltipView.frame.size.width * 0.5), self.frame.size.height * 0.5, tooltipView.frame.size.width, tooltipView.frame.size.height);
        
        CGFloat minTipX = self.frame.origin.x + tooltipTipView.frame.size.width;
        originalTouchPoint.x = MAX(originalTouchPoint.x, minTipX);
        
        CGFloat maxTipX = self.frame.origin.x + self.frame.size.width - tooltipTipView.frame.size.width;
        originalTouchPoint.x = MIN(originalTouchPoint.x, maxTipX);
        
        tooltipTipView.frame = CGRectMake(originalTouchPoint.x - ceil(tooltipTipView.frame.size.width * 0.5), CGRectGetMaxY(tooltipView.frame), tooltipTipView.frame.size.width, tooltipTipView.frame.size.height);
    };
    
    dispatch_block_t adjustTooltipVisibility = ^{
        tooltipView.alpha = isVisible ? 1.0 : 0.0;
        tooltipTipView.alpha = isVisible ? 1.0 : 0.0;
	};
    
    if (isVisible) {
        adjustTooltipPosition();
    }
    
    if (isAnimated) {
        [UIView animateWithDuration:0.2 animations:^{
            adjustTooltipVisibility();
        } completion:^(BOOL finished) {
            if (!isVisible) {
                adjustTooltipPosition();
            }
        }];
    } else {
        adjustTooltipVisibility();
    }
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
