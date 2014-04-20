//
//  GroupChatViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 19/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupChatViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *agentListChatView;
@property (weak, nonatomic) IBOutlet UITableView *agentListNavBar;
@property (weak, nonatomic) IBOutlet UIView *keyboardInput;
- (void) deallocDelegate;

@end
