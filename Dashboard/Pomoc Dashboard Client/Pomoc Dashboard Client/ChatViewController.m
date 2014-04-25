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
#import "StatusMessageTableViewCell.h"
#import "ContactInfoViewController.h"
#import "ReferTableViewController.h"
#import "PomocSupport.h"
#import "PMChatMessage.h"
#import "PMMessage.h"
#import "PMStatusMessage.h"
#import "UILabel+boldAndGray.h"
#import "UIImageView+WebCache.h"
#import "DashBoardSingleton.h"
#import "AnnotateViewController.h"

@interface ChatViewController () < UINavigationControllerDelegate, UIAlertViewDelegate, AnnotateViewControllerDelegate, PomocChatDelegate, ReferDelegate> {
    
    // Tracking UI table view
    CGRect chatMessageOriginalFrame;
    CGPoint chatInputOriginalCenter;
    CGRect chatNavOriginalFrame;
    
    NSMutableArray *chatList;
    
    // New way of 3 type of chat list
    NSMutableArray *unhandledChatList;
    NSMutableArray *handlingChatList;
    NSMutableArray *otherChatList;
    
    NSMutableArray *chatMessageList;
    NSInteger currentlySelectedChatRow;
    NSIndexPath *currentlySelectedChatIndexPath;
    NSString *currentSelectedConvoId;
    PMConversation *currentlySelectedConvo;
    
    NSString *userId;
    NSString *userName;
    BOOL keyboardEditing;
    
    DashBoardSingleton *singleton;
    
    UIPopoverController *uploadSegue;
    UIPopoverController *referSegue;
    
    __block NSArray *referList;
 
    UIView *popOutImage;
    
}

@end

@implementation ChatViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = CHAT_NAV_TITLE;
    
    // Ensuring that no border for chat message table view
    _chatMessageTable.separatorColor = [UIColor clearColor];
    _chatNavTable.separatorColor = [UIColor clearColor];
    
    // Border
    _chatMessageTable.layer.borderWidth = 0.5;
    CALayer *leftBorder = [CALayer layer];
    leftBorder.backgroundColor = [[UIColor blackColor] CGColor];
    leftBorder.frame = CGRectMake(0, 0, 0.5, _chatInputView.frame.size.height);
    [_chatInputView.layer addSublayer:leftBorder];
    _chatInputView.hidden = YES;
    
    self.navigationController.navigationBar.titleTextAttributes = [Utility navigationTitleDesign];
    
    currentlySelectedChatRow = -1;
    currentlySelectedConvo = nil;
    currentSelectedConvoId = @"";
    keyboardEditing = NO;
    
    _pastAndInfoToolbar.clipsToBounds = YES;
    
    chatList = [[NSMutableArray alloc] init];
    chatMessageList = [[NSMutableArray alloc] init];
    
    singleton = [DashBoardSingleton singleton];
    [singleton setChatDelegate:self];
    chatList = singleton.currentConversationList;
    
    unhandledChatList = [[NSMutableArray alloc] init];
    handlingChatList = [[NSMutableArray alloc] init];
    otherChatList = [[NSMutableArray alloc] init];
    
    [self splitChatIntoGroups];
    
    [_chatNavTable reloadData];
    
    // Storing the original position for moving them up when keyboard show
    chatMessageOriginalFrame = _chatMessageTable.frame;
    chatInputOriginalCenter = _chatInputView.center;
    chatNavOriginalFrame = _chatNavTable.frame;
    chatNavOriginalFrame.size.width = CHAT_NAV_ORIGINAL_FRAME;
    
    _toolBarView.hidden = TRUE;
}

- (void)splitChatIntoGroups {
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
    
    NSArray *sortedArray = [unhandledChatList sortedArrayUsingComparator:^NSComparisonResult(PMConversation *first, PMConversation *second) {

        PMMessage *aLastMessage = first.messages.lastObject;
        PMMessage *bLastMessage = second.messages.lastObject;
        
        return [aLastMessage.timestamp compare:bLastMessage.timestamp];
    }];
    
    unhandledChatList = [[NSMutableArray alloc] initWithArray:sortedArray];
    
}

- (IBAction)sendMessage:(id)sender {

    NSString *userInput = _userTextInput.text;
    
    if ([userInput length] > 0 ) {
        [currentlySelectedConvo sendTextMessage:userInput];
        [_userTextInput setText:@""];
    }
}

- (IBAction)handleActionPressed:(id)sender {
    
    if ([[_handleActionLabel title] isEqualToString: HANDLE_CHAT_BTN]) {
        [singleton handleConversation:currentlySelectedConvo];
        [_handleActionLabel setTitle:UNHANDLE_CHAT_BTN];
    } else {
        [singleton unhandleConversation:currentlySelectedConvo];
        [_handleActionLabel setTitle:HANDLE_CHAT_BTN];
    }
    
}

#pragma mark - annotation related

- (IBAction)annotateActionPressed:(id)sender {
    
    NSArray *subviews = [sender superview].subviews;
    UIImageView *imv;
    for (UIImageView *view in subviews) {
        if ([view isKindOfClass:[UIImageView class]] &&
            ((UIImageView *)view).image) {
            imv = view;
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

- (void)userCompleteAnnotation:(UIImage *)image {
    [currentlySelectedConvo sendImageMessage:image];
}

#pragma mark - Upload View Controller Delegate
- (void)pictureSelected:(UIImage *)image {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [currentlySelectedConvo sendImageMessage:image];
    });
    [uploadSegue dismissPopoverAnimated:YES];
}

#pragma mark - Navigation Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView tag] == CHAT_LIST_TABLEVIEW) {
        return 3;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView tag] == CHAT_LIST_TABLEVIEW) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 12)];
        [label setFont:[UIFont fontWithName:CHAT_NAV_FONT size:CHAT_NAV_FONT_SIZE]];
        [label setTextColor:[UIColor whiteColor]];
        
        NSString *headerTitle;

        switch(section) {
            case UNHANDLED_CHAT:
                headerTitle = UNHANDLE_CHAT_SECTION;
                view.backgroundColor = [UIColor redColor];
                break;
            case HANDLING_CHAT:
                headerTitle =  HANDLING_CHAT_SECTION;
                view.backgroundColor = [Utility colorFromHexString:HANDLING_CHAT_SECTION_COLOR];
                break;
            case OTHER_CHAT:
                headerTitle =  OTHER_CHAT_SECTION;
                view.backgroundColor = [Utility colorFromHexString:OTHER_CHAT_SECTION_COLOR];
                break;
        }
        
        // Section header is in 0th index
        label.text = headerTitle;
        [view addSubview:label];
        return view;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView tag] == CHAT_LIST_TABLEVIEW) {
        switch (section) {
            case UNHANDLED_CHAT:
                return unhandledChatList.count;
                break;
            case HANDLING_CHAT:
                return handlingChatList.count;
                break;
            case OTHER_CHAT:
                return otherChatList.count;
                break;
        }
    } else if ([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        
        if ([chatList count] == 0) {
            return 0;
        } else {
            if (currentlySelectedConvo ==nil) {
                return 0;
            } else {
                return [currentlySelectedConvo.messages count];
            }
        }
        return 0;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    if (tableView.tag == CHAT_LIST_TABLEVIEW) {
        
        return [self createChatNavTableView:tableView atRow:row type:indexPath.section];
    
    } else if(tableView.tag == CHAT_MESSAGE_TABLEVIEW) {
        
        PMConversation *convo = currentlySelectedConvo;
        id obj = [convo.messages objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[PMStatusMessage class]]) {
            return [self createStatusTableView:tableView
                                         atRow:row];
        }
         else if ([obj isKindOfClass:[PMImageMessage class]]) {
            return [self createChatImageTableView:tableView
                                            atRow:row];
        } else {
            return [self createChatMessageTableView:tableView
                                              atRow:row];
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Selecting one of the chat side nav
    if ([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        _toolBarView.hidden = FALSE;
        _chatInputView.hidden = FALSE;
        
        currentlySelectedChatRow = indexPath.row;
        currentlySelectedChatIndexPath = indexPath;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // Setting the visitor name
        UILabel *visitorNameLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_NAME];
        NSString *visitorName = [visitorNameLabel text];
        [self.navigationItem setTitle:visitorName];
        
        PMConversation *pmConversation;

        // Setting the chat for chat table view
        switch (indexPath.section) {
            case UNHANDLED_CHAT:
                pmConversation = [unhandledChatList objectAtIndex:currentlySelectedChatRow];
                break;
            case HANDLING_CHAT:
                pmConversation = [handlingChatList objectAtIndex:currentlySelectedChatRow];
                break;
            case OTHER_CHAT:
                pmConversation = [otherChatList objectAtIndex:currentlySelectedChatRow];
                break;
        }
        
        chatMessageList = [NSMutableArray arrayWithArray:pmConversation.messages];
        currentSelectedConvoId = pmConversation.conversationId;
        currentlySelectedConvo = pmConversation;
        
        [singleton isHandlerForConversation:currentSelectedConvoId completion:^(BOOL isHandler){
            
            if (isHandler) {
                [_handleActionLabel setTitle:UNHANDLE_CHAT_BTN];
            } else {
                [_handleActionLabel setTitle:HANDLE_CHAT_BTN];
            }
        }];
        
        // Make it read
        pmConversation.read = YES;
        cell.backgroundColor = [UIColor whiteColor];
        
        [_chatMessageTable reloadData];
        [self scrollChatContentToBottom];
    
    } else if ([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell isKindOfClass:[ChatMessagePictureCell class]]) {            ChatMessagePictureCell *cell = (ChatMessagePictureCell *) [tableView cellForRowAtIndexPath:indexPath];
            [self showImage:cell.messagePicture.image];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case UNHANDLED_CHAT:
            if (unhandledChatList.count == 0) {
                return 0;
            }
            return SECTION_HEIGHT;
            break;
        case HANDLING_CHAT:
            if (handlingChatList.count == 0) {
                return 0;
            }
            return SECTION_HEIGHT;
            break;
        case OTHER_CHAT:
            if (otherChatList.count == 0) {
                return 0;
            }
            return SECTION_HEIGHT;
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView tag] == CHAT_LIST_TABLEVIEW ) {
        return SECTION_CONTENT_HIGHT;
        
    } else if([tableView tag] == CHAT_MESSAGE_TABLEVIEW) {
        
        PMConversation *pmConvo;
        pmConvo = currentlySelectedConvo;
        
        id obj = [currentlySelectedConvo.messages objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[PMImageMessage class]]) {
            return CHAT_MESSAGE_PICTURE_HEIGHT;
        } else {
            
            PMChatMessage *message = [pmConvo.messages objectAtIndex:indexPath.row];
            NSString *text = message.message;
            UILabel *gettingSizeLabel = [[UILabel alloc] init];
            gettingSizeLabel.font = [UIFont fontWithName:CHAT_MESSAGE_TEXT_FONT size:CHAT_MESSAGE_TEXT_FONT_SIZE];
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
- (UITableViewCell *)createChatNavTableView:(UITableView *)tableView
                                      atRow:(NSInteger)row
                                       type:(NSInteger)type {
    
    static NSString *cellIdentifier = CHAT_TITLE_REUSE_CELL;
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
    
    if (![pmConvo read]) {
        [cell setBackgroundColor:[Utility colorFromHexString:CHAT_MESSAGE_UNREAD_COLOR]];
    }
    
    // Setting visitor name
    UILabel *visitorLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_NAME];
    [visitorLabel setText:pmConvo.creator.name];

    // Setting the started date of chat
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM 'at' HH:MM"];
    NSString *dateString = [dateFormatter stringFromDate:pmConvo.createDate];
    
    UILabel *startedLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_STARTED];
    [startedLabel setText:[NSString stringWithFormat:@"%@ %@",@"Started at", dateString]];
    
    // Setting number of agents
    UILabel *agentLabel = (UILabel *)[cell.contentView viewWithTag:CHAT_CELL_AGENT_NO];
    [singleton getHandlersForConversation:pmConvo.conversationId completion:^(NSArray *conversations) {
        
        NSUInteger total = 0;
        for (PMUser *user in conversations){
            if (![user.type isEqualToString:USER_TYPE_PUBLIC]) {
                total++;
            }
        }
        
        [agentLabel setText:[NSString stringWithFormat: @"%lu", (unsigned long)total]];
    }];
    
    return cell;
}

#pragma mark - CHAT MESSAGE
- (UITableViewCell *)createChatImageTableView:(UITableView *)tableView
                                        atRow:(NSInteger)row {
    PMConversation *pmCovo = currentlySelectedConvo;
    PMImageMessage *message = [pmCovo.messages objectAtIndex:row];
    
    return [self getChatImageCell:message tableView:tableView ];
    
}

- (UITableViewCell *)getChatImageCell:(PMImageMessage *)message
                            tableView:(UITableView *)tableView {
    static NSString *cellIdentifier = CHAT_PICTURE_REUSE_CELL;
    ChatMessagePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[ChatMessagePictureCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:cellIdentifier];
    }
    
    // Setting the started date of chat
    NSString *dateString = [Utility formatDateForTable:message.timestamp];
    
    // Setting visitor name
    cell.messageFrom.text = [NSString stringWithFormat:@"%@   %@",message.user.name, dateString];
    [cell.messageFrom boldAndBlackSubstring:message.user.name];
    
    __weak typeof(ChatMessagePictureCell *)weakCell = cell;
    
    // Setting the display text
    [message retrieveImageWithCompletion:^(UIImage *image) {
        weakCell.messagePicture.contentMode = UIViewContentModeScaleAspectFit;
        weakCell.messagePicture.clipsToBounds = YES;
        [weakCell.messagePicture setImage:image];
        [weakCell setNeedsLayout];
    }];
 
    return cell;
}

#define POPOUT_IMAGE_OFFSET 50

- (void)showImage:(UIImage *)image
{
    popOutImage = [[UIView alloc] initWithFrame:CGRectMake(0, POPOUT_IMAGE_OFFSET,
                                                           self.view.frame.size.width,
                                                           self.view.frame.size.height-POPOUT_IMAGE_OFFSET)];
    [popOutImage setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    
    CGRect frame = popOutImage.bounds;
    frame.size.width *= 0.9;
    frame.size.height *= 0.9;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    [imageView setCenter:CGPointMake(popOutImage.frame.size.width/2.0, popOutImage.frame.size.height / 2.0)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [popOutImage addSubview:imageView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImage:)];
    [popOutImage addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:popOutImage];
}

- (void)removeImage:(UITapGestureRecognizer *)tapRecognizer {
    [popOutImage removeFromSuperview];
}

- (UITableViewCell *) createStatusTableView:(UITableView *)tableView
                                      atRow:(NSInteger)row {
    PMConversation *pmConvo = currentlySelectedConvo; //[chatList objectAtIndex:currentlySelectedChatRow];
    PMStatusMessage *message = [pmConvo.messages objectAtIndex:row];
    
    return [self getStatusMessageCell:message tableView:tableView];
}

- (UITableViewCell *)getStatusMessageCell:(PMStatusMessage *)message
                                tableView:(UITableView *)tableView {
    
    static NSString *cellIdentifier = CHAT_STATUS_REUSE_CELL;
    StatusMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[StatusMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:cellIdentifier];
    }

    // Setting the started date of chat
    NSString *dateString = [Utility formatDateForTable:message.timestamp];
    NSString *messageOutput;
    
    switch (message.code) {
        case PMStatusMessageJoin:
            messageOutput = [NSString stringWithFormat:@"%@ has joined the conversation at %@", message.user.name, dateString] ;
            break;
        case PMStatusMessageLeave:
            messageOutput = [NSString stringWithFormat:@"%@ has left the conversation at %@", message.user.name, dateString];
            break;
        default:
            break;
    }
    
    // Setting visitor name
    cell.statusMessage.text = messageOutput;
    [cell.statusMessage boldAndBlackSubstring:message.user.name];
    
    return cell;
}


- (UITableViewCell *)createChatMessageTableView:(UITableView *)tableView
                                          atRow:(NSInteger)row {
    PMConversation *pmConvo = currentlySelectedConvo;
    PMChatMessage *message = [pmConvo.messages objectAtIndex:row];
    
    return [self getChatMessageCell:message tableView:tableView];
    
}

- (UITableViewCell *)getChatMessageCell:(PMChatMessage *)message
                              tableView:(UITableView *)tableView {
    
    static NSString *cellIdentifier = CHAT_MESSAGE_REUSE_CELL;
    ChatMessageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[ChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
    }
    
    // Setting the started date of chat
    NSString *dateString = [Utility formatDateForTable:message.timestamp];
    
    // Setting visitor name
    cell.messageFrom.text = [NSString stringWithFormat:@"%@   %@", message.user.name, dateString];
    [cell.messageFrom boldAndBlackSubstring:message.user.name];
    
    // Setting the display text
    [cell.messageText setText: message.message];

    return cell;
}

#pragma mark - updates [new convo or new mesages]

- (void)hasNewConversation:(NSMutableArray *)newChatList {
    chatList = newChatList;
    [self splitChatIntoGroups];
    [_chatNavTable reloadData];
}

- (void) updateChatList:(NSMutableArray *)newChatList {
    chatList = newChatList;
    [self splitChatIntoGroups];
    [_chatNavTable reloadData];
}

- (void) hasNewMessage:(NSMutableArray *)newChatList conversation:(PMConversation *)conversation; {
    chatList = newChatList;
    
    [self splitChatIntoGroups];
    [_chatNavTable reloadData];
    
    if ([currentlySelectedConvo.conversationId isEqualToString:conversation.conversationId]) {
        [_chatMessageTable reloadData];
        [self scrollChatContentToBottom];
    }
    [_chatNavTable selectRowAtIndexPath:currentlySelectedChatIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)handlerUpdate:(NSMutableArray *)newChatList {
    chatList = newChatList;
    [self splitChatIntoGroups];
    [_chatNavTable reloadData];
}

- (void)referred:(NSString *)convoId {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: INVITED_TITLE
                                                    message: INVITED_CONTENT
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)inviteActionPressed:(id)sender {
    [singleton getPossibleRefer:currentlySelectedConvo completion:^(NSArray *users){
        referList = users;
        [self performSegueWithIdentifier:@"referAgents" sender:self];
    }];
}

# pragma mark - Preparation for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"uploadPicture"]) {
        
        [self.view endEditing:YES];
        
        UploadViewController *child = [segue destinationViewController];
        child.delegate = self;

        uploadSegue = ((UIStoryboardPopoverSegue *)segue).popoverController;
        
        
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
        
    } else if ([[segue identifier] isEqualToString:@"addNote"]) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        ContactInfoViewController *vc = [segue destinationViewController];
        NSLog(@"chat vc line 714 convo id == %@",currentlySelectedConvo.conversationId);
        vc.currentConversation = currentlySelectedConvo;
        
        referSegue = ((UIStoryboardPopoverSegue *) segue).popoverController;
    }
    
}

- (void)closePopOver {
    [uploadSegue dismissPopoverAnimated:YES];
}

- (void)closeReferPopOver {
    [referSegue dismissPopoverAnimated:YES];
}

# pragma mark - Textfield editing delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    keyboardEditing = true;
    [self scrollThingUp];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage:self];
    return YES;
}

- (void)scrollThingUp {
    
    [_chatInputView setCenter:CGPointMake(chatInputOriginalCenter.x,
                                          chatInputOriginalCenter.y - KEYBOARD_UP_OFFSET)];
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height - KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    [self scrollChatContentToBottom];
    
    // Change chat nav table height
    chatNavOriginalFrame.size.height = chatNavOriginalFrame.size.height - KEYBOARD_UP_OFFSET;
    _chatNavTable.frame = chatNavOriginalFrame;
}

- (void)scrollChatContentToBottom {
    NSInteger numberOfRows = [_chatMessageTable numberOfRowsInSection:0];
    if (numberOfRows) {
        [_chatMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    keyboardEditing = false;
    _chatInputView.center = chatInputOriginalCenter;
    
    chatMessageOriginalFrame.size.height = chatMessageOriginalFrame.size.height + KEYBOARD_UP_OFFSET;
    _chatMessageTable.frame = chatMessageOriginalFrame;
    
    chatNavOriginalFrame.size.height = chatMessageOriginalFrame.size.height + KEYBOARD_UP_OFFSET;
    _chatNavTable.frame = chatNavOriginalFrame;
}

- (void) deallocDelegate {
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

#pragma mark - DISCONNECT
- (void)noInternet {
    UIAlertView *alert = [Utility disconnectAlert];
    alert.delegate = self;
    
    [alert show];
}

#pragma mark - UIAlertView 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"backtoLogin" sender:self];
    }
}

@end
