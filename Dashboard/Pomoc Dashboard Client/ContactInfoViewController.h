//
//  ContactInfoViewController.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSupport.h"

@interface ContactInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notesTableView;
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) PMConversation *currentConversation;

- (IBAction)addNotesPressed:(id)sender;

@end
