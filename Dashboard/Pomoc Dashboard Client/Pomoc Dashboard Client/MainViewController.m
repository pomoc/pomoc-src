//
//  MainViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "MainViewController.h"
#import "SideNavigationController.h"
#import "HomeViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setUpPanels];
}

- (void) setUpPanels {
    
    SideNavigationController *sideNav = [self.storyboard instantiateViewControllerWithIdentifier:@"sideNavigationController"];
    [self setLeftPanel:sideNav];
    [self setLeftGapPercentage:0.25];
//    
//    HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
//    [self setCenterPanel:homeView];
    
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationController"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
