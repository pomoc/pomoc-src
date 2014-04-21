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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    singleton = [DashBoardSingleton singleton];
    [singleton setHomeDelegate:self];
    [self initFakeData:100];
    [self initTimeChart];
    
    self.numArea.delegate = self;
   
    //show spinner
    [self showLoading];
    [singleton numberOfUnattendedConversation:^(NSUInteger total){
        NSLog(@"singleton replied total == %d", total);
        [spinner stopAnimating];
    }];
    
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    self.title = @"Charts";
    
    [self.numArea registerClass:[Chartlet class] forCellWithReuseIdentifier:@"chartlet"];
}

// Update the god-damn frames here so that the right size is used
- (void)viewWillAppear:(BOOL)animated
{
    [timeChart updateFrame:self.chartArea.bounds animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) deallocDelegate
{
    NSLog(@"inside dealloc delegate of chart vc");
    [singleton setHomeDelegate:nil];
}

- (void)initFakeData:(int)howmany
{
    fakeData = [[NSMutableDictionary alloc] init];
    float last = 0.0;
    int bracket = 10;
    int startTime = [[NSDate date] timeIntervalSince1970];
    
    for (int i=0; i<howmany; i++) {
        last = last + (rand() % (bracket * 2 + 1) - (bracket - 1));
        last = MAX(last, 0.0);
        [fakeData setObject:[NSNumber numberWithFloat:last] forKey:[NSNumber numberWithInt:startTime+i]];
    }
    chartArray = [[NSMutableArray alloc] initWithArray:@[@"Agents"]];
    chartlets = [[NSMutableDictionary alloc] init];
    [chartlets setObject:@"10" forKey:@"Agents"];
}

# pragma mark - Chart initializations
- (void)initTimeChart
{
    timeChart = [[LineChartView alloc] initWithFrame:self.chartArea.bounds];
    timeChart.delegate = self;
    
    [timeChart addData:fakeData withProperties:@{}];
    
    [self.chartArea addSubview:timeChart];
    [timeChart showChart];
    [self.numArea reloadData];
}

# pragma mark - Utility methods

- (void)showLoading
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint origin = self.view.bounds.origin;
    CGSize size = self.view.bounds.size;
    spinner.center = CGPointMake(origin.x + size.width/2, origin.y + size.height/2);
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    [spinner startAnimating];
}

# pragma mark - Pomoc delegate

- (void) agentTotalNumberChange: (NSUInteger)agentNumber
{
}

- (void) userTotalNumberChange: (NSUInteger)userNumber
{
}

- (void) totalConversationChanged: (NSUInteger)totalConversation
{
}

# pragma mark - Chartlets

# pragma mark - UICollectionView datasource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [chartlets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Chartlet *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"chartlet" forIndexPath:indexPath];
    
    NSString *key = chartArray[indexPath.row];
    [cell setTitleText:key];
    [cell setNumberText:[chartlets objectForKey:key]];
    return cell;
}

# pragma mark - UICollectionView delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Deselect item
}

# pragma mark - LineChartView delegate methods
- (void)didSelectPointAtKey:(NSNumber *)key value:(NSNumber *)value
{
    // Update agents
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    Chartlet *cell = (Chartlet *)[self.numArea cellForItemAtIndexPath:indexPath];
    [cell setNumberText:[value stringValue]];
}

- (void)didUnselectPoint
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    Chartlet *cell = (Chartlet *)[self.numArea cellForItemAtIndexPath:indexPath];
    [cell setNumberText:@"0"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
