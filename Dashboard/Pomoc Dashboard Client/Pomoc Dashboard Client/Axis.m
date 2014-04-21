//
//  Axis.m
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 20/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "Axis.h"
#define LENGTH_SMALL 0.15
#define LENGTH_BIG 0.25

@interface Axis () {
    NSMutableArray *labels;
    NSMutableArray *sortedData;
}

@end

@implementation Axis

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.smallTicksEvery = 1;
        self.bigTicksEvery = 5;
        sortedData = [[NSMutableArray alloc] initWithArray:@[]];
    }
    return self;
}

- (void)setData:(NSArray *)data
{
    _data = data;
    sortedData = [NSMutableArray arrayWithArray:data];
    [sortedData sortUsingSelector:@selector(compare:)];
    [self setNeedsDisplay];
}

- (void)generateLabels
{
    float height = self.bounds.size.height;
    float width = self.bounds.size.width;
    double chunk = 1.0 / [sortedData count] * width;
    for (int i=0; i<[sortedData count]; i += self.bigTicksEvery) {
        CGRect frame = CGRectMake(i * chunk, LENGTH_BIG * height, self.smallTicksEvery * chunk, (1-LENGTH_BIG)*height);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = sortedData[i];
        label.textAlignment = NSTextAlignmentCenter;
        [labels addObject:label];
        [self addSubview:label];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float height = self.bounds.size.height;
    float width = self.bounds.size.width;
    
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.tickColor.CGColor);
    
    // Draw the Axis line
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    
    // Draw the ticks
    CGContextSetLineWidth(context, 1.0);
    double chunk = 1.0 / [sortedData count] * width;
    
    for (int i=0; i<[sortedData count]; i++) {
        double x = chunk * i;
        CGContextMoveToPoint(context, x, 0); //start at this point
        if (i % self.bigTicksEvery == 0) {
            CGContextAddLineToPoint(context, x, height * LENGTH_BIG);
        } else if (i % self.smallTicksEvery == 0) {
            //CGContextAddLineToPoint(context, x, height * LENGTH_SMALL);
        }
    }
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end
