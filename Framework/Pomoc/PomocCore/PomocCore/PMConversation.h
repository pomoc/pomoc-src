//
//  PMConversation.h
//  PomocCore
//
//  Created by soedar on 4/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMMessageConstants.h"

@class PMConversation, PMMessage, PMInternalMessage, PMChatMessage, PMImageMessage, PMStatusMessage, PMUser, PMNote;

@protocol PMConversationDelegate <NSObject>

@optional
- (void)conversation:(PMConversation *)conversation didReceiveMessage:(PMMessage *)message;
- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage;
- (void)conversation:(PMConversation *)conversation didReceiveImageMessage:(PMImageMessage *)imageMessage;

- (void)conversation:(PMConversation *)conversation didReceiveStatusMessage:(PMStatusMessage *)statusMessage;

- (void)conversation:(PMConversation *)conversation didReceiveInternalMessage:(PMInternalMessage *)internalMessage;
- (void)conversation:(PMConversation *)conversation didReceiveNote:(PMNote *)notes;

// TODO
- (void)didReceiveHandlerUpdate:(PMConversation *)conversation isReferral:(BOOL)isReferral
                       referrer:(PMUser *)referrer referee:(PMUser *)referee;

//- (void)conversation:

@end

@interface PMConversation : NSObject

@property (nonatomic, strong, readonly) NSString *conversationId;
@property (nonatomic, strong, readonly) PMUser *creator;
@property (nonatomic, strong, readonly) NSDate *createDate;
@property (nonatomic, strong) NSMutableArray *handlers;


@property (nonatomic) BOOL read;

@property (nonatomic, weak) id<PMConversationDelegate> delegate;

- (void)sendTextMessage:(NSString *)message;
- (void)sendNote:(NSString *)note;
- (void)sendImageMessage:(UIImage *)image;

- (void)sendStatusMessage:(PMStatusMessageCode)code;

- (NSArray *)messages;
- (NSArray *)notes;

@end
