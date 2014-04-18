//
//  HomeViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "HomeViewController.h"
#import "DashBoardSingleton.h"
#import "JBLineChartView.h"
#import "JBChartView.h"
#import "JBChartTooltipView.h"
#import "JBLineChartFooterView.h"

CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBLineChartViewControllerChartPadding = 0.0f;

@interface HomeViewController () <PomocHomeDelegate ,JBLineChartViewDataSource, JBLineChartViewDelegate>

@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) JBChartTooltipView *tooltipView;
@property (nonatomic, assign) BOOL tooltipVisible;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DashBoardSingleton *singleton = [DashBoardSingleton singleton];
    [singleton setHomeDelegate:self];
    
    //TODO ask dashboard singleton for number of convo current, users online etc
    [_agentOnlineLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)[singleton.currentAgentList count]]];
    [_userOnlineLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)[singleton.currentUserList count]]];
    [_totalConversationLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)[singleton.currentConversationList count]]];
    [singleton numberOfUnattendedConversation:^(NSUInteger total){
        NSLog(@"singleton replied total == %lu",total);
        [_unattendedConversationLabel setText:[NSString stringWithFormat:@"%lu",total]];
    }];
    
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    self.title = @"Home";
    
    _lineChartView = [[JBLineChartView alloc] init];
    _lineChartView.delegate = self;
    _lineChartView.dataSource = self;
    _lineChartView.frame = CGRectMake(0, 0, 450,  350);

    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5) - 130, self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2) - 300, kJBLineChartViewControllerChartFooterHeight)];
    
//    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(100,100,100,100)];
    
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = @"24/03/2014";
    footerView.rightLabel.text = @"24/04/2014";
    footerView.sectionCount = 10;
    
    [_chartView addSubview:_lineChartView];
    [_chartView addSubview: footerView];
    [_lineChartView reloadData];
    
    //_lineChartView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    [_chartView addGestureRecognizer:swipeRecognizer];
    
}

- (IBAction)swipeGesture:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"detected a swipe");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Line chart settings 
//- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return 1; // width of line in chart
//}
//
//
- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex;
{
    return true;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [Utility colorFromHexString:@"#1abc9c"]; // color of line in chart
}


- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [Utility colorFromHexString:@"#1abc9c"]; // color of selected line
}

#pragma mark - Settings for the dots of the graph
- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return true;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForLineAtLineIndex:(NSUInteger)lineIndex;
{
    return 10;
}

#pragma mark - chart view data source
- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1; // number of lines in chart
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return 10; // number of values for a line
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    double blah = horizontalIndex;
    if (blah == 0) {
         return 0;
        
    } else {
        return (CGFloat)log2(blah);
        
    }
    
}

#pragma mark - Touch point settings
- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    // Update view
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    [self.tooltipView setText:@"tool tip text!"];
}

- (void)didUnselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    //NSLog(@"did unselect line at index!");
    // Update view
    [self setTooltipVisible:NO animated:YES];
}

#pragma tooltip visibility

- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated atTouchPoint:(CGPoint)touchPoint
{
    _tooltipVisible = tooltipVisible;
    
    JBChartView *chartView = _lineChartView;
    
    if (!self.tooltipView)
    {
        self.tooltipView = [[JBChartTooltipView alloc] init];
        self.tooltipView.alpha = 0.0;
        [self.chartView addSubview:self.tooltipView];
    }
    
    dispatch_block_t adjustTooltipPosition = ^{
        
        CGPoint originalTouchPoint = [self.view convertPoint:touchPoint fromView:chartView];
        
        CGPoint convertedTouchPoint = originalTouchPoint; // modified
        JBChartView *chartView = _lineChartView;
        
        if (chartView)
        {
            CGFloat minChartX = (chartView.frame.origin.x + ceil(self.tooltipView.frame.size.width * 0.5));
            if (convertedTouchPoint.x < minChartX)
            {
                convertedTouchPoint.x = minChartX;
            }
            CGFloat maxChartX = (chartView.frame.origin.x + chartView.frame.size.width - ceil(self.tooltipView.frame.size.width * 0.5));
            if (convertedTouchPoint.x > maxChartX)
            {
                convertedTouchPoint.x = maxChartX;
            }
            
            self.tooltipView.frame = CGRectMake(convertedTouchPoint.x - ceil(self.tooltipView.frame.size.width * 0.5), CGRectGetMaxY(chartView.headerView.frame), self.tooltipView.frame.size.width, self.tooltipView.frame.size.height);
           
        }
    };
    
    dispatch_block_t adjustTooltipVisibility = ^{
        self.tooltipView.alpha = _tooltipVisible ? 1.0 : 0.0;
	};
    
    if (tooltipVisible)
    {
        adjustTooltipPosition();
    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.25f animations:^{
            adjustTooltipVisibility();
        } completion:^(BOOL finished) {
            if (!tooltipVisible)
            {
                adjustTooltipPosition();
            }
        }];
    }
    else
    {
        adjustTooltipVisibility();
    }
}

- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated
{
    [self setTooltipVisible:tooltipVisible animated:animated atTouchPoint:CGPointZero];
}

#pragma mark - Pomoc delegate
- (void) agentTotalNumberChange: (NSUInteger)agentNumber
{
    [_agentOnlineLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)agentNumber]];
}

- (void) userTotalNumberChange: (NSUInteger)userNumber
{
    [_userOnlineLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)userNumber]];
}

- (void) totalConversationChanged: (NSUInteger)totalConversation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_totalConversationLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)totalConversation]];
    });
    
}

@end
