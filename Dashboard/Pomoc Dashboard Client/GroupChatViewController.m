//
//  GroupChatViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 19/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "GroupChatViewController.h"
#import "DashBoardSingleton.h"
#import "ChatMessageTextCell.h"
#import "PMSupport.h"
#import "PMUser.h"

@interface GroupChatViewController ()<UITableViewDataSource, UITableViewDelegate >
{
    DashBoardSingleton *singleton;
    NSMutableArray *agentList;
    BOOL keyboardEditing;
    
    PMConversation *currentChat;
    
    //tracking UI table view
    CGRect chatMessageOriginalFrame;
    CGPoint chatInputOriginalCenter;
}

@end

@implementation GroupChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ensuring that no border for chat message table view
    _chatMessageTable.separatorColor = [UIColor clearColor];
    _chatNavTable.separatorColor = [UIColor clearColor];
    
    //border
    _chatMessageTable.layer.borderWidth = 0.5;
    CALayer *leftBorder = [CALayer layer];
    [leftBorder setBackgroundColor:[[UIColor blackColor] CGColor]];
    [leftBorder setFrame:CGRectMake(_chatInputView.frame.size.width, 0, 0.5, _chatInputView.frame.size.height)];
    [_chatInputView.layer addSublayer:leftBorder];
    
    keyboardEditing = false;
    
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    self.title = @"Group Chat";

    singleton = [DashBoardSingleton singleton];
    agentList = singleton.currentAgentList;
    currentChat = singleton.agentConversation;
    
    singleton.groupChatDelegate = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    //storing the original position for moving them up when keyboard show
    chatMessageOriginalFrame = _chatMessageTable.frame;
    chatInputOriginalCenter = _chatInputView.center;
}

- (IBAction)sendMessage:(id)sender {
   
    NSString *userInput = _textInput.text;
    
    if ( [userInput length] > 0 ) {
        NSLog(@"user sending message!");
        [currentChat sendTextMessage:userInput];
        [_textInput setText:@""];
    }
}

- (void) deallocDelegate
{
    singleton.groupChatDelegate = nil;
}


#pragma mark - Navigation Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView tag] == GROUP_CHAT_TABLEVIEW) {
        return [currentChat.messages count];
    } else if ([tableView tag] ==AGENT_LIST_TABLEVIEW) {
        return [agentList count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if ([tableView tag] == GROUP_CHAT_TABLEVIEW) {
        
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        ChatMessageTextCell *chatCell = (ChatMessageTextCell *)cell;
        PMChatMessage *message = [currentChat.messages objectAtIndex:row];
        
        //setting the started date of chat
        NSString *dateString = [Utility formatDateForTable:message.timestamp];
        
        //Setting visitor name
        [chatCell.messageFrom setText:[NSString stringWithFormat:@"%@   %@",message.user.name, dateString]];
        chatCell.messageText.text = message.message;
        
        return cell;

    } else if ([tableView tag] ==AGENT_LIST_TABLEVIEW) {
        return [self createAgentListTable:tableView atRow:row];
    }
    
    return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView tag] ==AGENT_LIST_TABLEVIEW) {
        return @"Agents online";
    }
    return nil;
}

#pragma mark - POMOC delegate

- (void) agentListUpdated: (NSMutableArray *)updatedAgentList
{
    agentList = updatedAgentList;
    [_chatNavTable reloadData];
}

- (void) newChatMessage: (PMConversation *)conversation
{
    currentChat = conversation;
    [_chatMessageTable reloadData];
    [self scrollChatContentToBottom];
}

#pragma mark - CHAT SIDE NAV
- (UITableViewCell *) createAgentListTable: (UITableView *) tableView atRow: (NSInteger)row
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PMUser *agent = [agentList objectAtIndex:row];
    cell.textLabel.text = agent.name;
    cell.textLabel.font = [UIFont fontWithName:@"Marker Felt" size:17];
    
    UIImage *thumbNail = [UIImage imageNamed:@"worker-512.png"];
    UIImage *scaled = [Utility scaleImage:thumbNail toSize:CGSizeMake(25, 25)];
    
    cell.imageView.image = scaled;
    return cell;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}


#pragma  mark - Textfield editing delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    keyboardEditing = true;
    [self scrollThingUp];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage:self];
    return YES;
}

- (void) scrollThingUp
{
    [_chatInputView setCenter:CGPointMake(chatInputOriginalCenter.x, chatInputOriginalCenter.y - KEYBOARD_UP_OFFSET)];
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height - KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    [self scrollChatContentToBottom];
    
    
}

- (void) scrollChatContentToBottom
{
    NSInteger numberOfRows = [_chatMessageTable numberOfRowsInSection:0];
    if (numberOfRows) {
        [_chatMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    keyboardEditing = false;
    _chatInputView.center = chatInputOriginalCenter;
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height + KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
}




@end
