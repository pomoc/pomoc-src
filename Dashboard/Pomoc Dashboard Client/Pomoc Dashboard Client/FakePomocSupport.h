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

@class FakePomocSupport;

@protocol FakePomocSupportDelegate

// define protocol functions that can be used in any class using this delegate
- (void) chatListOnLoad:(NSArray *) pomocChatList;

- (void) newChat: (PomocChat *) newPomocChat;

- (void) newChatMessage: (PomocChatMessage *) newPomocChatMssage channel: (NSString *) channelId;

- (void) newPictureMessage: (PomocChatMessage *) newPomocChatMssage channel: (NSString *) channelId;




@end

@interface FakePomocSupport : NSObject

@property (nonatomic, assign) id  delegate;

@property (nonatomic, strong) NSMutableArray *chatList;

//init pomoc support with the last date this app pulled from
- (id) initWithLastUpdatedDate: (NSDate *)initWithLastUpdatedDate andAppId: (NSString *) appId;


//simulation
- (void) simulateNewChat;
- (void) simulateChatMessage;
- (void) simulatePictureMessage;

@end
