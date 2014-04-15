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

- (void) hasNewConversation: (NSMutableArray *)chatList;

- (void) hasNewMessage: (NSMutableArray *)chatList conversation: (PMConversation *)conversation;

@end


@protocol PomocHomeDelegate

//future work

//delegate for agent online/ offline
//delegate for user online/ offline

@end

@interface DashBoardSingleton : NSObject

+ (id)singleton;

- (void)loginAgentWithUserId:(NSString *)userId password:(NSString *)password completion:(void (^)(BOOL success))completion;

@property (nonatomic, strong) NSMutableArray *currentConversationList;

@property (nonatomic, assign) id  chatDelegate;
@property (nonatomic, assign) id  homeDelegate;

@end
