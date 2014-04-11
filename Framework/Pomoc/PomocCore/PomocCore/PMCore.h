//
//  PomocCore.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMCore, PMConversation;

@protocol PMCoreDelegate <NSObject>

- (void)newConversationCreated:(PMConversation *)conversation;
- (void)hasConnected;

@end


@interface PMCore : NSObject

+ (void)initWithAppID:(NSString *)appId;
+ (void)startConversationWithCompletion:(void (^)(PMConversation *conversation))completion;
+ (void)setDelegate:(id<PMCoreDelegate>)delegate;
+ (void)observeNewConversations;
+ (void)connect;

#pragma mark - Temp methods
+ (void)setUserId:(NSString *)userId;

@end
