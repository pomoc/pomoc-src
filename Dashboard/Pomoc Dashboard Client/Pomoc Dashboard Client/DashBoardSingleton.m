//
//  DashBoardSingleton.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "DashBoardSingleton.h"
#import "PomocSupport.h"
#import "SoundEngine.h"

@interface DashBoardSingleton () <PMSupportDelegate, PMConversationDelegate>{
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
    _currentConversationList = [[NSMutableArray alloc] init];
    
    [PMSupport setDelegate:self];
    
    [PMSupport loginAgentWithUserId:@"cm" password:@"cm" completion:^(NSString *returnedUserId) {
        
        _selfUserId = returnedUserId;
        
        [PMSupport connectWithCompletion:^(BOOL connected) {
            
            //inform applicaiton online
            [PMSupport pingApp];
            
            // Get all conversations
            [PMSupport getAllConversations:^(NSArray *conversations) {
                
                NSLog(@"total converlength == %lu",[conversations count]);
                
                for (PMConversation *convo in conversations) {
                    
                    //getting handlers
                    [PMSupport getHandlersForConversation:convo.conversationId completion:^(NSArray *users){
                        convo.handlers = [[NSMutableArray alloc] initWithArray:users];
                    }];
                    
                    //mark as unread
                    convo.read = FALSE;
                    
                    //setting delegates
                    convo.delegate = self;
                    [_currentConversationList addObject:convo];
                }
                
                _agentConversation = [PMSupport agentConversation];
                _agentConversation.delegate = self;
                
                if ([self isHomeDelegateAlive]) {
                    [_homeDelegate totalConversationChanged:[conversations count]];
                }
                
                if ([self isChatDelegateAlive]) {
                   [_chatDelegate updateChatList:_currentConversationList ];
                }
                
                completion(TRUE);
                
            }];
            
        }];
    }];
}

- (void)getPossibleRefer: (PMConversation *) convo completion:(void (^)(NSArray *user))completion;
{
    NSMutableSet *listOfAgent = [[NSMutableSet alloc] initWithArray:_currentAgentList];
    
    for (PMUser *user in [listOfAgent allObjects]) {
        if ([user.userId isEqualToString:_selfUserId]) {
            [listOfAgent removeObject:user];
            break;
        }
    }
    
    for (PMConversation *conversation in _currentConversationList) {
        
        if ([conversation.conversationId isEqualToString:convo.conversationId]) {
            for (PMUser *user in conversation.handlers) {
                [listOfAgent removeObject:user];
            }
            
            completion([listOfAgent allObjects]);
            break;
        }
        
    }
}

- (void)refer: (PMConversation *)convo referee:(PMUser *)user
{
    [PMSupport referHandlerConversation:convo.conversationId refereeUserId:user.userId];
}


- (void)numberOfUnattendedConversation:(void (^)(NSUInteger number))completion;
{
    NSUInteger totalAttended = 0;
    
    if ([_currentConversationList count] == 0) {
        totalUnattendedConversation = 0;
        completion(0);
    }
    
    for (PMConversation *convo in _currentConversationList) {
        
        for (PMUser *user in convo.handlers) {
            if (![user.type isEqualToString:USER_TYPE_PUBLIC]){
                totalAttended++;
                break;
            }
        }
    }
    
    totalUnattendedConversation = [_currentConversationList count] - totalAttended;
    completion(totalUnattendedConversation);
}

- (NSUInteger)numberOfConversation
{
    return [_currentConversationList count];
}

#pragma mark - handling convo
- (void)handleConversation:(PMConversation *)convo;
{
    [PMSupport handleConversation:convo.conversationId];
    [convo sendStatusMessage:PMStatusMessageJoin];
}

- (void)unhandleConversation:(PMConversation *)convo;
{
    [PMSupport unhandleConversation:convo.conversationId];
    [convo sendStatusMessage:PMStatusMessageLeave];
}

- (void)getHandlersForConversation:(NSString *)conversationId completion:(void  (^)(NSArray *conversations))completion
{
    [PMSupport getHandlersForConversation:conversationId completion:^(NSArray *conversations){
        completion(conversations);
    }];
    
}


#pragma mark - Pocmoc Support Delegate
- (void)newConversationCreated:(PMConversation *)conversation
{
    NSLog(@"new convo created");
    
    conversation.delegate = self;
    [_currentConversationList addObject:conversation];
    
    if ([self isHomeDelegateAlive]) {
        [_homeDelegate totalConversationChanged:[_currentConversationList count]];
    }
    
    SoundEngine *engine = [SoundEngine singleton];
    [engine playNewConversation];
    
    if ([self isChatDelegateAlive]) {
        [_chatDelegate hasNewConversation:_currentConversationList];
    }
}

- (void)updateOnlineUsers:(NSArray *)users
{
    NSUInteger currentAgentCount = [_currentAgentList count];
    
    [_currentAgentList removeAllObjects];
    [_currentUserList removeAllObjects];
    
    for (PMUser *user in users) {
        if([user.type isEqualToString:USER_TYPE_PUBLIC]) {
            [_currentUserList addObject:user];
        } else {
            [_currentAgentList addObject:user];
        }
    }
    
    if (currentAgentCount != [_currentAgentList count]) {
        if ([self isHomeDelegateAlive]) {
            [_homeDelegate agentTotalNumberChange:[_currentAgentList count]];
        }
        
        if ([self isGroupChatDelegateAlive]) {
            [_groupChatDelegate agentListUpdated:_currentAgentList];
        }
        
    } else {
        if ([self isHomeDelegateAlive]) {
            [_homeDelegate userTotalNumberChange:[_currentUserList count]];
        }
        
    }
}

- (void)updateOnlineUsers:(NSArray *)users conversationId:(NSString *)conversationId {

}

- (void)isHandlerForConversation:(NSString *)conversationId completion:(void (^)(BOOL isHandler))completion
{
    [self getHandlersForConversation:conversationId completion:^(NSArray * users){
       
        BOOL found = false;
        for (PMUser *user in users) {
            if ([user.userId isEqualToString:_selfUserId]) {
                found = true;
                break;
            }
        }
        completion(found);
        
    }];
}

#pragma mark - Pomoc Conversation delegates

- (void)conversation:(PMConversation *)conversation didReceiveNote:(PMNote *)notes
{
    [_notesDelegate updateNoteList:conversation];
}

- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage
{
    conversation.read = FALSE;
    
    SoundEngine *engine = [SoundEngine singleton];
    [engine playNewMessage];
    
    if ([self isEqualToAgent:conversation]) {
        _agentConversation = conversation;
        if ([self isGroupChatDelegateAlive]) {
            [_groupChatDelegate newChatMessage:_agentConversation];
        }
    } else {
        
        for (PMConversation __strong *convo in _currentConversationList) {
            if (convo.conversationId == conversation.conversationId) {
                convo = conversation;
                convo.delegate = self;
            }
        }
        if ([self isChatDelegateAlive]) {
            [_chatDelegate hasNewMessage:_currentConversationList conversation:conversation];
        }
    }
}

- (void)conversation:(PMConversation *)conversation didReceiveStatusMessage:(PMStatusMessage *)statusMessage
{
    for (PMConversation __strong *convo in _currentConversationList) {
        if (convo.conversationId == conversation.conversationId) {
            convo = conversation;
        }
    }
    
    if ([self isChatDelegateAlive]) {
        [_chatDelegate hasNewMessage:_currentConversationList conversation:conversation];
    }
    
}

- (void)conversation:(PMConversation *)conversation didReceiveImageMessage:(PMImageMessage *)imageMessage
{
    conversation.read = FALSE;
    
    SoundEngine *engine = [SoundEngine singleton];
    [engine playNewMessage];
    
    for (PMConversation __strong *convo in _currentConversationList) {
        if (convo.conversationId == conversation.conversationId) {
            convo = conversation;
        }
    }
    if ([self isChatDelegateAlive]) {
        [_chatDelegate hasNewMessage:_currentConversationList conversation:conversation];
    }
}

// Delegate method for handlers
- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId
{
    //replacing current handlers
    for (PMConversation *convo in _currentConversationList) {
        if ([convo.conversationId isEqualToString:conversationId]) {
            convo.handlers = (NSMutableArray *)handlers;
        }
    }

    //checking if current unattended conversation list changed
    __block NSUInteger temp = totalUnattendedConversation;
    
    [self numberOfUnattendedConversation:^(NSUInteger total){
       
        if (temp != total){
            if ([self isHomeDelegateAlive]) {
                [_homeDelegate totalUnattendedConversationChanged:temp];
            }
        }
    }];
    
    if ([self isChatDelegateAlive]) {
        [_chatDelegate handlerUpdate:_currentConversationList];
    }
}

// Delegate method for referral of handlers
- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId referrer:(PMUser *)referrer referee:(PMUser *)referee;
{
    if ([referee.userId isEqualToString: _selfUserId]) {
        
        if ([self isChatDelegateAlive]) {
            [_chatDelegate referred:conversationId];
        }
        
        [PMSupport handleConversation:conversationId];
    }
}

- (BOOL) isEqualToAgent: (PMConversation *)convo
{
    return [[PMSupport agentConversation].conversationId isEqualToString: convo.conversationId];
}

// check
- (BOOL)isHomeDelegateAlive
{
    if (_homeDelegate == nil)
        return FALSE;
    return TRUE;
}

- (BOOL)isChatDelegateAlive
{
    if (_chatDelegate == nil)
        return FALSE;
    return TRUE;
}

- (BOOL)isGroupChatDelegateAlive
{
    if(_groupChatDelegate == nil)
        return FALSE;
    return TRUE;
}

@end
