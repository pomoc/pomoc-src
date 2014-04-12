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

- (void)loginAgentWithUserId:(NSString *)userId password:(NSString *)password completion:(void (^)(BOOL success))completion
{
    
    _currentConversationList = [[NSMutableArray alloc] init];
    
    [PMSupport initWithAppID:@"anc3" secretKey:@"mySecret"];
    [PMSupport setDelegate:self];
    
    [PMSupport loginAgentWithUserId:@"steveng.1988@gmail.com" password:@"hehe" completion:^(NSString *returnedUserId) {
        
        //NSLog(@"------- USER ID IS %@", userId);
        [PMSupport connectWithCompletion:^(BOOL connected) {
            
            // Get all conversations
            [PMSupport getAllConversations:^(NSArray *conversations) {
                [_currentConversationList addObjectsFromArray:conversations];
                //NSLog(@"all conversation");
                //NSLog(@"all conversation.length == %lu",[conversations count]);
                //NSLog(@"own array length == %lu", [_currentConversationList count]);
                for (PMConversation *convo in conversations) {
                    //NSLog(@"number of messages %lu", [convo.messages count]);
                }
                completion(TRUE);
            }];
            
        }];
    }];

}

#pragma mark - Pocmoc Support Delegate

- (void)newConversationCreated:(PMConversation *)conversation
{
    [_currentConversationList addObject:conversation];
    [_chatDelegate hasUpdate:_currentConversationList];
}


- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage
{
    
    NSLog(@"recieved a chat message delegae called ");
    for (PMConversation __strong *convo in _currentConversationList) {
        if (convo.conversationId == conversation.conversationId) {
            convo = conversation;
        }
    }
    [_chatDelegate hasUpdate:_currentConversationList];
    
}

- (void)conversation:(PMConversation *)conversation didReceiveImageMessage:(PMImageMessage *)imageMessage
{
    
    NSLog(@"recieved an image message delegae called ");
    for (PMConversation __strong *convo in _currentConversationList) {
        if (convo.conversationId == conversation.conversationId) {
            convo = conversation;
        }
    }
    [_chatDelegate hasUpdate:_currentConversationList];
    
}




@end
