//
//  ChatViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 18/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//
#import "UploadViewController.h"
#import "ChatViewController.h"
#import "DashBoardSingleton.h"
#import "ChatMessagePictureCell.h"
#import "ChatMessageTextCell.h"

#import "PomocCore.h"
#import "PMChatMessage.h"
#import "PMMessage.h"

#import "PomocChat.h"

#import "UILabel+boldAndGray.h"

#import "UIImageView+WebCache.h"

//testing
#import "FakePMChatMessage.h"
#import "FakePMImageMessage.h"

#import "AnnotateViewController.h"

@interface ChatViewController () <PMCoreDelegate, UINavigationControllerDelegate, AnnotateViewControllerDelegate> {
    
    //tracking UI table view
    CGRect chatMessageOriginalFrame;
    CGPoint chatInputOriginalCenter;
    CGRect chatNavOriginalFrame;
    
    NSMutableArray *chatList;
    NSMutableArray *chatMessageList;
    NSInteger currentlySelectedChat;
    NSString *currentSelectedConvoId;
    
    NSString *userName;
    BOOL keyboardEditing;
    
    UIPopoverController *uploadSegue;
}

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Messages";
    
    userName = @"Steve";
    //[PMCore initWithAppID:@"anc" userId:userName delegate:self];
    
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
    currentSelectedConvoId = @"";
    keyboardEditing = false;
    
    _pastAndInfoToolbar.clipsToBounds = true;
    
    //testing
    [self testCreateMock];
}

- (IBAction)viewAction:(id)sender
{
    NSLog(@"clicked view action");
}

- (IBAction)sendMessage:(id)sender {
    
    NSLog(@"user sending message!");
    NSString *userInput = _userTextInput.text;
    [PMCore sendMessage:userInput conversationId:currentSelectedConvoId];
    [_userTextInput setText:@""];
    
}

- (IBAction)annotateActionPressed:(id)sender {
    NSArray *subviews = [sender superview].subviews;
    UIImageView *imv;
    for (int i=0; i<[subviews count]; i++) {
        if ([subviews[i] isKindOfClass:[UIImageView class]] &&
            ((UIImageView *)subviews[i]).image) {
            imv = subviews[i];
        }
    }
    if (imv) {
        UIImage *picture = imv.image;
        AnnotateViewController *annotateVC = [[AnnotateViewController alloc] initWithImage:picture];
        annotateVC.delegate = self;
        [self.navigationController pushViewController:annotateVC animated:YES];
    }
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

#pragma mark - UINavigationController methods
- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return YES;
}

#pragma mark - Navigation Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView tag] == CHAT_LIST_TABLEVIEW) {
        return [chatList count];
        
    } else if ([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        if ([chatList count] == 0) {
            return 0;
            
        } else {
            return [chatMessageList count];
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
        
        PomocChat *chat = [chatList objectAtIndex:currentlySelectedChat];
        id obj = [chat.chatMessages objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[FakePMChatMessage class]] ||
            [obj isKindOfClass:[PMChatMessage class]]) {
            
            NSLog(@"is chat message");
            return [self createChatMessageTableView:tableView atRow:row];
            
        } else if([obj isKindOfClass:[FakePMImageMessage class]]) {
            NSLog(@"is picture message");
            return [self createChatImageTableView: tableView atRow:row];
        }
    
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
        
        currentSelectedConvoId = pomocchat.conversationId;
        
        [_chatMessageTable reloadData];
        [self scrollChatContentToBottom];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        return 65;
        
    }else if([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        
        PomocChat *chat = [chatList objectAtIndex:currentlySelectedChat];
        id obj = [chat.chatMessages objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[PMChatMessage class]] ||
            [obj isKindOfClass:[FakePMChatMessage class]]) {
        
            PMChatMessage *message = [chat.chatMessages objectAtIndex:indexPath.row];
            NSString *text = message.message;
        
            //[[message.message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] boundingRectWithSize:CGSizeMake(695, 999)] ];
            UILabel *gettingSizeLabel = [[UILabel alloc] init];
            gettingSizeLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            gettingSizeLabel.text = text;
            gettingSizeLabel.numberOfLines = 0;
            gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize maximumLabelSize = CGSizeMake(695, 9999);
        
            CGSize expectedSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
        
            return expectedSize.height + 35;
        } else {
            return 170;
        }
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
    [visitorLabel setText:chat.userId];
    
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
-(UITableViewCell *) createChatImageTableView: (UITableView *)tableView atRow: (NSInteger)row
{
    PomocChat *chat = [chatList objectAtIndex:currentlySelectedChat];
    FakePMImageMessage *message = [chat.chatMessages objectAtIndex:row];
    
    return [self getChatImageCell :message tableView:tableView];
}

- (UITableViewCell *)getChatImageCell :(FakePMImageMessage *)message tableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"ChatPictureCell";
    ChatMessagePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatMessagePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //setting the started date of chat
    NSString *dateString = [Utility formatDateForTable:message.timestamp];
    
    //Setting visitor name
    [cell.messageFrom setText:[NSString stringWithFormat:@"%@   %@",message.userId, dateString]];
    [cell.messageFrom boldAndBlackSubstring:message.userId];
    
    //setting the display text
    UIImage *image = [UIImage imageNamed:message.imageUrl];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;

    __weak typeof(UITableViewCell *) weakCell = cell;
    [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://28.media.tumblr.com/tumblr_lwdu1460fh1r7o3dfo1_500.jpg"]
                    placeholderImage:image
                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                        UIImage *scaled = [Utility scaleImage:image toSize:CGSizeMake(120, 120)];
                        [weakCell.imageView setImage:scaled];
                        
                    }];
    
    return cell;
}

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
    
    //setting the started date of chat
    NSString *dateString = [Utility formatDateForTable:message.timestamp];
    
    //Setting visitor name
    [cell.messageFrom setText:[NSString stringWithFormat:@"%@   %@",message.userId, dateString]];
    [cell.messageFrom boldAndBlackSubstring:message.userId];
    
    //setting the display text
    [cell.messageText setText: message.message];
    
    
    return cell;
}

#pragma  mark - Preparation for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"uploadPicture"]) {
        
        UploadViewController *child = [segue destinationViewController];
        child.delegate = self;
        uploadSegue = ((UIStoryboardPopoverSegue *) segue).popoverController;
    }
}

#pragma mark - Upload View Controller Delegate 
- (void)pictureSelected:(UIImage *)image
{
    //dismiss segue
    [uploadSegue dismissPopoverAnimated:YES];
    
    //handling of photo
    NSLog(@"picture selected");
}

- (void) closePopOver
{
    [uploadSegue dismissPopoverAnimated:YES];
}

#pragma  mark - Textfield editing delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    keyboardEditing = true;
    [self scrollThingUp];
}

- (void) scrollThingUp
{
    [_chatInputView setCenter:CGPointMake(chatInputOriginalCenter.x, chatInputOriginalCenter.y - KEYBOARD_UP_OFFSET)];
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height - KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    /* keyboard is visible, move views */
    [self scrollChatContentToBottom];
    
    //change chat nav table height
    chatNavOriginalFrame.size.height = chatNavOriginalFrame.size.height - KEYBOARD_UP_OFFSET;
    _chatNavTable.frame = chatNavOriginalFrame;
    
}

- (void) scrollChatMessageUp
{
    [_chatInputView setCenter:CGPointMake(chatInputOriginalCenter.x, chatInputOriginalCenter.y - KEYBOARD_UP_OFFSET)];
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height - KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    /* keyboard is visible, move views */
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
    NSLog(@"called end editing");
    _chatInputView.center = chatInputOriginalCenter;
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height + KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    chatNavOriginalFrame.size.height = chatMessageOriginalFrame.size.height + KEYBOARD_UP_OFFSET;
    _chatNavTable.frame = chatNavOriginalFrame;
}
#pragma mark - Testing
- (void) testCreateMock
{
    //create some conversaiton
    PomocChat *chat = [[PomocChat alloc] initWithConversation:@"1"];
    [chatList addObject:chat];

    chat.userId = @"Visitor";
    chat.startedDate = [NSDate new];

    //add some messages inside
    FakePMChatMessage *message = [[FakePMChatMessage alloc] init];
    message.message = @"0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789 0123456789";
    message.conversationId = @"1";
    message.userId = @"visitor";
    
    FakePMChatMessage *message2 = [[FakePMChatMessage alloc] init];
    message2.message = @"simi rans jiao? ";
    message2.conversationId = @"1";
    message2.userId = @"agent Chun Mun";
    
    FakePMChatMessage *message3 = [[FakePMChatMessage alloc] init];
    message3.message = @"simi rans rans jiao? ";
    message3.conversationId = @"1";
    message3.userId = @"agent Steve";
    
    FakePMImageMessage *image1 = [[FakePMImageMessage alloc] init];
    image1.userId = @"visitor";
    image1.conversationId = @"1";
    image1.imageUrl = @"testImage.png";
    
    FakePMChatMessage *message4 = [[FakePMChatMessage alloc] init];
    message4.message = @"simi rans rans rans jiao? ";
    message4.conversationId = @"1";
    message4.userId = @"Agent BangHui";
    
    [chat.chatMessages addObject:message];
    [chat.chatMessages addObject:message2];
    [chat.chatMessages addObject:message3];
    [chat.chatMessages addObject:image1];
    [chat.chatMessages addObject:message4];
    
    [_chatNavTable reloadData];
}

#pragma mark - PMCore Delegate
- (void)didReceiveMessage:(PMMessage *)pomocMessage conversationId:(NSString *)conversationId
{
    NSLog(@"message delegae called ");
    
    if ([pomocMessage isKindOfClass:[PMChatMessage class]]) {
        
        PMChatMessage *chatMessage = (PMChatMessage *)pomocMessage;
        
        //if (![chatMessage.userId isEqualToString:userName]) {
            
            PomocChat *chatMessageConv = [self getPomocChatGivenConversationId:conversationId];
            [chatMessageConv.chatMessages addObject:chatMessage];
            
            //check if current chat being displayed is where the new chat message comign in
            if (currentlySelectedChat != -1) {
                
                PomocChat *currentChat = chatList[currentlySelectedChat];
                
                if (currentChat == chatMessageConv) {
                    [_chatMessageTable reloadData];
                    [self scrollChatContentToBottom];
                    
                }
            }
        //}
    }
}

- (void)newConversationCreated:(NSString *)conversationId
{
    NSLog(@"new conversation!");
    
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

- (PomocChat *) getPomocChatGivenConversationId: (NSString *)conversationId
{
    for (PomocChat *chat in chatList) {
        if ([chat.conversationId isEqualToString:conversationId]) {
            return chat;
        }
    }
    
    return nil;
}

#pragma mark - Upload View Controller Delegate
- (void)userCompleteAnnotation:(UIImage *)image
{
    NSLog(@"called user complete annotation !");
    
}

@end
