//
//  SideNavigationController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideNavigationController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)Chat:(id)sender;

@end
