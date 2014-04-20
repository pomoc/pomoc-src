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

#import "ReferTableViewController.h"

#import "PomocCore.h"
#import "PomocSupport.h"
#import "PMChatMessage.h"
#import "PMMessage.h"

#import "UILabel+boldAndGray.h"

#import "UIImageView+WebCache.h"

#import "DashBoardSingleton.h"

#import "AnnotateViewController.h"

@interface ChatViewController () < UINavigationControllerDelegate, AnnotateViewControllerDelegate, PomocChatDelegate, ReferDelegate> {
    
    //tracking UI table view
    CGRect chatMessageOriginalFrame;
    CGPoint chatInputOriginalCenter;
    CGRect chatNavOriginalFrame;
    
    NSMutableArray *chatList;
    
    //New way of 3 type of chat list
    NSMutableArray *unhandledChatList;
    NSMutableArray *handlingChatList;
    NSMutableArray *otherChatList;
    
    NSMutableArray *chatMessageList;
    NSInteger currentlySelectedChatRow;
    NSString *currentSelectedConvoId;
    PMConversation *currentlySelectedConvo;
    
    NSString *userId;
    NSString *userName;
    BOOL keyboardEditing;
    
    DashBoardSingleton *singleton;
    
    UIPopoverController *uploadSegue;
    UIPopoverController *referSegue;
    
    __block NSArray *referList;
    
}

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    NSLog(@"hehhe");
    [super viewDidLoad];
    self.title = @"Messages";
    
    //ensuring that no border for chat message table view
    _chatMessageTable.separatorColor = [UIColor clearColor];
    _chatNavTable.separatorColor = [UIColor clearColor];
    
    //border
    _chatMessageTable.layer.borderWidth = 0.5;
    CALayer *leftBorder = [CALayer layer];
    [leftBorder setBackgroundColor:[[UIColor blackColor] CGColor]];
    [leftBorder setFrame:CGRectMake(0, 0, 0.5, _chatInputView.frame.size.height)];
    [_chatInputView.layer addSublayer:leftBorder];
    _chatInputView.hidden = TRUE;
    
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    
    currentlySelectedChatRow = -1;
    currentlySelectedConvo = nil;
    currentSelectedConvoId = @"";
    keyboardEditing = false;
    
    _pastAndInfoToolbar.clipsToBounds = true;
    
    chatList = [[NSMutableArray alloc] init];
    chatMessageList = [[NSMutableArray alloc] init];
    
    singleton = [DashBoardSingleton singleton];
    [singleton setChatDelegate:self];
    chatList = singleton.currentConversationList;
    
    //NEW FILTER
    unhandledChatList = [[NSMutableArray alloc] init];
    handlingChatList = [[NSMutableArray alloc] init];
    otherChatList = [[NSMutableArray alloc] init];
    
    [self splitChatIntoGroups];
    
    [_chatNavTable reloadData];
    
    //storing the original position for moving them up when keyboard show
    chatMessageOriginalFrame = _chatMessageTable.frame;
    chatInputOriginalCenter = _chatInputView.center;
    chatNavOriginalFrame = _chatNavTable.frame;
    chatNavOriginalFrame.size.width = 280;
    
    _toolBarView.hidden = TRUE;
}
     
- (void) splitChatIntoGroups {
    NSLog(@"came inside split");
    [unhandledChatList removeAllObjects];
    [handlingChatList removeAllObjects];
    [otherChatList removeAllObjects];
    
    for (PMConversation *convo in chatList) {
        
        if ([convo.handlers count] == 0) {
            [unhandledChatList addObject:convo];
        
        } else {
            
            BOOL selfHandled = FALSE;
            
            for (PMUser *handler in convo.handlers) {

                if ([handler.userId isEqualToString: singleton.selfUserId]) {
                    selfHandled = true;
                }
            }
            
            if (selfHandled) {
                [handlingChatList addObject:convo];
            } else {
                [otherChatList addObject:convo];
            }
            
        }
    }
    
    NSArray *sortedArray;
    
    sortedArray = [unhandledChatList sortedArrayUsingComparator:^NSComparisonResult(id first, id second) {
        
        PMConversation *a = first;
        PMConversation *b = second;

        PMMessage *aLastMessage = [a.messages lastObject];
        PMMessage *bLastMessage = [b.messages lastObject];
        
        NSDate *aDate = aLastMessage.timestamp;
        NSDate *bDate = bLastMessage.timestamp;
        
        return [aDate compare:bDate];
    }];
    
    unhandledChatList = [[NSMutableArray alloc] initWithArray:sortedArray];
    
}

- (IBAction)sendMessage:(id)sender {

    NSString *userInput = _userTextInput.text;
    
    if ( [userInput length] > 0 ) {
        NSLog(@"user sending message!");
        [currentlySelectedConvo sendTextMessage:userInput];
        [_userTextInput setText:@""];
    }
}

- (IBAction)handleActionPressed:(id)sender {
    
    NSLog(@"hande button pressed");
    
    if ([[_handleActionLabel title] isEqualToString: @"Handle"]) {
        [singleton handleConversation:currentSelectedConvoId];
        [_handleActionLabel setTitle:@"Unhandle"];
    } else {
        [singleton unhandleConversation:currentSelectedConvoId];
        [_handleActionLabel setTitle:@"Handle"];
    }
    
}

#pragma mark - Action button
- (IBAction)viewAction:(id)sender
{
    
}

#pragma mark - annotation related

- (IBAction)annotateActionPressed:(id)sender {
    
    NSArray *subviews = [sender superview].subviews;
    UIImageView *imv;
    NSLog(@"sub views count == %lu", (unsigned long)[subviews count]);
    for (int i=0; i<[subviews count]; i++) {
        if ([subviews[i] isKindOfClass:[UIImageView class]] &&
            ((UIImageView *)subviews[i]).image) {
            NSLog(@"met criteria!");
            imv = subviews[i];
            break;
        }
    }
    
    if (imv) {
        UIImage *picture = imv.image;
        AnnotateViewController *annotateVC = [[AnnotateViewController alloc] initWithImage:picture];
        annotateVC.delegate = self;
        [self.navigationController pushViewController:annotateVC animated:YES];
    }
}

- (void)userCompleteAnnotation:(UIImage *)image
{
    NSLog(@"called user complete annotation !");
    [currentlySelectedConvo sendImageMessage:image];
}

#pragma mark - Upload View Controller Delegate
- (void)pictureSelected:(UIImage *)image
{
    NSLog(@"sending image");
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        [currentlySelectedConvo sendImageMessage:image];
    });
}

#pragma mark - Navigation Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView tag] ==CHAT_LIST_TABLEVIEW) {
        return 3;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView tag] == CHAT_LIST_TABLEVIEW) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 12)];
        [label setFont:[UIFont fontWithName:@"Avenir" size:14]];
        [label setTextColor:[UIColor whiteColor]];
        
        NSString *string;

        switch(section) {
            case UNHANDLED_CHAT:
                string = @"Unhandled chats";
                [view setBackgroundColor:[UIColor redColor] ];

                break;
            case HANDLING_CHAT:
                string =  @"Chats you are handling";
                [view setBackgroundColor:[Utility colorFromHexString:@"#42C9B3"]];
                break;
            case OTHER_CHAT:
                string =  @"Other chats";
                [view setBackgroundColor:[Utility colorFromHexString:@"#42C9B3"]];
                break;
        }
        
        /* Section header is in 0th index... */
        [label setText:string];
        [view addSubview:label];
        return view;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView tag] == CHAT_LIST_TABLEVIEW) {
        //return [chatList count];
        
        switch(section) {
            case UNHANDLED_CHAT:
                return [unhandledChatList count];
                break;
            case HANDLING_CHAT:
                return [handlingChatList count];
                break;
            case OTHER_CHAT:
                return [otherChatList count];
                break;
        }
        
    } else if ([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        if ([chatList count] == 0) {
            return 0;
            
        } else {
            return [currentlySelectedConvo.messages count];
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        
        return [self createChatNavTableView:tableView atRow:row type:indexPath.section];
        
    }else if([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        
        PMConversation *convo = [chatList objectAtIndex:currentlySelectedChatRow];
        id obj = [convo.messages objectAtIndex:indexPath.row];
        
        if( [obj isKindOfClass:[PMImageMessage class]]) {
            return [self createChatImageTableView: tableView atRow:row];
            
        } else {
            return [self createChatMessageTableView:tableView atRow:row];
        }
    
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selecting one of the chat side nav
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        
        _toolBarView.hidden = FALSE;
        _chatInputView.hidden = FALSE;
        
        currentlySelectedChatRow = indexPath.row;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        //setting the visitor name
        UILabel *visitorNameLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_NAME];
        NSString *visitorName = [visitorNameLabel text];
        [self.navigationItem setTitle:visitorName];
        
        //setting the chat for chat table view
        PMConversation *pmConversation = [chatList objectAtIndex:currentlySelectedChatRow];
        chatMessageList = [NSMutableArray arrayWithArray:pmConversation.messages];
        currentSelectedConvoId = pmConversation.conversationId;
        currentlySelectedConvo = pmConversation;
        
        [singleton isHandlerForConversation:currentSelectedConvoId completion:^(BOOL isHandler){
            
            if (isHandler) {
                [_handleActionLabel setTitle:@"Unhandle"];
            } else {
                [_handleActionLabel setTitle:@"Handle"];
            }
            
        }];
        
        [_chatMessageTable reloadData];
        [self scrollChatContentToBottom];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch(section) {
        case UNHANDLED_CHAT:
            if ([unhandledChatList count] ==0) {
                return 0;
            }
            return 20;
            break;
        case HANDLING_CHAT:
            if ([handlingChatList count] ==0) {
                return 0;
            }
            return 20;
            break;
        case OTHER_CHAT:
            if ([otherChatList count] ==0) {
                return 0;
            }
            return 20;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        return 65;
        
    }else if([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        
        PMConversation *pmConvo = [chatList objectAtIndex:currentlySelectedChatRow];
        id obj = [pmConvo.messages objectAtIndex:indexPath.row];
        
        if( [obj isKindOfClass:[PMImageMessage class]]) {
            return 170;
            
        } else {
            
            PMChatMessage *message = [pmConvo.messages objectAtIndex:indexPath.row];
            NSString *text = message.message;
            
            //[[message.message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] boundingRectWithSize:CGSizeMake(695, 999)] ];
            UILabel *gettingSizeLabel = [[UILabel alloc] init];
            gettingSizeLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            gettingSizeLabel.text = text;
            gettingSizeLabel.numberOfLines = 0;
            gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize maximumLabelSize = CGSizeMake(695, 9999);
            
            CGSize expectedSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
            
            return expectedSize.height + 40;
        }
    }
    
    return 0;
}

#pragma mark - CHAT SIDE NAV
- (UITableViewCell *) createChatNavTableView: (UITableView *) tableView atRow: (NSInteger)row type:(NSInteger) type
{
    NSLog(@"creating chat left side table view");
    
    static NSString *cellIdentifier = @"ChatTitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    PMConversation *pmConvo;
    switch (type) {
        case UNHANDLED_CHAT:
            pmConvo = [unhandledChatList objectAtIndex:row];
            break;
        case HANDLING_CHAT:
            pmConvo = [handlingChatList objectAtIndex:row];
            break;
        case OTHER_CHAT:
            pmConvo = [otherChatList objectAtIndex:row];
            break;
    }
    
    //Setting visitor name
    UILabel *visitorLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_NAME];
    [visitorLabel setText:pmConvo.creator.name];

    //setting the started date of chat
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM 'at' HH:MM"];
    NSString *dateString = [dateFormatter stringFromDate:pmConvo.createDate];
    
    UILabel *startedLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_STARTED];
    [startedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Started at", dateString]];
    
    
    //setting number of agents
    UILabel *agentLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_AGENT_NO];
    [singleton getHandlersForConversation:pmConvo.conversationId completion:^(NSArray *conversations) {
        
        NSUInteger total = 0;
        for (PMUser *user in conversations){
            if (![user.type isEqualToString:USER_TYPE_PUBLIC]) {
                total++;
            }
        }
        
        NSLog(@"getting list of handlers returned == %lu",(unsigned long)total);
        [agentLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)total]];
    }];
    
    return cell;
}

#pragma mark - CHAT MESSAGE
-(UITableViewCell *) createChatImageTableView: (UITableView *)tableView atRow: (NSInteger)row
{
    PMConversation *pmCovo = [chatList objectAtIndex:currentlySelectedChatRow];
    PMImageMessage *message = [pmCovo.messages objectAtIndex:row];
    
    return [self getChatImageCell:message tableView:tableView ];
    
}

- (UITableViewCell *)getChatImageCell :(PMImageMessage *)message tableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"ChatPictureCell";
    ChatMessagePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatMessagePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //setting the started date of chat
    NSString *dateString = [Utility formatDateForTable:message.timestamp];
    
    //Setting visitor name
    [cell.messageFrom setText:[NSString stringWithFormat:@"%@   %@",message.user.name, dateString]];
    [cell.messageFrom boldAndBlackSubstring:message.user.name];
    
    __weak typeof(ChatMessagePictureCell *) weakCell = cell;
    
    //setting the display text
    [message retrieveImageWithCompletion:^(UIImage *image) {
        
        NSLog(@"image retrieved");
        weakCell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        weakCell.imageView.clipsToBounds = YES;
        UIImage *scaled = [Utility scaleImage:image toSize:CGSizeMake(120, 120)];
        [weakCell.imageView setImage:scaled];
        
        [weakCell.messageBigPicture setImage:image];
        weakCell.messageBigPicture.hidden = true;
        [weakCell setNeedsLayout];
        
    }];
    return cell;
}

- (UITableViewCell *) createChatMessageTableView: (UITableView *)tableView atRow: (NSInteger)row
{
    PMConversation *pmConvo = [chatList objectAtIndex:currentlySelectedChatRow];
    PMChatMessage *message = [pmConvo.messages objectAtIndex:row];
    
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
    [cell.messageFrom setText:[NSString stringWithFormat:@"%@   %@",message.user.name, dateString]];
    [cell.messageFrom boldAndBlackSubstring:message.user.name];

    //setting the display text
    [cell.messageText setText: message.message];
    
    
    return cell;
}

#pragma mark - updates [new convo or new mesages]
- (void)hasNewConversation: (NSMutableArray *)newChatList
{
    chatList = newChatList;
    [self splitChatIntoGroups];
    [_chatNavTable reloadData];
}

- (void) updateChatList: (NSMutableArray *)newChatList
{
    chatList = newChatList;
    [self splitChatIntoGroups];
    [_chatNavTable reloadData];
}

- (void) hasNewMessage: (NSMutableArray *)newChatList conversation: (PMConversation *)conversation;
{
    NSLog(@"called chat VC has new message");
    chatList = newChatList;
    
    [self splitChatIntoGroups];
    [_chatNavTable reloadData];
    
    NSLog(@"current convo id == %@, convo id == %@", currentlySelectedConvo.conversationId, conversation.conversationId);
    
    if ([currentlySelectedConvo.conversationId isEqualToString:conversation.conversationId]) {
        NSLog(@"yes equal!");
        [_chatMessageTable reloadData];
        [self scrollChatContentToBottom];
    }
}

- (void) handlerUpdate: (NSMutableArray *)newChatList
{
    chatList = newChatList;
    [self splitChatIntoGroups];
    [_chatNavTable reloadData];
}

- (void) referred: (NSString *)convoId
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Chat Referred" message: @"You've been referred to a new chat conversation! " delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)inviteActionPressed:(id)sender
{
    [singleton getPossibleRefer:currentlySelectedConvo completion:^(NSArray *users){
        
        referList = users;
        [self performSegueWithIdentifier:@"referAgents" sender:self];
        
    }];
}

#pragma  mark - Preparation for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"uploadPicture"]) {
        
        [self.view endEditing:YES];
        
        UploadViewController *child = [segue destinationViewController];
        child.delegate = self;

        uploadSegue = ((UIStoryboardPopoverSegue *) segue).popoverController;
        
        
    } else if ([[segue identifier] isEqualToString:@"referAgents"]) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        ReferTableViewController *vc = [segue destinationViewController];
        [vc setCurrentConvo:currentlySelectedConvo];
        [vc setReferList:referList];
        [vc setDelegate:self];
        
        referSegue = ((UIStoryboardPopoverSegue *) segue).popoverController;
        
        if ([referList count] == 0) {
            referSegue.popoverContentSize = CGSizeMake(250, 44);
        } else {
            CGFloat height = [referList count] * 44;
            referSegue.popoverContentSize = CGSizeMake(250, height);
        }
        
    }
}

- (void) closePopOver
{
    [uploadSegue dismissPopoverAnimated:YES];
}

-(void) closeReferPopOver
{
    [referSegue dismissPopoverAnimated:YES];
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
    
    //change chat nav table height
    NSLog(@"chat nav origina frame .height = %f and .wdith = %f",
            chatNavOriginalFrame.size.height,
          chatNavOriginalFrame.size.width);
    NSLog(@"chat real  frame .height = %f and .wdith = %f",
          _chatNavTable.frame.size.height,
          _chatNavTable.frame.size.width);
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
    _chatInputView.center = chatInputOriginalCenter;
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height + KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    chatNavOriginalFrame.size.height = chatMessageOriginalFrame.size.height + KEYBOARD_UP_OFFSET;
    _chatNavTable.frame = chatNavOriginalFrame;
}

- (void) deallocDelegate
{
    singleton.chatDelegate = nil;
}


-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}


@end
