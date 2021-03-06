//
//  UploadViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 30/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadViewController;
@protocol UploadDelegate

- (void)pictureSelected:(UIImage *)image;
- (void)closePopOver;

@end

@interface UploadViewController : UIViewController

@property (nonatomic, assign) id  delegate;

@end