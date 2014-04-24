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
#import "LineChartView.h"
#import "JBChartView.h"
#import "JBChartTooltipView.h"
#import "JBLineChartFooterView.h"

CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBLineChartViewControllerChartPadding = 0.0f;

@interface HomeViewController () <PomocHomeDelegate, UIAlertViewDelegate> {
    DashBoardSingleton *singleton;
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, strong) LineChartView *lineChartView;
@property (nonatomic, strong) JBChartTooltipView *tooltipView;
@property (nonatomic, assign) BOOL tooltipVisible;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    singleton = [DashBoardSingleton singleton];
    [singleton setHomeDelegate:self];
    
    _agentOnlineLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[singleton.currentAgentList count]];
    _userOnlineLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[singleton.currentUserList count]];
    _totalConversationLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[singleton.currentConversationList count]];
    
    //show spinner
    [self showLoading];
    [singleton numberOfUnattendedConversation:^(NSUInteger total) {
        [_unattendedConversationLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)total]];
        [spinner stopAnimating];
    }];
    
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    self.title = HOME_NAV_TITLE;

    CGRect chartFrame = CGRectMake(0, 0, CHART_WIDTH, CHART_HEIGHT);
    _lineChartView = [[LineChartView alloc] initWithFrame:chartFrame];
    [_lineChartView addData:[self retrieveData:DATA_POINTS type:1]
             withProperties:@{@"line_color":LINE_COLOR, @"line_width":LINE_CHAT_WIDTH}];
    [_lineChartView addData:[self retrieveData:DATA_POINTS type:2]
             withProperties:@{}];
    
    [_chartView addSubview:_lineChartView];
    
}

// Update the god-damn frames here so that the right size is used
- (void)viewWillAppear:(BOOL)animated {
    [_lineChartView updateFrame:_chartView.bounds animated:NO];
}

- (NSDictionary *)retrieveData:(int)num type:(int)type {
    NSMutableDictionary *buffer = [[NSMutableDictionary alloc] init];
    float last = 0.0;
    int bracket = 10;
    int startTime = [[NSDate date] timeIntervalSince1970];
    
    srand(3217 + type);
    for (int i = 0; i < num; i++) {
        last = last + (rand() % (bracket * 2 + 1) - (bracket - 1));
        last = MAX(last, 0.0);
        [buffer setObject:[NSNumber numberWithFloat:last]
                   forKey:[NSNumber numberWithInt:startTime + i * 3600]];
    }
    
    return buffer;
}


- (void)showLoading {
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = _unattendedConversationLabel.center;
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    [spinner startAnimating];
}

#pragma mark - Pomoc delegate

- (void)agentTotalNumberChange: (NSUInteger)agentNumber {
    [_agentOnlineLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)agentNumber]];
}

- (void)userTotalNumberChange: (NSUInteger)userNumber {
    [_userOnlineLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)userNumber]];
}

- (void)totalConversationChanged: (NSUInteger)totalConversation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_totalConversationLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)totalConversation]];
    });
}

- (void)totalUnattendedConversationChanged:(NSUInteger)totalUnattended {
    [_unattendedConversationLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)totalUnattended]];
}

- (void)deallocDelegate {
    [singleton setHomeDelegate:nil];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

#pragma mark - DISCONNECT
- (void)noInternet {
    UIAlertView *alert = [Utility disconnectAlert];
    alert.delegate = self;
    [alert show];
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"backtoLogin" sender:self];
    }
}

@end
