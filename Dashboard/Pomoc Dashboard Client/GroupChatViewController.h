//
//  GroupChatViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 19/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupChatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *agentListChatView;
@property (weak, nonatomic) IBOutlet UITableView *agentListNavBar;
- (void) deallocDelegate;

@end
