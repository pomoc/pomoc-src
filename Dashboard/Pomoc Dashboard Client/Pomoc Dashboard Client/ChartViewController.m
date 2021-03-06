//
//  ChartViewController.m
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 4/19/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ChartViewController.h"
#import "DashBoardSingleton.h"
#import "LineChartView.h"
#import "Chartlet.h"

@interface ChartViewController () {
    DashBoardSingleton *singleton;
    UIActivityIndicatorView *spinner;
    
    NSMutableDictionary *fakeData;
    LineChartView *timeChart;
    
    NSMutableDictionary *chartlets;
    NSMutableArray *chartArray;
}

@end

# pragma mark - UIViewControllerDelegate methods

@implementation ChartViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    singleton = [DashBoardSingleton singleton];
    singleton.homeDelegate = self;

    [self initData:100];
    [self initTimeChart];
    
    self.numArea.delegate = self;
   
    //show spinner
    [self showLoading];
    [singleton numberOfUnattendedConversation:^(NSUInteger total){
        [spinner stopAnimating];
    }];
    
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    self.title = CHART_NAV_TITLE;
    
    [self.numArea registerClass:[Chartlet class] forCellWithReuseIdentifier:CHART_REUSE_CELL];
}

// Update the god-damn frames here so that the right size is used
- (void)viewWillAppear:(BOOL)animated {
    [timeChart updateFrame:self.chartArea.bounds animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deallocDelegate {
    singleton.homeDelegate = nil;
}

- (void)initData:(int)amount {
    fakeData = [[NSMutableDictionary alloc] init];
    float last = 0.0;
    int bracket = 10;
    int startTime = [[NSDate date] timeIntervalSince1970];
    
    for (int i = 0; i < amount; i++) {
        last = last + (rand() % (bracket * 2 + 1) - (bracket - 1));
        last = MAX(last, 0.0);
        [fakeData setObject:[NSNumber numberWithFloat:last]
                     forKey:[NSNumber numberWithInt:startTime + i]];
    }

    chartArray = [[NSMutableArray alloc] initWithArray:@[CHART_ARRAY]];
    chartlets = [[NSMutableDictionary alloc] init];
    [chartlets setObject:NO_OF_CELL
                  forKey:CHART_ARRAY];
}

# pragma mark - Chart initializations

- (void)initTimeChart {
    timeChart = [[LineChartView alloc] initWithFrame:self.chartArea.bounds];
    timeChart.delegate = self;
    
    [timeChart addData:fakeData
        withProperties:@{}];
    
    [self.chartArea addSubview:timeChart];
    [timeChart showChart];
    [self.numArea reloadData];
}

# pragma mark - Utility methods

- (void)showLoading {
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint origin = self.view.bounds.origin;
    CGSize size = self.view.bounds.size;
    spinner.center = CGPointMake(origin.x + size.width/2,
                                 origin.y + size.height/2);
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    [spinner startAnimating];
}

# pragma mark - UICollectionView datasource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [chartlets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Chartlet *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CHART_REUSE_CELL
                                                               forIndexPath:indexPath];
    
    NSString *key = chartArray[indexPath.row];
    [cell setTitleText:key];
    [cell setNumberText:[chartlets objectForKey:key]];
    return cell;
}

# pragma mark - LineChartView delegate methods

- (void)didSelectPointAtKey:(NSNumber *)key value:(NSNumber *)value
{
    // Update agents
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0
                                                 inSection:0];
    Chartlet *cell = (Chartlet *)[self.numArea cellForItemAtIndexPath:indexPath];
    [cell setNumberText:[value stringValue]];
}

- (void)didUnselectPoint
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    Chartlet *cell = (Chartlet *)[self.numArea cellForItemAtIndexPath:indexPath];
    [cell setNumberText:@"0"];
}

@end
