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
#import "PomocChatView+Login.h"
#import "PomocChatView+Image.h"
#import "PomocWindow.h"
#import "PomocResources.h"
#import "PomocChatView_Private.h"

@interface PomocChatView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UITextField *chatTextField;

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *users;

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
        
        [self setupLoginView];
        
        self.messages = [@[] mutableCopy];
        self.users = [@[] mutableCopy];
        
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
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CHAT_VIEW_HEADER_HEIGHT)];
    self.headerView.backgroundColor = [UIColor colorWithRed:24/255.0 green:181/255.0 blue:240/255.0 alpha:1.0];
    
    UIImage *pomocHeader = [PomocResources imageNamed:@"logo-word" type:@"png"];
    UIImageView *pomocImageView = [[UIImageView alloc] initWithImage:pomocHeader];
    
    [pomocImageView setContentMode:UIViewContentModeScaleAspectFit];
    pomocImageView.frame = CGRectMake(0, 4, self.frame.size.width, 32);
    
    
    [self.headerView addSubview:pomocImageView];
    
    [self addSubview:self.headerView];
}

- (void)setupFooterView
{
    self.footerView = [[UIView alloc] init];
    self.chatTextField = [[UITextField alloc] initWithFrame:CGRectMake(CHAT_VIEW_HEADER_HEIGHT+5, 0, self.frame.size.width-2*CHAT_VIEW_FOOTER_HEIGHT, CHAT_VIEW_FOOTER_HEIGHT)];
    [self.chatTextField setPlaceholder:@"Enter message here"];
    self.chatTextField.delegate = self;
    [self.footerView addSubview:self.chatTextField];
    [self addSubview:self.footerView];
    
    UIImage *screenshotImage = [PomocResources imageNamed:@"attach-512" type:@"png"];
    UIButton *screenshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [screenshotButton setImage:screenshotImage forState:UIControlStateNormal];
    screenshotButton.frame = CGRectMake(0, 0, CHAT_VIEW_FOOTER_HEIGHT, CHAT_VIEW_FOOTER_HEIGHT);
    [screenshotButton addTarget:self action:@selector(screenshotPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:screenshotButton];
    
    
    UIImage *sendImage = [PomocResources imageNamed:@"send_file-512" type:@"png"];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(self.frame.size.width-CHAT_VIEW_FOOTER_HEIGHT, 0, CHAT_VIEW_FOOTER_HEIGHT, CHAT_VIEW_FOOTER_HEIGHT);
    [sendButton setImage:sendImage forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:sendButton];
}

- (void)screenshotPressed:(UIButton *)button
{
    UIImage *image = [self screenshotOfMainWindow];
    [self.conversation sendImageMessage:image];
}

- (void)sendPressed:(UIButton *)button
{
    if (![self.chatTextField.text isEqualToString:@""]) {
        [self.conversation sendTextMessage:self.chatTextField.text];
    }
    self.chatTextField.text = @"";
}

- (void)setupChatView
{;
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

- (NSIndexPath *)addMessageToTableView:(PMChatMessage *)message
{
    // Add a new message, and also update the tableview with the new message
    [self.messages addObject:message];
    [self.users addObject:message.user];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    
    [self.chatTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.chatTableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return newIndexPath;
}

#pragma mark - PMMessage Delegate
- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage
{
    [self addMessageToTableView:chatMessage];
}

- (void)conversation:(PMConversation *)conversation didReceiveImageMessage:(PMImageMessage *)imageMessage
{
    NSIndexPath *indexPath = [self addMessageToTableView:imageMessage];
    [imageMessage retrieveImageWithCompletion:^(UIImage *image) {
        [self.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)conversation:(PMConversation *)conversation didReceiveStatusMessage:(PMStatusMessage *)statusMessage
{
    [self addMessageToTableView:statusMessage];
}


#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendPressed:nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMChatMessage *chatMessage = self.messages[indexPath.row];
    if ([chatMessage isKindOfClass:[PMImageMessage class]]) {
        return self.frame.size.width / 3.0 + 40;
    } else if ([chatMessage isKindOfClass:[PMStatusMessage class]]) {
        return CHAT_STATUS_CELL_HEIGHT;
    }
    return CHAT_TEXT_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMChatMessage *chatMessage = self.messages[indexPath.row];
    if ([chatMessage isKindOfClass:[PMImageMessage class]]) {
        PMImageMessage *imageMessage = (PMImageMessage *)chatMessage;
        [self showImage:imageMessage.image];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *chatCellId = @"ChatCell";
    static NSString *imageCellId = @"ImageCell";
    static NSString *statusCellId = @"StatusCell";
    
    PMChatMessage *chatMessage = self.messages[indexPath.row];
   
 
    UITableViewCell *cell;
    if ([chatMessage isKindOfClass:[PMImageMessage class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:imageCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:imageCellId];
        }
        
        // Clear the content view
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        PMImageMessage *imageMessage = (PMImageMessage *)chatMessage;
        CGFloat dimension = self.frame.size.width / 3.0;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, cell.contentView.bounds.size.width, 20)];
        NSAttributedString *userDetail = [self userStringFromMessage:chatMessage];
        [textLabel setAttributedText:userDetail];
        [cell.contentView addSubview:textLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, dimension, dimension)];
        [imageView setBackgroundColor:[UIColor grayColor]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [cell.contentView addSubview:imageView];
        
        if (imageMessage.image) {
            [imageView setImage:imageMessage.image];
        }
    } else if ([chatMessage isKindOfClass:[PMStatusMessage class]]) {
        PMStatusMessage *statusMessage = (PMStatusMessage *)chatMessage;
        
        cell = [tableView dequeueReusableCellWithIdentifier:statusCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:chatCellId];
        }
        
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
       
        NSString *statusText;
        if (statusMessage.code == PMStatusMessageJoin) {
            statusText = @" joined";
        } else if (statusMessage.code == PMStatusMessageLeave) {
            statusText = @" left";
        }
        
        NSMutableAttributedString *userDetails = [[NSMutableAttributedString alloc] init];
        NSDictionary *usernameAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                             NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:12]};
        NSAttributedString *username = [[NSAttributedString alloc] initWithString:chatMessage.user.name attributes:usernameAttributes];
        
        NSDictionary *statusAttributes = @{NSForegroundColorAttributeName: [UIColor grayColor],
                                              NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:12]};
        NSAttributedString *status = [[NSAttributedString alloc] initWithString:statusText attributes:statusAttributes];
        
        [userDetails appendAttributedString:username];
        [userDetails appendAttributedString:status];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, cell.contentView.bounds.size.width-15, 20)];
        [label setAttributedText:userDetails];
        [cell.contentView addSubview:label];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:chatCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:chatCellId];
        }
        
        NSAttributedString *userDetails = [self userStringFromMessage:chatMessage];
        [cell.textLabel setAttributedText:userDetails];
        
        cell.detailTextLabel.text = chatMessage.message;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (NSAttributedString *)userStringFromMessage:(PMChatMessage *)chatMessage
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" 'at' hh:mm a"];
    NSString *timeString = [dateFormatter stringFromDate:chatMessage.timestamp];
   
    NSString *userName = chatMessage.user.name;
    if ([chatMessage.user.type isEqualToString:@"agent"]) {
        userName = [NSString stringWithFormat:@"%@ (agent)", userName];
    }
    
    NSMutableAttributedString *userDetails = [[NSMutableAttributedString alloc] init];
    NSDictionary *usernameAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                         NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:12]};
    NSAttributedString *username = [[NSAttributedString alloc] initWithString:userName attributes:usernameAttributes];
    
    NSDictionary *timestampAttributes = @{NSForegroundColorAttributeName: [UIColor grayColor],
                                          NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:12]};
    NSAttributedString *timestamp = [[NSAttributedString alloc] initWithString:timeString attributes:timestampAttributes];
    
    
    [userDetails appendAttributedString:username];
    [userDetails appendAttributedString:timestamp];
    
    return userDetails;
}

@end
