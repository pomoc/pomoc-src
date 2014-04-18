//
//  DashBoardSingleton.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "DashBoardSingleton.h"
#import "PomocSupport.h"

@interface DashBoardSingleton () <PMSupportDelegate, PMConversationDelegate>{
    __block NSString *selfUserId;
    __block NSUInteger totalUnattendedConversation;
}

@end

@implementation DashBoardSingleton

+ (id)singleton {
    
    static DashBoardSingleton *sharedMyModel = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}


- (id)init {
    if (self = [super init]) {
        _currentAgentList = [[NSMutableArray alloc] init];
        _currentUserList = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)loginAgentWithUserId:(NSString *)userId password:(NSString *)password completion:(void (^)(BOOL success))completion
{
    NSLog(@"logging in");
    _currentConversationList = [[NSMutableArray alloc] init];
    
    [PMSupport initWithAppID:@"anc160" secretKey:@"mySecret"];
    [PMSupport setDelegate:self];
    
    [PMSupport loginAgentWithUserId:@"steveng.1988@gmail.com" password:@"hehe" completion:^(NSString *returnedUserId) {
        
        selfUserId = returnedUserId;
        
        //NSLog(@"------- USER ID IS %@", userId);
        [PMSupport connectWithCompletion:^(BOOL connected) {
            
            //inform applicaiton online
            [PMSupport pingApp];
            
            // Get all conversations
            [PMSupport getAllConversations:^(NSArray *conversations) {
                
                NSLog(@"all conversation.length == %lu",[conversations count]);
                
                for (PMConversation *convo in conversations) {
                    
                    NSLog(@"@convo message == %lu", [convo.messages count]);
                    
                    convo.delegate = self;
                    [_currentConversationList addObject:convo];
                    
                }
                completion(TRUE);
                
                if (_homeDelegate) {
                    if ([_homeDelegate respondsToSelector:@selector(totalConversationChanged:)]) {
                        [_homeDelegate totalConversationChanged:[conversations count]];
                    }
                }
                
            }];
            
        }];
    }];
}

- (void)numberOfUnattendedConversation:(void (^)(NSUInteger number))completion;
{
    __block NSUInteger totalAttended = 0;
    __block NSUInteger totalConversationIterated = 0;
    
    NSLog(@"number of unattended called, current convo list == %lu",[_currentConversationList count]);
    
    if ([_currentConversationList count] == 0) {
        totalUnattendedConversation = 0;
        completion(0);
    }
    
    for (PMConversation *convo in _currentConversationList) {
        
        [PMSupport getHandlersForConversation:convo.conversationId completion:^(NSArray *users){
             NSLog(@"handlers called");
            
            //check among the users in the convo, if there are someone inside
            for (PMUser *user in users) {
                NSLog(@"user.type == %@",user.type);
                if (![user.type isEqualToString:USER_TYPE_PUBLIC]){
                    totalAttended++;
                    break;
                }
            }
            
            totalConversationIterated ++;
            if (totalConversationIterated == [_currentConversationList count]) {
                totalUnattendedConversation = totalConversationIterated - totalAttended;
                completion(totalUnattendedConversation);
            }
            
        }];
        
    }
}

- (NSUInteger)numberOfConversation
{
    return [_currentConversationList count];
}

#pragma mark - handling convo
- (void)handleConversation:(NSString *)conversationId
{
    NSLog(@"handling conversation pressed");
    [PMSupport handleConversation:conversationId];
}

- (void)unhandleConversation:(NSString *)conversationId
{
    [PMSupport unhandleConversation:conversationId];
}

- (void)getHandlersForConversation:(NSString *)conversationId completion:(void  (^)(NSArray *conversations))completion
{
    NSLog(@"called line 121 get handler for convo with convo id ==%@", conversationId);
    
    [PMSupport getHandlersForConversation:conversationId completion:^(NSArray *conversations){
        
        NSUInteger total = 0;

        for (PMUser *user in conversations){
            NSLog(@"user type== %@", user.type);
            NSLog(@"user type== %@", user.userId);
            NSLog(@"user type== %@", user.name);
//            if (![user.type isEqualToString:USER_TYPE_PUBLIC]) {
//                total++;
//            }
        }
        
        NSLog(@"called in line 122 of singleton with conversation user == %lu", total);
        completion(conversations);
    }];
    
}


#pragma mark - Pocmoc Support Delegate

- (void)newConversationCreated:(PMConversation *)conversation
{
    conversation.delegate = self;
    [_currentConversationList addObject:conversation];
    NSLog(@"dashboard singleton detected new chat");
    
    [_chatDelegate hasNewConversation:_currentConversationList];
}

- (void)updateOnlineUsers:(NSArray *)users
{
    NSLog(@"delegate of update online users called");
    
    NSUInteger currentAgentCount = [_currentAgentList count];
    
    [_currentAgentList removeAllObjects];
    [_currentUserList removeAllObjects];
    
    for (PMUser *user in users) {
        NSLog(@"user.type == %@",user.type);
        if([user.type isEqualToString:USER_TYPE_PUBLIC]) {
            [_currentUserList addObject:user];
        } else {
            [_currentAgentList addObject:user];
        }
    }
    
    if (currentAgentCount != [_currentAgentList count]) {
        if ([_homeDelegate respondsToSelector:@selector(agentTotalNumberChange:)]) {
            [_homeDelegate agentTotalNumberChange:[_currentAgentList count]];
        }
    } else {
        if ([_homeDelegate respondsToSelector:@selector(userTotalNumberChange:)]) {
            [_homeDelegate userTotalNumberChange:[_currentUserList count]];
        }
        
    }
}

- (void)isHandlerForConversation:(NSString *)conversationId completion:(void (^)(BOOL isHandler))completion
{
    [self getHandlersForConversation:conversationId completion:^(NSArray * users){
       
        BOOL found = false;
        for (PMUser *user in users) {
            if ([user.userId isEqualToString:selfUserId]) {
                found = true;
                break;
            }
        }
        completion(found);
        
    }];
}

#pragma mark - Pomoc Conversation delegates

- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage
{
    NSLog(@"recieved new chat");
    for (PMConversation __strong *convo in _currentConversationList) {
        if (convo.conversationId == conversation.conversationId) {
            convo = conversation;
            convo.delegate = self;
        }
    }
    [_chatDelegate hasNewMessage:_currentConversationList conversation:conversation];
    
}

- (void)conversation:(PMConversation *)conversation didReceiveImageMessage:(PMImageMessage *)imageMessage
{
    NSLog(@"recieved an image message delegae called ");
    for (PMConversation __strong *convo in _currentConversationList) {
        if (convo.conversationId == conversation.conversationId) {
            convo = conversation;
        }
    }
    [_chatDelegate hasNewMessage:_currentConversationList conversation:conversation];
    
}

// Delegate method for handlers
- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId
{
    //checking if current unattended conversation list changed
    __block NSUInteger temp = totalUnattendedConversation;
    [self numberOfUnattendedConversation:^(NSUInteger total){
       
        if (temp != total){
            if ([_homeDelegate respondsToSelector:@selector(totalUnattendedConversationChanged:)]) {
                [_homeDelegate totalUnattendedConversationChanged:temp];
            }
        }
    }];
    
    [_chatDelegate handlerUpdate:_currentConversationList];
    
}

// Delegate method for referral of handlers
- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId referrer:(PMUser *)referrer referee:(PMUser *)referee;
{
    NSLog(@"hehe referred");
}

// check


@end
