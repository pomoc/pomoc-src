//
//  GroupChatViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 19/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupChatViewController : UIViewController <UITextFieldDelegate>


//Chat nav IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *chatNavTable;

//Chat message IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *chatMessageTable;
@property (weak, nonatomic) IBOutlet UIView *chatInputView;

@property (weak, nonatomic) IBOutlet UITextField *textInput;

- (IBAction)sendMessage:(id)sender;
- (void) deallocDelegate;

@end
