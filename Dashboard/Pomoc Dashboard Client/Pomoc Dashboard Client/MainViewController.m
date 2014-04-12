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
    NSLog(@"inside main view controller view did load");
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setUpPanels];
}

- (void) setUpPanels {
    
    self.bounceOnCenterPanelChange = false;
    
    SideNavigationController *sideNav = [self.storyboard instantiateViewControllerWithIdentifier:@"sideNavigationController"];
    [self setLeftPanel:sideNav];
    [self setLeftGapPercentage:0.25];

    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationController"]];
}


@end
