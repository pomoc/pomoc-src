//
//  ChatViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

//Main
@property (weak, nonatomic) IBOutlet UIView *chatView;

//Chat nav IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *chatNavTable;

//Chat message IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *chatMessageTable;
@property (weak, nonatomic) IBOutlet UIView *chatInputView;

//Main
- (IBAction)viewPastChat:(id)sender;
- (IBAction)viewAction:(id)sender;

//Chat message action
- (IBAction)sendMessage:(id)sender;

@end
