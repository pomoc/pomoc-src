//
//  PMConversation.h
//  PomocCore
//
//  Created by soedar on 4/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMConversation, PMMessage, PMInternalMessage, PMChatMessage;

@protocol PMConversationDelegate <NSObject>

@optional
- (void)conversation:(PMConversation *)conversation didReceiveMessage:(PMMessage *)message;
- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage;
- (void)conversation:(PMConversation *)conversation didReceiveInternalMessage:(PMInternalMessage *)internalMessage;

@end

@interface PMConversation : NSObject

@property (nonatomic, strong, readonly) NSString *conversationId;

@property (nonatomic, weak) id<PMConversationDelegate> delegate;

- (void)sendTextMessage:(NSString *)message;
- (NSArray *)messages;

@end
