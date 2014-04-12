//
//  ViewController.m
//  PomocDriverApp
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ViewController.h"
#import "PomocSupport.h"

@interface ViewController () <PMSupportDelegate, PMConversationDelegate, UITableViewDataSource, UITableViewDelegate>

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
    
    [PMSupport initWithAppID:@"anc" secretKey:@"mySecret"];
    [PMSupport setDelegate:self];
    
    // User 'login' code
    
    NSString *customer = @"customer";
    [PMSupport registerUserWithName:customer completion:^(NSString *userId) {
        [PMSupport connect];
    }];
    
    // Agent 'login' code
    /*
    [PMSupport loginAgentWithUserId:@"testuser" password:@"testpassword" completion:^(NSString *userId) {
        self.userId = userId;
        NSLog(@"------- USER ID IS %@", userId);
        [PMSupport connectWithCompletion:^(BOOL connected) {
        }];
    }];
     */
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
    [PMSupport startConversationWithCompletion:^(PMConversation *conversation) {
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
    if ([self.textField.text isEqualToString:@"image_large"]) {
        UIImage *image = [UIImage imageNamed:@"image_large"];
        [self.conversation sendImageMessage:image];
    } else if ([self.textField.text isEqualToString:@"image_small"]) {
        UIImage *image = [UIImage imageNamed:@"image_small"];
        [self.conversation sendImageMessage:image];
    } else {
        [self.conversation sendTextMessage:self.textField.text];
    }
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
    [self addMessage:chatMessage fromUser:chatMessage.user];
}

- (void)conversation:(PMConversation *)conversation didReceiveImageMessage:(PMImageMessage *)imageMessage
{
    // CHeck if the image message is right
    NSLog(@"Received image");
    NSIndexPath *indexPath = [self addMessage:imageMessage fromUser:imageMessage.user];
    [imageMessage retrieveImageWithCompletion:^(UIImage *image) {
        NSLog(@"Received image in completion");
        [self.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark - Adding Message

- (NSIndexPath *)addMessage:(PMChatMessage *)message fromUser:(PMUser *)user
{
    // Add a new message, and also update the tableview with the new message
    [self.messages addObject:message];
    [self.users addObject:user];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    
    [self.chatTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.chatTableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return newIndexPath;
}

#pragma mark - TableViewDelegate/DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMChatMessage *chatMessage = self.messages[indexPath.row];
    
    if ([chatMessage isKindOfClass:[PMImageMessage class]]) {
        return 220;
    }
    return 50;
}

// Probably don't need to edit anything below
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *chatCellId = @"ChatCell";
    static NSString *imageCellId = @"ImageCell";
    
    PMChatMessage *chatMessage = self.messages[indexPath.row];
    
    UITableViewCell *cell;
    if ([chatMessage isKindOfClass:[PMImageMessage class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:imageCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellId];
        }
        
        // Clear the content view
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        PMImageMessage *imageMessage = (PMImageMessage *)chatMessage;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [imageView setBackgroundColor:[UIColor grayColor]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [cell.contentView addSubview:imageView];
        
        if (imageMessage.image) {
            [imageView setImage:imageMessage.image];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:chatCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:chatCellId];
        }
        cell.textLabel.text = chatMessage.message;
        cell.detailTextLabel.text = [self.users[indexPath.row] name];
    }
    
    return cell;
}

@end
