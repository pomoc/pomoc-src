//
//  DashBoardSingleton.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "DashBoardSingleton.h"
#import "PomocSupport.h"

@interface DashBoardSingleton () <PMSupportDelegate, PMConversationDelegate>

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
    
    [PMSupport initWithAppID:@"anc63" secretKey:@"mySecret"];
    [PMSupport setDelegate:self];
    
    [PMSupport loginAgentWithUserId:@"steveng.1988@gmail.com" password:@"hehe" completion:^(NSString *returnedUserId) {
        
        //NSLog(@"------- USER ID IS %@", userId);
        [PMSupport connectWithCompletion:^(BOOL connected) {
            
            //inform applicaiton online
            [PMSupport pingApp];
            
            // Get all conversations
            [PMSupport getAllConversations:^(NSArray *conversations) {
                
                NSLog(@"all conversation.length == %lu",[conversations count]);
                
                for (PMConversation *convo in conversations) {
                
                    convo.delegate = self;
                    [_currentConversationList addObject:convo];
                    
                }
                completion(TRUE);
                [_homeDelegate totalConversationChanged:[conversations count]];
            }];
            
        }];
    }];
}

- (void)numberOfUnattendedConversation:(void (^)(NSUInteger number))completion
{
    __block NSUInteger total = 0;
    __block NSUInteger totalConversationIterated = 0;
    for (PMConversation *convo in _currentConversationList) {
        
        [PMSupport getHandlersForConversation:convo.conversationId completion:^(NSArray *users){
            
            for (PMUser *user in users) {
                if ([user.type isEqualToString:USER_TYPE_AGENT]){
                    total++;
                    break;
                }
            }
            
            totalConversationIterated ++;
            if (totalConversationIterated == [_currentConversationList count]) {
                completion(total);
            }
            
        }];
        
    }
}

- (NSUInteger)numberOfConversation
{
    return [_currentConversationList count];
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
        if([user.type isEqualToString:USER_TYPE_AGENT]) {
            [_currentAgentList addObject:user];
        } else {
            [_currentUserList addObject:user];
        }
    }
    
    if (currentAgentCount != [_currentAgentList count]) {
        [_homeDelegate agentTotalNumberChange:[_currentAgentList count]];
    } else {
        [_homeDelegate userTotalNumberChange:[_currentUserList count]];
    }
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

- (void) didReceiveHandlerUpdate:(PMConversation *)conversation isReferral:(BOOL)isReferral referrer:(PMUser *)referrer referee:(PMUser *)referee
{
    NSLog(@"conversation recieved handler update!");
}


@end
