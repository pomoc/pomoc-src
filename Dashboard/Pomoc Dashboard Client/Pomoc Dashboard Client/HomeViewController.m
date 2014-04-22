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

@interface HomeViewController () <PomocHomeDelegate ,JBLineChartViewDataSource, JBLineChartViewDelegate> {
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
    
    //TODO ask dashboard singleton for number of convo current, users online etc
    [_agentOnlineLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)[singleton.currentAgentList count]]];
    [_userOnlineLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)[singleton.currentUserList count]]];
    [_totalConversationLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)[singleton.currentConversationList count]]];
    
    //show spinner
    [self showLoading];
    [singleton numberOfUnattendedConversation:^(NSUInteger total){
        NSLog(@"singleton replied total == %lu",(unsigned long)total);
        [_unattendedConversationLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)total]];
        [spinner stopAnimating];
    }];
    
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    self.title = @"Home";
    
    CGRect chartFrame = CGRectMake(0, 0, 450,  350);
    _lineChartView = [[LineChartView alloc] initWithFrame:chartFrame];
    [_lineChartView addData:[self retrieveData:25 type:1] withProperties:@{@"line_color":[UIColor greenColor], @"line_width":@"4.0"}];
    [_lineChartView addData:[self retrieveData:25 type:2] withProperties:@{}];
    
    [_chartView addSubview:_lineChartView];
    
    //_lineChartView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    [_chartView addGestureRecognizer:swipeRecognizer];
    
}

// Update the god-damn frames here so that the right size is used
- (void)viewWillAppear:(BOOL)animated
{
    [_lineChartView updateFrame:_chartView.bounds animated:NO];
}

- (NSDictionary *)retrieveData:(int)num type:(int)type
{
    NSMutableDictionary *buffer = [[NSMutableDictionary alloc] init];
    float last = 0.0;
    int bracket = 10;
    int startTime = [[NSDate date] timeIntervalSince1970];
    
    srand(3217+type);
    for (int i=0; i<num; i++) {
        last = last + (rand() % (bracket * 2 + 1) - (bracket - 1));
        last = MAX(last, 0.0);
        [buffer setObject:[NSNumber numberWithFloat:last] forKey:[NSNumber numberWithInt:startTime+i]];
    }
    return buffer;
}


- (void)showLoading
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = _unattendedConversationLabel.center;
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    [spinner startAnimating];
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
    NSLog(@"home view controller line 254 total conversation updated!");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_totalConversationLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)totalConversation]];
    });
    
}

- (void)totalUnattendedConversationChanged:(NSUInteger)totalUnattended {
    
}

- (void) deallocDelegate
{
    NSLog(@"inside dealloc delegate of home vc");
    [singleton setHomeDelegate:nil];
}


-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}


@end
