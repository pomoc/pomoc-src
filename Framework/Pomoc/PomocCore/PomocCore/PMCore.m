//
//  PomocCore.m
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMCore.h"

#import "SocketIO.h"
#import "SocketIOPacket.h"

#import "PMMessage.h"
#import "PMInternalMessage.h"
#import "PMChatMessage.h"

#define MESSAGE_USER_ID   @"userId"
#define MESSAGE_APP_ID    @"appId"

@interface PMCore () <SocketIODelegate>

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) SocketIO *socket;
@property (nonatomic, weak) id<PMCoreDelegate> delegate;

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

+ (void)initWithAppID:(NSString *)appId userId:(NSString *)userId delegate:(id<PMCoreDelegate>)delegate {
    PMCore *core = [PMCore sharedInstance];
    if (!core.appId) {
        core.appId = appId;
        core.userId = userId;
        core.socket = [[SocketIO alloc] initWithDelegate:core];
        core.delegate = delegate;
        
        [core connect];
    }
}

+ (void)startConversationWithCompletion:(void (^)(NSString *conversationId))completion
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *initMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodeNewConversation];
   
    
    [core sendMessage:initMessage withAcknowledge:^(NSDictionary *jsonResponse) {
        if ([jsonResponse[@"success"] isEqual:@(YES)] && completion) {
            completion(jsonResponse[@"conversationId"]);
        }
    }];
}

+ (void)sendMessage:(NSString *)message conversationId:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];

    PMMessage *chatMessage = [PMMessage chatMessageWithMessage:message conversationId:conversationId];
    
    [core sendMessage:chatMessage withAcknowledge:nil];
}

/*
+ (void)subscibeToChannel:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *pomocMessage = [[PMMessage alloc] initWithUsername:core.userId
                                                      withChannel:conversationId
                                                         withType:MSG_TYPE_SUB
                                                      withMessage:@""];
    
    [core.socket sendJSON:[pomocMessage getJSONObject]];
}
 */

- (void)connect
{
    [self.socket connectToHost:@"localhost" onPort:3217];
    
    // Join global channel for appId
    [self observeNewConversations];
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
        if ([self.delegate respondsToSelector:@selector(didReceiveMessage:conversationId:)]) {
            [self.delegate didReceiveMessage:data[@"message"] conversationId:data[@"conversationId"]];
        }
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    /*
    NSLog(@"didReceiveMessage >>> data: %@", packet.data);
    PMMessage *message = [[PMMessage alloc] initWithJSONString:packet.data];
    
    // Normal chat message
    if ([message.type isEqualToString:MSG_TYPE_CHAT]) {
        if ([self.delegate respondsToSelector:@selector(didReceiveMessage:channelId:)]) {
            [self.delegate didReceiveMessage:message channelId:message.channel];
        }
    } else if ([message.type isEqualToString:MSG_TYPE_NOTIFY]) {
        if ([self.delegate respondsToSelector:@selector(newChannelCreated:)]) {
            [self.delegate newChannelCreated:message.channel];
        }
    }
    */
}

@end
