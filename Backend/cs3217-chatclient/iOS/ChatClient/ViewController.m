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
@property BOOL hasChannel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.messages = [@[] mutableCopy];
    self.users = [@[] mutableCopy];
    self.usernameLabel.text = [NSString stringWithFormat:@"User %i", arc4random()%10000];
    self.socketIO = [self connectSocketIO];
    self.hasChannel = false;

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

#pragma mark - Send Button Action

- (IBAction)sendMessage:(UIButton *)sender
{
    // Set channel
    if (!self.hasChannel) {
        [self.socketIO sendJSON:@{@"type": @"setChannel",
                                  @"channel": self.messageTextField.text}];
        self.hasChannel = true;
        [sender setTitle:@"send" forState:UIControlStateNormal];
        
    }
    // Send Message
    else {
        [self.socketIO sendJSON:@{@"type": @"chat",
                                  @"message": self.messageTextField.text}];
    }
    self.messageTextField.text = @"";
}

#pragma mark - SocketIO Delegate method - receiving incoming messages

- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage >>> data: %@", packet.data);
    [self addMessage:packet.data fromUser:@"received lazy to write properly"];
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
