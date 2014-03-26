//
//  ChatViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ChatViewController.h"
#import "FakePomocSupport.h"
#import "DashBoardSingleton.h"
#import "PomocChat.h"
#import "ChatMessagePictureCell.h"
#import "ChatMessageTextCell.h"
#import "PomocCore.h"

@interface ChatViewController () <PMCoreDelegate> {
    FakePomocSupport *pomocSupport;
    
    //tracking UI table view
    CGRect chatMessageOriginalFrame;
    CGPoint chatInputOriginalCenter;
    CGRect chatNavOriginalFrame;
    
    NSMutableArray *chatArray;
    NSMutableArray *chatMessagesArray;
    NSInteger currentlySelectedChat;
    
}

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PMCore initWithAppID:@"anc" userId:@"Steve" delegate:self];
//    [PMCore startConversationWithUserId:@"Steve" completion:^(NSString *conversationId) {
//        if (conversationId) {
//            NSLog(@"%@", conversationId);
//            [PMCore sendMessage:@"Hello!" userId:@"hehehe" channelId:conversationId];
//        }
//        else {
//            NSLog(@"Failed");
//        }
//    }];
    
    self.title = @"Messages";
    
    //init POMOC Support to retrieve all the chat
    NSDate *now = [NSDate date];
    NSString *appId = [[DashBoardSingleton sharedModel] appId];
    
    pomocSupport = [[FakePomocSupport alloc] initWithLastUpdatedDate:now andAppId:appId];
    pomocSupport.delegate = self;
    
    //ensuring that no border for chat message table view
    _chatMessageTable.separatorColor = [UIColor clearColor];
    _chatNavTable.separatorColor = [UIColor clearColor];
    
    //storing the original position for moving them up when keyboard show
    chatMessageOriginalFrame = _chatMessageTable.frame;
    chatInputOriginalCenter = _chatInputView.center;
    chatNavOriginalFrame = _chatNavTable.frame;
    
    chatArray = [[NSMutableArray alloc] init];
    chatMessagesArray = [[NSMutableArray alloc] init];
    currentlySelectedChat = -1;
    
    //border
    _chatMessageTable.layer.borderWidth = 0.5;
    CALayer *leftBorder = [CALayer layer];
    [leftBorder setBackgroundColor:[[UIColor blackColor] CGColor]];
    [leftBorder setFrame:CGRectMake(0, 0, 0.5, _chatInputView.frame.size.height)];
    [_chatInputView.layer addSublayer:leftBorder];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[Utility navigationTitleDesign]];
}


- (IBAction)viewPastChat:(id)sender
{
    NSLog(@"clicked view past chat!");
}

- (IBAction)viewAction:(id)sender
{
    NSLog(@"clicked view action");
}

- (IBAction)sendMessage:(id)sender {
    
    NSLog(@"user sending message!");
    
    NSLog(@"simulating new chat now");
    [pomocSupport simulateNewChat];
    
    NSLog(@"simulating chat message now");
    [pomocSupport simulateChatMessage];
    
    [pomocSupport simulatePictureMessage];
    
}

- (void) testProtocol
{
    NSLog(@"called test protocol");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    NSLog(@"came inside number of sections");
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"came inside number of rows");
    
    if ([tableView tag] == CHAT_LIST_TABLEVIEW) {
        return [chatArray count];
        
    } else if ([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        if ([chatArray count] == 0) {
            return 0;
            
        } else {
            PomocChat *chat = [chatArray objectAtIndex:currentlySelectedChat];
            return [chat.chatMessages count];
            
        }
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        return [self createChatNavTableView:tableView atRow:row];
    
    }else if([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        return [self createChatMessageTableView:tableView atRow:row];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selecting one of the chat side nav
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        
        currentlySelectedChat = indexPath.row;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        //setting the visitor name
        UILabel *visitorNameLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_NAME];
        NSString *visitorName = [visitorNameLabel text];
        [self.navigationItem setTitle:visitorName];
        
        //setting the chat for chat table view
        PomocChat *pomocchat = [chatArray objectAtIndex:currentlySelectedChat];
        chatMessagesArray = pomocchat.chatMessages;
        
         [_chatMessageTable reloadData];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        return 65;
        
    }else if([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        //call a method that
            //get the cell there
            //get the size
            //calculate the height probably required
        return 100;
    }
    
    return 0;
}

#pragma mark - CHAT SIDE NAV
- (UITableViewCell *) createChatNavTableView: (UITableView *) tableView atRow: (NSInteger)row
{
    static NSString *cellIdentifier = @"ChatTitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    PomocChat *chat = [chatArray objectAtIndex:row];
    
    //Setting visitor name
    UILabel *visitorLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_NAME];
    [visitorLabel setText:chat.visitorName];
    
    //setting the started date of chat
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM 'at' HH:MM"];
    NSString *dateString = [dateFormatter stringFromDate:chat.startedDate];
    
    UILabel *startedLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_STARTED];
    [startedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Started at",dateString]];
    
    //setting number of agents
    UILabel *agentLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_AGENT_NO];
    [agentLabel setText:[NSString stringWithFormat: @"%ld",chat.noOfAgent]];
    
    return cell;
}

- (void) insertNewRow
{
    
//    [_chatNavTable beginUpdates];
//    
//    NSIndexPath *path1 = [NSIndexPath indexPathForRow:temp inSection:0]; //ALSO TRIED WITH indexPathRow:0
//    NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
//    
//    [_chatNavTable insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationRight];
//    
//    [_chatNavTable endUpdates];
    
}


#pragma mark - CHAT MESSAGE
- (UITableViewCell *) createChatMessageTableView: (UITableView *)tableView atRow: (NSInteger)row
{
    PomocChat *chat = [chatArray objectAtIndex:currentlySelectedChat];
    PomocChatMessage *message = [chat.chatMessages objectAtIndex:row];
    
    if (message.messageImage == nil) {
        return [self getChatMessageCell:message tableView:tableView];
        
    } else {
        return [self getChatPictureCell:message tableView:tableView];
    }
    
}


- (UITableViewCell *)getChatPictureCell :(PomocChatMessage *) message tableView:(UITableView *)tableView;
{
    static NSString *cellIdentifier = @"ChatPictureCell";
    ChatMessagePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatMessagePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //Setting visitor name
    [cell.messageFrom setText:message.senderName];
    
    //setting the started date of chat
    NSString *dateString = [self formatDateForTable:message.sentDate];
    [cell.messageDate setText:[NSString stringWithFormat:@"%@",dateString]];
    
    //setting the display picture
    [cell.messagePicture setImage:message.messageImage];
    
    return cell;
}

- (UITableViewCell *)getChatMessageCell :(PomocChatMessage *)message tableView:(UITableView *)tableView;
{
    
    static NSString *cellIdentifier = @"ChatMessageCell";
    ChatMessageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //Setting visitor name
    [cell.messageFrom setText:message.senderName];
    
    //setting the started date of chat
    NSString *dateString = [self formatDateForTable:message.sentDate];
    [cell.messageDate setText:[NSString stringWithFormat:@"%@",dateString]];
    
    //setting the display text
    [cell.messageText setText: message.messageText];
    
    return cell;
}

- (NSString *)formatDateForTable :(NSDate *)dateToFormat
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd 'at' HH:MM"];
    NSString *dateString = [dateFormatter stringFromDate:dateToFormat];
    return dateString;
}

#pragma  mark - Textfield editing delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollThingUp];
}

- (void) scrollThingUp
{
    /* keyboard is visible, move views */
    [_chatInputView setCenter:CGPointMake(chatInputOriginalCenter.x, chatInputOriginalCenter.y - KEYBOARD_UP_OFFSET)];
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height - KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    //scrolling to bottom http://stackoverflow.com/questions/5112346/uitableview-scroll-to-bottom-on-reload
    //    NSInteger totalCell = [_chatMessageTable numberOfRowsInSection:0];
    //    NSIndexPath* ipath = [NSIndexPath indexPathForRow: totalCell inSection: 0];
    //    [_chatMessageTable scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    //
    chatNavOriginalFrame.size.height = chatNavOriginalFrame.size.height - KEYBOARD_UP_OFFSET;
    _chatNavTable.frame = chatNavOriginalFrame;
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _chatInputView.center = chatInputOriginalCenter;
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height + KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    chatNavOriginalFrame.size.height = chatMessageOriginalFrame.size.height + KEYBOARD_UP_OFFSET;
    _chatNavTable.frame = chatNavOriginalFrame;
}

#pragma mark - Pomoc support delgate

- (void) newChat:(PomocChat *) newPomocChat
{
    [chatArray addObject:newPomocChat];
    [_chatNavTable reloadData];
}

-(void) newChatMessage:(PomocChatMessage *) newPomocChatMssage channel:(NSString *)channelId
{
    //Finding the pomoc chat with such channel id and add the chat message in
    NSUInteger count = 0;
    for (PomocChat *pomocChat in chatArray) {
        if ([pomocChat.channelName isEqualToString:channelId]) {

            [pomocChat.chatMessages addObject:newPomocChatMssage];
            
            //new message came to the currently selected chat
            if (count == currentlySelectedChat) {
                chatMessagesArray = pomocChat.chatMessages;
                [_chatMessageTable reloadData];
            }
            break;
        }
        count ++;
    }
    
}

- (void) newPictureMessage: (PomocChatMessage *) newPomocChatMssage channel: (NSString *) channelId
{
    NSUInteger count = 0;
    for (PomocChat *pomocChat in chatArray) {
        if ([pomocChat.channelName isEqualToString:channelId]) {
            
            [pomocChat.chatMessages addObject:newPomocChatMssage];
            
            //new message came to the currently selected chat
            if (count == currentlySelectedChat) {
                chatMessagesArray = pomocChat.chatMessages;
                [_chatMessageTable reloadData];
            }
            break;
        }
        count ++;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 
 @property (readonly) NSString *username;
 @property (readonly) NSString *channel;
 @property (readonly) NSString *type;
 @property (readonly) NSString *message;
 */

#pragma mark - PMCore Delegate
- (void)didReceiveMessage:(PMMessage *)pomocMessage channelId:(NSString *)channelId
{
    NSLog(@"message delegae called ");
    NSLog(@"Username = %@ and channel = %@ and type = %@ and message = %@",
           pomocMessage.username,
           pomocMessage.channel,
           pomocMessage.type,
           pomocMessage.message);
}

- (void) newChannelCreated:(NSString *)channedId
{
    NSLog(@"new channel created with channel id == %@", channedId);
}




@end
