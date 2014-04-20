//
//  PMSupport.h
//  PomocCore
//
//  Created by soedar on 6/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMConversation, PMUser;

@protocol PMSupportDelegate <NSObject>

- (void)newConversationCreated:(PMConversation *)conversation;

// Delegate method for handlers
- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId;
// Delegate method for referral of handlers
- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId referrer:(PMUser *)referrer referee:(PMUser *)referee;
// Delegate method for users online - app
- (void)updateOnlineUsers:(NSArray *)users;
// Delegate method for users online - in a conversation
- (void)updateOnlineUsers:(NSArray *)users conversationId:(NSString *)conversationId;

@end

@interface PMSupport : NSObject

+ (void)initWithAppID:(NSString *)appId secretKey:(NSString *)secretKey;
+ (void)registerUserWithName:(NSString *)name completion:(void(^)(NSString *userId))completion;
+ (void)loginAgentWithUserId:(NSString *)userId password:(NSString *)password completion:(void (^)(NSString *userId))completion;
+ (void)connect;
+ (void)connectWithCompletion:(void (^)(BOOL connected))callback;
+ (void)disconnect;

// Conversations
+ (void)startConversationWithCompletion:(void (^)(PMConversation *conversation))completion;
+ (void)getAllConversations:(void(^)(NSArray *conversations))completion;

// Handling
+ (void)handleConversation:(NSString *)conversationId;
+ (void)unhandleConversation:(NSString *)conversationId;
+ (void)referHandlerConversation:(NSString *)conversationId refereeUserId:(NSString *)refereeUserId;
+ (void)getHandlersForConversation:(NSString *)conversationId completion:(void  (^)(NSArray *handlers))completion;

// Online
+ (void)pingApp;
+ (void)pingConversation:(NSString *)conversationId;

+ (void)setDelegate:(id<PMSupportDelegate>)delegate;

+ (PMConversation *)agentConversation;


@end
