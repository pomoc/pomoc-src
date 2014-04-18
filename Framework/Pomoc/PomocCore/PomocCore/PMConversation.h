//
//  PMConversation.h
//  PomocCore
//
//  Created by soedar on 4/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PMConversation, PMMessage, PMInternalMessage, PMChatMessage, PMImageMessage, PMUser;

@protocol PMConversationDelegate <NSObject>

@optional
- (void)conversation:(PMConversation *)conversation didReceiveMessage:(PMMessage *)message;
- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage;
- (void)conversation:(PMConversation *)conversation didReceiveImageMessage:(PMImageMessage *)imageMessage;
- (void)conversation:(PMConversation *)conversation didReceiveInternalMessage:(PMInternalMessage *)internalMessage;

// TODO
- (void)didReceiveHandlerUpdate:(PMConversation *)conversation isReferral:(BOOL)isReferral
                       referrer:(PMUser *)referrer referee:(PMUser *)referee;

@end

@interface PMConversation : NSObject

@property (nonatomic, strong, readonly) NSString *conversationId;
@property (nonatomic, strong, readonly) PMUser *creator;
@property (nonatomic, strong, readonly) NSDate *createDate;

@property (nonatomic, weak) id<PMConversationDelegate> delegate;

- (void)sendTextMessage:(NSString *)message;
- (void)sendImageMessage:(UIImage *)image;
- (NSArray *)messages;

@end
