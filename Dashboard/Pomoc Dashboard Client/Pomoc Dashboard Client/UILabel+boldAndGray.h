//
//  UILabel+boldAndGray.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 30/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (boldAndGray)

- (void) boldAndBlackSubstring:(NSString *)substring;
- (void) boldRange:(NSRange)range;

@end
