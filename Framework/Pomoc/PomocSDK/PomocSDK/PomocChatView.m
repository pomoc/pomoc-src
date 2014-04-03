//
//  PomocChatView.m
//  PomocSDK
//
//  Created by soedar on 3/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PomocChatView.h"
#import "PomocCore.h"
#import "PomocChatView+Screenshot.h"

@interface PomocChatView () <PMCoreDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *chatTextField;
@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSString *userId;

@end

@implementation PomocChatView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
        [self setupHeaderView];
        [self setupChatView];
        
        self.messages = [@[] mutableCopy];
        self.users = [@[] mutableCopy];
        self.userId = @"customer";
        
        [PMCore setDelegate:self];
        [PMCore startConversationWithCompletion:^(NSString *conversationId) {
            self.conversationId = conversationId;
        }];
    }
    return self;
}

#pragma mark - Setup code

- (void)setupView
{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.borderWidth = 0.4;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupHeaderView
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    self.headerView.backgroundColor = [UIColor blueColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:self.headerView.bounds];
    [headerLabel setText:@"Pomoc Chat"];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [self.headerView addSubview:headerLabel];
    
    [self addSubview:self.headerView];
}

- (void)setupChatView
{
    self.chatTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 30)];
    [self.chatTextField setPlaceholder:@"Enter message here"];
    self.chatTextField.delegate = self;
    [self addSubview:self.chatTextField];

    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height - 2*30)];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    [self addSubview:self.chatTableView];
}

- (void)addMessage:(NSString *)message fromUser:(NSString *)user
{
    // Add a new message, and also update the tableview with the new message
    [self.messages addObject:message];
    [self.users addObject:user];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    
    [self.chatTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.chatTableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - PomocCore Delegate
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


#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [PMCore sendMessage:self.chatTextField.text conversationId:self.conversationId];
    self.chatTextField.text = @"";
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

#pragma mark - UITableView datasource/delegate

// Probably don't need to edit anything below
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
