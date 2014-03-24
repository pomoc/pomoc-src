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

#define CHAT_CELL_NAME 1
#define CHAT_CELL_STARTED 2
#define CHAT_CELL_AGENT_NO 3

#define CHAT_LIST_TABLEVIEW 1
#define CHAT_MESSAGE_TABLEVIEW 2

#define CHAT_MESSAGE_CELL_NAME 1
#define CHAT_MESSAGE_TEXT 2
#define CHAT_MESSAGE_DATE 3

@interface ChatViewController (){
    NSArray *dataArray;
    FakePomocSupport *pomocSupport;
    
    //chat message original center
    CGRect chatMessageOriginalFrame;
    CGPoint chatInputOriginalCenter;
}

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Messages";
    dataArray = [[NSArray alloc] initWithObjects:@"Home", @"Chat", nil];
    
    //init POMOC Support to retrieve all the chat
    NSDate *now = [NSDate date];
    NSString *appId = [[DashBoardSingleton sharedModel] appId];
    
    pomocSupport = [[FakePomocSupport alloc] initWithLastUpdatedDate:now andAppId:appId];
    pomocSupport.delegate = self;
    
    [pomocSupport testCallDelegate];
    
    //ensuring that no border for chat message table view
    _chatMessageTable.separatorColor = [UIColor clearColor];
    
    //storing the original position for moving them up when keyboard show
    //chatMessageOriginalCenter = _chatMessageTable.center;
    chatMessageOriginalFrame = _chatMessageTable.frame;
    chatInputOriginalCenter = _chatInputView.center;
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

- (void) chatListOnLoad:(NSArray *)Chat
{
    
}

- (void) newChat: (PomocChat *)Chat
{
    NSLog(@"called new chat");
}

- (void) testProtocol
{
    NSLog(@"called test protocol");
}

- (void) newChatMessage: (PomocChat *)Chat
{
    
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
    // Return the number of rows in the section.
    //return [dataArray count];
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        return [self createChatNavTableView:tableView];
    
    }else if([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        return [self createChatMessageTableView:tableView];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selecting one of the chat side nav
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *visitorNameLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_NAME];
        NSString *visitorName = [visitorNameLabel text];
        [self updateChatViewWithVisitorName:visitorName];
        
    }
    
    
}


#pragma mark - CHAT SIDE NAV
- (UITableViewCell *) createChatNavTableView: (UITableView *) tableView
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Setting visitor name
    UILabel *visitorLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_NAME];
    [visitorLabel setText:@"Visitor XXX"];
    
    //setting the started date of chat
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM 'at' HH:MM"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    UILabel *startedLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_STARTED];
    [startedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Started at",dateString]];
    
    //setting number of agents
    UILabel *agentLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_AGENT_NO];
    [agentLabel setText:@"8"];
    
    return cell;
}


#pragma mark - CHAT MESSAGE
- (UITableViewCell *) createChatMessageTableView: (UITableView *) tableView
{
    static NSString *cellIdentifier = @"ChatMessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Setting visitor name
    UILabel *visitorLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_MESSAGE_CELL_NAME];
    [visitorLabel setText:@"Visitor XXX"];
    
    //setting the started date of chat
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd 'at' HH:MM"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    UILabel *startedLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_MESSAGE_DATE];
    [startedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Started at",dateString]];
    
    //setting number of agents
    UILabel *agentLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_MESSAGE_TEXT];
    [agentLabel setText:@"Hey yoooolooooo yoooolooooo yoooolooooo yoooolooooo yoooolooooo yoooolooooo"];
    
    return cell;
}

- (void) updateChatViewWithVisitorName: (NSString *) visitorName
{
    [self.navigationItem setTitle:visitorName];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    /* keyboard is visible, move views */
    [_chatInputView setCenter:CGPointMake(chatInputOriginalCenter.x, chatInputOriginalCenter.y - 350)];
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height - 350;
    _chatMessageTable.frame = chatMessageOriginalFrame;

    //scrolling to bottom http://stackoverflow.com/questions/5112346/uitableview-scroll-to-bottom-on-reload
    NSInteger totalCell = [_chatMessageTable numberOfRowsInSection:0] - 1;
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: totalCell inSection: 0];
    [_chatMessageTable scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    
    NSLog(@"keyboard visible");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"keyboard hidden");
    _chatInputView.center = chatInputOriginalCenter;
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height + 350;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    /* resign first responder, hide keyboard, move views */
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
@end
