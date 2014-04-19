//
//  ChartViewController.h
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 4/19/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *chartArea;

- (void) deallocDelegate;

@end
