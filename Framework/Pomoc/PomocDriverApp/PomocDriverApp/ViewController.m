//
//  ViewController.m
//  PomocDriverApp
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ViewController.h"
#import "PomocSupport.h"

/*
@interface PMConversation (Hack)

- (id)initWithConversationId:(NSString *)conversationId;
- (void)joinConversationWithCompletion:(void(^)(BOOL success))completion;

@end
 */

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
    
    [PMSupport setDelegate:self];
    
    // User 'login' code
//#ifndef __i386__
//        [PMSupport initWithAppID:@"f29e6e40f7bee2224384895bd5ed139a024ac1e8" secretKey:@"mySecret"];
//        NSString *customer = @"customer25";
//        [PMSupport registerUserWithName:customer completion:^(NSString *userId) {
//            [PMSupport connectWithCompletion:^(BOOL connected) {
//                [PMSupport getAllConversations:^(NSArray *conversations) {
//                    NSLog(@"logged in");
//
////                    NSString *testConversationId = @"test:anc63:chat";
////                    // Handling test
////                    [PMSupport handleConversation:testConversationId];
////                    [PMSupport unhandleConversation:testConversationId];
////                    [PMSupport getHandlersForConversation:testConversationId completion:^(NSArray *handlers) {
////                        NSLog(@"getHandlersForConversation: %@", handlers);
////                    }];
////                    [PMSupport referHandlerConversation:testConversationId refereeUserId:@"9A40ABF6-78CC-41C2-BC06-37FA5ACC6D60"];
////                    
//                    // Online test
//                    [PMSupport pingApp];
//                    //[PMSupport pingConversation:testConversationId];
//                }];
//            }];
//        }];
//#else
//        [PMSupport loginAgentWithUserId:@"steveng.19888@gmail.com" password:@"hehe" completion:^(NSString *userId) {
//            self.userId = userId;
//            NSLog(@"------- USER ID IS %@", userId);
//            [PMSupport connectWithCompletion:^(BOOL connected) {
//                // Get all conversations
//                [PMSupport getAllConversations:^(NSArray *conversations) {
//                    
//                }];
//            }];
//        }];
//#endif
    
    [PMSupport initWithAppID:@"356a192b7913b04c54574d18c28d46e6395428ab" secretKey:@"mySecret"];
    NSString *customer = @"customer11";
    [PMSupport registerUserWithName:customer completion:^(NSString *userId) {
        [PMSupport connectWithCompletion:^(BOOL connected) {
            [PMSupport getAllConversations:^(NSArray *conversations) {
                NSLog(@"logged in");
                
                //                    NSString *testConversationId = @"test:anc63:chat";
                //                    // Handling test
                //                    [PMSupport handleConversation:testConversationId];
                //                    [PMSupport unhandleConversation:testConversationId];
                //                    [PMSupport getHandlersForConversation:testConversationId completion:^(NSArray *handlers) {
                //                        NSLog(@"getHandlersForConversation: %@", handlers);
                //                    }];
                //                    [PMSupport referHandlerConversation:testConversationId refereeUserId:@"9A40ABF6-78CC-41C2-BC06-37FA5ACC6D60"];
                //
                // Online test
                [PMSupport pingApp];
                //[PMSupport pingConversation:testConversationId];
            }];
        }];
    }];

//    [PMSupport loginAgentWithUserId:@"steveng.19888@gmail.com" password:@"hehe" completion:^(NSString *userId) {
//        if (userId) {
//            self.userId = userId;
//            NSLog(@"------- USER ID IS %@", userId);
//            [PMSupport connectWithCompletion:^(BOOL connected) {
//                NSLog(@"Connected: %i", connected);
//                [PMSupport pingApp];
//                //[PMSupport disconnect];
//                /*
//                [PMSupport registerUserWithName:@"hello" completion:^(NSString *userId) {
//                    NSLog(@"User Id is %@", userId);
//                    [PMSupport connectWithCompletion:^(BOOL connected) {
//                        NSLog(@"Im am connected: %i", connected);
//                        // Get all conversations
//                        [PMSupport getAllConversations:^(NSArray *conversations) {
//                            
//                        }];
//                        [PMSupport pingApp];
//                    }];
//                }];
//                 */
//            }];
//        } else {
//            NSLog(@"failed");
//        }
//    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button action

- (IBAction)startConversationPressed:(UIButton *)button
{
    NSMutableArray *currentConversationList = [[NSMutableArray alloc] init];
    
    [button setEnabled:NO];
    [PMSupport startConversationWithCompletion:^(PMConversation *conversation) {
        self.conversation = conversation;
        self.conversation.delegate = self;
        //conversation.delegate = self;
        [currentConversationList addObject:conversation];
        conversation.delegate = self;
        [self.sendButton setHidden:NO];
        [self.textField setHidden:NO];
        [self.textField setReturnKeyType:UIReturnKeySend];
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
    } else if ([self.textField.text isEqualToString:@"status_join"]) {

        [self.conversation sendStatusMessage:PMStatusMessageJoin];
    } else {
        [self.conversation sendTextMessage:self.textField.text];
        //[self.conversation sendNote:self.textField.text];
    }
    self.textField.text = @"";
}

#pragma mark - PMCore Delegate

- (void)newConversationCreated:(PMConversation *)conversation
{
    NSLog(@"New Channel created %@", conversation);
}

- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId referrer:(PMUser *)referrer referee:(PMUser *)referee
{
    NSLog(@"referHandler");
    NSLog(@"hanlders: %@", handlers);
    NSLog(@"conversationId: %@", conversationId);
    NSLog(@"referrer: %@", referrer);
    NSLog(@"referee: %@", referee);
    //[PMSupport handleConversation:conversationId];
    
}

- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId
{
    NSLog(@"updateHandlers");
    NSLog(@"hanlders: %@", handlers);
    NSLog(@"conversationId: %@", conversationId);
}

- (void)updateOnlineUsers:(NSArray *)users
{
    NSLog(@"updateOnlineUsers - app");
    NSLog(@"users: %@", users);
}

- (void)updateOnlineUsers:(NSArray *)users conversationId:(NSString *)conversationId
{
    NSLog(@"updateOnlineUsers - conversation: %@", conversationId);
    NSLog(@"users: %@", users);
}

#pragma mark - PMConversation Delegate

- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage
{
    NSLog(@"did rec msg");
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

- (void)conversation:(PMConversation *)conversation didReceiveStatusMessage:(PMStatusMessage *)statusMessage
{
    NSLog(@"Received status message");
    
}

- (void)conversation:(PMConversation *)conversation didReceiveNote:(NSString *)notes
{
    NSLog(@"Received note: %@", notes);
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
