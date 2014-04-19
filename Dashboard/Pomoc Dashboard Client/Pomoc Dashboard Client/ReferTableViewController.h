//
//  ReferTableViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 14/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSupport.h"

@class ReferTableViewController;
@protocol ReferDelegate

- (void)closeReferPopOver;

@end


@interface ReferTableViewController : UITableViewController

@property (nonatomic, strong) PMConversation *currentConvo;
@property (nonatomic, strong) NSArray *referList;
@property (nonatomic, assign) id  delegate;

@end
