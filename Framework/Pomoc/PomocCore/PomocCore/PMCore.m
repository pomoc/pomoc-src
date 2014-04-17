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
#import "PMApplicationMessage.h"
#import "PMChatMessage.h"
#import "PMImageMessage.h"
#import "PomocImage.h"

#import "PMConversation.h"
#import "PMConversation+PMCore.h"

#import "PMUserManager.h"

#import "PomocConstants.h"

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

+ (void)sendImageMessage:(UIImage *)image conversationId:(NSString *)conversationId
{
    [[PomocImage sharedInstance] uploadImage:image withCompletion:^(NSString *imageId) {
        PMImageMessage *imageMessage = [PMMessage imageMessageWithId:imageId conversationId:conversationId];
        PMCore *core = [PMCore sharedInstance];
        [core sendMessage:imageMessage withAcknowledge:nil];
    }];
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
                if ([jsonMessage[@"class"] isEqualToString:[[PMChatMessage class] description]] ||
                    [jsonMessage[@"class"] isEqualToString:[[PMImageMessage class] description]]) {
                    PMChatMessage *message = [PMMessage chatMessageFromJsonData:jsonMessage];
                    [messages addObject:message];
                }
            }
            
            completion([NSArray arrayWithArray:messages]);
            
            // Announce online status
            // Request for list of handlers
        }
    }];
}

+ (void)getAllConversations:(void(^)(NSArray *conversations))completion
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *allConversationMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodeGetAppConversationList];
    
    [core sendMessage:allConversationMessage withAcknowledge:^(NSDictionary *jsonResponse) {
        if ([jsonResponse[@"success"] isEqual:@(YES)] && completion) {
            
            NSArray *conversationIds = jsonResponse[@"conversationIds"];
            NSMutableArray *conversations = [NSMutableArray array];
            for (NSString *conversationId in conversationIds) {
                [conversations addObject:[[PMConversation alloc] initWithConversationId:conversationId]];
            }
            
            [PMCore joinAllConversations:[conversations copy] completion:completion];
        }
    }];
}

+ (void)joinAllConversations:(NSArray *)conversations completion:(void(^)(NSArray *conversations))completion
{
    [PMCore joinConversationsInQueue:[conversations mutableCopy] done:[NSMutableArray array] completion:completion];
}

+ (void)joinConversationsInQueue:(NSMutableArray *)queue
                            done:(NSMutableArray *)done
                      completion:(void(^)(NSArray *conversations))completion
{
    if ([queue count] == 0) {
        completion([done copy]);
        return;
    }
    
    PMConversation *conversation = queue[0];
    
    [conversation joinConversationWithCompletion:^(BOOL success) {
        [queue removeObjectAtIndex:0];
        if (success) {
            [done addObject:conversation];
            @synchronized([PMCore sharedInstance].conversations) {
                [PMCore sharedInstance].conversations[conversation.conversationId] = conversation;
            }
        }
        [PMCore joinConversationsInQueue:queue done:done completion:completion];
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

+ (void)handleConversation:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *handleMessage = [PMMessage applicationMessageWithCode:PMApplicationMessageCodeHandle conversationId:conversationId];
    [core sendMessage:handleMessage withAcknowledge:nil];
}

+ (void)unhandleConversation:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *unhandleMessage = [PMMessage applicationMessageWithCode:PMApplicationMessageCodeUnhandle conversationId:conversationId];
    [core sendMessage:unhandleMessage withAcknowledge:nil];
}

+ (void)referHandlerConversation:(NSString *)conversationId refereeUserId:(NSString *)refereeUserId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *referHandlerMessage = [PMMessage applicationMessageWithCode:PMApplicationMessageCodeReferHandler conversationId:conversationId refereeUserId:refereeUserId];
    [core sendMessage:referHandlerMessage withAcknowledge:nil];
}

+ (void)getHandlersForConversation:(NSString *)conversationId completion:(void(^)(NSArray *conversations))completion
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *getHandlersMessage = [PMMessage applicationMessageWithCode:PMApplicationMessageCodeGetHandlers conversationId:conversationId];
    [core sendMessage:getHandlersMessage withAcknowledge:^(NSDictionary *jsonResponse) {
        if ([jsonResponse[@"success"] isEqual:@(YES)] && completion) {
            NSArray *handlers = [PMUserManager getUserObjectsFromUserIds:jsonResponse[@"handlers"]];
            completion(handlers);
        }
    }];
}

+ (void)pingApp
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *onlineAppUsersMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodePingApp];
    [core sendMessage:onlineAppUsersMessage withAcknowledge:nil];
}

+ (void)pingConversation:(NSString *)conversationId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *onlineConversationUsersMessage = [PMMessage internalMessageWithCode:PMInternalMessageCodePingConversation conversationId:conversationId];
    [core sendMessage:onlineConversationUsersMessage withAcknowledge:nil];
}

- (void)connect
{
    [self.socket connectToHost:POMOC_URL onPort:POMOC_PORT];
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
    } else if ([message isKindOfClass:[PMImageMessage class]]) {
        [self.socket sendEvent:@"chatMessage" withData:jsonData andAcknowledge:function];
    } else if ([message isKindOfClass:[PMApplicationMessage class]]) {
        [self.socket sendEvent:@"applicationMessage" withData:jsonData andAcknowledge:function];
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
    }
    else if ([packet.name isEqualToString:@"newConversation"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(newConversationCreated:)]) {
            NSString *conversationId = data[@"conversationId"];
            
            PMConversation *conversation = self.conversations[conversationId];
            if (!conversation) {
                conversation = [[PMConversation alloc] initWithConversationId:conversationId];
                @synchronized(self.conversations) {
                    self.conversations[conversationId] = conversation;
                }
            }
            
            [conversation joinConversationWithCompletion:^(BOOL success) {
                if (success) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(newConversationCreated:)]) {
                        [self.delegate newConversationCreated:conversation];
                    }
                }
            }];
        }
    }
    else if ([packet.name isEqualToString:@"onlineStatus"]) {
        NSArray *users = [PMUserManager getUserObjectsFromUserIds:packet.dataAsJSON[@"users"]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateOnlineUsers:)]) {
            if ([packet.dataAsJSON[@"type"] isEqualToString:@"conversation"]) {
                [self.delegate updateOnlineUsers:users conversationId:packet.dataAsJSON[@"conversationId"]];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateOnlineUsers:conversationId:)]) {
            if ([packet.dataAsJSON[@"type"] isEqualToString:@"app"]) {
                [self.delegate updateOnlineUsers:users];
            }
        }
    }
    else if ([packet.name isEqualToString:@"handlerStatus"]) {
        NSArray *handlers = [PMUserManager getUserObjectsFromUserIds:packet.dataAsJSON[@"users"]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateHandlers:conversationId:referrer:referee:)]) {
            if ([packet.dataAsJSON[@"type"] isEqualToString:@"handlers"]) {
                [self.delegate updateHandlers:handlers
                               conversationId:packet.dataAsJSON[@"conversationId"]
                                     referrer:nil
                                      referee:nil];
            }
            else if ([packet.dataAsJSON[@"type"] isEqualToString:@"referral"]) {
                PMUser *referrer = [PMUserManager getUserObjectFromUserId:packet.dataAsJSON[@"referrerUserId"]];
                PMUser *referee = [PMUserManager getUserObjectFromUserId:packet.dataAsJSON[@"refereeUserId"]];
                
                [self.delegate updateHandlers:handlers
                               conversationId:packet.dataAsJSON[@"conversationId"]
                                     referrer:referrer
                                      referee:referee];
            }
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
