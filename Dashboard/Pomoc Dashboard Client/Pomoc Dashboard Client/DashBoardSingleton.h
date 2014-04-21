//
//  DashBoardSingleton.h
//  Pomoc Dashboard Client
//
//  Dashboard APP level singleton
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMConversation.h"
#import "PMImageMessage.h"

@protocol PomocChatDelegate

- (void) updateChatList: (NSMutableArray *)chatList;
- (void) hasNewConversation: (NSMutableArray *)chatList;
- (void) hasNewMessage: (NSMutableArray *)chatList conversation: (PMConversation *)conversation;
- (void) handlerUpdate: (NSMutableArray *)chatList;
- (void) referred: (NSString *)convoId;

@end


@protocol PomocNoteDelegate

- (void) updateNoteList: (PMConversation *)convo;

@end


@protocol PomocGroupDelegate

- (void) agentListUpdated: (NSMutableArray *)agentList;
- (void) newChatMessage: (PMConversation *)conversation;

@end


@protocol PomocHomeDelegate

- (void) agentTotalNumberChange: (NSUInteger)agentNumber;
- (void) userTotalNumberChange: (NSUInteger)userNumber;
- (void) totalConversationChanged: (NSUInteger)totalConversation;
- (void) totalUnattendedConversationChanged: (NSUInteger)totalUnattended;

//delegate for agent online/ offline
//delegate for user online/ offline

@end

@interface DashBoardSingleton : NSObject

+ (id)singleton;

- (void)loginAgentWithUserId:(NSString *)userId password:(NSString *)password completion:(void (^)(BOOL success))completion;

//For home page to get number of conversation with 0 agents and total conversation
- (void)numberOfUnattendedConversation:(void (^)(NSUInteger number))completion;
- (NSUInteger)numberOfConversation;

//Handling convo
- (void)handleConversation:(PMConversation *)convo;
- (void)unhandleConversation:(PMConversation *)convo;
- (void)getHandlersForConversation:(NSString *)conversationId completion:(void  (^)(NSArray *conversations))completion;
- (void)isHandlerForConversation:(NSString *)conversationId completion:(void (^)(BOOL isHandler))completion;

//For refer view controller to get list of controller without self
- (void)getPossibleRefer: (PMConversation *)convo completion:(void (^)(NSArray *user))completion;
- (void)refer: (PMConversation *)convo referee:(PMUser *)user;

@property (nonatomic, strong) NSMutableArray *currentConversationList;
@property (nonatomic, strong) NSString *selfUserId;
@property (nonatomic, strong) NSMutableArray *currentAgentList;
@property (nonatomic, strong) NSMutableArray *currentUserList;
@property (nonatomic, strong) PMConversation *agentConversation;

@property (nonatomic, assign) id  chatDelegate;
@property (nonatomic, assign) id  homeDelegate;
@property (nonatomic, assign) id  groupChatDelegate;
@property (nonatomic, assign) id  notesDelegate;

@end
