//
//  ChatViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ChatViewController.h"
#import "DashBoardSingleton.h"
#import "ChatMessagePictureCell.h"
#import "ChatMessageTextCell.h"

#import "PomocCore.h"
#import "PMChatMessage.h"
#import "PMMessage.h"

#import "PomocChat.h"

@interface ChatViewController () <PMCoreDelegate> {
    
    //tracking UI table view
    CGRect chatMessageOriginalFrame;
    CGPoint chatInputOriginalCenter;
    CGRect chatNavOriginalFrame;
    
    NSMutableArray *chatList;
    NSMutableArray *chatMessageList;
    NSInteger currentlySelectedChat;
    
    NSString *userName;
}

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Messages";
    
    userName = @"Steve";
    [PMCore initWithAppID:@"anc" userId:userName delegate:self];
    
    //ensuring that no border for chat message table view
    _chatMessageTable.separatorColor = [UIColor clearColor];
    _chatNavTable.separatorColor = [UIColor clearColor];
    
    //storing the original position for moving them up when keyboard show
    chatMessageOriginalFrame = _chatMessageTable.frame;
    chatInputOriginalCenter = _chatInputView.center;
    chatNavOriginalFrame = _chatNavTable.frame;
    
    //border
    _chatMessageTable.layer.borderWidth = 0.5;
    CALayer *leftBorder = [CALayer layer];
    [leftBorder setBackgroundColor:[[UIColor blackColor] CGColor]];
    [leftBorder setFrame:CGRectMake(0, 0, 0.5, _chatInputView.frame.size.height)];
    [_chatInputView.layer addSublayer:leftBorder];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[Utility navigationTitleDesign]];
    
    chatList = [[NSMutableArray alloc] init];
    chatMessageList = [[NSMutableArray alloc] init];
    
    currentlySelectedChat = -1;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"came inside number of rows");
    
    if ([tableView tag] == CHAT_LIST_TABLEVIEW) {
        return [chatList count];
        
    } else if ([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        if ([chatList count] == 0) {
            return 0;
            
        } else {
            return [chatMessageList count];
            //
            //            PomocChat *chat = [chatList objectAtIndex:currentlySelectedChat];
            //            return [chat.chatMessages count];
            //
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
        PomocChat *pomocchat = [chatList objectAtIndex:currentlySelectedChat];
        chatMessageList = pomocchat.chatMessages;
        
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
    
    PomocChat *chat = [chatList objectAtIndex:row];
    
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
    [agentLabel setText:[NSString stringWithFormat: @"2"]];
    
    return cell;
}


#pragma mark - CHAT MESSAGE
- (UITableViewCell *) createChatMessageTableView: (UITableView *)tableView atRow: (NSInteger)row
{
    PomocChat *chat = [chatList objectAtIndex:currentlySelectedChat];
    PMChatMessage *message = [chat.chatMessages objectAtIndex:row];
    
    return [self getChatMessageCell:message tableView:tableView];
    
}

- (UITableViewCell *)getChatMessageCell :(PMChatMessage *)message tableView:(UITableView *)tableView;
{
    
    static NSString *cellIdentifier = @"ChatMessageCell";
    ChatMessageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //Setting visitor name
    [cell.messageFrom setText:message.userId];
    
    //setting the started date of chat
    NSString *dateString = [Utility formatDateForTable:message.timestamp];
    [cell.messageDate setText:[NSString stringWithFormat:@"%@",dateString]];
    
    //setting the display text
    [cell.messageText setText: message.message];
    
    return cell;
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

#pragma mark - PMCore Delegate

- (void)didReceiveMessage:(PMMessage *)pomocMessage conversationId:(NSString *)conversationId
{
    NSLog(@"message delegae called ");
    
    if ([pomocMessage isKindOfClass:[PMChatMessage class]]) {
        
        PMChatMessage *chatMessage = (PMChatMessage *)pomocMessage;
        
        if (![chatMessage.userId isEqualToString:userName]) {
            NSString *message = [NSString stringWithFormat:@"You said: %@", [chatMessage message]];
            [PMCore sendMessage:message conversationId:conversationId];
            
        }
    }
}

- (void)newConversationCreated:(NSString *)conversationId
{
    [PMCore joinConversation:conversationId completion:^(NSArray *messages) {
        
        PomocChat *chat = [[PomocChat alloc] initWithConversation:conversationId];
        [chatList addObject:chat];
        
        [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            PMChatMessage *message = (PMChatMessage *)obj;
            
            if(idx == 0) {
                chat.startedDate = message.timestamp;
                chat.userId = message.userId;
            }
            
            [chat.chatMessages addObject:message];
        }];
        
        [_chatNavTable reloadData];
    }];
}




@end
