//
//  JBChartTooltipTipView.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 3/17/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import "JBChartTooltipTipView.h"

@implementation JBChartTooltipTipView

#pragma mark - Alloc/Init

- (id)init
{
    CGFloat kJBChartTooltipTipViewDefaultWidth = 40.0f;
    CGFloat kJBChartTooltipTipViewDefaultHeight = 20.0f;
    self = [super initWithFrame:CGRectMake(0, 0,
                                           kJBChartTooltipTipViewDefaultWidth,
                                           kJBChartTooltipTipViewDefaultHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIColor *kJBColorTooltipColor = [UIColor whiteColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    CGContextSaveGState(context);
    {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect));
        CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, kJBColorTooltipColor.CGColor);
        CGContextFillPath(context);
    }
    CGContextRestoreGState(context);
}

@end
