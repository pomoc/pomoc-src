//
//  ViewController.m
//  ChatClient
//
//  Created by soedar on 13/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITableView *chatTableView;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) SocketIO * socketIO;

// FOR TESTING
@property NSString * username;
@property NSString * channel;
@property NSString * appId;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.messages = [@[] mutableCopy];
    self.users = [@[] mutableCopy];
    self.socketIO = [self connectSocketIO];
    self.username = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    self.usernameLabel.text = self.username;
    self.appId = @"testappid";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set up socket connection

- (SocketIO *)connectSocketIO
{
    SocketIO * socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:PORT];
    return socketIO;
}

#pragma mark - Init chat channel

- (void)initChatChannelwithUsername:(NSString *)username withAppId:(NSString *)appId
{
    PomocMessage * message = [[PomocMessage alloc] initWithUsername:username
                                                        withChannel:appId
                                                           withType:MSG_TYPE_INIT
                                                        withMessage:@""];
    // Set chat channel Id
    SocketIOCallback cb = ^(id argsData) {
        PomocMessage * response = [[PomocMessage alloc] initWithJSONString: (NSString *)argsData];
        NSLog(@"init callback: %@", [response getJSONObject]);
        // TODO: set initialized channel id for user
        // STUB
        self.channel = response.channel;
    };
    [self.socketIO sendEvent:@"init" withData:[message getJSONObject] andAcknowledge:cb];
    
}

#pragma mark - Send chat message

- (void)sendMessage:(NSString *)msg withUsername:(NSString *)username withChannel:(NSString *)channel
{
    PomocMessage * message = [[PomocMessage alloc] initWithUsername:username
                                                        withChannel:channel
                                                           withType:MSG_TYPE_CHAT
                                                        withMessage:msg];
    [self.socketIO sendJSON:[message getJSONObject]];
}

#pragma mark - Subscribe to channel

- (void)subscribeUsername:(NSString *)username toChannel:(NSString *)channel
{
    PomocMessage * message = [[PomocMessage alloc] initWithUsername:username
                                                        withChannel:channel
                                                           withType:MSG_TYPE_SUB
                                                        withMessage:@"" ];
    [self.socketIO sendJSON:[message getJSONObject]];
}

#pragma mark - Unsubscribe from channel

- (void)unsubscribeUsername:(NSString *)username fromChannel:(NSString *)channel
{
    PomocMessage * message = [[PomocMessage alloc] initWithUsername:username
                                                        withChannel:channel
                                                           withType:MSG_TYPE_UNSUB
                                                        withMessage:@"" ];
    [self.socketIO sendJSON:[message getJSONObject]];
}

#pragma mark - SocketIO Delegate method - receiving incoming messages

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage >>> data: %@", packet.data);
    PomocMessage * message = [[PomocMessage alloc] initWithJSONString:packet.data];

    // Normal chat message
    if ([message.type isEqualToString:MSG_TYPE_CHAT]) {
        // TODO: display chat message
        // STUB
        [self addMessage:message.message fromUser:message.username fromChannel:message.channel];
    }
    
    // Notification message
    else if([message.type isEqualToString:MSG_TYPE_NOTIFY]) {
        // Automatically subscribes user to channel
        [self subscribeUsername:message.username toChannel:message.channel];
        // TODO: show new chat in sidepanel or somethingy
        // STUB
    }
}




/* METHODS BELOW ARE FOR TESTING ONLY */

#pragma mark - Send Button Action

- (IBAction)sendButtonPressed:(UIButton *)sender
{
    [self initChatChannelwithUsername:self.username withAppId:self.appId];
}

#pragma mark - Adding Message

- (void)addMessage:(NSString *)message fromUser:(NSString *)user fromChannel:(NSString *)channel
{
    // Add a new message, and also update the tableview with the new message
    NSString * userAndChannel = [user stringByAppendingString:channel];
    [self.messages addObject:message];
    [self.users addObject:userAndChannel];
    
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
