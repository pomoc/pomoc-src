//
//  FakePomocSupport.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatViewController.h"
#import "PomocChat.h"
#import "PomocChatMessage.h"

//Soedar
#import "PomocCore.h"

@class PomocWrapper;

@protocol PomocWrapperDelegate

// define protocol functions that can be used in any class using this delegate
- (void) newChat: (PomocChat *) newPomocChat;

- (void) newChatMessage: (PomocChatMessage *) newPomocChatMssage channel: (NSString *) channelId;

- (void) newPictureMessage: (PomocChatMessage *) newPomocChatMssage channel: (NSString *) channelId;


@end

@interface PomocWrapper : NSObject <PMCoreDelegate>

@property (nonatomic, assign) id  delegate;

@property (nonatomic, strong) NSMutableArray *chatList;

//init pomoc support
- (id) initWithDelegate: (id) delegate;

//simulation
- (void) simulateNewChat;
- (void) simulateChatMessage;
- (void) simulatePictureMessage;

//wrapper of Pomoc Core
- (void)sendMessage:(NSString *)message conversationId:(NSString *)conversationId;

@end
