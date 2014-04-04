//
//  ViewController.m
//  PomocDriverApp
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ViewController.h"
#import "PomocCore.h"

@interface ViewController () <PMCoreDelegate, PMConversationDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet UIButton *startConversation;
@property (nonatomic, weak) IBOutlet UITableView *chatTableView;

@property (nonatomic, strong) PMConversation *conversation;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSString *userId;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.messages = [@[] mutableCopy];
    self.users = [@[] mutableCopy];
    self.userId = @"customer";
    
    [PMCore initWithAppID:@"anc" secretKey:@"mySecret"];
    [PMCore setUserId:self.userId];
    [PMCore setDelegate:self];
    [PMCore observeNewConversations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button action

- (IBAction)startConversationPressed:(UIButton *)button
{
    [button setEnabled:NO];
    [PMCore startConversationWithCompletion:^(PMConversation *conversation) {
        self.conversation = conversation;
        self.conversation.delegate = self;
        [self.sendButton setHidden:NO];
        [self.textField setHidden:NO];
        [self.chatTableView setHidden:NO];
        [button setHidden:YES];
    }];
}

- (IBAction)sendPressed:(UIButton *)button
{
    [self.conversation sendTextMessage:self.textField.text];
    self.textField.text = @"";
}

#pragma mark - PMCore Delegate

- (void)newConversationCreated:(PMConversation *)conversation
{
    NSLog(@"New Channel created %@", conversation);
}

#pragma mark - PMConversation Delegate

- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage
{
    [self addMessage:chatMessage.message fromUser:chatMessage.userId];
}

#pragma mark - Adding Message

- (void)addMessage:(NSString *)message fromUser:(NSString *)user
{
    // Add a new message, and also update the tableview with the new message
    [self.messages addObject:message];
    [self.users addObject:user];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    
    [self.chatTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.chatTableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - TableViewDelegate/DataSource

// Probably don't need to edit anything below
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Chat";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.messages[indexPath.row];
    cell.detailTextLabel.text = self.users[indexPath.row];
    return cell;
}

@end
