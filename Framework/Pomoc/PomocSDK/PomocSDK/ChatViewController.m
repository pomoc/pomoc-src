//
//  ChatViewController.m
//  PomocSDK
//
//  Created by soedar on 28/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ChatViewController.h"
#import "PomocCore.h"

@interface ChatViewController () <PMCoreDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *startConversation;
@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSString *userId;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    
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

- (void)setupViews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 25, 320, 200)];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 210, 260, 40)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.backgroundColor = [UIColor whiteColor];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.sendButton.frame = CGRectMake(270, 210, 50, 40);
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    
    self.startConversation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.startConversation.frame = CGRectMake(0, 50, 300, 30);
    [self.startConversation setTitle:@"Start Conversation" forState:UIControlStateNormal];
    
    [self.chatTableView setHidden:YES];
    [self.textField setHidden:YES];
    [self.sendButton setHidden:YES];
    
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.sendButton];
    [self.view addSubview:self.startConversation];
    
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    
    [self.startConversation addTarget:self action:@selector(startConversationPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button action

- (void)startConversationPressed:(UIButton *)button
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

- (void)sendPressed:(UIButton *)button
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
