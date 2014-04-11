//
//  PomocCore.m
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMCore.h"
#import "PMCore_Private.h"

#import "SocketIO.h"
#import "SocketIOPacket.h"

#import "PMMessage.h"
#import "PMInternalMessage.h"
#import "PMChatMessage.h"

#import "PMConversation.h"
#import "PMConversation+PMCore.h"

#define MESSAGE_USER_ID   @"userId"
#define MESSAGE_APP_ID    @"appId"

@interface PMCore () <SocketIODelegate>

@property (nonatomic, strong) NSString *appId;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) SocketIO *socket;
@property (nonatomic, weak) id<PMCoreDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *conversations;

@end

@implementation PMCore

+ (PMCore *)sharedInstance
{
    static PMCore *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)initWithAppID:(NSString *)appId {
    PMCore *core = [PMCore sharedInstance];
    if (!core.appId) {
        core.appId = appId;
        core.socket = [[SocketIO alloc] initWithDelegate:core];
        core.conversations = [NSMutableDictionary dictionary];
    }
}

+ (void)setUserId:(NSString *)userId
{
    [PMCore sharedInstance].userId = userId;
}

+ (void)startConversationWithCompletion:(void (^)(PMConversation *conversation))completion
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *initMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodeNewConversation];
    
    [core sendMessage:initMessage withAcknowledge:^(NSDictionary *jsonResponse) {
        if ([jsonResponse[@"success"] isEqual:@(YES)] && completion) {
            NSString *conversationId = jsonResponse[@"conversationId"];
            PMConversation *conversation = [[PMConversation alloc] initWithConversationId:conversationId];
            
            @synchronized(core.conversations) {
                core.conversations[conversationId] = conversation;
            }
            completion(conversation);
        }
    }];
}

+ (void)sendTextMessage:(NSString *)message conversationId:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *chatMessage = [PMMessage chatMessageWithMessage:message conversationId:conversationId];
    [core sendMessage:chatMessage withAcknowledge:nil];
}

+ (void)joinConversation:(NSString *)conversationId completion:(void (^)(NSArray *messages))completion
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *observeMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodeJoinConversation
                                                    conversationId:conversationId];
    
    [core sendMessage:observeMessage withAcknowledge:^(NSDictionary *jsonResponse) {
        if ([jsonResponse[@"success"] isEqual:@(YES)] && completion) {
            NSMutableArray *messages = [NSMutableArray array];
            for (NSDictionary *jsonMessage in jsonResponse[@"messages"]) {
                // TODO: Generalize this
                if ([jsonMessage[@"class"] isEqualToString:[[PMChatMessage class] description]]) {
                    PMChatMessage *message = [PMMessage chatMessageFromJsonData:jsonMessage];
                    [messages addObject:message];
                }
            }
            
            completion([NSArray arrayWithArray:messages]);
        }
    }];
}

+ (void)setDelegate:(id<PMCoreDelegate>)delegate
{
    [PMCore sharedInstance].delegate = delegate;
}

+ (void)observeNewConversations
{
    [[PMCore sharedInstance] observeNewConversations];
}

+ (void)connect
{
    [[PMCore sharedInstance] connect];
}

- (void)connect
{
    [self.socket connectToHost:@"api.pomoc.im" onPort:3217];
}

- (void)observeNewConversations
{
    PMMessage *observeMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodeObserveConversationList];
    [self sendMessage:observeMessage withAcknowledge:nil];
}

- (void)sendMessage:(PMMessage *)message withAcknowledge:(SocketIOCallback)function
{
    NSDictionary *jsonData = [self jsonDataForMessage:message];
    if ([message isKindOfClass:[PMInternalMessage class]]) {
        [self.socket sendEvent:@"internalMessage" withData:jsonData andAcknowledge:function];
    } else if ([message isKindOfClass:[PMChatMessage class]]) {
        [self.socket sendEvent:@"chatMessage" withData:jsonData andAcknowledge:function];
    }
}

- (NSDictionary *)jsonDataForMessage:(PMMessage *)message
{
    NSMutableDictionary *jsonDict = [[message jsonObject] mutableCopy];
    jsonDict[MESSAGE_APP_ID] = self.appId;
    jsonDict[MESSAGE_USER_ID] = self.userId;
    
    return [NSDictionary dictionaryWithDictionary:jsonDict];
}

#pragma mark - SocketIO Delegate methods

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSDictionary *data = [packet dataAsJSON][@"args"][0];
    
    if ([packet.name isEqualToString:@"chatMessage"]) {
        PMChatMessage *chatMessage = [PMMessage chatMessageFromJsonData:data];
        
        PMConversation *conversation = self.conversations[chatMessage.conversationId];
        if (conversation) {
            [conversation addMessage:chatMessage];
        }
    } else if ([packet.name isEqualToString:@"newConversation"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(newConversationCreated:)]) {
            NSString *conversationId = data[@"conversationId"];
            
            PMConversation *conversation = self.conversations[conversationId];
            if (!conversation) {
                conversation = [[PMConversation alloc] initWithConversationId:conversationId];
                @synchronized(self.conversations) {
                    self.conversations[conversationId] = conversation;
                }
            }
            
            [self.delegate newConversationCreated:conversation];
        }
    }
}

- (void)socketIODidConnect:(SocketIO *)socket
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasConnected)]) {
        [self.delegate hasConnected];
    }
}

@end
