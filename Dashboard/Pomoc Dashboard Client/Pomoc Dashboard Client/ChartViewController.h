//
//  ChartViewController.h
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 4/19/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartView.h"

@interface ChartViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, LineChartViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *chartArea;
@property (strong, nonatomic) IBOutlet UICollectionView *numArea;


- (void) deallocDelegate;

@end
