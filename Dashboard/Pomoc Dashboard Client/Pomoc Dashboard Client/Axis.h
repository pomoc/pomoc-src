//
//  Axis.h
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 20/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Axis : UIView

@property (weak, nonatomic) NSArray *data;
@property (weak, nonatomic) UIColor *tickColor;
@property int smallTicksEvery;
@property int bigTicksEvery;

@end
