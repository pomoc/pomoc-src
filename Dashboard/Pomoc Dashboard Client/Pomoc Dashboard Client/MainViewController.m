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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setUpPanels];
}

- (void) setUpPanels {
    
    NSLog(@"setting up panel");
    
    self.bounceOnCenterPanelChange = false;
    
    SideNavigationController *sideNav = [self.storyboard instantiateViewControllerWithIdentifier:@"sideNavigationController"];
    [self setLeftPanel:sideNav];
    [self setLeftGapPercentage:0.25];

    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationController"]];
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
