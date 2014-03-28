//
//  ViewController.m
//  PomocDriverApp
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ViewController.h"
#import "PomocCore.h"

@interface ViewController () <PMCoreDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet UIButton *startConversation;
@property (nonatomic, weak) IBOutlet UITableView *chatTableView;

@property (nonatomic, strong) NSString *conversationId;
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
    
    [PMCore initWithAppID:@"anc" userId:self.userId delegate:self];
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
    [PMCore startConversationWithCompletion:^(NSString *conversationId) {
        self.conversationId = conversationId;
        [self.sendButton setHidden:NO];
        [self.textField setHidden:NO];
        [self.chatTableView setHidden:NO];
        [button setHidden:YES];
    }];
}

- (IBAction)sendPressed:(UIButton *)button
{
    [PMCore sendMessage:self.textField.text conversationId:self.conversationId];
    self.textField.text = @"";
}

#pragma mark - PMCoreDelegate

- (void)didReceiveMessage:(PMMessage *)pomocMessage conversationId:(NSString *)conversation
{
    if ([pomocMessage isKindOfClass:[PMChatMessage class]]) {
        PMChatMessage *chatMessage = (PMChatMessage *)pomocMessage;
        [self addMessage:chatMessage.message fromUser:chatMessage.userId];
    }
}

- (void)newConversationCreated:(NSString *)conversationId
{
    NSLog(@"New Channel created %@", conversationId);
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
