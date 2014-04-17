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
@property (weak, nonatomic) IBOutlet UIToolbar *pastAndInfoToolbar;

//Main
- (IBAction)viewAction:(id)sender;

// Annotation
- (IBAction)annotateActionPressed:(id)sender;

//Chat message action
- (IBAction)sendMessage:(id)sender;


//Toolbar that contains info/action
@property (weak, nonatomic) IBOutlet UIView *toolBarView;

//Handling unhandling
- (IBAction)handleActionPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *handleActionLabel;


@property (weak, nonatomic) IBOutlet UITextField *userTextInput;

//

@end
