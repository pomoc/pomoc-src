//
//  PomocChatView.m
//  PomocSDK
//
//  Created by soedar on 3/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PomocChatView.h"
#import "PomocSupport.h"
#import "PomocChatView+Screenshot.h"

#define CHAT_VIEW_HEADER_HEIGHT     30
#define CHAT_VIEW_FOOTER_HEIGHT     30

@interface PomocChatView () <PMConversationDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UITextField *chatTextField;

@property (nonatomic, strong) PMConversation *conversation;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic) CGFloat originalHeight;

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
        [self setupFooterView];
        [self adjustViewsToHeight:self.frame.size.height];
        
        self.messages = [@[] mutableCopy];
        self.users = [@[] mutableCopy];
        self.userId = nil;
        
        [PMSupport registerUserWithName:@"customer" completion:^(NSString *userId) {
            self.userId = userId;
            [PMSupport startConversationWithCompletion:^(PMConversation *conversation) {
                self.conversation = conversation;
                self.conversation.delegate = self;
            }];
        }];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor blueColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CHAT_VIEW_HEADER_HEIGHT)];
    [headerLabel setText:@"Pomoc Chat"];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [self.headerView addSubview:headerLabel];
    
    [self addSubview:self.headerView];
}

- (void)setupFooterView
{
    self.footerView = [[UIView alloc] init];
    self.chatTextField = [[UITextField alloc] initWithFrame:CGRectMake(CHAT_VIEW_HEADER_HEIGHT, 0, self.frame.size.width-40, CHAT_VIEW_FOOTER_HEIGHT)];
    [self.chatTextField setPlaceholder:@"Enter message here"];
    self.chatTextField.delegate = self;
    [self.footerView addSubview:self.chatTextField];
    [self addSubview:self.footerView];
    
    UIButton *screenshotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [screenshotButton setTitle:@"SS" forState:UIControlStateNormal];
    screenshotButton.frame = CGRectMake(0, 0, CHAT_VIEW_FOOTER_HEIGHT, CHAT_VIEW_FOOTER_HEIGHT);
    [screenshotButton addTarget:self action:@selector(screenshotPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:screenshotButton];
}

- (void)screenshotPressed:(UIButton *)button
{
    UIImage *image = [self screenshotOfMainWindow];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    NSLog(@"Writing to photo album");
}

- (void)setupChatView
{;
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.allowsSelection = NO;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.chatTableView addGestureRecognizer:gestureRecognizer];
    
    [self addSubview:self.chatTableView];
}

- (void)adjustViewsToHeight:(CGFloat)height animate:(BOOL)animate
{
    if (animate) {
        [UIView animateWithDuration:0.3 animations:^{
            [self adjustViewsToHeight:height];
        }];
    } else {
        [self adjustViewsToHeight:height];
    }
}
- (void)adjustViewsToHeight:(CGFloat)height
{
    self.headerView.frame = CGRectMake(0, 0, self.frame.size.width, CHAT_VIEW_HEADER_HEIGHT);
    self.footerView.frame = CGRectMake(0, height-CHAT_VIEW_FOOTER_HEIGHT, self.frame.size.width, CHAT_VIEW_FOOTER_HEIGHT);
    self.chatTableView.frame = CGRectMake(0, CHAT_VIEW_HEADER_HEIGHT, self.frame.size.width, height - CHAT_VIEW_HEADER_HEIGHT - CHAT_VIEW_FOOTER_HEIGHT);
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = height;
    self.frame = viewFrame;
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

#pragma mark - PMMessage Delegate
- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage
{
    [self addMessage:chatMessage.message fromUser:chatMessage.userId];
}


#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![self.chatTextField.text isEqualToString:@""]) {
        [self.conversation sendTextMessage:self.chatTextField.text];
    }
    self.chatTextField.text = @"";
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

#pragma mark - Touch Notifications

- (void)dismissKeyboard
{
    if ([self.chatTextField isFirstResponder]) {
        [self.chatTextField resignFirstResponder];
    }
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *frameValue = keyboardInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardFrame = [frameValue CGRectValue];
    
    // This will probably cause all sort of mayhem for other orientations
    self.originalHeight = self.frame.size.height;
    CGFloat newHeight = [UIScreen mainScreen].bounds.size.height - keyboardFrame.size.height - self.frame.origin.x;
    [self adjustViewsToHeight:newHeight animate:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self adjustViewsToHeight:self.originalHeight animate:YES];
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
