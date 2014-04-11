//
//  PMSupport.h
//  PomocCore
//
//  Created by soedar on 6/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMConversation;

@protocol PMSupportDelegate <NSObject>

- (void)newConversationCreated:(PMConversation *)conversation;

@end

@interface PMSupport : NSObject

+ (void)initWithAppID:(NSString *)appId secretKey:(NSString *)secretKey;
+ (void)registerUserWithName:(NSString *)name completion:(void(^)(NSString *userId))completion;
+ (void)loginAgentWithUserId:(NSString *)userId password:(NSString *)password completion:(void (^)(NSString *userId))completion;
+ (void)connect;
+ (void)connectWithCallback:(void (^)(BOOL connected))callback;

+ (void)startConversationWithCompletion:(void (^)(PMConversation *conversation))completion;
+ (void)setDelegate:(id<PMSupportDelegate>)delegate;

@end
