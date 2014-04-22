//
//  PomocCore.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMCore, PMConversation, PMUser;

@protocol PMCoreDelegate <NSObject>

- (void)newConversationCreated:(PMConversation *)conversation;
- (void)hasConnected;
- (void)hasDisconnected;
// Online status
- (void)updateOnlineUsers:(NSArray *)users;
- (void)updateOnlineUsers:(NSArray *)users conversationId:(NSString *)conversationId;
// Handler status
- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId;
- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId referrer:(PMUser *)referrer referee:(PMUser *)referee;

@end


@interface PMCore : NSObject

+ (void)initWithAppID:(NSString *)appId;
+ (void)startConversationWithCompletion:(void (^)(PMConversation *conversation))completion;
+ (void)getAllConversations:(void(^)(NSArray *conversations))completion;
+ (void)setDelegate:(id<PMCoreDelegate>)delegate;
+ (void)observeNewConversations;
+ (void)connect;
+ (void)disconnect;
+ (void)handleConversation:(NSString *)conversationId;
+ (void)unhandleConversation:(NSString *)conversationId;
+ (void)referHandlerConversation:(NSString *)conversationId refereeUserId:(NSString *)refereeUserId;
+ (void)getHandlersForConversation:(NSString *)conversationId completion:(void (^)(NSArray *handlers))completion;
+ (void)pingApp;
+ (void)pingConversation:(NSString *)conversationId;


#pragma mark - Temp methods
+ (void)setUserId:(NSString *)userId;

@end
