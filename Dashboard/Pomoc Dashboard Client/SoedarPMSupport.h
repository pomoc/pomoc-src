//
//  SoedarPMSupport.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 29/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

// Soedar, I'm going to put possible delegates and method that might be needed here

// Assumption: I do not call PMCore anymore but I only call PMSupport

#import <Foundation/Foundation.h>
#import "PMCoreDelegate.h"

@interface SoedarPMSupport : NSObject

+ (void)initWithAppID:(NSString *)appId userId:(NSString *)userId delegate:(id<PMCoreDelegate>)delegate;

+ (void)startConversationWithCompletion:(void (^)(NSString *conversationId))completion;

+ (void)joinConversation:(NSString *)conversationId completion:(void (^)(NSArray *messages))completion;

//sending of messages
+ (void)sendChatMessage:(NSString *)message conversationId:(NSString *)conversationId;

//might be UIImage, ref: http://www.michaelroling.com/post/upload-an-image-using-objective-c
+ (void)sendPictureMessage:(UIImage *)image conversationId:(NSString *)conversationId;

//Use case for agent marking that 'I'm handling this conversation' and 'I'm not handling this conv'
//This also should allow server to keep track of how many agents are handling a case
+ (void)handleConversation: (NSString *)conversationId;
+ (void)unHandleConversation: (NSString *)conversationId;

//get all carousell users that are online currently
+ (void)getUsersOnline:(void (^)(NSArray *usersOnline))completion;
+ (void)getAgentsOnline:(void (^)(NSArray *usersOnline))completion;

//MAYBE FUTURE WORKS NEED TO DECIDE AGAIN
+ (void)getPastChatOfUser:(NSString *)userId completion:(void (^)(NSArray *messages))completion;
+ (void)getInfoOfUser:(NSString *)userId completion:(void (^)(NSObject *user))completion;


@end


@protocol PMSupportDelegate <NSObject>

//when an agent handle or unhandle a conversation, not sure if have agentId. this mean that when maybe we do initPMCore, need to maybe somehow pass in agentId
- (void)agentHandledConversation:(NSString *)conversationId agentId:(NSString *)agentId;
- (void)agentUnhandledConversation:(NSString *)conversationId agentId:(NSString *)agentId;

//when a new chat message was recieved
- (void)didReceiveChatTextMessage:(PMMessage *)pomocMessage conversationId:(NSString *)conversationId;

//when a new picture message was recieved
- (void)didReceiveChatPictureMessage:(PMMessage *)pomocMessage conversationId:(NSString *)conversationId;

//when new conversation created
- (void)newConversationCreated:(NSString *)conversationId;

//when new visitor is online, not sure what other attribtues of visitor, or perhaps when an object
//online = on the Carrousell app
//offline = closed the Carousell app
- (void)newUserOnline:(NSString *)customerName;
- (void)userOffline:(NSString *)customerName;



@end